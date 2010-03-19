Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab0CSFFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 01:05:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58945 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab0CSFFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 01:05:37 -0400
Date: Thu, 18 Mar 2010 22:05:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] tree/tiny rcu: Add debug RCU head option (v2)
Message-ID: <20100319050532.GE2894@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100319013024.GA28456@Krystal>
 <4BA2FA01.30102@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA2FA01.30102@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 12:13:53PM +0800, Lai Jiangshan wrote:
> CC: Christoph Lameter <cl@linux-foundation.org>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> I have written a patch like this before.
> 
> but SLUB opposed me, so I did not post it.
> 
> @ slub.c
> static void free_slab(struct kmem_cache *s, struct page *page)
> {
> 	if (unlikely(s->flags & SLAB_DESTROY_BY_RCU)) {
> 		/*
> 		 * RCU free overloads the RCU head over the LRU
> 		 */
> 		struct rcu_head *head = (void *)&page->lru;
> 
> 		call_rcu(head, rcu_free_slab);
> 	} else
> 		__free_slab(s, page);
> }
> 
> I think it is not your patch's fault, but the above code has
> already existed.
> 
> In your patch, struct rcu_head::debug will share the same memory of
> the other field of struct page, (especially share the struct page::flags
> which I encountered)
> 
> I tested it very long time before, so I can't give you dmesg.

Ouch!!!

If this only causes a problem for SLUB, maybe a workaround is to make
the config variable depend on !SLUB.  But this would seem to increase
the urgency of using the debug objects

							Thanx, Paul

> Lai
> 
> Mathieu Desnoyers wrote:
> > Poisoning the rcu_head callback list.
> > 
> > Helps finding racy users of call_rcu(), which results in hangs because list
> > entries are overwritten and/or skipped.
> > 
> > A lot of non-initialized rcu list heads will be found with this option enabled.
> > It is important to do not just blindly initialize them before each call_rcu, but
> > rather to perform the initialization at the proper location, after the memory
> > has been allocated, so we can effectively detect incorrect call_rcu users.
> > 
> > This patch version does not use "debug objects", although it probably should.
> > Some day I might find time to look into this transition, but the patch is usable
> > as is.
> > 
> > The weird #ifdef in the networking code comes from an agreement with Eric
> > Dumazet about how to disable the build check for the networking code.  For those
> > who wonder about the existence of this build-time check: it generates a build
> > error when the size of struct dst_entry grows (because it is very performance
> > sensitive). So the agreement here has been to disable the check when the
> > DEBUG_RCU_HEAD config option is active.
> > 
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > CC: mingo@elte.hu
> > CC: akpm@linux-foundation.org
> > CC: mingo@elte.hu
> > CC: laijs@cn.fujitsu.com
> > CC: dipankar@in.ibm.com
> > CC: josh@joshtriplett.org
> > CC: dvhltc@us.ibm.com
> > CC: niv@us.ibm.com
> > CC: tglx@linutronix.de
> > CC: peterz@infradead.org
> > CC: rostedt@goodmis.org
> > CC: Valdis.Kletnieks@vt.edu
> > CC: dhowells@redhat.com
> > CC: eric.dumazet@gmail.com
> > CC: Alexey Dobriyan <adobriyan@gmail.com>
> > CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  include/linux/rcupdate.h |   13 ++++++++++++-
> >  include/net/dst.h        |    2 ++
> >  kernel/rcutiny.c         |    9 +++++++++
> >  kernel/rcutree.c         |   10 ++++++++++
> >  lib/Kconfig.debug        |    9 +++++++++
> >  5 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > Index: linux-2.6-lttng/include/linux/rcupdate.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/linux/rcupdate.h	2010-03-18 20:27:25.000000000 -0400
> > +++ linux-2.6-lttng/include/linux/rcupdate.h	2010-03-18 20:30:54.000000000 -0400
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
> > @@ -71,11 +74,19 @@ extern void rcu_init(void);
> >  #error "Unknown RCU implementation specified to kernel configuration"
> >  #endif
> >  
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +#define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL, .debug = NULL }
> > +#define INIT_RCU_HEAD(ptr) do { \
> > +       (ptr)->next = NULL; (ptr)->func = NULL; (ptr)->debug = NULL; \
> > +} while (0)
> > +#else
> >  #define RCU_HEAD_INIT	{ .next = NULL, .func = NULL }
> > -#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> >  #define INIT_RCU_HEAD(ptr) do { \
> >         (ptr)->next = NULL; (ptr)->func = NULL; \
> >  } while (0)
> > +#endif
> > +
> > +#define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
> >  
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >  extern struct lockdep_map rcu_lock_map;
> > Index: linux-2.6-lttng/kernel/rcutree.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/rcutree.c	2010-03-18 20:27:25.000000000 -0400
> > +++ linux-2.6-lttng/kernel/rcutree.c	2010-03-18 20:31:16.000000000 -0400
> > @@ -39,6 +39,7 @@
> >  #include <asm/atomic.h>
> >  #include <linux/bitops.h>
> >  #include <linux/module.h>
> > +#include <linux/poison.h>
> >  #include <linux/completion.h>
> >  #include <linux/moduleparam.h>
> >  #include <linux/percpu.h>
> > @@ -1060,6 +1061,10 @@ static void rcu_do_batch(struct rcu_stat
> >  		next = list->next;
> >  		prefetch(next);
> >  		trace_rcu_tree_callback(list);
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +		WARN_ON_ONCE(list->debug != LIST_POISON1);
> > +		list->debug = NULL;
> > +#endif
> >  		list->func(list);
> >  		list = next;
> >  		if (++count >= rdp->blimit)
> > @@ -1350,6 +1355,11 @@ __call_rcu(struct rcu_head *head, void (
> >  	unsigned long flags;
> >  	struct rcu_data *rdp;
> >  
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +	WARN_ON_ONCE(head->debug);
> > +	head->debug = LIST_POISON1;
> > +#endif
> > +
> >  	head->func = func;
> >  	head->next = NULL;
> >  
> > Index: linux-2.6-lttng/lib/Kconfig.debug
> > ===================================================================
> > --- linux-2.6-lttng.orig/lib/Kconfig.debug	2010-03-18 20:27:25.000000000 -0400
> > +++ linux-2.6-lttng/lib/Kconfig.debug	2010-03-18 20:27:38.000000000 -0400
> > @@ -661,6 +661,15 @@ config DEBUG_LIST
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
> > --- linux-2.6-lttng.orig/include/net/dst.h	2010-03-18 20:27:25.000000000 -0400
> > +++ linux-2.6-lttng/include/net/dst.h	2010-03-18 20:35:02.000000000 -0400
> > @@ -159,7 +159,9 @@ static inline void dst_hold(struct dst_e
> >  	 * If your kernel compilation stops here, please check
> >  	 * __pad_to_align_refcnt declaration in struct dst_entry
> >  	 */
> > +#ifndef CONFIG_DEBUG_RCU_HEAD
> >  	BUILD_BUG_ON(offsetof(struct dst_entry, __refcnt) & 63);
> > +#endif
> >  	atomic_inc(&dst->__refcnt);
> >  }
> >  
> > Index: linux-2.6-lttng/kernel/rcutiny.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/kernel/rcutiny.c	2010-03-18 20:35:14.000000000 -0400
> > +++ linux-2.6-lttng/kernel/rcutiny.c	2010-03-18 20:39:12.000000000 -0400
> > @@ -35,6 +35,7 @@
> >  #include <linux/init.h>
> >  #include <linux/time.h>
> >  #include <linux/cpu.h>
> > +#include <linux/poison.h>
> >  
> >  /* Global control variables for rcupdate callback mechanism. */
> >  struct rcu_ctrlblk {
> > @@ -163,6 +164,10 @@ static void __rcu_process_callbacks(stru
> >  	while (list) {
> >  		next = list->next;
> >  		prefetch(next);
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +		WARN_ON_ONCE(list->debug != LIST_POISON1);
> > +		list->debug = NULL;
> > +#endif
> >  		list->func(list);
> >  		list = next;
> >  	}
> > @@ -210,6 +215,10 @@ static void __call_rcu(struct rcu_head *
> >  {
> >  	unsigned long flags;
> >  
> > +#ifdef CONFIG_DEBUG_RCU_HEAD
> > +	WARN_ON_ONCE(head->debug);
> > +	head->debug = LIST_POISON1;
> > +#endif
> >  	head->func = func;
> >  	head->next = NULL;
> >  
> > 
> 
