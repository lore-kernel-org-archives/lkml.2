Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0FID2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 23:28:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:49354 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0FID2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 23:28:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,387,1272870000"; 
   d="scan'208";a="628744875"
Subject: [RFC] para virt interface of perf to support kvm guest os
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
Date: Wed, 09 Jun 2010 11:30:14 +0800
Message-Id: <1276054214.2096.383.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

Based on Ingo's idea, I implement a para virt interface for perf to support
statistics collection in guest os. That means we could run tool perf in guest
os directly.

Great thanks to Peter Zijlstra. He is really the architect and gave me architecture
design suggestions. I also want to thank Yangsheng and LinMing for their generous
help.

The design is:

1) Add a kvm_pmu whose callbacks mostly just calls hypercall to vmexit to host kernel;
2) Create a host perf_event per guest perf_event;
3) Host kernel syncs perf_event count/overflows data changes to guest perf_event
when processing perf_event overflows after NMI arrives. Host kernel inject NMI to guest
kernel if a guest event overflows.
4) Guest kernel goes through all enabled event on current cpu and output data when they
overflows.
5) No change in user space.

Below is an example.

#perf top
--------------------------------------------------------------------------------------------------------------------------
   PerfTop:    7954 irqs/sec  kernel:79.5%  exact:  0.0% [1000Hz cycles],  (all, 8 CPUs)
--------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function                 DSO
             _______ _____ ________________________ _________________________________________________________

             5315.00  4.9% copy_user_generic_string /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             3342.00  3.1% add_preempt_count        /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             3338.00  3.1% sub_preempt_count        /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2454.00  2.3% pvclock_clocksource_read /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2434.00  2.3% tcp_sendmsg              /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2090.00  1.9% child_run                /bm/tmp/benchmarks/run_bmtbench/dbench/dbench-3.03/tbench
             2081.00  1.9% debug_smp_processor_id   /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             2003.00  1.9% __GI_strstr              /lib64/libc-2.11.so                                      
             1999.00  1.9% __strchr_sse2            /lib64/libc-2.11.so                                      
             1983.00  1.8% tcp_ack                  /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1800.00  1.7% tcp_transmit_skb         /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1727.00  1.6% schedule                 /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      
             1706.00  1.6% __libc_recv              /lib64/libc-2.11.so                                      
             1702.00  1.6% __GI_memchr              /lib64/libc-2.11.so                                      
             1580.00  1.5% tcp_recvmsg              /lib/modules/2.6.35-rc1-tip-guestperf/build/vmlinux      

The patch is against tip/master tree of June 1st.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0601/arch/x86/include/asm/kvm_host.h linux-2.6_tip0601perfkvm/arch/x86/include/asm/kvm_host.h
--- linux-2.6_tip0601/arch/x86/include/asm/kvm_host.h	2010-06-02 10:01:52.147999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/include/asm/kvm_host.h	2010-06-06 15:46:31.874999850 +0800
@@ -561,6 +561,9 @@ int emulator_write_phys(struct kvm_vcpu 
 			  const void *val, int bytes);
 int kvm_pv_mmu_op(struct kvm_vcpu *vcpu, unsigned long bytes,
 		  gpa_t addr, unsigned long *ret);
+int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
+		   unsigned long a2, unsigned long *result);
+
 u8 kvm_get_guest_memory_type(struct kvm_vcpu *vcpu, gfn_t gfn);
 
 extern bool tdp_enabled;
diff -Nraup linux-2.6_tip0601/arch/x86/include/asm/kvm_para.h linux-2.6_tip0601perfkvm/arch/x86/include/asm/kvm_para.h
--- linux-2.6_tip0601/arch/x86/include/asm/kvm_para.h	2010-06-02 10:01:52.126999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/include/asm/kvm_para.h	2010-06-06 15:46:31.874999850 +0800
@@ -33,7 +33,14 @@
 #define MSR_KVM_WALL_CLOCK_NEW  0x4b564d00
 #define MSR_KVM_SYSTEM_TIME_NEW 0x4b564d01
 
-#define KVM_MAX_MMU_OP_BATCH           32
+/* Operations for KVM_PERF_OP */
+#define KVM_PERF_OP_OPEN		1
+#define KVM_PERF_OP_CLOSE		2
+#define KVM_PERF_OP_ENABLE		3
+#define KVM_PERF_OP_DISABLE		4
+#define KVM_PERF_OP_START		5
+#define KVM_PERF_OP_STOP		6
+#define KVM_PERF_OP_READ		7
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
@@ -64,6 +71,12 @@ struct kvm_mmu_op_release_pt {
 #ifdef __KERNEL__
 #include <asm/processor.h>
 
+struct kvmperf_event {
+	unsigned int event_offset;
+	struct page *event_page;
+	struct page *event_page2;
+};
+
 extern void kvmclock_init(void);
 
 
diff -Nraup linux-2.6_tip0601/arch/x86/Kconfig linux-2.6_tip0601perfkvm/arch/x86/Kconfig
--- linux-2.6_tip0601/arch/x86/Kconfig	2010-06-02 10:01:52.364999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/Kconfig	2010-06-06 15:46:31.875999850 +0800
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
diff -Nraup linux-2.6_tip0601/arch/x86/kernel/cpu/perf_event.c linux-2.6_tip0601perfkvm/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6_tip0601/arch/x86/kernel/cpu/perf_event.c	2010-06-02 10:01:53.252999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-06-06 15:46:31.875999850 +0800
@@ -25,6 +25,7 @@
 #include <linux/highmem.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
+#include <linux/kvm_para.h>
 
 #include <asm/apic.h>
 #include <asm/stacktrace.h>
@@ -582,10 +583,20 @@ static void x86_pmu_disable_all(void)
 	}
 }
 
+#ifdef CONFIG_KVM_PERF
+extern int kvm_hw_perf_enable(void);
+extern int kvm_hw_perf_disable(void);
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
 
@@ -809,6 +820,11 @@ void hw_perf_enable(void)
 	struct hw_perf_event *hwc;
 	int i, added = cpuc->n_added;
 
+#ifdef CONFIG_KVM_PERF
+	if (!kvm_hw_perf_enable())
+		return;
+#endif
+
 	if (!x86_pmu_initialized())
 		return;
 
@@ -1254,6 +1270,7 @@ x86_get_event_constraints(struct cpu_hw_
 #include "perf_event_intel_lbr.c"
 #include "perf_event_intel_ds.c"
 #include "perf_event_intel.c"
+#include "perf_event_kvm.c"
 
 static int __cpuinit
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
@@ -1307,6 +1324,11 @@ void __init init_hw_perf_events(void)
 
 	pr_info("Performance Events: ");
 
+#ifdef CONFIG_KVM_PERF
+	if (!kvm_init_hw_perf_events())
+		return;
+#endif
+
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_INTEL:
 		err = intel_pmu_init();
@@ -1535,6 +1557,13 @@ const struct pmu *hw_perf_event_init(str
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
diff -Nraup linux-2.6_tip0601/arch/x86/kernel/cpu/perf_event_kvm.c linux-2.6_tip0601perfkvm/arch/x86/kernel/cpu/perf_event_kvm.c
--- linux-2.6_tip0601/arch/x86/kernel/cpu/perf_event_kvm.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kernel/cpu/perf_event_kvm.c	2010-06-06 15:46:31.876999850 +0800
@@ -0,0 +1,367 @@
+/*
+ * Performance events 
+ *
+ *  Copyright (C) 2010 Intel Corporation, Zhang Yanmin <yanmin.zhang@intel.com>
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#ifdef CONFIG_KVM_PERF
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
+	unsigned long addr;
+
+	addr = __pa(event);
+	kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_CLOSE,
+		addr, (unsigned long) event->shadow);
+
+	if (atomic_dec_and_mutex_lock(&active_events, &pmc_reserve_mutex)) {
+		kvm_release_pmc_hardware();
+		mutex_unlock(&pmc_reserve_mutex);
+	}
+}
+
+static int
+check_event_overflow(struct perf_event *event, struct pt_regs *regs)
+{
+	struct perf_sample_data data;
+	struct hw_perf_event *hwc = &event->hw;
+	s32 overflows;
+	int i;
+	int handled = 0;
+
+again:
+	overflows = atomic_read(&hwc->overflows);
+	if (atomic_cmpxchg(&hwc->overflows, overflows, 0) !=
+			overflows)
+		goto again;
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
+	unsigned long addr = __pa(event);
+
+	if (kvm_add_event(event))
+		return -1;
+
+	ret = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_ENABLE,
+	 		addr, (unsigned long) event->shadow);
+	return ret;
+}
+
+static void kvm_pmu_disable(struct perf_event *event)
+{
+	unsigned long addr = __pa(event);
+	kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_DISABLE,
+		addr, (unsigned long) event->shadow);
+	kvm_del_event(event);
+}
+
+static int kvm_pmu_start(struct perf_event *event)
+{
+	int ret;
+	unsigned long addr = __pa(event);
+
+	if (kvm_add_event(event))
+		return -1;
+
+	ret = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_START,
+			addr, (unsigned long) event->shadow);
+	return ret;
+}
+
+static void kvm_pmu_stop(struct perf_event *event)
+{
+	unsigned long addr = __pa(event);
+	kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_STOP,
+		addr, (unsigned long) event->shadow);
+	kvm_del_event(event);
+}
+
+static void kvm_pmu_read(struct perf_event *event)
+{
+	unsigned long addr;
+
+	addr = __pa(event);
+
+	kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_READ,
+			addr, (unsigned long) event->shadow);
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
+	.start		= kvm_pmu_start,
+	.stop		= kvm_pmu_stop,
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
+static int __kvm_hw_perf_event_init(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	int err;
+	unsigned long result;
+	unsigned long addr;
+
+	err = 0;
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
+			return err;
+	}
+
+	event->destroy = kvm_hw_perf_event_destroy;
+
+	hwc->idx = -1;
+	hwc->last_cpu = -1;
+	hwc->last_tag = ~0ULL;
+
+	addr = __pa(event);
+	result = kvm_hypercall3(KVM_PERF_OP, KVM_PERF_OP_OPEN, addr, 0);
+
+	if (result)
+		event->shadow = (void *) result;
+	else
+		err = -1;
+
+	return err;
+}
+
+const struct pmu *kvm_hw_perf_event_init(struct perf_event *event)
+{
+	int err;
+
+	err = __kvm_hw_perf_event_init(event);
+	if (err)
+		return ERR_PTR(err);
+
+	return &kvm_pmu;
+}
+
+int kvm_hw_perf_enable(void)
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
+int kvm_hw_perf_disable(void)
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
diff -Nraup linux-2.6_tip0601/arch/x86/kvm/kvmperf_event.c linux-2.6_tip0601perfkvm/arch/x86/kvm/kvmperf_event.c
--- linux-2.6_tip0601/arch/x86/kvm/kvmperf_event.c	1970-01-01 08:00:00.000000000 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kvm/kvmperf_event.c	2010-06-06 16:36:32.714999849 +0800
@@ -0,0 +1,276 @@
+/*
+ * Performance events x86 kvm para architecture code
+ *
+ *  Copyright (C) 2010 Intel Inc.
+ *  		Zhang Yanmin <yanmin.zhang@intel.com>
+ *
+ *  For licencing details see kernel-base/COPYING
+ */
+
+#include <linux/perf_event.h>
+#include <linux/capability.h>
+#include <linux/notifier.h>
+#include <linux/hardirq.h>
+#include <linux/kprobes.h>
+#include <linux/module.h>
+#include <linux/kdebug.h>
+#include <linux/sched.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/highmem.h>
+#include <linux/cpu.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/file.h>
+#include <linux/syscalls.h>
+#include <linux/init.h>
+
+#include <asm/apic.h>
+#include <asm/stacktrace.h>
+#include <asm/nmi.h>
+#include <asm/compat.h>
+
+#include "x86.h"
+
+static void kvm_sync_event_to_guest(struct perf_event *event, int overflows)
+{
+	struct hw_perf_event *hwc = &event->hw;
+	struct kvmperf_event *kvmevent;
+	int offset, len, data_len, copied, page_offset;
+	struct page *event_page;
+	void *shared_kaddr;
+
+	kvmevent = event->shadow;
+	offset = kvmevent->event_offset;
+
+	/* Copy perf_event->count firstly */
+	offset += offsetof(struct perf_event, count);
+	if (offset < PAGE_SIZE) {
+		event_page = kvmevent->event_page;
+		page_offset = offset;
+	} else {
+		event_page = kvmevent->event_page2;
+		page_offset = offset - PAGE_SIZE;
+	}
+	shared_kaddr = kmap_atomic(event_page, KM_USER0);
+	*((atomic64_t *)(shared_kaddr + page_offset)) = event->count;
+
+	offset = kvmevent->event_offset;
+	offset += offsetof(struct perf_event, hw);
+	if (offset < PAGE_SIZE) {
+		if (event_page == kvmevent->event_page2) {
+			kunmap_atomic(shared_kaddr, KM_USER0);
+			event_page = kvmevent->event_page;
+			shared_kaddr = kmap_atomic(event_page, KM_USER0);
+		}
+		page_offset = offset;
+	} else {
+		if (event_page == kvmevent->event_page) {
+			kunmap_atomic(shared_kaddr, KM_USER0);
+			event_page = kvmevent->event_page2;
+			shared_kaddr = kmap_atomic(event_page, KM_USER0);
+		}
+		page_offset = offset - PAGE_SIZE;
+	}
+
+	if (overflows)
+		atomic_add(overflows, (atomic_t *)(shared_kaddr + page_offset));
+
+	kunmap_atomic(shared_kaddr, KM_USER0);
+#if 0
+	offset += offsetof(struct hw_perf_event, prev_count);
+	data_len = sizeof(struct hw_perf_event) -
+		offsetof(struct hw_perf_event, prev_count);
+	if (event_page == kvmevent->event_page2) {
+		page_offset += offsetof(struct hw_perf_event, prev_count);
+		memcpy(shared_kaddr + page_offset,
+				&hwc->prev_count, data_len);
+		kunmap_atomic(shared_kaddr, KM_USER0);
+
+		return;
+	}
+
+	copied = 0;
+	if (offset < PAGE_SIZE) {
+		len = PAGE_SIZE - offset;
+		if (len > data_len)
+			len = data_len;
+		memcpy(shared_kaddr + offset,
+				&hwc->prev_count, data_len);
+		copied = len;
+		page_offset = 0;
+	} else
+		page_offset = offset - PAGE_SIZE;
+
+	kunmap_atomic(shared_kaddr, KM_USER0);
+	len = data_len - copied;
+	if (len) {
+		/* Copy across pages */
+		shared_kaddr = kmap_atomic(kvmevent->event_page2, KM_USER0);
+		memcpy(shared_kaddr + page_offset,
+				((void *)&hwc->prev_count) + copied, len);
+		kunmap_atomic(shared_kaddr, KM_USER0);
+	}
+#endif
+}
+
+static void kvm_perf_event_overflow(struct perf_event *event, int nmi,
+		struct perf_sample_data *data,
+		struct pt_regs *regs)
+{
+	BUG_ON(event->shadow == NULL);
+	kvm_sync_event_to_guest(event, 1);
+
+	kvm_notify_event_overflow();
+}
+
+static struct perf_event *
+kvm_pv_perf_op_open(struct kvm_vcpu *vcpu, gpa_t addr)
+{
+	int ret;
+	struct perf_event *event;
+	struct perf_event *host_event = NULL;
+	struct kvmperf_event *shadow = NULL;
+
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
+	if (!event)
+		goto out;
+
+	shadow = kzalloc(sizeof(*shadow), GFP_KERNEL);
+	if (!shadow)
+		goto out;
+
+	shadow->event_page = gfn_to_page(vcpu->kvm, addr >> PAGE_SHIFT);
+	shadow->event_offset = addr & ~PAGE_MASK;
+	if (shadow->event_offset + sizeof(struct perf_event) > PAGE_SIZE) {
+		shadow->event_page2 = gfn_to_page(vcpu->kvm,
+					(addr >> PAGE_SHIFT) + 1);
+	}
+
+	ret = kvm_read_guest(vcpu->kvm, addr, event, sizeof(*event));
+	if (ret)
+		goto out;
+
+	/*
+	 * By default, we disable the host event. Later on, guets os
+	 * triggers a perf_event_attach to enable it
+	 */
+	event->attr.disabled = 1;
+	event->attr.inherit = 0;
+	event->attr.enable_on_exec = 0;
+	/*
+	 * We don't support exclude mode of user and kernel for guest os,
+	 * which mean we always collect both user and kernel for guest os
+	 */
+	event->attr.exclude_user = 0;
+	event->attr.exclude_kernel = 0;
+	/* We always create a cpu context host perf event */
+
+	host_event = perf_event_create_kernel_counter(&event->attr, -1,
+				current->pid, kvm_perf_event_overflow);
+
+	if (IS_ERR(host_event)) {
+		host_event = NULL;
+		goto out;
+	}
+	host_event->shadow = shadow;
+
+out:
+	if (!host_event)
+		kfree(shadow);
+	kfree(event);
+
+	return host_event;
+}
+
+static int kvm_pv_perf_op_close(struct kvm_vcpu *vcpu,
+				struct perf_event *host_event)
+{
+	struct kvmperf_event *shadow = host_event->shadow;
+
+	perf_event_release_kernel(host_event);
+	put_page(shadow->event_page);
+	if (shadow->event_page2)
+		put_page(shadow->event_page2);
+	kfree(shadow);
+	return 0;
+}
+
+static int kvm_pv_perf_op_enable(struct perf_event *host_event)
+{
+	perf_event_attach(host_event);
+	return 0;
+}
+
+static int kvm_pv_perf_op_disable(struct perf_event *host_event)
+{
+	perf_event_detach(host_event);
+	return 0;
+}
+
+static int kvm_pv_perf_op_start(struct perf_event *host_event)
+{
+	perf_event_attach(host_event);
+	return 0;
+}
+
+static int kvm_pv_perf_op_stop(struct perf_event *host_event)
+{
+	perf_event_detach(host_event);
+	return 0;
+}
+
+static int kvm_pv_perf_op_read(struct perf_event *host_event)
+{
+	u64 enabled, running;
+	if (host_event->state == PERF_EVENT_STATE_ACTIVE)
+		perf_event_read_value(host_event, &enabled, &running);
+	kvm_sync_event_to_guest(host_event, 0);
+	return 0;
+}
+
+int kvm_pv_perf_op(struct kvm_vcpu *vcpu, int op_code, unsigned long a1,
+		unsigned long a2, unsigned long *result)
+{
+	unsigned long ret;
+	struct perf_event *host_event;
+	gpa_t addr;
+
+	addr = (gpa_t)(a1);
+
+	switch(op_code) {
+	case KVM_PERF_OP_OPEN:
+		ret = (unsigned long) kvm_pv_perf_op_open(vcpu, addr);
+		break;
+	case KVM_PERF_OP_CLOSE:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_close(vcpu, host_event);
+		break;
+	case KVM_PERF_OP_ENABLE:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_enable(host_event);
+		break;
+	case KVM_PERF_OP_DISABLE:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_disable(host_event);
+		break;
+	case KVM_PERF_OP_START:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_start(host_event);
+		break;
+	case KVM_PERF_OP_STOP:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_stop(host_event);
+		break;
+	case KVM_PERF_OP_READ:
+		host_event = (struct perf_event *) a2;
+		ret = kvm_pv_perf_op_read(host_event);
+		break;
+	default:
+		ret = -KVM_ENOSYS;
+	}
+
+	*result = ret;
+	return 0;
+}
+
diff -Nraup linux-2.6_tip0601/arch/x86/kvm/Makefile linux-2.6_tip0601perfkvm/arch/x86/kvm/Makefile
--- linux-2.6_tip0601/arch/x86/kvm/Makefile	2010-06-02 10:01:52.563999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kvm/Makefile	2010-06-06 15:46:31.876999850 +0800
@@ -11,7 +11,7 @@ kvm-y			+= $(addprefix ../../../virt/kvm
 kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
 
 kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
-			   i8254.o timer.o
+			   i8254.o timer.o kvmperf_event.o
 kvm-intel-y		+= vmx.o
 kvm-amd-y		+= svm.o
 
diff -Nraup linux-2.6_tip0601/arch/x86/kvm/x86.c linux-2.6_tip0601perfkvm/arch/x86/kvm/x86.c
--- linux-2.6_tip0601/arch/x86/kvm/x86.c	2010-06-02 10:01:52.572999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kvm/x86.c	2010-06-06 16:33:28.977999849 +0800
@@ -6,12 +6,14 @@
  * Copyright (C) 2006 Qumranet, Inc.
  * Copyright (C) 2008 Qumranet, Inc.
  * Copyright IBM Corporation, 2008
+ * Copyright Intel Corporation, 2010
  *
  * Authors:
  *   Avi Kivity   <avi@qumranet.com>
  *   Yaniv Kamay  <yaniv@qumranet.com>
  *   Amit Shah    <amit.shah@qumranet.com>
  *   Ben-Ami Yassour <benami@il.ibm.com>
+ *   Yanmin Zhang <yanmin.zhang@intel.com>
  *
  * This work is licensed under the terms of the GNU GPL, version 2.  See
  * the COPYING file in the top-level directory.
@@ -4052,6 +4054,16 @@ static unsigned long kvm_get_guest_ip(vo
 	return ip;
 }
 
+int kvm_notify_event_overflow(void)
+{
+	if (percpu_read(current_vcpu)) {
+		kvm_inject_nmi(percpu_read(current_vcpu));
+		return 0;
+	}
+
+	return -1;
+}
+
 static struct perf_guest_info_callbacks kvm_guest_cbs = {
 	.is_in_guest		= kvm_is_in_guest,
 	.is_user_mode		= kvm_is_user_mode,
@@ -4245,6 +4257,9 @@ int kvm_emulate_hypercall(struct kvm_vcp
 	case KVM_HC_MMU_OP:
 		r = kvm_pv_mmu_op(vcpu, a0, hc_gpa(vcpu, a1, a2), &ret);
 		break;
+	case KVM_PERF_OP:
+		r = kvm_pv_perf_op(vcpu, a0, a1, a2, &ret);
+		break;
 	default:
 		ret = -KVM_ENOSYS;
 		break;
diff -Nraup linux-2.6_tip0601/arch/x86/kvm/x86.h linux-2.6_tip0601perfkvm/arch/x86/kvm/x86.h
--- linux-2.6_tip0601/arch/x86/kvm/x86.h	2010-06-02 10:01:52.552999849 +0800
+++ linux-2.6_tip0601perfkvm/arch/x86/kvm/x86.h	2010-06-06 16:30:45.918999850 +0800
@@ -74,5 +74,6 @@ static inline struct kvm_mem_aliases *kv
 
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
+int kvm_notify_event_overflow(void);
 
 #endif
diff -Nraup linux-2.6_tip0601/include/linux/kvm_para.h linux-2.6_tip0601perfkvm/include/linux/kvm_para.h
--- linux-2.6_tip0601/include/linux/kvm_para.h	2010-06-02 10:02:08.780999849 +0800
+++ linux-2.6_tip0601perfkvm/include/linux/kvm_para.h	2010-06-06 15:46:31.877999850 +0800
@@ -17,6 +17,7 @@
 
 #define KVM_HC_VAPIC_POLL_IRQ		1
 #define KVM_HC_MMU_OP			2
+#define KVM_PERF_OP			3
 
 /*
  * hypercalls use architecture specific
diff -Nraup linux-2.6_tip0601/include/linux/perf_event.h linux-2.6_tip0601perfkvm/include/linux/perf_event.h
--- linux-2.6_tip0601/include/linux/perf_event.h	2010-06-02 10:02:08.055999849 +0800
+++ linux-2.6_tip0601perfkvm/include/linux/perf_event.h	2010-06-06 16:31:38.542999849 +0800
@@ -534,7 +534,20 @@ struct hw_perf_event {
 		/* breakpoint */
 		struct arch_hw_breakpoint	info;
 #endif
+#ifdef CONFIG_KVM_PERF
+		/*
+		 * host will increase overflows of guest event variable,
+		 * guest kernel checks it and output overflow data
+		 */
+		atomic_t		overflows;
+#endif
 	};
+
+	/*
+	 * CAREFULL: prev_count should be the first member after the
+	 * union. With KVM paravirt support, host side perf_event sync
+	 * function just assumes that.
+	 */
 	atomic64_t			prev_count;
 	u64				sample_period;
 	u64				last_period;
@@ -731,6 +744,14 @@ struct perf_event {
 
 	perf_overflow_handler_t		overflow_handler;
 
+	/*
+	 * pointer to kvm guest/host perf_event peers:
+	 * 1) If in host, shadow points to an area of guest event
+	 * 	page mapping information;
+	 * 2) If in guest, shadow points to it's host peer event;
+	 */
+	void		 		*shadow;
+
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
@@ -849,6 +870,10 @@ perf_event_create_kernel_counter(struct 
 				perf_overflow_handler_t callback);
 extern u64 perf_event_read_value(struct perf_event *event,
 				 u64 *enabled, u64 *running);
+extern void perf_event_output(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs);
+void perf_event_attach(struct perf_event *event);
+void perf_event_detach(struct perf_event *event);
 
 struct perf_sample_data {
 	u64				type;
@@ -1026,6 +1051,14 @@ perf_event_task_sched_in(struct task_str
 static inline void
 perf_event_task_sched_out(struct task_struct *task,
 			    struct task_struct *next)			{ }
+
+static inline void
+perf_event_output(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs)	{ }
+
+static inline void perf_event_attach(struct perf_event *event)		{ }
+static inline void perf_event_detach(struct perf_event *event)		{ }
+
 static inline void
 perf_event_task_tick(struct task_struct *task)				{ }
 static inline int perf_event_init_task(struct task_struct *child)	{ return 0; }
diff -Nraup linux-2.6_tip0601/kernel/perf_event.c linux-2.6_tip0601perfkvm/kernel/perf_event.c
--- linux-2.6_tip0601/kernel/perf_event.c	2010-06-02 10:03:06.809999849 +0800
+++ linux-2.6_tip0601perfkvm/kernel/perf_event.c	2010-06-06 15:57:08.878999851 +0800
@@ -34,6 +34,7 @@
 #include <linux/hw_breakpoint.h>
 
 #include <asm/irq_regs.h>
+#include <asm/kvm_para.h>
 
 /*
  * Each CPU has a list of per CPU events:
@@ -754,6 +755,7 @@ static int group_can_go_on(struct perf_e
 	 */
 	if (event->attr.exclusive && cpuctx->active_oncpu)
 		return 0;
+
 	/*
 	 * Otherwise, try to add it if all previous groups were able
 	 * to go on.
@@ -1617,6 +1619,7 @@ void perf_event_task_tick(struct task_st
 	struct perf_cpu_context *cpuctx;
 	struct perf_event_context *ctx;
 	int rotate = 0;
+	int adjust_freq = 1;
 
 	if (!atomic_read(&nr_events))
 		return;
@@ -1630,9 +1633,16 @@ void perf_event_task_tick(struct task_st
 	if (ctx && ctx->nr_events && ctx->nr_events != ctx->nr_active)
 		rotate = 1;
 
-	perf_ctx_adjust_freq(&cpuctx->ctx);
-	if (ctx)
-		perf_ctx_adjust_freq(ctx);
+#ifdef CONFIG_KVM_PERF
+        if (kvm_para_available())
+                adjust_freq = 0;
+#endif
+
+        if (adjust_freq) {
+		perf_ctx_adjust_freq(&cpuctx->ctx);
+		if (ctx)
+			perf_ctx_adjust_freq(ctx);
+	}
 
 	if (!rotate)
 		return;
@@ -3431,7 +3441,7 @@ void perf_prepare_sample(struct perf_eve
 	}
 }
 
-static void perf_event_output(struct perf_event *event, int nmi,
+void perf_event_output(struct perf_event *event, int nmi,
 				struct perf_sample_data *data,
 				struct pt_regs *regs)
 {
@@ -5242,6 +5252,47 @@ perf_event_create_kernel_counter(struct 
 }
 EXPORT_SYMBOL_GPL(perf_event_create_kernel_counter);
 
+void perf_event_attach(struct perf_event *event)
+{
+	struct perf_event_context *old_ctx, *new_ctx;
+
+	old_ctx = event->ctx;
+	new_ctx = find_get_context(current->pid, -1);
+	if (old_ctx != new_ctx) {
+		if (old_ctx) {
+			/* Delete from old ctx before joining new ctx */
+			mutex_lock(&old_ctx->mutex);
+			raw_spin_lock(&old_ctx->lock);
+			list_del_event(event, old_ctx);
+			raw_spin_unlock(&old_ctx->lock);
+			mutex_unlock(&old_ctx->mutex);
+			put_ctx(old_ctx);
+		}
+
+		mutex_lock(&new_ctx->mutex);
+		raw_spin_lock(&new_ctx->lock);
+		list_add_event(event, new_ctx);
+		event->ctx = new_ctx;
+		raw_spin_unlock(&new_ctx->lock);
+		mutex_unlock(&new_ctx->mutex);
+	} else
+		put_ctx(new_ctx);
+
+	perf_event_enable(event);
+}
+EXPORT_SYMBOL_GPL(perf_event_attach);
+
+void perf_event_detach(struct perf_event *event)
+{
+	/*
+	 * Just disable the event and don't del it from
+	 * ctx->event_list in case there is a race condition
+	 * with perf_event_read_value
+	 */
+	perf_event_disable(event);
+}
+EXPORT_SYMBOL_GPL(perf_event_detach);
+
 /*
  * inherit a event from parent task to child task:
  */


