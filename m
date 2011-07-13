Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab1GMPlF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:41:05 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:7126 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab1GMPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:41:03 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LOA37B-02-9JJ-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 6/7] KVM: SVM: Rework hflags handling
Date: Wed, 13 Jul 2011 17:32:24 +0200
Message-ID: <1310571145-28930-7-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
References: <1310571145-28930-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joro@8bytes.org>

This patch moves the unsetting of the hflags used for
nesting into the #vmexit path instead of doing everything in
the vmrun path.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/kvm/svm.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f2cca2c..c83315a 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2256,6 +2256,8 @@ static int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	mark_all_dirty(svm->vmcb);
 
+	svm->vcpu.arch.hflags &=  ~(HF_VINTR_MASK | HF_HIF_MASK);
+
 	nested_svm_unmap(page);
 
 	nested_svm_uninit_mmu_context(&svm->vcpu);
@@ -2317,6 +2319,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	struct vmcb *nested_vmcb;
 	struct page *page;
 	u64 vmcb_gpa;
+	u64 rflags;
 
 	vmcb_gpa = svm->vmcb->save.rax;
 
@@ -2350,6 +2353,8 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	kvm_clear_exception_queue(&svm->vcpu);
 	kvm_clear_interrupt_queue(&svm->vcpu);
 
+	rflags = kvm_get_rflags(&svm->vcpu);
+
 	/*
 	 * Save the old vmcb, so we don't need to pick what we save, but can
 	 * restore everything when a VMEXIT occurs
@@ -2357,7 +2362,7 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	svm->host_vmcb->save.efer   = svm->vcpu.arch.efer;
 	svm->host_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	svm->host_vmcb->save.cr4    = svm->vcpu.arch.cr4;
-	svm->host_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
+	svm->host_vmcb->save.rflags = rflags;
 	svm->host_vmcb->save.rax    = svm->vcpu.arch.regs[VCPU_REGS_RAX];
 	svm->host_vmcb->save.rsp    = svm->vcpu.arch.regs[VCPU_REGS_RSP];
 	svm->host_vmcb->save.rip    = svm->vcpu.arch.regs[VCPU_REGS_RIP];
@@ -2365,17 +2370,11 @@ static bool nested_svm_vmrun(struct vcpu_svm *svm)
 	if (!npt_enabled)
 		svm->host_vmcb->save.cr3 = kvm_read_cr3(&svm->vcpu);
 
-	if (kvm_get_rflags(&svm->vcpu) & X86_EFLAGS_IF)
-		svm->vcpu.arch.hflags |= HF_HIF_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_HIF_MASK;
+	svm->vcpu.arch.hflags |= rflags & X86_EFLAGS_IF ? HF_HIF_MASK   : 0;
 
-	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK)
+	if (nested_vmcb->control.int_ctl & V_INTR_MASKING_MASK) {
 		svm->vcpu.arch.hflags |= HF_VINTR_MASK;
-	else
-		svm->vcpu.arch.hflags &= ~HF_VINTR_MASK;
 
-	if (svm->vcpu.arch.hflags & HF_VINTR_MASK) {
 		/* We only want the cr8 intercept bits of the guest */
 		clr_cr_intercept(svm, INTERCEPT_CR8_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR8_WRITE);
-- 
1.7.4.1


