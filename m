Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab0IFQAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:00:02 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:48689
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755503Ab0IFP7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:59:53 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8C1L8-02-7A4-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: Alexander Graf <agraf@suse.de>, <joro@8bytes.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/27] KVM: MMU: Propagate the right fault back to the guest after gva_to_gpa
Date: Mon, 6 Sep 2010 17:55:57 +0200
Message-ID: <1283788566-29186-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
References: <1283788566-29186-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements logic to make sure that either a
page-fault/page-fault-vmexit or a nested-page-fault-vmexit
is propagated back to the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/x86.c              |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5eb57c..173834b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -663,6 +663,7 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 int kvm_read_guest_page_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gfn_t gfn, void *data, int offset, int len,
 			    u32 *error);
+void kvm_propagate_fault(struct kvm_vcpu *vcpu);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
 
 int kvm_pic_set_irq(void *opaque, int irq, int level);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 38d482d..65b00f0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -337,6 +337,22 @@ void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 	kvm_queue_exception_e(vcpu, PF_VECTOR, error_code);
 }
 
+void kvm_propagate_fault(struct kvm_vcpu *vcpu)
+{
+	unsigned long address;
+	u32 nested, error;
+
+	address = vcpu->arch.fault.address;
+	error   = vcpu->arch.fault.error_code;
+	nested  = error &  PFERR_NESTED_MASK;
+	error   = error & ~PFERR_NESTED_MASK;
+
+	if (mmu_is_nested(vcpu) && !nested)
+		vcpu->arch.nested_mmu.inject_page_fault(vcpu, address, error);
+	else
+		vcpu->arch.mmu.inject_page_fault(vcpu, address, error);
+}
+
 void kvm_inject_nmi(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.nmi_pending = 1;
@@ -4130,8 +4146,7 @@ static void inject_emulated_exception(struct kvm_vcpu *vcpu)
 {
 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
 	if (ctxt->exception == PF_VECTOR)
-		kvm_inject_page_fault(vcpu, vcpu->arch.fault.address,
-					    vcpu->arch.fault.error_code);
+		kvm_propagate_fault(vcpu);
 	else if (ctxt->error_code_valid)
 		kvm_queue_exception_e(vcpu, ctxt->exception, ctxt->error_code);
 	else
-- 
1.7.0.4


