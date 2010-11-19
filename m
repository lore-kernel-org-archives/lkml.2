Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0KSWOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:14:53 -0500
Received: from kroah.org ([198.145.64.141]:52931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757951Ab0KSWEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:16 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 14:01:24 2010
Message-Id: <20101119220124.306500596@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 14:00:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joerg Roedel <joerg.roedel@amd.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [26/66] KVM: SVM: Restore correct registers after sel_cr0 intercept emulation
In-Reply-To: <20101119220309.GA15562@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit cda0008299a06f0d7218c6037c3c02d7a865e954 upstream.

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

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/svm.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

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
@@ -1206,8 +1214,12 @@ static void svm_set_cr0(struct kvm_vcpu
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
 
@@ -2399,6 +2411,23 @@ static int emulate_on_interception(struc
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
@@ -2672,7 +2701,7 @@ static int (*svm_exit_handlers[])(struct
 	[SVM_EXIT_READ_CR4]			= emulate_on_interception,
 	[SVM_EXIT_READ_CR8]			= emulate_on_interception,
 	[SVM_EXIT_CR0_SEL_WRITE]		= emulate_on_interception,
-	[SVM_EXIT_WRITE_CR0]			= emulate_on_interception,
+	[SVM_EXIT_WRITE_CR0]			= cr0_write_interception,
 	[SVM_EXIT_WRITE_CR3]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR4]			= emulate_on_interception,
 	[SVM_EXIT_WRITE_CR8]			= cr8_write_interception,


