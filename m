Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759691Ab2J2UjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:39:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18478 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab2J2Uiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:38:55 -0400
X-Authority-Analysis: v=2.0 cv=KcBQQHkD c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=NUiy80xzjYkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=Myyqfof8AEkA:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=9AzMRrQhAAAA:8 a=NufY4J3AAAAA:8 a=KKAkSRfTAAAA:8 a=JfrnYn6hAAAA:8 a=ftUzEednAAAA:8 a=sozttTNsAAAA:8 a=EUspDBNiAAAA:8 a=VnNF1IyMAAAA:8 a=fh4mg5NFAAAA:8 a=ayC55rCoAAAA:8 a=Gc1rIOvl34UhWScpVeAA:9 a=E6k37eg1NvgA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=jbrJJM5MRmoA:10 a=jEp0ucaQiEUA:10 a=SxxB86fLhQ4A:10 a=re9sYKne76oA:10 a=WwgC8nHKvroA:10 a=3Rfx1nUSh_UA:10 a=QwxQZocgbLcA:10 a=x2szoZtqnggA:10 a=IG2fH9E8heMA:10 a=Im-eZXwrtqoA:10 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121029203851.039482257@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 29 Oct 2012 16:27:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Subject: [PATCH 30/32] rcu: Switch to extended quiescent state in userspace from nohz
 cpuset
References: <20121029202711.062749374@goodmis.org>
Content-Disposition: inline; filename=0030-rcu-Switch-to-extended-quiescent-state-in-userspace-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

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

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Kevin Hilman <khilman@ti.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tick.h     |    3 +++
 kernel/time/tick-sched.c |   27 +++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 3c31d6e..e2a49ad 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -153,6 +153,8 @@ static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
 #ifdef CONFIG_CPUSETS_NO_HZ
+DECLARE_PER_CPU(int, nohz_task_ext_qs);
+
 extern void tick_nohz_enter_kernel(void);
 extern void tick_nohz_exit_kernel(void);
 extern void tick_nohz_enter_exception(struct pt_regs *regs);
@@ -160,6 +162,7 @@ extern void tick_nohz_exit_exception(struct pt_regs *regs);
 extern void tick_nohz_check_adaptive(void);
 extern void tick_nohz_pre_schedule(void);
 extern void tick_nohz_post_schedule(void);
+extern void tick_nohz_cpu_exit_qs(void);
 extern bool tick_nohz_account_tick(void);
 extern void tick_nohz_flush_current_times(bool restart_tick);
 #else /* !CPUSETS_NO_HZ */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 16267ee..bdd40bb 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -571,10 +571,13 @@ static void tick_nohz_cpuset_stop_tick(struct tick_sched *ts)
 
 	if (!was_stopped && ts->tick_stopped) {
 		WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_NONE);
-		if (user)
+		if (user) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
-		else if (!current->mm)
+			__get_cpu_var(nohz_task_ext_qs) = 1;
+			rcu_user_enter_irq();
+		} else if (!current->mm) {
 			ts->saved_jiffies_whence = JIFFIES_SAVED_SYS;
+		}
 
 		ts->saved_jiffies = jiffies;
 		set_thread_flag(TIF_NOHZ);
@@ -906,6 +909,8 @@ void tick_check_idle(int cpu)
 }
 
 #ifdef CONFIG_CPUSETS_NO_HZ
+DEFINE_PER_CPU(int, nohz_task_ext_qs);
+
 void tick_nohz_exit_kernel(void)
 {
 	unsigned long flags;
@@ -928,6 +933,9 @@ void tick_nohz_exit_kernel(void)
 	ts->saved_jiffies = jiffies;
 	ts->saved_jiffies_whence = JIFFIES_SAVED_USER;
 
+	__get_cpu_var(nohz_task_ext_qs) = 1;
+	rcu_user_enter();
+
 	local_irq_restore(flags);
 }
 
@@ -947,6 +955,11 @@ void tick_nohz_enter_kernel(void)
 	WARN_ON_ONCE(!ts->tick_stopped);
 	WARN_ON_ONCE(ts->saved_jiffies_whence != JIFFIES_SAVED_USER);
 
+	if (__get_cpu_var(nohz_task_ext_qs) == 1) {
+		__get_cpu_var(nohz_task_ext_qs) = 0;
+		rcu_user_exit();
+	}
+
 	delta_jiffies = jiffies - ts->saved_jiffies;
 	account_user_ticks(current, delta_jiffies);
 
@@ -956,6 +969,14 @@ void tick_nohz_enter_kernel(void)
 	local_irq_restore(flags);
 }
 
+void tick_nohz_cpu_exit_qs(void)
+{
+	if (__get_cpu_var(nohz_task_ext_qs)) {
+		rcu_user_exit_irq();
+		__get_cpu_var(nohz_task_ext_qs) = 0;
+	}
+}
+
 void tick_nohz_enter_exception(struct pt_regs *regs)
 {
 	if (user_mode(regs))
@@ -991,6 +1012,7 @@ static void tick_nohz_restart_adaptive(void)
 	tick_nohz_flush_current_times(true);
 	tick_nohz_restart_sched_tick();
 	clear_thread_flag(TIF_NOHZ);
+	tick_nohz_cpu_exit_qs();
 }
 
 void tick_nohz_check_adaptive(void)
@@ -1030,6 +1052,7 @@ void tick_nohz_pre_schedule(void)
 	if (test_thread_flag(TIF_NOHZ)) {
 		tick_nohz_flush_current_times(true);
 		clear_thread_flag(TIF_NOHZ);
+		/* FIXME: warn if we are in RCU idle mode */
 	}
 }
 
-- 
1.7.10.4


