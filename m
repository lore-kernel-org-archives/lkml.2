Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab1EANW0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:22:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60484 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1EANWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:22 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/86] rcu: put per-CPU kthread at non-RT priority during CPU hotplug operations
Date: Sun,  1 May 2011 06:20:48 -0700
Message-Id: <1304256126-26015-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paul.mckenney@linaro.org>

If you are doing CPU hotplug operations, it is best not to have
CPU-bound realtime tasks running CPU-bound on the outgoing CPU.
So this commit makes per-CPU kthreads run at non-realtime priority
during that time.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 85b06c5..eca6f05 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -1464,6 +1464,30 @@ static void invoke_rcu_node_kthread(struct rcu_node *rnp)
 }
 
 /*
+ * Set the specified CPU's kthread to run RT or not, as specified by
+ * the to_rt argument.  The CPU-hotplug locks are held, so the task
+ * is not going away.
+ */
+static void rcu_cpu_kthread_setrt(int cpu, int to_rt)
+{
+	int policy;
+	struct sched_param sp;
+	struct task_struct *t;
+
+	t = per_cpu(rcu_cpu_kthread_task, cpu);
+	if (t == NULL)
+		return;
+	if (to_rt) {
+		policy = SCHED_FIFO;
+		sp.sched_priority = RCU_KTHREAD_PRIO;
+	} else {
+		policy = SCHED_NORMAL;
+		sp.sched_priority = 0;
+	}
+	sched_setscheduler_nocheck(t, policy, &sp);
+}
+
+/*
  * Timer handler to initiate the waking up of per-CPU kthreads that
  * have yielded the CPU due to excess numbers of RCU callbacks.
  * We wake up the per-rcu_node kthread, which in turn will wake up
@@ -2166,9 +2190,11 @@ static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE:
 	case CPU_DOWN_FAILED:
 		rcu_node_kthread_setaffinity(rnp, -1);
+		rcu_cpu_kthread_setrt(cpu, 1);
 		break;
 	case CPU_DOWN_PREPARE:
 		rcu_node_kthread_setaffinity(rnp, cpu);
+		rcu_cpu_kthread_setrt(cpu, 0);
 		break;
 	case CPU_DYING:
 	case CPU_DYING_FROZEN:
-- 
1.7.3.2

