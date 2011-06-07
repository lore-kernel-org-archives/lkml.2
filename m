Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1FGR0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 13:26:20 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50501 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456Ab1FGR0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 13:26:19 -0400
Date: Tue, 7 Jun 2011 10:26:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>, mingo@elte.hu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: remove rcu_read_lock from wake_affine
Message-ID: <20110607172606.GA2286@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110607101251.777.34547.stgit@IBM-009124035060.in.ibm.com>
 <1307442411.2322.246.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307442411.2322.246.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 12:26:51PM +0200, Peter Zijlstra wrote:
> On Tue, 2011-06-07 at 15:43 +0530, Nikunj A. Dadhania wrote:
> > wake_affine is called from one path: select_task_rq_fair, which already has
> > rcu read lock held.
> > 
> > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> > ---
> >  kernel/sched_fair.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index 354e26b..0bfec93 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -1461,6 +1461,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
> >  
> >  #endif
> >  
> > +/* Assumes rcu_read_lock is held */
> 
> Not a big fan of such comments, esp with CONFIG_PROVE_RCU its better to
> use those facilities, which is to say: if we're missing a
> rcu_read_lock() the thing will yell bloody murder.

Nikunj, one such approach is is "WARN_ON_ONCE(!rcu_read_lock_held())".

This will complain if this function is called without an rcu_read_lock()
in effect, but only if CONFIG_PROVE_RCU=y.

							Thanx, Paul

> >  static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  {
> >  	s64 this_load, load;
> > @@ -1481,7 +1482,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  	 * effect of the currently running task from the load
> >  	 * of the current CPU:
> >  	 */
> > -	rcu_read_lock();
> >  	if (sync) {
> >  		tg = task_group(current);
> >  		weight = current->se.load.weight;
> > @@ -1517,7 +1517,6 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
> >  		balanced = this_eff_load <= prev_eff_load;
> >  	} else
> >  		balanced = true;
> > -	rcu_read_unlock();
> >  
> >  	/*
> >  	 * If the currently running task will sleep within
> > 
> 
> OK, took the patch and removed the comment, thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
