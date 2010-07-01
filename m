Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292Ab0GAVT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:19:28 -0400
Received: from kroah.org ([198.145.64.141]:33207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933134Ab0GAVPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:16 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:01 2010
Message-Id: <20100701174301.645111514@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [179/200] KVM: SVM: Fix schedule-while-atomic on nested exception handling
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

Move the actual vmexit routine out of code that runs with
irqs and preemption disabled.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit b8e88bc8ffba5fe53fb8d8a0a4be3bbcffeebe56)
---
 arch/x86/kvm/svm.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -129,6 +129,7 @@ static void svm_flush_tlb(struct kvm_vcp
 static void svm_complete_interrupts(struct vcpu_svm *svm);
 
 static int nested_svm_exit_handled(struct vcpu_svm *svm);
+static int nested_svm_intercept(struct vcpu_svm *svm);
 static int nested_svm_vmexit(struct vcpu_svm *svm);
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code);
@@ -1384,6 +1385,8 @@ static int nested_svm_check_permissions(
 static int nested_svm_check_exception(struct vcpu_svm *svm, unsigned nr,
 				      bool has_error_code, u32 error_code)
 {
+	int vmexit;
+
 	if (!is_nested(svm))
 		return 0;
 
@@ -1392,7 +1395,11 @@ static int nested_svm_check_exception(st
 	svm->vmcb->control.exit_info_1 = error_code;
 	svm->vmcb->control.exit_info_2 = svm->vcpu.arch.cr2;
 
-	return nested_svm_exit_handled(svm);
+	vmexit = nested_svm_intercept(svm);
+	if (vmexit == NESTED_EXIT_DONE)
+		svm->nested.exit_required = true;
+
+	return vmexit;
 }
 
 static inline int nested_svm_intr(struct vcpu_svm *svm)
@@ -1521,7 +1528,7 @@ static int nested_svm_exit_special(struc
 /*
  * If this function returns true, this #vmexit was already handled
  */
-static int nested_svm_exit_handled(struct vcpu_svm *svm)
+static int nested_svm_intercept(struct vcpu_svm *svm)
 {
 	u32 exit_code = svm->vmcb->control.exit_code;
 	int vmexit = NESTED_EXIT_HOST;
@@ -1567,9 +1574,17 @@ static int nested_svm_exit_handled(struc
 	}
 	}
 
-	if (vmexit == NESTED_EXIT_DONE) {
+	return vmexit;
+}
+
+static int nested_svm_exit_handled(struct vcpu_svm *svm)
+{
+	int vmexit;
+
+	vmexit = nested_svm_intercept(svm);
+
+	if (vmexit == NESTED_EXIT_DONE)
 		nested_svm_vmexit(svm);
-	}
 
 	return vmexit;
 }


