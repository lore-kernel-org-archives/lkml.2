Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab0KXSTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 13:19:01 -0500
Received: from db3ehsobe004.messaging.microsoft.com ([213.199.154.142]:55406
	"EHLO DB3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106Ab0KXSS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 13:18:56 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzbb2cKzz1202hzz8275bhz32i691h668h67dh685h63h)
X-Spam-TCS-SCL: 2:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LCEIV0-01-381-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 9/9] KVM: SVM: Remove nested sel_cr0_write handling code
Date: Wed, 24 Nov 2010 19:18:35 +0100
Message-ID: <1290622715-8382-10-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all the old code which handled the nested
selective cr0 write intercepts. This code was only in place
as a work-around until the instruction emulator is capable
of doing the same. This is the case with this patch-set and
so the code can be removed.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   52 +---------------------------------------------------
 1 files changed, 1 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a2c513d..b34e905 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -89,14 +89,6 @@ struct nested_state {
 	/* A VMEXIT is required but not yet emulated */
 	bool exit_required;
 
-	/*
-	 * If we vmexit during an instruction emulation we need this to restore
-	 * the l1 guest rip after the emulation
-	 */
-	unsigned long vmexit_rip;
-	unsigned long vmexit_rsp;
-	unsigned long vmexit_rax;
-
 	/* cache for intercepts of the guest */
 	u16 intercept_cr_read;
 	u16 intercept_cr_write;
@@ -1233,31 +1225,6 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (is_nested(svm)) {
-		/*
-		 * We are here because we run in nested mode, the host kvm
-		 * intercepts cr0 writes but the l1 hypervisor does not.
-		 * But the L1 hypervisor may intercept selective cr0 writes.
-		 * This needs to be checked here.
-		 */
-		unsigned long old, new;
-
-		/* Remove bits that would trigger a real cr0 write intercept */
-		old = vcpu->arch.cr0 & SVM_CR0_SELECTIVE_MASK;
-		new = cr0 & SVM_CR0_SELECTIVE_MASK;
-
-		if (old == new) {
-			/* cr0 write with ts and mp unchanged */
-			svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
-			if (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE) {
-				svm->nested.vmexit_rip = kvm_rip_read(vcpu);
-				svm->nested.vmexit_rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
-				svm->nested.vmexit_rax = kvm_register_read(vcpu, VCPU_REGS_RAX);
-				return;
-			}
-		}
-	}
-
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
@@ -2546,23 +2513,6 @@ static int emulate_on_interception(struct vcpu_svm *svm)
 	return emulate_instruction(&svm->vcpu, 0, 0, 0) == EMULATE_DONE;
 }
 
-static int cr0_write_interception(struct vcpu_svm *svm)
-{
-	struct kvm_vcpu *vcpu = &svm->vcpu;
-	int r;
-
-	r = emulate_instruction(&svm->vcpu, 0, 0, 0);
-
-	if (svm->nested.vmexit_rip) {
-		kvm_register_write(vcpu, VCPU_REGS_RIP, svm->nested.vmexit_rip);
-		kvm_register_write(vcpu, VCPU_REGS_RSP, svm->nested.vmexit_rsp);
-		kvm_register_write(vcpu, VCPU_REGS_RAX, svm->nested.vmexit_rax);
-		svm->nested.vmexit_rip = 0;
-	}
-
-	return r == EMULATE_DONE;
-}
-
 static int cr8_write_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
@@ -2826,7 +2776,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR4]			= emulate_on_interception,
 	[SVM_EXIT_READ_CR8]			= emulate_on_interception,
 	[SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR0]			= cr0_write_interception,
+	[SVM_EXIT_WRITE_CR0]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR3]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR8]			= cr8_write_interception,
-- 
1.7.1


