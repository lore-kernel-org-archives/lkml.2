Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab2BHX2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 18:28:47 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59376 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538Ab2BHX2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 18:28:46 -0500
MIME-Version: 1.0
In-Reply-To: <20120208065115.GA19691@zhy>
References: <1328560933-3037-1-git-send-email-venki@google.com>
	<20120208065115.GA19691@zhy>
Date: Wed, 8 Feb 2012 15:28:45 -0800
Message-ID: <CABeCy1bAB6PSAUabk8zO8oh_sLVo3sOPVrr_kSovLdmOOtkfTg@mail.gmail.com>
Subject: Re: [RFC] Extend mwait idle to optimize away IPIs when possible
From: Venki Pallipadi <venki@google.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 10:51 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Mon, Feb 06, 2012 at 12:42:13PM -0800, Venkatesh Pallipadi wrote:
>> smp_call_function_single and ttwu_queue_remote sends unconditional IPI
>> to target CPU. However, if the target CPU is in mwait based idle, we can
>> do IPI-less wakeups using the magical powers of monitor-mwait.
>> Doing this has certain advantages:
>
> Actually I'm trying to do the similar thing on MIPS.
>
> The difference is that I want task_is_polling() to do something. The basic
> idea is:
>
>> +                     if (ipi_pending()) {
>> +                             clear_ipi_pending();
>> +                             local_bh_disable();
>> +                             local_irq_disable();
>> +                             generic_smp_call_function_single_interrupt();
>> +                             scheduler_wakeup_self_check();
>> +                             local_irq_enable();
>> +                             local_bh_enable();
>
> I let cpu_idle() check if there is anything to do as your above code.
>
> And task_is_polling() handle the others with below patch:
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5255c9d..09f633d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -527,15 +527,16 @@ void resched_task(struct task_struct *p)
>                smp_send_reschedule(cpu);
>  }
>
> -void resched_cpu(int cpu)
> +int resched_cpu(int cpu)
>  {
>        struct rq *rq = cpu_rq(cpu);
>        unsigned long flags;
>
>        if (!raw_spin_trylock_irqsave(&rq->lock, flags))
> -               return;
> +               return 0;
>        resched_task(cpu_curr(cpu));
>        raw_spin_unlock_irqrestore(&rq->lock, flags);
> +       return 1;
>  }

Two points -
rq->lock: I tried something similar first. One hurdle with checking
task_is_polling() is that you need rq->lock to check it. And adding
lock+unlock (without wait) in wakeup path ended up being no net gain
compared to IPI. And when we actually end up spinning on that lock,
thats going to add overhead in the common path. That is the reason I
switched to atomic compare exchange and moving any wait onto the
target CPU coming out of idle.

resched_task: ttwu_queue_remote() does not imply that the remote CPU
will do a resched. Today there is a IPI and IPI handler calls onto
check_preempt_wakeup() and if the current task has higher precedence
than the waking up task, then there will be just an activation of new
task and no resched. Using resched_task above breaks
check_preempt_wakeup() and always calls a resched on remote CPU after
the IPI, which would be change in behavior.

Thanks,
Venki

>
>  #ifdef CONFIG_NO_HZ
> @@ -1484,7 +1485,8 @@ void scheduler_ipi(void)
>
>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
>  {
> -       if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> +       if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list) &&
> +                                               !resched_cpu(cpu))
>                smp_send_reschedule(cpu);
>  }
>
> Thought?
>
> Thanks,
> Yong
