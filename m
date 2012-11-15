Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768064Ab2KOPZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:25:50 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40884 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423166Ab2KOPZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:25:48 -0500
MIME-Version: 1.0
In-Reply-To: <1352953617.18025.94.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	<1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	<1352953617.18025.94.camel@gandalf.local.home>
Date: Thu, 15 Nov 2012 16:25:46 +0100
Message-ID: <CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
Subject: Re: [PATCH 7/7] printk: Wake up klogd using irq_work
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/15 Steven Rostedt <rostedt@goodmis.org>:
> On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> index f249e8c..822d757 100644
>> --- a/kernel/time/tick-sched.c
>> +++ b/kernel/time/tick-sched.c
>> @@ -289,7 +289,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>>               time_delta = timekeeping_max_deferment();
>>       } while (read_seqretry(&xtime_lock, seq));
>>
>> -     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
>> +     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
>
> If the CPU is going offline, the printk_tick() would be executed here.
> But now that printk_tick() is done with the irq_work code, it wont be
> executed till the next tick.  Could this cause a missed printk because
> of this, if the cpu is going offline?
>
> Actually, how does irq_work in general handle cpu offline work?

Good point, and that's not trivial to solve.

The hotplug down sequence does:

----->
CPU that offilines                                          CPU offlining
-----------------
---------------------
cpu_down() {
    __stop_machine(take_cpu_down)

take_cpu_down() {

__cpu_disable() {

    * disable irqs in hw

    * clear from online mask
                                                                       }

move all tasks somewhere
                                                                   }
while (!idle_cpu(offlining))
    cpu_relax()

cpu_die();
<---------

So the offlining CPU goes to idle in the end once irqs are disabled in
the apic level. Does that include the timer tick? If so then the last
resort to offline without irq works in the queue is to make
take_cpu_down() ask for a retry if there are pending irq works during
its execution.

Now if we have printk() calls between __cpu_disable() and the idle
loop, they will be lost until the next onlining. Unless we do an
explicit call to printk_tick() from the idle loop if the CPU is
offline.

Note that !CONFIG_NO_HZ doesn't seem to handle that. Which makes me
wonder if the tick is really part of the whole IRQ disablement done in
__cpu_disable().
