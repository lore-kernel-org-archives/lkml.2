Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1EKQIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:08:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab1EKPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:55:45 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH v1 5/5] KVM: Expose a version 1 architectural PMU to guests
Date: Wed, 11 May 2011 11:55:33 -0400
Message-Id: <1305129333-7456-6-git-send-email-avi@redhat.com>
In-Reply-To: <1305129333-7456-1-git-send-email-avi@redhat.com>
References: <1305129333-7456-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use perf_events to emulate an architectural PMU, version 1.

Caveats:
- counters that have PMI (interrupt) enabled stop counting after the
  interrupt is signalled.  This is because we need one-shot samples
  that keep counting, which perf doesn't support yet
- some combinations of INV and CMASK are not supported
- counters keep on counting in the host as well as the guest

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |   29 +++++
 arch/x86/kvm/Makefile           |    2 +-
 arch/x86/kvm/pmu.c              |  248 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c              |   16 ++--
 4 files changed, 286 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/kvm/pmu.c

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d2ac8e2..5563fb4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/tracepoint.h>
 #include <linux/cpumask.h>
+#include <linux/irq_work.h>
 
 #include <linux/kvm.h>
 #include <linux/kvm_para.h>
@@ -291,6 +292,24 @@ struct kvm_mmu {
 	u64 pdptrs[4]; /* pae */
 };
 
+#define KVM_PMU_MAX_GENERAL_PURPOSE_COUNTERS 4
+
+struct kvm_pmc {
+	u64 counter;
+	u64 eventsel;
+	struct perf_event *perf_event;
+	struct kvm_vcpu *vcpu;
+};
+
+struct kvm_pmu {
+	unsigned nr_arch_gp_counters;
+	unsigned available_event_types;
+	u64 counter_bitmask;
+	u8 version;
+	struct kvm_pmc gp_counters[KVM_PMU_MAX_GENERAL_PURPOSE_COUNTERS];
+	struct irq_work irq_work;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -419,6 +438,8 @@ struct kvm_vcpu_arch {
 	u64 mcg_ctl;
 	u64 *mce_banks;
 
+	struct kvm_pmu pmu;
+
 	/* used for guest single stepping over the given code position */
 	unsigned long singlestep_rip;
 
@@ -870,4 +891,12 @@ extern bool kvm_find_async_pf_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 void kvm_complete_insn_gp(struct kvm_vcpu *vcpu, int err);
 
+void kvm_pmu_init(struct kvm_vcpu *vcpu);
+void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
+void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu);
+bool kvm_pmu_msr(struct kvm_vcpu *vcpu, u32 msr);
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
+int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data);
+int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index f15501f..cfca03f 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -12,7 +12,7 @@ kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(addprefix ../../../virt/kvm/, async_pf.o)
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
-			   i8254.o timer.o
+			   i8254.o timer.o pmu.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
new file mode 100644
index 0000000..fb36d35
--- /dev/null
+++ b/arch/x86/kvm/pmu.c
@@ -0,0 +1,248 @@
+/*
+ * Kernel-based Virtual Machine -- Performane Monitoring Unit support
+ *
+ * Copyright 2011 Red Hat, Inc. and/or its affiliates.
+ *
+ * Authors:
+ *   Avi Kivity   <avi@redhat.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/kvm_host.h>
+#include <linux/perf_event.h>
+#include "x86.h"
+#include "pmu.h"
+#include "lapic.h"
+
+static struct kvm_arch_event_perf_mapping {
+	u8 eventsel;
+	u8 unit_mask;
+	unsigned event_type;
+	bool inexact;
+} arch_events[] = {
+	/* Index must match CPUID 0x0A.EBX bit vector */
+	[0] = { 0x3c, 0x00, PERF_COUNT_HW_CPU_CYCLES },
+	[1] = { 0xc0, 0x00, PERF_COUNT_HW_INSTRUCTIONS },
+	[2] = { 0x3c, 0x01, PERF_COUNT_HW_BUS_CYCLES  },
+	[3] = { 0x2e, 0x4f, PERF_COUNT_HW_CACHE_REFERENCES },
+	[4] = { 0x2e, 0x41, PERF_COUNT_HW_CACHE_MISSES },
+	[5] = { 0xc4, 0x00, PERF_COUNT_HW_BRANCH_INSTRUCTIONS },
+	[6] = { 0xc5, 0x00, PERF_COUNT_HW_BRANCH_MISSES },
+};
+
+static inline struct kvm_pmc *get_gp_pmc(struct kvm_pmu *pmu, u32 msr,
+					 u32 base)
+{
+	if (msr >= base && msr < base + pmu->nr_arch_gp_counters)
+		return &pmu->gp_counters[msr - base];
+	return NULL;
+}
+
+static void __kvm_perf_overflow(struct irq_work *irq_work)
+{
+	struct kvm_pmu *pmu = container_of(irq_work, struct kvm_pmu, irq_work);
+	struct kvm_vcpu *vcpu = container_of(pmu, struct kvm_vcpu, arch.pmu);
+
+	if (vcpu->arch.apic)
+		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTPC);
+}
+
+static void kvm_perf_overflow(void *_pmc, struct perf_event *perf_event,
+			      int nmi,
+			      struct perf_sample_data *data,
+			      struct pt_regs *regs)
+{
+	struct kvm_pmc *pmc = _pmc;
+
+	irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
+}
+
+static u64 read_gp_pmc(struct kvm_pmu *pmu, struct kvm_pmc *pmc)
+{
+	u64 counter, enabled, running;
+
+	counter = pmc->counter;
+
+	if (pmc->perf_event)
+		counter += perf_event_read_value(pmc->perf_event,
+						 &enabled, &running);
+
+	/* FIXME: Scaling needed? */
+
+	return counter & pmu->counter_bitmask;
+}
+
+static int reprogram_gp_counter(struct kvm_pmu *pmu, struct kvm_pmc *pmc,
+				u64 eventsel)
+{
+	struct perf_event_attr attr = { };
+	struct perf_event *event;
+	int i;
+	u8 event_select, unit_mask, cmask;
+	perf_overflow_handler_t callback = NULL;
+	bool inv;
+
+	if (pmc->perf_event) {
+		pmc->counter = read_gp_pmc(pmu, pmc);
+		perf_event_release_kernel(pmc->perf_event);
+		pmc->perf_event = NULL;
+		irq_work_sync(&pmu->irq_work);
+		pmc->eventsel = eventsel;
+	}
+
+	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE))
+		return 0;
+
+	attr.type = PERF_TYPE_HARDWARE;
+	attr.size = sizeof(attr);
+	attr.exclude_idle = true;
+
+	event_select = eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
+	unit_mask = (eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
+
+	for (i = 0; i < ARRAY_SIZE(arch_events); ++i) {
+		if (arch_events[i].eventsel == event_select
+		    && arch_events[i].unit_mask == unit_mask
+		    && (pmu->available_event_types & (1 << i))) {
+			attr.config = arch_events[i].event_type;
+			break;
+		}
+	}
+	if (i == ARRAY_SIZE(arch_events))
+		return 1;
+
+	attr.exclude_user = !(eventsel & ARCH_PERFMON_EVENTSEL_USR);
+	attr.exclude_kernel = !(eventsel & ARCH_PERFMON_EVENTSEL_OS);
+
+	if (eventsel & ARCH_PERFMON_EVENTSEL_EDGE)
+		printk_once("kvm: pmu ignoring edge bit\n");
+
+	if (eventsel & ARCH_PERFMON_EVENTSEL_INT) {
+		callback = kvm_perf_overflow;
+		attr.disabled = true;
+	}
+
+	inv = eventsel & ARCH_PERFMON_EVENTSEL_INV;
+	cmask = (eventsel & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
+
+	pmc->eventsel = eventsel;
+
+	if (inv || cmask > 1) {
+		printk_once("kvm: pmu ignoring difficult inv/cmask combo\n");
+		return 0;
+	}
+
+	attr.sample_period = (-pmc->counter) & pmu->counter_bitmask;
+
+	event = perf_event_create_kernel_counter(&attr, -1, current,
+						 callback, pmc);
+	if (IS_ERR(event))
+		return PTR_ERR(event);
+
+	if (callback)
+		perf_event_refresh(event, 1);
+
+	pmc->perf_event = event;
+	return 0;
+}
+
+bool kvm_pmu_msr(struct kvm_vcpu *vcpu, u32 msr)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	return get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)
+		|| get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0);
+}
+
+int kvm_pmu_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0))) {
+		*data = read_gp_pmc(pmu, pmc);
+		return 0;
+	} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
+		*data = pmc->eventsel;
+		return 0;
+	}
+	return 1;
+}
+
+int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if ((pmc = get_gp_pmc(pmu, index, MSR_IA32_PERFCTR0))) {
+		data = (s64)(s32)data;
+		pmc->counter += data - read_gp_pmc(pmu, pmc);
+		return 0;
+	} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
+		if (data == pmc->eventsel)
+			return 0;
+		if (data & 0xffffffff00200000ULL)
+			return 1;
+		return reprogram_gp_counter(pmu, pmc, data);
+	}
+	return 1;
+}
+
+int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	if (pmc >= pmu->nr_arch_gp_counters)
+		return 1;
+	*data = read_gp_pmc(pmu, &pmu->gp_counters[pmc]);
+	return 0;
+}
+
+void kvm_pmu_cpuid_update(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_cpuid_entry2 *entry;
+	unsigned bitmap_len;
+
+	pmu->nr_arch_gp_counters = 0;
+	pmu->version = 0;
+	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
+	if (!entry)
+		return;
+	pmu->version = entry->eax & 0xff;
+	pmu->nr_arch_gp_counters = min((int)(entry->eax >> 8) & 0xff,
+				       KVM_PMU_MAX_GENERAL_PURPOSE_COUNTERS);
+	pmu->counter_bitmask = ((u64)1 << ((entry->eax >> 16) & 0xff)) - 1;
+	bitmap_len = (entry->eax >> 24) & 0xff;
+	pmu->available_event_types = ~entry->ebx & ((1ULL << bitmap_len) - 1);
+}
+
+void kvm_pmu_init(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	memset(pmu, 0, sizeof(*pmu));
+	for (i = 0; i < KVM_PMU_MAX_GENERAL_PURPOSE_COUNTERS; ++i)
+		pmu->gp_counters[i].vcpu = vcpu;
+	init_irq_work(&pmu->irq_work, __kvm_perf_overflow);
+	kvm_pmu_cpuid_update(vcpu);
+}
+
+void kvm_pmu_destroy(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	int i;
+
+	irq_work_sync(&pmu->irq_work);
+	for (i = 0; i < KVM_PMU_MAX_GENERAL_PURPOSE_COUNTERS; ++i) {
+		pmc = &pmu->gp_counters[i];
+		if (pmc->perf_event)
+			perf_event_release_kernel(pmc->perf_event);
+	}
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77c9d867..b3c609e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -593,6 +593,8 @@ static void update_cpuid(struct kvm_vcpu *vcpu)
 		if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE))
 			best->ecx |= bit(X86_FEATURE_OSXSAVE);
 	}
+
+	kvm_pmu_cpuid_update(vcpu);
 }
 
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
@@ -1561,8 +1563,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	 * which we perfectly emulate ;-). Any other value should be at least
 	 * reported, some guests depend on them.
 	 */
-	case MSR_P6_EVNTSEL0:
-	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
 	case MSR_K7_EVNTSEL1:
 	case MSR_K7_EVNTSEL2:
@@ -1574,8 +1574,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	/* at least RHEL 4 unconditionally writes to the perfctr registers,
 	 * so we ignore writes to make it happy.
 	 */
-	case MSR_P6_PERFCTR0:
-	case MSR_P6_PERFCTR1:
 	case MSR_K7_PERFCTR0:
 	case MSR_K7_PERFCTR1:
 	case MSR_K7_PERFCTR2:
@@ -1612,6 +1610,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 	default:
 		if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
 			return xen_hvm_config(vcpu, data);
+		if (kvm_pmu_msr(vcpu, msr))
+			return kvm_pmu_set_msr(vcpu, msr, data);
 		if (!ignore_msrs) {
 			pr_unimpl(vcpu, "unhandled wrmsr: 0x%x data %llx\n",
 				msr, data);
@@ -1772,10 +1772,6 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 	case MSR_K8_SYSCFG:
 	case MSR_K7_HWCR:
 	case MSR_VM_HSAVE_PA:
-	case MSR_P6_PERFCTR0:
-	case MSR_P6_PERFCTR1:
-	case MSR_P6_EVNTSEL0:
-	case MSR_P6_EVNTSEL1:
 	case MSR_K7_EVNTSEL0:
 	case MSR_K7_PERFCTR0:
 	case MSR_K8_INT_PENDING_MSG:
@@ -1877,6 +1873,8 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
 		data = 0xbe702111;
 		break;
 	default:
+		if (kvm_pmu_msr(vcpu, msr))
+			return kvm_pmu_get_msr(vcpu, msr, pdata);
 		if (!ignore_msrs) {
 			pr_unimpl(vcpu, "unhandled rdmsr: 0x%x\n", msr);
 			return 1;
@@ -6221,6 +6219,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 		goto fail_free_mce_banks;
 
 	kvm_async_pf_hash_reset(vcpu);
+	kvm_pmu_init(vcpu);
 
 	return 0;
 fail_free_mce_banks:
@@ -6239,6 +6238,7 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	int idx;
 
+	kvm_pmu_destroy(vcpu);
 	kfree(vcpu->arch.mce_banks);
 	kvm_free_lapic(vcpu);
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-- 
1.7.4.3

