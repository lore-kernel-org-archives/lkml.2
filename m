Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031005Ab2CUN7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 09:59:40 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61813 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030946Ab2CUN7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 09:59:36 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>, Ingo Molnar <mingo@kernel.org>,
        Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Zen Lin <zen@openhuawei.org>
Subject: [PATCH 13/32] nohz/cpuset: Don't stop the tick if posix cpu timers are running
Date: Wed, 21 Mar 2012 14:58:19 +0100
Message-Id: <1332338318-5958-15-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
References: <1332338318-5958-1-git-send-email-fweisbec@gmail.com>
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
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Zen Lin <zen@openhuawei.org>
---
 include/linux/posix-timers.h |    1 +
 kernel/posix-cpu-timers.c    |   12 ++++++++++++
 kernel/time/tick-sched.c     |    4 ++++
 3 files changed, 17 insertions(+), 0 deletions(-)

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
index 125cb67..79d4c24 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -6,6 +6,7 @@
 #include <linux/posix-timers.h>
 #include <linux/errno.h>
 #include <linux/math64.h>
+#include <linux/cpuset.h>
 #include <asm/uaccess.h>
 #include <linux/kernel_stat.h>
 #include <trace/events/timer.h>
@@ -1274,6 +1275,17 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
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
index 4f99766..fc35d41 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -21,6 +21,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/cpuset.h>
+#include <linux/posix-timers.h>
 
 #include <asm/irq_regs.h>
 
@@ -512,6 +513,9 @@ static bool can_stop_adaptive_tick(void)
 	if (!sched_can_stop_tick())
 		return false;
 
+	if (posix_cpu_timers_running(current))
+		return false;
+
 	/* Is there a grace period to complete ? */
 	if (rcu_pending(smp_processor_id()))
 		return false;
-- 
1.7.5.4

