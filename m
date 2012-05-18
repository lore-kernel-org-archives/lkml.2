Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab2ERFqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 01:46:23 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48449 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2ERFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 01:46:22 -0400
Message-ID: <4FB5E2AA.1030907@linaro.org>
Date: Fri, 18 May 2012 09:48:26 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: Re: Perf record format portability
References: <4FB275EB.5050904@linaro.org>   <20120515155146.GB7864@infradead.org> <4FB38677.8070601@linaro.org>   <20120516145927.GC7864@infradead.org>  <1337187503.6724.50.camel@gandalf.stny.rr.com>  <4FB4885F.4000002@linaro.org> <1337255326.6724.92.camel@gandalf.stny.rr.com>
In-Reply-To: <1337255326.6724.92.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 03:48 PM, Steven Rostedt wrote:

> trace-cmd copies the entire /sys/kernel/debug/tracing/events directory
> into the data file (well it copies only the events you specify).
> I thought perf did the same. It should be using what's in the perf.dat
> file and not what's on the host.

I found that 'perf script' and 'perf report' works differently,
and I suppose 'perf script' is correct and 'perf report' isn't.

What I'm doing on PC host is:

1) Collect data with:
    perf record -a -R -f -m 8192	-c 1 -e sched:sched_switch \
	-e sched:sched_process_exit -e sched:sched_process_fork \
	-e sched:sched_wakeup -e sched:sched_migrate_task [task]
2) Collect an output from 'perf script' and 'perf report', both looks
    great.
3) Copy perf.data and contents of /proc/kallsyms to ARM target.

4) Next, on ARM target:
    perf script --kallsyms=[kallsyms from PC host] -i [perf.data from PC host]
    Looks good, all event names like 'sched_wakeup' or 'sched_switch' are shown.
5) Try:
    perf report --kallsyms=[kallsyms from PC host] -i [perf.data from PC host] --stdio
    All event names are shown as 'unknown:unknown'.

"Cross-replaying" (perf sched replay) looks broken too.
Host results are:

run measurement overhead: 260 nsecs
sleep measurement overhead: 56109 nsecs
the run test took 1000054 nsecs
the sleep test took 1076170 nsecs
nr_run_events:        246
nr_sleep_events:      257
nr_wakeup_events:     123
target-less wakeups:  27
task      0 (           <unknown>:      3440), nr_events: 33
task      1 (         kworker/0:0:      3227), nr_events: 15
task      2 (           <unknown>:         0), nr_events: 125
task      3 (     plugin-containe:      1769), nr_events: 13
task      4 (         ksoftirqd/0:         3), nr_events: 5
task      5 (         kworker/2:2:      2023), nr_events: 3
task      6 (                perf:      3441), nr_events: 200
task      7 (         migration/2:      3091), nr_events: 3
task      8 (         kworker/1:0:      3104), nr_events: 158
task      9 (               urxvt:      2952), nr_events: 95
task     10 (         ksoftirqd/2:      3093), nr_events: 3
------------------------------------------------------------
#1  : 70.193, ravg: 70.19, cpu: 116.57 / 116.57
#2  : 70.607, ravg: 70.23, cpu: 116.61 / 116.58
#3  : 70.411, ravg: 70.25, cpu: 116.69 / 116.59
#4  : 70.386, ravg: 70.27, cpu: 116.72 / 116.60
#5  : 70.222, ravg: 70.26, cpu: 116.39 / 116.58
#6  : 70.361, ravg: 70.27, cpu: 116.40 / 116.56
#7  : 70.409, ravg: 70.28, cpu: 116.43 / 116.55
#8  : 70.368, ravg: 70.29, cpu: 116.50 / 116.55
#9  : 70.604, ravg: 70.32, cpu: 116.75 / 116.57
#10 : 70.578, ravg: 70.35, cpu: 116.79 / 116.59

Cross-replaying attempt is ('perf sched -i [perf.data from PC host] replay'):

run measurement overhead: 8099 nsecs
sleep measurement overhead: 159428 nsecs
the run test took 998913 nsecs
the sleep test took 1188048 nsecs
nr_run_events:        0
nr_sleep_events:      0
nr_wakeup_events:     0
------------------------------------------------------------
#1  : 0.058, ravg: 0.06, cpu: 0.00 / 0.00
#2  : 0.105, ravg: 0.06, cpu: 0.00 / 0.00
#3  : 0.027, ravg: 0.06, cpu: 0.00 / 0.00
#4  : 0.026, ravg: 0.06, cpu: 0.00 / 0.00
#5  : 0.035, ravg: 0.05, cpu: 0.00 / 0.00
#6  : 0.027, ravg: 0.05, cpu: 0.00 / 0.00
#7  : 0.027, ravg: 0.05, cpu: 0.00 / 0.00
#8  : 0.028, ravg: 0.05, cpu: 0.00 / 0.00
#9  : 0.029, ravg: 0.04, cpu: 0.00 / 0.00
#10 : 0.028, ravg: 0.04, cpu: 0.00 / 0.00

Dmitry
