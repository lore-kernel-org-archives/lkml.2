Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2I0MYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:24:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58233 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574Ab2I0MY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:24:28 -0400
Date: Thu, 27 Sep 2012 05:24:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paul.mckenney@linaro.org, rakib.mullick@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] sched: Fix load avg vs cpu-hotplug
Message-ID: <20120927122408.GB6556@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-5d18023294abc22984886bd7185344e0c2be0daf@git.kernel.org>
 <1348734171.3292.6.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348734171.3292.6.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092712-2876-0000-0000-00000088AAF8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 10:22:51AM +0200, Peter Zijlstra wrote:
> On Wed, 2012-09-26 at 22:12 -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  5d18023294abc22984886bd7185344e0c2be0daf
> > Gitweb:     http://git.kernel.org/tip/5d18023294abc22984886bd7185344e0c2be0daf
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Mon, 20 Aug 2012 11:26:57 +0200
> > Committer:  Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > CommitDate: Sun, 23 Sep 2012 07:43:56 -0700
> > 
> > sched: Fix load avg vs cpu-hotplug
> > 
> > Rabik and Paul reported two different issues related to the same few
> > lines of code.
> > 
> > Rabik's issue is that the nr_uninterruptible migration code is wrong in
> > that he sees artifacts due to this (Rabik please do expand in more
> > detail).
> > 
> > Paul's issue is that this code as it stands relies on us using
> > stop_machine() for unplug, we all would like to remove this assumption
> > so that eventually we can remove this stop_machine() usage altogether.
> > 
> > The only reason we'd have to migrate nr_uninterruptible is so that we
> > could use for_each_online_cpu() loops in favour of
> > for_each_possible_cpu() loops, however since nr_uninterruptible() is the
> > only such loop and its using possible lets not bother at all.
> > 
> > The problem Rabik sees is (probably) caused by the fact that by
> > migrating nr_uninterruptible we screw rq->calc_load_active for both rqs
> > involved.
> > 
> > So don't bother with fancy migration schemes (meaning we now have to
> > keep using for_each_possible_cpu()) and instead fold any nr_active delta
> > after we migrate all tasks away to make sure we don't have any skewed
> > nr_active accounting.
> > 
> > [ paulmck: Move call to calc_load_migration to CPU_DEAD to avoid
> > miscounting noted by Rakib. ]
> > 
> > Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
> > Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > ---
> >  kernel/sched/core.c |   41 ++++++++++++++++++++---------------------
> >  1 files changed, 20 insertions(+), 21 deletions(-)
> > 
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index fbf1fd0..8c38b5e 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -5304,27 +5304,17 @@ void idle_task_exit(void)
> >  }
> >  
> >  /*
> > - * While a dead CPU has no uninterruptible tasks queued at this point,
> > - * it might still have a nonzero ->nr_uninterruptible counter, because
> > - * for performance reasons the counter is not stricly tracking tasks to
> > - * their home CPUs. So we just add the counter to another CPU's counter,
> > - * to keep the global sum constant after CPU-down:
> > - */
> > -static void migrate_nr_uninterruptible(struct rq *rq_src)
> > -{
> > -	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> > -
> > -	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
> > -	rq_src->nr_uninterruptible = 0;
> > -}
> > -
> > -/*
> > - * remove the tasks which were accounted by rq from calc_load_tasks.
> > + * Since this CPU is going 'away' for a while, fold any nr_active delta
> > + * we might have. Assumes we're called after migrate_tasks() so that the
> > + * nr_active count is stable.
> > + *
> > + * Also see the comment "Global load-average calculations".
> >   */
> > -static void calc_global_load_remove(struct rq *rq)
> > +static void calc_load_migrate(struct rq *rq)
> >  {
> > -	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
> > -	rq->calc_load_active = 0;
> > +	long delta = calc_load_fold_active(rq);
> > +	if (delta)
> > +		atomic_long_add(delta, &calc_load_tasks);
> >  }
> >  
> >  /*
> > @@ -5617,9 +5607,18 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		migrate_tasks(cpu);
> >  		BUG_ON(rq->nr_running != 1); /* the migration thread */
> >  		raw_spin_unlock_irqrestore(&rq->lock, flags);
> > +		break;
> >  
> > -		migrate_nr_uninterruptible(rq);
> > -		calc_global_load_remove(rq);
> > +	case CPU_DEAD:
> > +		{
> > +			struct rq *dest_rq;
> > +
> > +			local_irq_save(flags);
> > +			dest_rq = cpu_rq(smp_processor_id());
> > +			raw_spin_lock(&dest_rq->lock);
> > +			calc_load_migrate(rq);
> > +			raw_spin_unlock_irqrestore(&dest_rq->lock, flags);
> > +		}
> >  		break;
> >  #endif
> >  	}
> 
> 
> Huh, what is this patch doing??! Didn't we merge my version of this? 

Yep, it all got straightened out in the merge commit 593d1006
(Merge remote-tracking branch 'tip/core/rcu' into next.2012.09.25b).
After this merge commit, the code looks as follows:

		migrate_tasks(cpu);
		BUG_ON(rq->nr_running != 1); /* the migration thread */
		raw_spin_unlock_irqrestore(&rq->lock, flags);
		break;

	case CPU_DEAD:
		calc_load_migrate(rq);
		break;

Which is what you had in https://lkml.org/lkml/2012/9/5/585.  I am
not sure what happened to that patch, but as you can see from the
merge commit, it had not made it yet.

							Thanx, Paul

