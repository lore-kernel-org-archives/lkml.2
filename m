Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab1GVPRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:17:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43641 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1GVPRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:17:30 -0400
Date: Fri, 22 Jul 2011 17:16:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] x86/mtrr changes for v3.1
Message-ID: <20110722151638.GA22644@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-mtrr-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-mtrr-for-linus


out-of-topic modifications in x86-mtrr-for-linus:
-------------------------------------------------
include/linux/stop_machine.h       # 192d885: x86, mtrr: use stop_machine APIs 
                                   # f740e6cd: stop_machine: implement stop_mac
                                   # 6d3321e: x86, mtrr: lock stop machine duri
kernel/stop_machine.c              # 192d885: x86, mtrr: use stop_machine APIs 
                                   # f740e6cd: stop_machine: implement stop_mac
                                   # fd7355b: stop_machine: reorganize stop_cpu
                                   # 6d3321e: x86, mtrr: lock stop machine duri

 Thanks,

	Ingo

------------------>
Sergei Shtylyov (1):
      x86, mtrr: Use pci_dev->revision

Suresh Siddha (2):
      x86, mtrr: lock stop machine during MTRR rendezvous sequence
      x86, mtrr: use stop_machine APIs for doing MTRR rendezvous

Tejun Heo (2):
      stop_machine: reorganize stop_cpus() implementation
      stop_machine: implement stop_machine_from_inactive_cpu()


 arch/x86/kernel/cpu/mtrr/main.c |  182 ++++++++++-----------------------------
 include/linux/stop_machine.h    |   14 +++-
 kernel/stop_machine.c           |   78 ++++++++++++++++-
 3 files changed, 131 insertions(+), 143 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 929739a..08119a3 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -79,7 +79,6 @@ void set_mtrr_ops(const struct mtrr_ops *ops)
 static int have_wrcomb(void)
 {
 	struct pci_dev *dev;
-	u8 rev;
 
 	dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL);
 	if (dev != NULL) {
@@ -89,13 +88,11 @@ static int have_wrcomb(void)
 		 * chipsets to be tagged
 		 */
 		if (dev->vendor == PCI_VENDOR_ID_SERVERWORKS &&
-		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
-			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
-			if (rev <= 5) {
-				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
-				pci_dev_put(dev);
-				return 0;
-			}
+		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE &&
+		    dev->revision <= 5) {
+			pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+			pci_dev_put(dev);
+			return 0;
 		}
 		/*
 		 * Intel 450NX errata # 23. Non ascending cacheline evictions to
@@ -137,55 +134,43 @@ static void __init init_table(void)
 }
 
 struct set_mtrr_data {
-	atomic_t	count;
-	atomic_t	gate;
 	unsigned long	smp_base;
 	unsigned long	smp_size;
 	unsigned int	smp_reg;
 	mtrr_type	smp_type;
 };
 
-static DEFINE_PER_CPU(struct cpu_stop_work, mtrr_work);
-
 /**
- * mtrr_work_handler - Synchronisation handler. Executed by "other" CPUs.
+ * mtrr_rendezvous_handler - Work done in the synchronization handler. Executed
+ * by all the CPUs.
  * @info: pointer to mtrr configuration data
  *
  * Returns nothing.
  */
-static int mtrr_work_handler(void *info)
+static int mtrr_rendezvous_handler(void *info)
 {
 #ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
-	unsigned long flags;
-
-	atomic_dec(&data->count);
-	while (!atomic_read(&data->gate))
-		cpu_relax();
-
-	local_irq_save(flags);
-
-	atomic_dec(&data->count);
-	while (atomic_read(&data->gate))
-		cpu_relax();
 
-	/*  The master has cleared me to execute  */
+	/*
+	 * We use this same function to initialize the mtrrs during boot,
+	 * resume, runtime cpu online and on an explicit request to set a
+	 * specific MTRR.
+	 *
+	 * During boot or suspend, the state of the boot cpu's mtrrs has been
+	 * saved, and we want to replicate that across all the cpus that come
+	 * online (either at the end of boot or resume or during a runtime cpu
+	 * online). If we're doing that, @reg is set to something special and on
+	 * all the cpu's we do mtrr_if->set_all() (On the logical cpu that
+	 * started the boot/resume sequence, this might be a duplicate
+	 * set_all()).
+	 */
 	if (data->smp_reg != ~0U) {
 		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	} else if (mtrr_aps_delayed_init) {
-		/*
-		 * Initialize the MTRRs inaddition to the synchronisation.
-		 */
+	} else if (mtrr_aps_delayed_init || !cpu_online(smp_processor_id())) {
 		mtrr_if->set_all();
 	}
-
-	atomic_dec(&data->count);
-	while (!atomic_read(&data->gate))
-		cpu_relax();
-
-	atomic_dec(&data->count);
-	local_irq_restore(flags);
 #endif
 	return 0;
 }
@@ -223,20 +208,11 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2)
  * 14. Wait for buddies to catch up
  * 15. Enable interrupts.
  *
- * What does that mean for us? Well, first we set data.count to the number
- * of CPUs. As each CPU announces that it started the rendezvous handler by
- * decrementing the count, We reset data.count and set the data.gate flag
- * allowing all the cpu's to proceed with the work. As each cpu disables
- * interrupts, it'll decrement data.count once. We wait until it hits 0 and
- * proceed. We clear the data.gate flag and reset data.count. Meanwhile, they
- * are waiting for that flag to be cleared. Once it's cleared, each
- * CPU goes through the transition of updating MTRRs.
- * The CPU vendors may each do it differently,
- * so we call mtrr_if->set() callback and let them take care of it.
- * When they're done, they again decrement data->count and wait for data.gate
- * to be set.
- * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag
- * Everyone then enables interrupts and we all continue on.
+ * What does that mean for us? Well, stop_machine() will ensure that
+ * the rendezvous handler is started on each CPU. And in lockstep they
+ * do the state transition of disabling interrupts, updating MTRR's
+ * (the CPU vendors may each do it differently, so we call mtrr_if->set()
+ * callback and let them take care of it.) and enabling interrupts.
  *
  * Note that the mechanism is the same for UP systems, too; all the SMP stuff
  * becomes nops.
@@ -244,92 +220,26 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2)
 static void
 set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
-	struct set_mtrr_data data;
-	unsigned long flags;
-	int cpu;
-
-	preempt_disable();
-
-	data.smp_reg = reg;
-	data.smp_base = base;
-	data.smp_size = size;
-	data.smp_type = type;
-	atomic_set(&data.count, num_booting_cpus() - 1);
-
-	/* Make sure data.count is visible before unleashing other CPUs */
-	smp_wmb();
-	atomic_set(&data.gate, 0);
-
-	/* Start the ball rolling on other CPUs */
-	for_each_online_cpu(cpu) {
-		struct cpu_stop_work *work = &per_cpu(mtrr_work, cpu);
-
-		if (cpu == smp_processor_id())
-			continue;
-
-		stop_one_cpu_nowait(cpu, mtrr_work_handler, &data, work);
-	}
-
-
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	/* Ok, reset count and toggle gate */
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 1);
-
-	local_irq_save(flags);
-
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	/* Ok, reset count and toggle gate */
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 0);
-
-	/* Do our MTRR business */
-
-	/*
-	 * HACK!
-	 *
-	 * We use this same function to initialize the mtrrs during boot,
-	 * resume, runtime cpu online and on an explicit request to set a
-	 * specific MTRR.
-	 *
-	 * During boot or suspend, the state of the boot cpu's mtrrs has been
-	 * saved, and we want to replicate that across all the cpus that come
-	 * online (either at the end of boot or resume or during a runtime cpu
-	 * online). If we're doing that, @reg is set to something special and on
-	 * this cpu we still do mtrr_if->set_all(). During boot/resume, this
-	 * is unnecessary if at this point we are still on the cpu that started
-	 * the boot/resume sequence. But there is no guarantee that we are still
-	 * on the same cpu. So we do mtrr_if->set_all() on this cpu aswell to be
-	 * sure that we are in sync with everyone else.
-	 */
-	if (reg != ~0U)
-		mtrr_if->set(reg, base, size, type);
-	else
-		mtrr_if->set_all();
+	struct set_mtrr_data data = { .smp_reg = reg,
+				      .smp_base = base,
+				      .smp_size = size,
+				      .smp_type = type
+				    };
 
-	/* Wait for the others */
-	while (atomic_read(&data.count))
-		cpu_relax();
-
-	atomic_set(&data.count, num_booting_cpus() - 1);
-	smp_wmb();
-	atomic_set(&data.gate, 1);
-
-	/*
-	 * Wait here for everyone to have seen the gate change
-	 * So we're the last ones to touch 'data'
-	 */
-	while (atomic_read(&data.count))
-		cpu_relax();
+	stop_machine(mtrr_rendezvous_handler, &data, cpu_online_mask);
+}
 
-	local_irq_restore(flags);
-	preempt_enable();
+static void set_mtrr_from_inactive_cpu(unsigned int reg, unsigned long base,
+				      unsigned long size, mtrr_type type)
+{
+	struct set_mtrr_data data = { .smp_reg = reg,
+				      .smp_base = base,
+				      .smp_size = size,
+				      .smp_type = type
+				    };
+
+	stop_machine_from_inactive_cpu(mtrr_rendezvous_handler, &data,
+				       cpu_callout_mask);
 }
 
 /**
@@ -783,7 +693,7 @@ void mtrr_ap_init(void)
 	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
 	 *      lock to prevent mtrr entry changes
 	 */
-	set_mtrr(~0U, 0, 0, 0);
+	set_mtrr_from_inactive_cpu(~0U, 0, 0, 0);
 }
 
 /**
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index 092dc9b..4a9d0c7 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -124,15 +124,19 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
  */
 int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus);
 
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				   const struct cpumask *cpus);
+
 #else	 /* CONFIG_STOP_MACHINE && CONFIG_SMP */
 
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
 
@@ -142,5 +146,11 @@ static inline int stop_machine(int (*fn)(void *), void *data,
 	return __stop_machine(fn, data, cpus);
 }
 
+static inline int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+						 const struct cpumask *cpus)
+{
+	return __stop_machine(fn, data, cpus);
+}
+
 #endif	/* CONFIG_STOP_MACHINE && CONFIG_SMP */
 #endif	/* _LINUX_STOP_MACHINE */
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index e3516b2..c112475 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -136,10 +136,11 @@ void stop_one_cpu_nowait(unsigned int cpu, cpu_stop_fn_t fn, void *arg,
 static DEFINE_MUTEX(stop_cpus_mutex);
 static DEFINE_PER_CPU(struct cpu_stop_work, stop_cpus_work);
 
-int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
+static void queue_stop_cpus_work(const struct cpumask *cpumask,
+				 cpu_stop_fn_t fn, void *arg,
+				 struct cpu_stop_done *done)
 {
 	struct cpu_stop_work *work;
-	struct cpu_stop_done done;
 	unsigned int cpu;
 
 	/* initialize works and done */
@@ -147,9 +148,8 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 		work = &per_cpu(stop_cpus_work, cpu);
 		work->fn = fn;
 		work->arg = arg;
-		work->done = &done;
+		work->done = done;
 	}
-	cpu_stop_init_done(&done, cpumask_weight(cpumask));
 
 	/*
 	 * Disable preemption while queueing to avoid getting
@@ -161,7 +161,15 @@ int __stop_cpus(const struct cpumask *cpumask, cpu_stop_fn_t fn, void *arg)
 		cpu_stop_queue_work(&per_cpu(cpu_stopper, cpu),
 				    &per_cpu(stop_cpus_work, cpu));
 	preempt_enable();
+}
 
+static int __stop_cpus(const struct cpumask *cpumask,
+		       cpu_stop_fn_t fn, void *arg)
+{
+	struct cpu_stop_done done;
+
+	cpu_stop_init_done(&done, cpumask_weight(cpumask));
+	queue_stop_cpus_work(cpumask, fn, arg, &done);
 	wait_for_completion(&done.completion);
 	return done.executed ? done.ret : -ENOENT;
 }
@@ -431,8 +439,15 @@ static int stop_machine_cpu_stop(void *data)
 	struct stop_machine_data *smdata = data;
 	enum stopmachine_state curstate = STOPMACHINE_NONE;
 	int cpu = smp_processor_id(), err = 0;
+	unsigned long flags;
 	bool is_active;
 
+	/*
+	 * When called from stop_machine_from_inactive_cpu(), irq might
+	 * already be disabled.  Save the state and restore it on exit.
+	 */
+	local_save_flags(flags);
+
 	if (!smdata->active_cpus)
 		is_active = cpu == cpumask_first(cpu_online_mask);
 	else
@@ -460,7 +475,7 @@ static int stop_machine_cpu_stop(void *data)
 		}
 	} while (curstate != STOPMACHINE_EXIT);
 
-	local_irq_enable();
+	local_irq_restore(flags);
 	return err;
 }
 
@@ -487,4 +502,57 @@ int stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 }
 EXPORT_SYMBOL_GPL(stop_machine);
 
+/**
+ * stop_machine_from_inactive_cpu - stop_machine() from inactive CPU
+ * @fn: the function to run
+ * @data: the data ptr for the @fn()
+ * @cpus: the cpus to run the @fn() on (NULL = any online cpu)
+ *
+ * This is identical to stop_machine() but can be called from a CPU which
+ * is not active.  The local CPU is in the process of hotplug (so no other
+ * CPU hotplug can start) and not marked active and doesn't have enough
+ * context to sleep.
+ *
+ * This function provides stop_machine() functionality for such state by
+ * using busy-wait for synchronization and executing @fn directly for local
+ * CPU.
+ *
+ * CONTEXT:
+ * Local CPU is inactive.  Temporarily stops all active CPUs.
+ *
+ * RETURNS:
+ * 0 if all executions of @fn returned 0, any non zero return value if any
+ * returned non zero.
+ */
+int stop_machine_from_inactive_cpu(int (*fn)(void *), void *data,
+				  const struct cpumask *cpus)
+{
+	struct stop_machine_data smdata = { .fn = fn, .data = data,
+					    .active_cpus = cpus };
+	struct cpu_stop_done done;
+	int ret;
+
+	/* Local CPU must be inactive and CPU hotplug in progress. */
+	BUG_ON(cpu_active(raw_smp_processor_id()));
+	smdata.num_threads = num_active_cpus() + 1;	/* +1 for local */
+
+	/* No proper task established and can't sleep - busy wait for lock. */
+	while (!mutex_trylock(&stop_cpus_mutex))
+		cpu_relax();
+
+	/* Schedule work on other CPUs and execute directly for local CPU */
+	set_state(&smdata, STOPMACHINE_PREPARE);
+	cpu_stop_init_done(&done, num_active_cpus());
+	queue_stop_cpus_work(cpu_active_mask, stop_machine_cpu_stop, &smdata,
+			     &done);
+	ret = stop_machine_cpu_stop(&smdata);
+
+	/* Busy wait for completion. */
+	while (!completion_done(&done.completion))
+		cpu_relax();
+
+	mutex_unlock(&stop_cpus_mutex);
+	return ret ?: done.ret;
+}
+
 #endif	/* CONFIG_STOP_MACHINE */
