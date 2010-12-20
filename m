Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0LTP0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:26:50 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42508 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab0LTPYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KPUo7zaKOcWGzD4hCewsw6kviACzqn7IawuVtG1HpWf7e+wzMq+fLaweKojA/ZgMac
         r94LNpRXCZ4RLg7Km9v3FC3IWK3VIQA6oCtATKfftiOjiocTxsPsvtm+cWd1V+WjZ2w2
         SbB4/muHtgHF4m7eEzsHBxVdJ/yVvIUxG4vvk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: [RFC PATCH 06/15] nohz_task: Keep the tick if rcu needs it
Date: Mon, 20 Dec 2010 16:24:13 +0100
Message-Id: <1292858662-5650-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a nohz task is running, don't stop the tick if RCU
needs the CPU to notify a quiescent state or if it has
callbacks to handle.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Blanchard <anton@au1.ibm.com>
Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    1 +
 kernel/rcutree.c         |    3 +--
 kernel/sched.c           |    6 ++++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 03cda7b..262d48b 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -122,6 +122,7 @@ extern void rcu_init(void);
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern void rcu_check_callbacks(int cpu, int user);
+extern int rcu_pending(int cpu);
 struct notifier_block;
 
 #ifdef CONFIG_NO_HZ
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index ccdc04c..44dce3f 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -149,7 +149,6 @@ module_param(rcu_cpu_stall_suppress, int, 0644);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
-static int rcu_pending(int cpu);
 
 /*
  * Return the number of RCU-sched batches processed thus far for debug & stats.
@@ -1634,7 +1633,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-static int rcu_pending(int cpu)
+int rcu_pending(int cpu)
 {
 	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
 	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
diff --git a/kernel/sched.c b/kernel/sched.c
index 6dbae46..45bd6e2 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2470,10 +2470,16 @@ static void nohz_task_cpu_update(void *unused)
 int nohz_task_can_stop_tick(void)
 {
 	struct rq *rq = this_rq();
+	int cpu;
 
 	if (rq->nr_running > 1)
 		return 0;
 
+	cpu = smp_processor_id();
+
+	if (rcu_pending(cpu) || rcu_needs_cpu(cpu))
+		return 0;
+
 	return 1;
 }
 
-- 
1.7.3.2

