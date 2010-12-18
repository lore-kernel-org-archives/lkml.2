Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab0LROtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 09:49:22 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48785 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab0LROtV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 09:49:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UI5/pzbSXfwpVXiz964cvYgU02LQS77RvmjbauyWhaZ1Mq4ufB6eE6p1/5/Wv6fdnd
         LNvZ+N2BqeUJ4/9Moa4rK5ok+8OjEyb75A4jLRl18MGbw1o/pu9Agk7r7XG9YYW9ic5P
         p6K+EJyuL6N8xZOpaFkoyX6AGqrC8xNfpSo3I=
MIME-Version: 1.0
In-Reply-To: <1292609740.2266.323.camel@twins>
References: <20101216145602.899838254@chello.nl>
	<20101216150920.968046926@chello.nl>
	<20101216184229.GA15889@redhat.com>
	<1292525893.2708.50.camel@laptop>
	<1292526220.2708.55.camel@laptop>
	<1292528874.2708.85.camel@laptop>
	<1292531553.2708.89.camel@laptop>
	<20101217165414.GA8997@redhat.com>
	<1292607781.2266.295.camel@twins>
	<1292609740.2266.323.camel@twins>
Date: Sat, 18 Dec 2010 22:49:19 +0800
Message-ID: <AANLkTik86z7NZCqkYU1JY1NUW3qxthaBohY3CNk6awEd@mail.gmail.com>
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 2:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2010-12-17 at 18:43 +0100, Peter Zijlstra wrote:
>>
>> Hrmph, so is it only about serializing concurrent wakeups? If so, we
>> could possibly hold p->pi_lock over the wakeup.
>
> Something like the below.. except it still suffers from the
> __migrate_task() hole you identified in your other email.
>
> By fully serializing all wakeups using ->pi_lock it becomes a lot
> simpler (although I just realized we might have a problem with
> try_to_wake_up_local).
>
> static int
> try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> {
>        unsigned long flags;
>        int cpu, ret = 0;
>
>        smp_wmb();
>        raw_spin_lock_irqsave(&p->pi_lock, flags);
>
>        if (!(p->state & state))
>                goto unlock;
>
>        ret = 1; /* we qualify as a proper wakeup now */

Could below happen in this __window__?

p is going through wake_event and it first set TASK_UNINTERRUPTIBLE,
then waker see that and above if (!(p->state & state)) passed.
But at this time condition == true for p, and p return to run and
intend to sleep:
          p->state == XXX;
          sleep;

then we could wake up a process which has wrong state, no?

>
>        if (p->se.on_rq && ttwu_force(p, state, wake_flags))
>                goto unlock;
>
>        p->sched_contributes_to_load = !!task_contributes_to_load(p);
>
>        /*
>         * In order to serialize against other tasks wanting to task_rq_lock()
>         * we need to wait until the current task_rq(p)->lock holder goes away,
>         * so that the next might observe TASK_WAKING.
>         */
>        p->state = TASK_WAKING;
>        smp_wmb();
>        raw_spin_unlock_wait(&task_rq(p)->lock);
>
>        /*
>         * Stable, now that TASK_WAKING is visible.
>         */
>        cpu = task_cpu(p);
>
> #ifdef CONFIG_SMP
>        /*
>         * Catch the case where schedule() has done the dequeue but hasn't yet
>         * scheduled to a new task, in that case p is still being referenced
>         * by that cpu so we cannot wake it to any other cpu.
>         *
>         * Here we must either do a full remote enqueue, or simply wait for
>         * the remote cpu to finish the schedule(), the latter was found to
>         * be cheapest.
>         */
>        while (p->oncpu)
>                cpu_relax();
>
>        if (p->sched_class->task_waking)
>                p->sched_class->task_waking(p);
>
>        cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
> #endif
>        ttwu_queue(p, cpu);
>        ttwu_stat(p, cpu, wake_flags);
> unlock:
>        raw_spin_unlock_irqrestore(&p->pi_lock, flags);
>
>        return ret;
> }
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself.
