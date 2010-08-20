Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab0HTIII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0HTIIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:08:04 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: kvm@vger.kernel.org
Cc: Zachary Amsden <zamsden@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [KVM timekeeping 02/35] Convert TSC writes to TSC offset writes
Date: Thu, 19 Aug 2010 22:07:16 -1000
Message-Id: <1282291669-25709-3-git-send-email-zamsden@redhat.com>
In-Reply-To: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change svm / vmx to be the same internally and write TSC offset
instead of bare TSC in helper functions.  Isolated as a single
patch to contain code movement.

Signed-off-by: Zachary Amsden <zamsden@redhat.com>
---
 arch/x86/kvm/svm.c |   29 ++++++++++++++++-------------
 arch/x86/kvm/vmx.c |   11 +++++------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7a2feb9..4cb8822 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -702,6 +702,20 @@ static void init_sys_seg(struct vmcb_seg *seg, uint32_t type)
 	seg->base = 0;
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
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
@@ -2567,20 +2581,9 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 data)
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
+		svm_write_tsc_offset(vcpu, data - native_read_tsc());
 		break;
-	}
 	case MSR_K6_STAR:
 		svm->vmcb->save.star = data;
 		break;
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index a8753e1..1f67e94 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1155,9 +1155,9 @@ static u64 guest_read_tsc(void)
  * writes 'guest_tsc' into guest's timestamp counter "register"
  * guest_tsc = host_tsc + tsc_offset ==> tsc_offset = guest_tsc - host_tsc
  */
-static void guest_write_tsc(u64 guest_tsc, u64 host_tsc)
+static void vmx_write_tsc_offset(u64 offset)
 {
-	vmcs_write64(TSC_OFFSET, guest_tsc - host_tsc);
+	vmcs_write64(TSC_OFFSET, offset);
 }
 
 /*
@@ -1261,7 +1261,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 		break;
 	case MSR_IA32_TSC:
 		rdtscll(host_tsc);
-		guest_write_tsc(data, host_tsc);
+		vmx_write_tsc_offset(data - host_tsc);
 		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
@@ -2518,7 +2518,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 {
 	u32 host_sysenter_cs, msr_low, msr_high;
 	u32 junk;
-	u64 host_pat, tsc_this;
+	u64 host_pat;
 	unsigned long a;
 	struct desc_ptr dt;
 	int i;
@@ -2659,8 +2659,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;
 	vmcs_writel(CR4_GUEST_HOST_MASK, ~vmx->vcpu.arch.cr4_guest_owned_bits);
 
-	tsc_this = native_read_tsc();
-	guest_write_tsc(0, tsc_this);
+	vmx_write_tsc_offset(0-native_read_tsc());
 
 	return 0;
 }
-- 
1.7.1

