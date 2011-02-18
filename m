Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab1BRSHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 13:07:39 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:21426 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1BRSHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 13:07:35 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABJEXk2rR7Hu/2dsb2JhbACmJXOffZs0hV4EhQuHBoM6
X-IronPort-AV: E=Sophos;i="4.62,188,1297036800"; 
   d="scan'208";a="262036328"
Message-ID: <4D5EB564.6030504@cisco.com>
Date: Fri, 18 Feb 2011 11:07:32 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-perf-users@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@ghostprotocols.net, paulus@samba.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
References: <1298008433-22911-1-git-send-email-daahern@cisco.com> <1298008433-22911-4-git-send-email-daahern@cisco.com> <20110218070657.GA11404@elte.hu> <4D5E8204.2090501@cisco.com> <20110218175926.GA3445@nowhere>
In-Reply-To: <20110218175926.GA3445@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 10:59, Frederic Weisbecker wrote:
> On Fri, Feb 18, 2011 at 07:28:20AM -0700, David Ahern wrote:
>>
>>
>> On 02/18/11 00:06, Ingo Molnar wrote:
>>>
>>> * David Ahern <daahern@cisco.com> wrote:
>>>
>>>> +--timehist::
>>>> +        Generate time history output. This shows each sample with a wall-clock
>>>> +        timestamp and address to symbol conversions. The samples are output in
>>>> +        the same order they exist in the perf.data file. The --timehist option
>>>> +        must be used with the record to get wall-clock timestamps.
>>>
>>> Displaying samples this way is very useful, but how is this different from trace 
>>> output - i.e. 'perf script' output?
>>>
>>> There's a 'live logging mode' feature:
>>>
>>>     perf record ./myworkload | perf inject -v -b | perf script -i -
>>>
>>> ( There's also some work going on to have a separate 'perf trace' utility that will
>>>   output a linear trace of whatever events in perf.data are. )
>>>
>>> So unless i'm missing something it would be more useful to extend 'perf script' (or 
>>> the upcoming 'perf trace') to list regular samples in a perf.data (i.e. not rely on 
>>> -R raw trace data alone), and of course allow a straightforward utilization of real 
>>> timestamps, when available.
>>
>> To date I have not seen any option to show samples with wall-clock
>> timestamps. In a sense it pretty-prints the -R format. This allows perf
>> samples to be compared to other log files / sources of data to resolve
>> an issue.
>>
>> For example:
>>
>>  Time-of-Day   Kernel Timestamp cpu    Event  Command   PID
>> IP     Symbol Name (DSO Name)
>> 22:40:13.831567     858005051634   1  context-switches  kworker/1:0 8
>> ffffffff8103251e perf_event_task_sched_out ([kernel.kallsyms])
>>
>> 22:40:13.831683     858005168139   1  context-switches  sshd 897
>> ffffffff8103251e perf_event_task_sched_out ([kernel.kallsyms])
>>
>> With the stack callchain option it dumps a line for each address in the
>> stack (columns abbreviated here for email):
>>
>> 07:24:37.527728  1  sshd 819  ffffffff8103251e perf_event_task_sched_out
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81377231 schedule ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81377f3a
>> schedule_hrtimeout_range_clock ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81378016 schedule_hrtimeout_range
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81103e15 poll_schedule_timeout
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff8110463c do_select ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff811047f4 core_sys_select
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81104929 sys_select
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819  ffffffff81002bc2 system_call
>> ([kernel.kallsyms])
>> 07:24:37.527728  1  sshd 819      7f56d4814e93 __GI_select
>> (/lib64/libc-2.12.90.so)
>> 07:24:37.527728  1  sshd 819            40560b run_builtin
>> (/tmp/build-perf/perf)
>> 07:24:37.527728  1  sshd 819            40580d handle_internal_command
>> (/tmp/build-perf/perf)
>> 07:24:37.527728  1  sshd 819            405959 run_argv
>> (/tmp/build-perf/perf)
>> 07:24:37.527728  1  sshd 819            405b63 main (/tmp/build-perf/perf)
>> 07:24:37.527728  1  sshd 819      7fa49de9fe7d __libc_start_main
>> (/lib64/libc-2.12.90.so)
>>
>>
>> This format has allowed us to do an in-depth analysis of scheduling
>> (record -e cs -c 1): we can see when was process running, for how long
>> it ran, why it was kicked off the processor, how long was it off the
>> processor, what ran in between schedulings, etc. If a log file shows a
>> process missing a heartbeat you can look at the perf data in the time
>> range and see if it had a chance to run. If not where was it blocked.
> 
> Oh, in this case I strongly suggest you to use the tracepoint events.
> 
> Look at the output of "perf list" and seek the events which name
> start with "sched:"
> 
>   sched:sched_kthread_stop                   [Tracepoint event]
>   sched:sched_kthread_stop_ret               [Tracepoint event]
>   sched:sched_wait_task                      [Tracepoint event]
>   sched:sched_wakeup                         [Tracepoint event]
>   sched:sched_wakeup_new                     [Tracepoint event]
>   sched:sched_switch                         [Tracepoint event]
>   sched:sched_migrate_task                   [Tracepoint event]
>   sched:sched_process_free                   [Tracepoint event]
>   sched:sched_process_exit                   [Tracepoint event]
>   sched:sched_process_wait                   [Tracepoint event]
>   sched:sched_process_fork                   [Tracepoint event]
>   sched:sched_stat_wait                      [Tracepoint event]
>   sched:sched_stat_sleep                     [Tracepoint event]
>   sched:sched_stat_iowait                    [Tracepoint event]
>   sched:sched_stat_runtime                   [Tracepoint event]
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

Yes, I have looked at that output before -- essentially ftrace output.

We want not only context-switch events, but the stack trace at the
switch. For example, with the stack trace you can see preemption -- when
a process got booted by another and where the booted process is at the
time. You can see not only which system call caused an ap to block
(e.g., an ioctl) but the full code path leading to the block.

That data along with the gettimeofday timestamp has allowed us to
resolve performance issues such as a system call taking longer than
expected during a specific sequence of events or a process getting
preempted and not scheduled for N seconds. etc., etc.

David
