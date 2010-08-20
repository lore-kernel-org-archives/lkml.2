Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab0HTILn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:11:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0HTIJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:09:09 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 27/35] Add TSC trapping
Date: Thu, 19 Aug 2010 22:07:41 -1000
Message-Id: <1282291669-25709-28-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add TSC trapping for SVM and VMX, with handler in common code.
Reasons to trap the TSC are numerous, but we avoid it as much
as possible for performance reasons.  We don't trap TSC when
kvmclock is in use.  We base the trapped TSC off the system
clock, which keeps it in sync on SMP virtual machines, and
we don't trap the TSC if the system TSC is "stable".

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +
 arch/x86/kvm/svm.c              |   22 +++++++++++++++
 arch/x86/kvm/vmx.c              |   21 ++++++++++++++
 arch/x86/kvm/x86.c              |   58 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/x86.h              |    1 +
 5 files changed, 85 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ec1dc3a..993d13d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -344,6 +344,7 @@ struct kvm_vcpu_arch {
 	u64 last_tsc_nsec;
 	u64 last_tsc_write;
 	bool tsc_rebase;
+	bool tsc_trapping;
 
 	bool nmi_pending;
 	bool nmi_injected;
@@ -529,6 +530,7 @@ struct kvm_x86_ops {
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
+	void (*set_tsc_trap)(struct kvm_vcpu *vcpu, bool trap);
 
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2be8338..604fc0f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -788,6 +788,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
+	if (svm->vcpu.arch.tsc_trapping)
+		svm->vmcb->control.intercept |= 1ULL << INTERCEPT_RDTSC;
+
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
 	control->int_ctl = V_INTR_MASKING_MASK;
@@ -1020,6 +1023,16 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
+static void svm_set_tsc_trap(struct kvm_vcpu *vcpu, bool trap)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	vcpu->arch.tsc_trapping = trap;
+	if (trap)
+		svm->vmcb->control.intercept |= 1ULL << INTERCEPT_RDTSC;
+	else
+		svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_RDTSC);
+}
+
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
 	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
@@ -2406,6 +2419,13 @@ static int task_switch_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int rdtsc_interception(struct vcpu_svm *svm)
+{
+	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
+	kvm_read_tsc(&svm->vcpu);
+	return 1;
+}
+
 static int cpuid_interception(struct vcpu_svm *svm)
 {
 	svm->next_rip = kvm_rip_read(&svm->vcpu) + 2;
@@ -2724,6 +2744,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
+	[SVM_EXIT_RDTSC]			= rdtsc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
@@ -3543,6 +3564,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.write_tsc_offset = svm_write_tsc_offset,
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
+	.set_tsc_trap = svm_set_tsc_trap,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f8b70ac..45508f2 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2788,6 +2788,19 @@ out:
 	return ret;
 }
 
+static void vmx_set_tsc_trap(struct kvm_vcpu *vcpu, bool trap)
+{
+	u32 cpu_based_vm_exec_control;
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	if (trap)
+		cpu_based_vm_exec_control |= CPU_BASED_RDTSC_EXITING;
+	else
+		cpu_based_vm_exec_control &= ~CPU_BASED_RDTSC_EXITING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+	vcpu->arch.tsc_trapping = trap;
+}
+
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	u32 cpu_based_vm_exec_control;
@@ -3388,6 +3401,12 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_rdtsc(struct kvm_vcpu *vcpu)
+{
+	kvm_read_tsc(vcpu);
+	return 1;
+}
+
 static int handle_wbinvd(struct kvm_vcpu *vcpu)
 {
 	skip_emulated_instruction(vcpu);
@@ -3670,6 +3689,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
+	[EXIT_REASON_RDTSC]		      = handle_rdtsc,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 	[EXIT_REASON_VMCLEAR]	              = handle_vmx_insn,
 	[EXIT_REASON_VMLAUNCH]                = handle_vmx_insn,
@@ -4347,6 +4367,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
+	.set_tsc_trap = vmx_set_tsc_trap,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 086d56a..839e3fd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -985,6 +985,19 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
+void kvm_read_tsc(struct kvm_vcpu *vcpu)
+{
+	u64 tsc;
+	s64 kernel_ns = getnsboottime();
+
+	tsc = compute_guest_tsc(vcpu, kernel_ns);
+	kvm_register_write(vcpu, VCPU_REGS_RAX, (u32)tsc);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, tsc >> 32);
+	vcpu->arch.last_guest_tsc = tsc;
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_read_tsc);
+
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
@@ -1089,6 +1102,16 @@ static void kvm_request_clock_update(struct kvm_vcpu *v)
 	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 }
 
+static void kvm_update_tsc_trapping(struct kvm *kvm)
+{
+	int trap, i;
+	struct kvm_vcpu *vcpu;
+
+	trap = check_tsc_unstable() && atomic_read(&kvm->online_vcpus) > 1;
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_x86_ops->set_tsc_trap(vcpu, trap && !vcpu->arch.time_page);
+}
+
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -1414,20 +1437,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 		vcpu->arch.time = data;
 		kvm_request_clock_update(vcpu);
 
-		/* we verify if the enable bit is set... */
-		if (!(data & 1))
-			break;
-
-		/* ...but clean it before doing the actual write */
-		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
-
-		vcpu->arch.time_page =
+		/* if the enable bit is set... */
+		if ((data & 1)) {
+			vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
+			vcpu->arch.time_page =
 				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
 
-		if (is_error_page(vcpu->arch.time_page)) {
-			kvm_release_page_clean(vcpu->arch.time_page);
-			vcpu->arch.time_page = NULL;
+			if (is_error_page(vcpu->arch.time_page)) {
+				kvm_release_page_clean(vcpu->arch.time_page);
+				vcpu->arch.time_page = NULL;
+			}
 		}
+		kvm_update_tsc_trapping(vcpu->kvm);
 		break;
 	}
 	case MSR_IA32_MCG_CTL:
@@ -5007,7 +5028,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
-	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+	if (!vcpu->arch.tsc_trapping)
+		kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
 
 	atomic_set(&vcpu->guest_mode, 0);
 	smp_wmb();
@@ -5561,14 +5583,12 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_x86_ops->vcpu_free(vcpu);
 }
 
-struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
-						unsigned int id)
+struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
 {
-	if (check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
-		printk_once(KERN_WARNING
-		"kvm: SMP vm created on host with unstable TSC; "
-		"guest TSC will not be reliable\n");
-	return kvm_x86_ops->vcpu_create(kvm, id);
+	struct kvm_vcpu *vcpu;
+	vcpu = kvm_x86_ops->vcpu_create(kvm, id);
+	kvm_update_tsc_trapping(vcpu->kvm);
+	return vcpu;
 }
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2d6385e..cb38f51 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -69,5 +69,6 @@ void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+void kvm_read_tsc(struct kvm_vcpu *vcpu);
 
 #endif
-- 
1.7.1

