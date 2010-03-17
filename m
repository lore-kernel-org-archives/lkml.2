Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab0CQImc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:42:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59042 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab0CQIm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:42:26 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       dipankar@in.ibm.com, josh@freedesktop.org, paulmck@linux.vnet.ibm.com,
       oleg@redhat.com, akpm@linux-foundation.org, peterz@infradead.org,
       arjan@infradead.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] cpuhog: implement cpuhog
Date: Wed, 17 Mar 2010 17:40:48 +0900
Message-Id: <1268815251-31407-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1268815251-31407-1-git-send-email-tj@kernel.org>
References: <1268815251-31407-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 17 Mar 2010 08:41:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a simplistic per-cpu maximum priority cpu hogging mechanism
named cpuhog.  A non-sleeping callback can be scheduled to run on one
or multiple cpus with maximum priority monopolozing those cpus.  This
is primarily to replace and unify RT workqueue usage in stop_machine
and scheduler migration_thread which currently is serving multiple
purposes.

Four functions are provided - hog_one_cpu(), hog_one_cpu_nowait(),
hog_cpus() and try_hog_cpus().

This is to allow clean sharing of resources among stop_cpu and all the
migration thread users.  One cpuhog thread per cpu is created which is
currently named "hog/CPU".  This will eventually replace the migration
thread and take on its name.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 include/linux/cpuhog.h |   24 +++
 kernel/Makefile        |    2 +-
 kernel/cpuhog.c        |  368 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 393 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/cpuhog.h
 create mode 100644 kernel/cpuhog.c

diff --git a/include/linux/cpuhog.h b/include/linux/cpuhog.h
new file mode 100644
index 0000000..5252884
--- /dev/null
+++ b/include/linux/cpuhog.h
@@ -0,0 +1,24 @@
+/*
+ * linux/cpuhog.h - CPU hogs to monopolize CPUs
+ *
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ *
+ * This file is released under the GPLv2.
+ */
+#include <linux/cpumask.h>
+#include <linux/list.h>
+
+typedef int (*cpuhog_fn_t)(void *arg);
+
+struct cpuhog_work {
+	struct list_head	list;		/* cpuhog->works */
+	cpuhog_fn_t		fn;
+	void			*arg;
+	struct cpuhog_done	*done;
+};
+
+int hog_one_cpu(unsigned int cpu, cpuhog_fn_t fn, void *arg);
+void hog_one_cpu_nowait(unsigned int cpu, cpuhog_fn_t fn, void *arg,
+			struct cpuhog_work *work_buf);
+int hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg);
+int try_hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg);
diff --git a/kernel/Makefile b/kernel/Makefile
index 6aebdeb..0fa06cb 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o
+	    async.o cpuhog.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/cpuhog.c b/kernel/cpuhog.c
new file mode 100644
index 0000000..877a5ed
--- /dev/null
+++ b/kernel/cpuhog.c
@@ -0,0 +1,368 @@
+/*
+ * kernel/cpuhog.c - CPU hogs to monopolize CPUs
+ *
+ * Copyright (C) 2010		SUSE Linux Products GmbH
+ * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
+ *
+ * This file is released under the GPLv2.
+ *
+ * Simplistic per-cpu maximum priority cpu hogging mechanism.  The
+ * caller can specify a non-sleeping function to be executed on a
+ * single or multiple cpus preempting all other processes and
+ * monopolizing those cpus until it finishes.
+ *
+ * Resources for this mechanism are preallocated when a cpu is brought
+ * up and requests are guaranteed to be served as long as the target
+ * cpus are online.
+ */
+#include <linux/completion.h>
+#include <linux/cpu.h>
+#include <linux/cpuhog.h>
+#include <linux/init.h>
+#include <linux/kthread.h>
+#include <linux/percpu.h>
+
+/*
+ * Structure to determine completion condition and record errors.  May
+ * be shared by works on different cpus.
+ */
+struct cpuhog_done {
+	atomic_t		nr_todo;	/* nr left to execute */
+	bool			executed;	/* actually executed? */
+	int			ret;		/* collected return value */
+	struct completion	completion;	/* fired if nr_todo reaches 0 */
+};
+
+/* the actual hog, one per every possible cpu, enabled on online cpus */
+struct cpuhog {
+	spinlock_t		lock;
+	struct list_head	works;		/* list of pending works */
+	struct task_struct	*thread;	/* hog thread */
+	bool			enabled;	/* is this hog enabled? */
+};
+
+static DEFINE_PER_CPU(struct cpuhog, cpuhog);
+
+static void cpuhog_init_done(struct cpuhog_done *done, unsigned int nr_todo)
+{
+	memset(done, 0, sizeof(*done));
+	atomic_set(&done->nr_todo, nr_todo);
+	init_completion(&done->completion);
+}
+
+/* signal completion unless @done is NULL */
+static void cpuhog_signal_done(struct cpuhog_done *done, bool executed)
+{
+	if (done) {
+		if (executed)
+			done->executed = true;
+		if (atomic_dec_and_test(&done->nr_todo))
+			complete(&done->completion);
+	}
+}
+
+/* queue @work to @hog.  if offline, @work is completed immediately */
+static void cpuhog_queue_work(struct cpuhog *hog, struct cpuhog_work *work)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hog->lock, flags);
+
+	if (hog->enabled) {
+		list_add_tail(&work->list, &hog->works);
+		wake_up_process(hog->thread);
+	} else
+		cpuhog_signal_done(work->done, false);
+
+	spin_unlock_irqrestore(&hog->lock, flags);
+}
+
+/**
+ * hog_one_cpu - hog a cpu
+ * @cpu: cpu to hog
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Execute @fn(@arg) on @cpu.  @fn is run in a process context with
+ * the highest priority preempting any task on the cpu and
+ * monopolizing it.  This function returns after the execution is
+ * complete.
+ *
+ * This function doesn't guarantee @cpu stays online till @fn
+ * completes.  If @cpu goes down in the middle, execution may happen
+ * partially or fully on different cpus.  @fn should either be ready
+ * for that or the caller should ensure that @cpu stays online until
+ * this function completes.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -ENOENT if @fn(@arg) was not executed because @cpu was offline;
+ * otherwise, the return value of @fn.
+ */
+int hog_one_cpu(unsigned int cpu, cpuhog_fn_t fn, void *arg)
+{
+	struct cpuhog_done done;
+	struct cpuhog_work work = { .fn = fn, .arg = arg, .done = &done };
+
+	cpuhog_init_done(&done, 1);
+	cpuhog_queue_work(&per_cpu(cpuhog, cpu), &work);
+	wait_for_completion(&done.completion);
+	return done.executed ? done.ret : -ENOENT;
+}
+
+/**
+ * hog_one_cpu_nowait - hog a cpu but don't wait for completion
+ * @cpu: cpu to hog
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Similar to hog_one_cpu() but doesn't wait for completion.  The
+ * caller is responsible for ensuring @work_buf is currently unused
+ * and will remain untouched until cpuhog starts executing @fn.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+void hog_one_cpu_nowait(unsigned int cpu, cpuhog_fn_t fn, void *arg,
+			struct cpuhog_work *work_buf)
+{
+	memset(work_buf, 0, sizeof(*work_buf));
+	work_buf->fn = fn;
+	work_buf->arg = arg;
+	cpuhog_queue_work(&per_cpu(cpuhog, cpu), work_buf);
+}
+
+/* static data for hog_cpus */
+static DEFINE_MUTEX(hog_cpus_mutex);
+static DEFINE_PER_CPU(struct cpuhog_work, hog_cpus_work);
+
+int __hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg)
+{
+	struct cpuhog_work *work;
+	struct cpuhog_done done;
+	unsigned int cpu;
+
+	/* initialize works and done */
+	for_each_cpu(cpu, cpumask) {
+		work = &per_cpu(hog_cpus_work, cpu);
+		work->fn = fn;
+		work->arg = arg;
+		work->done = &done;
+	}
+	cpuhog_init_done(&done, cpumask_weight(cpumask));
+
+	/*
+	 * Disable preemption while queueing to avoid getting
+	 * preempted by a hog which might wait for other hogs to enter
+	 * @fn which can lead to deadlock.
+	 */
+	preempt_disable();
+	for_each_cpu(cpu, cpumask)
+		cpuhog_queue_work(&per_cpu(cpuhog, cpu),
+				  &per_cpu(hog_cpus_work, cpu));
+	preempt_enable();
+
+	wait_for_completion(&done.completion);
+	return done.executed ? done.ret : -ENOENT;
+}
+
+/**
+ * hog_cpus - hog multiple cpus
+ * @cpumask: cpus to hog
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Execute @fn(@arg) on online cpus in @cpumask.  On each target cpu,
+ * @fn is run in a process context with the highest priority
+ * preempting any task on the cpu and monopolizing it.  This function
+ * returns after all executions are complete.
+ *
+ * This function doesn't guarantee the cpus in @cpumask stay online
+ * till @fn completes.  If some cpus go down in the middle, execution
+ * on the cpu may happen partially or fully on different cpus.  @fn
+ * should either be ready for that or the caller should ensure that
+ * the cpus stay online until this function completes.
+ *
+ * All hog_cpus() calls are serialized making it safe for @fn to wait
+ * for all cpus to start executing it.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -ENOENT if @fn(@arg) was not executed at all because all cpus in
+ * @cpumask were offline; otherwise, 0 if all executions of @fn
+ * returned 0, any non zero return value if any returned non zero.
+ */
+int hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg)
+{
+	int ret;
+
+	/* static works are used, process one request at a time */
+	mutex_lock(&hog_cpus_mutex);
+	ret = __hog_cpus(cpumask, fn, arg);
+	mutex_unlock(&hog_cpus_mutex);
+	return ret;
+}
+
+/**
+ * try_hog_cpus - try to hog multiple cpus
+ * @cpumask: cpus to hog
+ * @fn: function to execute
+ * @arg: argument to @fn
+ *
+ * Identical to hog_cpus() except that it fails with -EAGAIN if
+ * someone else is already using the facility.
+ *
+ * CONTEXT:
+ * Might sleep.
+ *
+ * RETURNS:
+ * -EAGAIN if someone else is already hogging cpus, -ENOENT if
+ * @fn(@arg) was not executed at all because all cpus in @cpumask were
+ * offline; otherwise, 0 if all executions of @fn returned 0, any non
+ * zero return value if any returned non zero.
+ */
+int try_hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg)
+{
+	int ret;
+
+	/* static works are used, process one request at a time */
+	if (!mutex_trylock(&hog_cpus_mutex))
+		return -EAGAIN;
+	ret = __hog_cpus(cpumask, fn, arg);
+	mutex_unlock(&hog_cpus_mutex);
+	return ret;
+}
+
+static int cpuhog_thread(void *data)
+{
+	struct cpuhog *hog = data;
+	struct cpuhog_work *work;
+	int ret;
+
+repeat:
+	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
+
+	if (kthread_should_stop()) {
+		__set_current_state(TASK_RUNNING);
+		return 0;
+	}
+
+	work = NULL;
+	spin_lock_irq(&hog->lock);
+	if (!list_empty(&hog->works)) {
+		work = list_first_entry(&hog->works, struct cpuhog_work, list);
+		list_del_init(&work->list);
+	}
+	spin_unlock_irq(&hog->lock);
+
+	if (work) {
+		struct cpuhog_done *done = work->done;
+
+		__set_current_state(TASK_RUNNING);
+
+		/* cpu hog callbacks are not allowed to sleep */
+		preempt_disable();
+
+		ret = work->fn(work->arg);
+		if (ret)
+			done->ret = ret;
+
+		/* restore preemption and check it's still balanced */
+		preempt_enable();
+		WARN_ON_ONCE(preempt_count());
+
+		cpuhog_signal_done(done, true);
+	} else
+		schedule();
+
+	goto repeat;
+}
+
+/* manage hog for a cpu, mostly lifted from sched migration thread mgmt */
+static int __cpuinit cpuhog_cpu_callback(struct notifier_block *nfb,
+					 unsigned long action, void *hcpu)
+{
+	struct sched_param param = { .sched_priority = MAX_RT_PRIO - 1 };
+	unsigned int cpu = (unsigned long)hcpu;
+	struct cpuhog *hog = &per_cpu(cpuhog, cpu);
+	struct cpuhog_work *work;
+	struct task_struct *p;
+
+	switch (action & ~CPU_TASKS_FROZEN) {
+	case CPU_UP_PREPARE:
+		BUG_ON(hog->thread || hog->enabled || !list_empty(&hog->works));
+		p = kthread_create(cpuhog_thread, hog, "hog/%d", cpu);
+		if (IS_ERR(p))
+			return NOTIFY_BAD;
+		sched_setscheduler_nocheck(p, SCHED_FIFO, &param);
+		get_task_struct(p);
+		hog->thread = p;
+		break;
+
+	case CPU_ONLINE:
+		kthread_bind(hog->thread, cpu);
+		/* strictly unnecessary, as first user will wake it */
+		wake_up_process(hog->thread);
+		/* mark enabled */
+		spin_lock_irq(&hog->lock);
+		hog->enabled = true;
+		spin_unlock_irq(&hog->lock);
+		break;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_DEAD:
+		/* kill the hog */
+		kthread_stop(hog->thread);
+		/* drain remaining works */
+		spin_lock_irq(&hog->lock);
+		list_for_each_entry(work, &hog->works, list)
+			cpuhog_signal_done(work->done, false);
+		hog->enabled = false;
+		spin_unlock_irq(&hog->lock);
+		/* release the hog */
+		put_task_struct(hog->thread);
+		hog->thread = NULL;
+		break;
+#endif
+	}
+
+	return NOTIFY_OK;
+}
+
+/*
+ * Give it a higher priority so that cpuhog is available to other cpu
+ * notifiers.  It currently shares the same priority as sched
+ * migration_notifier.
+ */
+static struct notifier_block __cpuinitdata cpuhog_cpu_notifier = {
+	.notifier_call	= cpuhog_cpu_callback,
+	.priority	= 10,
+};
+
+static int __init cpuhog_init(void)
+{
+	void *bcpu = (void *)(long)smp_processor_id();
+	unsigned int cpu;
+	int err;
+
+	for_each_possible_cpu(cpu) {
+		struct cpuhog *hog = &per_cpu(cpuhog, cpu);
+
+		spin_lock_init(&hog->lock);
+		INIT_LIST_HEAD(&hog->works);
+	}
+
+	/* start one for the boot cpu */
+	err = cpuhog_cpu_callback(&cpuhog_cpu_notifier, CPU_UP_PREPARE, bcpu);
+	BUG_ON(err == NOTIFY_BAD);
+	cpuhog_cpu_callback(&cpuhog_cpu_notifier, CPU_ONLINE, bcpu);
+	register_cpu_notifier(&cpuhog_cpu_notifier);
+
+	return 0;
+}
+early_initcall(cpuhog_init);
-- 
1.6.4.2

