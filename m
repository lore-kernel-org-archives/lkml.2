Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab1LEQs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 11:48:59 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56065 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932491Ab1LEQs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 11:48:58 -0500
Date: Mon, 5 Dec 2011 08:45:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111205164505.GB2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205091924.GA28117@zhy>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120516-1976-0000-0000-00000843352D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 05:19:24PM +0800, Yong Zhang wrote:
> On Sat, Dec 03, 2011 at 10:34:42AM -0800, Paul E. McKenney wrote:
> > From: Yong Zhang <yong.zhang0@gmail.com>
> > 
> > RCU-lockdep will issue warnings given the following use pattern:
> > 
> > 	rcu_read_lock();
> > 	local_irq_disable();
> > 	rcu_read_unlock();
> > 	local_irq_enable();
> > 
> > However, this use pattern is legal except for the scheduler's runqueue
> > and priority-inheritance locks (and any other locks that the scheduler
> > might use during priority-inheritance operations).
> > 
> > Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |    8 ++++++--
> >  1 files changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 8cd9efe..2020e8a 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -401,8 +401,11 @@ static noinline void rcu_read_unlock_special(struct task_struct *t)
> >  
> >  #ifdef CONFIG_RCU_BOOST
> >  		/* Unboost if we were boosted. */
> > -		if (rbmp)
> > +		if (rbmp) {
> > +			local_irq_save(flags);
> >  			rt_mutex_unlock(rbmp);
> > +			local_irq_restore(flags);
> > +		}
> >  #endif /* #ifdef CONFIG_RCU_BOOST */
> >  
> >  		/*
> > @@ -1233,9 +1236,10 @@ static int rcu_boost(struct rcu_node *rnp)
> >  	lockdep_set_class_and_name(&mtx.wait_lock, &rcu_boost_class,
> >  				   "rcu_boost_mutex");
> >  	t->rcu_boost_mutex = &mtx;
> > -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> > +	raw_spin_unlock(&rnp->lock); /* rrupts remain disabled. */
> >  	rt_mutex_lock(&mtx);  /* Side effect: boosts task t's priority. */
> >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> 
> We permit rt_mutex_unlock() to be call with irq disabled,
> but rt_mutex_lock() is still not allowed. So this usage
> is not legal now.

Even after commit #5342e269b has been applied?  The purpose of that
commit was to allow rt_mutex_lock() to be called with irqs disabled.

So, what am I missing?

						Thanx, Paul

> Sounds we should hold this patch on until a more suitable
> way is found.
> 
> Thanks,
> Yong
> 
> > +	local_irq_restore(flags);
> >  
> >  	return rnp->exp_tasks != NULL || rnp->boost_tasks != NULL;
> >  }
> > -- 
> > 1.7.3.2
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> Only stand for myself
> 

