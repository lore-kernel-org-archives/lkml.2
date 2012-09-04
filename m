Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab2IDXDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 19:03:44 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33122 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757871Ab2IDXDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 19:03:43 -0400
Date: Tue, 4 Sep 2012 16:03:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH tip/core/rcu 13/15] rcu: Move TINY_PREEMPT_RCU away from
 raw_local_irq_save()
Message-ID: <20120904230325.GV2593@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1346352988-32444-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120831183431.GK4259@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120831183431.GK4259@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090423-7606-0000-0000-000003599EE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 11:34:31AM -0700, Josh Triplett wrote:
> On Thu, Aug 30, 2012 at 11:56:26AM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> > 
> > The use of raw_local_irq_save() is unnecessary, given that local_irq_save()
> > really does disable interrupts.  Also, it appears to interfere with lockdep.
> > Therefore, this commit moves to local_irq_save().
> 
> It looks like the non-raw versions also include tracing, which typically
> has recursive dependency problems with RCU.  Can all of these call sites
> safely call into tracing without recursing back into RCU?

The rcu_trace_sub_qlen() version is the most suspicious, but it is the
one that Fengguang found to be causing the problem:

	https://lkml.org/lkml/2012/8/21/551

							Thanx, Paul

> - Josh Triplett
> 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> > ---
> >  kernel/rcutiny_plugin.h |   10 +++++-----
> >  1 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> > index 918fd1e..3d01902 100644
> > --- a/kernel/rcutiny_plugin.h
> > +++ b/kernel/rcutiny_plugin.h
> > @@ -278,7 +278,7 @@ static int rcu_boost(void)
> >  	    rcu_preempt_ctrlblk.exp_tasks == NULL)
> >  		return 0;  /* Nothing to boost. */
> >  
> > -	raw_local_irq_save(flags);
> > +	local_irq_save(flags);
> >  
> >  	/*
> >  	 * Recheck with irqs disabled: all tasks in need of boosting
> > @@ -287,7 +287,7 @@ static int rcu_boost(void)
> >  	 */
> >  	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
> >  	    rcu_preempt_ctrlblk.exp_tasks == NULL) {
> > -		raw_local_irq_restore(flags);
> > +		local_irq_restore(flags);
> >  		return 0;
> >  	}
> >  
> > @@ -317,7 +317,7 @@ static int rcu_boost(void)
> >  	t = container_of(tb, struct task_struct, rcu_node_entry);
> >  	rt_mutex_init_proxy_locked(&mtx, t);
> >  	t->rcu_boost_mutex = &mtx;
> > -	raw_local_irq_restore(flags);
> > +	local_irq_restore(flags);
> >  	rt_mutex_lock(&mtx);
> >  	rt_mutex_unlock(&mtx);  /* Keep lockdep happy. */
> >  
> > @@ -991,9 +991,9 @@ static void rcu_trace_sub_qlen(struct rcu_ctrlblk *rcp, int n)
> >  {
> >  	unsigned long flags;
> >  
> > -	raw_local_irq_save(flags);
> > +	local_irq_save(flags);
> >  	rcp->qlen -= n;
> > -	raw_local_irq_restore(flags);
> > +	local_irq_restore(flags);
> >  }
> >  
> >  /*
> > -- 
> > 1.7.8
> > 
> 

