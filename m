Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0DVKdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:33:32 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26981 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0DVKd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:29 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBK-01-033-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/8] KVM: SVM: Fix nested nmi handling
Date: Thu, 22 Apr 2010 12:33:07 +0200
Message-ID: <1271932394-13968-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:18.0903 (UTC) FILETIME=[3964B470:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch introducing nested nmi handling had a bug. The
check does not belong to enable_nmi_window but must be in
nmi_allowed. This patch fixes this.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ab78eb8..ec20584 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2771,8 +2771,12 @@ static int svm_nmi_allowed(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb *vmcb = svm->vmcb;
-	return !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
-		!(svm->vcpu.arch.hflags & HF_NMI_MASK);
+	int ret;
+	ret = !(vmcb->control.int_state & SVM_INTERRUPT_SHADOW_MASK) &&
+	      !(svm->vcpu.arch.hflags & HF_NMI_MASK);
+	ret = ret && gif_set(svm) && nested_svm_nmi(svm);
+
+	return ret;
 }
 
 static bool svm_get_nmi_mask(struct kvm_vcpu *vcpu)
@@ -2841,11 +2845,9 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	 * Something prevents NMI from been injected. Single step over possible
 	 * problem (IRET or exception injection or interrupt shadow)
 	 */
-	if (gif_set(svm) && nested_svm_nmi(svm)) {
-		svm->nmi_singlestep = true;
-		svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
-		update_db_intercept(vcpu);
-	}
+	svm->nmi_singlestep = true;
+	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	update_db_intercept(vcpu);
 }
 
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
-- 
1.7.0.4


