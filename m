Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292Ab2FOWYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:24:52 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48715 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab2FOWYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:24:51 -0400
Date: Fri, 15 Jun 2012 15:24:42 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 03/14] rcu: Add ACCESS_ONCE() to ->qlen
 accesses
Message-ID: <20120615222442.GO2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615201256.GA26120@linux.vnet.ibm.com>
 <1339791195-26389-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339791195-26389-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615204500.GH31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615204500.GH31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061522-1780-0000-0000-0000067CA370
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000281; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000002; SDB=6.00148371; UDB=6.00033818; UTC=2012-06-15
 22:24:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 01:45:00PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 01:13:04PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The _rcu_barrier() function accesses other CPUs' rcu_data structure's
> > ->qlen field without benefit of locking.  This commit therefore adds
> > the required ACCESS_ONCE() wrappers around accesses and updates that
> > need it.
> 
> This type of restriction makes me wonder if we could add some kind of
> attribute to fields like qlen to make GCC or sparse help enforce this.

It is worth thinking about.  Should spark some spirited discussions.  ;-)

> > ACCESS_ONCE() is not needed when a CPU accesses its own ->qlen, or
> > in code that cannot run while _rcu_barrier() is sampling ->qlen fields.
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you!

							Thanx, Paul

> >  kernel/rcutree.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index d938671..cdc101e 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1349,7 +1349,7 @@ rcu_send_cbs_to_orphanage(int cpu, struct rcu_state *rsp,
> >  		rsp->qlen += rdp->qlen;
> >  		rdp->n_cbs_orphaned += rdp->qlen;
> >  		rdp->qlen_lazy = 0;
> > -		rdp->qlen = 0;
> > +		ACCESS_ONCE(rdp->qlen) = 0;
> >  	}
> >  
> >  	/*
> > @@ -1597,7 +1597,7 @@ static void rcu_do_batch(struct rcu_state *rsp, struct rcu_data *rdp)
> >  	}
> >  	smp_mb(); /* List handling before counting for rcu_barrier(). */
> >  	rdp->qlen_lazy -= count_lazy;
> > -	rdp->qlen -= count;
> > +	ACCESS_ONCE(rdp->qlen) -= count;
> >  	rdp->n_cbs_invoked += count;
> >  
> >  	/* Reinstate batch limit if we have worked down the excess. */
> > @@ -1886,7 +1886,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> >  	rdp = this_cpu_ptr(rsp->rda);
> >  
> >  	/* Add the callback to our list. */
> > -	rdp->qlen++;
> > +	ACCESS_ONCE(rdp->qlen)++;
> >  	if (lazy)
> >  		rdp->qlen_lazy++;
> >  	else
> > @@ -2420,7 +2420,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
> >  	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
> >  	init_callback_list(rdp);
> >  	rdp->qlen_lazy = 0;
> > -	rdp->qlen = 0;
> > +	ACCESS_ONCE(rdp->qlen) = 0;
> >  	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
> >  	WARN_ON_ONCE(rdp->dynticks->dynticks_nesting != DYNTICK_TASK_EXIT_IDLE);
> >  	WARN_ON_ONCE(atomic_read(&rdp->dynticks->dynticks) != 1);
> > -- 
> > 1.7.8
> > 
> 

