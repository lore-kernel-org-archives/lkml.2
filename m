Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab1ELJrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 05:47:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39390 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567Ab1ELJrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 05:47:08 -0400
Date: Thu, 12 May 2011 02:47:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
Message-ID: <20110512094704.GL2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <6921.1304989476@localhost>
 <20110510082029.GF2258@linux.vnet.ibm.com>
 <34783.1305155494@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34783.1305155494@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 07:11:34PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 10 May 2011 01:20:29 PDT, "Paul E. McKenney" said:
> 
> Would test, but it doesn't apply cleanly to my -mmotm0506 tree:
> 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 5616b17..20c22c5 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -1525,13 +1525,15 @@ static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
> >   */
> >  static void rcu_cpu_kthread_timer(unsigned long arg)
> >  {
> > -	unsigned long flags;
> > +	unsigned long old;
> > +	unsigned long new;
> >  	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, arg);
> >  	struct rcu_node *rnp = rdp->mynode;
> >  
> > -	raw_spin_lock_irqsave(&rnp->lock, flags);
> > -	rnp->wakemask |= rdp->grpmask;
> > -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +	do {
> > +		old = rnp->wakemask;
> > +		new = old | rdp->grpmask;
> > +	} while (cmpxchg(&rnp->wakemask, old, new) != old);
> >  	invoke_rcu_node_kthread(rnp);
> >  }
> 
> My source has this:
> 
>         raw_spin_lock_irqsave(&rnp->lock, flags);
>         rnp->wakemask |= rdp->grpmask;
>         invoke_rcu_node_kthread(rnp);
>         raw_spin_unlock_irqrestore(&rnp->lock, flags);
> 
> the last 2 lines swapped from what you diffed against.  I can easily work around
> that, except it's unclear what the implications of the invoke_rcu moving outside
> of the irq save/restore pair (or if it being inside is the actual root cause)...

Odd...

This looks to me like a recent -next -- I do not believe that straight
mmotm has rcu_cpu_kthread_timer() in it.  The patch should apply to the
last few days' -next kernels.

							Thanx, Paul
