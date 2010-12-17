Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0LQU6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 15:58:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:51574 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756180Ab0LQUzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 15:55:05 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 17/20] rcu: limit rcu_node leaf-level fanout
Date: Fri, 17 Dec 2010 12:54:48 -0800
Message-Id: <1292619291-2468-17-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20101217205433.GA10199@linux.vnet.ibm.com>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent benchmarks have indicated possible lock contention on the
leaf-level rcu_node locks.  This commit therefore limits the number of
CPUs per leaf-level rcu_node structure to 16, in other words, there
can be at most 16 rcu_data structures fanning into a given rcu_node
structure.  Prior to this, the limit was 32 on 32-bit systems and 64 on
64-bit systems.

Note that the fanout of non-leaf rcu_node structures is unchanged.  The
organization of accesses to the rcu_node tree is such that references
to non-leaf rcu_node structures are much less frequent than to the
leaf structures.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |    3 ++-
 kernel/rcutree.h |   43 ++++++++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 20 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index c39ec5b..01c8ad3 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1869,8 +1869,9 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 {
 	int i;
 
-	for (i = NUM_RCU_LVLS - 1; i >= 0; i--)
+	for (i = NUM_RCU_LVLS - 1; i > 0; i--)
 		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
+	rsp->levelspread[0] = RCU_FANOUT_LEAF;
 }
 #else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
 static void __init rcu_init_levelspread(struct rcu_state *rsp)
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 1a54be2..e8f057e 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -31,46 +31,51 @@
 /*
  * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
  * In theory, it should be possible to add more levels straightforwardly.
- * In practice, this has not been tested, so there is probably some
- * bug somewhere.
+ * In practice, this did work well going from three levels to four.
+ * Of course, your mileage may vary.
  */
 #define MAX_RCU_LVLS 4
-#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
-#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
-#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
-#define RCU_FANOUT_FOURTH     (RCU_FANOUT_CUBE * RCU_FANOUT)
-
-#if NR_CPUS <= RCU_FANOUT
+#if CONFIG_RCU_FANOUT > 16
+#define RCU_FANOUT_LEAF       16
+#else /* #if CONFIG_RCU_FANOUT > 16 */
+#define RCU_FANOUT_LEAF       (CONFIG_RCU_FANOUT)
+#endif /* #else #if CONFIG_RCU_FANOUT > 16 */
+#define RCU_FANOUT_1	      (RCU_FANOUT_LEAF)
+#define RCU_FANOUT_2	      (RCU_FANOUT_1 * CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_3	      (RCU_FANOUT_2 * CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_4	      (RCU_FANOUT_3 * CONFIG_RCU_FANOUT)
+
+#if NR_CPUS <= RCU_FANOUT_1
 #  define NUM_RCU_LVLS	      1
 #  define NUM_RCU_LVL_0	      1
 #  define NUM_RCU_LVL_1	      (NR_CPUS)
 #  define NUM_RCU_LVL_2	      0
 #  define NUM_RCU_LVL_3	      0
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_SQ
+#elif NR_CPUS <= RCU_FANOUT_2
 #  define NUM_RCU_LVLS	      2
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
 #  define NUM_RCU_LVL_2	      (NR_CPUS)
 #  define NUM_RCU_LVL_3	      0
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_CUBE
+#elif NR_CPUS <= RCU_FANOUT_3
 #  define NUM_RCU_LVLS	      3
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
-#  define NUM_RCU_LVL_3	      NR_CPUS
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_2)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
+#  define NUM_RCU_LVL_3	      (NR_CPUS)
 #  define NUM_RCU_LVL_4	      0
-#elif NR_CPUS <= RCU_FANOUT_FOURTH
+#elif NR_CPUS <= RCU_FANOUT_4
 #  define NUM_RCU_LVLS	      4
 #  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_CUBE)
-#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT)
-#  define NUM_RCU_LVL_4	      NR_CPUS
+#  define NUM_RCU_LVL_1	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_3)
+#  define NUM_RCU_LVL_2	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_2)
+#  define NUM_RCU_LVL_3	      DIV_ROUND_UP(NR_CPUS, RCU_FANOUT_1)
+#  define NUM_RCU_LVL_4	      (NR_CPUS)
 #else
 # error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
-#endif /* #if (NR_CPUS) <= RCU_FANOUT */
+#endif /* #if (NR_CPUS) <= RCU_FANOUT_1 */
 
 #define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3 + NUM_RCU_LVL_4)
 #define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
-- 
1.7.3.2

