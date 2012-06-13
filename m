Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab2FMH4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 03:56:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37372 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2FMH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 03:56:11 -0400
Message-ID: <4FD84795.20409@gmail.com>
Date: Wed, 13 Jun 2012 15:56:05 +0800
From: Charles Wang <muming.wq@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Doug Smythies <dsmythies@telus.net>
CC: "'Peter Zijlstra'" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Charles Wang'" <muming.wq@taobao.com>, "'Tao Ma'" <tm@tao.ma>,
        =?ISO-2022-JP?B?JxskQjReQmMbKEIn?= <handai.szj@taobao.com>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>	 <1339429374.30462.54.camel@twins> <4FD70D12.5030404@gmail.com> <1339494970.31548.66.camel@twins> <004701cd4929$200d4600$6027d200$@net>
In-Reply-To: <004701cd4929$200d4600$6027d200$@net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 13, 2012 01:55 PM, Doug Smythies wrote:

>>  On 2012.06.12 02:56 - 0800 (I think), Peter Zijlstra wrote:
> 
>> Also added Doug to CC, hopefully we now have everybody who pokes at this
>> stuff.
> 
> Thanks.
> 
> On my computer, and from a different thread from yesterday, I let
> the proposed "wang" patch multiple processes test continue for
> another 24 hours. The png file showing the results is attached, also
> available at [1].
> 
> Conclusion: The proposed "wang" patch is worse for the lower load
> conditions, giving higher reported load average errors for the same
> conditions. The proposed "wang" patch tends towards a load equal to
> the number of processes, independent of the actual load of those
> processes.
> 
> Interestingly, with the "wang" patch I was able to remove the 10
> tick grace period without bad side effects (very minimally tested).
> 
> @ Charles or Tao: If I could ask: What is your expected load for your 16
> processes case? Because you used to get a reported load average of
> < 1, we know that the processes enter and exit idle (sleep) at a high
> frequency (as that was only possible way for the older under reporting
> issue, at least as far as I know). You said it now reports a load
> average of 8 to 10, but that is too low. How many CPU's do you have?
> I have been unable to re-create your situation on my test computer
> (an i7 CPU).
> When I run 16 processes, where each process would use 0.95 of a cpu,
> if the system did not become resource limited, I get a reported load
> average of about 15 to 16. Kernel = 3.5 RC2. Process sleep frequency
> was about 80 Hertz each.
> 
> [1]
> http://www.smythies.com/~doug/network/load_average/load_processes_wang.html
> 
> Doug Smythies
> 


Thanks Doug for these exhaustive testing!

Every cpu's load should be the load right on the time executing
calculation.
This is what my patch expected to do.

After my patch, it's supposed to let every cpu's load calculation be
independent from
its idle and other cpus' influence when the calculation is finished.
But it seems other problem exists.

I recorded some trace, show as below:

tasks--->calc_load_tasks
idle--->calc_load_tasks_idle
idle_unmask--->calc_unmask_cpu_load_idle
scheduler_tick---> after calc_load_account_active called
pick_next_task_idle---> after pick_next_task_idle called

#           TASK-PID    CPU#    TIMESTAMP
#              | |       |          |                      |
           <...>-4318  [000]  1864.217498: scheduler_tick: tasks:1
idle:0 idle_unmask:0
           <...>-4320  [002]  1864.217534: scheduler_tick: tasks:2
idle:0 idle_unmask:0
           <...>-4313  [003]  1864.217555: scheduler_tick: tasks:3
idle:0 idle_unmask:0
           <...>-4323  [004]  1864.217577: scheduler_tick: tasks:5
idle:0 idle_unmask:0
           <...>-4316  [005]  1864.217596: scheduler_tick: tasks:6
idle:0 idle_unmask:0
           <...>-4311  [006]  1864.217617: scheduler_tick: tasks:8
idle:0 idle_unmask:0
           <...>-4312  [007]  1864.217637: scheduler_tick: tasks:9
idle:0 idle_unmask:0
          <idle>-0     [008]  1864.217659: scheduler_tick: tasks:9
idle:0 idle_unmask:0
           <...>-4317  [009]  1864.217679: scheduler_tick: tasks:10
idle:0 idle_unmask:0
           <...>-4321  [010]  1864.217700: scheduler_tick: tasks:11
idle:0 idle_unmask:0
           <...>-4318  [000]  1864.217716: pick_next_task_idle: go idle!
tasks:11 idle:-1 idle_unmask:0
           <...>-4319  [011]  1864.217721: scheduler_tick: tasks:12
idle:-1 idle_unmask:0
           <...>-4309  [012]  1864.217742: scheduler_tick: tasks:13
idle:-1 idle_unmask:0
           <...>-4313  [003]  1864.217758: pick_next_task_idle: go idle!
tasks:13 idle:-2 idle_unmask:0
           <...>-4310  [013]  1864.217762: scheduler_tick: tasks:14
idle:-2 idle_unmask:0
           <...>-4309  [012]  1864.217773: pick_next_task_idle: go idle!
tasks:14 idle:-3 idle_unmask:0
           <...>-4314  [014]  1864.217783: scheduler_tick: tasks:15
idle:-3 idle_unmask:0
           <...>-4322  [015]  1864.217804: scheduler_tick: tasks:16
idle:-3 idle_unmask:0
           <...>-4319  [011]  1864.217862: pick_next_task_idle: go idle!
tasks:16 idle:-4 idle_unmask:0
           <...>-4316  [005]  1864.217886: pick_next_task_idle: go idle!
tasks:16 idle:-5 idle_unmask:0
           <...>-4322  [015]  1864.217909: pick_next_task_idle: go idle!
tasks:16 idle:-6 idle_unmask:0
           <...>-4320  [002]  1864.217956: pick_next_task_idle: go idle!
tasks:16 idle:-7 idle_unmask:0
           <...>-4311  [006]  1864.217976: pick_next_task_idle: go idle!
tasks:16 idle:-9 idle_unmask:0
           <...>-4321  [010]  1864.218118: pick_next_task_idle: go idle!
tasks:16 idle:-10 idle_unmask:0
           <...>-4314  [014]  1864.218198: pick_next_task_idle: go idle!
tasks:16 idle:-11 idle_unmask:0
           <...>-4317  [009]  1864.218930: pick_next_task_idle: go idle!
tasks:16 idle:-12 idle_unmask:0
           <...>-4323  [004]  1864.219782: pick_next_task_idle: go idle!
tasks:16 idle:-14 idle_unmask:0
           <...>-4310  [013]  1864.219784: pick_next_task_idle: go idle!
tasks:16 idle:-15 idle_unmask:0
           <...>-4312  [007]  1864.221397: pick_next_task_idle: go idle!
tasks:16 idle:-16 idle_unmask:0

As u see, the time when we calculate the load, almost all of these cpus'
loads are 1. But after
calculation, almost all of their loads go down to 0.   All these are
done in 1~2 tick.
If a cpu's load moves quickly between 0 and 1, then the time when we get
the load it should be 0 or 1, not always on 1. This is the problem i
found, and may lead the load tending towards the number of processes.
@Peter  Will scheduler disturb the time doing load calculation? I
thought it's just determined by the time interrupts before.

