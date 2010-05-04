Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934115Ab0EDU2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 16:28:36 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50493 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933662Ab0EDUUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 16:20:16 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 26/48] rcu: RCU_FAST_NO_HZ must check RCU dyntick state
Date: Tue,  4 May 2010 13:19:36 -0700
Message-Id: <1273004398-19760-26-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <20100504201934.GA19234@linux.vnet.ibm.com>
References: <20100504201934.GA19234@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current version of RCU_FAST_NO_HZ reproduces the old CLASSIC_RCU
dyntick-idle bug, as it fails to detect CPUs that have interrupted
or NMIed out of dyntick-idle mode.  Fix this by making rcu_needs_cpu()
check the state in the per-CPU rcu_dynticks variables, thus correctly
detecting the dyntick-idle state from an RCU perspective.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 5c599e8..92e5c9b 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -1053,6 +1053,8 @@ static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
 int rcu_needs_cpu(int cpu)
 {
 	int c = 0;
+	int snap;
+	int snap_nmi;
 	int thatcpu;
 
 	/* Check for being in the holdoff period. */
@@ -1060,12 +1062,18 @@ int rcu_needs_cpu(int cpu)
 		return rcu_needs_cpu_quick_check(cpu);
 
 	/* Don't bother unless we are the last non-dyntick-idle CPU. */
-	for_each_cpu_not(thatcpu, nohz_cpu_mask)
-		if (cpu_online(thatcpu) && thatcpu != cpu) {
+	for_each_online_cpu(thatcpu) {
+		if (thatcpu == cpu)
+			continue;
+		snap = per_cpu(rcu_dynticks, thatcpu)->dynticks;
+		snap_nmi = per_cpu(rcu_dynticks, thatcpu)->dynticks_nmi;
+		smp_mb(); /* Order sampling of snap with end of grace period. */
+		if (((snap & 0x1) != 0) || ((snap_nmi & 0x1) != 0)) {
 			per_cpu(rcu_dyntick_drain, cpu) = 0;
 			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
 			return rcu_needs_cpu_quick_check(cpu);
 		}
+	}
 
 	/* Check and update the rcu_dyntick_drain sequencing. */
 	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
-- 
1.7.0

