Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1AFKLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:11:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab1AFKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:10:58 -0500
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, linux-kernel@vger.kernel.org
Subject: [KVM TSC trapping / migration 1/2] Add TSC trapping for SVM and VMX
Date: Thu,  6 Jan 2011 00:10:44 -1000
Message-Id: <1294308645-31113-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
References: <1294308645-31113-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reasons to trap the TSC are numerous, but we want to avoid it as much
as possible for performance reasons.

We provide two conservative modes via modules parameters and userspace
hinting.  First, the module can be loaded with "tsc_auto=1" as a module
parameter, which turns on conservative TSC trapping only when it is
required (when unstable TSC or faster KHZ CPU is detected).

For userspace hinting, we enable trapping only if necessary.  Userspace
can hint that a VM needs a fixed frequency TSC, and also that SMP
stability will be required.  In that case, we conservatively turn on
trapping when it is needed.  In addition, users may now specify the
desired TSC rate at which to run.  If this rate differs significantly
from the host rate, trapping will be enabled.

There is also an override control to allow TSC trapping to be turned on
or off unconditionally for testing.

We indicate to pvclock users that the TSC is being trapped, to allow
avoiding overhead and directly using RDTSCP (only for SVM).  This
optimization is not yet implemented.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h    |    6 +-
 arch/x86/include/asm/pvclock-abi.h |    1 +
 arch/x86/kvm/svm.c                 |   20 ++++++
 arch/x86/kvm/vmx.c                 |   21 +++++++
 arch/x86/kvm/x86.c                 |  113 +++++++++++++++++++++++++++++++++---
 arch/x86/kvm/x86.h                 |    2 +
 include/linux/kvm.h                |   15 +++++
 7 files changed, 168 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ff651b7..6cce67a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -452,6 +452,8 @@ struct kvm_arch {
 	u32 virtual_tsc_khz;
 	u32 virtual_tsc_mult;
 	s8 virtual_tsc_shift;
+	bool tsc_trapping;
+	u32 tsc_flags;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
@@ -575,6 +577,8 @@ struct kvm_x86_ops {
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+	void (*set_tsc_trapping)(struct kvm_vcpu *vcpu, bool trap);
 
 	void (*set_tdp_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
 
@@ -582,8 +586,6 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
-	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
-
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
index 35f2d19..315ead5 100644
--- a/arch/x86/include/asm/pvclock-abi.h
+++ b/arch/x86/include/asm/pvclock-abi.h
@@ -40,5 +40,6 @@ struct pvclock_wall_clock {
 } __attribute__((__packed__));
 
 #define PVCLOCK_TSC_STABLE_BIT	(1 << 0)
+#define PVCLOCK_TSC_TRAPPED_BIT (1 << 1)
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_PVCLOCK_ABI_H */
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c929d00..af48be9 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -806,6 +806,8 @@ static void init_vmcb(struct vcpu_svm *svm)
 				(1ULL << INTERCEPT_MONITOR) |
 				(1ULL << INTERCEPT_MWAIT);
 
+	kvm_setup_tsc_trapping(&svm->vcpu);
+
 	control->iopm_base_pa = iopm_base;
 	control->msrpm_base_pa = __pa(svm->msrpm);
 	control->int_ctl = V_INTR_MASKING_MASK;
@@ -1038,6 +1040,15 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VINTR);
 }
 
+static void svm_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	if (trap)
+		svm->vmcb->control.intercept |= 1ULL << INTERCEPT_RDTSC;
+	else
+		svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_RDTSC);
+}
+
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
 	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
@@ -2497,6 +2508,13 @@ static int task_switch_interception(struct vcpu_svm *svm)
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
@@ -2833,6 +2851,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
+	[SVM_EXIT_RDTSC]			= rdtsc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
@@ -3676,6 +3695,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 
 	.write_tsc_offset = svm_write_tsc_offset,
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
+	.set_tsc_trapping = svm_set_tsc_trapping,
 
 	.set_tdp_cr3 = set_tdp_cr3,
 };
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 28c72da..3516d18 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -2631,6 +2631,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
 	kvm_write_tsc(&vmx->vcpu, 0);
+	kvm_setup_tsc_trapping(&vmx->vcpu);
 
 	return 0;
 }
@@ -2770,6 +2771,18 @@ out:
 	return ret;
 }
 
+static void vmx_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap)
+{
+	u32 cpu_based_vm_exec_control;
+
+	cpu_based_vm_exec_control = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
+	if (trap)
+		cpu_based_vm_exec_control |= CPU_BASED_RDTSC_EXITING;
+	else
+		cpu_based_vm_exec_control &= ~CPU_BASED_RDTSC_EXITING;
+	vmcs_write32(CPU_BASED_VM_EXEC_CONTROL, cpu_based_vm_exec_control);
+}
+
 static void enable_irq_window(struct kvm_vcpu *vcpu)
 {
 	u32 cpu_based_vm_exec_control;
@@ -3359,6 +3372,12 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
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
@@ -3651,6 +3670,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_PENDING_INTERRUPT]       = handle_interrupt_window,
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
+	[EXIT_REASON_RDTSC]		      = handle_rdtsc,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 	[EXIT_REASON_VMCLEAR]	              = handle_vmx_insn,
 	[EXIT_REASON_VMLAUNCH]                = handle_vmx_insn,
@@ -4339,6 +4359,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
+	.set_tsc_trapping = vmx_set_tsc_trapping,
 
 	.set_tdp_cr3 = vmx_set_cr3,
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a339e50..bbcd582 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -95,6 +95,12 @@ static int kvm_dev_ioctl_get_supported_cpuid(struct kvm_cpuid2 *cpuid,
 struct kvm_x86_ops *kvm_x86_ops;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
+static int __read_mostly tsc_trap = 1;
+module_param(tsc_trap, int, S_IRUGO);
+
+static bool __read_mostly tsc_auto = 1;
+module_param(tsc_auto, bool, S_IRUGO);
+
 int ignore_msrs = 0;
 module_param_named(ignore_msrs, ignore_msrs, bool, S_IRUGO | S_IWUSR);
 
@@ -1058,6 +1064,8 @@ static void update_pvclock(struct kvm_vcpu *v,
 	pvclock->tsc_timestamp = tsc_timestamp;
 	pvclock->system_time = kernel_ns + v->kvm->arch.kvmclock_offset;
 	pvclock->flags = 0;
+	if (v->kvm->arch.tsc_trapping)
+		pvclock->flags |= PVCLOCK_TSC_TRAPPED_BIT;
 }
 
 static void update_user_kvmclock(struct kvm_vcpu *v,
@@ -1072,6 +1080,18 @@ static void update_user_kvmclock(struct kvm_vcpu *v,
 	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
 }
 
+void kvm_read_tsc(struct kvm_vcpu *vcpu)
+{
+	u64 tsc;
+	s64 kernel_ns = get_kernel_ns();
+
+	tsc = compute_guest_tsc(vcpu, kernel_ns);
+	kvm_register_write(vcpu, VCPU_REGS_RAX, (u32)tsc);
+	kvm_register_write(vcpu, VCPU_REGS_RDX, tsc >> 32);
+	kvm_x86_ops->skip_emulated_instruction(vcpu);
+}
+EXPORT_SYMBOL_GPL(kvm_read_tsc);
+
 static int kvm_guest_time_update(struct kvm_vcpu *v)
 {
 	unsigned long flags;
@@ -1198,6 +1218,55 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
 
+void kvm_setup_tsc_trapping(struct kvm_vcpu *vcpu)
+{
+	struct kvm_arch *arch = &vcpu->kvm->arch;
+	int trap;
+	bool tsc_underrun, tsc_overrun;
+
+	/*
+	 * First, establish rate differences outside NTP correction boundary.
+	 * N.B. - virtual_tsc_khz may not yet be known, in which case it is
+	 * assumed the host rate will be used; guard against this in overrun.
+	 */
+	u64 max_tsc_ull = max_tsc_khz * 1000000ULL;
+	tsc_overrun = (arch->virtual_tsc_khz &&
+		       arch->virtual_tsc_khz * 1000500ULL < max_tsc_ull);
+	tsc_underrun = (arch->virtual_tsc_khz * 999500ULL > max_tsc_ull);
+
+	/*
+	 * We must trap if we have unstable TSC and a hint from userspace that
+	 * SMP is required; also, if we want a fixed rate and the max TSC rate
+	 * exceeds the VM rate by over 500 ppm (the maximum NTP slew rate).
+	 */
+	trap =
+	  (check_tsc_unstable() &&
+	      (arch->tsc_flags & KVM_TSC_FLAG_SMP_COHERENCY)) ||
+	  ((arch->tsc_flags & KVM_TSC_FLAG_FIXED_RATE) &&
+	      (tsc_overrun || tsc_underrun));
+
+	/*
+	 * Auto-selection: if we have no guidance from userspace, we can't
+	 * know if VCPUs will be added, so assume SMP, as it is difficult to
+	 * switch other CPUs into trapping mode after they have started
+	 */
+	if (tsc_auto)
+		trap |= (tsc_overrun || check_tsc_unstable());
+
+	/* tsc_trap (module parameter) overrides explicit choice */
+	if (tsc_trap != 0)
+		trap = (tsc_trap > 0);
+
+	/* Correct untrapped underrun with catchup */
+	if (!trap && tsc_underrun)
+		vcpu->arch.tsc_catchup = 1;
+
+	vcpu->kvm->arch.tsc_trapping = trap;
+	kvm_x86_ops->set_tsc_trapping(vcpu, trap);
+	pr_debug("kvm: set trap mode %d on vcpu %d\n", trap, vcpu->vcpu_id);
+}
+EXPORT_SYMBOL_GPL(kvm_setup_tsc_trapping);
+
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -1962,6 +2031,7 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_DEBUGREGS:
 	case KVM_CAP_X86_ROBUST_SINGLESTEP:
 	case KVM_CAP_XSAVE:
+	case KVM_CAP_TSC_CONTROL:
 		r = 1;
 		break;
 	case KVM_CAP_COALESCED_MMIO:
@@ -3535,7 +3605,30 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		r = 0;
 		break;
 	}
+	case KVM_TSC_CONTROL: {
+		struct kvm_tsc_control user_tsc;
+
+		r = -EFAULT;
+		if (copy_from_user(&user_tsc, argp, sizeof(user_tsc)))
+			goto out;
+
+		r = -EINVAL;
+		if (user_tsc.flags &
+		    ~(KVM_TSC_FLAG_FIXED_RATE |
+		      KVM_TSC_FLAG_SMP_COHERENCY))
+			goto out;
 
+		if (user_tsc.tsc_khz &&
+			(user_tsc.tsc_khz > KVM_TSC_MAX_KHZ ||
+			 user_tsc.tsc_khz < KVM_TSC_MIN_KHZ))
+			goto out;
+
+		if (user_tsc.tsc_khz)
+			kvm_arch_set_tsc_khz(kvm, user_tsc.tsc_khz);
+
+		r = 0;
+		break;
+	}
 	default:
 		;
 	}
@@ -5222,7 +5315,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (hw_breakpoint_active())
 		hw_breakpoint_restore();
 
-	kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
+	/*
+	 * We only need to record this for unstable, passthrough TSC.
+	 * Since the host clocksource will not be TSC in that case, we
+	 * risk going backwards during recalibration of kvmclock due to
+	 * differing clock resolution.
+	 */
+	if (!vcpu->kvm->arch.tsc_trapping && check_tsc_unstable())
+		kvm_get_msr(vcpu, MSR_IA32_TSC, &vcpu->arch.last_guest_tsc);
 
 	atomic_set(&vcpu->guest_mode, 0);
 	smp_wmb();
@@ -5777,14 +5877,11 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
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
+	return vcpu;
 }
 
 int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2cea414..6afa64f 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -75,5 +75,7 @@ void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+void kvm_read_tsc(struct kvm_vcpu *vcpu);
+void kvm_setup_tsc_trapping(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 919ae53..cb97e53 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -540,6 +540,8 @@ struct kvm_ppc_pvinfo {
 #endif
 #define KVM_CAP_PPC_GET_PVINFO 57
 #define KVM_CAP_PPC_IRQ_LEVEL 58
+#define KVM_CAP_TSC_CONTROL 59
+
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -619,6 +621,17 @@ struct kvm_clock_data {
 	__u32 pad[9];
 };
 
+struct kvm_tsc_control {
+	__u32 flags;
+	__u32 tsc_khz;
+};
+
+#define KVM_TSC_FLAG_FIXED_RATE		(1 << 0)
+#define KVM_TSC_FLAG_SMP_COHERENCY	(1 << 1)
+
+#define KVM_TSC_MIN_KHZ 16000		/* 16 MHz, slower than first Pentium */
+#define KVM_TSC_MAX_KHZ 100000000	/* 100 GHz, good for a few years */
+
 /*
  * ioctls for VM fds
  */
@@ -676,6 +689,8 @@ struct kvm_clock_data {
 #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
 /* Available with KVM_CAP_PPC_GET_PVINFO */
 #define KVM_PPC_GET_PVINFO	  _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
+/* Available with KVM_CAP_TSC_CONTROL */
+#define KVM_TSC_CONTROL		  _IOW(KVMIO,  0xa2, struct kvm_tsc_control)
 
 /*
  * ioctls for vcpu fds
-- 
1.7.1

