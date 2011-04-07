Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1DGQ0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:26:11 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40306 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab1DGQ0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:26:10 -0400
Date: Thu, 7 Apr 2011 09:26:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110407162600.GA24227@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110405215450.GK2247@linux.vnet.ibm.com>
 <20110405230745.GA5972@linux.vnet.ibm.com>
 <1302077428.2225.1365.camel@twins>
 <20110406192119.GB2265@linux.vnet.ibm.com>
 <20110406201350.GA9378@linux.vnet.ibm.com>
 <1302123970.2207.4.camel@laptop>
 <4D9CDACB.9050705@linux.intel.com>
 <20110407003041.GD2265@linux.vnet.ibm.com>
 <4D9D507F.2040006@cn.fujitsu.com>
 <20110407154737.GF2262@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110407154737.GF2262@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 08:47:37AM -0700, Paul E. McKenney wrote:
> On Thu, Apr 07, 2011 at 01:49:51PM +0800, Lai Jiangshan wrote:
> > On 04/07/2011 08:30 AM, Paul E. McKenney wrote:
> > > On Wed, Apr 06, 2011 at 02:27:39PM -0700, H. Peter Anvin wrote:
> > >> On 04/06/2011 02:06 PM, Peter Zijlstra wrote:
> > >>> On Wed, 2011-04-06 at 13:13 -0700, Paul E. McKenney wrote:
> > >>>> And the following patch builds correctly for defconfig x86 builds,
> > >>>> while allowing rcupdate.h to see the sched.h definitions as needed
> > >>>> to inline rcu_read_lock() and rcu_read_unlock().
> > >>>>
> > >>> Looks like an entirely reasonable patch to me ;-)
> > >>>
> > >>
> > >> Quite... a lot better than the original proposal!
> > > 
> > > Glad you both like it!
> > > 
> > > When I do an allyesconfig build, I do get errors during the "CHECK"
> > > phase, when it is putting things into the usr/include in the build tree.
> > > I believe that this is because I am exposing different header files to
> > > the library-export scripts.  The following patch silences some of them,
> > > but I am really out of my depth here.
> > > 
> > > Sam, Jan, Michal, help?
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > 
> > Easy to split rcupdate.h, hard to resolve the dependence problem.
> > 
> > You can apply the next additional patch when you test:
> 
> I am sure that you are quite correct.  ;-)
> 
> I am moving _rcu_read_lock() and _rcu_read_unlock() into
> include/linux/rcutree.h and include/linux/rcutiny.h, and I am sure that
> more pain will ensue.
> 
> One thing I don't understand...  How does is it helping to group the
> task_struct RCU-related fields into a structure?  Is that generating
> better code on your platform due to smaller offsets or something?
> 
> Also, does your patchset address the CHECK warnings?

I take it back...  I applied the following patch on top of my earlier
one, and a defconfig x86 build completed without error.  (Though I have
not tested the results of the build.)

One possible difference -- I did this work on top of a recent Linus
git commit (b2a8b4b81966) rather than on top of my -rcu tree.  Also,
I have not yet tried an allyesconfig build, which will no doubt locate
some more problems.

							Thanx, Paul

------------------------------------------------------------------------

rcu: inline preemptible rcu_read_lock() and rcu_read_unlock()

Move the definitions of __rcu_read_lock() and __rcu_read_unlock()
from kernel/rcutree_plugin.h to include/linux/rcutree.h and from
kernel/rcutiny_plugin.h to include/linux/rcutiny.h, allowing these
functions to be inlined.


 include/linux/rcutiny.h |   34 ++++++++++++++++++++++++++++++++++
 include/linux/rcutree.h |   34 ++++++++++++++++++++++++++++++++++
 kernel/rcutiny_plugin.h |   38 ++------------------------------------
 kernel/rcutree_plugin.h |   38 ++------------------------------------
 4 files changed, 72 insertions(+), 72 deletions(-)

rcu: inline preemptible rcu_read_lock() and rcu_read_unlock()

Move the definitions of __rcu_read_lock() and __rcu_read_unlock()
from kernel/rcutree_plugin.h to include/linux/rcutree.h and from
kernel/rcutiny_plugin.h to include/linux/rcutiny.h, allowing these
functions to be inlined.

Not-signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..227a3dd 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -47,6 +47,40 @@ static inline void rcu_barrier(void)
 
 void rcu_barrier(void);
 void synchronize_rcu_expedited(void);
+void rcu_read_unlock_special(struct task_struct *t);
+
+/*
+ * Tiny-preemptible RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+static inline void __rcu_read_lock(void)
+{
+	current->rcu_read_lock_nesting++;
+	barrier();
+}
+
+/*
+ * Tiny-preemptible RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+static inline void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
+
+	barrier();
+	--t->rcu_read_lock_nesting;
+	barrier();  /* decrement before load of ->rcu_read_unlock_special */
+	if (t->rcu_read_lock_nesting == 0 &&
+	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		rcu_read_unlock_special(t);
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(t->rcu_read_lock_nesting < 0);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+}
 
 #endif /* #else #ifdef CONFIG_TINY_RCU */
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c317eec..00a2b88 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -40,6 +40,40 @@ extern void rcu_cpu_stall_reset(void);
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void exit_rcu(void);
+extern void rcu_read_unlock_special(struct task_struct *t);
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+static inline void __rcu_read_lock(void)
+{
+	current->rcu_read_lock_nesting++;
+	barrier();
+}
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+static inline void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
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
 
 #else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
index 3cb8e36..d0e1ac3 100644
--- a/kernel/rcutiny_plugin.h
+++ b/kernel/rcutiny_plugin.h
@@ -520,23 +520,11 @@ void rcu_preempt_note_context_switch(void)
 }
 
 /*
- * Tiny-preemptible RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutiny.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Handle special cases during rcu_read_unlock(), such as needing to
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -616,29 +604,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
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
-	struct task_struct *t = current;
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
index a363871..4b27afd 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -196,18 +196,6 @@ static void rcu_preempt_note_context_switch(int cpu)
 }
 
 /*
- * Tree-preemptable RCU implementation for rcu_read_lock().
- * Just increment ->rcu_read_lock_nesting, shared state will be updated
- * if we block.
- */
-void __rcu_read_lock(void)
-{
-	current->rcu_read_lock_nesting++;
-	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-/*
  * Check for preempted RCU readers blocking the current grace period
  * for the specified rcu_node structure.  If the caller needs a reliable
  * answer, it must hold the rcu_node's ->lock.
@@ -261,7 +249,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
  * notify RCU core processing or task having blocked during the RCU
  * read-side critical section.
  */
-static void rcu_read_unlock_special(struct task_struct *t)
+void rcu_read_unlock_special(struct task_struct *t)
 {
 	int empty;
 	int empty_exp;
@@ -332,29 +320,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		local_irq_restore(flags);
 	}
 }
-
-/*
- * Tree-preemptable RCU implementation for rcu_read_unlock().
- * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
- * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
- * invoke rcu_read_unlock_special() to clean up after a context switch
- * in an RCU read-side critical section and other special cases.
- */
-void __rcu_read_unlock(void)
-{
-	struct task_struct *t = current;
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
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
