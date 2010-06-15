Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0FOHgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 03:36:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650Ab0FOHey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 03:34:54 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com, glommer@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>
Subject: [PATCH 13/17] Add TSC offset tracking
Date: Mon, 14 Jun 2010 21:34:15 -1000
Message-Id: <1276587259-32319-14-git-send-email-zamsden@redhat.com>
In-Reply-To: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
References: <1276587259-32319-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Track the last TSC offset set for each VM and ensure that the storing of
the offset and the reading of the TSC are never preempted by taking a
spinlock.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    6 +++++-
 arch/x86/kvm/svm.c              |   30 +++++++++++++++++-------------
 arch/x86/kvm/vmx.c              |   21 +++++++--------------
 arch/x86/kvm/x86.c              |   20 +++++++++++++++++++-
 arch/x86/kvm/x86.h              |    2 ++
 5 files changed, 50 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7ec2472..98d4de8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -410,8 +410,11 @@ struct kvm_arch {
 	gpa_t ept_identity_map_addr;
 
 	unsigned long irq_sources_bitmap;
-	u64 vm_init_tsc;
 	s64 kvmclock_offset;
+	u64 last_tsc_write;
+	u64 last_tsc_offset;
+	u64 last_tsc_nsec;
+	spinlock_t tsc_write_lock;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
@@ -536,6 +539,7 @@ struct kvm_x86_ops {
 	int (*get_lpage_level)(void);
 	bool (*rdtscp_supported)(void);
 	void (*adjust_tsc_offset)(struct kvm_vcpu *vcpu, s64 adjustment);
+	void (*write_tsc_offset)(struct kvm_vcpu *vcpu, u64 offset);
 
 	void (*set_supported_cpuid)(u32 func, struct kvm_cpuid_entry2 *entry);
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ee2cf30..4654507 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2527,20 +2527,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
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
@@ -3417,6 +3406,20 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 		svm->nested.hsave->control.tsc_offset += adjustment;
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
@@ -3503,6 +3506,7 @@ static struct kvm_x86_ops svm_x86_ops = {
 	.set_supported_cpuid = svm_set_supported_cpuid,
 
 	.adjust_tsc_offset = svm_adjust_tsc_offset,
+	.write_tsc_offset = svm_write_tsc_offset,
 };
 
 static int __init svm_init(void)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a993e67..9b604b8 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1133,12 +1133,11 @@ static u64 guest_read_tsc(void)
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
 
 static void vmx_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
@@ -1217,7 +1216,6 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct shared_msr_entry *msr;
-	u64 host_tsc;
 	int ret = 0;
 
 	switch (msr_index) {
@@ -1247,8 +1245,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_TSC:
-		rdtscll(host_tsc);
-		guest_write_tsc(data, host_tsc);
+		guest_write_tsc(vcpu, data);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
@@ -2503,7 +2500,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
 	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
-	u64 host_pat, tsc_this, tsc_base;
+	u64 host_pat;
 	unsigned long a;
 	struct desc_ptr dt;
 	int i;
@@ -2644,12 +2641,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
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
@@ -4336,6 +4328,7 @@ static struct kvm_x86_ops vmx_x86_ops = {
 	.set_supported_cpuid = vmx_set_supported_cpuid,
 
 	.adjust_tsc_offset = vmx_adjust_tsc_offset,
+	.write_tsc_offset = vmx_write_tsc_offset,
 };
 
 static int __init vmx_init(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15c7317..ef847ee 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -932,6 +932,24 @@ static inline void kvm_request_guest_time_update(struct kvm_vcpu *v)
 	set_bit(KVM_REQ_CLOCK_SYNC, &v->requests);
 }
 
+void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data)
+{
+	struct kvm *kvm = vcpu->kvm;
+	u64 offset;
+
+	spin_lock(&kvm->arch.tsc_write_lock);
+	offset = data - native_read_tsc();
+	kvm->arch.last_tsc_nsec = get_kernel_ns();
+	kvm->arch.last_tsc_write = data;
+	kvm->arch.last_tsc_offset = offset;
+	kvm_x86_ops->write_tsc_offset(vcpu, offset);
+	spin_unlock(&kvm->arch.tsc_write_lock);
+
+	/* Reset of TSC must disable overshoot protection below */
+	vcpu->arch.hv_clock.tsc_timestamp = 0;
+}
+EXPORT_SYMBOL_GPL(guest_write_tsc);
+
 static int kvm_recompute_guest_time(struct kvm_vcpu *v)
 {
 	unsigned long flags;
@@ -5616,7 +5634,7 @@ struct  kvm *kvm_arch_create_vm(void)
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
 	set_bit(KVM_USERSPACE_IRQ_SOURCE_ID, &kvm->arch.irq_sources_bitmap);
 
-	rdtscll(kvm->arch.vm_init_tsc);
+	spin_lock_init(&kvm->arch.tsc_write_lock);
 
 	return kvm;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f4b5445..ce2aff8 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -75,4 +75,6 @@ static inline struct kvm_mem_aliases *kvm_aliases(struct kvm *kvm)
 void kvm_before_handle_nmi(struct kvm_vcpu *vcpu);
 void kvm_after_handle_nmi(struct kvm_vcpu *vcpu);
 
+void guest_write_tsc(struct kvm_vcpu *vcpu, u64 data);
+
 #endif
-- 
1.7.1

