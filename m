Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1EHNeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 09:34:22 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58253 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1EHNeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 09:34:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, Gleb Natapov <gleb@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/3] rcu: provide rcu_virt_note_context_switch() function.
Date: Sun,  8 May 2011 06:34:09 -0700
Message-Id: <1304861650-18475-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110508133343.GA18287@linux.vnet.ibm.com>
References: <20110508133343.GA18287@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Provide rcu_virt_note_context_switch() for vitalization use to note
quiescent state during guest entry.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutiny.h |    8 ++++++++
 include/linux/rcutree.h |   10 ++++++++++
 kernel/rcutree.c        |    1 +
 3 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 30ebd7c..52b3e02 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -100,6 +100,14 @@ static inline void rcu_note_context_switch(int cpu)
 }
 
 /*
+ * Take advantage of the fact that there is only one CPU, which
+ * allows us to ignore virtualization-based context switches.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+}
+
+/*
  * Return the number of grace periods.
  */
 static inline long rcu_batches_completed(void)
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 284dad1..e65d066 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,6 +35,16 @@ extern void rcu_note_context_switch(int cpu);
 extern int rcu_needs_cpu(int cpu);
 extern void rcu_cpu_stall_reset(void);
 
+/*
+ * Note a virtualization-based context switch.  This is simply a
+ * wrapper around rcu_note_context_switch(), which allows TINY_RCU
+ * to save a few bytes.
+ */
+static inline void rcu_virt_note_context_switch(int cpu)
+{
+	rcu_note_context_switch(cpu);
+}
+
 #ifdef CONFIG_TREE_PREEMPT_RCU
 
 extern void exit_rcu(void);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b2fe2a2..54ff7eb 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -157,6 +157,7 @@ void rcu_note_context_switch(int cpu)
 	rcu_sched_qs(cpu);
 	rcu_preempt_note_context_switch(cpu);
 }
+EXPORT_SYMBOL_GPL(rcu_note_context_switch);
 
 #ifdef CONFIG_NO_HZ
 DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks) = {
-- 
1.7.3.2

