Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1HOPyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 11:54:49 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46598 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754952Ab1HOPy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 11:54:26 -0400
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
Subject: [PATCH 31/32] rcu: Switch to extended quiescent state in userspace from nohz cpuset
Date: Mon, 15 Aug 2011 17:52:28 +0200
Message-Id: <1313423549-27093-32-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we switch to adaptive nohz mode and we run in userspace,
we can still receive IPIs from the RCU core if a grace period
has been started by another CPU because we need to take part
of its completion.

However running in userspace is similar to that of running in
idle because we don't make use of RCU there, thus we can be
considered as running in RCU extended quiescent state. The
benefit when running into that mode is that we are not
anymore disturbed by needless IPIs coming from the RCU core.

To perform this, we just to use the RCU extended quiescent state
APIs on the following points:

- kernel exit or tick stop in userspace: here we switch to extended
quiescent state because we run in userspace without the tick.

- kernel entry or tick restart: here we exit the extended quiescent
state because either we enter the kernel and we may make use of RCU
read side critical section anytime, or we need the timer tick for some
reason and that takes care of RCU grace period in a traditional way.

TODO: hook into do_notify_resume() because we may have called
rcu_enter_nohz() from syscall exit hook, but we might call
do_notify_resume() right after, which may use RCU.

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
 include/linux/tick.h     |    2 ++
 kernel/sched.c           |    1 +
 kernel/time/tick-sched.c |   21 +++++++++++++++++++++
 3 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 9d0270e..4e7555f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -138,12 +138,14 @@ extern u64 get_cpu_iowait_time_us(int cpu, u64 *last_update_time);
 
 #ifdef CONFIG_CPUSETS_NO_HZ
 DECLARE_PER_CPU(int, task_nohz_mode);
+DECLARE_PER_CPU(int, nohz_task_ext_qs);
 
 extern void tick_nohz_enter_kernel(void);
 extern void tick_nohz_exit_kernel(void);
 extern void tick_nohz_enter_exception(struct pt_regs *regs);
 extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern int tick_nohz_adaptive_mode(void);
+extern void tick_nohz_cpu_exit_qs(void);
 extern bool tick_nohz_account_tick(void);
 extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
diff --git a/kernel/sched.c b/kernel/sched.c
index 2bcd456..576d0bf 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2504,6 +2504,7 @@ static void cpuset_nohz_restart_tick(void)
 	__get_cpu_var(task_nohz_mode) = 0;
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
+	tick_nohz_cpu_exit_qs();
 }
 
 void cpuset_update_nohz(void)
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 9a2ba5b..b611b77 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -757,6 +757,7 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_CPUSETS_NO_HZ
+DEFINE_PER_CPU(int, nohz_task_ext_qs);
 
 void tick_nohz_exit_kernel(void)
 {
@@ -783,6 +784,9 @@ void tick_nohz_exit_kernel(void)
 	ts->saved_jiffies = jiffies;
 	ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
 
+	__get_cpu_var(nohz_task_ext_qs) = 1;
+	rcu_enter_nohz();
+
 	local_irq_restore(flags);
 }
 
@@ -799,6 +803,11 @@ void tick_nohz_enter_kernel(void)
 		return;
 	}
 
+	if (__get_cpu_var(nohz_task_ext_qs) == 1) {
+		__get_cpu_var(nohz_task_ext_qs) = 0;
+		rcu_exit_nohz();
+	}
+
 	ts = &__get_cpu_var(tick_cpu_sched);
 
 	WARN_ON_ONCE(ts->saved_jiffies_whence == JIFFIES_SAVED_SYS);
@@ -814,6 +823,16 @@ void tick_nohz_enter_kernel(void)
 	local_irq_restore(flags);
 }
 
+void tick_nohz_cpu_exit_qs(void)
+{
+	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+	if (__get_cpu_var(nohz_task_ext_qs)) {
+		rcu_exit_nohz();
+		__get_cpu_var(nohz_task_ext_qs) = 0;
+	}
+}
+
 void tick_nohz_enter_exception(struct pt_regs *regs)
 {
 	if (user_mode(regs))
@@ -858,6 +877,8 @@ static void tick_nohz_cpuset_stop_tick(int user)
 		if (user) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
 			ts->saved_jiffies = jiffies;
+			__get_cpu_var(nohz_task_ext_qs) = 1;
+			rcu_enter_nohz();
 		} else if (!current->mm) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
 			ts->saved_jiffies = jiffies;
-- 
1.7.5.4

