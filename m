Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641Ab0KXSSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:18:48 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:16576 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0KXSSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:44 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUZ-02-3OG-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] KVM: SVM: Add checks for all group 7 instructions
Date: Wed, 24 Nov 2010 19:18:31 +0100
Message-ID: <1290622715-8382-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds intercept checks for all the group 7
instructions to the KVM instruction emulator path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 035c5b5..7284193 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3619,6 +3619,55 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 	update_cr0_intercept(svm);
 }
 
+static void svm_check_group7(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c = &ctxt->decode;
+
+	switch (c->modrm_rm) {
+	case 0:
+		switch (c->modrm_reg) {
+		case 1:
+			vmcb->control.exit_code = SVM_EXIT_MONITOR;
+			break;
+		case 3:
+			vmcb->control.exit_code = SVM_EXIT_VMRUN;
+			break;
+		}
+		break;
+	case 1:
+		switch (c->modrm_reg) {
+		case 1:
+			vmcb->control.exit_code = SVM_EXIT_MWAIT;
+			break;
+		case 3:
+			vmcb->control.exit_code = SVM_EXIT_VMMCALL;
+			break;
+		case 7:
+			vmcb->control.exit_code = SVM_EXIT_RDTSCP;
+			break;
+		}
+		break;
+	case 2:
+		vmcb->control.exit_code = SVM_EXIT_VMLOAD;
+		break;
+	case 3:
+		vmcb->control.exit_code = SVM_EXIT_VMSAVE;
+		break;
+	case 4:
+		vmcb->control.exit_code = SVM_EXIT_STGI;
+		break;
+	case 5:
+		vmcb->control.exit_code = SVM_EXIT_CLGI;
+		break;
+	case 6:
+		vmcb->control.exit_code = SVM_EXIT_SKINIT;
+		break;
+	case 7:
+		vmcb->control.exit_code = SVM_EXIT_INVLPGA;
+		break;
+	}
+}
+
 static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 				struct x86_emulate_ctxt *ctxt)
 {
@@ -3654,8 +3703,10 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 		break;
 	case 0x01:
 		/* 0x0f 0x01 and modrm_mod == 3 encodes special instructions */
-		if (c->modrm_mod == 3)
+		if (c->modrm_mod == 3) {
+			svm_check_group7(vmcb, ctxt);
 			break;
+		}
 
 		switch (c->modrm_reg) {
 		case 0x00: /* SGDT */
-- 
1.7.1


