Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0DOSQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 14:16:22 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:48056 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab0DOSNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 14:13:50 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 12/16] rcu: disable CPU stall warnings upon panic
Date: Thu, 15 Apr 2010 11:13:35 -0700
Message-Id: <1271355219-20714-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100415181255.GA19588@linux.vnet.ibm.com>
References: <20100415181255.GA19588@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current RCU CPU stall warnings remain enabled even after a panic
occurs, which some people have found to be a bit counterproductive.
This patch therefore uses a notifier to disable stall warnings once a
panic occurs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   24 ++++++++++++++++++++++++
 1 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 3623f8e..595fb83 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -449,6 +449,8 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
+int rcu_cpu_stall_panicking __read_mostly;
+
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
 	rsp->gp_start = jiffies;
@@ -526,6 +528,8 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	long delta;
 	struct rcu_node *rnp;
 
+	if (rcu_cpu_stall_panicking)
+		return;
 	delta = jiffies - rsp->jiffies_stall;
 	rnp = rdp->mynode;
 	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
@@ -540,6 +544,21 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	}
 }
 
+static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
+{
+	rcu_cpu_stall_panicking = 1;
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rcu_panic_block = {
+	.notifier_call = rcu_panic,
+};
+
+static void __init check_cpu_stall_init(void)
+{
+	atomic_notifier_chain_register(&panic_notifier_list, &rcu_panic_block);
+}
+
 #else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
@@ -550,6 +569,10 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 }
 
+static void __init check_cpu_stall_init(void)
+{
+}
+
 #endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 /*
@@ -1934,6 +1957,7 @@ void __init rcu_init(void)
 	cpu_notifier(rcu_cpu_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
+	check_cpu_stall_init();
 }
 
 #include "rcutree_plugin.h"
-- 
1.7.0

