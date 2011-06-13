Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab1FMSBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:01:11 -0400
Received: from mga14.intel.com ([143.182.124.37]:11503 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753658Ab1FMSBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,359,1304319600"; 
   d="scan'208";a="12022774"
Message-Id: <20110613175915.504721985@sbsiddha-MOBL3.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Mon, 13 Jun 2011 10:58:33 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, trenn@novell.com,
        prarit@redhat.com, tj@kernel.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        youquan.song@intel.com, stable@kernel.org
Subject: [patch v4 1/2] stop_machine: enable __stop_machine() to be called from the cpu online path
References: <20110613175832.331826123@sbsiddha-MOBL3.sc.intel.com>
Content-Disposition: inline; filename=stop_machine_from_cpu_hotplug_path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently stop machine infrastructure can be called only from a cpu that is
online. But for !CONFIG_SMP, we do allow calling __stop_machine() before the
cpu is online.

x86 for example requires stop machine infrastructure in the cpu online path
and currently implements its own stop machine (using stop_one_cpu_nowait())
for MTRR initialization in the cpu online path.

Enhance the __stop_machine() so that it can be called before the cpu
is onlined. This will pave the way for code consolidation and address potential
deadlocks caused by multiple mechanisms of doing system wide rendezvous.

This will also address the behavioral differences of __stop_machine()
between SMP and UP builds.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org    # v2.6.35+
---
 include/linux/stop_machine.h |   11 +++--
 kernel/stop_machine.c        |   91 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 93 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/kernel/stop_machine.c
===================================================================
--- linux-2.6-tip.orig/kernel/stop_machine.c
+++ linux-2.6-tip/kernel/stop_machine.c
@@ -28,6 +28,7 @@
 struct cpu_stop_done {
 	atomic_t		nr_todo;	/* nr left to execute */
 	bool			executed;	/* actually executed? */
+	bool			caller_offline; /* stop_cpu caller cpu status */
 	int			ret;		/* collected return value */
 	struct completion	completion;	/* fired if nr_todo reaches 0 */
 };
@@ -47,15 +48,24 @@ static void cpu_stop_init_done(struct cp
 	memset(done, 0, sizeof(*done));
 	atomic_set(&done->nr_todo, nr_todo);
 	init_completion(&done->completion);
+	done->caller_offline = !cpu_online(raw_smp_processor_id());
 }
 
 /* signal completion unless @done is NULL */
 static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
 {
 	if (done) {
+		bool caller_offline;
+
+		/*
+		 * Get the offline status before we do the atomic_dec_and_test
+		 * below. This will avoid unsafe references to the 'done'
+		 * memory that is present on the stop_cpu caller's stack.
+		 */
+		caller_offline = done->caller_offline;
 		if (executed)
 			done->executed = true;
-		if (atomic_dec_and_test(&done->nr_todo))
+		if (atomic_dec_and_test(&done->nr_todo) && !caller_offline)
 			complete(&done->completion);
 	}
 }
@@ -136,6 +146,56 @@ void stop_one_cpu_nowait(unsigned int cp
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
+/* stop all the online cpu's aswell as the calling cpu that is offline */
+static int __stop_all_cpus(cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_work *work;
+	struct cpu_stop_done done;
+	unsigned int cpu;
+	int ret;
+
+	/*
+	 * This cpu is not yet online, so loop till we get the mutex.
+	 */
+	while (!mutex_trylock(&stop_cpus_mutex))
+		cpu_relax();
+
+	/* initialize works and done */
+	for_each_cpu(cpu, cpu_online_mask) {
+		work = &per_cpu(stop_cpus_work, cpu);
+		work->fn = fn;
+		work->arg = arg;
+		work->done = &done;
+	}
+
+	cpu_stop_init_done(&done, num_online_cpus());
+
+	/*
+	 * Queue the work on all the online cpu's first.
+	 */
+	for_each_cpu(cpu, cpu_online_mask)
+		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
+				    &per_cpu(stop_cpus_work, cpu));
+
+	/*
+	 * This cpu is not yet online. @fn needs to be run on this
+	 * cpu, run it now.
+	 */
+	ret = fn(arg);
+	if (ret)
+		done.ret = ret;
+
+	/*
+	 * This cpu is not yet online. Wait synchronously for others to
+	 * complete the stop cpu work.
+	 */
+	while (atomic_read(&done.nr_todo))
+		cpu_relax();
+
+	mutex_unlock(&stop_cpus_mutex);
+	return done.ret;
+}
+
 int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 {
 	struct cpu_stop_work *work;
@@ -431,6 +491,7 @@ static int stop_machine_cpu_stop(void *d
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags = 0;
 	bool is_active;
 
 	if (!smdata->active_cpus)
@@ -446,7 +507,13 @@ static int stop_machine_cpu_stop(void *d
 			curstate = smdata->state;
 			switch (curstate) {
 			case STOPMACHINE_DISABLE_IRQ:
-				local_irq_disable();
+				/*
+				 * In most of the cases this gets called from
+				 * the stop_cpu thread context. But this can
+				 * also be called directly from the cpu online
+				 * path where interrupts are disabled.
+				 */
+				local_irq_save(flags);
 				hard_irq_disable();
 				break;
 			case STOPMACHINE_RUN:
@@ -460,7 +527,7 @@ static int stop_machine_cpu_stop(void *d
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 	return err;
 }
 
@@ -470,9 +537,23 @@ int __stop_machine(int (*fn)(void *), vo
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
-	/* Set the initial state and stop all online cpus. */
+	/*
+	 * Include the calling cpu that might not be online yet. We are
+	 * checking only for the online status here, so no need to worry about
+	 * preemption status (can't be preempted to a cpu that is not
+	 * yet online). So raw_smp_processor_id() is safe here.
+	 */
+	if (!cpu_online(raw_smp_processor_id()))
+		smdata.num_threads++;
+
+	/* Set the initial state and stop all cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
-	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);
+
+	if (!cpu_online(raw_smp_processor_id()))
+		return __stop_all_cpus(stop_machine_cpu_stop, &smdata);
+	else
+		return stop_cpus(cpu_online_mask, stop_machine_cpu_stop,
+				 &smdata);
 }
 
 int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
Index: linux-2.6-tip/include/linux/stop_machine.h
===================================================================
--- linux-2.6-tip.orig/include/linux/stop_machine.h
+++ linux-2.6-tip/include/linux/stop_machine.h
@@ -104,7 +104,7 @@ static inline int try_stop_cpus(const st
  * @data: the data ptr for the @fn()
  * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
- * Description: This causes a thread to be scheduled on every cpu,
+ * Description: This causes a thread to be scheduled on every online cpu,
  * each of which disables interrupts.  The result is that no one is
  * holding a spinlock or inside any other preempt-disabled region when
  * @fn() runs.
@@ -120,7 +120,9 @@ int stop_machine(int (*fn)(void *), void
  * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
  *
  * Description: This is a special version of the above, which assumes cpus
- * won't come or go while it's being called.  Used by hotplug cpu.
+ * won't come or go while it's being called.  Used by hotplug cpu. This can
+ * be also called from the cpu online path, where the calling cpu is not
+ * yet online.
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
@@ -129,10 +131,11 @@ int __stop_machine(int (*fn)(void *), vo
 static inline int __stop_machine(int (*fn)(void *), void *data,
 				 const struct cpumask *cpus)
 {
+	unsigned long flags;
 	int ret;
-	local_irq_disable();
+	local_irq_save(flags);
 	ret = fn(data);
-	local_irq_enable();
+	local_irq_restore(flags);
 	return ret;
 }
 


