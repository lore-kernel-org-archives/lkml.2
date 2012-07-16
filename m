Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab2GPKn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:43:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:52619 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2GPKmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:42:45 -0400
Message-Id: <20120716103948.352501068@linutronix.de>
User-Agent: quilt/0.48-1
Date: Mon, 16 Jul 2012 10:42:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [Patch 3/7] smpboot: Provide infrastructure for percpu hotplug threads
References: <20120716103749.122800930@linutronix.de>
Content-Disposition: inline;
 filename=smpboot-percpu-thread-infrastructure.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/smpboot.h |   43 +++++++++
 kernel/cpu.c            |   10 +-
 kernel/smpboot.c        |  229 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/smpboot.h        |    4 
 4 files changed, 285 insertions(+), 1 deletion(-)

Index: tip/include/linux/smpboot.h
===================================================================
--- /dev/null
+++ tip/include/linux/smpboot.h
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
Index: tip/kernel/cpu.c
===================================================================
--- tip.orig/kernel/cpu.c
+++ tip/kernel/cpu.c
@@ -280,12 +280,13 @@ static int __ref _cpu_down(unsigned int 
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
@@ -354,6 +355,10 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out;
 	}
 
+	ret = smpboot_create_threads(cpu);
+	if (ret)
+		goto out;
+
 	ret = __cpu_notify(CPU_UP_PREPARE | mod, hcpu, -1, &nr_calls);
 	if (ret) {
 		nr_calls--;
@@ -368,6 +373,9 @@ static int __cpuinit _cpu_up(unsigned in
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));
 
+	/* Wake the per cpu threads */
+	smpboot_unpark_threads(cpu);
+
 	/* Now call notifier in preparation. */
 	cpu_notify(CPU_ONLINE | mod, hcpu);
 
Index: tip/kernel/smpboot.c
===================================================================
--- tip.orig/kernel/smpboot.c
+++ tip/kernel/smpboot.c
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
+ * @void:	thread data pointer
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
+			schedule_preempt_disabled();
+		} else {
+			set_current_state(TASK_RUNNING);
+			preempt_enable();
+			ht->thread_fn(td->cpu);
+			preempt_disable();
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
Index: tip/kernel/smpboot.h
===================================================================
--- tip.orig/kernel/smpboot.h
+++ tip/kernel/smpboot.h
@@ -13,4 +13,8 @@ static inline void idle_thread_set_boot_
 static inline void idle_threads_init(void) { }
 #endif
 
+int smpboot_create_threads(unsigned int cpu);
+void smpboot_park_threads(unsigned int cpu);
+void smpboot_unpark_threads(unsigned int cpu);
+
 #endif


