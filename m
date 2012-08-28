Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468Ab2H1R6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:58:04 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42772 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab2H1R6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:58:01 -0400
Date: Tue, 28 Aug 2012 10:07:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Add rq->nr_uninterruptible count to dest cpu's rq while CPU goes
 down.
Message-ID: <20120828170734.GT2961@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1345128138.29668.42.camel@twins>
 <CADZ9YHjzNVz6nSqbnTgVYfwi2hz0KYuXC89GHw6UjL2GyGZ64A@mail.gmail.com>
 <1345139199.29668.46.camel@twins>
 <CADZ9YHgNhTGWicX0kFfrNoL17JkxfZcXryqqa-wHLVLh05SvAg@mail.gmail.com>
 <1345454817.23018.27.camel@twins>
 <20120820162657.GI2435@linux.vnet.ibm.com>
 <20120827184435.GA13883@linux.vnet.ibm.com>
 <CADZ9YHi-DGd71jxQpYyRfVUqdr-ks-znSeCtcBAccL7wRd3r5g@mail.gmail.com>
 <20120828134206.GH2961@linux.vnet.ibm.com>
 <CADZ9YHhXspOy9cy--cPqzaZYssDjgwRPztU=pg-Rfj5g2aXDiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADZ9YHhXspOy9cy--cPqzaZYssDjgwRPztU=pg-Rfj5g2aXDiw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082817-5930-0000-0000-00000B55D668
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 10:52:45PM +0600, Rakib Mullick wrote:
> On 8/28/12, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Aug 28, 2012 at 12:57:09PM +0600, Rakib Mullick wrote:
> >> Hello Paul,
> >>
> >> On 8/28/12, Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >> > On Mon, Aug 20, 2012 at 09:26:57AM -0700, Paul E. McKenney wrote:
> >> >> On Mon, Aug 20, 2012 at 11:26:57AM +0200, Peter Zijlstra wrote:
> >> >
> >> > How about the following updated patch?
> >> >
> >> Actually, I was waiting for Peter's update.
> >
> > I was too, but chatted with Peter.
> >
> >> > 							Thanx, Paul
> >> >
> >> > ------------------------------------------------------------------------
> >> >
> >> > sched: Fix load avg vs cpu-hotplug
> >> >
> >> > Rabik and Paul reported two different issues related to the same few
> >> > lines of code.
> >> >
> >> > Rabik's issue is that the nr_uninterruptible migration code is wrong in
> >> > that he sees artifacts due to this (Rabik please do expand in more
> >> > detail).
> >> >
> >> > Paul's issue is that this code as it stands relies on us using
> >> > stop_machine() for unplug, we all would like to remove this assumption
> >> > so that eventually we can remove this stop_machine() usage altogether.
> >> >
> >> > The only reason we'd have to migrate nr_uninterruptible is so that we
> >> > could use for_each_online_cpu() loops in favour of
> >> > for_each_possible_cpu() loops, however since nr_uninterruptible() is
> >> > the
> >> > only such loop and its using possible lets not bother at all.
> >> >
> >> > The problem Rabik sees is (probably) caused by the fact that by
> >> > migrating nr_uninterruptible we screw rq->calc_load_active for both rqs
> >> > involved.
> >> >
> >> > So don't bother with fancy migration schemes (meaning we now have to
> >> > keep using for_each_possible_cpu()) and instead fold any nr_active
> >> > delta
> >> > after we migrate all tasks away to make sure we don't have any skewed
> >> > nr_active accounting.
> >> >
> >> > [ paulmck: Move call to calc_load_migration to CPU_DEAD to avoid
> >> > miscounting noted by Rakib. ]
> >> >
> >> > Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
> >> > Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> >> >
> >> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >> > index e841dfc..a8807f2 100644
> >> > --- a/kernel/sched/core.c
> >> > +++ b/kernel/sched/core.c
> >> > @@ -5309,27 +5309,17 @@ void idle_task_exit(void)
> >> >  }
> >> >
> >> >  /*
> >> > - * While a dead CPU has no uninterruptible tasks queued at this point,
> >> > - * it might still have a nonzero ->nr_uninterruptible counter, because
> >> > - * for performance reasons the counter is not stricly tracking tasks
> >> > to
> >> > - * their home CPUs. So we just add the counter to another CPU's
> >> > counter,
> >> > - * to keep the global sum constant after CPU-down:
> >> > - */
> >> > -static void migrate_nr_uninterruptible(struct rq *rq_src)
> >> > -{
> >> > -	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
> >> > -
> >> > -	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
> >> > -	rq_src->nr_uninterruptible = 0;
> >> > -}
> >> > -
> >> > -/*
> >> > - * remove the tasks which were accounted by rq from calc_load_tasks.
> >> > + * Since this CPU is going 'away' for a while, fold any nr_active
> >> > delta
> >> > + * we might have. Assumes we're called after migrate_tasks() so that
> >> > the
> >> > + * nr_active count is stable.
> >> > + *
> >> > + * Also see the comment "Global load-average calculations".
> >> >   */
> >> > -static void calc_global_load_remove(struct rq *rq)
> >> > +static void calc_load_migrate(struct rq *rq)
> >> >  {
> >> > -	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
> >> > -	rq->calc_load_active = 0;
> >> > +	long delta = calc_load_fold_active(rq);
> >> > +	if (delta)
> >> > +		atomic_long_add(delta, &calc_load_tasks);
> >> >  }
> >> >
> >> >  /*
> >> > @@ -5622,9 +5612,18 @@ migration_call(struct notifier_block *nfb,
> >> > unsigned
> >> > long action, void *hcpu)
> >> >  		migrate_tasks(cpu);
> >> >  		BUG_ON(rq->nr_running != 1); /* the migration thread */
> >> >  		raw_spin_unlock_irqrestore(&rq->lock, flags);
> >> > +		break;
> >> >
> >> > -		migrate_nr_uninterruptible(rq);
> >> > -		calc_global_load_remove(rq);
> >> > +	case CPU_DEAD:
> >> > +		{
> >> > +			struct rq *dest_rq;
> >> > +
> >> > +			local_irq_save(flags);
> >> > +			dest_rq = cpu_rq(smp_processor_id());
> >>
> >> Use of smp_processor_id() as dest cpu isn't clear to me, this
> >> processor is about to get down, isn't it?
> >
> > Nope.  The CPU_DEAD notifier happens after the outgoing CPU has been
> > fully offlined, and so it must run on some other CPU.
> >
> >> > +			raw_spin_lock(&dest_rq->lock);
> >> > +			calc_load_migrate(rq);
> >>
> >> Well, calc_load_migrate() has no impact cause rq->nr_running == 1 at
> >> this point. It's been already pointed out previously.
> >
> > Even after the outgoing CPU is fully gone?  I would hope that the value
> > would be zero.
> >
> Perhaps, yes and it doesn't make any difference. And so, at this point
> doing calc_load_migrate()... I'm not sure. But, I'm sure that, this is
> not what I had in my mind.
> 
> The patch I sent it was to move rq->nr_uninterruptible to the dest_rq
> where all the tasks were moved. Then, Peter says that patch isn't
> correct, cause tasks might get spread out amongst more than one CPU
> due to tasks affinity (*if* task was affined). But, we can easily
> expect that, admin is smart enough to not put a CPU offline, where
> s/he put a task to explicitly run on. I agree that, my patch isn't
> 100% correct but it's better than current which is almost 100% wrong
> which picks up a random CPU-rq to move rq->nr_uninterruptible count.
> So, simply moving ->nr_uninterruptible to dest_rq (where tasks were
> moved) should be fine. And when dest_rq's time will come to go idle
> i.e calc_load_enter_idle() or calc_load_account_active() (if no_hz=n),
> active count will get folded, we do not need to explicitly fold
> nr_active count when CPU is going to die.

OK, but I thought that Peter said that ->nr_uninterruptible was
meaningful only when summed across all CPUs.  If that is the case,
it shouldn't matter where the counts are moved.

(I am not all that worried about the exact form of the patch, as long
as it allows us to get rid of the __stop_machine() in CPU offlining.)

							Thanx, Paul

