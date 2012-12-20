Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2LTSfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:35:14 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:51573 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2LTSdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:33:44 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 09/24] nohz: Wake up full dynticks CPUs when a timer gets enqueued
Date: Thu, 20 Dec 2012 19:32:56 +0100
Message-Id: <1356028391-14427-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wake up a CPU when a timer list timer is enqueued there and
the CPU is in full dynticks mode. Sending an IPI to it makes
it reconsidering the next timer to program on top of recent
updates.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |    4 ++--
 kernel/sched/core.c   |   18 +++++++++++++++++-
 kernel/timer.c        |    2 +-
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 727b988..8a89dc6 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2038,9 +2038,9 @@ static inline void idle_task_exit(void) {}
 #endif
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
-extern void wake_up_idle_cpu(int cpu);
+extern void wake_up_nohz_cpu(int cpu);
 #else
-static inline void wake_up_idle_cpu(int cpu) { }
+static inline void wake_up_nohz_cpu(int cpu) { }
 #endif
 
 extern unsigned int sysctl_sched_latency;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6271b89..1ca0a66 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -579,7 +579,7 @@ unlock:
  * account when the CPU goes back to idle and evaluates the timer
  * wheel for the next timer event.
  */
-void wake_up_idle_cpu(int cpu)
+static void wake_up_idle_cpu(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
@@ -609,6 +609,22 @@ void wake_up_idle_cpu(int cpu)
 		smp_send_reschedule(cpu);
 }
 
+static bool wake_up_full_nohz_cpu(int cpu)
+{
+	if (tick_nohz_full_cpu(cpu)) {
+		smp_send_reschedule(cpu);
+		return true;
+	}
+
+	return false;
+}
+
+void wake_up_nohz_cpu(int cpu)
+{
+	if (!wake_up_full_nohz_cpu(cpu))
+		wake_up_idle_cpu(cpu);
+}
+
 static inline bool got_nohz_idle_kick(void)
 {
 	int cpu = smp_processor_id();
diff --git a/kernel/timer.c b/kernel/timer.c
index ff3b516..970b57d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -936,7 +936,7 @@ void add_timer_on(struct timer_list *timer, int cpu)
 	 * makes sure that a CPU on the way to idle can not evaluate
 	 * the timer wheel.
 	 */
-	wake_up_idle_cpu(cpu);
+	wake_up_nohz_cpu(cpu);
 	spin_unlock_irqrestore(&base->lock, flags);
 }
 EXPORT_SYMBOL_GPL(add_timer_on);
-- 
1.7.5.4

