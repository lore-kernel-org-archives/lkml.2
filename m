Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0KXSeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:34:04 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:30675
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339Ab0KXSeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:34:02 -0500
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Nov 2010 13:34:02 EST
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUZ-01-37W-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/9] KVM: SVM: Add checks for CRx read and write intercepts
Date: Wed, 24 Nov 2010 19:18:28 +0100
Message-ID: <1290622715-8382-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add code to check for any CRx read, write, and
the selective-cr0 intercepts for instructions emulated in
software by KVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 72 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index d1721c2..29f0491 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3622,7 +3622,78 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 				struct x86_emulate_ctxt *ctxt)
 {
-	return X86EMUL_CONTINUE;
+	struct decode_cache *c = &ctxt->decode;
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *vmcb = svm->vmcb;
+	int vmexit, ret;
+
+	if (!is_nested(svm))
+		return X86EMUL_CONTINUE;
+
+	ret = X86EMUL_CONTINUE;
+
+	if (!c->twobyte)
+		goto out;
+
+	switch (c->b) {
+	case 0x01:
+		/* 0x0f 0x01 and modrm_mod == 3 encodes special instructions */
+		if (c->modrm_mod == 3)
+			break;
+
+		switch (c->modrm_reg) {
+		case 0x04: /* SMSW */
+			vmcb->control.exit_code = SVM_EXIT_READ_CR0;
+			break;
+		case 0x06:  { /* LMSW */
+			u64 cr0, val;
+
+			vmcb->control.exit_code = SVM_EXIT_WRITE_CR0;
+
+			if (svm->nested.intercept_cr_write & INTERCEPT_CR0_MASK)
+				break;
+
+			/* check for selective-cr0 special case */
+			cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK & 0xf;
+			val = c->src.val     & ~SVM_CR0_SELECTIVE_MASK & 0xf;
+
+			if (cr0 ^ val)
+				vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+
+			break;
+			}
+		}
+	case 0x06: /* CLTS */
+		vmcb->control.exit_code = SVM_EXIT_WRITE_CR0;
+		break;
+	case 0x20: /* CR read  */
+		vmcb->control.exit_code = SVM_EXIT_READ_CR0 + c->modrm_reg;
+		break;
+	case 0x22: /* CR write */
+		vmcb->control.exit_code = SVM_EXIT_WRITE_CR0 + c->modrm_reg;
+		if (c->modrm_reg == 0 &&
+		    !(svm->nested.intercept_cr_write & INTERCEPT_CR0_MASK)) {
+			/* check for selective-cr0 special case */
+			u64 cr0, val;
+
+			cr0 = vcpu->arch.cr0 & ~SVM_CR0_SELECTIVE_MASK;
+			val = c->src.val     & ~SVM_CR0_SELECTIVE_MASK;
+
+			if (cr0 ^ val)
+				vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
+		}
+		break;
+	}
+
+	vmcb->control.next_rip = ctxt->eip;
+	vmexit = nested_svm_exit_handled(svm);
+
+	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
+					   : X86EMUL_CONTINUE;
+
+out:
+
+	return ret;
 }
 
 static struct kvm_x86_ops svm_x86_ops = {
-- 
1.7.1


