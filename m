Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab2BICwp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:52:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49693 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab2BICwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:52:44 -0500
Message-ID: <4F3334F7.70809@gmail.com>
Date: Wed, 08 Feb 2012 19:52:39 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in record,
 stat, top
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <4F331F14.5070100@gmail.com>
In-Reply-To: <4F331F14.5070100@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/08/2012 06:19 PM, Namhyung Kim wrote:
>> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
>> index 3d4b6c5..e793c16 100644
>> --- a/tools/perf/util/thread_map.c
>> +++ b/tools/perf/util/thread_map.c
>> @@ -6,7 +6,10 @@
>>  #include <sys/types.h>
>>  #include <sys/stat.h>
>>  #include <unistd.h>
>> +#include <ctype.h>
> 
> I was trying to remove ctype.h, you might use util.h here.

Right, knew that. But, in this case I am adding a call to isdigit which
means a direct dependency on ctype.h. I would prefer a direct
relationship versus an indirect via util.h

> 
> 
>> +#include <string.h>
>>  #include "thread_map.h"
>> +#include "debug.h"
>>
>>   /* Skip "." and ".." directories */
>>   static int filter(const struct dirent *dir)
>> @@ -152,6 +155,155 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
>>   	return thread_map__new_by_tid(tid);
>>   }
>>
>> +
>> +static pid_t get_next_task_id(char **str)
>> +{
>> +	char *p, *pend;
>> +	pid_t ret = -1;
>> +	bool adv_pend = false;
>> +
>> +	pend = p = *str;
>> +
>> +	/* empty strings */
>> +	if (*pend == '\0')
>> +		return -1;
>> +
>> +	/* only expecting digits separated by commas */
>> +	while (isdigit(*pend))
>> +		++pend;
>> +
>> +	if (*pend == ',') {
>> +		*pend = '\0';
>> +		adv_pend = true;
>> +		/* catch strings ending in a comma - like '1234,' */
>> +		if (*(pend+1) == '\0') {
>> +			ui__error("task id strings should not end in a comma\n");
>> +			goto out;
>> +		}
>> +	}
>> +
>> +	/* only convert if all characters are valid */
>> +	if (*pend == '\0') {
>> +		ret = atoi(p);
>> +		if (adv_pend)
>> +			pend++;
>> +		*str = pend;
>> +	}
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>> +{
>> +	struct thread_map *threads = NULL;
>> +	char name[256];
>> +	int items, total_tasks = 0;
>> +	struct dirent **namelist = NULL;
>> +	int i, j = 0;
>> +	char *ostr, *str;
>> +	pid_t pid;
>> +
>> +	ostr = strdup(pid_str);
>> +	if (!ostr)
>> +		return NULL;
>> +	str = ostr;
>> +
>> +	while (*str) {
>> +		pid = get_next_task_id(&str);
>> +		if (pid<  0) {
>> +			free(threads);
>> +			threads = NULL;
>> +			break;
>> +		}
>> +
>> +		sprintf(name, "/proc/%d/task", pid);
>> +		items = scandir(name,&namelist, filter, NULL);
>> +		if (items<= 0)
>> +			break;
>> +
>> +		total_tasks += items;
>> +		if (threads)
>> +			threads = realloc(threads,
>> +					  sizeof(*threads) + sizeof(pid_t)*total_tasks);
>> +		else
>> +			threads = malloc(sizeof(*threads) + sizeof(pid_t)*items);
>> +
>> +		if (threads) {
>> +			for (i = 0; i<  items; i++)
>> +				threads->map[j++] = atoi(namelist[i]->d_name);
>> +			threads->nr = total_tasks;
>> +		}
>> +
>> +		for (i = 0; i<  items; i++)
>> +			free(namelist[i]);
>> +		free(namelist);
>> +
>> +		if (!threads)
>> +			break;
>> +	}
>> +
>> +	free(ostr);
>> +
>> +	return threads;
>> +}
>> +
>> +static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
>> +{
>> +	struct thread_map *threads = NULL;
>> +	char *str;
>> +	int ntasks = 0;
>> +	pid_t tid;
>> +
>> +	/* perf-stat expects threads to be generated even if tid not given */
>> +	if (!tid_str) {
>> +		threads = malloc(sizeof(*threads) + sizeof(pid_t));
>> +		threads->map[1] = -1;
>> +		threads->nr	= 1;
>> +		return threads;
>> +	}
>> +
>> +	str = strdup(tid_str);
>> +	if (!str)
>> +		return NULL;
>> +
>> +	while (*str) {
>> +		tid = get_next_task_id(&str);
>> +		if (tid < 0) {
>> +			free(threads);
>> +			threads = NULL;
>> +			break;
>> +		}
>> +
>> +		ntasks++;
>> +		if (threads)
>> +			threads = realloc(threads,
>> +					  sizeof(*threads) + sizeof(pid_t) * ntasks);
>> +		else
>> +			threads = malloc(sizeof(*threads) + sizeof(pid_t));
>> +
>> +		if (threads == NULL)
>> +			break;
>> +
>> +		threads->map[ntasks-1] = tid;
>> +		threads->nr	= ntasks;
>> +	}
>> +
>> +	return threads;
>> +}
>> +
> 
> This will ends up being a code duplication. How about something like below?
> 
> 	while (*str) {
> 		tid = get_next_task_id(&str);
> 		if (tid < 0)
> 			goto out_err;
> 
> 		tmp = thread_map__new_by_tid(tid); /* and for pid too */
> 		if (tmp == NULL)
> 			goto out_err;
> 			
> 		threads = thread_map__merge(threads, tmp); /* should be implemented */
> 		if (threads == NULL)
> 			break;
> 	}
> 

The pid and tid functions are implemented differently. The commonality
is parsing a CSV string in a while loop.

> 
>> +struct thread_map *thread_map__new_str(const char *pid, const char *tid,
>> +				       uid_t uid)
>> +{
>> +	if (pid)
>> +		return thread_map__new_by_pid_str(pid);
>> +
>> +	if (!tid&&  uid != UINT_MAX)
>> +		return thread_map__new_by_uid(uid);
>> +
>> +	return thread_map__new_by_tid_str(tid);
>> +}
>> +
>>   void thread_map__delete(struct thread_map *threads)
>>   {
>>   	free(threads);
> [snip]
>> diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
>> index d0c0139..1240bd6 100644
>> --- a/tools/perf/util/usage.c
>> +++ b/tools/perf/util/usage.c
>> @@ -83,7 +83,7 @@ void warning(const char *warn, ...)
>>   	va_end(params);
>>   }
>>
>> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>> +uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
>>   {
>>   	struct passwd pwd, *result;
>>   	char buf[1024];
>> @@ -91,8 +91,8 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>>   	if (str == NULL)
>>   		return UINT_MAX;
>>
>> -	/* CPU and PID are mutually exclusive */
>> -	if (tid > 0 || pid > 0) {
>> +	/* UUID and PID are mutually exclusive */
> 
> s/UUID/UID/ ?

Yes. I was trying to fix the CPU typo when the function was created.
Will remove the extra 'U'.

David

