Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab2DWQnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:43:15 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40107 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab2DWQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:12 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss initialization latencies for large systems
Date: Mon, 23 Apr 2012 09:42:27 -0700
Message-Id: <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-4242-0000-0000-0000016DB43D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Commit #0209f649 (rcu: limit rcu_node leaf-level fanout) set an upper
limit of 16 on the leaf-level fanout for the rcu_node tree.  This was
needed to reduce lock contention that was induced by the synchronization
of scheduling-clock interrupts, which was in turn needed to improve
energy efficiency for moderate-sized lightly loaded servers.

However, reducing the leaf-level fanout means that there are more
leaf-level rcu_node structures in the tree, which in turn means that
RCU's grace-period initialization incurs more cache misses.  This is
not a problem on moderate-sized servers with only a few tens of CPUs,
but becomes a major source of real-time latency spikes on systems with
many hundreds of CPUs.  In addition, the workloads running on these large
systems tend to be CPU-bound, which eliminates the energy-efficiency
advantages of synchronizing scheduling-clock interrupts.  Therefore,
these systems need maximal values for the rcu_node leaf-level fanout.

This commit addresses this problem by introducing a new kernel parameter
named RCU_FANOUT_LEAF that directly controls the leaf-level fanout.
This parameter defaults to 16 to handle the common case of a moderate
sized lightly loaded servers, but may be set higher on larger systems.

Reported-by: Mike Galbraith <efault@gmx.de>
Reported-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 init/Kconfig     |   27 +++++++++++++++++++++++++++
 kernel/rcutree.c |    2 +-
 kernel/rcutree.h |   10 +++-------
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 85c6870..6d18ef8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -458,6 +458,33 @@ config RCU_FANOUT
 	  Select a specific number if testing RCU itself.
 	  Take the default if unsure.
 
+config RCU_FANOUT_LEAF
+	int "Tree-based hierarchical RCU leaf-level fanout value"
+	range 2 RCU_FANOUT if 64BIT
+	range 2 RCU_FANOUT if !64BIT
+	depends on TREE_RCU || TREE_PREEMPT_RCU
+	default 16
+	help
+	  This option controls the leaf-level fanout of hierarchical
+	  implementations of RCU, and allows trading off cache misses
+	  against lock contention.  Systems that synchronize their
+	  scheduling-clock interrupts for energy-efficiency reasons will
+	  want the default because the smaller leaf-level fanout keeps
+	  lock contention levels acceptably low.  Very large systems
+	  (hundreds or thousands of CPUs) will instead want to set this
+	  value to the maximum value possible in order to reduce the
+	  number of cache misses incurred during RCU's grace-period
+	  initialization.  These systems tend to run CPU-bound, and thus
+	  are not helped by synchronized interrupts, and thus tend to
+	  skew them, which reduces lock contention enough that large
+	  leaf-level fanouts work well.
+
+	  Select a specific number if testing RCU itself.
+
+	  Select the maximum permissible value for large systems.
+
+	  Take the default if unsure.
+
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
 	depends on TREE_RCU || TREE_PREEMPT_RCU
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 1050d6d..780acf8 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2418,7 +2418,7 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 
 	for (i = NUM_RCU_LVLS - 1; i > 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
-	rsp->levelspread[0] = RCU_FANOUT_LEAF;
+	rsp->levelspread[0] = CONFIG_RCU_FANOUT_LEAF;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index cdd1be0..a905c20 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -29,18 +29,14 @@
 #include <linux/seqlock.h>
 
 /*
- * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
+ * Define shape of hierarchy based on NR_CPUS, CONFIG_RCU_FANOUT, and
+ * CONFIG_RCU_FANOUT_LEAF.
  * In theory, it should be possible to add more levels straightforwardly.
  * In practice, this did work well going from three levels to four.
  * Of course, your mileage may vary.
  */
 #define MAX_RCU_LVLS 4
-#if CONFIG_RCU_FANOUT > 16
-#define RCU_FANOUT_LEAF       16
-#else /* #if CONFIG_RCU_FANOUT > 16 */
-#define RCU_FANOUT_LEAF       (CONFIG_RCU_FANOUT)
-#endif /* #else #if CONFIG_RCU_FANOUT > 16 */
-#define RCU_FANOUT_1	      (RCU_FANOUT_LEAF)
+#define RCU_FANOUT_1	      (CONFIG_RCU_FANOUT_LEAF)
 #define RCU_FANOUT_2	      (RCU_FANOUT_1 * CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_3	      (RCU_FANOUT_2 * CONFIG_RCU_FANOUT)
 #define RCU_FANOUT_4	      (RCU_FANOUT_3 * CONFIG_RCU_FANOUT)
-- 
1.7.8

