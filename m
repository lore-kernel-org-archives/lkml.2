Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0DVKdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:33:37 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:16464 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab0DVKdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:33:32 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzab9bhzz1202hzzz32i87h2a8h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L19XBL-02-0SH-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/8] KVM: SVM: Sync cr0 and cr3 to kvm state before nested handling
Date: Thu, 22 Apr 2010 12:33:09 +0200
Message-ID: <1271932394-13968-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 Apr 2010 10:33:19.0012 (UTC) FILETIME=[39755640:01CAE207]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch syncs cr0 and cr3 from the vmcb to the kvm state
before nested intercept handling is done. This allows to
simplify the vmexit path.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c480d7f..5ad9d80 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1799,10 +1799,7 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
 	nested_vmcb->save.idtr   = vmcb->save.idtr;
 	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
-	if (npt_enabled)
-		nested_vmcb->save.cr3    = vmcb->save.cr3;
-	else
-		nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
+	nested_vmcb->save.cr3    = svm->vcpu.arch.cr3;
 	nested_vmcb->save.cr2    = vmcb->save.cr2;
 	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
 	nested_vmcb->save.rflags = vmcb->save.rflags;
@@ -2641,6 +2638,11 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(exit_code, vcpu);
 
+	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR0_MASK))
+		vcpu->arch.cr0 = svm->vmcb->save.cr0;
+	if (npt_enabled)
+		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+
 	if (unlikely(svm->nested.exit_required)) {
 		nested_svm_vmexit(svm);
 		svm->nested.exit_required = false;
@@ -2668,11 +2670,6 @@ static int handle_exit(struct kvm_vcpu *vcpu)
 
 	svm_complete_interrupts(svm);
 
-	if (!(svm->vmcb->control.intercept_cr_write & INTERCEPT_CR0_MASK))
-		vcpu->arch.cr0 = svm->vmcb->save.cr0;
-	if (npt_enabled)
-		vcpu->arch.cr3 = svm->vmcb->save.cr3;
-
 	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
 		kvm_run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		kvm_run->fail_entry.hardware_entry_failure_reason
-- 
1.7.0.4


