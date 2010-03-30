Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab0CaAiH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:38:07 -0400
Received: from kroah.org ([198.145.64.141]:48525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866Ab0C3XJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:57 2010
Message-Id: <20100330224957.333713176@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [26/45] KVM: x86 emulator: limit instructions to 15 bytes
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

commit eb3c79e64a70fb8f7473e30fa07e89c1ecc2c9bb upstream

[ <cebbert@redhat.com>: backport to 2.6.27 ]

While we are never normally passed an instruction that exceeds 15 bytes,
smp games can cause us to attempt to interpret one, which will cause
large latencies in non-preempt hosts.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86_emulate.c        |    5 ++++-
 include/asm-x86/kvm_x86_emulate.h |    2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -581,6 +581,9 @@ static int do_insn_fetch(struct x86_emul
 {
 	int rc = 0;
 
+	/* x86 instructions are limited to 15 bytes. */
+	if (eip + size - ctxt->decode.eip_orig > 15)
+		return X86EMUL_UNHANDLEABLE;
 	eip += ctxt->cs_base;
 	while (size--) {
 		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
@@ -839,7 +842,7 @@ x86_decode_insn(struct x86_emulate_ctxt
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = ctxt->vcpu->arch.rip;
+	c->eip = c->eip_orig = ctxt->vcpu->arch.rip;
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 
--- a/include/asm-x86/kvm_x86_emulate.h
+++ b/include/asm-x86/kvm_x86_emulate.h
@@ -128,7 +128,7 @@ struct decode_cache {
 	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
-	unsigned long eip;
+	unsigned long eip, eip_orig;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;


