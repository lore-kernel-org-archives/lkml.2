Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab2BIFgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 00:36:52 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64480 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2BIFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 00:36:51 -0500
X-AuditID: 9c930197-b7cdbae000001518-0e-4f335b6f596d
Message-ID: <4F335B69.8060701@gmail.com>
Date: Thu, 09 Feb 2012 14:36:41 +0900
From: Namhyung Kim <namhyung@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: David Ahern <dsahern@gmail.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@elte.hu,
        peterz@infradead.org, fweisbec@gmail.com, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH] perf tools: Allow multiple threads or processes in record,
 stat, top
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com> <4F331F14.5070100@gmail.com> <4F3334F7.70809@gmail.com>
In-Reply-To: <4F3334F7.70809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-02-09 11:52 AM, David Ahern wrote:
> On 02/08/2012 06:19 PM, Namhyung Kim wrote:
>>> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
>>> index 3d4b6c5..e793c16 100644
>>> --- a/tools/perf/util/thread_map.c
>>> +++ b/tools/perf/util/thread_map.c
>>> @@ -6,7 +6,10 @@
>>>   #include<sys/types.h>
>>>   #include<sys/stat.h>
>>>   #include<unistd.h>
>>> +#include<ctype.h>
>>
>> I was trying to remove ctype.h, you might use util.h here.
> 
> Right, knew that. But, in this case I am adding a call to isdigit which
> means a direct dependency on ctype.h. I would prefer a direct
> relationship versus an indirect via util.h
> 

OK, not a big deal.


>>
>>
>>> +#include<string.h>
>>>   #include "thread_map.h"
>>> +#include "debug.h"
>>>
>>>    /* Skip "." and ".." directories */
>>>    static int filter(const struct dirent *dir)
>>> @@ -152,6 +155,155 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
>>>    	return thread_map__new_by_tid(tid);
>>>    }
>>>
>>> +
>>> +static pid_t get_next_task_id(char **str)
>>> +{
>>> +	char *p, *pend;
>>> +	pid_t ret = -1;
>>> +	bool adv_pend = false;
>>> +
>>> +	pend = p = *str;
>>> +
>>> +	/* empty strings */
>>> +	if (*pend == '\0')
>>> +		return -1;
>>> +
>>> +	/* only expecting digits separated by commas */
>>> +	while (isdigit(*pend))
>>> +		++pend;
>>> +
>>> +	if (*pend == ',') {
>>> +		*pend = '\0';
>>> +		adv_pend = true;
>>> +		/* catch strings ending in a comma - like '1234,' */
>>> +		if (*(pend+1) == '\0') {
>>> +			ui__error("task id strings should not end in a comma\n");
>>> +			goto out;
>>> +		}
>>> +	}
>>> +
>>> +	/* only convert if all characters are valid */
>>> +	if (*pend == '\0') {
>>> +		ret = atoi(p);
>>> +		if (adv_pend)
>>> +			pend++;
>>> +		*str = pend;
>>> +	}
>>> +
>>> +out:
>>> +	return ret;
>>> +}
>>> +
>>> +static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
>>> +{
>>> +	struct thread_map *threads = NULL;
>>> +	char name[256];
>>> +	int items, total_tasks = 0;
>>> +	struct dirent **namelist = NULL;
>>> +	int i, j = 0;
>>> +	char *ostr, *str;
>>> +	pid_t pid;
>>> +
>>> +	ostr = strdup(pid_str);
>>> +	if (!ostr)
>>> +		return NULL;
>>> +	str = ostr;
>>> +
>>> +	while (*str) {
>>> +		pid = get_next_task_id(&str);
>>> +		if (pid<   0) {
>>> +			free(threads);
>>> +			threads = NULL;
>>> +			break;
>>> +		}
>>> +
>>> +		sprintf(name, "/proc/%d/task", pid);
>>> +		items = scandir(name,&namelist, filter, NULL);
>>> +		if (items<= 0)
>>> +			break;
>>> +
>>> +		total_tasks += items;
>>> +		if (threads)
>>> +			threads = realloc(threads,
>>> +					  sizeof(*threads) + sizeof(pid_t)*total_tasks);
>>> +		else
>>> +			threads = malloc(sizeof(*threads) + sizeof(pid_t)*items);
>>> +
>>> +		if (threads) {
>>> +			for (i = 0; i<   items; i++)
>>> +				threads->map[j++] = atoi(namelist[i]->d_name);
>>> +			threads->nr = total_tasks;
>>> +		}
>>> +
>>> +		for (i = 0; i<   items; i++)
>>> +			free(namelist[i]);
>>> +		free(namelist);
>>> +
>>> +		if (!threads)
>>> +			break;
>>> +	}
>>> +
>>> +	free(ostr);
>>> +
>>> +	return threads;
>>> +}
>>> +
>>> +static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
>>> +{
>>> +	struct thread_map *threads = NULL;
>>> +	char *str;
>>> +	int ntasks = 0;
>>> +	pid_t tid;
>>> +
>>> +	/* perf-stat expects threads to be generated even if tid not given */
>>> +	if (!tid_str) {
>>> +		threads = malloc(sizeof(*threads) + sizeof(pid_t));
>>> +		threads->map[1] = -1;
>>> +		threads->nr	= 1;
>>> +		return threads;
>>> +	}
>>> +
>>> +	str = strdup(tid_str);
>>> +	if (!str)
>>> +		return NULL;
>>> +
>>> +	while (*str) {
>>> +		tid = get_next_task_id(&str);
>>> +		if (tid<  0) {
>>> +			free(threads);
>>> +			threads = NULL;
>>> +			break;
>>> +		}
>>> +
>>> +		ntasks++;
>>> +		if (threads)
>>> +			threads = realloc(threads,
>>> +					  sizeof(*threads) + sizeof(pid_t) * ntasks);
>>> +		else
>>> +			threads = malloc(sizeof(*threads) + sizeof(pid_t));
>>> +
>>> +		if (threads == NULL)
>>> +			break;
>>> +
>>> +		threads->map[ntasks-1] = tid;
>>> +		threads->nr	= ntasks;
>>> +	}
>>> +
>>> +	return threads;
>>> +}
>>> +
>>
>> This will ends up being a code duplication. How about something like below?
>>
>> 	while (*str) {
>> 		tid = get_next_task_id(&str);
>> 		if (tid<  0)
>> 			goto out_err;
>>
>> 		tmp = thread_map__new_by_tid(tid); /* and for pid too */
>> 		if (tmp == NULL)
>> 			goto out_err;
>> 			
>> 		threads = thread_map__merge(threads, tmp); /* should be implemented */
>> 		if (threads == NULL)
>> 			break;
>> 	}
>>
> 
> The pid and tid functions are implemented differently. The commonality
> is parsing a CSV string in a while loop.
> 

Oh, I meant this:

static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
{
	...
	while (*str) {
		...
		tmp = thread_map__new_by_pid(pid);
		...
	}
	...
}

static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
{
	...
	while (*str) {
		...
		tmp = thread_map__new_by_tid(tid);
		...
	}
	...
}


Thanks,
Namhyung

