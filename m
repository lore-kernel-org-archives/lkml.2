Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0DVKdn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:33:43 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:19218
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753813Ab0DVKdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:39 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzz6d525hz32i2a8h87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBQ-01-039-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7/8] KVM: x86: Allow marking an exception as reinjected
Date: Thu, 22 Apr 2010 12:33:13 +0200
Message-ID: <1271932394-13968-8-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0184 (UTC) FILETIME=[398F9500:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds logic to kvm/x86 which allows to mark an
injected exception as reinjected. This allows to remove an
ugly hack from svm_complete_interrupts that prevented
exceptions from being reinjected at all in the nested case.
The hack was necessary because an reinjected exception into
the nested guest could cause a nested vmexit emulation. But
reinjected exceptions must not intercept. The downside of
the hack is that a exception that in injected could get
lost.
This patch fixes the problem and puts the code for it into
generic x86 files because. Nested-VMX will likely have the
same problem and could reuse the code.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_host.h |    6 +++++-
 arch/x86/kvm/svm.c              |   12 ++++++------
 arch/x86/kvm/vmx.c              |    3 ++-
 arch/x86/kvm/x86.c              |   23 +++++++++++++++++++----
 4 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 357573a..3f0007b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -312,6 +312,7 @@ struct kvm_vcpu_arch {
 	struct kvm_queued_exception {
 		bool pending;
 		bool has_error_code;
+		bool reinject;
 		u8 nr;
 		u32 error_code;
 	} exception;
@@ -514,7 +515,8 @@ struct kvm_x86_ops {
 	void (*set_irq)(struct kvm_vcpu *vcpu);
 	void (*set_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu, unsigned nr,
-				bool has_error_code, u32 error_code);
+				bool has_error_code, u32 error_code,
+				bool reinject);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu);
 	int (*nmi_allowed)(struct kvm_vcpu *vcpu);
 	bool (*get_nmi_mask)(struct kvm_vcpu *vcpu);
@@ -617,6 +619,8 @@ void kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr);
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
+void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr);
+void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code);
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long cr2,
 			   u32 error_code);
 bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 65fc114..30e49fe 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -338,7 +338,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 
 static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
-				bool has_error_code, u32 error_code)
+				bool has_error_code, u32 error_code,
+				bool reinject)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -346,7 +347,8 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
 	 * If we are within a nested VM we'd better #VMEXIT and let the guest
 	 * handle the exception
 	 */
-	if (nested_svm_check_exception(svm, nr, has_error_code, error_code))
+	if (!reinject &&
+	    nested_svm_check_exception(svm, nr, has_error_code, error_code))
 		return;
 
 	if (nr == BP_VECTOR && !svm_has(SVM_FEATURE_NRIP)) {
@@ -2918,8 +2920,6 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 		svm->vcpu.arch.nmi_injected = true;
 		break;
 	case SVM_EXITINTINFO_TYPE_EXEPT:
-		if (is_nested(svm))
-			break;
 		/*
 		 * In case of software exceptions, do not reinject the vector,
 		 * but re-execute the instruction instead. Rewind RIP first
@@ -2935,10 +2935,10 @@ static void svm_complete_interrupts(struct vcpu_svm *svm)
 		}
 		if (exitintinfo & SVM_EXITINTINFO_VALID_ERR) {
 			u32 err = svm->vmcb->control.exit_int_info_err;
-			kvm_queue_exception_e(&svm->vcpu, vector, err);
+			kvm_requeue_exception_e(&svm->vcpu, vector, err);
 
 		} else
-			kvm_queue_exception(&svm->vcpu, vector);
+			kvm_requeue_exception(&svm->vcpu, vector);
 		break;
 	case SVM_EXITINTINFO_TYPE_INTR:
 		kvm_queue_interrupt(&svm->vcpu, vector, false);
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index dc023bc..285fe1a 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -919,7 +919,8 @@ static void skip_emulated_instruction(struct kvm_vcpu *vcpu)
 }
 
 static void vmx_queue_exception(struct kvm_vcpu *vcpu, unsigned nr,
-				bool has_error_code, u32 error_code)
+				bool has_error_code, u32 error_code,
+				bool reinject)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 intr_info = nr | INTR_INFO_VALID_MASK;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c2c3c29..9c183cd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -265,7 +265,8 @@ static int exception_class(int vector)
 }
 
 static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
-		unsigned nr, bool has_error, u32 error_code)
+		unsigned nr, bool has_error, u32 error_code,
+		bool reinject)
 {
 	u32 prev_nr;
 	int class1, class2;
@@ -276,6 +277,7 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 		vcpu->arch.exception.has_error_code = has_error;
 		vcpu->arch.exception.nr = nr;
 		vcpu->arch.exception.error_code = error_code;
+		vcpu->arch.exception.reinject = true;
 		return;
 	}
 
@@ -304,10 +306,16 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcpu,
 
 void kvm_queue_exception(struct kvm_vcpu *vcpu, unsigned nr)
 {
-	kvm_multiple_exception(vcpu, nr, false, 0);
+	kvm_multiple_exception(vcpu, nr, false, 0, false);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception);
 
+void kvm_requeue_exception(struct kvm_vcpu *vcpu, unsigned nr)
+{
+	kvm_multiple_exception(vcpu, nr, false, 0, true);
+}
+EXPORT_SYMBOL_GPL(kvm_requeue_exception);
+
 void kvm_inject_page_fault(struct kvm_vcpu *vcpu, unsigned long addr,
 			   u32 error_code)
 {
@@ -324,10 +332,16 @@ EXPORT_SYMBOL_GPL(kvm_inject_nmi);
 
 void kvm_queue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
 {
-	kvm_multiple_exception(vcpu, nr, true, error_code);
+	kvm_multiple_exception(vcpu, nr, true, error_code, false);
 }
 EXPORT_SYMBOL_GPL(kvm_queue_exception_e);
 
+void kvm_requeue_exception_e(struct kvm_vcpu *vcpu, unsigned nr, u32 error_code)
+{
+	kvm_multiple_exception(vcpu, nr, true, error_code, true);
+}
+EXPORT_SYMBOL_GPL(kvm_requeue_exception_e);
+
 /*
  * Checks if cpl <= required_cpl; if true, return true.  Otherwise queue
  * a #GP and return false.
@@ -4404,7 +4418,8 @@ static void inject_pending_event(struct kvm_vcpu *vcpu)
 					vcpu->arch.exception.error_code);
 		kvm_x86_ops->queue_exception(vcpu, vcpu->arch.exception.nr,
 					  vcpu->arch.exception.has_error_code,
-					  vcpu->arch.exception.error_code);
+					  vcpu->arch.exception.error_code,
+					  vcpu->arch.exception.reinject);
 		return;
 	}
 
-- 
1.7.0.4


