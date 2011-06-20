Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1FUAA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 20:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756590Ab1FUAAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 20:00:18 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zachary Amsden <zamsden@gmail.com>
Cc: Zachary Amsden <zamsden@redhat.com>, Zachary Amsden <zamsden@gmail.com>
Subject: [KVM TSC emulation 9/9] Add software TSC emulation
Date: Mon, 20 Jun 2011 16:59:37 -0700
Message-Id: <1308614377-18627-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
References: <1308614377-18627-1-git-send-email-zamsden@redhat.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>, Frank Arnold <farnold@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, linux-kvm@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When hardware assistance is unavailable to scale the TSC, or it is
not possible to keep in sync, add a software virtualization mode
where the TSC is trapped and thus guaranteed to always have perfect
synchronization.

Currently this behavior defaults to on; how and when the decision to
use trapping is made is likely to be a matter of debate.  For now,
just make it possible.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |   26 +++++++++++++++++++++++++-
 arch/x86/kvm/vmx.c |   28 +++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c |   34 +++++++++++++++++++++++-----------
 arch/x86/kvm/x86.h |    5 +++++
 4 files changed, 80 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index dcab00e..fc4583d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -185,6 +185,7 @@ module_param(nested, int, S_IRUGO);
 
 static void svm_flush_tlb(struct kvm_vcpu *vcpu);
 static void svm_complete_interrupts(struct vcpu_svm *svm);
+static void svm_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
 static int nested_svm_intercept(struct vcpu_svm *svm);
@@ -912,13 +913,18 @@ static void svm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 	u64 khz;
 
 	/* Guest TSC same frequency as host TSC? */
-	if (!scale) {
+	if (!scale && !check_tsc_unstable()) {
 		svm->tsc_ratio = TSC_RATIO_DEFAULT;
 		return;
 	}
 
 	/* TSC scaling supported? */
 	if (!boot_cpu_has(X86_FEATURE_TSCRATEMSR)) {
+		if (kvm_software_tsc) {
+			pr_debug("kvm: using TSC trapping\n");
+			svm_set_tsc_trapping(vcpu, true);
+			return;
+		}
 		if (user_tsc_khz > tsc_khz) {
 			vcpu->arch.tsc_catchup = 1;
 			vcpu->arch.tsc_always_catchup = 1;
@@ -1184,6 +1190,7 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	svm->vmcb_pa = page_to_pfn(page) << PAGE_SHIFT;
 	svm->asid_generation = 0;
 	init_vmcb(svm);
+	kvm_set_tsc_khz(&svm->vcpu, kvm_max_tsc_khz);
 	kvm_write_tsc(&svm->vcpu, 0);
 
 	err = fx_init(&svm->vcpu);
@@ -1303,6 +1310,15 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 	clr_intercept(svm, INTERCEPT_VINTR);
 }
 
+static void svm_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	if (trap)
+		set_intercept(svm, INTERCEPT_RDTSC);
+	else
+		clr_intercept(svm, INTERCEPT_RDTSC);
+}
+
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
 	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
@@ -2732,6 +2748,13 @@ static int task_switch_interception(struct vcpu_svm *svm)
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
@@ -3178,6 +3201,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_SMI]				= nop_on_interception,
 	[SVM_EXIT_INIT]				= nop_on_interception,
 	[SVM_EXIT_VINTR]			= interrupt_window_interception,
+	[SVM_EXIT_RDTSC]			= rdtsc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
 	[SVM_EXIT_INVD]                         = emulate_on_interception,
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 780fe12..65066b4 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -606,6 +606,7 @@ static void kvm_cpu_vmxon(u64 addr);
 static void kvm_cpu_vmxoff(void);
 static void vmx_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
 static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr);
+static void vmx_set_tsc_trapping(struct kvm_vcpu *vcpu, bool trap);
 
 static DEFINE_PER_CPU(struct vmcs *, vmxarea);
 static DEFINE_PER_CPU(struct vmcs *, current_vmcs);
@@ -1756,9 +1757,14 @@ static u64 guest_read_tsc(void)
  */
 static void vmx_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 {
-	if (!scale)
+	if (!scale && !check_tsc_unstable())
 		return;
 
+	if (kvm_software_tsc) {
+		pr_debug("kvm: using TSC trapping\n");
+		vmx_set_tsc_trapping(vcpu, true);
+		return;
+	}
 	if (user_tsc_khz > tsc_khz) {
 		vcpu->arch.tsc_catchup = 1;
 		vcpu->arch.tsc_always_catchup = 1;
@@ -3695,6 +3701,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~0UL);
 	set_cr4_guest_host_mask(vmx);
 
+	kvm_set_tsc_khz(&vmx->vcpu, kvm_max_tsc_khz);
 	kvm_write_tsc(&vmx->vcpu, 0);
 
 	return 0;
@@ -3997,6 +4004,18 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
 	return 0;
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
 static int handle_rmode_exception(struct kvm_vcpu *vcpu,
 				  int vec, u32 err_code)
 {
@@ -4497,6 +4516,12 @@ static int handle_invlpg(struct kvm_vcpu *vcpu)
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
@@ -5421,6 +5446,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_HLT]                     = handle_halt,
 	[EXIT_REASON_INVD]		      = handle_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
+	[EXIT_REASON_RDTSC]		      = handle_rdtsc,
 	[EXIT_REASON_VMCALL]                  = handle_vmcall,
 	[EXIT_REASON_VMCLEAR]	              = handle_vmclear,
 	[EXIT_REASON_VMLAUNCH]                = handle_vmlaunch,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09e67fb..1a07796 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -99,6 +99,10 @@ EXPORT_SYMBOL_GPL(kvm_max_guest_tsc_khz);
 static u32 tsc_tolerance_ppm = 250;
 module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
 
+int kvm_software_tsc = 1;
+module_param_named(software_tsc_emulation, kvm_software_tsc, bool, 0644);
+EXPORT_SYMBOL_GPL(kvm_software_tsc);
+
 #define KVM_NR_SHARED_MSRS 16
 
 struct kvm_shared_msrs_global {
@@ -993,7 +997,8 @@ static inline u64 get_kernel_ns(void)
 }
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
-unsigned long max_tsc_khz;
+unsigned long kvm_max_tsc_khz;
+EXPORT_SYMBOL_GPL(kvm_max_tsc_khz);
 
 static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 {
@@ -1001,7 +1006,7 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 				   vcpu->arch.virtual_tsc_shift);
 }
 
-static void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
+void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
 {
 	u32 thresh_lo, thresh_hi;
 	int use_scaling = 0;
@@ -1026,6 +1031,7 @@ static void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz)
 	}
 	kvm_x86_ops->set_tsc_khz(vcpu, this_tsc_khz, use_scaling);	
 }
+EXPORT_SYMBOL_GPL(kvm_set_tsc_khz);
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
@@ -1117,6 +1123,18 @@ void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
 
 EXPORT_SYMBOL_GPL(kvm_write_tsc);
 
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
@@ -4931,7 +4949,7 @@ static void kvm_timer_init(void)
 {
 	int cpu;
 
-	max_tsc_khz = tsc_khz;
+	kvm_max_tsc_khz = tsc_khz;
 	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
 #ifdef CONFIG_CPU_FREQ
@@ -4940,13 +4958,13 @@ static void kvm_timer_init(void)
 		cpu = get_cpu();
 		cpufreq_get_policy(&policy, cpu);
 		if (policy.cpuinfo.max_freq)
-			max_tsc_khz = policy.cpuinfo.max_freq;
+			kvm_max_tsc_khz = policy.cpuinfo.max_freq;
 		put_cpu();
 #endif
 		cpufreq_register_notifier(&kvmclock_cpufreq_notifier_block,
 					  CPUFREQ_TRANSITION_NOTIFIER);
 	}
-	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
+	pr_debug("kvm: max_tsc_khz = %ld\n", kvm_max_tsc_khz);
 	for_each_online_cpu(cpu)
 		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
 }
@@ -6194,10 +6212,6 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 						unsigned int id)
 {
-	if (check_tsc_unstable() && atomic_read(&kvm->online_vcpus) != 0)
-		printk_once(KERN_WARNING
-		"kvm: SMP vm created on host with unstable TSC; "
-		"guest TSC will not be reliable\n");
 	return kvm_x86_ops->vcpu_create(kvm, id);
 }
 
@@ -6385,8 +6399,6 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	}
 	vcpu->arch.pio_data = page_address(page);
 
-	kvm_set_tsc_khz(vcpu, max_tsc_khz);
-
 	r = kvm_mmu_create(vcpu);
 	if (r < 0)
 		goto fail_free_pio_data;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 256da82..94780df 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -80,6 +80,10 @@ void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 int kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
 
 void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+void kvm_read_tsc(struct kvm_vcpu *vcpu);
+void kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 this_tsc_khz);
+extern int kvm_software_tsc;
+extern unsigned long kvm_max_tsc_khz;
 
 int kvm_read_guest_virt(struct x86_emulate_ctxt *ctxt,
 	gva_t addr, void *val, unsigned int bytes,
@@ -89,4 +93,5 @@ int kvm_write_guest_virt_system(struct x86_emulate_ctxt *ctxt,
 	gva_t addr, void *val, unsigned int bytes,
 	struct x86_exception *exception);
 
+
 #endif
-- 
1.7.1

