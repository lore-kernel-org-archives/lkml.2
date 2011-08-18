Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab1HRXBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 19:01:13 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56125 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab1HRXBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 19:01:12 -0400
Date: Thu, 18 Aug 2011 16:01:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.0-git15 Atomic scheduling in pidmap_init
Message-ID: <20110818230108.GG2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110817223735.GI2227@zod.bos.redhat.com>
 <20110817224916.GO2419@linux.vnet.ibm.com>
 <20110817230219.GJ2227@zod.bos.redhat.com>
 <20110817230641.GA7837@somewhere.redhat.com>
 <20110817231750.GK2227@zod.bos.redhat.com>
 <20110818183523.GD2325@linux.vnet.ibm.com>
 <20110818140034.668e8dea.akpm@linux-foundation.org>
 <20110818212334.GE2325@linux.vnet.ibm.com>
 <20110818215540.GA14098@linux.vnet.ibm.com>
 <20110818222108.GS2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110818222108.GS2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 06:21:08PM -0400, Josh Boyer wrote:
> On Thu, Aug 18, 2011 at 02:55:40PM -0700, Paul E. McKenney wrote:
> > And here is this patch ported to v3.1-rc2, FYI.
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > rcu: Avoid having just-onlined CPU resched itself when RCU is idle
> > 
> > CPUs set rdp->qs_pending when coming online to resolve races with
> > grace-period start.  However, this means that if RCU is idle, the
> > just-onlined CPU might needlessly send itself resched IPIs.  Adjust the
> > online-CPU initialization to avoid this, and also to correctly cause
> > the CPU to respond to the current grace period if needed.
> > 
> > This patch is believed to fix or otherwise suppress problems in
> > https://bugzilla.redhat.com/show_bug.cgi?id=726877, however, the
> > relationship is not apparent to this patch's author.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This is what has been in rawhide for a while now.
> 
> Tested-by: Josh Boyer <jwboyer@redhat.com>

Thank you, I have added your Tested-by.

							Thanx, Paul

> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index ba06207..6986d34 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1865,8 +1865,6 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
> >  
> >  	/* Set up local state, ensuring consistent view of global state. */
> >  	raw_spin_lock_irqsave(&rnp->lock, flags);
> > -	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
> > -	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
> >  	rdp->beenonline = 1;	 /* We have now been online. */
> >  	rdp->preemptible = preemptible;
> >  	rdp->qlen_last_fqs_check = 0;
> > @@ -1891,8 +1889,15 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
> >  		rnp->qsmaskinit |= mask;
> >  		mask = rnp->grpmask;
> >  		if (rnp == rdp->mynode) {
> > -			rdp->gpnum = rnp->completed; /* if GP in progress... */
> > +			/*
> > +			 * If there is a grace period in progress, we will
> > +			 * set up to wait for it next time we run the
> > +			 * RCU core code.
> > +			 */
> > +			rdp->gpnum = rnp->completed;
> >  			rdp->completed = rnp->completed;
> > +			rdp->passed_quiesc = 0;
> > +			rdp->qs_pending = 1;
> >  			rdp->passed_quiesc_completed = rnp->completed - 1;
> >  		}
> >  		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
