Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2L2NVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 08:21:09 -0500
Received: from mail-vc0-f176.google.com ([209.85.220.176]:59780 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab2L2NVH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 08:21:07 -0500
MIME-Version: 1.0
In-Reply-To: <87a9t1s5o9.fsf@sejong.aot.lge.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
	<1356028391-14427-21-git-send-email-fweisbec@gmail.com>
	<87a9t1s5o9.fsf@sejong.aot.lge.com>
Date: Sat, 29 Dec 2012 14:21:06 +0100
Message-ID: <CAFTL4hxDMhyC-x=SUecoUUy=6==yxFsmJ7B=zfFUQ-M6QSoYXw@mail.gmail.com>
Subject: Re: [PATCH 20/24] nohz: Full dynticks mode
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/26 Namhyung Kim <namhyung@kernel.org>:
> Hi Frederic,
>
> On Thu, 20 Dec 2012 19:33:07 +0100, Frederic Weisbecker wrote:
>> When a CPU is in full dynticks mode, try to switch
>> it to nohz mode from the interrupt exit path if it is
>> running a single non-idle task.
>>
>> Then restart the tick if necessary if we are enqueuing a
>> second task while the timer is stopped, so that the scheduler
>> tick is rearmed.
>>
>> [TODO: Check remaining things to be done from scheduler_tick()]
>>
>> [ Included build fix from Geoff Levand ]
> [snip]
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index db3d4df..f3d8f4a 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -943,6 +943,14 @@ static inline u64 steal_ticks(u64 steal)
>>  static inline void inc_nr_running(struct rq *rq)
>>  {
>>       rq->nr_running++;
>> +
>> +     if (rq->nr_running == 2) {
>> +             if (tick_nohz_full_cpu(rq->cpu)) {
>> +                     /* Order rq->nr_running write against the IPI */
>> +                     smp_wmb();
>> +                     smp_send_reschedule(rq->cpu);
>> +             }
>> +     }
>
> This block should be guarded with #ifdef CONFIG_SMP, otherwise:
>
>   CC      kernel/sched/core.o
> In file included from /home/namhyung/project/linux/kernel/sched/core.c:85:0:
> /home/namhyung/project/linux/kernel/sched/sched.h: In function ‘inc_nr_running’:
> /home/namhyung/project/linux/kernel/sched/sched.h:960:28: error: ‘struct rq’ has no member named ‘cpu’
> /home/namhyung/project/linux/kernel/sched/sched.h:963:26: error: ‘struct rq’ has no member named ‘cpu’

Right, to fix this, I'm making it depend on CONFIG_NO_HZ_FULL and make
CONFIG_NO_HZ_FULL depend on SMP for the next version.

Thanks!
