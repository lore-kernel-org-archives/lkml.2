Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0K3RE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:04:27 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:27190
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754746Ab0K3REZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:04:25 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEX-01-0X0-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/6] KVM: SVM: Add function to recalculate intercept masks
Date: Tue, 30 Nov 2010 18:03:56 +0100
Message-ID: <1291136641-4874-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a function to recalculate the effective
intercepts masks when the vcpu is in guest-mode and either
the host or the guest intercept masks change.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   43 ++++++++++++++++++++++++++-----------------
 1 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index bff391e..05fe851 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -192,6 +192,26 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
+static void recalc_intercepts(struct vcpu_svm *svm)
+{
+	struct vmcb_control_area *c, *h;
+	struct nested_state *g;
+
+	if (!is_guest_mode(&svm->vcpu))
+		return;
+
+	c = &svm->vmcb->control;
+	h = &svm->nested.hsave->control;
+	g = &svm->nested;
+
+	c->intercept_cr_read = h->intercept_cr_read | g->intercept_cr_read;
+	c->intercept_cr_write = h->intercept_cr_write | g->intercept_cr_write;
+	c->intercept_dr_read = h->intercept_dr_read | g->intercept_dr_read;
+	c->intercept_dr_write = h->intercept_dr_write | g->intercept_dr_write;
+	c->intercept_exceptions = h->intercept_exceptions | g->intercept_exceptions;
+	c->intercept = h->intercept | g->intercept;
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -2272,23 +2292,6 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	/* We don't want to see VMMCALLs from a nested guest */
 	svm->vmcb->control.intercept &= ~(1ULL << INTERCEPT_VMMCALL);
 
-	/*
-	 * We don't want a nested guest to be more powerful than the guest, so
-	 * all intercepts are ORed
-	 */
-	svm->vmcb->control.intercept_cr_read |=
-		nested_vmcb->control.intercept_cr_read;
-	svm->vmcb->control.intercept_cr_write |=
-		nested_vmcb->control.intercept_cr_write;
-	svm->vmcb->control.intercept_dr_read |=
-		nested_vmcb->control.intercept_dr_read;
-	svm->vmcb->control.intercept_dr_write |=
-		nested_vmcb->control.intercept_dr_write;
-	svm->vmcb->control.intercept_exceptions |=
-		nested_vmcb->control.intercept_exceptions;
-
-	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
-
 	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
@@ -2301,6 +2304,12 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	/* Enter Guest-Mode */
 	enter_guest_mode(&svm->vcpu);
 
+	/*
+	 * Merge guest and host intercepts - must be called  with vcpu in
+	 * guest-mode to take affect here
+	 */
+	recalc_intercepts(svm);
+
 	svm->nested.vmcb = vmcb_gpa;
 
 	enable_gif(svm);
-- 
1.7.1


