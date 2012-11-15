Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768638Ab2KOSIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:08:18 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65401 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768597Ab2KOSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <1352997261.18025.103.camel@gandalf.local.home>
References: <1352925457-15700-1-git-send-email-fweisbec@gmail.com>
	<1352925457-15700-8-git-send-email-fweisbec@gmail.com>
	<1352953617.18025.94.camel@gandalf.local.home>
	<CAFTL4hzzhd5__VwR7N+VKpq1C27xHGgi4vj87drbcLghJ+Od5g@mail.gmail.com>
	<1352997261.18025.103.camel@gandalf.local.home>
Date: Thu, 15 Nov 2012 19:08:16 +0100
Message-ID: <CAFTL4hxD8kjHDL04RACCqEZ829-O4VutSgbGsNXiHT=-NAHpWQ@mail.gmail.com>
Subject: Re: [PATCH RFC] irq_work: Flush work on CPU_DYING (was: Re: [PATCH
 7/7] printk: Wake up klogd using irq_work)
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
> On Thu, 2012-11-15 at 16:25 +0100, Frederic Weisbecker wrote:
>> 2012/11/15 Steven Rostedt <rostedt@goodmis.org>:
>> > On Wed, 2012-11-14 at 21:37 +0100, Frederic Weisbecker wrote:
>> >> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>> >> index f249e8c..822d757 100644
>> >> --- a/kernel/time/tick-sched.c
>> >> +++ b/kernel/time/tick-sched.c
>> >> @@ -289,7 +289,7 @@ static ktime_t tick_nohz_stop_sched_tick(struct tick_sched *ts,
>> >>               time_delta = timekeeping_max_deferment();
>> >>       } while (read_seqretry(&xtime_lock, seq));
>> >>
>> >> -     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) || printk_needs_cpu(cpu) ||
>> >> +     if (rcu_needs_cpu(cpu, &rcu_delta_jiffies) ||
>> >
>> > If the CPU is going offline, the printk_tick() would be executed here.
>> > But now that printk_tick() is done with the irq_work code, it wont be
>> > executed till the next tick.  Could this cause a missed printk because
>> > of this, if the cpu is going offline?
>> >
>> > Actually, how does irq_work in general handle cpu offline work?
>>
>> Good point, and that's not trivial to solve.
>>
>> The hotplug down sequence does:
>>
>> ----->
>> CPU that offilines                                          CPU offlining
>> -----------------
>> ---------------------
>> cpu_down() {
>>     __stop_machine(take_cpu_down)
>>
>> take_cpu_down() {
>>
>> __cpu_disable() {
>>
>>     * disable irqs in hw
>>
>>     * clear from online mask
>>                                                                        }
>>
>> move all tasks somewhere
>>                                                                    }
>> while (!idle_cpu(offlining))
>>     cpu_relax()
>>
>> cpu_die();
>> <---------
>>
>> So the offlining CPU goes to idle in the end once irqs are disabled in
>> the apic level. Does that include the timer tick? If so then the last
>> resort to offline without irq works in the queue is to make
>> take_cpu_down() ask for a retry if there are pending irq works during
>> its execution.
>>
>> Now if we have printk() calls between __cpu_disable() and the idle
>> loop, they will be lost until the next onlining. Unless we do an
>> explicit call to printk_tick() from the idle loop if the CPU is
>> offline.
>>
>> Note that !CONFIG_NO_HZ doesn't seem to handle that. Which makes me
>> wonder if the tick is really part of the whole IRQ disablement done in
>> __cpu_disable().
>
>
> How about flushing all irq_work from CPU_DYING. The notifier is called
> by stop_machine on the CPU that is going down. Grant you, the code will
> not be called from irq context (so things like get_irq_regs() wont work)
> but I'm not sure what the requirements are for irq_work in that regard
> (Peter?). But irqs are disabled and the CPU is about to go offline.
> Might as well flush the work.
>
> I ran this against my stress_cpu_hotplug script (attached) and it seemed
> to work fine. I even did a:
>
>   perf record ./stress-cpu-hotplug
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> Index: linux-rt.git/kernel/irq_work.c
> ===================================================================
> --- linux-rt.git.orig/kernel/irq_work.c
> +++ linux-rt.git/kernel/irq_work.c
> @@ -14,6 +14,7 @@
>  #include <linux/irqflags.h>
>  #include <linux/sched.h>
>  #include <linux/tick.h>
> +#include <linux/cpu.h>
>  #include <asm/processor.h>
>
>
> @@ -105,11 +106,7 @@ bool irq_work_needs_cpu(void)
>         return true;
>  }
>
> -/*
> - * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> - * context with local IRQs disabled.
> - */
> -void irq_work_run(void)
> +static void __irq_work_run(void)
>  {
>         unsigned long flags;
>         struct irq_work *work;
> @@ -128,7 +125,6 @@ void irq_work_run(void)
>         if (llist_empty(this_list))
>                 return;
>
> -       BUG_ON(!in_irq());
>         BUG_ON(!irqs_disabled());
>
>         llnode = llist_del_all(this_list);
> @@ -155,8 +151,23 @@ void irq_work_run(void)
>                 (void)cmpxchg(&work->flags, flags, flags & ~IRQ_WORK_BUSY);
>         }
>  }
> +
> +/*
> + * Run the irq_work entries on this cpu. Requires to be ran from hardirq
> + * context with local IRQs disabled.
> + */
> +void irq_work_run(void)
> +{
> +       BUG_ON(!in_irq());
> +       __irq_work_run();
> +}
>  EXPORT_SYMBOL_GPL(irq_work_run);
>
> +static void irq_work_run_cpu_down(void)
> +{
> +       __irq_work_run();
> +}
> +
>  /*
>   * Synchronize against the irq_work @entry, ensures the entry is not
>   * currently in use.
> @@ -169,3 +180,35 @@ void irq_work_sync(struct irq_work *work
>                 cpu_relax();
>  }
>  EXPORT_SYMBOL_GPL(irq_work_sync);
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +static int irq_work_cpu_notify(struct notifier_block *self,
> +                              unsigned long action, void *hcpu)
> +{
> +       long cpu = (long)hcpu;
> +
> +       switch (action) {
> +       case CPU_DYING:

Looks good. Perf has already deactivated the cpu wide events on
CPU_DOWN_PREPARE. I suspect it's the only irq work enqueuer from NMI.
At this stage of cpu down hotplug, irqs are deactivated so the last
possible enqueuers before the CPU goes idle/down are from subsequent
CPU_DYING notifiers or the hotplug code.

There may be some printk() there but we never provided the guarantee
that klogd would be woken up on that thin window. !CONFIG_NO_HZ does
not call printk_needs_cpu() that takes cares of offlining. Its purpose
was actually to avoid a hang in old code anyway.

I'm adding this patch to my queue.

Thanks.
