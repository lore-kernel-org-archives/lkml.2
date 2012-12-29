Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2L2QoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 11:44:15 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:63788 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab2L2QoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 11:44:09 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 23/27] nohz: Don't stop the tick if posix cpu timers are running
Date: Sat, 29 Dec 2012 17:43:02 +0100
Message-Id: <1356799386-4212-24-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
References: <1356799386-4212-1-git-send-email-fweisbec@gmail.com>
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
index 165d476..15f8f4f 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1269,6 +1269,17 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
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
index 04504c4..eb6ad3d 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/irq_work.h>
+#include <linux/posix-timers.h>
 
 #include <asm/irq_regs.h>
 
@@ -599,6 +600,9 @@ static bool can_stop_full_tick(int cpu)
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

