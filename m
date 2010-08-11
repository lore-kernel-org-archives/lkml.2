Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898Ab0HKECQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 00:02:16 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56927 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742Ab0HKECO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 00:02:14 -0400
Date: Tue, 10 Aug 2010 21:01:57 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 2/2] rcu,debug_core: allow the kernel debugger to
 reset the rcu stall timer
Message-ID: <20100811040157.GA7722@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1281330732-17164-1-git-send-email-jason.wessel@windriver.com>
 <1281330732-17164-2-git-send-email-jason.wessel@windriver.com>
 <1281330732-17164-3-git-send-email-jason.wessel@windriver.com>
 <20100809174353.GH3026@linux.vnet.ibm.com>
 <4C60484B.8030002@windriver.com>
 <20100809190142.GM3026@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809190142.GM3026@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 12:01:42PM -0700, Paul E. McKenney wrote:
> On Mon, Aug 09, 2010 at 01:26:19PM -0500, Jason Wessel wrote:
> > On 08/09/2010 12:43 PM, Paul E. McKenney wrote:
> > > On Mon, Aug 09, 2010 at 12:12:12AM -0500, Jason Wessel wrote:
> > >
> > >> +void rcu_cpu_stall_reset(void)
> > >> +{
> > >> +    rcu_sched_state.jiffies_stall = 0;
> > >> +    rcu_bh_state.jiffies_stall = 0;
> > >> +}
> > >> +
> > >
> > > OK, so you are suppressing RCU CPU stall warnings for rcu_sched and
> > > rcu_bh, but not for preemptible RCU.  I believe that you want all of
> > > them covered.
> > 
> > What is the state variable for the preemptible RCU I had not hit a
> > warning in my testing so I must needs some more test cases. :-)
> 
> Well, you won't hit preemptible RCU unless you set TREE_PREEMPT_RCU.  ;-)
> 
> > > I have a number of recent patches that allow RCU CPU stall warnings to
> > > be suppressed, one of which allows them to be suppressed using sysfs.
> > > Would that work for you, or do you need an in-kernel interface?
> > 
> > We need an in-kernel interface for sure.
> 
> OK, good to know.
> 
> > > If you do need an in-kernel interface, I could export (and probably
> > > rename) rcu_panic(), which is a static in 2.6.35.  This assumes that you
> > > never want to re-enable RCU CPU stall warnings once you suppress them,
> > > which is what your patch appears to do.
> > >
> > > So, if I export a suppress_rcu_cpu_stall() function that permanently
> > > disabled RCU CPU stall warnings, would that work for you?  (They could
> > > be manually re-enabled via sysfs.)
> > 
> > This is an RFC patch for a reason.  The intent behind the interface is
> > to allow for one stall check cycle to go by after resuming kernel
> > execution and after that the normal rules are in play.  Code flow
> > wise, it looked like the easiest thing to do was set the jiffies_stall
> > value to zero and then exit when the.  The patch I created was
> > supposed to only ignore one stall cycle.
> > 
> > Here is the pseudo code.
> > 
> > /* before restarting kernel execution zero out the jiffies_stall  value.
> > 
> > __rcu_pending() {
> > 
> >     check_cpu_stall();  <- Here we check if the stall val is set to zero
> > and just return
> >     /* do all normal work */
> > 
> > }
> > 
> > In the normal flow of things rc_start_gp() will ultimately call
> > record_gp_stall_check_time which updates the jiffies_stall back to non
> > zero and the stall accounting is back in play.
> 
> Ah, I get it now.  Just out of curiosity, why not set the various
> ->jiffies_stall fields to jiffies + RCU_SECONDS_TILL_STALL_CHECK?
> Is the value of jiffies likely to advance a lot after you call
> rcu_cpu_stall_reset(), perhaps due to the system trying to catch up with
> the passage of time?

Here is an initial patch.  Untested, probably doesn't even compile.
It is against my -rcu tree:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/testing

Thoughts?

							Thanx, Paul

commit 1a745a8467f285e17ded055699ecc557d1b1893e
Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Date:   Tue Aug 10 14:28:53 2010 -0700

    rcu: permit suppressing current grace period's CPU stall warnings
    
    When using a kernel debugger, a long sojourn in the debugger can get
    you lots of RCU CPU stall warnings once you resume.  This might not be
    helpful, especially if you are using the system console.  This patch
    therefore allows RCU CPU stall warnings to be suppressed, but only for
    the duration of the current set of grace periods.
    
    Requested-by: Jason Wessel <jason.wessel@windriver.com>
    Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 4cc5eba..3fa1797 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -178,6 +178,10 @@ static inline void rcu_sched_force_quiescent_state(void)
 {
 }
 
+static inline void rcu_cpu_stall_reset(void)
+{
+}
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
 extern int rcu_scheduler_active __read_mostly;
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index c13b85d..0726809 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -36,6 +36,7 @@ extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
+extern void rcu_cpu_stall_reset(void);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ff21411..42140a8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -565,6 +565,22 @@ static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 	return NOTIFY_DONE;
 }
 
+/**
+ * rcu_cpu_stall_reset - prevent further stall warnings in current grace period
+ *
+ * Set the stall-warning timeout way off into the future, thus preventing
+ * any RCU CPU stall-warning messages from appearing in the current set of
+ * RCU grace periods.
+ *
+ * The caller must disable hard irqs.
+ */
+void rcu_cpu_stall_reset(void)
+{
+	rcu_sched_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_bh_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+	rcu_preempt_stall_reset();
+}
+
 static struct notifier_block rcu_panic_block = {
 	.notifier_call = rcu_panic,
 };
@@ -584,6 +600,10 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 }
 
+void rcu_cpu_stall_reset(void)
+{
+}
+
 static void __init check_cpu_stall_init(void)
 {
 }
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index bb4d086..7abd439 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -372,6 +372,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
+static void rcu_preempt_stall_reset(void);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 63bb771..561410f 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -417,6 +417,16 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 	}
 }
 
+/*
+ * Suppress preemptible RCU's CPU stall warnings by pushing the
+ * time of the next stall-warning message comfortably far into the
+ * future.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+	rcu_preempt_state.jiffies_stall = jiffies + ULONG_MAX / 2;
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -867,6 +877,14 @@ static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 }
 
+/*
+ * Because preemptible RCU does not exist, there is no need to suppress
+ * its CPU stall warnings.
+ */
+static void rcu_preempt_stall_reset(void)
+{
+}
+
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
