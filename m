Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2ECRoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:44:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50770 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757670Ab2ECRoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:44:04 -0400
Date: Thu, 3 May 2012 10:43:28 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-3bb5d2ee396aabaa4e318f17e94d13e2ee0e5a88@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tj@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tj@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        rientjes@google.com
In-Reply-To: <1334966930.28674.245.camel@sbsiddha-desk.sc.intel.com>
References: <1334966930.28674.245.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smp, idle:
  Allocate idle thread for each possible cpu during boot
Git-Commit-ID: 3bb5d2ee396aabaa4e318f17e94d13e2ee0e5a88
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 03 May 2012 10:43:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bb5d2ee396aabaa4e318f17e94d13e2ee0e5a88
Gitweb:     http://git.kernel.org/tip/3bb5d2ee396aabaa4e318f17e94d13e2ee0e5a88
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 20 Apr 2012 17:08:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 3 May 2012 19:32:34 +0200

smp, idle: Allocate idle thread for each possible cpu during boot

percpu areas are already allocated during boot for each possible cpu.
percpu idle threads can be considered as an extension of the percpu areas,
and allocate them for each possible cpu during boot.

This will eliminate the need for workqueue based idle thread allocation.
In future we can move the idle thread area into the percpu area too.

[ tglx: Moved the loop into smpboot.c and added an error check when
  the init code failed to allocate an idle thread for a cpu which
  should be onlined ]

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: venki@google.com
Link: http://lkml.kernel.org/r/1334966930.28674.245.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/cpu.c     |    9 ++++--
 kernel/smp.c     |    4 +++
 kernel/smpboot.c |   72 ++++++++++++++---------------------------------------
 kernel/smpboot.h |    2 +
 4 files changed, 31 insertions(+), 56 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 05c46ba..0e6353c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -297,15 +297,18 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	int ret, nr_calls = 0;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
+	struct task_struct *idle;
 
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
 	cpu_hotplug_begin();
 
-	ret = smpboot_prepare(cpu);
-	if (ret)
+	idle = idle_thread_get(cpu);
+	if (IS_ERR(idle)) {
+		ret = PTR_ERR(idle);
 		goto out;
+	}
 
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
@@ -316,7 +319,7 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 	}
 
 	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu, idle_thread_get(cpu));
+	ret = __cpu_up(cpu, idle);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
diff --git a/kernel/smp.c b/kernel/smp.c
index 2f8b10e..a61294c 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -13,6 +13,8 @@
 #include <linux/smp.h>
 #include <linux/cpu.h>
 
+#include "smpboot.h"
+
 #ifdef CONFIG_USE_GENERIC_SMP_HELPERS
 static struct {
 	struct list_head	queue;
@@ -669,6 +671,8 @@ void __init smp_init(void)
 {
 	unsigned int cpu;
 
+	idle_threads_init();
+
 	/* FIXME: This should be done in userspace --RR */
 	for_each_present_cpu(cpu) {
 		if (num_online_cpus() >= setup_max_cpus)
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index ed15769..e1a797e 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -6,64 +6,42 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/percpu.h>
-#include <linux/workqueue.h>
 
 #include "smpboot.h"
 
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
-struct create_idle {
-	struct work_struct	work;
-	struct task_struct	*idle;
-	struct completion	done;
-	unsigned int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c = container_of(work, struct create_idle, work);
-
-	c->idle = fork_idle(c->cpu);
-	complete(&c->done);
-}
-
-static struct task_struct * __cpuinit idle_thread_create(unsigned int cpu)
-{
-	struct create_idle c_idle = {
-		.cpu	= cpu,
-		.done	= COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-	};
-
-	INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-	schedule_work(&c_idle.work);
-	wait_for_completion(&c_idle.done);
-	destroy_work_on_stack(&c_idle.work);
-	return c_idle.idle;
-}
-
 /*
  * For the hotplug case we keep the task structs around and reuse
  * them.
  */
 static DEFINE_PER_CPU(struct task_struct *, idle_threads);
 
-static inline struct task_struct *get_idle_for_cpu(unsigned int cpu)
+struct task_struct * __cpuinit idle_thread_get(unsigned int cpu)
 {
 	struct task_struct *tsk = per_cpu(idle_threads, cpu);
 
 	if (!tsk)
-		return idle_thread_create(cpu);
+		return ERR_PTR(-ENOMEM);
 	init_idle(tsk, cpu);
 	return tsk;
 }
 
-struct task_struct * __cpuinit idle_thread_get(unsigned int cpu)
+void __init idle_thread_set_boot_cpu(void)
 {
-	return per_cpu(idle_threads, cpu);
+	per_cpu(idle_threads, smp_processor_id()) = current;
 }
 
-void __init idle_thread_set_boot_cpu(void)
+static inline void idle_init(unsigned int cpu)
 {
-	per_cpu(idle_threads, smp_processor_id()) = current;
+	struct task_struct *tsk = per_cpu(idle_threads, cpu);
+
+	if (!tsk) {
+		tsk = fork_idle(cpu);
+		if (IS_ERR(tsk))
+			pr_err("SMP: fork_idle() failed for CPU %u\n", cpu);
+		else
+			per_cpu(idle_threads, cpu) = tsk;
+	}
 }
 
 /**
@@ -72,25 +50,13 @@ void __init idle_thread_set_boot_cpu(void)
  *
  * Creates the thread if it does not exist.
  */
-static int __cpuinit idle_thread_init(unsigned int cpu)
+void __init idle_threads_init(void)
 {
-	struct task_struct *idle = get_idle_for_cpu(cpu);
+	unsigned int cpu;
 
-	if (IS_ERR(idle)) {
-		printk(KERN_ERR "failed fork for CPU %u\n", cpu);
-		return PTR_ERR(idle);
+	for_each_possible_cpu(cpu) {
+		if (cpu != smp_processor_id())
+			idle_init(cpu);
 	}
-	per_cpu(idle_threads, cpu) = idle;
-	return 0;
 }
-#else
-static inline int idle_thread_init(unsigned int cpu) { return 0; }
 #endif
-
-/**
- * smpboot_prepare - generic smpboot preparation
- */
-int __cpuinit smpboot_prepare(unsigned int cpu)
-{
-	return idle_thread_init(cpu);
-}
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index 7943bbb..4cfbcb8 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
@@ -8,9 +8,11 @@ int smpboot_prepare(unsigned int cpu);
 #ifdef CONFIG_GENERIC_SMP_IDLE_THREAD
 struct task_struct *idle_thread_get(unsigned int cpu);
 void idle_thread_set_boot_cpu(void);
+void idle_threads_init(void);
 #else
 static inline struct task_struct *idle_thread_get(unsigned int cpu) { return NULL; }
 static inline void idle_thread_set_boot_cpu(void) { }
+static inline void idle_threads_init(unsigned int cpu) { }
 #endif
 
 #endif
