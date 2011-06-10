Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab1FJTfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 15:35:20 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46778 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489Ab1FJTfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 15:35:18 -0400
Date: Fri, 10 Jun 2011 12:35:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 03/28] rcu: Streamline code produced by
 __rcu_read_unlock()
Message-ID: <20110610193511.GI2230@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110608192943.GA13211@linux.vnet.ibm.com>
 <1307561407-13809-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <4DF1C455.2080706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF1C455.2080706@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 03:14:29PM +0800, Lai Jiangshan wrote:
> On 06/09/2011 03:29 AM, Paul E. McKenney wrote:
> > Given some common flag combinations, particularly -Os, gcc will inline
> > rcu_read_unlock_special() despite its being in an unlikely() clause.
> > Use noline to prohibit this misoptimization.
> > 
> > In addition, move the second barrier() in __rcu_read_unlock() so that
> > it is not on the common-case code path.  This will allow the compiler to
> > generate better code for the common-case path through __rcu_read_unlock().
> > 
> > Finally, fix up whitespace in kernel/lockdep.c to keep checkpatch happy.
> > 
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree_plugin.h |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index ea2e2fb..40a6db7 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -284,7 +284,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
> >   * notify RCU core processing or task having blocked during the RCU
> >   * read-side critical section.
> >   */
> > -static void rcu_read_unlock_special(struct task_struct *t)
> > +static noinline void rcu_read_unlock_special(struct task_struct *t)
> >  {
> >  	int empty;
> >  	int empty_exp;
> > @@ -387,11 +387,11 @@ void __rcu_read_unlock(void)
> >  	struct task_struct *t = current;
> >  
> >  	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> > -	--t->rcu_read_lock_nesting;
> > -	barrier();  /* decrement before load of ->rcu_read_unlock_special */
> > -	if (t->rcu_read_lock_nesting == 0 &&
> > -	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > -		rcu_read_unlock_special(t);
> > +	if (--t->rcu_read_lock_nesting == 0) {
> 
> > +		barrier();  /* decr before ->rcu_read_unlock_special load */
> 
> Since ACCESS_ONCE() is used for loading ->rcu_read_unlock_special, is the previous
> barrier() still needed?

It doesn't really matter until we can inline __rcu_read_unlock(), but
hopefully that day is coming soon.  So...

The concern is for cases where the compiler can see __rcu_read_lock() and
__rcu_read_unlock().  The compiler would then be within its rights to
cancel the increments and decrements of t->rcu_read_lock_nesting against
each other, which could turn a loop containing an RCU read-side critical
section into one big long critical section.

We could do --ACCESS_ONCE(t->rcu_read_lock_nesting), but that generates
lousy code on x86.  So, is there a way to make the compiler forget only
about t->rcu_read_lock_nesting rather than about all variables?

							Thanx, Paul

> > +		if (unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> > +			rcu_read_unlock_special(t);
> > +	}
> >  #ifdef CONFIG_PROVE_LOCKING
> >  	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> >  #endif /* #ifdef CONFIG_PROVE_LOCKING */
> 
