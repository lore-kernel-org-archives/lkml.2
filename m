Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab2H3Vnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:43:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:43465 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2H3Vnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 06/15] rcu: Make offline-CPU checking allow for indefinite delays
Date: Thu, 30 Aug 2012 11:56:19 -0700
Message-Id: <1346352988-32444-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-6148-0000-0000-00000917896D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_implicit_offline_qs() function implicitly assumed that execution
would progress predictably when interrupts are disabled, which is of course
not guaranteed when running on a hypervisor.  Furthermore, this function
is short, and is called from one place only in a short function.

This commit therefore ensures that the timing is checked before
checking the condition, which guarantees correct behavior even given
indefinite delays.  It also inlines rcu_implicit_offline_qs() into
rcu_implicit_dynticks_qs().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   53 +++++++++++++++++++++--------------------------------
 1 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 96b8aff..9f44749 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -317,35 +317,6 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 }
 
 /*
- * If the specified CPU is offline, tell the caller that it is in
- * a quiescent state.  Otherwise, whack it with a reschedule IPI.
- * Grace periods can end up waiting on an offline CPU when that
- * CPU is in the process of coming online -- it will be added to the
- * rcu_node bitmasks before it actually makes it online.  The same thing
- * can happen while a CPU is in the process of coming online.  Because this
- * race is quite rare, we check for it after detecting that the grace
- * period has been delayed rather than checking each and every CPU
- * each and every time we start a new grace period.
- */
-static int rcu_implicit_offline_qs(struct rcu_data *rdp)
-{
-	/*
-	 * If the CPU is offline for more than a jiffy, it is in a quiescent
-	 * state.  We can trust its state not to change because interrupts
-	 * are disabled.  The reason for the jiffy's worth of slack is to
-	 * handle CPUs initializing on the way up and finding their way
-	 * to the idle loop on the way down.
-	 */
-	if (cpu_is_offline(rdp->cpu) &&
-	    ULONG_CMP_LT(rdp->rsp->gp_start + 2, jiffies)) {
-		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
-		rdp->offline_fqs++;
-		return 1;
-	}
-	return 0;
-}
-
-/*
  * rcu_idle_enter_common - inform RCU that current CPU is moving towards idle
  *
  * If the new value of the ->dynticks_nesting counter now is zero,
@@ -675,7 +646,7 @@ static int dyntick_save_progress_counter(struct rcu_data *rdp)
  * Return true if the specified CPU has passed through a quiescent
  * state by virtue of being in or having passed through an dynticks
  * idle state since the last call to dyntick_save_progress_counter()
- * for this same CPU.
+ * for this same CPU, or by virtue of having been offline.
  */
 static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 {
@@ -699,8 +670,26 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
-	/* Go check for the CPU being offline. */
-	return rcu_implicit_offline_qs(rdp);
+	/*
+	 * Check for the CPU being offline, but only if the grace period
+	 * is old enough.  We don't need to worry about the CPU changing
+	 * state: If we see it offline even once, it has been through a
+	 * quiescent state.
+	 *
+	 * The reason for insisting that the grace period be at least
+	 * one jiffy old is that CPUs that are not quite online and that
+	 * have just gone offline can still execute RCU read-side critical
+	 * sections.
+	 */
+	if (ULONG_CMP_GE(rdp->rsp->gp_start + 2, jiffies))
+		return 0;  /* Grace period is not old enough. */
+	barrier();
+	if (cpu_is_offline(rdp->cpu)) {
+		trace_rcu_fqs(rdp->rsp->name, rdp->gpnum, rdp->cpu, "ofl");
+		rdp->offline_fqs++;
+		return 1;
+	}
+	return 0;
 }
 
 static int jiffies_till_stall_check(void)
-- 
1.7.8

