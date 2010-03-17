Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0CQDn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 23:43:56 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:51870 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab0CQDny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 23:43:54 -0400
Date: Tue, 16 Mar 2010 19:26:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] rcu: local_irq_disable() also delimits RCU_SCHED
	read-site critical sections
Message-ID: <20100317022648.GA7049@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4B9F66E1.2060309@cn.fujitsu.com> <20100316132156.GC6709@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316132156.GC6709@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 06:21:56AM -0700, Paul E. McKenney wrote:
> On Tue, Mar 16, 2010 at 07:09:21PM +0800, Lai Jiangshan wrote:
> > It is documented that local_irq_disable() also delimits
> > RCU_SCHED read-site critical sections.
> > See the document of synchronize_sched() or
> > Documentation/RCU/whatisRCU.txt.
> > 
> > So we have to test irqs_disabled() in rcu_read_lock_sched_held().
> > Otherwise rcu-lockdep brings incorrect complaint.
> 
> Interesting -- I was under the impression that preempt_count() covered
> this as well, due to the following in include/linux/hardirq.h:
> 
> 	#define PREEMPT_MASK    (__IRQ_MASK(PREEMPT_BITS) << PREEMPT_SHIFT)
> 	#define SOFTIRQ_MASK    (__IRQ_MASK(SOFTIRQ_BITS) << SOFTIRQ_SHIFT)
> 	#define HARDIRQ_MASK    (__IRQ_MASK(HARDIRQ_BITS) << HARDIRQ_SHIFT)
> 	#define NMI_MASK        (__IRQ_MASK(NMI_BITS)     << NMI_SHIFT)
> 
> But irqs_disabled() does look to sample the actual interrupt hardware.
> 
> So, if there are cases where RCU is used where the interrupt hardware
> is disabled, but preempt_count() has not been updated, this patch is
> the right thing to do.

In light of later emails in this thread, first a big "thank you!!!"
to Lai, and I will pull this one in.  Good stuff!!!

							Thanx, Paul

> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > ---
> > diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> > index 3024050..2ce5674 100644
> > --- a/include/linux/rcupdate.h
> > +++ b/include/linux/rcupdate.h
> > @@ -160,7 +160,7 @@ static inline int rcu_read_lock_sched_held(void)
> >  		return 1;
> >  	if (debug_locks)
> >  		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
> > -	return lockdep_opinion || preempt_count() != 0;
> > +	return lockdep_opinion || preempt_count() != 0 || irqs_disabled();
> >  }
> >  #else /* #ifdef CONFIG_PREEMPT */
> >  static inline int rcu_read_lock_sched_held(void)
> > @@ -191,7 +191,7 @@ static inline int rcu_read_lock_bh_held(void)
> >  #ifdef CONFIG_PREEMPT
> >  static inline int rcu_read_lock_sched_held(void)
> >  {
> > -	return !rcu_scheduler_active || preempt_count() != 0;
> > +	return !rcu_scheduler_active || preempt_count() != 0 || irqs_disabled();
> >  }
> >  #else /* #ifdef CONFIG_PREEMPT */
> >  static inline int rcu_read_lock_sched_held(void)
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
