Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1GMPdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:33:18 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9608 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1GMPdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:16 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37A-02-9JF-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/7] KVM: SVM: Reorder nested_svm_vmrun
Date: Wed, 13 Jul 2011 17:32:21 +0200
Message-ID: <1310571145-28930-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>

Reorder the function a little bit to move interrupt related
code together and the tlb-flush from the middle of the
function towards the end.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/svm.c |   31 ++++++++++++++++---------------
 1 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index dc703ac..f81e35e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2411,6 +2411,20 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	else
 		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
 
+	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
+		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
+	else
+		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
+
+	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+		/* We only want the cr8 intercept bits of the guest */
+		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
+		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+	}
+
+	/* We don't want to see VMMCALLs from a nested guest */
+	clr_intercept(svm, INTERCEPT_VMMCALL);
+
 	if (nested_vmcb->control.nested_ctl) {
 		kvm_mmu_unload(&svm->vcpu);
 		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
@@ -2459,22 +2473,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->nested.intercept_exceptions = nested_vmcb->control.intercept_exceptions;
 	svm->nested.intercept            = nested_vmcb->control.intercept;
 
-	svm_flush_tlb(&svm->vcpu);
 	svm->vmcb->control.int_ctl = nested_vmcb->control.int_ctl | V_INTR_MASKING_MASK;
-	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
-		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
-
-	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
-		/* We only want the cr8 intercept bits of the guest */
-		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
-	}
-
-	/* We don't want to see VMMCALLs from a nested guest */
-	clr_intercept(svm, INTERCEPT_VMMCALL);
-
 	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
@@ -2484,6 +2483,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
+	svm_flush_tlb(&svm->vcpu);
+
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
 
-- 
1.7.4.1


