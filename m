Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab0GMCZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0GMCZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:25:46 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Subject: [PATCH 01/18] Make TSC offset writes non-preemptible
Date: Mon, 12 Jul 2010 16:25:21 -1000
Message-Id: <1278987938-23873-2-git-send-email-zamsden@redhat.com>
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that the storing of the offset and the reading of the TSC
are never preempted by taking a spinlock.  While the lock is overkill
now, it is useful later in this patch series.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    4 +++-
 arch/x86/kvm/svm.c              |   31 ++++++++++++++++++-------------
 arch/x86/kvm/vmx.c              |   22 ++++++++--------------
 arch/x86/kvm/x86.c              |   17 ++++++++++++++++-
 arch/x86/kvm/x86.h              |    2 ++
 5 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 502e53f..3b4efe2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -394,8 +394,8 @@ struct kvm_arch {
 	gpa_t ept_identity_map_addr;
 
 	unsigned long irq_sources_bitmap;
-	u64 vm_init_tsc;
 	s64 kvmclock_offset;
+	spinlock_t tsc_write_lock;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
@@ -522,6 +522,8 @@ struct kvm_x86_ops {
 
 	bool (*has_wbinvd_exit)(void);
 
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
+
 	const struct trace_print_flags *exit_reasons_str;
 };
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 56c9b6b..6671053 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2543,20 +2543,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	switch (ecx) {
-	case MSR_IA32_TSC: {
-		u64 tsc_offset = data - native_read_tsc();
-		u64 g_tsc_offset = 0;
-
-		if (is_nested(svm)) {
-			g_tsc_offset = svm->vmcb->control.tsc_offset -
-				       svm->nested.hsave->control.tsc_offset;
-			svm->nested.hsave->control.tsc_offset = tsc_offset;
-		}
-
-		svm->vmcb->control.tsc_offset = tsc_offset + g_tsc_offset;
-
+	case MSR_IA32_TSC: 
+		guest_write_tsc(vcpu, data);
 		break;
-	}
 	case MSR_K6_STAR:
 		svm->vmcb->save.star = data;
 		break;
@@ -3429,6 +3418,20 @@ static bool svm_has_wbinvd_exit(void)
 	return true;
 }
 
+static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	u64 g_tsc_offset = 0;
+
+	if (is_nested(svm)) {
+		g_tsc_offset = svm->vmcb->control.tsc_offset -
+			       svm->nested.hsave->control.tsc_offset;
+		svm->nested.hsave->control.tsc_offset = offset;
+	}
+
+	svm->vmcb->control.tsc_offset = offset + g_tsc_offset;
+}
+
 static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3515,6 +3518,8 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
 	.has_wbinvd_exit = svm_has_wbinvd_exit,
+
+	.write_tsc_offset = svm_write_tsc_offset,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 2fdcc98..9055ca6 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1153,12 +1153,11 @@ static u64 guest_read_tsc(void)
 }
 
 /*
- * writes 'guest_tsc' into guest's timestamp counter "register"
- * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
+ * writes 'offset' into guest's timestamp counter offset register
  */
-static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
+static void vmx_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 {
-	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
+	vmcs_write64(TSC_OFFSET, offset);
 }
 
 /*
@@ -1231,7 +1230,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct shared_msr_entry *msr;
-	u64 host_tsc;
 	int ret = 0;
 
 	switch (msr_index) {
@@ -1261,8 +1259,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TSC:
-		rdtscll(host_tsc);
-		guest_write_tsc(data, host_tsc);
+		guest_write_tsc(vcpu, data);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
@@ -2517,7 +2514,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
 	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
-	u64 host_pat, tsc_this, tsc_base;
+	u64 host_pat;
 	unsigned long a;
 	struct desc_ptr dt;
 	int i;
@@ -2658,12 +2655,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
-	tsc_base = vmx->vcpu.kvm->arch.vm_init_tsc;
-	rdtscll(tsc_this);
-	if (tsc_this < vmx->vcpu.kvm->arch.vm_init_tsc)
-		tsc_base = tsc_this;
-
-	guest_write_tsc(0, tsc_base);
+	guest_write_tsc(&vmx->vcpu, 0);
 
 	return 0;
 }
@@ -4358,6 +4350,8 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
+
+	.write_tsc_offset = vmx_write_tsc_offset,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6ed3176..a2ee975 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -893,6 +893,21 @@ static void kvm_set_time_scale(uint32_t tsc_khz, struct pvclock_vcpu_time_info *
 
 static DEFINE_PER_CPU(unsigned long, cpu_tsc_khz);
 
+void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 offset;
+
+	spin_lock(&kvm->arch.tsc_write_lock);
+	offset = data - native_read_tsc();
+	kvm_x86_ops->write_tsc_offset(vcpu, offset);
+	spin_unlock(&kvm->arch.tsc_write_lock);
+
+	/* Reset of TSC must disable overshoot protection below */
+	vcpu->arch.hv_clock.tsc_timestamp = 0;
+}
+EXPORT_SYMBOL_GPL(guest_write_tsc);
+
 static void kvm_write_guest_time(struct kvm_vcpu *v)
 {
 	struct timespec ts;
@@ -5487,7 +5502,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	rdtscll(kvm->arch.vm_init_tsc);
+	spin_lock_init(&kvm->arch.tsc_write_lock);
 
 	return kvm;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b7a4047..f8d81f4 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -68,4 +68,6 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 
+void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+
 #endif
-- 
1.7.1

