Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2HMPKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:10:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60866 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab2HMPKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:10:52 -0400
Date: Mon, 13 Aug 2012 08:10:21 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-f97f8f06a49febbc3cb3635172efbe64ddc79700@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, namhyung@kernel.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120716103948.352501068@linutronix.de>
References: <20120716103948.352501068@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] smpboot:
  Provide infrastructure for percpu hotplug threads
Git-Commit-ID: f97f8f06a49febbc3cb3635172efbe64ddc79700
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 08:10:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f97f8f06a49febbc3cb3635172efbe64ddc79700
Gitweb:     http://git.kernel.org/tip/f97f8f06a49febbc3cb3635172efbe64ddc79700
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 16 Jul 2012 10:42:36 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 17:01:07 +0200

smpboot: Provide infrastructure for percpu hotplug threads

Provide a generic interface for setting up and tearing down percpu
threads.

On registration the threads for already online cpus are created and
started. On deregistration (modules) the threads are stoppped.

During hotplug operations the threads are created, started, parked and
unparked. The datastructure for registration provides a pointer to
percpu storage space and optional setup, cleanup, park, unpark
functions. These functions are called when the thread state changes.

Each implementation has to provide a function which is queried and
returns whether the thread should run and the thread function itself.

The core code handles all state transitions and avoids duplicated code
in the call sites.

[ paulmck: Preemption leak fix ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20120716103948.352501068@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smpboot.h |   43 +++++++++
 kernel/cpu.c            |   10 ++-
 kernel/smpboot.c        |  229 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h        |    4 +
 4 files changed, 285 insertions(+), 1 deletions(-)

diff --git a/include/linux/smpboot.h b/include/linux/smpboot.h
new file mode 100644
index 0000000..e0106d8
--- /dev/null
+++ b/include/linux/smpboot.h
@@ -0,0 +1,43 @@
+#ifndef _LINUX_SMPBOOT_H
+#define _LINUX_SMPBOOT_H
+
+#include <linux/types.h>
+
+struct task_struct;
+/* Cookie handed to the thread_fn*/
+struct smpboot_thread_data;
+
+/**
+ * struct smp_hotplug_thread - CPU hotplug related thread descriptor
+ * @store:		Pointer to per cpu storage for the task pointers
+ * @list:		List head for core management
+ * @thread_should_run:	Check whether the thread should run or not. Called with
+ *			preemption disabled.
+ * @thread_fn:		The associated thread function
+ * @setup:		Optional setup function, called when the thread gets
+ *			operational the first time
+ * @cleanup:		Optional cleanup function, called when the thread
+ *			should stop (module exit)
+ * @park:		Optional park function, called when the thread is
+ *			parked (cpu offline)
+ * @unpark:		Optional unpark function, called when the thread is
+ *			unparked (cpu online)
+ * @thread_comm:	The base name of the thread
+ */
+struct smp_hotplug_thread {
+	struct task_struct __percpu	**store;
+	struct list_head		list;
+	int				(*thread_should_run)(unsigned int cpu);
+	void				(*thread_fn)(unsigned int cpu);
+	void				(*setup)(unsigned int cpu);
+	void				(*cleanup)(unsigned int cpu, bool online);
+	void				(*park)(unsigned int cpu);
+	void				(*unpark)(unsigned int cpu);
+	const char			*thread_comm;
+};
+
+int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread);
+void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread);
+int smpboot_thread_schedule(void);
+
+#endif
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 14d3258..e615dfb 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -280,12 +280,13 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
+	smpboot_park_threads(cpu);
 
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
+		smpboot_unpark_threads(cpu);
 		cpu_notify_nofail(CPU_DOWN_FAILED | mod, hcpu);
-
 		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
@@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out;
 	}
 
+	ret = smpboot_create_threads(cpu);
+	if (ret)
+		goto out;
+
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -368,6 +373,9 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
+	/* Wake the per cpu threads */
+	smpboot_unpark_threads(cpu);
+
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);
 
diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 98f60c5..9d5f7b0 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -1,11 +1,17 @@
 /*
  * Common SMP CPU bringup/teardown functions
  */
+#include <linux/cpu.h>
 #include <linux/err.h>
 #include <linux/smp.h>
 #include <linux/init.h>
+#include <linux/list.h>
+#include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/export.h>
 #include <linux/percpu.h>
+#include <linux/kthread.h>
+#include <linux/smpboot.h>
 
 #include "smpboot.h"
 
@@ -65,3 +71,226 @@ void __init idle_threads_init(void)
 	}
 }
 #endif
+
+static LIST_HEAD(hotplug_threads);
+static DEFINE_MUTEX(smpboot_threads_lock);
+
+struct smpboot_thread_data {
+	unsigned int			cpu;
+	unsigned int			status;
+	struct smp_hotplug_thread	*ht;
+};
+
+enum {
+	HP_THREAD_NONE = 0,
+	HP_THREAD_ACTIVE,
+	HP_THREAD_PARKED,
+};
+
+/**
+ * smpboot_thread_fn - percpu hotplug thread loop function
+ * @data:	thread data pointer
+ *
+ * Checks for thread stop and park conditions. Calls the necessary
+ * setup, cleanup, park and unpark functions for the registered
+ * thread.
+ *
+ * Returns 1 when the thread should exit, 0 otherwise.
+ */
+static int smpboot_thread_fn(void *data)
+{
+	struct smpboot_thread_data *td = data;
+	struct smp_hotplug_thread *ht = td->ht;
+
+	while (1) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		preempt_disable();
+		if (kthread_should_stop()) {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			if (ht->cleanup)
+				ht->cleanup(td->cpu, cpu_online(td->cpu));
+			kfree(td);
+			return 0;
+		}
+
+		if (kthread_should_park()) {
+			__set_current_state(TASK_RUNNING);
+			preempt_enable();
+			if (ht->park && td->status == HP_THREAD_ACTIVE) {
+				BUG_ON(td->cpu != smp_processor_id());
+				ht->park(td->cpu);
+				td->status = HP_THREAD_PARKED;
+			}
+			kthread_parkme();
+			/* We might have been woken for stop */
+			continue;
+		}
+
+		BUG_ON(td->cpu != smp_processor_id());
+
+		/* Check for state change setup */
+		switch (td->status) {
+		case HP_THREAD_NONE:
+			preempt_enable();
+			if (ht->setup)
+				ht->setup(td->cpu);
+			td->status = HP_THREAD_ACTIVE;
+			preempt_disable();
+			break;
+		case HP_THREAD_PARKED:
+			preempt_enable();
+			if (ht->unpark)
+				ht->unpark(td->cpu);
+			td->status = HP_THREAD_ACTIVE;
+			preempt_disable();
+			break;
+		}
+
+		if (!ht->thread_should_run(td->cpu)) {
+			preempt_enable();
+			schedule();
+		} else {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			ht->thread_fn(td->cpu);
+		}
+	}
+}
+
+static int
+__smpboot_create_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+	struct smpboot_thread_data *td;
+
+	if (tsk)
+		return 0;
+
+	td = kzalloc_node(sizeof(*td), GFP_KERNEL, cpu_to_node(cpu));
+	if (!td)
+		return -ENOMEM;
+	td->cpu = cpu;
+	td->ht = ht;
+
+	tsk = kthread_create_on_cpu(smpboot_thread_fn, td, cpu,
+				    ht->thread_comm);
+	if (IS_ERR(tsk)) {
+		kfree(td);
+		return PTR_ERR(tsk);
+	}
+
+	get_task_struct(tsk);
+	*per_cpu_ptr(ht->store, cpu) = tsk;
+	return 0;
+}
+
+int smpboot_create_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+	int ret = 0;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry(cur, &hotplug_threads, list) {
+		ret = __smpboot_create_thread(cur, cpu);
+		if (ret)
+			break;
+	}
+	mutex_unlock(&smpboot_threads_lock);
+	return ret;
+}
+
+static void smpboot_unpark_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+	kthread_unpark(tsk);
+}
+
+void smpboot_unpark_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry(cur, &hotplug_threads, list)
+		smpboot_unpark_thread(cur, cpu);
+	mutex_unlock(&smpboot_threads_lock);
+}
+
+static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
+{
+	struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+	if (tsk)
+		kthread_park(tsk);
+}
+
+void smpboot_park_threads(unsigned int cpu)
+{
+	struct smp_hotplug_thread *cur;
+
+	mutex_lock(&smpboot_threads_lock);
+	list_for_each_entry_reverse(cur, &hotplug_threads, list)
+		smpboot_park_thread(cur, cpu);
+	mutex_unlock(&smpboot_threads_lock);
+}
+
+static void smpboot_destroy_threads(struct smp_hotplug_thread *ht)
+{
+	unsigned int cpu;
+
+	/* We need to destroy also the parked threads of offline cpus */
+	for_each_possible_cpu(cpu) {
+		struct task_struct *tsk = *per_cpu_ptr(ht->store, cpu);
+
+		if (tsk) {
+			kthread_stop(tsk);
+			put_task_struct(tsk);
+			*per_cpu_ptr(ht->store, cpu) = NULL;
+		}
+	}
+}
+
+/**
+ * smpboot_register_percpu_thread - Register a per_cpu thread related to hotplug
+ * @plug_thread:	Hotplug thread descriptor
+ *
+ * Creates and starts the threads on all online cpus.
+ */
+int smpboot_register_percpu_thread(struct smp_hotplug_thread *plug_thread)
+{
+	unsigned int cpu;
+	int ret = 0;
+
+	mutex_lock(&smpboot_threads_lock);
+	for_each_online_cpu(cpu) {
+		ret = __smpboot_create_thread(plug_thread, cpu);
+		if (ret) {
+			smpboot_destroy_threads(plug_thread);
+			goto out;
+		}
+		smpboot_unpark_thread(plug_thread, cpu);
+	}
+	list_add(&plug_thread->list, &hotplug_threads);
+out:
+	mutex_unlock(&smpboot_threads_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(smpboot_register_percpu_thread);
+
+/**
+ * smpboot_unregister_percpu_thread - Unregister a per_cpu thread related to hotplug
+ * @plug_thread:	Hotplug thread descriptor
+ *
+ * Stops all threads on all possible cpus.
+ */
+void smpboot_unregister_percpu_thread(struct smp_hotplug_thread *plug_thread)
+{
+	get_online_cpus();
+	mutex_lock(&smpboot_threads_lock);
+	list_del(&plug_thread->list);
+	smpboot_destroy_threads(plug_thread);
+	mutex_unlock(&smpboot_threads_lock);
+	put_online_cpus();
+}
+EXPORT_SYMBOL_GPL(smpboot_unregister_percpu_thread);
diff --git a/kernel/smpboot.h b/kernel/smpboot.h
index 6ef9433..72415a0 100644
--- a/kernel/smpboot.h
+++ b/kernel/smpboot.h
@@ -13,4 +13,8 @@ static inline void idle_thread_set_boot_cpu(void) { }
 static inline void idle_threads_init(void) { }
 #endif
 
+int smpboot_create_threads(unsigned int cpu);
+void smpboot_park_threads(unsigned int cpu);
+void smpboot_unpark_threads(unsigned int cpu);
+
 #endif
