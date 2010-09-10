Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab0IJPdB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:33:01 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39675 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755Ab0IJPc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:32:59 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i2a8h87h43h)
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8JF40-02-JPW-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/29] KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
Date: Fri, 10 Sep 2010 17:30:55 +0200
Message-ID: <1284132667-18620-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
References: <1284132667-18620-1-git-send-email-joerg.roedel@amd.com>
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
 arch/x86/kvm/x86.c              |   18 +++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 87734cc..7d3adb8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -660,6 +660,7 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu);
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 access);
+void kvm_propagate_fault(struct kvm_vcpu *vcpu);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 307599d..2816e5a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -338,6 +338,22 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu)
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
+void kvm_propagate_fault(struct kvm_vcpu *vcpu)
+{
+	u32 nested, error;
+
+	error   = vcpu->arch.fault.error_code;
+	nested  = error &  PFERR_NESTED_MASK;
+	error   = error & ~PFERR_NESTED_MASK;
+
+	vcpu->arch.fault.error_code = error;
+
+	if (mmu_is_nested(vcpu) && !nested)
+		vcpu->arch.nested_mmu.inject_page_fault(vcpu);
+	else
+		vcpu->arch.mmu.inject_page_fault(vcpu);
+}
+
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.nmi_pending = 1;
@@ -4126,7 +4142,7 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception == PF_VECTOR)
-		kvm_inject_page_fault(vcpu);
+		kvm_propagate_fault(vcpu);
 	else if (ctxt->error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception, ctxt->error_code);
 	else
-- 
1.7.0.4


