Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004Ab2FOVGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 17:06:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44543 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757981Ab2FOVGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 17:06:32 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/15] rcu: Size rcu_node tree from nr_cpu_ids rather than NR_CPUS
Date: Fri, 15 Jun 2012 14:05:57 -0700
Message-Id: <1339794370-28119-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061521-3534-0000-0000-00000966C5B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_node tree array is sized based on compile-time constants,
including NR_CPUS.  Although this approach has worked well in the past,
the recent trend by many distros to define NR_CPUS=4096 results in
excessive grace-period-initialization latencies.

This commit therefore substitutes the run-time computed nr_cpu_ids for
the compile-time NR_CPUS when building the tree.  This can result in
much of the compile-time-allocated rcu_node array being unused.  If
this is a major problem, you are in a specialized situation anyway,
so you can manually adjust the NR_CPUS, RCU_FANOUT, and RCU_FANOUT_LEAF
kernel config parameters.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c        |    2 +-
 kernel/rcutree_plugin.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index a151184..9098910 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -2672,7 +2672,7 @@ static void __init rcu_init_geometry(void)
 {
 	int i;
 	int j;
-	int n = NR_CPUS;
+	int n = nr_cpu_ids;
 	int rcu_capacity[MAX_RCU_LVLS + 1];
 
 	/* If the compile-time values are accurate, just leave. */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index e9b44c3..7cb86ae 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -72,6 +72,8 @@ static void __init rcu_bootup_announce_oddness(void)
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
 		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout.\n");
+	if (nr_cpu_ids != NR_CPUS)
+		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
-- 
1.7.8

