Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab1LNUOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:14:54 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42364 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976Ab1LNUOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:14:53 -0500
Message-ID: <4EE903B1.7000600@fb.com>
Date: Wed, 14 Dec 2011 12:14:41 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: <avagin@openvz.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 3/4] trace: add ability to collect call chain of non-current
 task.
References: <1317052535-1765247-1-git-send-email-avagin@openvz.org> <1317052535-1765247-4-git-send-email-avagin@openvz.org> <1317132351.15383.66.camel@twins> <20110927205548.GN18553@somewhere> <4EE01ACB.1000102@fb.com> <4EE1EC0B.4020600@openvz.org>
In-Reply-To: <4EE1EC0B.4020600@openvz.org>
Content-Type: text/plain; charset="KOI8-R"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.5.7110,1.0.211,0.0.0000
 definitions=2011-12-14_08:2011-12-14,2011-12-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/9/11 3:07 AM, Andrey Vagin wrote:

>> Attached is an alternative approach that does what you allude to above.
>
> * Your method doesn't work for rt scheduler.

This is no worse than sched_stat_{iowait,sleep} which are also CFS specific?

> * It doesn't distinguish blocking time and sleeping time.

Can't we distinguish based on next->state?

> * This patch does a bit mess between subsystems...

Which subsystems?

>> perf record -agPe sched:sched_switch --filter "delay > 1000000" --
>> sleep 1
>
> Why do you need the option "-a" ?
>

I'd love to see it work without the -a (so normal users can use it).

I guess I'll need to move the trace_sched_switch() tracepoint to be 
after perf_event_task_sched_in() in finish_task_switch().


>>
>> allows us to collect a lot less. For some reason, "perf script" shows
>
>> the correct delay field, but the sample period still contains 1 (i.e
>> __perf_count() hint is not working for me).
>
> Which kernel do you use? Does it contain "[PATCH] event: don't divide
> events if it has field period"? It works fine with my kernel...
>

I was using 3.2-rc2. I picked up the patch you reference above.

# perf report -D | grep SAMPLE.*period:
3 1437330416084 0x26d908 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 7276/7806: 
0xffffffff8102c0a7 period: 140736819516096 addr: 0
3 1437330422290 0x26db58 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 7276/7806: 
0xffffffff8102c0a7 period: 140736819516096 addr: 0
3 1437330428485 0x26dda8 [0x250]: PERF_RECORD_SAMPLE(IP, 1): 7276/7806: 
0xffffffff8102c0a7 period: 140736819516096 addr: 0

# perf script | grep next_comm=test.*delay | head -3
             test 13070 [023]  1437.320529: sched_switch: 
prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
next_comm=test next_pid=13070 next_prio=120 delay=1096877
             test 13070 [023]  1437.320531: sched_switch: 
prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
next_comm=test next_pid=13070 next_prio=120 delay=1096877
             test 13070 [023]  1437.320532: sched_switch: 
prev_comm=kworker/0:1 prev_pid=0 prev_prio=120 prev_state=R ==> 
next_comm=test next_pid=13070 next_prio=120 delay=1096877

The period still looks bogus i.e. doesn't match delay.

Thanks for reviewing. I'll clean up some of these issues and post a new 
patch in a couple of days.

  -Arun

