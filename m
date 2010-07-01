Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933081Ab0GAVBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:01:30 -0400
Received: from kroah.org ([198.145.64.141]:47916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868Ab0GAUvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:25 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:38 2010
Message-Id: <20100701173438.875324823@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 143/164] KVM: SVM: Dont sync nested cr8 to lapic and back
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

This patch makes syncing of the guest tpr to the lapic
conditional on !nested. Otherwise a nested guest using the
TPR could freeze the guest.
Another important change this patch introduces is that the
cr8 intercept bits are no longer ORed at vmrun emulation if
the guest sets VINTR_MASKING in its VMCB. The reason is that
nested cr8 accesses need alway be handled by the nested
hypervisor because they change the shadow version of the
tpr.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
(cherry picked from commit 88ab24adc7142506c8583ac36a34fa388300b750)
---
 arch/x86/kvm/svm.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1805,21 +1805,6 @@ static bool nested_svm_vmrun(struct vcpu
 	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
 	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
 
-	/* We don't want a nested guest to be more powerful than the guest,
-	   so all intercepts are ORed */
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
 	svm->nested.vmcb_msrpm = nested_vmcb->control.msrpm_base_pa;
 
 	/* cache intercepts */
@@ -1837,6 +1822,28 @@ static bool nested_svm_vmrun(struct vcpu
 	else
 		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
+	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
+		/* We only want the cr8 intercept bits of the guest */
+		svm->vmcb->control.intercept_cr_read &= ~INTERCEPT_CR8_MASK;
+		svm->vmcb->control.intercept_cr_write &= ~INTERCEPT_CR8_MASK;
+	}
+
+	/* We don't want a nested guest to be more powerful than the guest,
+	   so all intercepts are ORed */
+	svm->vmcb->control.intercept_cr_read |=
+		nested_vmcb->control.intercept_cr_read;
+	svm->vmcb->control.intercept_cr_write |=
+		nested_vmcb->control.intercept_cr_write;
+	svm->vmcb->control.intercept_dr_read |=
+		nested_vmcb->control.intercept_dr_read;
+	svm->vmcb->control.intercept_dr_write |=
+		nested_vmcb->control.intercept_dr_write;
+	svm->vmcb->control.intercept_exceptions |=
+		nested_vmcb->control.intercept_exceptions;
+
+	svm->vmcb->control.intercept |= nested_vmcb->control.intercept;
+
+	svm->vmcb->control.lbr_ctl = nested_vmcb->control.lbr_ctl;
 	svm->vmcb->control.int_vector = nested_vmcb->control.int_vector;
 	svm->vmcb->control.int_state = nested_vmcb->control.int_state;
 	svm->vmcb->control.tsc_offset += nested_vmcb->control.tsc_offset;
@@ -2500,6 +2507,9 @@ static void update_cr8_intercept(struct
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	if (irr == -1)
 		return;
 
@@ -2603,6 +2613,9 @@ static inline void sync_cr8_to_lapic(str
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR8_MASK)) {
 		int cr8 = svm->vmcb->control.int_ctl & V_TPR_MASK;
 		kvm_set_cr8(vcpu, cr8);
@@ -2614,6 +2627,9 @@ static inline void sync_lapic_to_cr8(str
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u64 cr8;
 
+	if (is_nested(svm) && (vcpu->arch.hflags & HF_VINTR_MASK))
+		return;
+
 	cr8 = kvm_get_cr8(vcpu);
 	svm->vmcb->control.int_ctl &= ~V_TPR_MASK;
 	svm->vmcb->control.int_ctl |= cr8 & V_TPR_MASK;


