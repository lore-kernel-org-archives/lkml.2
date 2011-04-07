Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab1DGHG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:06:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65384 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1DGHGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:06:55 -0400
Message-ID: <4D9D6308.7040501@cn.fujitsu.com>
Date: Thu, 07 Apr 2011 15:08:56 +0800
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
Subject: [PATCH 4/4] rcu: declare preemptible __rcu_read_[un]lock() as inline
 function
References: <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com> <1301657749.4859.531.camel@twins> <20110405215450.GK2247@linux.vnet.ibm.com> <20110405230745.GA5972@linux.vnet.ibm.com> <1302077428.2225.1365.camel@twins> <20110406192119.GB2265@linux.vnet.ibm.com> <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com>
In-Reply-To: <20110407003041.GD2265@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:07:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:07:37,
	Serialize complete at 2011-04-07 15:07:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__rcu_read_[un]lock() are so simple functions, make them inlined.
Also rmove dumplicated code.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/rcupdate.h |   36 ++++++++++++++++++++++++++++++++++--
 kernel/rcutiny_plugin.h  |   38 ++------------------------------------
 kernel/rcutree_plugin.h  |   38 ++------------------------------------
 3 files changed, 38 insertions(+), 74 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index b24b288..1eb38b9 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -70,8 +70,40 @@ static inline void __rcu_read_unlock_bh(void)
 
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
 
 static inline int rcu_preempt_depth(void)
 {
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
index 17e84f5..31e408f 100644
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

