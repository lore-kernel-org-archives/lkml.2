Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab1BRO2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:28:24 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:33194 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab1BRO2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:28:20 -0500
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEcQXk2rRN+K/2dsb2JhbACmInOgU5s5hV4EhQuHBoM6
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="312208080"
Message-ID: <4D5E8204.2090501@cisco.com>
Date: Fri, 18 Feb 2011 07:28:20 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, acme@ghostprotocols.net, paulus@samba.org,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 3/3] perf events: add timehist option to record and report
References: <1298008433-22911-1-git-send-email-daahern@cisco.com> <1298008433-22911-4-git-send-email-daahern@cisco.com> <20110218070657.GA11404@elte.hu>
In-Reply-To: <20110218070657.GA11404@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 00:06, Ingo Molnar wrote:
> 
> * David Ahern <daahern@cisco.com> wrote:
> 
>> +--timehist::
>> +        Generate time history output. This shows each sample with a wall-clock
>> +        timestamp and address to symbol conversions. The samples are output in
>> +        the same order they exist in the perf.data file. The --timehist option
>> +        must be used with the record to get wall-clock timestamps.
> 
> Displaying samples this way is very useful, but how is this different from trace 
> output - i.e. 'perf script' output?
> 
> There's a 'live logging mode' feature:
> 
>     perf record ./myworkload | perf inject -v -b | perf script -i -
> 
> ( There's also some work going on to have a separate 'perf trace' utility that will
>   output a linear trace of whatever events in perf.data are. )
> 
> So unless i'm missing something it would be more useful to extend 'perf script' (or 
> the upcoming 'perf trace') to list regular samples in a perf.data (i.e. not rely on 
> -R raw trace data alone), and of course allow a straightforward utilization of real 
> timestamps, when available.

To date I have not seen any option to show samples with wall-clock
timestamps. In a sense it pretty-prints the -R format. This allows perf
samples to be compared to other log files / sources of data to resolve
an issue.

For example:

 Time-of-Day   Kernel Timestamp cpu    Event  Command   PID
IP     Symbol Name (DSO Name)
22:40:13.831567     858005051634   1  context-switches  kworker/1:0 8
ffffffff8103251e perf_event_task_sched_out ([kernel.kallsyms])

22:40:13.831683     858005168139   1  context-switches  sshd 897
ffffffff8103251e perf_event_task_sched_out ([kernel.kallsyms])

With the stack callchain option it dumps a line for each address in the
stack (columns abbreviated here for email):

07:24:37.527728  1  sshd 819  ffffffff8103251e perf_event_task_sched_out
([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81377231 schedule ([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81377f3a
schedule_hrtimeout_range_clock ([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81378016 schedule_hrtimeout_range
([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81103e15 poll_schedule_timeout
([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff8110463c do_select ([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff811047f4 core_sys_select
([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81104929 sys_select
([kernel.kallsyms])
07:24:37.527728  1  sshd 819  ffffffff81002bc2 system_call
([kernel.kallsyms])
07:24:37.527728  1  sshd 819      7f56d4814e93 __GI_select
(/lib64/libc-2.12.90.so)
07:24:37.527728  1  sshd 819            40560b run_builtin
(/tmp/build-perf/perf)
07:24:37.527728  1  sshd 819            40580d handle_internal_command
(/tmp/build-perf/perf)
07:24:37.527728  1  sshd 819            405959 run_argv
(/tmp/build-perf/perf)
07:24:37.527728  1  sshd 819            405b63 main (/tmp/build-perf/perf)
07:24:37.527728  1  sshd 819      7fa49de9fe7d __libc_start_main
(/lib64/libc-2.12.90.so)


This format has allowed us to do an in-depth analysis of scheduling
(record -e cs -c 1): we can see when was process running, for how long
it ran, why it was kicked off the processor, how long was it off the
processor, what ran in between schedulings, etc. If a log file shows a
process missing a heartbeat you can look at the perf data in the time
range and see if it had a chance to run. If not where was it blocked.

David

> 
> Thanks,
> 
> 	Ingo
