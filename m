Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab2FNPuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:50:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50736 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab2FNPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:50:08 -0400
Message-ID: <4FDA082C.1080706@gmail.com>
Date: Thu, 14 Jun 2012 09:50:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: acme@ghostprotocols.net
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, namhyung.kim@lge.com
Subject: Re: [PATCH] perf script: format regression due to libtraceevent
References: <1339688920-62816-1-git-send-email-dsahern@gmail.com>
In-Reply-To: <1339688920-62816-1-git-send-email-dsahern@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/14/12 9:48 AM, David Ahern wrote:
> Consider the commands:
> perf record -e sched:sched_switch -fo /tmp/perf-3.5.data  -a -- sleep 1

grr..... copied the wrong filename above when creating the commit log. 
/tmp/perf.data was used for both the record and the script commands.


> perf script -i /tmp/perf.data
>
> In v3.4 the output has the form (lines wrapped)
>              perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==>  next_comm=swapper/5 next_pid=0 next_prio=120
>
> In 3.5 that same line has become:
>             perf 29214 [005] 821043.582596: sched_switch:
>              <...>-29214 [005]     0.000000000: sched_switch:
>           prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==>  next_comm=swapper/5 next_pid=0 next_prio=120
>
> Note the duplicates in the output -- pid, cpu, event name. With
> this patch the v3.4 output is restored:
>             perf 29214 [005] 821043.582596: sched_switch:
> prev_comm=perf prev_pid=29214 prev_prio=120
> prev_state=S ==>  next_comm=swapper/5 next_pid=0 next_prio=120
>
> Signed-off-by: David Ahern<dsahern@gmail.com>
> ---
>   tools/lib/traceevent/event-parse.c |   36 ------------------------------------
>   1 file changed, 36 deletions(-)
>
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 5548282..261107a 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -4027,20 +4027,9 @@ void pevent_event_info(struct trace_seq *s, struct event_format *event,
>   void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
>   			struct pevent_record *record)
>   {
> -	static char *spaces = "                    "; /* 20 spaces */
>   	struct event_format *event;
> -	unsigned long secs;
> -	unsigned long usecs;
> -	unsigned long nsecs;
> -	const char *comm;
>   	void *data = record->data;
>   	int type;
> -	int pid;
> -	int len;
> -	int p;
> -
> -	secs = record->ts / NSECS_PER_SEC;
> -	nsecs = record->ts - secs * NSECS_PER_SEC;
>
>   	if (record->size<  0) {
>   		do_warning("ug! negative record size %d", record->size);
> @@ -4055,31 +4044,6 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
>   		return;
>   	}
>
> -	pid = parse_common_pid(pevent, data);
> -	comm = find_cmdline(pevent, pid);
> -
> -	if (pevent->latency_format) {
> -		trace_seq_printf(s, "%8.8s-%-5d %3d",
> -		       comm, pid, record->cpu);
> -		pevent_data_lat_fmt(pevent, s, record);
> -	} else
> -		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
> -
> -	if (pevent->flags&  PEVENT_NSEC_OUTPUT) {
> -		usecs = nsecs;
> -		p = 9;
> -	} else {
> -		usecs = (nsecs + 500) / NSECS_PER_USEC;
> -		p = 6;
> -	}
> -
> -	trace_seq_printf(s, " %5lu.%0*lu: %s: ", secs, p, usecs, event->name);
> -
> -	/* Space out the event names evenly. */
> -	len = strlen(event->name);
> -	if (len<  20)
> -		trace_seq_printf(s, "%.*s", 20 - len, spaces);
> -
>   	pevent_event_info(s, event, record);
>   }
>

