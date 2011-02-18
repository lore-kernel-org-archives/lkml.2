Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab1BRSl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:41:28 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36533 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab1BRSl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=vcm1zlS5SH2CI89j3JF8p/4IUMZQbpjMl1VJVa8eRmUuvGGXuFOKLbNZ6+jCEu09rF
         dZoE3OlBP6dqAnHC75ZQ3buRMkK9GQIriT8i8v72hQpml4GAs+ELmcT6c6e4DEHR8RHb
         h7YWVxnXaHkTmCaFxM9UdQN9D3uNnOP0nISeE=
Date: Fri, 18 Feb 2011 16:41:19 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: David Ahern <daahern@cisco.com>, Ingo Molnar <mingo@elte.hu>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
Message-ID: <20110218184119.GC302@ghostprotocols.net>
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>
 <1298008433-22911-4-git-send-email-daahern@cisco.com>
 <20110218070657.GA11404@elte.hu>
 <4D5E8204.2090501@cisco.com>
 <20110218175926.GA3445@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218175926.GA3445@nowhere>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 18, 2011 at 06:59:30PM +0100, Frederic Weisbecker escreveu:
>   sched:sched_wait_task                      [Tracepoint event]
>   sched:sched_wakeup                         [Tracepoint event]
>   sched:sched_wakeup_new                     [Tracepoint event]
>   sched:sched_switch                         [Tracepoint event]
>   sched:sched_migrate_task                   [Tracepoint event]
>   sched:sched_process_free                   [Tracepoint event]
>   sched:sched_process_exit                   [Tracepoint event]
> 
> 
> You have the sched:sched_switch event and many others.
> 
> Just try:
> 
> perf record -a -e sched:*
> perf script
> 
>             perf-4128  [000] 19242.870025: sched_stat_runtime: comm=perf pid=4128 runtime=7430405 [ns] vruntime=3530192223488 
>             perf-4128  [000] 19242.870042: sched_stat_runtime: comm=perf pid=4128 runtime=23142 [ns] vruntime=3530192246630 [n
>             perf-4128  [000] 19242.870045: sched_stat_sleep: comm=kondemand/0 pid=59 delay=9979163 [ns]
>             perf-4128  [000] 19242.870048: sched_wakeup: comm=kondemand/0 pid=59 prio=120 success=1 target_cpu=000
>             perf-4128  [000] 19242.870063: sched_stat_runtime: comm=perf pid=4128 runtime=21581 [ns] vruntime=3530192268211 [n
>             perf-4128  [000] 19242.870066: sched_stat_wait: comm=kondemand/0 pid=59 delay=21581 [ns]
>             perf-4128  [000] 19242.870069: sched_switch: prev_comm=perf prev_pid=4128 prev_prio=120 prev_state=R ==> next_comm
>      kondemand/0-59    [000] 19242.870091: sched_stat_runtime: comm=kondemand/0 pid=59 runtime=27362 [ns] vruntime=35301862739
>      kondemand/0-59    [000] 19242.870094: sched_stat_wait: comm=perf pid=4128 delay=27362 [ns]
>      kondemand/0-59    [000] 19242.870095: sched_switch: prev_comm=kondemand/0 prev_pid=59 prev_prio=120 prev_state=S ==> next
> 
> And you can run your own script on these events:
> 
> $ sudo ./perf script -g python
> generated Python script: perf-script.py
> 
> Edit perf-script.py and then run it:
> 
> $ perf script -s ./perf-script.py
> 
> That also works for perl.
> 
> The timestamps will be the cpu time and not the walltime, but at least that seems
> to be partly what you seek?

The whole issue for him, AFAIK, is to correlate perf events with app
events.

Think about tcpdump + networking tracepoints or 'perf probe' dynamic
events in the network stack, he wants to merge those logs and correlate
the tcpdump packet exchange with the tracepoints events in the network
stack, etc.

I.e. it doesn't matter if it is ftrace or not, having a common clock
shared between apps and kernel tracing/whatever infrastructure is what
David is after, right?

He can change userspace to use the clock the kernel is using in the
perf/ftrace/whatever infrastructure or make the kernel use the clock
userspace uses.

The issue here is who will bend, u or k ;-)

- Arnaldo
