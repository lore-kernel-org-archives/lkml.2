Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab1DFUOA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:14:00 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44326 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab1DFUN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:13:59 -0400
Date: Wed, 6 Apr 2011 13:13:50 -0700
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
Message-ID: <20110406201350.GA9378@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D93D29C.5010702@cn.fujitsu.com>
 <1301558691.2250.486.camel@laptop>
 <4D944E60.8080704@cn.fujitsu.com>
 <1301570320.4859.242.camel@twins>
 <4D953121.6090901@cn.fujitsu.com>
 <1301657749.4859.531.camel@twins>
 <20110405215450.GK2247@linux.vnet.ibm.com>
 <20110405230745.GA5972@linux.vnet.ibm.com>
 <1302077428.2225.1365.camel@twins>
 <20110406192119.GB2265@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406192119.GB2265@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 06, 2011 at 12:21:19PM -0700, Paul E. McKenney wrote:
> On Wed, Apr 06, 2011 at 10:10:28AM +0200, Peter Zijlstra wrote:
> > On Tue, 2011-04-05 at 16:07 -0700, Paul E. McKenney wrote:
> > > 
> > > The next layer on this onion is the use of the ctl_table typedef
> > > in include/linux/key.h -- which is defined to be struct ctl_table.
> > > Anyone know where struct ctl_table is defined?  Color me blind, but I
> > > am not seeing it... 
> > 
> > include/linux/sysctl.h:1015
> 
> Thank you!

And the following patch builds correctly for defconfig x86 builds,
while allowing rcupdate.h to see the sched.h definitions as needed
to inline rcu_read_lock() and rcu_read_unlock().

I will try allyesconfig builds and see what else breaks.

							Thanx, Paul

 include/linux/pid.h      |    2 +-
 include/linux/rcupdate.h |   27 +++++++++------------------
 include/linux/rcutree.h  |    2 ++
 include/linux/sched.h    |   10 ++++------
 include/linux/sem.h      |    2 +-
 include/linux/sysctl.h   |    5 +++--
 include/linux/types.h    |   10 ++++++++++
 kernel/pid_namespace.c   |    2 ++
 8 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index efceda0..3c5719b 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_PID_H
 #define _LINUX_PID_H
 
-#include <linux/rcupdate.h>
+#include <linux/types.h>
 
 enum pid_type
 {
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index ff422d2..2fe6402 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -33,6 +33,7 @@
 #ifndef __LINUX_RCUPDATE_H
 #define __LINUX_RCUPDATE_H
 
+#include <linux/types.h>
 #include <linux/cache.h>
 #include <linux/spinlock.h>
 #include <linux/threads.h>
@@ -52,16 +53,6 @@ extern int rcutorture_runnable; /* for sysctl */
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
-
 /* Exported common interfaces */
 extern void call_rcu_sched(struct rcu_head *head,
 			   void (*func)(struct rcu_head *rcu));
@@ -141,14 +132,6 @@ static inline void rcu_exit_nohz(void)
 
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
@@ -797,4 +780,12 @@ static inline void debug_rcu_head_unqueue(struct rcu_head *head)
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
index 83bd2e2..30a4444 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -78,7 +78,7 @@ struct sched_param {
 #include <linux/topology.h>
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
-#include <linux/rcupdate.h>
+#include <linux/types.h>
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
diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..8489a1f 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -78,7 +78,7 @@ struct  seminfo {
 
 #ifdef __KERNEL__
 #include <asm/atomic.h>
-#include <linux/rcupdate.h>
+#include <linux/types.h>
 #include <linux/cache.h>
 
 struct task_struct;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..be80a59 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -19,6 +19,8 @@
  ****************************************************************
  */
 
+#include <linux/key.h>
+
 #ifndef _LINUX_SYSCTL_H
 #define _LINUX_SYSCTL_H
 
@@ -1012,8 +1014,7 @@ extern int proc_do_large_bitmap(struct ctl_table *, int,
  */
 
 /* A sysctl table is an array of struct ctl_table: */
-struct ctl_table 
-{
+struct ctl_table {
 	const char *procname;		/* Text ID for /proc/sys, or zero */
 	void *data;
 	int maxlen;
diff --git a/include/linux/types.h b/include/linux/types.h
index 176da8c..868ef8b 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -231,6 +231,16 @@ struct hlist_node {
 	struct hlist_node *next, **pprev;
 };
 
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
 struct ustat {
 	__kernel_daddr_t	f_tfree;
 	__kernel_ino_t		f_tinode;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index e9c9adc..bfa75df 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -8,6 +8,8 @@
  *
  */
 
+#include <linux/types.h>
+#include <asm/atomic.h>
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
 #include <linux/syscalls.h>
