Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994Ab2FPBB6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 21:01:58 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53893 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948Ab2FPBB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 21:01:57 -0400
Date: Fri, 15 Jun 2012 18:01:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 13/15] rcu: Introduce for_each_rcu_flavor()
 and use it
Message-ID: <20120616010149.GW2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1339794370-28119-13-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615235239.GE7613@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615235239.GE7613@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061601-5518-0000-0000-00000535DB4D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 04:52:40PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 02:06:08PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The arrival of TREE_PREEMPT_RCU some years back included some ugly
> > code involving either #ifdef or #ifdef'ed wrapper functions to iterate
> > over all non-SRCU flavors of RCU.  This commit therefore introduces
> > a for_each_rcu_flavor() iterator over the rcu_state structures for each
> > flavor of RCU to clean up a bit of the ugliness.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Great cleanup!
> 
> A few comments below, though.
> 
> >  kernel/rcutree.c        |   53 +++++++++++++---------
> >  kernel/rcutree.h        |   12 ++---
> >  kernel/rcutree_plugin.h |  116 -----------------------------------------------
> >  3 files changed, 36 insertions(+), 145 deletions(-)
> 
> Awesome diffstat.

;-)

> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index bd4e41c..75ad92a 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -84,6 +84,7 @@ struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh, call_rcu_bh);
> >  DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
> >  
> >  static struct rcu_state *rcu_state;
> > +LIST_HEAD(rcu_struct_flavors);
> 
> Does any means exist to turn this into a constant array known at compile
> time rather than a runtime linked list?  Having this as a compile-time
> constant may allow the compiler to unroll for_each_rcu_flavor and
> potentially inline the calls inside it.

I could do that, but none of the traversals is anywhere near performance
critical, and all the ways I can think of to do this are uglier than
the list.

> > @@ -2539,9 +2548,10 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptible)
> >  
> >  static void __cpuinit rcu_prepare_cpu(int cpu)
> >  {
> > -	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
> > -	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
> > -	rcu_preempt_init_percpu_data(cpu);
> > +	struct rcu_state *rsp;
> > +
> > +	for_each_rcu_flavor(rsp)
> > +		rcu_init_percpu_data(cpu, rsp, 0);
> 
> This results in passing 0 as the "preemptible" parameter of
> rcu_init_percpu_data, which seems wrong if the preemptible parameter has
> any meaning at all. :)

Good catch!  Hmmm...  Probably best to move this to the rcu_state
initialization.

> > @@ -2577,18 +2588,15 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> >  		 * touch any data without introducing corruption. We send the
> >  		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
> >  		 */
> > -		rcu_cleanup_dying_cpu(&rcu_bh_state);
> > -		rcu_cleanup_dying_cpu(&rcu_sched_state);
> > -		rcu_preempt_cleanup_dying_cpu();
> > -		rcu_cleanup_after_idle(cpu);
> > +		for_each_rcu_flavor(rsp)
> > +			rcu_cleanup_dying_cpu(rsp);
> 
> Why did rcu_cleanup_after_idle go away here?

Because I fat-fingered it.  Thank you very much for spotting this.  It
would have been nasty to find otherwise.

							Thanx, Paul

