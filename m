Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab2FVP02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:26:28 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:53481 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933213Ab2FVP0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:26:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 03/22] rcu: Size rcu_node tree from nr_cpu_ids rather than NR_CPUS
Date: Fri, 22 Jun 2012 08:17:02 -0700
Message-Id: <1340378241-6458-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120622151655.GA6249@linux.vnet.ibm.com>
 <1340378241-6458-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062215-1780-0000-0000-000006B6BC74
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000282; HX=3.00000190; KW=3.00000007;
 PH=3.00000001; SC=3.00000003; SDB=6.00150292; UDB=6.00034140; UTC=2012-06-22
 15:26:20
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
index 260c1a3..f06a655 100644
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
index 61aab6f..67b3b97 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -72,6 +72,8 @@ static void __init rcu_bootup_announce_oddness(void)
 #endif
 	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
 		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout to %d.\n", rcu_fanout_leaf);
+	if (nr_cpu_ids != NR_CPUS)
+		printk(KERN_INFO "\tRCU restricting CPUs from NR_CPUS=%d to nr_cpu_ids=%d.\n", NR_CPUS, nr_cpu_ids);
 }
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
-- 
1.7.8

