Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0CSAez (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:34:55 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40105 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411Ab0CSAex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:34:53 -0400
Date: Thu, 18 Mar 2010 20:34:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH tip/core/urgent 2/2] rcu: remove INIT_RCU_HEAD,
	RCU_HEAD_INIT, RCU_HEAD
Message-ID: <20100319003448.GA23020@Krystal>
References: <20100318192513.GA10832@linux.vnet.ibm.com> <1268940334-10892-2-git-send-email-paulmck@linux.vnet.ibm.com> <20100318193520.GB14283@Krystal> <20100318200317.GG2423@linux.vnet.ibm.com> <20100318202202.GA18657@Krystal> <20100318210432.GI2423@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100318210432.GI2423@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:29:45 up 55 days,  3:06,  5 users,  load average: 0.04, 0.06,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Thu, Mar 18, 2010 at 04:22:02PM -0400, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Thu, Mar 18, 2010 at 03:35:20PM -0400, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > From: Alexey Dobriyan <adobriyan@gmail.com>
> > > > > 
> > > > > call_rcu() will unconditionally reinitialize RCU head anyway.  New users
> > > > > of these macros constantly appear, so remove them.
> > > > 
> > > > Hrm. So do we have something that checks for double-use of a RCU head at
> > > > the moment ? (using call_rcu() twice on the same head without being
> > > > certain that the first callback have finished its execution).
> > > > 
> > > > I think that hiding rcu head initialization into call_rcu() is one more
> > > > step towards misuses that will silently corrupt rcu head lists. So I
> > > > think we should first add the double-use debugging option before we
> > > > remove the RCU head initializations.
> > > 
> > > So your thought is to have rcu_do_batch() do something like the
> > > following?
> > > 
> > > 	...
> > > 
> > > 	next = list->next;
> > > 	prefetch(next);
> > > 	list->next = RCU_HEAD_INIT_PTR;
> > > 	func = list->func;
> > > 	list->func = RCU_HEAD_INIT_PTR;
> > > 	func(list);
> > > 	... /* touching anything referenced by "list" is use-after-free. */
> > > 
> > > Then have __call_rcu() do something like the following before initializing
> > > the ->func and ->next pointers:
> > > 
> > > 	WARN_ON_ONCE(head->next != RCU_HEAD_INIT_PTR ||
> > > 		     head->func != RCU_HEAD_INIT_PTR);
> > > 
> > > And then require that all users of call_rcu() and friends use one of the
> > > RCU_INIT() macros?
> > > 
> > > Or did you have something else in mind?
> > 
> > More precisely poisoning an extra field of the rcu_head, as done in the
> > following patch.
> > 
> > I posted it a few months ago, but has been rejected on the ground that
> > it should be re-done in within the debug objects infrastructure.  But I
> > had to focus on other things and never found time to do these changes.
> > It needs a separate patch which adds missing INIT_RCU_HEAD() to a few
> > more kernel sites.
> 
> Indeed!
> 
> > The reason why I add a supplementary field for the poison is to be able
> > to warn for detection of incoherent list_head both in call_rcu and in
> > rcu_do_batch(), which does not seem possible with the scheme you propose
> > above. The sequence is:
> > 
> > init ->         debug = NULL
> > call_rcu ->     WARN_ON_ONCE(debug != NULL)
> >                 debug = LIST_POISON1
> > rcu_do_batch -> WARN_ON_ONCE(debug != LIST_POISON1)
> >                 debug = NULL
> > 
> > 
> > tree rcu: Add debug RCU head option
> > 
> > Poisoning the rcu_head callback list. Only for rcu tree for now.
> > 
> > Helps finding racy users of call_rcu(), which results in hangs because list
> > entries are overwritten and/or skipped.
> 
> This does look attractive!
> 
> Some comments below.
> 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > CC: mingo@elte.hu
> > CC: akpm@linux-foundation.org
> > ---
> >  include/linux/rcupdate.h |   11 +++++++++++
> >  include/net/dst.h        |    2 ++
> >  kernel/rcutree.c         |   10 ++++++++++
> >  lib/Kconfig.debug        |    9 +++++++++
> >  4 files changed, 32 insertions(+)
> > 
> > Index: linux-2.6-lttng/include/linux/rcupdate.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2009-11-22 20:25:49.000000000 -0500
> > +++ linux-2.6-lttng/include/linux/rcupdate.h	2009-11-22 22:11:48.000000000 -0500
> > @@ -49,6 +49,9 @@
> >  struct rcu_head {
> >  	struct rcu_head *next;
> >  	void (*func)(struct rcu_head *head);
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +	struct rcu_head *debug;
> > +#endif
> >  };
> > 
> >  /* Exported common interfaces */
> > @@ -77,11 +80,19 @@ extern int rcu_scheduler_active;
> >  #error "Unknown RCU implementation specified to kernel configuration"
> >  #endif
> > 
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL, .debug = NULL }
> > +#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> > +#define INIT_RCU_HEAD(ptr) do { \
> > +       (ptr)->next = NULL; (ptr)->func = NULL; (ptr)->debug = NULL; \
> > +} while (0)
> > +#else
> >  #define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
> >  #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> 
> RCU_HEAD() is identical in either case, so should be pulled out of the
> #ifdef, right?
> 

Yep. Will do.

> >  #define INIT_RCU_HEAD(ptr) do { \
> >         (ptr)->next = NULL; (ptr)->func = NULL; \
> >  } while (0)
> > +#endif
> > 
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  extern struct lockdep_map rcu_lock_map;
> > Index: linux-2.6-lttng/kernel/rcutree.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/rcutree.c	2009-11-22 21:38:56.000000000 -0500
> > +++ linux-2.6-lttng/kernel/rcutree.c	2009-11-22 22:10:49.000000000 -0500
> > @@ -39,6 +39,7 @@
> >  #include <asm/atomic.h>
> >  #include <linux/bitops.h>
> >  #include <linux/module.h>
> > +#include <linux/poison.h>
> >  #include <linux/completion.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/percpu.h>
> > @@ -1010,6 +1011,10 @@ static void rcu_do_batch(struct rcu_stat
> >  		next = list->next;
> >  		prefetch(next);
> >  		trace_rcu_tree_callback(list);
> > +#ifdef DEBUG_RCU_HEAD
> 
> This needs to be CONFIG_DEBUG_RCU_HEAD, right?
> 

Yes. I think this came from how the patch evolved (used a define before moving
to menus). Will fix.

> > +		WARN_ON_ONCE(list->debug != LIST_POISON1);
> > +		list->debug = NULL;
> > +#endif
> >  		list->func(list);
> >  		list = next;
> >  		if (++count >= rdp->blimit)
> > @@ -1291,6 +1296,11 @@ __call_rcu(struct rcu_head *head, void (
> >  	unsigned long flags;
> >  	struct rcu_data *rdp;
> > 
> > +#ifdef DEBUG_RCU_HEAD
> 
> Ditto here.
> 
> > +	WARN_ON_ONCE(head->debug);
> > +	head->debug = LIST_POISON1;
> > +#endif
> > +
> >  	head->func = func;
> >  	head->next = NULL;
> > 
> > Index: linux-2.6-lttng/lib/Kconfig.debug
> > ===================================================================
> > --- linux-2.6-lttng.orig/lib/Kconfig.debug	2009-11-22 22:01:03.000000000 -0500
> > +++ linux-2.6-lttng/lib/Kconfig.debug	2009-11-22 22:10:49.000000000 -0500
> > @@ -652,6 +652,15 @@ config DEBUG_LIST
> > 
> >  	  If unsure, say N.
> > 
> > +config DEBUG_RCU_HEAD
> > +	bool "Debug RCU callbacks"
> > +	depends on DEBUG_KERNEL
> > +	depends on TREE_RCU
> > +	help
> > +	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
> > +	  Seems to find problems more quickly with stress-tests in single-cpu
> > +	  mode.
> > +
> >  config DEBUG_SG
> >  	bool "Debug SG table operations"
> >  	depends on DEBUG_KERNEL
> > Index: linux-2.6-lttng/include/net/dst.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/net/dst.h	2009-11-22 20:25:49.000000000 -0500
> > +++ linux-2.6-lttng/include/net/dst.h	2009-11-22 22:10:49.000000000 -0500
> > @@ -154,7 +154,9 @@ static inline void dst_hold(struct dst_e
> >  	 * If your kernel compilation stops here, please check
> >  	 * __pad_to_align_refcnt declaration in struct dst_entry
> >  	 */
> > +#ifndef CONFIG_DEBUG_RCU_HEAD
> >  	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
> > +#endif
> 
> You lost me on this one.
> 

Basically, the networking code generate a build error when the size of a struct
dst_entry grows (because it is very performance sensitive). So the agreement
here has been to disable the check when the DEBUG_RCU_HEAD config option is
active.

> >  	atomic_inc(&dst->__refcnt);
> >  }
> 
> Would you be willing to add this to TINY_RCU as well?  It would be under
> #ifdef, so would not affect the size of production builds.

Sure, I'll add it to v2. Do you think it is worthwhile to submit it even though
it's not based on the debug objects infrastructure ?

Thanks,

Mathieu

> 
> 							Thanx, Paul

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
