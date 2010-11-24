Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423Ab0KXSS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:18:59 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:2467
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755194Ab0KXSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:56 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUZ-01-380-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/9] KVM: SVM: Add intercept checks for descriptor table accesses
Date: Wed, 24 Nov 2010 19:18:30 +0100
Message-ID: <1290622715-8382-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds checks for accesses to the descriptor table
base registers to the intruction emulator path of KVM.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 16ff569..035c5b5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3636,12 +3636,40 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 		goto out;
 
 	switch (c->b) {
+	case 0x00:
+		switch (c->modrm_reg) {
+		case 0x00: /* SLDT */
+			vmcb->control.exit_code = SVM_EXIT_LDTR_READ;
+			break;
+		case 0x01: /* STR */
+			vmcb->control.exit_code = SVM_EXIT_TR_READ;
+			break;
+		case 0x02: /* LLDT */
+			vmcb->control.exit_code = SVM_EXIT_LDTR_WRITE;
+			break;
+		case 0x03: /* LTR */
+			vmcb->control.exit_code = SVM_EXIT_TR_WRITE;
+			break;
+		}
+		break;
 	case 0x01:
 		/* 0x0f 0x01 and modrm_mod == 3 encodes special instructions */
 		if (c->modrm_mod == 3)
 			break;
 
 		switch (c->modrm_reg) {
+		case 0x00: /* SGDT */
+			vmcb->control.exit_code = SVM_EXIT_GDTR_READ;
+			break;
+		case 0x01: /* SIDT */
+			vmcb->control.exit_code = SVM_EXIT_IDTR_READ;
+			break;
+		case 0x02: /* LGDT */
+			vmcb->control.exit_code = SVM_EXIT_GDTR_WRITE;
+			break;
+		case 0x03: /* LIDT */
+			vmcb->control.exit_code = SVM_EXIT_IDTR_WRITE;
+			break;
 		case 0x04: /* SMSW */
 			vmcb->control.exit_code = SVM_EXIT_READ_CR0;
 			break;
-- 
1.7.1


