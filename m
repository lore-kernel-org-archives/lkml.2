Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab1AFK5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:57:11 -0500
Received: from canuck.infradead.org ([134.117.69.58]:33007 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1AFK5J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:57:09 -0500
Subject: Re: [RFC][PATCH 18/18] sched: Sort hotplug vs ttwu queueing
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Jens Axboe <axboe@kernel.dk>,
        Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110105204700.GA1313@redhat.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150103.214765376@chello.nl>  <20110105204700.GA1313@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 Jan 2011 11:56:58 +0100
Message-ID: <1294311418.2016.326.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 21:47 +0100, Oleg Nesterov wrote:
> On 01/04, Peter Zijlstra wrote:
> >
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +static void ttwu_queue_unplug(struct rq *rq)
> > +{
> > +	struct task_struct *p, *list = xchg(&rq->wake_list, NULL);
> > +	unsigned long flags;
> > +	int cpu;
> > +
> > +	if (!list)
> > +		return;
> > +
> > +	while (list) {
> > +		p = list;
> > +		list = list->wake_entry;
> > +
> > +		raw_spin_lock_irqsave(&p->pi_lock, flags);
> > +		cpu = select_task_rq(p, SD_BALANCE_WAKE, 0);
> > +		set_task_cpu(p, cpu);
> > +		ttwu_queue(p, cpu);
> > +		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> > +	}
> > +}
> > +#endif
> > +
> >  /**
> >   * try_to_wake_up - wake up a thread
> >   * @p: the thread to be awakened
> > @@ -6151,6 +6174,11 @@ migration_call(struct notifier_block *nf
> >  		migrate_nr_uninterruptible(rq);
> >  		calc_global_load_remove(rq);
> >  		break;
> > +
> > +	case CPU_DEAD:
> > +		ttwu_queue_unplug(cpu_rq(cpu));
> 
> I think this is not strictly needed...
> 
> Afaics, take_cpu_down() can simply call sched_ttwu_pending() at the
> start. This will activate the pending tasks on the (almost) dead
> cpu but we don't care, they will be migrated later.

At the end, __cpu_disable() is the one clearing all the cpu mask bits.
So we could call it from CPU_DYING I guess.

> When __stop_machine(take_cpu_down) returns nobody can use this CPU
> as a target, iow rq->wake_list can't be used again.

Right, so something like the below should suffice, I've folded that into
patch 17.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6129,6 +6129,7 @@ migration_call(struct notifier_block *nf
 
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_DYING:
+		sched_ttwu_pending();
 		/* Update our root-domain */
 		raw_spin_lock_irqsave(&rq->lock, flags);
 		if (rq->rd) {

