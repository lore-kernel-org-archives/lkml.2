Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0GAVa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:30:56 -0400
Received: from kroah.org ([198.145.64.141]:33231 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933149Ab0GAVPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:22 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174301.990821922@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>
Subject: [183/200] KVM: SVM: Fix wrong interrupt injection in enable_irq_windows
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

The nested_svm_intr() function does not execute the vmexit
anymore. Therefore we may still be in the nested state after
that function ran. This patch changes the nested_svm_intr()
function to return wether the irq window could be enabled.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 8fe546547cf6857a9d984bfe2f2194910f3fc5d0)
---
 arch/x86/kvm/svm.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1402,16 +1402,17 @@ static int nested_svm_check_exception(st
 	return vmexit;
 }
 
-static inline int nested_svm_intr(struct vcpu_svm *svm)
+/* This function returns true if it is save to enable the irq window */
+static inline bool nested_svm_intr(struct vcpu_svm *svm)
 {
 	if (!is_nested(svm))
-		return 0;
+		return true;
 
 	if (!(svm->vcpu.arch.hflags & HF_VINTR_MASK))
-		return 0;
+		return true;
 
 	if (!(svm->vcpu.arch.hflags & HF_HIF_MASK))
-		return 0;
+		return false;
 
 	svm->vmcb->control.exit_code = SVM_EXIT_INTR;
 
@@ -1424,10 +1425,10 @@ static inline int nested_svm_intr(struct
 		 */
 		svm->nested.exit_required = true;
 		trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
-		return 1;
+		return false;
 	}
 
-	return 0;
+	return true;
 }
 
 static void *nested_svm_map(struct vcpu_svm *svm, u64 gpa, struct page **_page)
@@ -2591,13 +2592,11 @@ static void enable_irq_window(struct kvm
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	nested_svm_intr(svm);
-
 	/* In case GIF=0 we can't rely on the CPU to tell us when
 	 * GIF becomes 1, because that's a separate STGI/VMRUN intercept.
 	 * The next time we get that intercept, this function will be
 	 * called again though and we'll get the vintr intercept. */
-	if (gif_set(svm)) {
+	if (gif_set(svm) && nested_svm_intr(svm)) {
 		svm_set_vintr(svm);
 		svm_inject_irq(svm, 0x0);
 	}


