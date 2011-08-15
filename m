Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab1HOPxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:53:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab1HOPxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:53:42 -0400
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
Subject: [PATCH 18/32] nohz/cpuset: Don't stop the tick if posix cpu timers are running
Date: Mon, 15 Aug 2011 17:52:15 +0200
Message-Id: <1313423549-27093-19-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
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
 include/linux/posix-timers.h |    1 +
 kernel/posix-cpu-timers.c    |   12 ++++++++++++
 kernel/sched.c               |    4 ++++
 3 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 959c141..5092cfd 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -116,6 +116,7 @@ int posix_timer_event(struct k_itimer *timr, int si_private);
 void posix_cpu_timer_schedule(struct k_itimer *timer);
 
 void run_posix_cpu_timers(struct task_struct *task);
+bool posix_cpu_timers_running(struct task_struct *tsk);
 void posix_cpu_timers_exit(struct task_struct *task);
 void posix_cpu_timers_exit_group(struct task_struct *task);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 58f405b..f284fa4 100644
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
@@ -1300,6 +1301,17 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
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
diff --git a/kernel/sched.c b/kernel/sched.c
index 8bf8280..78ea0a5 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -71,6 +71,7 @@
 #include <linux/ctype.h>
 #include <linux/ftrace.h>
 #include <linux/slab.h>
+#include <linux/posix-timers.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -2491,6 +2492,9 @@ bool cpuset_nohz_can_stop_tick(void)
 	if (rcu_pending(cpu))
 		return false;
 
+	if (posix_cpu_timers_running(current))
+		return false;
+
 	return true;
 }
 
-- 
1.7.5.4

