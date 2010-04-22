Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab0DVUir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:38:47 -0400
Received: from kroah.org ([198.145.64.141]:37467 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab0DVT2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:07 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.021005075@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [052/197] KVM: x86 emulator: Add Virtual-8086 mode of emulation
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Gleb Natapov <gleb@redhat.com>

commit a0044755679f3e761b8b95995e5f2db2b7efd0f6 upstream

For some instructions CPU behaves differently for real-mode and
virtual 8086. Let emulator know which mode cpu is in, so it will
not poke into vcpu state directly.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/kvm_emulate.h |    1 +
 arch/x86/kvm/emulate.c             |   14 +++++++-------
 arch/x86/kvm/x86.c                 |    3 ++-
 3 files changed, 10 insertions(+), 8 deletions(-)

--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -168,6 +168,7 @@ struct x86_emulate_ctxt {
 
 /* Execution mode, passed to the emulator. */
 #define X86EMUL_MODE_REAL     0	/* Real mode.             */
+#define X86EMUL_MODE_VM86     1	/* Virtual 8086 mode.     */
 #define X86EMUL_MODE_PROT16   2	/* 16-bit protected mode. */
 #define X86EMUL_MODE_PROT32   4	/* 32-bit protected mode. */
 #define X86EMUL_MODE_PROT64   8	/* 64-bit (long) mode.    */
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -895,6 +895,7 @@ x86_decode_insn(struct x86_emulate_ctxt
 
 	switch (mode) {
 	case X86EMUL_MODE_REAL:
+	case X86EMUL_MODE_VM86:
 	case X86EMUL_MODE_PROT16:
 		def_op_bytes = def_ad_bytes = 2;
 		break;
@@ -1453,7 +1454,7 @@ emulate_syscall(struct x86_emulate_ctxt
 
 	/* syscall is not available in real mode */
 	if (c->lock_prefix || ctxt->mode == X86EMUL_MODE_REAL
-		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE))
+	    || ctxt->mode == X86EMUL_MODE_VM86)
 		return -1;
 
 	setup_syscalls_segments(ctxt, &cs, &ss);
@@ -1505,9 +1506,8 @@ emulate_sysenter(struct x86_emulate_ctxt
 	if (c->lock_prefix)
 		return -1;
 
-	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL ||
-		!(ctxt->vcpu->arch.cr0 & X86_CR0_PE)) {
+	/* inject #GP if in real mode */
+	if (ctxt->mode == X86EMUL_MODE_REAL) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
@@ -1571,9 +1571,9 @@ emulate_sysexit(struct x86_emulate_ctxt
 	if (c->lock_prefix)
 		return -1;
 
-	/* inject #GP if in real mode or paging is disabled */
-	if (ctxt->mode == X86EMUL_MODE_REAL
-		|| !(ctxt->vcpu->arch.cr0 & X86_CR0_PE)) {
+	/* inject #GP if in real mode or Virtual 8086 mode */
+	if (ctxt->mode == X86EMUL_MODE_REAL ||
+	    ctxt->mode == X86EMUL_MODE_VM86) {
 		kvm_inject_gp(ctxt->vcpu, 0);
 		return -1;
 	}
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2828,8 +2828,9 @@ int emulate_instruction(struct kvm_vcpu
 		vcpu->arch.emulate_ctxt.vcpu = vcpu;
 		vcpu->arch.emulate_ctxt.eflags = kvm_x86_ops->get_rflags(vcpu);
 		vcpu->arch.emulate_ctxt.mode =
+			(!(vcpu->arch.cr0 & X86_CR0_PE)) ? X86EMUL_MODE_REAL :
 			(vcpu->arch.emulate_ctxt.eflags & X86_EFLAGS_VM)
-			? X86EMUL_MODE_REAL : cs_l
+			? X86EMUL_MODE_VM86 : cs_l
 			? X86EMUL_MODE_PROT64 :	cs_db
 			? X86EMUL_MODE_PROT32 : X86EMUL_MODE_PROT16;
 


