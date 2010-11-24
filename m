Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0KXSSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:18:46 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:13664 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab0KXSSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:44 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIUZ-02-3OF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6/9] KVM: SVM: Add intercept checks for remaining twobyte instructions
Date: Wed, 24 Nov 2010 19:18:32 +0100
Message-ID: <1290622715-8382-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds intercepts checks for the remaining twobyte
instructions to the KVM instruction emulator.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   29 +++++++++++++++++++++++++++++
 1 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 7284193..77b344e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -3741,10 +3741,19 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 
 			break;
 			}
+		case 0x07: /* INVLPG */
+			vmcb->control.exit_code = SVM_EXIT_INVLPG;
+			break;
 		}
 	case 0x06: /* CLTS */
 		vmcb->control.exit_code = SVM_EXIT_WRITE_CR0;
 		break;
+	case 0x08: /* INVD */
+		vmcb->control.exit_code = SVM_EXIT_INVD;
+		break;
+	case 0x09: /* WBINVD */
+		vmcb->control.exit_code = SVM_EXIT_WBINVD;
+		break;
 	case 0x20: /* CR read  */
 		vmcb->control.exit_code = SVM_EXIT_READ_CR0 + c->modrm_reg;
 		break;
@@ -3768,6 +3777,26 @@ static int svm_insn_intercepted(struct kvm_vcpu *vcpu,
 	case 0x23:
 		vmcb->control.exit_code = SVM_EXIT_WRITE_DR0 + c->modrm_reg;
 		break;
+	case 0x30: /* WRMSR */
+		vmcb->control.exit_code = SVM_EXIT_MSR;
+		vmcb->control.exit_info_1 = 1;
+		break;
+	case 0x31: /* RDTSC */
+		vmcb->control.exit_code = SVM_EXIT_RDTSC;
+		break;
+	case 0x32: /* RDMSR */
+		vmcb->control.exit_code = SVM_EXIT_MSR;
+		vmcb->control.exit_info_1 = 0;
+		break;
+	case 0x33: /* RDPMC */
+		vmcb->control.exit_code = SVM_EXIT_RDPMC;
+		break;
+	case 0xa2: /* CPUID */
+		vmcb->control.exit_code = SVM_EXIT_CPUID;
+		break;
+	case 0xaa: /* RSM */
+		vmcb->control.exit_code = SVM_EXIT_RSM;
+		break;
 	}
 
 	vmcb->control.next_rip = ctxt->eip;
-- 
1.7.1


