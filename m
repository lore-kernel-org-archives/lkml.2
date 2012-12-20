Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2LTSld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:41:33 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60120 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2LTSlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:41:23 -0500
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
Subject: [PATCH 23/24] nohz: Don't stop the tick if posix cpu timers are running
Date: Thu, 20 Dec 2012 19:33:10 +0100
Message-Id: <1356028391-14427-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If either a per thread or a per process posix cpu timer is running,
don't stop the tick.

TODO: restart the tick if it is stopped and a posix cpu timer is
enqueued. Check we probably need a memory barrier for the per
process posix timer that can be enqueued from another task
of the group.

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
 include/linux/posix-timers.h |    1 +
 kernel/posix-cpu-timers.c    |   11 +++++++++++
 kernel/time/tick-sched.c     |    4 ++++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..97480c2 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -119,6 +119,7 @@ int posix_timer_event(struct k_itimer *timr, int si_private);
 void posix_cpu_timer_schedule(struct k_itimer *timer);
 
 void run_posix_cpu_timers(struct task_struct *task);
+bool posix_cpu_timers_running(struct task_struct *tsk);
 void posix_cpu_timers_exit(struct task_struct *task);
 void posix_cpu_timers_exit_group(struct task_struct *task);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 3d58bd5..d3b46b3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1266,6 +1266,17 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	return 0;
 }
 
+bool posix_cpu_timers_running(struct task_struct *tsk)
+{
+	if (!task_cputime_zero(&tsk->cputime_expires))
+		return true;
+
+	if (tsk->signal->cputimer.running)
+		return true;
+
+	return false;
+}
+
 /*
  * This is called from the timer interrupt handler.  The irq handler has
  * already updated our counts.  We need to check if any timers fire now.
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 0c9281a..4f4fa13 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
+#include <linux/posix-timers.h>
 
 #include <asm/irq_regs.h>
 
@@ -597,6 +598,9 @@ static bool can_stop_full_tick(int cpu)
 	if (rcu_pending(cpu))
 		return false;
 
+	if (posix_cpu_timers_running(current))
+		return false;
+
 	return true;
 }
 #endif
-- 
1.7.5.4

