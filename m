Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1LIRI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:08:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62354 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab1LIRIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:08:24 -0500
Message-ID: <4EE24083.7020305@gmail.com>
Date: Fri, 09 Dec 2011 10:08:19 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf: fix comm for processes with named threads
References: <1323446430-1955-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1323446430-1955-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disregard. Need to update to your latest core branch.


On 12/09/2011 09:00 AM, David Ahern wrote:
> perf does not properly handle monitoring of processes with named threads.
> For example:
> 
> $ ps -C myapp -L
>   PID   LWP TTY          TIME CMD
> 25118 25118 ?        00:00:00 myapp
> 25118 25119 ?        00:00:00 myapp:worker
> 
> perf record -e cs -c 1 -fo /tmp/perf.data -p 25118 -- sleep 10
> perf report --stdio -i /tmp/perf.data
>    100.00%  myapp:worker  [kernel.kallsyms]  [k] perf_event_task_sched_out
> 
> The process name is set to the name of the last thread it finds for the
> process.
> 
> The Problem:
> perf-top and perf-record both create a thread_map of threads to be
> monitored. That map is used in perf_event__synthesize_thread_map which
> loops over the entries in thread_map and calls __event__synthesize_thread
> to generate COMM and MMAP events.
> 
> __event__synthesize_thread calls perf_event__synthesize_comm which opens
> /proc/pid/status, reads the name of the task and its thread group id.
> That's all fine. The problem is that it then reads /proc/pid/task and
> generates COMM events for each task it finds - but using the name found
> in /proc/pid/status where pid is the thread of interest. This means the
> name of the last thread processed sets the name for all threads in the
> process - which is not good for multithreaded processes with named
> threads.
> 
> The Fix:
> perf_event__synthesize_comm has an input argument (full) that decides
> whether to process task entries for each pid it is passed. It currently
> never set to 0 (perf_event__synthesize_comm has a single caller and it
> always passes the value 1). Let's fix that.
> 
> Add the full input argument to __event__synthesize_thread which passes
> it to perf_event__synthesize_comm. For thread/process monitoring set full
> to 0 which means COMM and MMAP events are only generated for the pid
> passed to it. For system wide monitoring set full to 1 so that COMM events
> are generated for all threads in a process.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  tools/perf/util/event.c |   35 ++++++++++++++++++++++++++++++-----
>  1 files changed, 30 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 437f8ca..6085727 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -260,10 +260,10 @@ int perf_event__synthesize_modules(perf_event__handler_t process,
>  
>  static int __event__synthesize_thread(union perf_event *comm_event,
>  				      union perf_event *mmap_event,
> -				      pid_t pid, perf_event__handler_t process,
> +				      pid_t pid, int full, perf_event__handler_t process,
>  				      struct perf_session *session)
>  {
> -	pid_t tgid = perf_event__synthesize_comm(comm_event, pid, 1, process,
> +	pid_t tgid = perf_event__synthesize_comm(comm_event, pid, full, process,
>  					    session);
>  	if (tgid == -1)
>  		return -1;
> @@ -276,7 +276,7 @@ int perf_event__synthesize_thread_map(struct thread_map *threads,
>  				      struct perf_session *session)
>  {
>  	union perf_event *comm_event, *mmap_event;
> -	int err = -1, thread;
> +	int err = -1, thread, j;
>  
>  	comm_event = malloc(sizeof(comm_event->comm) + session->id_hdr_size);
>  	if (comm_event == NULL)
> @@ -289,11 +289,36 @@ int perf_event__synthesize_thread_map(struct thread_map *threads,
>  	err = 0;
>  	for (thread = 0; thread < threads->nr; ++thread) {
>  		if (__event__synthesize_thread(comm_event, mmap_event,
> -					       threads->map[thread],
> +					       threads->map[thread], 0,
>  					       process, session)) {
>  			err = -1;
>  			break;
>  		}
> +
> +		/* 
> +		 * comm.pid is set to thread group id by
> +		 * perf_event__synthesize_comm
> +		 */
> +		if ((int) comm_event->comm.pid != threads->map[thread]) {
> +			bool need_leader = true;
> +
> +			/* is thread group leader in thread_map? */
> +			for (j = 0; j < threads->nr; ++j) {
> +				if ((int) comm_event->comm.pid == threads->map[j]) {
> +					need_leader = false;
> +					break;
> +				}
> +			}
> +
> +			/* if not, generate events for it */
> +			if (need_leader &&
> +			    __event__synthesize_thread(comm_event, mmap_event,
> +					       comm_event->comm.pid, 0,
> +					       process, session)) {
> +				err = -1;
> +				break;
> +			}
> +		}
>  	}
>  	free(mmap_event);
>  out_free_comm:
> @@ -329,7 +354,7 @@ int perf_event__synthesize_threads(perf_event__handler_t process,
>  		if (*end) /* only interested in proper numerical dirents */
>  			continue;
>  
> -		__event__synthesize_thread(comm_event, mmap_event, pid,
> +		__event__synthesize_thread(comm_event, mmap_event, pid, 1,
>  					   process, session);
>  	}
>  
