Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1DEXIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:08:00 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:43778 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab1DEXHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:07:54 -0400
Date: Tue, 5 Apr 2011 16:07:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110405230745.GA5972@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110330105505.GA3195@sepie.suse.cz>
 <1301482656.4859.171.camel@twins>
 <4D931814.9090100@suse.cz>
 <4D93D29C.5010702@cn.fujitsu.com>
 <1301558691.2250.486.camel@laptop>
 <4D944E60.8080704@cn.fujitsu.com>
 <1301570320.4859.242.camel@twins>
 <4D953121.6090901@cn.fujitsu.com>
 <1301657749.4859.531.camel@twins>
 <20110405215450.GK2247@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405215450.GK2247@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05, 2011 at 02:54:50PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 01, 2011 at 01:35:49PM +0200, Peter Zijlstra wrote:
> > On Fri, 2011-04-01 at 09:57 +0800, Lai Jiangshan wrote:
> > > 
> > > We are trying to use inlined read_read_[un]lock(), it is required that sched.h
> > > needs include rcupdate.h which causes many recursive including. Splitting rcupdate.h
> > > only does not help. 
> > 
> > You're not making any kind of sense there.
> > 
> > linux-2.6# cat kernel/sched_tmp.c 
> > 
> > #include <linux/sched.h>
> > 
> > linux-2.6# make kernel/sched_tmp.i
> > linux-2.6# awk '/^#/ { t=$0 } /rcu_read_lock/ { print t " " $0 }' kernel/sched_tmp.i
> > # 60 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void __rcu_read_lock_bh(void)
> > # 60 "/usr/src/linux-2.6/include/linux/rcupdate.h" extern void __rcu_read_lock(void);
> > # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_held(void)
> > # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_bh_held(void)
> > # 258 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline int rcu_read_lock_sched_held(void)
> > # 559 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock(void)
> > # 559 "/usr/src/linux-2.6/include/linux/rcupdate.h"  __rcu_read_lock();
> > # 600 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock_bh(void)
> > # 600 "/usr/src/linux-2.6/include/linux/rcupdate.h"  __rcu_read_lock_bh();
> > # 627 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline void rcu_read_lock_sched(void)
> > # 627 "/usr/src/linux-2.6/include/linux/rcupdate.h" static inline __attribute__((no_instrument_function)) void rcu_read_lock_sched_notrace(void)
> > # 70 "/usr/src/linux-2.6/include/linux/srcu.h" int __srcu_read_lock(struct srcu_struct *sp) ;
> > # 103 "/usr/src/linux-2.6/include/linux/srcu.h" static inline int srcu_read_lock_held(struct srcu_struct *sp)
> > # 149 "/usr/src/linux-2.6/include/linux/srcu.h" static inline int srcu_read_lock(struct srcu_struct *sp)
> > # 149 "/usr/src/linux-2.6/include/linux/srcu.h"  int retval = __srcu_read_lock(sp);
> > # 1227 "/usr/src/linux-2.6/include/linux/sched.h"  int rcu_read_lock_nesting;
> > # 1786 "/usr/src/linux-2.6/include/linux/sched.h"  p->rcu_read_lock_nesting = 0;
> > 
> > There isn't a single rcu_read_lock() user in the include chain of
> > sched.h, therefore its possible to split rcupdate.h such that one part
> > includes the bits needed for sched.h and another part that includes
> > sched.h and provides rcu_read_lock().
> 
> Yep, you can easily split struct rcu_head out into its own header file,
> and then include that into sched.h in place of rcupdate.h without trouble
> (at least in the few builds I tried).
> 
> The trouble comes when you take the next step and include sched.h
> into include/linux/rcutree.h, which would be needed to allow
> TREE_PREEMPT_RCU's rcu_read_lock() and rcu_read_unlock() to be
> inlined.  This pulls sched.h into files that it was not already
> included into, and we do get build failures (the first of which
> requires changes local to RCU, FWIW).
> 
> Of course, it would be good to straighten this out.

And here is a start -- the build is -much- quieter with this patch.

The next layer on this onion is the use of the ctl_table typedef
in include/linux/key.h -- which is defined to be struct ctl_table.
Anyone know where struct ctl_table is defined?  Color me blind, but I
am not seeing it...

							Thanx, Paul

------------------------------------------------------------------------

diff --git a/include/linux/rcu_head.h b/include/linux/rcu_head.h
new file mode 100644
index 0000000..e0b8add
--- /dev/null
+++ b/include/linux/rcu_head.h
@@ -0,0 +1,46 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion: base structures
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2001
+ *
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ * Papers:
+ * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
+ * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ *		http://lse.sourceforge.net/locking/rcupdate.html
+ *
+ */
+
+#ifndef __LINUX_RCU_HEAD_H
+#define __LINUX_RCU_HEAD_H
+
+/**
+ * struct rcu_head - callback structure for use with RCU
+ * @next: next update requests in a list
+ * @func: actual update function to call after the grace period.
+ */
+struct rcu_head {
+	struct rcu_head *next;
+	void (*func)(struct rcu_head *head);
+};
+
+#endif /* __LINUX_RCU_HEAD_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ff422d2..ab94fcfb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,15 +52,7 @@ extern int rcutorture_runnable; /* for sysctl */
 #define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
 #define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
 
-/**
- * struct rcu_head - callback structure for use with RCU
- * @next: next update requests in a list
- * @func: actual update function to call after the grace period.
- */
-struct rcu_head {
-	struct rcu_head *next;
-	void (*func)(struct rcu_head *head);
-};
+#include <linux/rcu_head.h>
 
 /* Exported common interfaces */
 extern void call_rcu_sched(struct rcu_head *head,
@@ -141,14 +133,6 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
-#include <linux/rcutree.h>
-#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
-#include <linux/rcutiny.h>
-#else
-#error "Unknown RCU implementation specified to kernel configuration"
-#endif
-
 /*
  * init_rcu_head_on_stack()/destroy_rcu_head_on_stack() are needed for dynamic
  * initialization and destruction of rcu_head on the stack. rcu_head structures
@@ -797,4 +781,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
 }
 #endif	/* #else !CONFIG_DEBUG_OBJECTS_RCU_HEAD */
 
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
+#include <linux/rcutree.h>
+#elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
+#include <linux/rcutiny.h>
+#else
+#error "Unknown RCU implementation specified to kernel configuration"
+#endif
+
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 3a93348..c317eec 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,6 +30,8 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
+#include <linux/sched.h>
+
 extern void rcu_init(void);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 83bd2e2..e7c6a90 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -78,7 +78,7 @@ struct sched_param {
 #include <linux/topology.h>
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
-#include <linux/rcupdate.h>
+#include <linux/rcu_head.h>
 #include <linux/rculist.h>
 #include <linux/rtmutex.h>
 
@@ -2241,11 +2241,9 @@ int same_thread_group(struct task_struct *p1, struct task_struct *p2)
 	return p1->tgid == p2->tgid;
 }
 
-static inline struct task_struct *next_thread(const struct task_struct *p)
-{
-	return list_entry_rcu(p->thread_group.next,
-			      struct task_struct, thread_group);
-}
+/* Avoid #include hell for inlining rcu_read_lock(). */
+#define next_thread(p) \
+	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
 
 static inline int thread_group_empty(struct task_struct *p)
 {
