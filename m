Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab0LTP1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:27:08 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:54867 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab0LTPYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:24:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DDI6j1EAPvB4pYxRi6y8Ps7ZgNYx1LpxM81GCz9ebyLn8yNin3fUGr6Z1YJYoSVmyS
         8BXBkuhO+zqAOsr8dXKie8oX0h0CrabGt1uAFjNPuvkYjQe35SVqhzmLtDq8oOa7Aror
         fW+WD4AQbIy99vdwYu4ISQYFuhqN9k1mJICnA=
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
Subject: [RFC PATCH 01/15] nohz_task: New mask for cpus having nohz task
Date: Mon, 20 Dec 2010 16:24:08 +0100
Message-Id: <1292858662-5650-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A nohz task is a non-idle task that tries to shutdown the tick while
the task is running under some conditions.

This brings a new cpu_has_nohz_task_mask cpu mask that keeps track
of the cpus that have a nohz task. This is a 1:1 mapping: a nohz
task is affine to a single cpu and can't be moved elsewhere, and
a cpu can have only one nohz task.

This tracking will be useful later for rcu or when we need to
find an idle cpu target for a timer.

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
 arch/Kconfig            |    3 +++
 include/linux/cpumask.h |    8 ++++++++
 kernel/cpu.c            |   15 +++++++++++++++
 kernel/time/Kconfig     |    7 +++++++
 4 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 8bf0fa65..e631791 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -175,4 +175,7 @@ config HAVE_PERF_EVENTS_NMI
 config HAVE_ARCH_JUMP_LABEL
 	bool
 
+config HAVE_NO_HZ_TASK
+	bool
+
 source "kernel/gcov/Kconfig"
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bae6fe2..6c4801c 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -100,6 +100,13 @@ extern const struct cpumask *const cpu_active_mask;
 #define cpu_active(cpu)		((cpu) == 0)
 #endif
 
+#ifdef CONFIG_NO_HZ_TASK
+extern const struct cpumask *const cpu_has_nohz_task_mask;
+#define cpu_has_nohz_task(cpu)	cpumask_test_cpu((cpu), cpu_has_nohz_task_mask)
+#else
+#define cpu_has_nohz_task(cpu)	0
+#endif
+
 /* verify cpu argument to cpumask_* operators */
 static inline unsigned int cpumask_check(unsigned int cpu)
 {
@@ -671,6 +678,7 @@ void set_cpu_possible(unsigned int cpu, bool possible);
 void set_cpu_present(unsigned int cpu, bool present);
 void set_cpu_online(unsigned int cpu, bool online);
 void set_cpu_active(unsigned int cpu, bool active);
+void set_cpu_has_nohz_task(unsigned int cpu, bool has_nohz_task);
 void init_cpu_present(const struct cpumask *src);
 void init_cpu_possible(const struct cpumask *src);
 void init_cpu_online(const struct cpumask *src);
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f6e726f..bc9a93e 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -540,6 +540,11 @@ static DECLARE_BITMAP(cpu_active_bits, CONFIG_NR_CPUS) __read_mostly;
 const struct cpumask *const cpu_active_mask = to_cpumask(cpu_active_bits);
 EXPORT_SYMBOL(cpu_active_mask);
 
+#ifdef CONFIG_NO_HZ_TASK
+static DECLARE_BITMAP(cpu_has_nohz_task_bits, CONFIG_NR_CPUS) __read_mostly;
+const struct cpumask *const cpu_has_nohz_task_mask = to_cpumask(cpu_has_nohz_task_bits);
+#endif
+
 void set_cpu_possible(unsigned int cpu, bool possible)
 {
 	if (possible)
@@ -572,6 +577,16 @@ void set_cpu_active(unsigned int cpu, bool active)
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_active_bits));
 }
 
+#ifdef CONFIG_NO_HZ_TASK
+void set_cpu_has_nohz_task(unsigned int cpu, bool has_nohz_task)
+{
+	if (has_nohz_task)
+		cpumask_set_cpu(cpu, to_cpumask(cpu_has_nohz_task_bits));
+	else
+		cpumask_clear_cpu(cpu, to_cpumask(cpu_has_nohz_task_bits));
+}
+#endif
+
 void init_cpu_present(const struct cpumask *src)
 {
 	cpumask_copy(to_cpumask(cpu_present_bits), src);
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index f06a8a3..a460cee 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -27,3 +27,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS || GENERIC_CLOCKEVENTS_MIGR
 
+config NO_HZ_TASK
+       bool "Tickless task"
+       depends on HAVE_NO_HZ_TASK && NO_HZ && SMP && HIGH_RES_TIMERS
+       help
+         When a task runs alone on a CPU and switches into this mode,
+         the timer interrupt will only trigger when it is strictly
+         needed.
-- 
1.7.3.2

