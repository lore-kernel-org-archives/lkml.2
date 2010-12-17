Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0LQSP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 13:15:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:60967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab0LQSP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 13:15:56 -0500
Subject: Re: [RFC][PATCH 5/5] sched: Reduce ttwu rq->lock contention
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292607781.2266.295.camel@twins>
References: <20101216145602.899838254@chello.nl>
	 <20101216150920.968046926@chello.nl> <20101216184229.GA15889@redhat.com>
	 <1292525893.2708.50.camel@laptop> <1292526220.2708.55.camel@laptop>
	 <1292528874.2708.85.camel@laptop> <1292531553.2708.89.camel@laptop>
	 <20101217165414.GA8997@redhat.com>  <1292607781.2266.295.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 17 Dec 2010 19:15:40 +0100
Message-ID: <1292609740.2266.323.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 18:43 +0100, Peter Zijlstra wrote:
> 
> Hrmph, so is it only about serializing concurrent wakeups? If so, we
> could possibly hold p->pi_lock over the wakeup. 

Something like the below.. except it still suffers from the
__migrate_task() hole you identified in your other email.

By fully serializing all wakeups using ->pi_lock it becomes a lot
simpler (although I just realized we might have a problem with
try_to_wake_up_local).

static int
try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
{
        unsigned long flags;
        int cpu, ret = 0;

        smp_wmb();
        raw_spin_lock_irqsave(&p->pi_lock, flags);

        if (!(p->state & state))
                goto unlock;

        ret = 1; /* we qualify as a proper wakeup now */

        if (p->se.on_rq && ttwu_force(p, state, wake_flags))
                goto unlock;

        p->sched_contributes_to_load = !!task_contributes_to_load(p);

        /*
         * In order to serialize against other tasks wanting to task_rq_lock()
         * we need to wait until the current task_rq(p)->lock holder goes away,
         * so that the next might observe TASK_WAKING.
         */
        p->state = TASK_WAKING;
        smp_wmb();
        raw_spin_unlock_wait(&task_rq(p)->lock);

        /*
         * Stable, now that TASK_WAKING is visible.
         */
        cpu = task_cpu(p);

#ifdef CONFIG_SMP
        /*
         * Catch the case where schedule() has done the dequeue but hasn't yet
         * scheduled to a new task, in that case p is still being referenced
         * by that cpu so we cannot wake it to any other cpu.
         *
         * Here we must either do a full remote enqueue, or simply wait for
         * the remote cpu to finish the schedule(), the latter was found to
         * be cheapest.
         */
        while (p->oncpu)
                cpu_relax();

        if (p->sched_class->task_waking)
                p->sched_class->task_waking(p);

        cpu = select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
#endif
        ttwu_queue(p, cpu);
        ttwu_stat(p, cpu, wake_flags);
unlock:
        raw_spin_unlock_irqrestore(&p->pi_lock, flags);

        return ret;
}

