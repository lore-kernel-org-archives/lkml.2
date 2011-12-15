Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758939Ab1LOPUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:20:07 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:35187 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544Ab1LOPUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:20:04 -0500
Message-ID: <4EEA101C.7060505@gmail.com>
Date: Thu, 15 Dec 2011 19:19:56 +0400
From: Andrew Vagin <avagin@gmail.com>
Reply-To: avagin@gmail.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: avagin@openvz.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere> <4EE01ACB.1000102@fb.com> <4EE1EC0B.4020600@openvz.org> <4EE903B1.7000600@fb.com>
In-Reply-To: <4EE903B1.7000600@fb.com>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2011 12:14 AM, Arun Sharma wrote:
>
>
> On 12/9/11 3:07 AM, Andrey Vagin wrote:
>
>>> Attached is an alternative approach that does what you allude to above.
>>
>> * Your method doesn't work for rt scheduler.
>
> This is no worse than sched_stat_{iowait,sleep} which are also CFS 
> specific?
Sorry. You are right. It's the same.
>
>> * It doesn't distinguish blocking time and sleeping time.
>
> Can't we distinguish based on next->state?
It will be "Running". We can distinguish based on block_start of sleep_start
>
>> * This patch does a bit mess between subsystems...
>
> Which subsystems?
sched_switch belongs to scheduler.
sched_stat belongs to sched_fair.

I am not sure, that it's bad. Send this patches in LKML.

>
>>> perf record -agPe sched:sched_switch --filter "delay > 1000000" --
>>> sleep 1
>>
>> Why do you need the option "-a" ?
>>
>
> I'd love to see it work without the -a (so normal users can use it).
>
> I guess I'll need to move the trace_sched_switch() tracepoint to be 
> after perf_event_task_sched_in() in finish_task_switch().
>
>
>>>
>>> allows us to collect a lot less. For some reason, "perf script" shows
>>
>>> the correct delay field, but the sample period still contains 1 (i.e
>>> __perf_count() hint is not working for me).
>>
>> Which kernel do you use? Does it contain "[PATCH] event: don't divide
>> events if it has field period"? It works fine with my kernel...
>>
>
> I was using 3.2-rc2. I picked up the patch you reference above.
>
> # perf report -D | grep SAMPLE.*period:
> 3 1437330416084 0x26d908 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 
> 7276/7806: 0xffffffff8102c0a7 period: 140736819516096 addr: 0
> 3 1437330422290 0x26db58 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 
> 7276/7806: 0xffffffff8102c0a7 period: 140736819516096 addr: 0
> 3 1437330428485 0x26dda8 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 
> 7276/7806: 0xffffffff8102c0a7 period: 140736819516096 addr: 0
>
> # perf script | grep next_comm=test.*delay | head -3
>             test 13070 [023]  1437.320529: sched_switch: 
> prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
> next_comm=test next_pid=13070 next_prio=120 delay=1096877
>             test 13070 [023]  1437.320531: sched_switch: 
> prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
> next_comm=test next_pid=13070 next_prio=120 delay=1096877
>             test 13070 [023]  1437.320532: sched_switch: 
> prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
> next_comm=test next_pid=13070 next_prio=120 delay=1096877
>
> The period still looks bogus i.e. doesn't match delay.

I pushed my tree on github git://github.com/avagin/perf.git. Look at 
branch "arun" https://github.com/avagin/perf/tree/arun

It works for me. You can find output of commands bellow.

# ./perf record -e sched:sched_switch -agP
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.091 MB perf.data (~3954 samples) ]

# ./perf report -D | grep SAMPLE.*period:
1 1539849049077 0x10d78 [0xc8]: PERF_RECORD_SAMPLE(IP, 1): 34/34: 
0xffffffff810527c4 period: 7714488 addr: 0

#./perf script
  kworker/1:2    34 [001]  1539.849049: sched_switch: prev_comm=perf 
prev_pid=2700 prev_prio=120 prev_state=R ==> next_comm=kworker/1:2 
next_pid=34 next_prio=120 delay=7714488
> Thanks for reviewing. I'll clean up some of these issues and post a 
> new patch in a couple of days.
>
>  -Arun
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/


