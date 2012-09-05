Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125Ab2IESTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 14:19:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44925 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab2IESTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 14:19:32 -0400
Date: Wed, 5 Sep 2012 11:19:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 16/23] rcu: Prevent initialization-time
 quiescent-state race
Message-ID: <20120905181920.GN3308@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830181811.GA29154@linux.vnet.ibm.com>
 <1346350718-30937-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346350718-30937-16-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120903093742.GE5574@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120903093742.GE5574@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090518-4242-0000-0000-000002CB345B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 02:37:42AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:18:31AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Now the the grace-period initialization procedure is preemptible, it is
> > subject to the following race on systems whose rcu_node tree contains
> > more than one node:
> > 
> > 1.	CPU 31 starts initializing the grace period, including the
> > 	first leaf rcu_node structures, and is then preempted.
> > 
> > 2.	CPU 0 refers to the first leaf rcu_node structure, and notes
> > 	that a new grace period has started.  It passes through a
> > 	quiescent state shortly thereafter, and informs the RCU core
> > 	of this rite of passage.
> > 
> > 3.	CPU 0 enters an RCU read-side critical section, acquiring
> > 	a pointer to an RCU-protected data item.
> > 
> > 4.	CPU 31 removes the data item referenced by CPU 0 from the
> > 	data structure, and registers an RCU callback in order to
> > 	free it.
> > 
> > 5.	CPU 31 resumes initializing the grace period, including its
> > 	own rcu_node structure.  In invokes rcu_start_gp_per_cpu(),
> > 	which advances all callbacks, including the one registered
> > 	in #4 above, to be handled by the current grace period.
> > 
> > 6.	The remaining CPUs pass through quiescent states and inform
> > 	the RCU core, but CPU 0 remains in its RCU read-side critical
> > 	section, still referencing the now-removed data item.
> > 
> > 7.	The grace period completes and all the callbacks are invoked,
> > 	including the one that frees the data item that CPU 0 is still
> > 	referencing.  Oops!!!
> > 
> > This commit therefore moves the callback handling to precede initialization
> > of any of the rcu_node structures, thus avoiding this race.
> 
> I don't think it makes sense to introduce and subsequently fix a race in
> the same patch series. :)
> 
> Could you squash this patch into the one moving grace-period
> initialization into a kthread?

I tried that, and got a surprisingly large set of conflicts.  Ah, OK,
the problem is that breaking up rcu_gp_kthread() into subfunctions
did enough code motion to defeat straightforward rebasing.  Is there
some way to tell "git rebase" about such code motion, or would this
need to be carried out carefully by hand?

							Thanx, Paul

> - Josh Triplett
> 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |   33 +++++++++++++++++++--------------
> >  1 files changed, 19 insertions(+), 14 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 55f20fd..d435009 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1028,20 +1028,6 @@ rcu_start_gp_per_cpu(struct rcu_state *rsp, struct rcu_node *rnp, struct rcu_dat
> >  	/* Prior grace period ended, so advance callbacks for current CPU. */
> >  	__rcu_process_gp_end(rsp, rnp, rdp);
> >  
> > -	/*
> > -	 * Because this CPU just now started the new grace period, we know
> > -	 * that all of its callbacks will be covered by this upcoming grace
> > -	 * period, even the ones that were registered arbitrarily recently.
> > -	 * Therefore, advance all outstanding callbacks to RCU_WAIT_TAIL.
> > -	 *
> > -	 * Other CPUs cannot be sure exactly when the grace period started.
> > -	 * Therefore, their recently registered callbacks must pass through
> > -	 * an additional RCU_NEXT_READY stage, so that they will be handled
> > -	 * by the next RCU grace period.
> > -	 */
> > -	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> > -	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> > -
> >  	/* Set state so that this CPU will detect the next quiescent state. */
> >  	__note_new_gpnum(rsp, rnp, rdp);
> >  }
> > @@ -1068,6 +1054,25 @@ static int rcu_gp_init(struct rcu_state *rsp)
> >  	rsp->gpnum++;
> >  	trace_rcu_grace_period(rsp->name, rsp->gpnum, "start");
> >  	record_gp_stall_check_time(rsp);
> > +
> > +	/*
> > +	 * Because this CPU just now started the new grace period, we
> > +	 * know that all of its callbacks will be covered by this upcoming
> > +	 * grace period, even the ones that were registered arbitrarily
> > +	 * recently.    Therefore, advance all RCU_NEXT_TAIL callbacks
> > +	 * to RCU_NEXT_READY_TAIL.  When the CPU later recognizes the
> > +	 * start of the new grace period, it will advance all callbacks
> > +	 * one position, which will cause all of its current outstanding
> > +	 * callbacks to be handled by the newly started grace period.
> > +	 *
> > +	 * Other CPUs cannot be sure exactly when the grace period started.
> > +	 * Therefore, their recently registered callbacks must pass through
> > +	 * an additional RCU_NEXT_READY stage, so that they will be handled
> > +	 * by the next RCU grace period.
> > +	 */
> > +	rdp = __this_cpu_ptr(rsp->rda);
> > +	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
> > +
> >  	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> >  
> >  	/* Exclude any concurrent CPU-hotplug operations. */
> > -- 
> > 1.7.8
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

