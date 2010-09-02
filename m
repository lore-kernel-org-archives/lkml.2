Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0IBPb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:31:29 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:42092
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755771Ab0IBPb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:31:26 -0400
X-SpamScore: -4
X-BigFish: VS-4(zz1419Mzz1202hzz8275bh8275dhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L84LPJ-01-729-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 2/3] KVM: SVM: Restore correct registers after sel_cr0 intercept emulation
Date: Thu, 2 Sep 2010 17:29:46 +0200
Message-ID: <1283441387-7378-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
References: <1283441387-7378-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements restoring of the correct rip, rsp, and
rax after the svm emulation in KVM injected a selective_cr0
write intercept into the guest hypervisor. The problem was
that the vmexit is emulated in the instruction emulation
which later commits the registers right after the write-cr0
instruction. So the l1 guest will continue to run with the
l2 rip, rsp and rax resulting in unpredictable behavior.

This patch is not the final word, it is just an easy patch
to fix the issue. The real fix will be done when the
instruction emulator is made aware of nested virtualization.
Until this is done this patch fixes the issue and provides
an easy way to fix this in -stable too.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 55743ab..ecd4e58 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -88,6 +88,14 @@ struct nested_state {
 	/* A VMEXIT is required but not yet emulated */
 	bool exit_required;
 
+	/*
+	 * If we vmexit during an instruction emulation we need this to restore
+	 * the l1 guest rip after the emulation
+	 */
+	unsigned long vmexit_rip;
+	unsigned long vmexit_rsp;
+	unsigned long vmexit_rax;
+
 	/* cache for intercepts of the guest */
 	u16 intercept_cr_read;
 	u16 intercept_cr_write;
@@ -1213,8 +1221,12 @@ static void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 		if (old == new) {
 			/* cr0 write with ts and mp unchanged */
 			svm->vmcb->control.exit_code = SVM_EXIT_CR0_SEL_WRITE;
-			if (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE)
+			if (nested_svm_exit_handled(svm) == NESTED_EXIT_DONE) {
+				svm->nested.vmexit_rip = kvm_rip_read(vcpu);
+				svm->nested.vmexit_rsp = kvm_register_read(vcpu, VCPU_REGS_RSP);
+				svm->nested.vmexit_rax = kvm_register_read(vcpu, VCPU_REGS_RAX);
 				return;
+			}
 		}
 	}
 
@@ -2430,6 +2442,23 @@ static int emulate_on_interception(struct vcpu_svm *svm)
 	return emulate_instruction(&svm->vcpu, 0, 0, 0) == EMULATE_DONE;
 }
 
+static int cr0_write_interception(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	int r;
+
+	r = emulate_instruction(&svm->vcpu, 0, 0, 0);
+
+	if (svm->nested.vmexit_rip) {
+		kvm_register_write(vcpu, VCPU_REGS_RIP, svm->nested.vmexit_rip);
+		kvm_register_write(vcpu, VCPU_REGS_RSP, svm->nested.vmexit_rsp);
+		kvm_register_write(vcpu, VCPU_REGS_RAX, svm->nested.vmexit_rax);
+		svm->nested.vmexit_rip = 0;
+	}
+
+	return r == EMULATE_DONE;
+}
+
 static int cr8_write_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
@@ -2692,7 +2721,7 @@ static int (*svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_READ_CR4]			= emulate_on_interception,
 	[SVM_EXIT_READ_CR8]			= emulate_on_interception,
 	[SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR0]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR0]			= cr0_write_interception,
 	[SVM_EXIT_WRITE_CR3]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR8]			= cr8_write_interception,
-- 
1.7.0.4


