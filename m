Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0HTIQa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:16:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab0HTIIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:10 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 03/35] Move TSC offset writes to common code
Date: Thu, 19 Aug 2010 22:07:17 -1000
Message-Id: <1282291669-25709-4-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, ensure that the storing of the offset and the reading of the TSC
are never preempted by taking a spinlock.  While the lock is overkill
now, it is useful later in this patch series.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    3 +++
 arch/x86/kvm/svm.c              |    6 ++++--
 arch/x86/kvm/vmx.c              |   13 ++++++-------
 arch/x86/kvm/x86.c              |   18 ++++++++++++++++++
 arch/x86/kvm/x86.h              |    2 ++
 5 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 960f9c9..3b4efe2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -395,6 +395,7 @@ struct kvm_arch {
 
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
+	spinlock_t tsc_write_lock;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
@@ -521,6 +522,8 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 4cb8822..8d7ae20 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2581,8 +2581,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TSC:
-		svm_write_tsc_offset(vcpu, data - native_read_tsc());
+	case MSR_IA32_TSC: 
+		kvm_write_tsc(vcpu, data);
 		break;
 	case MSR_K6_STAR:
 		svm->vmcb->save.star = data;
@@ -3547,6 +3547,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
+
+	.write_tsc_offset = svm_write_tsc_offset,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 1f67e94..e3e056f 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1152,10 +1152,9 @@ static u64 guest_read_tsc(void)
 }
 
 /*
- * writes 'guest_tsc' into guest's timestamp counter "register"
- * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
+ * writes 'offset' into guest's timestamp counter offset register
  */
-static void vmx_write_tsc_offset(u64 offset)
+static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
 	vmcs_write64(TSC_OFFSET, offset);
 }
@@ -1230,7 +1229,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct shared_msr_entry *msr;
-	u64 host_tsc;
 	int ret = 0;
 
 	switch (msr_index) {
@@ -1260,8 +1258,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TSC:
-		rdtscll(host_tsc);
-		vmx_write_tsc_offset(data - host_tsc);
+		kvm_write_tsc(vcpu, data);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
@@ -2659,7 +2656,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
-	vmx_write_tsc_offset(0-native_read_tsc());
+	kvm_write_tsc(&vmx->vcpu, 0);
 
 	return 0;
 }
@@ -4354,6 +4351,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
+
+	.write_tsc_offset = vmx_write_tsc_offset,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1bf9227..33e8208 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -895,6 +895,22 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
+void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 offset;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
+	offset = data - native_read_tsc();
+	kvm_x86_ops->write_tsc_offset(vcpu, offset);
+	spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
+
+	/* Reset of TSC must disable overshoot protection below */
+	vcpu->arch.hv_clock.tsc_timestamp = 0;
+}
+EXPORT_SYMBOL_GPL(kvm_write_tsc);
+
 static void kvm_write_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
@@ -5495,6 +5511,8 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
+	spin_lock_init(&kvm->arch.tsc_write_lock);
+
 	return kvm;
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b7a4047..2d6385e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -68,4 +68,6 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 
+void kvm_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+
 #endif
-- 
1.7.1

