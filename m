Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab1HOPxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:55 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab1HOPxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:52 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [PATCH 21/32] rcu: Restart the tick on non-responding adaptive nohz CPUs
Date: Mon, 15 Aug 2011 17:52:18 +0200
Message-Id: <1313423549-27093-22-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU in adaptive nohz mode doesn't respond to complete
a grace period, issue it a specific IPI so that it restarts
the tick and chases a quiescent state.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Paul E . McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 0009bfc..d496c70 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -50,6 +50,7 @@
 #include <linux/wait.h>
 #include <linux/kthread.h>
 #include <linux/prefetch.h>
+#include <linux/cpuset.h>
 
 #include "rcutree.h"
 
@@ -295,6 +296,20 @@ static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
 
 #ifdef CONFIG_SMP
 
+static void cpuset_update_rcu_cpu(int cpu)
+{
+#ifdef CONFIG_CPUSETS_NO_HZ
+	unsigned long flags;
+
+	local_irq_save(flags);
+
+	if (cpuset_cpu_adaptive_nohz(cpu))
+		smp_cpuset_update_nohz(cpu);
+
+	local_irq_restore(flags);
+#endif
+}
+
 /*
  * If the specified CPU is offline, tell the caller that it is in
  * a quiescent state.  Otherwise, whack it with a reschedule IPI.
@@ -317,6 +332,8 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
+	cpuset_update_rcu_cpu(rdp->cpu);
+
 	/* If preemptible RCU, no point in sending reschedule IPI. */
 	if (rdp->preemptible)
 		return 0;
-- 
1.7.5.4

