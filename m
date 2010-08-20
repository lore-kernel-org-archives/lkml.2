Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab0HTII0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab0HTIIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:22 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 09/35] Unify TSC logic
Date: Thu, 19 Aug 2010 22:07:23 -1000
Message-Id: <1282291669-25709-10-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the TSC control logic from the vendor backends into x86.c
by adding adjust_tsc_offset to x86 ops.  Now all TSC decisions
can be done in one place.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    5 +++--
 arch/x86/kvm/svm.c              |   26 ++++++++++----------------
 arch/x86/kvm/vmx.c              |   22 ++++++++--------------
 arch/x86/kvm/x86.c              |   17 ++++++++++++++---
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b42893..324e892 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -255,7 +255,6 @@ struct kvm_mmu {
 };
 
 struct kvm_vcpu_arch {
-	u64 host_tsc;
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
@@ -336,9 +335,10 @@ struct kvm_vcpu_arch {
 
 	gpa_t time;
 	struct pvclock_vcpu_time_info hv_clock;
-	unsigned int hv_clock_tsc_khz;
+	unsigned int hw_tsc_khz;
 	unsigned int time_offset;
 	struct page *time_page;
+	u64 last_host_tsc;
 
 	bool nmi_pending;
 	bool nmi_injected;
@@ -520,6 +520,7 @@ struct kvm_x86_ops {
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
+	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
 
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index e8bfe8e..2be8338 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -716,6 +716,15 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
 }
 
+static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->vmcb->control.tsc_offset += adjustment;
+	if (is_nested(svm))
+		svm->nested.hsave->control.tsc_offset += adjustment;
+}
+
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -962,20 +971,6 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	int i;
 
 	if (unlikely(cpu != vcpu->cpu)) {
-		u64 delta;
-
-		if (check_tsc_unstable()) {
-			/*
-			 * Make sure that the guest sees a monotonically
-			 * increasing TSC.
-			 */
-			delta = vcpu->arch.host_tsc - native_read_tsc();
-			svm->vmcb->control.tsc_offset += delta;
-			if (is_nested(svm))
-				svm->nested.hsave->control.tsc_offset += delta;
-		}
-		vcpu->cpu = cpu;
-		kvm_migrate_timers(vcpu);
 		svm->asid_generation = 0;
 	}
 
@@ -991,8 +986,6 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 	++vcpu->stat.host_state_reload;
 	for (i = 0; i < NR_HOST_SAVE_USER_MSRS; i++)
 		wrmsrl(host_save_user_msrs[i], svm->host_user_msrs[i]);
-
-	vcpu->arch.host_tsc = native_read_tsc();
 }
 
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
@@ -3549,6 +3542,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
 
 	.write_tsc_offset = svm_write_tsc_offset,
+	.adjust_tsc_offset = svm_adjust_tsc_offset,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index e3e056f..f8b70ac 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -505,7 +505,6 @@ static void __vcpu_clear(void *arg)
 		vmcs_clear(vmx->vmcs);
 	if (per_cpu(current_vmcs, cpu) == vmx->vmcs)
 		per_cpu(current_vmcs, cpu) = NULL;
-	rdtscll(vmx->vcpu.arch.host_tsc);
 	list_del(&vmx->local_vcpus_link);
 	vmx->vcpu.cpu = -1;
 	vmx->launched = 0;
@@ -887,7 +886,6 @@ static void vmx_load_host_state(struct vcpu_vmx *vmx)
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u64 tsc_this, delta, new_offset;
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
 
 	if (!vmm_exclusive)
@@ -904,14 +902,12 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		struct desc_ptr *gdt = &__get_cpu_var(host_gdt);
 		unsigned long sysenter_esp;
 
-		kvm_migrate_timers(vcpu);
 		kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
 		local_irq_disable();
 		list_add(&vmx->local_vcpus_link,
 			 &per_cpu(vcpus_on_cpu, cpu));
 		local_irq_enable();
 
-		vcpu->cpu = cpu;
 		/*
 		 * Linux uses per-cpu TSS and GDT, so set these when switching
 		 * processors.
@@ -921,16 +917,6 @@ static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 		rdmsrl(MSR_IA32_SYSENTER_ESP, sysenter_esp);
 		vmcs_writel(HOST_IA32_SYSENTER_ESP, sysenter_esp); /* 22.2.3 */
-
-		/*
-		 * Make sure the time stamp counter is monotonous.
-		 */
-		rdtscll(tsc_this);
-		if (tsc_this < vcpu->arch.host_tsc) {
-			delta = vcpu->arch.host_tsc - tsc_this;
-			new_offset = vmcs_read64(TSC_OFFSET) + delta;
-			vmcs_write64(TSC_OFFSET, new_offset);
-		}
 	}
 }
 
@@ -1159,6 +1145,12 @@ static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	vmcs_write64(TSC_OFFSET, offset);
 }
 
+static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
+{
+	u64 offset = vmcs_read64(TSC_OFFSET);
+	vmcs_write64(TSC_OFFSET, offset + adjustment);
+}
+
 /*
  * Reads an msr value (of 'msr_index') into 'pdata'.
  * Returns 0 on success, non-0 otherwise.
@@ -4114,6 +4106,7 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 
 	cpu = get_cpu();
 	vmx_vcpu_load(&vmx->vcpu, cpu);
+	vmx->vcpu.cpu = cpu;
 	err = vmx_vcpu_setup(vmx);
 	vmx_vcpu_put(&vmx->vcpu);
 	put_cpu();
@@ -4353,6 +4346,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
 	.write_tsc_offset = vmx_write_tsc_offset,
+	.adjust_tsc_offset = vmx_adjust_tsc_offset,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e3b10e..7fc4a55 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -973,9 +973,9 @@ static int kvm_write_guest_time(struct kvm_vcpu *v)
 		return 1;
 	}
 
-	if (unlikely(vcpu->hv_clock_tsc_khz != this_tsc_khz)) {
+	if (unlikely(vcpu->hw_tsc_khz != this_tsc_khz)) {
 		kvm_set_time_scale(this_tsc_khz, &vcpu->hv_clock);
-		vcpu->hv_clock_tsc_khz = this_tsc_khz;
+		vcpu->hw_tsc_khz = this_tsc_khz;
 	}
 
 	/* With all the info we got, fill in the values */
@@ -1866,13 +1866,24 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	}
 
 	kvm_x86_ops->vcpu_load(vcpu, cpu);
-	kvm_request_guest_time_update(vcpu);
+	if (unlikely(vcpu->cpu != cpu)) {
+		/* Make sure TSC doesn't go backwards */
+		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :
+				native_read_tsc() - vcpu->arch.last_host_tsc;
+		if (tsc_delta < 0)
+			mark_tsc_unstable("KVM discovered backwards TSC");
+		if (check_tsc_unstable())
+			kvm_x86_ops->adjust_tsc_offset(vcpu, -tsc_delta);
+		kvm_migrate_timers(vcpu);
+		vcpu->cpu = cpu;
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
 	kvm_x86_ops->vcpu_put(vcpu);
 	kvm_put_guest_fpu(vcpu);
+	vcpu->arch.last_host_tsc = native_read_tsc();
 }
 
 static int is_efer_nx(void)
-- 
1.7.1

