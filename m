Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0GNUOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:14:10 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43947 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757532Ab0GNUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 29/30] rcu: add boot parameter to suppress RCU CPU stall warning messages
Date: Wed, 14 Jul 2010 13:10:03 -0700
Message-Id: <1279138204-12849-29-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the RCU CPU stall warning messages are a very good way to alert
people to a problem, once alerted, it is sometimes helpful to shut them
off in order to avoid obscuring other messages that might be being used
to track down the problem.  Although you can rebuild the kernel with
CONFIG_RCU_CPU_STALL_DETECTOR=n, this is sometimes inconvenient.  This
commit therefore adds a boot parameter named "rcu_cpu_stall_suppress"
that shuts these messages off without requiring a rebuild (though a
reboot might be needed for those not brave enough to patch their kernel
while it is running).

This message-suppression was already in place for the panic case, so this
commit need only rename the variable and export it via module_param().

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 5b1c3c2..f3d5906 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -143,6 +143,11 @@ module_param(blimit, int, 0);
 module_param(qhimark, int, 0);
 module_param(qlowmark, int, 0);
 
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+int rcu_cpu_stall_suppress __read_mostly;
+module_param(rcu_cpu_stall_suppress, int, 0);
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
 static int rcu_pending(int cpu);
 
@@ -450,7 +455,7 @@ static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
-int rcu_cpu_stall_panicking __read_mostly;
+int rcu_cpu_stall_suppress __read_mostly;
 
 static void record_gp_stall_check_time(struct rcu_state *rsp)
 {
@@ -530,7 +535,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 	long delta;
 	struct rcu_node *rnp;
 
-	if (rcu_cpu_stall_panicking)
+	if (rcu_cpu_stall_suppress)
 		return;
 	delta = jiffies - rsp->jiffies_stall;
 	rnp = rdp->mynode;
@@ -548,7 +553,7 @@ static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 
 static int rcu_panic(struct notifier_block *this, unsigned long ev, void *ptr)
 {
-	rcu_cpu_stall_panicking = 1;
+	rcu_cpu_stall_suppress = 1;
 	return NOTIFY_DONE;
 }
 
-- 
1.7.0.6

