Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab1DGHFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:05:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59133 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1DGHFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:05:53 -0400
Message-ID: <4D9D62CE.7060007@cn.fujitsu.com>
Date: Thu, 07 Apr 2011 15:07:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/4] rcu: introduce task_rcu_struct and move task's RCU code
 to rcupdate_defs.h
References: <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com> <1301657749.4859.531.camel@twins> <20110405215450.GK2247@linux.vnet.ibm.com> <20110405230745.GA5972@linux.vnet.ibm.com> <1302077428.2225.1365.camel@twins> <20110406192119.GB2265@linux.vnet.ibm.com> <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com>
In-Reply-To: <20110407003041.GD2265@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:06:35,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:06:36,
	Serialize complete at 2011-04-07 15:06:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add struct task_rcu_struct to make code clearer and move
them to rcupdate_defs.h which help us for code maitainment.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/init_task.h     |   25 +----------------
 include/linux/rcupdate.h      |   34 ++++++++++++++++++-----
 include/linux/rcupdate_defs.h |   60 +++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h         |   39 +--------------------------
 kernel/rcutiny_plugin.h       |   26 +++++++++--------
 kernel/rcutree_plugin.h       |   37 +++++++++++++------------
 6 files changed, 122 insertions(+), 99 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index caa151f..1749002 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -90,29 +90,6 @@ extern struct group_info init_groups;
  */
 # define CAP_INIT_BSET  CAP_FULL_SET
 
-#ifdef CONFIG_RCU_BOOST
-#define INIT_TASK_RCU_BOOST()						\
-	.rcu_boost_mutex = NULL,
-#else
-#define INIT_TASK_RCU_BOOST()
-#endif
-#ifdef CONFIG_TREE_PREEMPT_RCU
-#define INIT_TASK_RCU_TREE_PREEMPT()					\
-	.rcu_blocked_node = NULL,
-#else
-#define INIT_TASK_RCU_TREE_PREEMPT(tsk)
-#endif
-#ifdef CONFIG_PREEMPT_RCU
-#define INIT_TASK_RCU_PREEMPT(tsk)					\
-	.rcu_read_lock_nesting = 0,					\
-	.rcu_read_unlock_special = 0,					\
-	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),		\
-	INIT_TASK_RCU_TREE_PREEMPT()					\
-	INIT_TASK_RCU_BOOST()
-#else
-#define INIT_TASK_RCU_PREEMPT(tsk)
-#endif
-
 extern struct cred init_cred;
 
 #ifdef CONFIG_PERF_EVENTS
@@ -191,7 +168,7 @@ extern struct cred init_cred;
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
-	INIT_TASK_RCU_PREEMPT(tsk)					\
+	.task_rcu_struct = INIT_TASK_RCU_STRUCT(tsk.task_rcu_struct),	\
 }
 
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index c25d2a6..b24b288 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -34,6 +34,29 @@
 #define __LINUX_RCUPDATE_H
 
 #include <linux/rcupdate_defs.h>
+#include <linux/sched.h>
+
+static inline
+struct task_rcu_struct *task_rcu_struct(struct task_struct *t)
+{
+	return &t->task_rcu_struct;
+}
+
+static inline
+struct task_struct *task_of_task_rcu(struct task_rcu_struct *task_rcu)
+{
+	return container_of(task_rcu, struct task_struct, task_rcu_struct);
+}
+
+static inline struct task_rcu_struct *current_task_rcu_struct(void)
+{
+	return task_rcu_struct(current);
+}
+
+static inline void rcu_copy_process(struct task_struct *tsk)
+{
+	init_task_rcu_struct(task_rcu_struct(tsk));
+}
 
 static inline void __rcu_read_lock_bh(void)
 {
@@ -50,13 +73,10 @@ static inline void __rcu_read_unlock_bh(void)
 extern void __rcu_read_lock(void);
 extern void __rcu_read_unlock(void);
 
-/*
- * Defined as a macro as it is a very low level header included from
- * areas that don't even know about current.  This gives the rcu_read_lock()
- * nesting depth, but makes sense only if CONFIG_PREEMPT_RCU -- in other
- * types of kernel builds, the rcu_read_lock() nesting depth is unknowable.
- */
-#define rcu_preempt_depth() (current->rcu_read_lock_nesting)
+static inline int rcu_preempt_depth(void)
+{
+	return current_task_rcu_struct()->rcu_read_lock_nesting;
+}
 
 #else /* #ifdef CONFIG_PREEMPT_RCU */
 
diff --git a/include/linux/rcupdate_defs.h b/include/linux/rcupdate_defs.h
index ae84745..e4e1567 100644
--- a/include/linux/rcupdate_defs.h
+++ b/include/linux/rcupdate_defs.h
@@ -93,6 +93,66 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
+/* Special flags for preemptible RCU */
+#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
+#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
+
+struct task_struct;
+
+struct task_rcu_struct {
+#ifdef CONFIG_PREEMPT_RCU
+	int rcu_read_lock_nesting;
+	char rcu_read_unlock_special;
+	struct list_head rcu_node_entry;
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	struct rcu_node *rcu_blocked_node;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	struct rt_mutex *rcu_boost_mutex;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#endif /* #ifdef CONFIG_PREEMPT_RCU */
+};
+
+#ifdef CONFIG_RCU_BOOST
+#define INIT_TASK_RCU_BOOST()						\
+	.rcu_boost_mutex = NULL,
+#else
+#define INIT_TASK_RCU_BOOST()
+#endif
+#ifdef CONFIG_TREE_PREEMPT_RCU
+#define INIT_TASK_RCU_TREE_PREEMPT()					\
+	.rcu_blocked_node = NULL,
+#else
+#define INIT_TASK_RCU_TREE_PREEMPT(tsk)
+#endif
+#ifdef CONFIG_PREEMPT_RCU
+#define INIT_TASK_RCU_STRUCT(task_rcu) {				\
+		.rcu_read_lock_nesting = 0,				\
+		.rcu_read_unlock_special = 0,				\
+		.rcu_node_entry = LIST_HEAD_INIT(task_rcu.rcu_node_entry),\
+		INIT_TASK_RCU_TREE_PREEMPT()				\
+		INIT_TASK_RCU_BOOST()					\
+	}
+#else
+#define INIT_TASK_RCU_STRUCT(task_rcu) {}
+#endif
+
+static inline void init_task_rcu_struct(struct task_rcu_struct *task_rcu)
+{
+#ifdef CONFIG_PREEMPT_RCU
+	task_rcu->rcu_read_lock_nesting = 0;
+	task_rcu->rcu_read_unlock_special = 0;
+	INIT_LIST_HEAD(&task_rcu->rcu_node_entry);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	task_rcu->rcu_blocked_node = NULL;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+#ifdef CONFIG_RCU_BOOST
+	task_rcu->rcu_boost_mutex = NULL;
+#endif /* #ifdef CONFIG_RCU_BOOST */
+#endif /* CONFIG_PREEMPT_RCU */
+}
+
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
 #elif defined(CONFIG_TINY_RCU) || defined(CONFIG_TINY_PREEMPT_RCU)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 69db9e7..5252e48 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1232,17 +1232,7 @@ struct task_struct {
 	unsigned int policy;
 	cpumask_t cpus_allowed;
 
-#ifdef CONFIG_PREEMPT_RCU
-	int rcu_read_lock_nesting;
-	char rcu_read_unlock_special;
-	struct list_head rcu_node_entry;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	struct rcu_node *rcu_blocked_node;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	struct rt_mutex *rcu_boost_mutex;
-#endif /* #ifdef CONFIG_RCU_BOOST */
+	struct task_rcu_struct task_rcu_struct;
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1772,33 +1762,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
-#ifdef CONFIG_PREEMPT_RCU
-
-#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
-#define RCU_READ_UNLOCK_BOOSTED (1 << 1) /* boosted while in RCU read-side. */
-#define RCU_READ_UNLOCK_NEED_QS (1 << 2) /* RCU core needs CPU response. */
-
-static inline void rcu_copy_process(struct task_struct *p)
-{
-	p->rcu_read_lock_nesting = 0;
-	p->rcu_read_unlock_special = 0;
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	p->rcu_blocked_node = NULL;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-#ifdef CONFIG_RCU_BOOST
-	p->rcu_boost_mutex = NULL;
-#endif /* #ifdef CONFIG_RCU_BOOST */
-	INIT_LIST_HEAD(&p->rcu_node_entry);
-}
-
-#else
-
-static inline void rcu_copy_process(struct task_struct *p)
-{
-}
-
-#endif
-
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index f259c67..425e892 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -150,7 +150,7 @@ static int rcu_cpu_blocking_cur_gp(void)
  */
 static int rcu_preempt_running_reader(void)
 {
-	return current->rcu_read_lock_nesting;
+	return current_task_rcu_struct()->rcu_read_lock_nesting;
 }
 
 /*
@@ -192,7 +192,7 @@ static int rcu_preempt_gp_in_progress(void)
  * Advance a ->blkd_tasks-list pointer to the next entry, instead
  * returning NULL if at the end of the list.
  */
-static struct list_head *rcu_next_node_entry(struct task_struct *t)
+static struct list_head *rcu_next_node_entry(struct task_rcu_struct *t)
 {
 	struct list_head *np;
 
@@ -255,7 +255,7 @@ static int rcu_boost(void)
 {
 	unsigned long flags;
 	struct rt_mutex mtx;
-	struct task_struct *t;
+	struct task_rcu_struct *t;
 	struct list_head *tb;
 
 	if (rcu_preempt_ctrlblk.boost_tasks == NULL &&
@@ -298,8 +298,8 @@ static int rcu_boost(void)
 	 * simply acquiring this artificial rt_mutex will boost task
 	 * t's priority.  (Thanks to tglx for suggesting this approach!)
 	 */
-	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
+	t = container_of(tb, struct task_rcu_struct, rcu_node_entry);
+	rt_mutex_init_proxy_locked(&mtx, task_of_task_rcu(t));
 	t->rcu_boost_mutex = &mtx;
 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_local_irq_restore(flags);
@@ -402,9 +402,11 @@ static void rcu_preempt_boost_start_gp(void)
  */
 static void rcu_preempt_cpu_qs(void)
 {
+	struct task_rcu_struct *t = current_task_rcu_struct();
+
 	/* Record both CPU and task as having responded to current GP. */
 	rcu_preempt_ctrlblk.gpcpu = rcu_preempt_ctrlblk.gpnum;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 
 	/* If there is no GP then there is nothing more to do.  */
 	if (!rcu_preempt_gp_in_progress())
@@ -473,7 +475,7 @@ static void rcu_preempt_start_gp(void)
  */
 void rcu_preempt_note_context_switch(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 	unsigned long flags;
 
 	local_irq_save(flags); /* must exclude scheduler_tick(). */
@@ -518,7 +520,7 @@ void rcu_preempt_note_context_switch(void)
  */
 void __rcu_read_lock(void)
 {
-	current->rcu_read_lock_nesting++;
+	current_task_rcu_struct()->rcu_read_lock_nesting++;
 	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -528,7 +530,7 @@ EXPORT_SYMBOL_GPL(__rcu_read_lock);
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+static void rcu_read_unlock_special(struct task_rcu_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -617,7 +619,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
  */
 void __rcu_read_unlock(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
 	--t->rcu_read_lock_nesting;
@@ -640,7 +642,7 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
  */
 static void rcu_preempt_check_callbacks(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	if (rcu_preempt_gp_in_progress() &&
 	    (!rcu_preempt_running_reader() ||
@@ -841,7 +843,7 @@ int rcu_preempt_needs_cpu(void)
  */
 void exit_rcu(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	if (t->rcu_read_lock_nesting == 0)
 		return;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 69b8ab8..17e84f5 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -120,11 +120,12 @@ EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
 static void rcu_preempt_qs(int cpu)
 {
 	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	rdp->passed_quiesc_completed = rdp->gpnum - 1;
 	barrier();
 	rdp->passed_quiesc = 1;
-	current->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+	t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
 }
 
 /*
@@ -142,7 +143,7 @@ static void rcu_preempt_qs(int cpu)
  */
 static void rcu_preempt_note_context_switch(int cpu)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 	unsigned long flags;
 	struct rcu_data *rdp;
 	struct rcu_node *rnp;
@@ -213,7 +214,7 @@ static void rcu_preempt_note_context_switch(int cpu)
  */
 void __rcu_read_lock(void)
 {
-	current->rcu_read_lock_nesting++;
+	current_task_rcu_struct()->rcu_read_lock_nesting++;
 	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_lock);
@@ -268,7 +269,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
  * Advance a ->blkd_tasks-list pointer to the next entry, instead
  * returning NULL if at the end of the list.
  */
-static struct list_head *rcu_next_node_entry(struct task_struct *t,
+static struct list_head *rcu_next_node_entry(struct task_rcu_struct *t,
 					     struct rcu_node *rnp)
 {
 	struct list_head *np;
@@ -284,7 +285,7 @@ static struct list_head *rcu_next_node_entry(struct task_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+static void rcu_read_unlock_special(struct task_rcu_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -384,7 +385,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
  */
 void __rcu_read_unlock(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
 	--t->rcu_read_lock_nesting;
@@ -407,15 +408,15 @@ EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 {
 	unsigned long flags;
-	struct task_struct *t;
+	struct task_rcu_struct *t;
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	t = list_entry(rnp->gp_tasks,
-		       struct task_struct, rcu_node_entry);
+		       struct task_rcu_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
-		sched_show_task(t);
+		sched_show_task(task_of_task_rcu(t));
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
@@ -446,14 +447,14 @@ static void rcu_print_detail_task_stall(struct rcu_state *rsp)
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	struct task_struct *t;
+	struct task_rcu_struct *t;
 
 	if (!rcu_preempt_blocked_readers_cgp(rnp))
 		return;
 	t = list_entry(rnp->gp_tasks,
-		       struct task_struct, rcu_node_entry);
+		       struct task_rcu_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
-		printk(" P%d", t->pid);
+		printk(" P%d", task_of_task_rcu(t)->pid);
 }
 
 /*
@@ -508,7 +509,7 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	struct list_head *lp_root;
 	int retval = 0;
 	struct rcu_node *rnp_root = rcu_get_root(rsp);
-	struct task_struct *t;
+	struct task_rcu_struct *t;
 
 	if (rnp == rnp_root) {
 		WARN_ONCE(1, "Last CPU thought to be offlined?");
@@ -581,7 +582,7 @@ static void rcu_preempt_offline_cpu(int cpu)
  */
 static void rcu_preempt_check_callbacks(int cpu)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	if (t->rcu_read_lock_nesting == 0) {
 		rcu_preempt_qs(cpu);
@@ -851,7 +852,7 @@ static void __init __rcu_init_preempt(void)
  */
 void exit_rcu(void)
 {
-	struct task_struct *t = current;
+	struct task_rcu_struct *t = current_task_rcu_struct();
 
 	if (t->rcu_read_lock_nesting == 0)
 		return;
@@ -1110,7 +1111,7 @@ static int rcu_boost(struct rcu_node *rnp)
 {
 	unsigned long flags;
 	struct rt_mutex mtx;
-	struct task_struct *t;
+	struct task_rcu_struct *t;
 	struct list_head *tb;
 
 	if (rnp->exp_tasks == NULL && rnp->boost_tasks == NULL)
@@ -1158,8 +1159,8 @@ static int rcu_boost(struct rcu_node *rnp)
 	 * and task t's exiting its outermost RCU read-side critical
 	 * section.
 	 */
-	t = container_of(tb, struct task_struct, rcu_node_entry);
-	rt_mutex_init_proxy_locked(&mtx, t);
+	t = container_of(tb, struct task_rcu_struct, rcu_node_entry);
+	rt_mutex_init_proxy_locked(&mtx, task_of_task_rcu(t));
 	t->rcu_boost_mutex = &mtx;
 	t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BOOSTED;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-- 
1.7.4

