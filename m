Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab2FAJMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:12:51 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:41771 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127Ab2FAJMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:12:47 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 07/27] x86, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Yinghai Lu <yinghai@kernel.org>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Don Zickus <dzickus@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Fri, 01 Jun 2012 14:41:56 +0530
Message-ID: <20120601091148.31979.53116.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060109-2674-0000-0000-000004C07E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Convert x86 to use the generic framework to boot secondary CPUs.

Notes:
1. x86 manipulates the cpu_online_mask under vector_lock. So, while
converting over to the generic smp booting code, override arch_vector_lock()
and arch_vector_unlock() to lock_vector_lock() and unlock_vector_lock()
respectively.

2. In smp_callin(), we allow the master to continue as soon as the physical
booting of the secondary processor is done. That is, we don't wait till the
CPU_STARTING notifications are sent.

Implications:
 - This does not alter the order in which the notifications are sent (i.e.,
   still CPU_STARTING is followed by CPU_ONLINE) because the master waits till
   the new cpu is set in the cpu_online_mask before returning to generic code.

 - This approach is better because of 2 reasons:
   a. It makes more sense: the master has a timeout for waiting on the
      cpu_callin_map - which means we should report back as soon as possible.
      The whole idea of having a timeout is to estimate the maximum time that
      could be taken for physical booting. This approach separates out the
      physical booting vs running CPU hotplug callbacks and reports back to
      the master as soon as physical booting is done.

   b. Because we send out CPU_STARTING notifications *after* reporting to the
      master, we don't risk the chance of the master wrongly concluding a boot
      failure if we happen to add more callbacks to the CPU_STARTING
      notification.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/x86/include/asm/smp.h     |    3 +++
 arch/x86/kernel/apic/io_apic.c |   15 +++++++++++++++
 arch/x86/kernel/smp.c          |    4 ++++
 arch/x86/kernel/smpboot.c      |   39 ++++++++++++++-------------------------
 4 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index ac1f3eb..b081b90 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -176,6 +176,9 @@ void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
+void native_cpu_pre_starting(void *arg);
+void native_cpu_pre_online(void *arg);
+void native_cpu_post_online(void *arg);
 int native_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ac96561..a7d0037 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1084,6 +1084,21 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 }
 EXPORT_SYMBOL(IO_APIC_get_PCI_irq_vector);
 
+/*
+ * We need to hold vector_lock while manipulating cpu_online_mask so that the
+ * set of online cpus does not change while we are assigning vectors to cpus.
+ * Holding this lock ensures we don't half assign or remove an irq from a cpu.
+ */
+void arch_vector_lock(void)
+{
+	lock_vector_lock();
+}
+
+void arch_vector_unlock(void)
+{
+	unlock_vector_lock();
+}
+
 void lock_vector_lock(void)
 {
 	/* Used to the online set of cpus does not change
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 48d2b7d..4a9748e 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -293,6 +293,10 @@ struct smp_ops smp_ops = {
 	.stop_other_cpus	= native_stop_other_cpus,
 	.smp_send_reschedule	= native_smp_send_reschedule,
 
+	.cpu_pre_starting	= native_cpu_pre_starting,
+	.cpu_pre_online		= native_cpu_pre_online,
+	.cpu_post_online	= native_cpu_post_online,
+
 	.cpu_up			= native_cpu_up,
 	.cpu_die		= native_cpu_die,
 	.cpu_disable		= native_cpu_disable,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 269bc1f..202be43 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -189,7 +189,7 @@ static void __cpuinit smp_callin(void)
 	/*
 	 * Need to setup vector mappings before we enable interrupts.
 	 */
-	setup_vector_irq(smp_processor_id());
+	setup_vector_irq(cpuid);
 
 	/*
 	 * Save our processor parameters. Note: this information
@@ -211,14 +211,10 @@ static void __cpuinit smp_callin(void)
 	 * This must be done before setting cpu_online_mask
 	 * or calling notify_cpu_starting.
 	 */
-	set_cpu_sibling_map(raw_smp_processor_id());
+	set_cpu_sibling_map(cpuid);
 	wmb();
 
-	notify_cpu_starting(cpuid);
-
-	/*
-	 * Allow the master to continue.
-	 */
+	/* Allow the master to continue. */
 	cpumask_set_cpu(cpuid, cpu_callin_mask);
 }
 
@@ -227,6 +223,11 @@ static void __cpuinit smp_callin(void)
  */
 notrace static void __cpuinit start_secondary(void *unused)
 {
+	smpboot_start_secondary(unused);
+}
+
+void __cpuinit native_cpu_pre_starting(void *unused)
+{
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
 	 * fragile that we want to limit the things done here to the
@@ -234,43 +235,31 @@ notrace static void __cpuinit start_secondary(void *unused)
 	 */
 	cpu_init();
 	x86_cpuinit.early_percpu_clock_init();
-	preempt_disable();
 	smp_callin();
+}
 
+void __cpuinit native_cpu_pre_online(void *unused)
+{
 #ifdef CONFIG_X86_32
 	/* switch away from the initial page table */
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
 
-	/* otherwise gcc will move up smp_processor_id before the cpu_init */
-	barrier();
 	/*
 	 * Check TSC synchronization with the BP:
 	 */
 	check_tsc_sync_target();
+}
 
-	/*
-	 * We need to hold vector_lock so there the set of online cpus
-	 * does not change while we are assigning vectors to cpus.  Holding
-	 * this lock ensures we don't half assign or remove an irq from a cpu.
-	 */
-	lock_vector_lock();
-	set_cpu_online(smp_processor_id(), true);
-	unlock_vector_lock();
-	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
+void __cpuinit native_cpu_post_online(void *unused)
+{
 	x86_platform.nmi_init();
 
-	/* enable local interrupts */
-	local_irq_enable();
-
 	/* to prevent fake stack check failure in clock setup */
 	boot_init_stack_canary();
 
 	x86_cpuinit.setup_percpu_clockev();
-
-	wmb();
-	cpu_idle();
 }
 
 /*

