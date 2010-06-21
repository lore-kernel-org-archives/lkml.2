Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162Ab0FUJb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 05:31:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:6748 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab0FUJba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 05:31:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="578273169"
Subject: [PATCH V2 4/5] ara virt interface of perf to support kvm guest os
 statistics collection in guest os
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 21 Jun 2010 17:31:46 +0800
Message-Id: <1277112706.2096.512.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 4th patch is to implement para virt perf at guest side.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

--- linux-2.6_tip0620/arch/x86/Kconfig	2010-06-21 15:19:39.180999849 +0800
+++ linux-2.6_tip0620perfkvm/arch/x86/Kconfig	2010-06-21 15:21:39.309999849 +0800
@@ -552,6 +552,14 @@ config KVM_GUEST
 	  This option enables various optimizations for running under the KVM
 	  hypervisor.
 
+config KVM_PERF
+	bool "KVM Guest perf support"
+	select PARAVIRT
+	select PERF_EVENT
+	---help---
+	  This option enables various optimizations for running perf in
+	  guest os under the KVM hypervisor.
+
 source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
--- linux-2.6_tip0620/arch/x86/kernel/cpu/perf_event.c	2010-06-21 15:19:39.964999849 +0800
+++ linux-2.6_tip0620perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-06-21 16:44:36.602999849 +0800
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/kvm_para.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -583,10 +584,20 @@ static void x86_pmu_disable_all(void)
 	}
 }
 
+#ifdef CONFIG_KVM_PERF
+static int kvm_hw_perf_enable(void);
+static int kvm_hw_perf_disable(void);
+#endif
+
 void hw_perf_disable(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
+#ifdef CONFIG_KVM_PERF
+	if (!kvm_hw_perf_disable())
+		return;
+#endif
+
 	if (!x86_pmu_initialized())
 		return;
 
@@ -810,6 +821,11 @@ void hw_perf_enable(void)
 	struct hw_perf_event *hwc;
 	int i, added = cpuc->n_added;
 
+#ifdef CONFIG_KVM_PERF
+	if (!kvm_hw_perf_enable())
+		return;
+#endif
+
 	if (!x86_pmu_initialized())
 		return;
 
@@ -1264,6 +1280,7 @@ x86_get_event_constraints(struct cpu_hw_
 #include "perf_event_intel_lbr.c"
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
+#include "perf_event_kvm.c"
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
@@ -1317,6 +1334,11 @@ void __init init_hw_perf_events(void)
 
 	pr_info("Performance Events: ");
 
+#ifdef CONFIG_KVM_PERF
+	if (!kvm_init_hw_perf_events())
+		return;
+#endif
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		err = intel_pmu_init();
@@ -1541,6 +1563,13 @@ const struct pmu *hw_perf_event_init(str
 	const struct pmu *tmp;
 	int err;
 
+#ifdef CONFIG_KVM_PERF
+	if (kvm_para_available()) {
+		tmp = kvm_hw_perf_event_init(event);
+		return tmp;
+	}
+#endif
+
 	err = __hw_perf_event_init(event);
 	if (!err) {
 		/*
--- linux-2.6_tip0620/arch/x86/kernel/cpu/perf_event_kvm.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6_tip0620perfkvm/arch/x86/kernel/cpu/perf_event_kvm.c	2010-06-21 16:44:56.735999849 +0800
@@ -0,0 +1,426 @@
+/*
+ * Performance events
+ *
+ * Copyright (C) 2010 Intel Corporation
+ *     Zhang Yanmin <yanmin.zhang@intel.com>
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#ifdef CONFIG_KVM_PERF
+
+static atomic_t guest_perf_id; /*Global id counter per guest os*/
+
+static inline int get_new_perf_event_id(void)
+{
+	return atomic_inc_return(&guest_perf_id);
+}
+
+#ifdef CONFIG_X86_LOCAL_APIC
+
+static bool kvm_reserve_pmc_hardware(void)
+{
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		disable_lapic_nmi_watchdog();
+
+	return true;
+}
+
+static void kvm_release_pmc_hardware(void)
+{
+	if (nmi_watchdog == NMI_LOCAL_APIC)
+		enable_lapic_nmi_watchdog();
+}
+
+#else
+
+static bool kvm_reserve_pmc_hardware(void) { return true; }
+static void kvm_release_pmc_hardware(void) {}
+
+#endif
+
+static void kvm_hw_perf_event_destroy(struct perf_event *event)
+{
+	struct guest_perf_shadow *shadow = event->guest_perf_shadow;
+
+	BUG_ON(!shadow);
+	kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_CLOSE, shadow->id);
+
+	kfree(shadow);
+	event->guest_perf_shadow = NULL;
+
+	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
+		kvm_release_pmc_hardware();
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+}
+
+/* The guest might also run as a host */
+static int check_ontop_guest_overflow(struct perf_event *event, int overflows)
+{
+	struct host_perf_shadow *host_shadow = event->host_perf_shadow;
+	if (!host_shadow)
+		return 0;
+
+	if (perf_guest_cbs)
+		perf_guest_cbs->copy_event_to_shadow(event, overflows);
+
+	return 1;
+}
+
+static int
+check_event_overflow(struct perf_event *event, struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct guest_perf_shadow *guest_shadow = event->guest_perf_shadow;
+	s32 overflows;
+	int i;
+	int handled = 0;
+
+	local64_set(&event->count, guest_shadow->counter.count);
+
+again:
+	overflows = atomic_read(&guest_shadow->counter.overflows);
+	if (atomic_cmpxchg(&guest_shadow->counter.overflows, overflows, 0) !=
+			overflows)
+		goto again;
+
+	if (check_ontop_guest_overflow(event, overflows)) {
+		handled = 1;
+		return handled;
+	}
+
+	for (i = 0; i < overflows; i++) {
+		perf_sample_data_init(&data, 0);
+
+		data.period = event->hw.last_period;
+
+		if (event->overflow_handler)
+			event->overflow_handler(event, 1, &data, regs);
+		else
+
+			perf_event_output(event, 1, &data, regs);
+
+		handled++;
+	}
+
+	return handled;
+}
+
+static int
+kvm_check_event_overflow(struct pt_regs *regs)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct perf_event *event;
+	int i, max_count;
+	int handled = 0;
+
+	max_count = X86_PMC_IDX_MAX;
+	for (i = 0; i < max_count; i++) {
+		event = cpuc->event_list[i];
+		if (event)
+			handled += check_event_overflow(event, regs);
+	}
+	return handled;
+}
+
+static DEFINE_PER_CPU(int, kvm_nmi_entered);
+
+static int kvm_x86_pmu_handle_irq(struct pt_regs *regs)
+{
+	int handled = 0;
+
+	if (percpu_read(kvm_nmi_entered))
+		return 0;
+
+	percpu_write(kvm_nmi_entered, 1);
+
+	handled = kvm_check_event_overflow(regs);
+	if (handled)
+		inc_irq_stat(apic_perf_irqs);
+
+	percpu_write(kvm_nmi_entered, 0);
+
+	return handled;
+}
+
+static int __kprobes
+kvm_perf_event_nmi_handler(struct notifier_block *self,
+			 unsigned long cmd, void *__args)
+{
+	struct die_args *args = __args;
+	struct pt_regs *regs;
+
+	if (!atomic_read(&active_events))
+		return NOTIFY_DONE;
+
+	switch (cmd) {
+	case DIE_NMI:
+	case DIE_NMI_IPI:
+		break;
+
+	default:
+		return NOTIFY_DONE;
+	}
+
+	regs = args->regs;
+
+	kvm_x86_pmu_handle_irq(regs);
+
+	return NOTIFY_STOP;
+}
+
+static __read_mostly struct notifier_block kvm_perf_event_nmi_notifier = {
+	.notifier_call		= kvm_perf_event_nmi_handler,
+	.next			= NULL,
+	.priority		= 1
+};
+
+static int kvm_add_event(struct perf_event *event)
+{
+	int i, max_count;
+	unsigned long flags;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int ret = -1;
+
+	local_irq_save(flags);
+	max_count = X86_PMC_IDX_MAX;
+
+	if (cpuc->n_events >= max_count) {
+		local_irq_restore(flags);
+		return -ENOSPC;
+	}
+	for (i = 0; i < max_count; i++) {
+		if (cpuc->event_list[i] == NULL) {
+			cpuc->event_list[i] = event;
+			cpuc->n_events++;
+			ret = 0;
+			break;
+		}
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int kvm_del_event(struct perf_event *event)
+{
+	int i, max_count;
+	unsigned long flags;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	int ret = -1;
+
+	local_irq_save(flags);
+	max_count = X86_PMC_IDX_MAX;
+	for (i = 0; i < max_count; i++) {
+		if (cpuc->event_list[i] == event) {
+			cpuc->event_list[i] = NULL;
+			cpuc->n_events--;
+			ret = 0;
+			break;
+		}
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+static int kvm_pmu_enable(struct perf_event *event)
+{
+	int ret;
+	struct guest_perf_shadow *shadow = event->guest_perf_shadow;
+
+	if (kvm_add_event(event))
+		return -1;
+
+	ret = kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_ENABLE, shadow->id);
+	return ret;
+}
+
+static void kvm_pmu_disable(struct perf_event *event)
+{
+	struct guest_perf_shadow *shadow = event->guest_perf_shadow;
+	kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_DISABLE, shadow->id);
+	local64_set(&event->count, shadow->counter.count);
+	kvm_del_event(event);
+}
+
+static void kvm_pmu_read(struct perf_event *event)
+{
+	int ret;
+	struct guest_perf_shadow *shadow = event->guest_perf_shadow;
+	ret = kvm_hypercall2(KVM_PERF_OP, KVM_PERF_OP_READ, shadow->id);
+	if (!ret)
+		local64_set(&event->count, shadow->counter.count);
+	return;
+}
+
+static void kvm_pmu_unthrottle(struct perf_event *event)
+{
+	return;
+}
+
+static const struct pmu kvm_pmu = {
+	.enable		= kvm_pmu_enable,
+	.disable	= kvm_pmu_disable,
+	.start		= kvm_pmu_enable,
+	.stop		= kvm_pmu_disable,
+	.read		= kvm_pmu_read,
+	.unthrottle	= kvm_pmu_unthrottle,
+};
+
+static int kvm_default_x86_handle_irq(struct pt_regs *regs)
+{
+	return 1;
+}
+
+int __init kvm_init_hw_perf_events(void)
+{
+	if (!kvm_para_available())
+		return -1;
+
+	x86_pmu.handle_irq = kvm_default_x86_handle_irq;
+
+	pr_cont("KVM PARA PMU driver.\n");
+	register_die_notifier(&kvm_perf_event_nmi_notifier);
+
+	return 0;
+}
+
+static __u64 kvm_get_pte_phys(void *virt_addr)
+{
+	__u64 pte_phys;
+
+#ifdef CONFIG_HIGHPTE
+	struct page *page;
+	unsigned long dst = (unsigned long) virt_addr;
+
+	page = kmap_atomic_to_page(virt_addr);
+	pte_phys = page_to_pfn(page);
+	pte_phys <<= PAGE_SHIFT;
+	pte_phys += (dst & ~(PAGE_MASK));
+#else
+	pte_phys = (unsigned long)__pa(virt_addr);
+#endif
+	return pte_phys;
+}
+
+static int __kvm_hw_perf_event_init(struct perf_event *event)
+{
+	int err;
+	unsigned long result;
+	__u64 param_addr;
+	struct guest_perf_shadow *shadow = NULL;
+	struct guest_perf_event_param guest_param;
+	struct guest_perf_attr *attr = NULL;
+
+	err = 0;
+
+	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
+	if (!attr) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
+	if (!shadow) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	shadow->id = get_new_perf_event_id();
+	event->guest_perf_shadow = shadow;
+
+	if (!atomic_inc_not_zero(&active_events)) {
+		mutex_lock(&pmc_reserve_mutex);
+		if (atomic_read(&active_events) == 0) {
+			if (!kvm_reserve_pmc_hardware())
+				err = -EBUSY;
+		}
+		if (!err)
+			atomic_inc(&active_events);
+		mutex_unlock(&pmc_reserve_mutex);
+		if (err)
+			goto out;
+	}
+
+	event->destroy = kvm_hw_perf_event_destroy;
+	attr->type = event->attr.type;
+	attr->config = event->attr.config;
+	attr->sample_period = event->attr.sample_period;
+	attr->read_format = event->attr.read_format;
+	attr->flags = event->attr.flags;
+	attr->bp_type = event->attr.bp_type;
+	attr->bp_addr = event->attr.bp_addr;
+	attr->bp_len = event->attr.bp_len;
+
+	guest_param.id = shadow->id;
+	guest_param.attr_addr = kvm_get_pte_phys(attr);
+	guest_param.guest_event_addr = kvm_get_pte_phys(&shadow->counter);
+	param_addr = kvm_get_pte_phys(&guest_param);
+	result = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN,
+			(unsigned long) param_addr, param_addr >> 32);
+
+	if (result)
+		err = result;
+
+out:
+	if (err && shadow) {
+		kfree(shadow);
+		event->guest_perf_shadow = NULL;
+	}
+	kfree(attr);
+
+	return err;
+}
+
+const struct pmu *kvm_hw_perf_event_init(struct perf_event *event)
+{
+	int err;
+
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_PERF))
+		return ERR_PTR(-ENOSYS);
+
+	err = __kvm_hw_perf_event_init(event);
+	if (err)
+		return ERR_PTR(err);
+
+	return &kvm_pmu;
+}
+
+static int kvm_hw_perf_enable(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!kvm_para_available())
+		return -1;
+
+	if (cpuc->enabled)
+		return 0;
+
+	if (cpuc->n_added)
+		cpuc->n_added = 0;
+
+	cpuc->enabled = 1;
+	barrier();
+
+	return 0;
+}
+
+static int kvm_hw_perf_disable(void)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+
+	if (!kvm_para_available())
+		return -1;
+
+	if (!cpuc->enabled)
+		return 0;
+
+	cpuc->n_added = 0;
+	cpuc->enabled = 0;
+	barrier();
+
+	return 0;
+}
+
+#endif
+
--- linux-2.6_tip0620/Documentation/kvm/cpuid.txt	2010-06-21 15:19:26.199999849 +0800
+++ linux-2.6_tip0620perfkvm/Documentation/kvm/cpuid.txt	2010-06-21 15:21:39.312999849 +0800
@@ -36,6 +36,9 @@ KVM_FEATURE_MMU_OP                 ||   
 KVM_FEATURE_CLOCKSOURCE2           ||     3 || kvmclock available at msrs
                                    ||       || 0x4b564d00 and 0x4b564d01
 ------------------------------------------------------------------------------
+KVM_FEATURE_PV_PERF                ||     4 || kvm paravirt perf event
+                                   ||       || available
+------------------------------------------------------------------------------
 KVM_FEATURE_CLOCKSOURCE_STABLE_BIT ||    24 || host will warn if no guest-side
                                    ||       || per-cpu warps are expected in
                                    ||       || kvmclock.


