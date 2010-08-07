Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724Ab0HGEFr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 00:05:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34607 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab0HGEFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 00:05:45 -0400
Date: Sat, 7 Aug 2010 14:05:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the kgdb tree with Linus' tree
Message-Id: <20100807140542.bea61032.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

Today's linux-next merge of the kgdb tree got a conflict in
include/linux/rcupdate.h between commits
551d55a944b143ef26fbd482d1c463199d6f65cf ("tree/tiny rcu: Add debug RCU
head objects") and f5155b33277c9678041a27869165619bb34f722f ("rcu: add an
rcu_dereference_index_check()") from Linus' tree and commit
9e213357d0aeaeb81e213cfd3b9415db5fccc1b5 ("rcu,debug_core: allow the
kernel debugger to reset the rcu stall timer") from the kgdb tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/rcupdate.h
index 9fbc54a,585efef..0000000
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@@ -529,74 -517,12 +529,82 @@@ extern void call_rcu(struct rcu_head *h
  extern void call_rcu_bh(struct rcu_head *head,
  			void (*func)(struct rcu_head *head));
  
 +/*
 + * debug_rcu_head_queue()/debug_rcu_head_unqueue() are used internally
 + * by call_rcu() and rcu callback execution, and are therefore not part of the
 + * RCU API. Leaving in rcupdate.h because they are used by all RCU flavors.
 + */
 +
 +#ifdef CONFIG_DEBUG_OBJECTS_RCU_HEAD
 +# define STATE_RCU_HEAD_READY	0
 +# define STATE_RCU_HEAD_QUEUED	1
 +
 +extern struct debug_obj_descr rcuhead_debug_descr;
 +
 +static inline void debug_rcu_head_queue(struct rcu_head *head)
 +{
 +	debug_object_activate(head, &rcuhead_debug_descr);
 +	debug_object_active_state(head, &rcuhead_debug_descr,
 +				  STATE_RCU_HEAD_READY,
 +				  STATE_RCU_HEAD_QUEUED);
 +}
 +
 +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 +{
 +	debug_object_active_state(head, &rcuhead_debug_descr,
 +				  STATE_RCU_HEAD_QUEUED,
 +				  STATE_RCU_HEAD_READY);
 +	debug_object_deactivate(head, &rcuhead_debug_descr);
 +}
 +#else	/* !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 +static inline void debug_rcu_head_queue(struct rcu_head *head)
 +{
 +}
 +
 +static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 +{
 +}
 +#endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 +
 +#ifndef CONFIG_PROVE_RCU
 +#define __do_rcu_dereference_check(c) do { } while (0)
 +#endif /* #ifdef CONFIG_PROVE_RCU */
 +
 +#define __rcu_dereference_index_check(p, c) \
 +	({ \
 +		typeof(p) _________p1 = ACCESS_ONCE(p); \
 +		__do_rcu_dereference_check(c); \
 +		smp_read_barrier_depends(); \
 +		(_________p1); \
 +	})
 +
 +/**
 + * rcu_dereference_index_check() - rcu_dereference for indices with debug checking
 + * @p: The pointer to read, prior to dereferencing
 + * @c: The conditions under which the dereference will take place
 + *
 + * Similar to rcu_dereference_check(), but omits the sparse checking.
 + * This allows rcu_dereference_index_check() to be used on integers,
 + * which can then be used as array indices.  Attempting to use
 + * rcu_dereference_check() on an integer will give compiler warnings
 + * because the sparse address-space mechanism relies on dereferencing
 + * the RCU-protected pointer.  Dereferencing integers is not something
 + * that even gcc will put up with.
 + *
 + * Note that this function does not implicitly check for RCU read-side
 + * critical sections.  If this function gains lots of uses, it might
 + * make sense to provide versions for each flavor of RCU, but it does
 + * not make sense as of early 2010.
 + */
 +#define rcu_dereference_index_check(p, c) \
 +	__rcu_dereference_index_check((p), (c))
 +
+ #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+ extern void rcu_cpu_stall_reset(void);
+ #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+ static void rcu_cpu_stall_reset()
+ {
+ }
+ #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+ 
  #endif /* __LINUX_RCUPDATE_H */
