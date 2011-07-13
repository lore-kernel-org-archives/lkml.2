Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab1GMPd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:33:58 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:59791 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab1GMPdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:33:18 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37B-02-9JI-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/7] KVM: SVM: Don't change host intercepts in vmrun emulation
Date: Wed, 13 Jul 2011 17:32:25 +0200
Message-ID: <1310571145-28930-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than changing the host intercepts in
nested_svm_vmrun, mask the intercepts we only want to see
from the guest out in recalc_intercepts.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c83315a..ab48dd4 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -102,6 +102,9 @@ struct nested_state {
 	u32 intercept_exceptions;
 	u64 intercept;
 
+	/* Mask of relevant host intercepts for recalculation */
+	u32 intercept_cr_mask;
+
 	/* Nested Paging related state */
 	u64 nested_cr3;
 
@@ -250,10 +253,11 @@ static void recalc_intercepts(struct vcpu_svm *svm)
 	h = &svm->host_vmcb->control;
 	g = &svm->nested;
 
-	c->intercept_cr = h->intercept_cr | g->intercept_cr;
+	c->intercept_cr = (h->intercept_cr & g->intercept_cr_mask) |
+			   g->intercept_cr;
 	c->intercept_dr = h->intercept_dr | g->intercept_dr;
 	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
-	c->intercept = h->intercept | g->intercept;
+	c->intercept = (h->intercept & ~(INTERCEPT_VMMCALL)) | g->intercept;
 }
 
 static inline void set_cr_intercept(struct vcpu_svm *svm, int bit)
@@ -2376,13 +2380,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
 
 		/* We only want the cr8 intercept bits of the guest */
-		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
-		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
+		svm->nested.intercept_cr_mask = ~(INTERCEPT_CR8_READ |
+						  INTERCEPT_CR8_WRITE);
+	} else {
+		svm->nested.intercept_cr_mask = 0ULL;
 	}
 
-	/* We don't want to see VMMCALLs from a nested guest */
-	clr_intercept(svm, INTERCEPT_VMMCALL);
-
 	if (nested_vmcb->control.nested_ctl) {
 		kvm_mmu_unload(&svm->vcpu);
 		svm->nested.nested_cr3 = nested_vmcb->control.nested_cr3;
-- 
1.7.4.1


