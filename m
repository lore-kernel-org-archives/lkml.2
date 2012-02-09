Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2BIBTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:19:25 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52422 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2BIBTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:19:23 -0500
X-AuditID: 9c930179-b7cf1ae000000e40-11-4f331f178da9
Message-ID: <4F331F14.5070100@gmail.com>
Date: Thu, 09 Feb 2012 10:19:16 +0900
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
References: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1328718772-16688-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2012-02-09 1:32 AM, David Ahern wrote:
> Allow a user to collect events for multiple threads or processes
> using a comma separated list.
> 
> e.g., collect data on a VM and its vhost thread:
>    perf top -p 21483,21485
>    perf stat -p 21483,21485 -ddd
>    perf record -p 21483,21485
> 
> or monitoring vcpu threads
>    perf top -t 21488,21489
>    perf stat -t 21488,21489 -ddd
>    perf record -t 21488,21489
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Nice work, thanks. Some minor nits below..


> ---
>   tools/perf/Documentation/perf-record.txt |    4 +-
>   tools/perf/Documentation/perf-stat.txt   |    4 +-
>   tools/perf/Documentation/perf-top.txt    |    4 +-
>   tools/perf/builtin-record.c              |   10 +-
>   tools/perf/builtin-stat.c                |   31 +++---
>   tools/perf/builtin-test.c                |    2 -
>   tools/perf/builtin-top.c                 |   12 +--
>   tools/perf/perf.h                        |    4 +-
>   tools/perf/util/evlist.c                 |   10 +-
>   tools/perf/util/evlist.h                 |    4 +-
>   tools/perf/util/evsel.c                  |    2 +-
>   tools/perf/util/thread_map.c             |  152 ++++++++++++++++++++++++++++++
>   tools/perf/util/thread_map.h             |    4 +
>   tools/perf/util/top.c                    |   10 +-
>   tools/perf/util/top.h                    |    2 +-
>   tools/perf/util/usage.c                  |    6 +-
>   tools/perf/util/util.h                   |    2 +-
>   17 files changed, 207 insertions(+), 56 deletions(-)
> 
[snip]
> diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
> index 3d4b6c5..e793c16 100644
> --- a/tools/perf/util/thread_map.c
> +++ b/tools/perf/util/thread_map.c
> @@ -6,7 +6,10 @@
>  #include <sys/types.h>
>  #include <sys/stat.h>
>  #include <unistd.h>
> +#include <ctype.h>

I was trying to remove ctype.h, you might use util.h here.


> +#include <string.h>
>  #include "thread_map.h"
> +#include "debug.h"
> 
>   /* Skip "." and ".." directories */
>   static int filter(const struct dirent *dir)
> @@ -152,6 +155,155 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
>   	return thread_map__new_by_tid(tid);
>   }
> 
> +
> +static pid_t get_next_task_id(char **str)
> +{
> +	char *p, *pend;
> +	pid_t ret = -1;
> +	bool adv_pend = false;
> +
> +	pend = p = *str;
> +
> +	/* empty strings */
> +	if (*pend == '\0')
> +		return -1;
> +
> +	/* only expecting digits separated by commas */
> +	while (isdigit(*pend))
> +		++pend;
> +
> +	if (*pend == ',') {
> +		*pend = '\0';
> +		adv_pend = true;
> +		/* catch strings ending in a comma - like '1234,' */
> +		if (*(pend+1) == '\0') {
> +			ui__error("task id strings should not end in a comma\n");
> +			goto out;
> +		}
> +	}
> +
> +	/* only convert if all characters are valid */
> +	if (*pend == '\0') {
> +		ret = atoi(p);
> +		if (adv_pend)
> +			pend++;
> +		*str = pend;
> +	}
> +
> +out:
> +	return ret;
> +}
> +
> +static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
> +{
> +	struct thread_map *threads = NULL;
> +	char name[256];
> +	int items, total_tasks = 0;
> +	struct dirent **namelist = NULL;
> +	int i, j = 0;
> +	char *ostr, *str;
> +	pid_t pid;
> +
> +	ostr = strdup(pid_str);
> +	if (!ostr)
> +		return NULL;
> +	str = ostr;
> +
> +	while (*str) {
> +		pid = get_next_task_id(&str);
> +		if (pid<  0) {
> +			free(threads);
> +			threads = NULL;
> +			break;
> +		}
> +
> +		sprintf(name, "/proc/%d/task", pid);
> +		items = scandir(name,&namelist, filter, NULL);
> +		if (items<= 0)
> +			break;
> +
> +		total_tasks += items;
> +		if (threads)
> +			threads = realloc(threads,
> +					  sizeof(*threads) + sizeof(pid_t)*total_tasks);
> +		else
> +			threads = malloc(sizeof(*threads) + sizeof(pid_t)*items);
> +
> +		if (threads) {
> +			for (i = 0; i<  items; i++)
> +				threads->map[j++] = atoi(namelist[i]->d_name);
> +			threads->nr = total_tasks;
> +		}
> +
> +		for (i = 0; i<  items; i++)
> +			free(namelist[i]);
> +		free(namelist);
> +
> +		if (!threads)
> +			break;
> +	}
> +
> +	free(ostr);
> +
> +	return threads;
> +}
> +
> +static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
> +{
> +	struct thread_map *threads = NULL;
> +	char *str;
> +	int ntasks = 0;
> +	pid_t tid;
> +
> +	/* perf-stat expects threads to be generated even if tid not given */
> +	if (!tid_str) {
> +		threads = malloc(sizeof(*threads) + sizeof(pid_t));
> +		threads->map[1] = -1;
> +		threads->nr	= 1;
> +		return threads;
> +	}
> +
> +	str = strdup(tid_str);
> +	if (!str)
> +		return NULL;
> +
> +	while (*str) {
> +		tid = get_next_task_id(&str);
> +		if (tid < 0) {
> +			free(threads);
> +			threads = NULL;
> +			break;
> +		}
> +
> +		ntasks++;
> +		if (threads)
> +			threads = realloc(threads,
> +					  sizeof(*threads) + sizeof(pid_t) * ntasks);
> +		else
> +			threads = malloc(sizeof(*threads) + sizeof(pid_t));
> +
> +		if (threads == NULL)
> +			break;
> +
> +		threads->map[ntasks-1] = tid;
> +		threads->nr	= ntasks;
> +	}
> +
> +	return threads;
> +}
> +

This will ends up being a code duplication. How about something like below?

	while (*str) {
		tid = get_next_task_id(&str);
		if (tid < 0)
			goto out_err;

		tmp = thread_map__new_by_tid(tid); /* and for pid too */
		if (tmp == NULL)
			goto out_err;
			
		threads = thread_map__merge(threads, tmp); /* should be implemented */
		if (threads == NULL)
			break;
	}


> +struct thread_map *thread_map__new_str(const char *pid, const char *tid,
> +				       uid_t uid)
> +{
> +	if (pid)
> +		return thread_map__new_by_pid_str(pid);
> +
> +	if (!tid&&  uid != UINT_MAX)
> +		return thread_map__new_by_uid(uid);
> +
> +	return thread_map__new_by_tid_str(tid);
> +}
> +
>   void thread_map__delete(struct thread_map *threads)
>   {
>   	free(threads);
[snip]
> diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
> index d0c0139..1240bd6 100644
> --- a/tools/perf/util/usage.c
> +++ b/tools/perf/util/usage.c
> @@ -83,7 +83,7 @@ void warning(const char *warn, ...)
>   	va_end(params);
>   }
> 
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
> +uid_t parse_target_uid(const char *str, const char *tid, const char *pid)
>   {
>   	struct passwd pwd, *result;
>   	char buf[1024];
> @@ -91,8 +91,8 @@ uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid)
>   	if (str == NULL)
>   		return UINT_MAX;
> 
> -	/* CPU and PID are mutually exclusive */
> -	if (tid > 0 || pid > 0) {
> +	/* UUID and PID are mutually exclusive */

s/UUID/UID/ ?

Thanks.
Namhyung


> +	if (tid || pid) {
>   		ui__warning("PID/TID switch overriding UID\n");
>   		sleep(1);
>   		return UINT_MAX;
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 232d17e..7917b09 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -245,7 +245,7 @@ struct perf_event_attr;
> 
>   void event_attr_init(struct perf_event_attr *attr);
> 
> -uid_t parse_target_uid(const char *str, pid_t tid, pid_t pid);
> +uid_t parse_target_uid(const char *str, const char *tid, const char *pid);
> 
>   #define _STR(x) #x
>   #define STR(x) _STR(x)

