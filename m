Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab0KXSTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:19:18 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:55623
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab0KXSTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:19:12 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIV0-01-383-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/9] KVM: SVM: Add intercept checks for one-byte instructions
Date: Wed, 24 Nov 2010 19:18:33 +0100
Message-ID: <1290622715-8382-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add intercept checks for emulated one-byte
instructions to the KVM instruction emulation path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   36 +++++++++++++++++++++++++++++++++---
 1 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 77b344e..2a30b5b 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3668,6 +3668,35 @@ static void svm_check_group7(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
 	}
 }
 
+static void svm_check_onebyte(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+
+	switch (c->b) {
+	case 0x90: /* PAUSE */
+		if (c->rep_prefix == REPE_PREFIX)
+			vmcb->control.exit_code = SVM_EXIT_PAUSE;
+		break;
+	case 0x9c: /* PUSHF */
+		break;
+	case 0x9d: /* POPF */
+		vmcb->control.exit_code = SVM_EXIT_POPF;
+		break;
+	case 0xcd: /* INTn */
+		vmcb->control.exit_code = SVM_EXIT_SWINT;
+		break;
+	case 0xcf: /* IRET */
+		vmcb->control.exit_code = SVM_EXIT_IRET;
+		break;
+	case 0xf1: /* ICEBP */
+		vmcb->control.exit_code = SVM_EXIT_ICEBP;
+		break;
+	case 0xf4: /* HLT */
+		vmcb->control.exit_code = SVM_EXIT_HLT;
+		break;
+	}
+}
+
 static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 				struct x86_emulate_ctxt *ctxt)
 {
@@ -3681,8 +3710,10 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 
 	ret = X86EMUL_CONTINUE;
 
-	if (!c->twobyte)
+	if (!c->twobyte) {
+		svm_check_onebyte(vmcb, ctxt);
 		goto out;
+	}
 
 	switch (c->b) {
 	case 0x00:
@@ -3799,14 +3830,13 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 		break;
 	}
 
+out:
 	vmcb->control.next_rip = ctxt->eip;
 	vmexit = nested_svm_exit_handled(svm);
 
 	ret = (vmexit == NESTED_EXIT_DONE) ? X86EMUL_INTERCEPTED
 					   : X86EMUL_CONTINUE;
 
-out:
-
 	return ret;
 }
 
-- 
1.7.1


