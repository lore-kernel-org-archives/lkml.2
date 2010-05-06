Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab0EFQxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 12:53:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:51697 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab0EFQxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 12:53:49 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, peterz@infradead.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Dimitri Sivanich <sivanich@sgi.com>
Subject: [PATCH 2/5] stop_machine: reimplement using cpu_stop
Date: Thu,  6 May 2010 18:52:49 +0200
Message-Id: <1273164772-19149-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273164772-19149-1-git-send-email-tj@kernel.org>
References: <1273164772-19149-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 06 May 2010 16:52:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement stop_machine using cpu_stop.  As cpu stoppers are
guaranteed to be available for all online cpus,
stop_machine_create/destroy() are no longer necessary and removed.

With resource management and synchronization handled by cpu_stop, the
new implementation is much simpler.  Asking the cpu_stop to execute
the stop_cpu() state machine on all online cpus with cpu hotplug
disabled is enough.

stop_machine itself doesn't need to manage any global resources
anymore, so all per-instance information is rolled into struct
stop_machine_data and the mutex and all static data variables are
removed.

The previous implementation created and destroyed RT workqueues as
necessary which made stop_machine() calls highly expensive on very
large machines.  According to Dimitri Sivanich, preventing the dynamic
creation/destruction makes booting faster more than twice on very
large machines.  cpu_stop resources are preallocated for all online
cpus and should have the same effect.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Rusty Russell <rusty@rustcorp.com.au>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dimitri Sivanich <sivanich@sgi.com>
---
 arch/s390/kernel/time.c      |    1 -
 drivers/xen/manage.c         |   14 +---
 include/linux/stop_machine.h |   20 -----
 kernel/cpu.c                 |    8 --
 kernel/module.c              |   14 +---
 kernel/stop_machine.c        |  158 ++++++++++--------------------------------
 6 files changed, 42 insertions(+), 173 deletions(-)

diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index fba6dec..03d9656 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -390,7 +390,6 @@ static void __init time_init_wq(void)
 	if (time_sync_wq)
 		return;
 	time_sync_wq = create_singlethread_workqueue("timesync");
-	stop_machine_create();
 }
 
 /*
diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 2ac4440..8943b8c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -80,12 +80,6 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
-	err = stop_machine_create();
-	if (err) {
-		printk(KERN_ERR "xen suspend: failed to setup stop_machine %d\n", err);
-		goto out;
-	}
-
 #ifdef CONFIG_PREEMPT
 	/* If the kernel is preemptible, we need to freeze all the processes
 	   to prevent them from being in the middle of a pagetable update
@@ -93,7 +87,7 @@ static void do_suspend(void)
 	err = freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
-		goto out_destroy_sm;
+		goto out;
 	}
 #endif
 
@@ -136,12 +130,8 @@ out_resume:
 out_thaw:
 #ifdef CONFIG_PREEMPT
 	thaw_processes();
-
-out_destroy_sm:
-#endif
-	stop_machine_destroy();
-
 out:
+#endif
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_PM_SLEEP */
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index efcbd6c..0e552e7 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -67,23 +67,6 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
-/**
- * stop_machine_create: create all stop_machine threads
- *
- * Description: This causes all stop_machine threads to be created before
- * stop_machine actually gets called. This can be used by subsystems that
- * need a non failing stop_machine infrastructure.
- */
-int stop_machine_create(void);
-
-/**
- * stop_machine_destroy: destroy all stop_machine threads
- *
- * Description: This causes all stop_machine threads which were created with
- * stop_machine_create to be destroyed again.
- */
-void stop_machine_destroy(void);
-
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
@@ -96,8 +79,5 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return ret;
 }
 
-static inline int stop_machine_create(void) { return 0; }
-static inline void stop_machine_destroy(void) { }
-
 #endif /* CONFIG_SMP */
 #endif /* _LINUX_STOP_MACHINE */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 914aedc..5457775 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -266,9 +266,6 @@ int __ref cpu_down(unsigned int cpu)
 {
 	int err;
 
-	err = stop_machine_create();
-	if (err)
-		return err;
 	cpu_maps_update_begin();
 
 	if (cpu_hotplug_disabled) {
@@ -280,7 +277,6 @@ int __ref cpu_down(unsigned int cpu)
 
 out:
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return err;
 }
 EXPORT_SYMBOL(cpu_down);
@@ -361,9 +357,6 @@ int disable_nonboot_cpus(void)
 {
 	int cpu, first_cpu, error;
 
-	error = stop_machine_create();
-	if (error)
-		return error;
 	cpu_maps_update_begin();
 	first_cpu = cpumask_first(cpu_online_mask);
 	/*
@@ -394,7 +387,6 @@ int disable_nonboot_cpus(void)
 		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
 	}
 	cpu_maps_update_done();
-	stop_machine_destroy();
 	return error;
 }
 
diff --git a/kernel/module.c b/kernel/module.c
index 1016b75..0838246 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -723,16 +723,8 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 		return -EFAULT;
 	name[MODULE_NAME_LEN-1] = '\0';
 
-	/* Create stop_machine threads since free_module relies on
-	 * a non-failing stop_machine call. */
-	ret = stop_machine_create();
-	if (ret)
-		return ret;
-
-	if (mutex_lock_interruptible(&module_mutex) != 0) {
-		ret = -EINTR;
-		goto out_stop;
-	}
+	if (mutex_lock_interruptible(&module_mutex) != 0)
+		return -EINTR;
 
 	mod = find_module(name);
 	if (!mod) {
@@ -792,8 +784,6 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
  out:
 	mutex_unlock(&module_mutex);
-out_stop:
-	stop_machine_destroy();
 	return ret;
 }
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index 7e3f918..884c7a1 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -388,174 +388,92 @@ enum stopmachine_state {
 	/* Exit */
 	STOPMACHINE_EXIT,
 };
-static enum stopmachine_state state;
 
 struct stop_machine_data {
-	int (*fn)(void *);
-	void *data;
-	int fnret;
+	int			(*fn)(void *);
+	void			*data;
+	/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
+	unsigned int		num_threads;
+	const struct cpumask	*active_cpus;
+
+	enum stopmachine_state	state;
+	atomic_t		thread_ack;
 };
 
-/* Like num_online_cpus(), but hotplug cpu uses us, so we need this. */
-static unsigned int num_threads;
-static atomic_t thread_ack;
-static DEFINE_MUTEX(lock);
-/* setup_lock protects refcount, stop_machine_wq and stop_machine_work. */
-static DEFINE_MUTEX(setup_lock);
-/* Users of stop_machine. */
-static int refcount;
-static struct workqueue_struct *stop_machine_wq;
-static struct stop_machine_data active, idle;
-static const struct cpumask *active_cpus;
-static void __percpu *stop_machine_work;
-
-static void set_state(enum stopmachine_state newstate)
+static void set_state(struct stop_machine_data *smdata,
+		      enum stopmachine_state newstate)
 {
 	/* Reset ack counter. */
-	atomic_set(&thread_ack, num_threads);
+	atomic_set(&smdata->thread_ack, smdata->num_threads);
 	smp_wmb();
-	state = newstate;
+	smdata->state = newstate;
 }
 
 /* Last one to ack a state moves to the next state. */
-static void ack_state(void)
+static void ack_state(struct stop_machine_data *smdata)
 {
-	if (atomic_dec_and_test(&thread_ack))
-		set_state(state + 1);
+	if (atomic_dec_and_test(&smdata->thread_ack))
+		set_state(smdata, smdata->state + 1);
 }
 
-/* This is the actual function which stops the CPU. It runs
- * in the context of a dedicated stopmachine workqueue. */
-static void stop_cpu(struct work_struct *unused)
+/* This is the cpu_stop function which stops the CPU. */
+static int stop_machine_cpu_stop(void *data)
 {
+	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
-	struct stop_machine_data *smdata = &idle;
-	int cpu = smp_processor_id();
-	int err;
+	int cpu = smp_processor_id(), err = 0;
+	bool is_active;
+
+	if (!smdata->active_cpus)
+		is_active = cpu == cpumask_first(cpu_online_mask);
+	else
+		is_active = cpumask_test_cpu(cpu, smdata->active_cpus);
 
-	if (!active_cpus) {
-		if (cpu == cpumask_first(cpu_online_mask))
-			smdata = &active;
-	} else {
-		if (cpumask_test_cpu(cpu, active_cpus))
-			smdata = &active;
-	}
 	/* Simple state machine */
 	do {
 		/* Chill out and ensure we re-read stopmachine_state. */
 		cpu_relax();
-		if (state != curstate) {
-			curstate = state;
+		if (smdata->state != curstate) {
+			curstate = smdata->state;
 			switch (curstate) {
 			case STOPMACHINE_DISABLE_IRQ:
 				local_irq_disable();
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
-				/* On multiple CPUs only a single error code
-				 * is needed to tell that something failed. */
-				err = smdata->fn(smdata->data);
-				if (err)
-					smdata->fnret = err;
+				if (is_active)
+					err = smdata->fn(smdata->data);
 				break;
 			default:
 				break;
 			}
-			ack_state();
+			ack_state(smdata);
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
 	local_irq_enable();
+	return err;
 }
 
-/* Callback for CPUs which aren't supposed to do anything. */
-static int chill(void *unused)
-{
-	return 0;
-}
-
-int stop_machine_create(void)
-{
-	mutex_lock(&setup_lock);
-	if (refcount)
-		goto done;
-	stop_machine_wq = create_rt_workqueue("kstop");
-	if (!stop_machine_wq)
-		goto err_out;
-	stop_machine_work = alloc_percpu(struct work_struct);
-	if (!stop_machine_work)
-		goto err_out;
-done:
-	refcount++;
-	mutex_unlock(&setup_lock);
-	return 0;
-
-err_out:
-	if (stop_machine_wq)
-		destroy_workqueue(stop_machine_wq);
-	mutex_unlock(&setup_lock);
-	return -ENOMEM;
-}
-EXPORT_SYMBOL_GPL(stop_machine_create);
-
-void stop_machine_destroy(void)
-{
-	mutex_lock(&setup_lock);
-	refcount--;
-	if (refcount)
-		goto done;
-	destroy_workqueue(stop_machine_wq);
-	free_percpu(stop_machine_work);
-done:
-	mutex_unlock(&setup_lock);
-}
-EXPORT_SYMBOL_GPL(stop_machine_destroy);
-
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
-	struct work_struct *sm_work;
-	int i, ret;
-
-	/* Set up initial state. */
-	mutex_lock(&lock);
-	num_threads = num_online_cpus();
-	active_cpus = cpus;
-	active.fn = fn;
-	active.data = data;
-	active.fnret = 0;
-	idle.fn = chill;
-	idle.data = NULL;
-
-	set_state(STOPMACHINE_PREPARE);
-
-	/* Schedule the stop_cpu work on all cpus: hold this CPU so one
-	 * doesn't hit this CPU until we're ready. */
-	get_cpu();
-	for_each_online_cpu(i) {
-		sm_work = per_cpu_ptr(stop_machine_work, i);
-		INIT_WORK(sm_work, stop_cpu);
-		queue_work_on(i, stop_machine_wq, sm_work);
-	}
-	/* This will release the thread on our CPU. */
-	put_cpu();
-	flush_workqueue(stop_machine_wq);
-	ret = active.fnret;
-	mutex_unlock(&lock);
-	return ret;
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .num_threads = num_online_cpus(),
+					    .active_cpus = cpus };
+
+	/* Set the initial state and stop all online cpus. */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
 }
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 {
 	int ret;
 
-	ret = stop_machine_create();
-	if (ret)
-		return ret;
 	/* No CPUs can come up or down during this. */
 	get_online_cpus();
 	ret = __stop_machine(fn, data, cpus);
 	put_online_cpus();
-	stop_machine_destroy();
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stop_machine);
-- 
1.6.4.2

