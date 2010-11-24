Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab0KXSTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:19:53 -0500
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:4546
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997Ab0KXSTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:19:49 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIV0-01-382-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 8/9] KVM: SVM: Add checks for IO instructions
Date: Wed, 24 Nov 2010 19:18:34 +0100
Message-ID: <1290622715-8382-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code to check for IOIO intercepts on
instructions decoded by the KVM instruction emulator.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2a30b5b..a2c513d 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3668,6 +3668,47 @@ static void svm_check_group7(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
 	}
 }
 
+static void svm_check_ioio(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
+{
+	struct decode_cache *c;
+	u32 bytes, seg;
+	u32 exit_info;
+
+	c         = &ctxt->decode;
+	/* Encode Port */
+	exit_info = (c->regs[VCPU_REGS_RDX] & 0xffff) << 16;
+	seg       = 0;
+
+	/* Encode Address Size */
+	exit_info |= (u32)c->ad_bytes << (SVM_IOIO_ASIZE_SHIFT - 1);
+
+	if (c->rep_prefix)
+		exit_info |= SVM_IOIO_REP_MASK;
+
+	if ((c->b & 0x06) == 0x06) {
+		/* OUT* Instruction */
+		bytes = c->dst.bytes;
+	} else {
+		/* IN* Instruction */
+		bytes      = c->src.bytes;
+		exit_info |= SVM_IOIO_TYPE_MASK;
+	}
+
+	/* Encode Data Size */
+	bytes      = min(bytes, 4u);
+	exit_info |= bytes << SVM_IOIO_SIZE_SHIFT;
+
+	/* Check for the string variants */
+	if ((c->b & 0xf0) == 0x60) {
+		exit_info |= SVM_IOIO_STR_MASK;
+		exit_info |= (seg & 0x07) << 10;
+	}
+
+	vmcb->control.exit_info_1 = exit_info;
+	vmcb->control.exit_info_2 = ctxt->eip;
+	vmcb->control.exit_code   = SVM_EXIT_IOIO;
+}
+
 static void svm_check_onebyte(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
 {
 	struct decode_cache *c = &ctxt->decode;
@@ -3685,6 +3726,20 @@ static void svm_check_onebyte(struct vmcb *vmcb, struct x86_emulate_ctxt *ctxt)
 	case 0xcd: /* INTn */
 		vmcb->control.exit_code = SVM_EXIT_SWINT;
 		break;
+	case 0x6c: /* INS */
+	case 0x6d:
+	case 0xe4: /* IN */
+	case 0xe5:
+	case 0xec:
+	case 0xed:
+	case 0x6e: /* OUTS */
+	case 0x6f:
+	case 0xe6: /* OUT */
+	case 0xe7:
+	case 0xee:
+	case 0xef:
+		svm_check_ioio(vmcb, ctxt);
+		break;
 	case 0xcf: /* IRET */
 		vmcb->control.exit_code = SVM_EXIT_IRET;
 		break;
-- 
1.7.1


