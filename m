Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0DPHfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 03:35:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:51731 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756512Ab0DPHfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 03:35:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,218,1270450800"; 
   d="scan'208";a="509638388"
Subject: [PATCH V4 1/2] perf & kvm: Enhance perf to collect KVM guest os
 statistics from host side
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, Avi Kivity <avi@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       kvm@vger.kernel.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
       linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, tim.c.chen@intel.com,
       zhiteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Fri, 16 Apr 2010 15:34:35 +0800
Message-Id: <1271403275.2078.509.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the kernel patch to enable perf to collect guest os statistics.

Joerg,

Would you like to add support on svm? I don't know the exact point to trigger
NMI to host with svm.

See below code with vmx:
 
+		kvm_before_handle_nmi(&vmx->vcpu);
 		asm("int $2");
+		kvm_after_handle_nmi(&vmx->vcpu);

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup --exclude=tools linux-2.6_tip0413/arch/x86/include/asm/perf_event.h linux-2.6_tip0413_perfkvm/arch/x86/include/asm/perf_event.h
--- linux-2.6_tip0413/arch/x86/include/asm/perf_event.h	2010-04-14 11:11:03.992966568 +0800
+++ linux-2.6_tip0413_perfkvm/arch/x86/include/asm/perf_event.h	2010-04-14 11:13:17.261881591 +0800
@@ -135,17 +135,10 @@ extern void perf_events_lapic_init(void)
  */
 #define PERF_EFLAGS_EXACT	(1UL << 3)
 
-#define perf_misc_flags(regs)				\
-({	int misc = 0;					\
-	if (user_mode(regs))				\
-		misc |= PERF_RECORD_MISC_USER;		\
-	else						\
-		misc |= PERF_RECORD_MISC_KERNEL;	\
-	if (regs->flags & PERF_EFLAGS_EXACT)		\
-		misc |= PERF_RECORD_MISC_EXACT;		\
-	misc; })
-
-#define perf_instruction_pointer(regs)	((regs)->ip)
+struct pt_regs;
+extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
+extern unsigned long perf_misc_flags(struct pt_regs *regs);
+#define perf_misc_flags(regs)	perf_misc_flags(regs)
 
 #else
 static inline void init_hw_perf_events(void)		{ }
diff -Nraup --exclude=tools linux-2.6_tip0413/arch/x86/kernel/cpu/perf_event.c linux-2.6_tip0413_perfkvm/arch/x86/kernel/cpu/perf_event.c
--- linux-2.6_tip0413/arch/x86/kernel/cpu/perf_event.c	2010-04-14 11:11:04.825028810 +0800
+++ linux-2.6_tip0413_perfkvm/arch/x86/kernel/cpu/perf_event.c	2010-04-14 17:02:12.198063684 +0800
@@ -1720,6 +1720,11 @@ struct perf_callchain_entry *perf_callch
 {
 	struct perf_callchain_entry *entry;
 
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		/* TODO: We don't support guest os callchain now */
+		return NULL;
+	}
+
 	if (in_nmi())
 		entry = &__get_cpu_var(pmc_nmi_entry);
 	else
@@ -1743,3 +1748,30 @@ void perf_arch_fetch_caller_regs(struct 
 	regs->cs = __KERNEL_CS;
 	local_save_flags(regs->flags);
 }
+
+unsigned long perf_instruction_pointer(struct pt_regs *regs)
+{
+	unsigned long ip;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest())
+		ip = perf_guest_cbs->get_guest_ip();
+	else
+		ip = instruction_pointer(regs);
+	return ip;
+}
+
+unsigned long perf_misc_flags(struct pt_regs *regs)
+{
+	int misc = 0;
+	if (perf_guest_cbs && perf_guest_cbs->is_in_guest()) {
+		misc |= perf_guest_cbs->is_user_mode() ?
+			PERF_RECORD_MISC_GUEST_USER :
+			PERF_RECORD_MISC_GUEST_KERNEL;
+	} else
+		misc |= user_mode(regs) ? PERF_RECORD_MISC_USER :
+			PERF_RECORD_MISC_KERNEL;
+	if (regs->flags & PERF_EFLAGS_EXACT)
+		misc |= PERF_RECORD_MISC_EXACT;
+
+	return misc;
+}
+
diff -Nraup --exclude=tools linux-2.6_tip0413/arch/x86/kvm/vmx.c linux-2.6_tip0413_perfkvm/arch/x86/kvm/vmx.c
--- linux-2.6_tip0413/arch/x86/kvm/vmx.c	2010-04-14 11:11:04.353024541 +0800
+++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/vmx.c	2010-04-15 10:28:39.516891050 +0800
@@ -3654,8 +3654,11 @@ static void vmx_complete_interrupts(stru
 
 	/* We need to handle NMIs before interrupts are enabled */
 	if ((exit_intr_info & INTR_INFO_INTR_TYPE_MASK) == INTR_TYPE_NMI_INTR &&
-	    (exit_intr_info & INTR_INFO_VALID_MASK))
+	    (exit_intr_info & INTR_INFO_VALID_MASK)) {
+		kvm_before_handle_nmi(&vmx->vcpu);
 		asm("int $2");
+		kvm_after_handle_nmi(&vmx->vcpu);
+	}
 
 	idtv_info_valid = idt_vectoring_info & VECTORING_INFO_VALID_MASK;
 
diff -Nraup --exclude=tools linux-2.6_tip0413/arch/x86/kvm/x86.c linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c
--- linux-2.6_tip0413/arch/x86/kvm/x86.c	2010-04-14 11:11:04.341042024 +0800
+++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.c	2010-04-15 17:16:41.340064784 +0800
@@ -40,6 +40,7 @@
 #include <linux/user-return-notifier.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
+#include <linux/perf_event.h>
 #include <trace/events/kvm.h>
 #undef TRACE_INCLUDE_FILE
 #define CREATE_TRACE_POINTS
@@ -3765,6 +3766,47 @@ static void kvm_timer_init(void)
 	}
 }
 
+static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
+
+static int kvm_is_in_guest(void)
+{
+	return percpu_read(current_vcpu) != NULL;
+}
+
+static int kvm_is_user_mode(void)
+{
+	int user_mode = 3;
+	if (percpu_read(current_vcpu))
+		user_mode = kvm_x86_ops->get_cpl(percpu_read(current_vcpu));
+	return user_mode != 0;
+}
+
+static unsigned long kvm_get_guest_ip(void)
+{
+	unsigned long ip = 0;
+	if (percpu_read(current_vcpu))
+		ip = kvm_rip_read(percpu_read(current_vcpu));
+	return ip;
+}
+
+static struct perf_guest_info_callbacks kvm_guest_cbs = {
+	.is_in_guest		= kvm_is_in_guest,
+	.is_user_mode		= kvm_is_user_mode,
+	.get_guest_ip		= kvm_get_guest_ip,
+};
+
+void kvm_before_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	percpu_write(current_vcpu, vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_before_handle_nmi);
+
+void kvm_after_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	percpu_write(current_vcpu, NULL);
+}
+EXPORT_SYMBOL_GPL(kvm_after_handle_nmi);
+
 int kvm_arch_init(void *opaque)
 {
 	int r;
@@ -3801,6 +3843,8 @@ int kvm_arch_init(void *opaque)
 
 	kvm_timer_init();
 
+	perf_register_guest_info_callbacks(&kvm_guest_cbs);
+
 	return 0;
 
 out:
@@ -3809,6 +3853,8 @@ out:
 
 void kvm_arch_exit(void)
 {
+	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
+
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
 		cpufreq_unregister_notifier(&kvmclock_cpufreq_notifier_block,
 					    CPUFREQ_TRANSITION_NOTIFIER);
diff -Nraup --exclude=tools linux-2.6_tip0413/arch/x86/kvm/x86.h linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.h
--- linux-2.6_tip0413/arch/x86/kvm/x86.h	2010-04-14 11:11:04.328996790 +0800
+++ linux-2.6_tip0413_perfkvm/arch/x86/kvm/x86.h	2010-04-15 10:27:57.116972433 +0800
@@ -65,4 +65,7 @@ static inline int is_paging(struct kvm_v
 	return kvm_read_cr0_bits(vcpu, X86_CR0_PG);
 }
 
+void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
+void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
+
 #endif
diff -Nraup --exclude=tools linux-2.6_tip0413/include/linux/perf_event.h linux-2.6_tip0413_perfkvm/include/linux/perf_event.h
--- linux-2.6_tip0413/include/linux/perf_event.h	2010-04-14 11:11:16.922212684 +0800
+++ linux-2.6_tip0413_perfkvm/include/linux/perf_event.h	2010-04-14 11:34:33.478072738 +0800
@@ -288,11 +288,13 @@ struct perf_event_mmap_page {
 	__u64	data_tail;		/* user-space written tail */
 };
 
-#define PERF_RECORD_MISC_CPUMODE_MASK		(3 << 0)
+#define PERF_RECORD_MISC_CPUMODE_MASK		(7 << 0)
 #define PERF_RECORD_MISC_CPUMODE_UNKNOWN	(0 << 0)
 #define PERF_RECORD_MISC_KERNEL			(1 << 0)
 #define PERF_RECORD_MISC_USER			(2 << 0)
 #define PERF_RECORD_MISC_HYPERVISOR		(3 << 0)
+#define PERF_RECORD_MISC_GUEST_KERNEL		(4 << 0)
+#define PERF_RECORD_MISC_GUEST_USER		(5 << 0)
 
 #define PERF_RECORD_MISC_EXACT			(1 << 14)
 /*
@@ -446,6 +448,12 @@ enum perf_callchain_context {
 # include <asm/perf_event.h>
 #endif
 
+struct perf_guest_info_callbacks {
+	int (*is_in_guest) (void);
+	int (*is_user_mode) (void);
+	unsigned long (*get_guest_ip) (void);
+};
+
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 #include <asm/hw_breakpoint.h>
 #endif
@@ -920,6 +928,12 @@ static inline void perf_event_mmap(struc
 		__perf_event_mmap(vma);
 }
 
+extern struct perf_guest_info_callbacks *perf_guest_cbs;
+extern int perf_register_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+extern int perf_unregister_guest_info_callbacks(
+		struct perf_guest_info_callbacks *);
+
 extern void perf_event_comm(struct task_struct *tsk);
 extern void perf_event_fork(struct task_struct *tsk);
 
@@ -989,6 +1003,11 @@ perf_sw_event(u32 event_id, u64 nr, int 
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
+static inline int perf_register_guest_info_callbacks
+(struct perf_guest_info_callbacks *) {return 0; }
+static inline int perf_unregister_guest_info_callbacks
+(struct perf_guest_info_callbacks *) {return 0; }
+
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_comm(struct task_struct *tsk)		{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
diff -Nraup --exclude=tools linux-2.6_tip0413/kernel/perf_event.c linux-2.6_tip0413_perfkvm/kernel/perf_event.c
--- linux-2.6_tip0413/kernel/perf_event.c	2010-04-14 11:12:04.090770764 +0800
+++ linux-2.6_tip0413_perfkvm/kernel/perf_event.c	2010-04-14 11:13:17.265859229 +0800
@@ -2797,6 +2797,27 @@ void perf_arch_fetch_caller_regs(struct 
 
 
 /*
+ * We assume there is only KVM supporting the callbacks.
+ * Later on, we might change it to a list if there is
+ * another virtualization implementation supporting the callbacks.
+ */
+struct perf_guest_info_callbacks *perf_guest_cbs;
+
+int perf_register_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = cbs;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_register_guest_info_callbacks);
+
+int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
+{
+	perf_guest_cbs = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
+
+/*
  * Output
  */
 static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
@@ -3748,7 +3769,7 @@ void __perf_event_mmap(struct vm_area_st
 		.event_id  = {
 			.header = {
 				.type = PERF_RECORD_MMAP,
-				.misc = 0,
+				.misc = PERF_RECORD_MISC_USER,
 				/* .size */
 			},
 			/* .pid */


