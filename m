Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab1C1C7I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 22:59:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56945 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab1C1C7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 22:59:07 -0400
Message-ID: <4D8FF9F1.9090409@cn.fujitsu.com>
Date: Mon, 28 Mar 2011 11:01:05 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Jan Beulich <jbeulich@novell.com>, David Howells <dhowells@redhat.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Serge Hallyn <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <clameter@sgi.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [RFC PATCH 5/5] RCU: declare preemptible __rcu_read_[un]lock() as
 inline function
References: <4D8FF8AD.5080607@cn.fujitsu.com>
In-Reply-To: <4D8FF8AD.5080607@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:57:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-28 10:57:36,
	Serialize complete at 2011-03-28 10:57:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



__rcu_read_[un]lock() are so simple functions, make them inlined.
Also rmove dumplicated code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   37 +++++++++++++++++++++++++++++++++++--
 kernel/rcutiny_plugin.h  |   38 ++------------------------------------
 kernel/rcutree_plugin.h  |   38 ++------------------------------------
 3 files changed, 39 insertions(+), 74 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index a5ed3fe..58e0350 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -187,8 +187,41 @@ static inline void rcu_copy_process(struct task_struct *tsk)
 
 #ifdef CONFIG_PREEMPT_RCU
 
-extern void __rcu_read_lock(void);
-extern void __rcu_read_unlock(void);
+void rcu_read_unlock_special(struct task_rcu_struct *t);
+
+/*
+ * Preemptible RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+static inline void __rcu_read_lock(void)
+{
+	current_task_rcu_struct()->rcu_read_lock_nesting++;
+	barrier();
+}
+
+/*
+ * Preemptible RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+static inline void __rcu_read_unlock(void)
+{
+	struct task_rcu_struct *t = current_task_rcu_struct();
+
+	barrier();
+	--t->rcu_read_lock_nesting;
+	barrier();  /* decrement before load of ->rcu_read_unlock_special */
+	if (t->rcu_read_lock_nesting == 0 &&
+	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		rcu_read_unlock_special(t);
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
+
 void synchronize_rcu(void);
 
 /*
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 425e892..49a7699 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -514,23 +514,11 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current_task_rcu_struct()->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_rcu_struct *t)
+void rcu_read_unlock_special(struct task_rcu_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -609,29 +597,7 @@ static void rcu_read_unlock_special(struct task_rcu_struct *t)
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	local_irq_restore(flags);
 }
-
-/*
- * Tiny-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_rcu_struct *t = current_task_rcu_struct();
-
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutiny.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
-#ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+EXPORT_SYMBOL_GPL(rcu_read_unlock_special);
 
 /*
  * Check for a quiescent state from the current CPU.  When a task blocks,
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 88a12d4..63c548a 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -208,18 +208,6 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Tree-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current_task_rcu_struct()->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Check for preempted RCU readers blocking the current grace period
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
@@ -285,7 +273,7 @@ static struct list_head *rcu_next_node_entry(struct task_rcu_struct *t,
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_rcu_struct *t)
+void rcu_read_unlock_special(struct task_rcu_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -375,29 +363,7 @@ static void rcu_read_unlock_special(struct task_rcu_struct *t)
 		local_irq_restore(flags);
 	}
 }
-
-/*
- * Tree-preemptible RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_rcu_struct *t = current_task_rcu_struct();
-
-	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
-	--t->rcu_read_lock_nesting;
-	barrier();  /* decrement before load of ->rcu_read_unlock_special */
-	if (t->rcu_read_lock_nesting == 0 &&
-	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
-		rcu_read_unlock_special(t);
-#ifdef CONFIG_PROVE_LOCKING
-	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
-#endif /* #ifdef CONFIG_PROVE_LOCKING */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+EXPORT_SYMBOL_GPL(rcu_read_unlock_special);
 
 #ifdef CONFIG_RCU_CPU_STALL_VERBOSE
 
-- 
1.7.4

