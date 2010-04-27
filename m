Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab0D0KjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 06:39:15 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:51821
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754737Ab0D0KjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 06:39:03 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6ff19hz32i87h2a8h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L1J6WP-02-NP5-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/22] KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
Date: Tue, 27 Apr 2010 12:38:27 +0200
Message-ID: <1272364712-17425-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
References: <1272364712-17425-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 27 Apr 2010 10:38:36.0089 (UTC) FILETIME=[CA843290:01CAE5F5]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements logic to make sure that either a
page-fault/page-fault-vmexit or a nested-page-fault-vmexit
is propagated back to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/emulate.c          |   20 ++++++++++----------
 arch/x86/kvm/mmu.h              |    1 +
 arch/x86/kvm/x86.c              |   20 ++++++++++++++++++--
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8426870..d024e27 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -645,6 +645,7 @@ void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
+void kvm_propagate_fault(struct kvm_vcpu *vcpu);
 int kvm_read_guest_page_tdp(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 *error);
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 5ac0bb4..171e1c7 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1336,7 +1336,7 @@ static int read_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	addr = dt.address + index * 8;
 	ret = ops->read_std(addr, desc, sizeof *desc, ctxt->vcpu,  &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT)
-		kvm_inject_page_fault(ctxt->vcpu, addr, err);
+		kvm_propagate_fault(ctxt->vcpu);
 
        return ret;
 }
@@ -1362,7 +1362,7 @@ static int write_segment_descriptor(struct x86_emulate_ctxt *ctxt,
 	addr = dt.address + index * 8;
 	ret = ops->write_std(addr, desc, sizeof *desc, ctxt->vcpu, &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT)
-		kvm_inject_page_fault(ctxt->vcpu, addr, err);
+		kvm_propagate_fault(ctxt->vcpu);
 
 	return ret;
 }
@@ -2165,7 +2165,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, old_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2175,7 +2175,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			     &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, old_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2183,7 +2183,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, new_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2196,7 +2196,7 @@ static int task_switch_16(struct x86_emulate_ctxt *ctxt,
 				     ctxt->vcpu, &err);
 		if (ret == X86EMUL_PROPAGATE_FAULT) {
 			/* FIXME: need to provide precise fault address */
-			kvm_inject_page_fault(ctxt->vcpu, new_tss_base, err);
+			kvm_propagate_fault(ctxt->vcpu);
 			return ret;
 		}
 	}
@@ -2304,7 +2304,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, old_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2314,7 +2314,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			     &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, old_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2322,7 +2322,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 			    &err);
 	if (ret == X86EMUL_PROPAGATE_FAULT) {
 		/* FIXME: need to provide precise fault address */
-		kvm_inject_page_fault(ctxt->vcpu, new_tss_base, err);
+		kvm_propagate_fault(ctxt->vcpu);
 		return ret;
 	}
 
@@ -2335,7 +2335,7 @@ static int task_switch_32(struct x86_emulate_ctxt *ctxt,
 				     ctxt->vcpu, &err);
 		if (ret == X86EMUL_PROPAGATE_FAULT) {
 			/* FIXME: need to provide precise fault address */
-			kvm_inject_page_fault(ctxt->vcpu, new_tss_base, err);
+			kvm_propagate_fault(ctxt->vcpu);
 			return ret;
 		}
 	}
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 64f619b..b42b27e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -47,6 +47,7 @@
 #define PFERR_USER_MASK (1U << 2)
 #define PFERR_RSVD_MASK (1U << 3)
 #define PFERR_FETCH_MASK (1U << 4)
+#define PFERR_NESTED_MASK (1U << 31)
 
 int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 317ad26..4d3a698 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -324,6 +324,22 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
+void kvm_propagate_fault(struct kvm_vcpu *vcpu)
+{
+	unsigned long address;
+	u32 nested, error;
+
+	address = vcpu->arch.fault_address;
+	error   = vcpu->arch.fault_error_code;
+	nested  = error &  PFERR_NESTED_MASK;
+	error   = error & ~PFERR_NESTED_MASK;
+
+	if (vcpu->arch.mmu.nested && !nested)
+		vcpu->arch.nested_mmu.inject_page_fault(vcpu, address, error);
+	else
+		vcpu->arch.mmu.inject_page_fault(vcpu, address, error);
+}
+
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.nmi_pending = 1;
@@ -3338,7 +3354,7 @@ static int emulator_read_emulated(unsigned long addr,
 	gpa = kvm_mmu_gva_to_gpa_read(vcpu, addr, &error_code);
 
 	if (gpa == UNMAPPED_GVA) {
-		kvm_inject_page_fault(vcpu, addr, error_code);
+		kvm_propagate_fault(vcpu);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
@@ -3392,7 +3408,7 @@ static int emulator_write_emulated_onepage(unsigned long addr,
 	gpa = kvm_mmu_gva_to_gpa_write(vcpu, addr, &error_code);
 
 	if (gpa == UNMAPPED_GVA) {
-		kvm_inject_page_fault(vcpu, addr, error_code);
+		kvm_propagate_fault(vcpu);
 		return X86EMUL_PROPAGATE_FAULT;
 	}
 
-- 
1.7.0.4


