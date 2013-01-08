Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3AHCJK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 21:09:10 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:47200 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3AHCJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 21:09:00 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/33] nohz: Basic full dynticks interface
Date: Tue,  8 Jan 2013 03:08:07 +0100
Message-Id: <1357610913-1080-8-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start with a very simple interface to define full dynticks CPU:
use a boot time option defined cpumask through the "full_nohz="
kernel parameter.

Make sure you keep at least one CPU outside this range to handle
the timekeeping.

Also full_nohz= must match rcu_nocb= value.

Suggested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/tick.h     |    7 +++++++
 kernel/time/Kconfig      |    9 +++++++++
 kernel/time/tick-sched.c |   23 +++++++++++++++++++++++
 3 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index 553272e..2d4f6f0 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -157,6 +157,13 @@ static inline u64 get_cpu_idle_time_us(int cpu, u64 *unused) { return -1; }
 static inline u64 get_cpu_iowait_time_us(int cpu, u64 *unused) { return -1; }
 # endif /* !NO_HZ */
 
+#ifdef CONFIG_NO_HZ_FULL
+int tick_nohz_full_cpu(int cpu);
+#else
+static inline int tick_nohz_full_cpu(int cpu) { return 0; }
+#endif
+
+
 # ifdef CONFIG_CPU_IDLE_GOV_MENU
 extern void menu_hrtimer_cancel(void);
 # else
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8601f0d..dc6381d 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -70,6 +70,15 @@ config NO_HZ
 	  only trigger on an as-needed basis both when the system is
 	  busy and when the system is idle.
 
+config NO_HZ_FULL
+       bool "Full tickless system"
+       depends on NO_HZ && RCU_USER_QS && VIRT_CPU_ACCOUNTING_GEN && RCU_NOCB_CPU && SMP
+       select CONTEXT_TRACKING_FORCE
+       help
+         Try to be tickless everywhere, not just in idle. (You need
+	 to fill up the full_nohz_mask boot parameter).
+
+
 config HIGH_RES_TIMERS
 	bool "High Resolution Timer Support"
 	depends on !ARCH_USES_GETTIMEOFFSET && GENERIC_CLOCKEVENTS
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 314b9ee..494a2aa 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -142,6 +142,29 @@ static void tick_sched_handle(struct tick_sched *ts, struct pt_regs *regs)
 	profile_tick(CPU_PROFILING);
 }
 
+#ifdef CONFIG_NO_HZ_FULL
+static cpumask_var_t full_nohz_mask;
+bool have_full_nohz_mask;
+
+int tick_nohz_full_cpu(int cpu)
+{
+	if (!have_full_nohz_mask)
+		return 0;
+
+	return cpumask_test_cpu(cpu, full_nohz_mask);
+}
+
+/* Parse the boot-time nohz CPU list from the kernel parameters. */
+static int __init tick_nohz_full_setup(char *str)
+{
+	alloc_bootmem_cpumask_var(&full_nohz_mask);
+	have_full_nohz_mask = true;
+	cpulist_parse(str, full_nohz_mask);
+	return 1;
+}
+__setup("full_nohz=", tick_nohz_full_setup);
+#endif
+
 /*
  * NOHZ - aka dynamic tick functionality
  */
-- 
1.7.5.4

