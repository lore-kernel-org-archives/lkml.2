Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab0K3REW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:04:22 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:21077
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab0K3REU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:04:20 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCPJEW-02-CCP-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 4/6] KVM: SVM: Add manipulation functions for exception intercepts
Date: Tue, 30 Nov 2010 18:03:59 +0100
Message-ID: <1291136641-4874-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
References: <1291136641-4874-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch wraps changes to the exception intercepts of SVM
into seperate functions to abstract nested-svm better and
prepare the implementation of the vmcb-clean-bits feature.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   58 ++++++++++++++++++++++++++--------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 5250a2b..783142e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -259,6 +259,24 @@ static inline void clr_dr_intercept(struct vcpu_svm *svm, int bit)
 	recalc_intercepts(svm);
 }
 
+static inline void set_exception_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_exceptions |= (1U << bit);
+
+	recalc_intercepts(svm);
+}
+
+static inline void clr_exception_intercept(struct vcpu_svm *svm, int bit)
+{
+	struct vmcb *vmcb = get_host_vmcb(svm);
+
+	vmcb->control.intercept_exceptions &= ~(1U << bit);
+
+	recalc_intercepts(svm);
+}
+
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -840,10 +858,9 @@ static void init_vmcb(struct vcpu_svm *svm)
 	set_dr_intercept(svm, INTERCEPT_DR6_WRITE);
 	set_dr_intercept(svm, INTERCEPT_DR7_WRITE);
 
-	control->intercept_exceptions = (1 << PF_VECTOR) |
-					(1 << UD_VECTOR) |
-					(1 << MC_VECTOR);
-
+	set_exception_intercept(svm, PF_VECTOR);
+	set_exception_intercept(svm, UD_VECTOR);
+	set_exception_intercept(svm, MC_VECTOR);
 
 	control->intercept =	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
@@ -920,7 +937,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 		control->nested_ctl = 1;
 		control->intercept &= ~((1ULL << INTERCEPT_TASK_SWITCH) |
 					(1ULL << INTERCEPT_INVLPG));
-		control->intercept_exceptions &= ~(1 << PF_VECTOR);
+		clr_exception_intercept(svm, PF_VECTOR);
 		clr_cr_intercept(svm, INTERCEPT_CR3_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
 		save->g_pat = 0x0007040600070406ULL;
@@ -1381,20 +1398,18 @@ static void update_db_intercept(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->control.intercept_exceptions &=
-		~((1 << DB_VECTOR) | (1 << BP_VECTOR));
+	clr_exception_intercept(svm, DB_VECTOR);
+	clr_exception_intercept(svm, BP_VECTOR);
 
 	if (svm->nmi_singlestep)
-		svm->vmcb->control.intercept_exceptions |= (1 << DB_VECTOR);
+		set_exception_intercept(svm, DB_VECTOR);
 
 	if (vcpu->guest_debug & KVM_GUESTDBG_ENABLE) {
 		if (vcpu->guest_debug &
 		    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP))
-			svm->vmcb->control.intercept_exceptions |=
-				1 << DB_VECTOR;
+			set_exception_intercept(svm, DB_VECTOR);
 		if (vcpu->guest_debug & KVM_GUESTDBG_USE_SW_BP)
-			svm->vmcb->control.intercept_exceptions |=
-				1 << BP_VECTOR;
+			set_exception_intercept(svm, BP_VECTOR);
 	} else
 		vcpu->guest_debug = 0;
 }
@@ -1515,21 +1530,8 @@ static int ud_interception(struct vcpu_svm *svm)
 static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	u32 excp;
-
-	if (is_guest_mode(vcpu)) {
-		u32 h_excp, n_excp;
 
-		h_excp  = svm->nested.hsave->control.intercept_exceptions;
-		n_excp  = svm->nested.intercept_exceptions;
-		h_excp &= ~(1 << NM_VECTOR);
-		excp    = h_excp | n_excp;
-	} else {
-		excp  = svm->vmcb->control.intercept_exceptions;
-		excp &= ~(1 << NM_VECTOR);
-	}
-
-	svm->vmcb->control.intercept_exceptions = excp;
+	clr_exception_intercept(svm, NM_VECTOR);
 
 	svm->vcpu.fpu_active = 1;
 	update_cr0_intercept(svm);
@@ -3635,9 +3637,7 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->control.intercept_exceptions |= 1 << NM_VECTOR;
-	if (is_guest_mode(vcpu))
-		svm->nested.hsave->control.intercept_exceptions |= 1 << NM_VECTOR;
+	set_exception_intercept(svm, NM_VECTOR);
 	update_cr0_intercept(svm);
 }
 
-- 
1.7.1


