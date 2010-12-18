Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab0LRP3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 10:29:00 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:55199 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab0LRP26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 10:28:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cI/3DbFrr1Q33SNPe5504F12iUyZXbxw0JayytpkxFSxDjC1PoVW20A7xo2hQydNol
         QokmiK2W70cDa78xXXOT8MzRR4x+wsyN6doPx9vqL+eTm8Jro8R3RWlTGu6PSEM54iN7
         2hhDKJaOICuhh8b24f+az3HlI0EZ0ITJjkQqM=
Message-ID: <4D0CD337.4080407@kernel.org>
Date: Sat, 18 Dec 2010 16:28:55 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Christoph Lameter <cl@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] x86: Use this_cpu_ops to optimize code
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Go through x86 code and replace __get_cpu_var and get_cpu_var
instances that refer to a scalar and are not used for address
determinations.

Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Christoph Lameter <cl@linux.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
Peter, these three patches are the x86 ones which were in
percpu#for-next but should go through x86 tree.  These should be
applied on top of percpu#this_cpu_ops.

Thank you.

 arch/x86/include/asm/debugreg.h           |    2 +-
 arch/x86/kernel/apic/io_apic.c            |    4 ++--
 arch/x86/kernel/apic/nmi.c                |   24 ++++++++++++------------
 arch/x86/kernel/apic/x2apic_uv_x.c        |    8 ++++----
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |    6 +++---
 arch/x86/kernel/cpu/perf_event.c          |   27 +++++++++++----------------
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 ++--
 arch/x86/kernel/ftrace.c                  |    6 +++---
 arch/x86/kernel/hw_breakpoint.c           |   12 ++++++------
 arch/x86/kernel/irq.c                     |    6 +++---
 arch/x86/kernel/irq_32.c                  |    4 ++--
 arch/x86/kernel/smpboot.c                 |    2 +-
 arch/x86/kernel/tsc.c                     |    2 +-
 arch/x86/kvm/x86.c                        |    8 ++++----
 arch/x86/oprofile/nmi_int.c               |    2 +-
 16 files changed, 57 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
index b81002f..078ad0c 100644
--- a/arch/x86/include/asm/debugreg.h
+++ b/arch/x86/include/asm/debugreg.h
@@ -94,7 +94,7 @@ static inline void hw_breakpoint_disable(void)

 static inline int hw_breakpoint_active(void)
 {
-	return __get_cpu_var(cpu_dr7) & DR_GLOBAL_ENABLE_MASK;
+	return __this_cpu_read(cpu_dr7) & DR_GLOBAL_ENABLE_MASK;
 }

 extern void aout_dump_debugregs(struct user *dump);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 7cc0a72..8d50922 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2302,7 +2302,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 		unsigned int irr;
 		struct irq_desc *desc;
 		struct irq_cfg *cfg;
-		irq = __get_cpu_var(vector_irq)[vector];
+		irq = __this_cpu_read(vector_irq[vector]);

 		if (irq == -1)
 			continue;
@@ -2336,7 +2336,7 @@ asmlinkage void smp_irq_move_cleanup_interrupt(void)
 			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
 			goto unlock;
 		}
-		__get_cpu_var(vector_irq)[vector] = -1;
+		__this_cpu_write(vector_irq[vector], -1);
 unlock:
 		raw_spin_unlock(&desc->lock);
 	}
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index c90041c..b387dce 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -306,12 +306,12 @@ void acpi_nmi_disable(void)
  */
 void cpu_nmi_set_wd_enabled(void)
 {
-	__get_cpu_var(wd_enabled) = 1;
+	__this_cpu_write(wd_enabled, 1);
 }

 void setup_apic_nmi_watchdog(void *unused)
 {
-	if (__get_cpu_var(wd_enabled))
+	if (__this_cpu_read(wd_enabled))
 		return;

 	/* cheap hack to support suspend/resume */
@@ -322,12 +322,12 @@ void setup_apic_nmi_watchdog(void *unused)
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
 		if (lapic_watchdog_init(nmi_hz) < 0) {
-			__get_cpu_var(wd_enabled) = 0;
+			__this_cpu_write(wd_enabled, 0);
 			return;
 		}
 		/* FALL THROUGH */
 	case NMI_IO_APIC:
-		__get_cpu_var(wd_enabled) = 1;
+		__this_cpu_write(wd_enabled, 1);
 		atomic_inc(&nmi_active);
 	}
 }
@@ -337,13 +337,13 @@ void stop_apic_nmi_watchdog(void *unused)
 	/* only support LOCAL and IO APICs for now */
 	if (!nmi_watchdog_active())
 		return;
-	if (__get_cpu_var(wd_enabled) == 0)
+	if (__this_cpu_read(wd_enabled) == 0)
 		return;
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		lapic_watchdog_stop();
 	else
 		__acpi_nmi_disable(NULL);
-	__get_cpu_var(wd_enabled) = 0;
+	__this_cpu_write(wd_enabled, 0);
 	atomic_dec(&nmi_active);
 }

@@ -403,8 +403,8 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)

 	sum = get_timer_irqs(cpu);

-	if (__get_cpu_var(nmi_touch)) {
-		__get_cpu_var(nmi_touch) = 0;
+	if (__this_cpu_read(nmi_touch)) {
+		__this_cpu_write(nmi_touch, 0);
 		touched = 1;
 	}

@@ -427,7 +427,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		touched = 1;

 	/* if the none of the timers isn't firing, this cpu isn't doing much */
-	if (!touched && __get_cpu_var(last_irq_sum) == sum) {
+	if (!touched && __this_cpu_read(last_irq_sum) == sum) {
 		/*
 		 * Ayiee, looks like this CPU is stuck ...
 		 * wait a few IRQs (5 seconds) before doing the oops ...
@@ -440,12 +440,12 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 			die_nmi("BUG: NMI Watchdog detected LOCKUP",
 				regs, panic_on_timeout);
 	} else {
-		__get_cpu_var(last_irq_sum) = sum;
+		__this_cpu_write(last_irq_sum, sum);
 		__this_cpu_write(alert_counter, 0);
 	}

 	/* see if the nmi watchdog went off */
-	if (!__get_cpu_var(wd_enabled))
+	if (!__this_cpu_read(wd_enabled))
 		return rc;
 	switch (nmi_watchdog) {
 	case NMI_LOCAL_APIC:
@@ -467,7 +467,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)

 static void enable_ioapic_nmi_watchdog_single(void *unused)
 {
-	__get_cpu_var(wd_enabled) = 1;
+	__this_cpu_write(wd_enabled, 1);
 	atomic_inc(&nmi_active);
 	__acpi_nmi_enable(NULL);
 }
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index c1c52c3..26ec9a7 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -118,8 +118,8 @@ static int __init uv_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		else if (!strcmp(oem_table_id, "UVX"))
 			uv_system_type = UV_X2APIC;
 		else if (!strcmp(oem_table_id, "UVH")) {
-			__get_cpu_var(x2apic_extra_bits) =
-				nodeid << (uvh_apicid.s.pnode_shift - 1);
+			__this_cpu_write(x2apic_extra_bits,
+				nodeid << (uvh_apicid.s.pnode_shift - 1));
 			uv_system_type = UV_NON_UNIQUE_APIC;
 			uv_set_apicid_hibit();
 			return 1;
@@ -284,7 +284,7 @@ static unsigned int x2apic_get_apic_id(unsigned long x)
 	unsigned int id;

 	WARN_ON(preemptible() && num_online_cpus() > 1);
-	id = x | __get_cpu_var(x2apic_extra_bits);
+	id = x | __this_cpu_read(x2apic_extra_bits);

 	return id;
 }
@@ -376,7 +376,7 @@ struct apic __refdata apic_x2apic_uv_x = {

 static __cpuinit void set_x2apic_extra_bits(int pnode)
 {
-	__get_cpu_var(x2apic_extra_bits) = (pnode << 6);
+	__this_cpu_write(x2apic_extra_bits, (pnode << 6));
 }

 /*
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 491977b..42a3604 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1377,7 +1377,7 @@ static int __devexit powernowk8_cpu_exit(struct cpufreq_policy *pol)
 static void query_values_on_cpu(void *_err)
 {
 	int *err = _err;
-	struct powernow_k8_data *data = __get_cpu_var(powernow_data);
+	struct powernow_k8_data *data = __this_cpu_read(powernow_data);

 	*err = query_current_values_with_pending_wait(data);
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 7a35b72..0c746af 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -326,7 +326,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)

 static int msr_to_offset(u32 msr)
 {
-	unsigned bank = __get_cpu_var(injectm.bank);
+	unsigned bank = __this_cpu_read(injectm.bank);

 	if (msr == rip_msr)
 		return offsetof(struct mce, ip);
@@ -346,7 +346,7 @@ static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;

-	if (__get_cpu_var(injectm).finished) {
+	if (__this_cpu_read(injectm.finished)) {
 		int offset = msr_to_offset(msr);

 		if (offset < 0)
@@ -369,7 +369,7 @@ static u64 mce_rdmsrl(u32 msr)

 static void mce_wrmsrl(u32 msr, u64 v)
 {
-	if (__get_cpu_var(injectm).finished) {
+	if (__this_cpu_read(injectm.finished)) {
 		int offset = msr_to_offset(msr);

 		if (offset >= 0)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6d75b91..ba85814 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -968,8 +968,7 @@ x86_perf_event_set_period(struct perf_event *event)

 static void x86_pmu_enable_event(struct perf_event *event)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	if (cpuc->enabled)
+	if (__this_cpu_read(cpu_hw_events.enabled))
 		__x86_pmu_enable_event(&event->hw,
 				       ARCH_PERFMON_EVENTSEL_ENABLE);
 }
@@ -1243,7 +1242,7 @@ perf_event_nmi_handler(struct notifier_block *self,
 		break;
 	case DIE_NMIUNKNOWN:
 		this_nmi = percpu_read(irq_stat.__nmi_count);
-		if (this_nmi != __get_cpu_var(pmu_nmi).marked)
+		if (this_nmi != __this_cpu_read(pmu_nmi.marked))
 			/* let the kernel handle the unknown nmi */
 			return NOTIFY_DONE;
 		/*
@@ -1267,8 +1266,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 	this_nmi = percpu_read(irq_stat.__nmi_count);
 	if ((handled > 1) ||
 		/* the next nmi could be a back-to-back nmi */
-	    ((__get_cpu_var(pmu_nmi).marked == this_nmi) &&
-	     (__get_cpu_var(pmu_nmi).handled > 1))) {
+	    ((__this_cpu_read(pmu_nmi.marked) == this_nmi) &&
+	     (__this_cpu_read(pmu_nmi.handled) > 1))) {
 		/*
 		 * We could have two subsequent back-to-back nmis: The
 		 * first handles more than one counter, the 2nd
@@ -1279,8 +1278,8 @@ perf_event_nmi_handler(struct notifier_block *self,
 		 * handling more than one counter. We will mark the
 		 * next (3rd) and then drop it if unhandled.
 		 */
-		__get_cpu_var(pmu_nmi).marked	= this_nmi + 1;
-		__get_cpu_var(pmu_nmi).handled	= handled;
+		__this_cpu_write(pmu_nmi.marked, this_nmi + 1);
+		__this_cpu_write(pmu_nmi.handled, handled);
 	}

 	return NOTIFY_STOP;
@@ -1454,11 +1453,9 @@ static inline void x86_pmu_read(struct perf_event *event)
  */
 static void x86_pmu_start_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
 	perf_pmu_disable(pmu);
-	cpuc->group_flag |= PERF_EVENT_TXN;
-	cpuc->n_txn = 0;
+	__this_cpu_or(cpu_hw_events.group_flag, PERF_EVENT_TXN);
+	__this_cpu_write(cpu_hw_events.n_txn, 0);
 }

 /*
@@ -1468,14 +1465,12 @@ static void x86_pmu_start_txn(struct pmu *pmu)
  */
 static void x86_pmu_cancel_txn(struct pmu *pmu)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-
-	cpuc->group_flag &= ~PERF_EVENT_TXN;
+	__this_cpu_and(cpu_hw_events.group_flag, ~PERF_EVENT_TXN);
 	/*
 	 * Truncate the collected events.
 	 */
-	cpuc->n_added -= cpuc->n_txn;
-	cpuc->n_events -= cpuc->n_txn;
+	__this_cpu_sub(cpu_hw_events.n_added, __this_cpu_read(cpu_hw_events.n_txn));
+	__this_cpu_sub(cpu_hw_events.n_events, __this_cpu_read(cpu_hw_events.n_txn));
 	perf_pmu_enable(pmu);
 }

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index c8f5c08..4ee59bc 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -649,7 +649,7 @@ static void intel_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;

 	if (unlikely(hwc->idx == X86_PMC_IDX_FIXED_BTS)) {
-		if (!__get_cpu_var(cpu_hw_events).enabled)
+		if (!__this_cpu_read(cpu_hw_events.enabled))
 			return;

 		intel_pmu_enable_bts(hwc->config);
@@ -679,7 +679,7 @@ static int intel_pmu_save_and_restart(struct perf_event *event)

 static void intel_pmu_reset(void)
 {
-	struct debug_store *ds = __get_cpu_var(cpu_hw_events).ds;
+	struct debug_store *ds = __this_cpu_read(cpu_hw_events.ds);
 	unsigned long flags;
 	int idx;

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3afb33f..b45246f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -167,9 +167,9 @@ static void ftrace_mod_code(void)

 void ftrace_nmi_enter(void)
 {
-	__get_cpu_var(save_modifying_code) = modifying_code;
+	__this_cpu_write(save_modifying_code, modifying_code);

-	if (!__get_cpu_var(save_modifying_code))
+	if (!__this_cpu_read(save_modifying_code))
 		return;

 	if (atomic_inc_return(&nmi_running) & MOD_CODE_WRITE_FLAG) {
@@ -183,7 +183,7 @@ void ftrace_nmi_enter(void)

 void ftrace_nmi_exit(void)
 {
-	if (!__get_cpu_var(save_modifying_code))
+	if (!__this_cpu_read(save_modifying_code))
 		return;

 	/* Finish all executions before clearing nmi_running */
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 42c5942..02f0763 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -122,7 +122,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 		return -EBUSY;

 	set_debugreg(info->address, i);
-	__get_cpu_var(cpu_debugreg[i]) = info->address;
+	__this_cpu_write(cpu_debugreg[i], info->address);

 	dr7 = &__get_cpu_var(cpu_dr7);
 	*dr7 |= encode_dr7(i, info->len, info->type);
@@ -397,12 +397,12 @@ void flush_ptrace_hw_breakpoint(struct task_struct *tsk)

 void hw_breakpoint_restore(void)
 {
-	set_debugreg(__get_cpu_var(cpu_debugreg[0]), 0);
-	set_debugreg(__get_cpu_var(cpu_debugreg[1]), 1);
-	set_debugreg(__get_cpu_var(cpu_debugreg[2]), 2);
-	set_debugreg(__get_cpu_var(cpu_debugreg[3]), 3);
+	set_debugreg(__this_cpu_read(cpu_debugreg[0]), 0);
+	set_debugreg(__this_cpu_read(cpu_debugreg[1]), 1);
+	set_debugreg(__this_cpu_read(cpu_debugreg[2]), 2);
+	set_debugreg(__this_cpu_read(cpu_debugreg[3]), 3);
 	set_debugreg(current->thread.debugreg6, 6);
-	set_debugreg(__get_cpu_var(cpu_dr7), 7);
+	set_debugreg(__this_cpu_read(cpu_dr7), 7);
 }
 EXPORT_SYMBOL_GPL(hw_breakpoint_restore);

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 83ec017..3a43caa 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -234,7 +234,7 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *regs)
 	exit_idle();
 	irq_enter();

-	irq = __get_cpu_var(vector_irq)[vector];
+	irq = __this_cpu_read(vector_irq[vector]);

 	if (!handle_irq(irq, regs)) {
 		ack_APIC_irq();
@@ -350,12 +350,12 @@ void fixup_irqs(void)
 	for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 		unsigned int irr;

-		if (__get_cpu_var(vector_irq)[vector] < 0)
+		if (__this_cpu_read(vector_irq[vector]) < 0)
 			continue;

 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
 		if (irr  & (1 << (vector % 32))) {
-			irq = __get_cpu_var(vector_irq)[vector];
+			irq = __this_cpu_read(vector_irq[vector]);

 			data = irq_get_irq_data(irq);
 			raw_spin_lock(&desc->lock);
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 96656f2..48ff6dc 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -79,7 +79,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 	u32 *isp, arg1, arg2;

 	curctx = (union irq_ctx *) current_thread_info();
-	irqctx = __get_cpu_var(hardirq_ctx);
+	irqctx = __this_cpu_read(hardirq_ctx);

 	/*
 	 * this is where we switch to the IRQ stack. However, if we are
@@ -166,7 +166,7 @@ asmlinkage void do_softirq(void)

 	if (local_softirq_pending()) {
 		curctx = current_thread_info();
-		irqctx = __get_cpu_var(softirq_ctx);
+		irqctx = __this_cpu_read(softirq_ctx);
 		irqctx->tinfo.task = curctx->task;
 		irqctx->tinfo.previous_esp = current_stack_pointer;

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 083e99d..ff4e5a1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1377,7 +1377,7 @@ void play_dead_common(void)

 	mb();
 	/* Ack it */
-	__get_cpu_var(cpu_state) = CPU_DEAD;
+	__this_cpu_write(cpu_state, CPU_DEAD);

 	/*
 	 * With physical CPU hotplug, we should halt the cpu
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 0c40d8b..acb08dd 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -659,7 +659,7 @@ void restore_sched_clock_state(void)

 	local_irq_save(flags);

-	__get_cpu_var(cyc2ns_offset) = 0;
+	__this_cpu_write(cyc2ns_offset, 0);
 	offset = cyc2ns_suspend - sched_clock();

 	for_each_possible_cpu(cpu)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cdac9e5..79d9606 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -981,7 +981,7 @@ static inline u64 nsec_to_cycles(u64 nsec)
 	if (kvm_tsc_changes_freq())
 		printk_once(KERN_WARNING
 		 "kvm: unreliable cycle conversion on adjustable rate TSC\n");
-	ret = nsec * __get_cpu_var(cpu_tsc_khz);
+	ret = nsec * __this_cpu_read(cpu_tsc_khz);
 	do_div(ret, USEC_PER_SEC);
 	return ret;
 }
@@ -1066,7 +1066,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	local_irq_save(flags);
 	kvm_get_msr(v, MSR_IA32_TSC, &tsc_timestamp);
 	kernel_ns = get_kernel_ns();
-	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	this_tsc_khz = __this_cpu_read(cpu_tsc_khz);

 	if (unlikely(this_tsc_khz == 0)) {
 		local_irq_restore(flags);
@@ -4432,7 +4432,7 @@ EXPORT_SYMBOL_GPL(kvm_fast_pio_out);

 static void tsc_bad(void *info)
 {
-	__get_cpu_var(cpu_tsc_khz) = 0;
+	__this_cpu_write(cpu_tsc_khz, 0);
 }

 static void tsc_khz_changed(void *data)
@@ -4446,7 +4446,7 @@ static void tsc_khz_changed(void *data)
 		khz = cpufreq_quick_get(raw_smp_processor_id());
 	if (!khz)
 		khz = tsc_khz;
-	__get_cpu_var(cpu_tsc_khz) = khz;
+	__this_cpu_write(cpu_tsc_khz, khz);
 }

 static int kvmclock_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 4e8baad..a0cae67 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -143,7 +143,7 @@ static inline int has_mux(void)

 inline int op_x86_phys_to_virt(int phys)
 {
-	return __get_cpu_var(switch_index) + phys;
+	return __this_cpu_read(switch_index) + phys;
 }

 inline int op_x86_virt_to_phys(int virt)
-- 
1.7.1

