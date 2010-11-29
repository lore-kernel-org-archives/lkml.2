Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0K2PjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:39:17 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:20023 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0K2Pif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:38:35 -0500
X-SpamScore: 5
X-BigFish: VPS5(z1039ozbb2cKzz1202hzz8275bhz32i691h668h67dh63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCNKS3-01-73U-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/3] KVM: SVM: Make Use of the generic guest-mode functions
Date: Mon, 29 Nov 2010 16:38:09 +0100
Message-ID: <1291045090-2714-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
References: <1291045090-2714-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces the is_nested logic in the SVM module
with the generic notion of guest-mode.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   44 +++++++++++++++++++++-----------------------
 1 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 2fd2f4d..3376fca 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -192,11 +192,6 @@ static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 	return container_of(vcpu, struct vcpu_svm, vcpu);
 }
 
-static inline bool is_nested(struct vcpu_svm *svm)
-{
-	return svm->nested.vmcb;
-}
-
 static inline void enable_gif(struct vcpu_svm *svm)
 {
 	svm->vcpu.arch.hflags |= HF_GIF_MASK;
@@ -727,7 +722,7 @@ static void svm_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 g_tsc_offset = 0;
 
-	if (is_nested(svm)) {
+	if (kvm_vcpu_is_gm(vcpu)) {
 		g_tsc_offset = svm->vmcb->control.tsc_offset -
 			       svm->nested.hsave->control.tsc_offset;
 		svm->nested.hsave->control.tsc_offset = offset;
@@ -741,7 +736,7 @@ static void svm_adjust_tsc_offset(struct kvm_vcpu *vcpu, s64 adjustment)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.tsc_offset += adjustment;
-	if (is_nested(svm))
+	if (kvm_vcpu_is_gm(vcpu))
 		svm->nested.hsave->control.tsc_offset += adjustment;
 }
 
@@ -1209,7 +1204,7 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	if (gcr0 == *hcr0 && svm->vcpu.fpu_active) {
 		vmcb->control.intercept_cr_read &= ~INTERCEPT_CR0_MASK;
 		vmcb->control.intercept_cr_write &= ~INTERCEPT_CR0_MASK;
-		if (is_nested(svm)) {
+		if (kvm_vcpu_is_gm(&svm->vcpu)) {
 			struct vmcb *hsave = svm->nested.hsave;
 
 			hsave->control.intercept_cr_read  &= ~INTERCEPT_CR0_MASK;
@@ -1220,7 +1215,7 @@ static void update_cr0_intercept(struct vcpu_svm *svm)
 	} else {
 		svm->vmcb->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
 		svm->vmcb->control.intercept_cr_write |= INTERCEPT_CR0_MASK;
-		if (is_nested(svm)) {
+		if (kvm_vcpu_is_gm(&svm->vcpu)) {
 			struct vmcb *hsave = svm->nested.hsave;
 
 			hsave->control.intercept_cr_read |= INTERCEPT_CR0_MASK;
@@ -1233,7 +1228,7 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (is_nested(svm)) {
+	if (kvm_vcpu_is_gm(vcpu)) {
 		/*
 		 * We are here because we run in nested mode, the host kvm
 		 * intercepts cr0 writes but the l1 hypervisor does not.
@@ -1471,7 +1466,7 @@ static void svm_fpu_activate(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 excp;
 
-	if (is_nested(svm)) {
+	if (kvm_vcpu_is_gm(vcpu)) {
 		u32 h_excp, n_excp;
 
 		h_excp  = svm->nested.hsave->control.intercept_exceptions;
@@ -1700,7 +1695,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 {
 	int vmexit;
 
-	if (!is_nested(svm))
+	if (!kvm_vcpu_is_gm(&svm->vcpu))
 		return 0;
 
 	svm->vmcb->control.exit_code = SVM_EXIT_EXCP_BASE + nr;
@@ -1718,7 +1713,7 @@ static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 /* This function returns true if it is save to enable the irq window */
 static inline bool nested_svm_intr(struct vcpu_svm *svm)
 {
-	if (!is_nested(svm))
+	if (!kvm_vcpu_is_gm(&svm->vcpu))
 		return true;
 
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
@@ -1757,7 +1752,7 @@ static inline bool nested_svm_intr(struct vcpu_svm *svm)
 /* This function returns true if it is save to enable the nmi window */
 static inline bool nested_svm_nmi(struct vcpu_svm *svm)
 {
-	if (!is_nested(svm))
+	if (!kvm_vcpu_is_gm(&svm->vcpu))
 		return true;
 
 	if (!(svm->nested.intercept & (1ULL << INTERCEPT_NMI)))
@@ -1994,7 +1989,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_vmcb)
 		return 1;
 
-	/* Exit nested SVM mode */
+	/* Exit Guest-Mode */
+	kvm_vcpu_leave_gm(&svm->vcpu);
 	svm->nested.vmcb = 0;
 
 	/* Give the current vmcb to the guest */
@@ -2302,7 +2298,9 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 
 	nested_svm_unmap(page);
 
-	/* nested_vmcb is our indicator if nested SVM is activated */
+	/* Enter Guest-Mode */
+	kvm_vcpu_enter_gm(&svm->vcpu);
+
 	svm->nested.vmcb = vmcb_gpa;
 
 	enable_gif(svm);
@@ -2588,7 +2586,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, unsigned ecx, u64 *data)
 	case MSR_IA32_TSC: {
 		u64 tsc_offset;
 
-		if (is_nested(svm))
+		if (kvm_vcpu_is_gm(vcpu))
 			tsc_offset = svm->nested.hsave->control.tsc_offset;
 		else
 			tsc_offset = svm->vmcb->control.tsc_offset;
@@ -3002,7 +3000,7 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 		return 1;
 	}
 
-	if (is_nested(svm)) {
+	if (kvm_vcpu_is_gm(vcpu)) {
 		int vmexit;
 
 		trace_kvm_nested_vmexit(svm->vmcb->save.rip, exit_code,
@@ -3109,7 +3107,7 @@ static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+	if (kvm_vcpu_is_gm(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
 	if (irr == -1)
@@ -3163,7 +3161,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu)
 
 	ret = !!(vmcb->save.rflags & X86_EFLAGS_IF);
 
-	if (is_nested(svm))
+	if (kvm_vcpu_is_gm(vcpu))
 		return ret && !(svm->vcpu.arch.hflags & HF_VINTR_MASK);
 
 	return ret;
@@ -3220,7 +3218,7 @@ static inline void sync_cr8_to_lapic(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+	if (kvm_vcpu_is_gm(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
 	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
@@ -3234,7 +3232,7 @@ static inline void sync_lapic_to_cr8(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
-	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+	if (kvm_vcpu_is_gm(vcpu) && (vcpu->arch.hflags & HF_VINTR_MASK))
 		return;
 
 	cr8 = kvm_get_cr8(vcpu);
@@ -3614,7 +3612,7 @@ static void svm_fpu_deactivate(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	svm->vmcb->control.intercept_exceptions |= 1 << NM_VECTOR;
-	if (is_nested(svm))
+	if (kvm_vcpu_is_gm(vcpu))
 		svm->nested.hsave->control.intercept_exceptions |= 1 << NM_VECTOR;
 	update_cr0_intercept(svm);
 }
-- 
1.7.1


