Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0CaAcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:32:33 -0400
Received: from kroah.org ([198.145.64.141]:48809 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab0C3XMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:01 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:17 2010
Message-Id: <20100330225816.992530549@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [14/89] KVM: x86 emulator: limit instructions to 15 bytes
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit eb3c79e64a70fb8f7473e30fa07e89c1ecc2c9bb upstream

While we are never normally passed an instruction that exceeds 15 bytes,
smp games can cause us to attempt to interpret one, which will cause
large latencies in non-preempt hosts.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/kvm_x86_emulate.h |    2 +-
 arch/x86/kvm/x86_emulate.c             |    5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/kvm_x86_emulate.h
+++ b/arch/x86/include/asm/kvm_x86_emulate.h
@@ -129,7 +129,7 @@ struct decode_cache {
 	u8 seg_override;
 	unsigned int d;
 	unsigned long regs[NR_VCPU_REGS];
-	unsigned long eip;
+	unsigned long eip, eip_orig;
 	/* modrm */
 	u8 modrm;
 	u8 modrm_mod;
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -606,6 +606,9 @@ static int do_insn_fetch(struct x86_emul
 {
 	int rc = 0;
 
+	/* x86 instructions are limited to 15 bytes. */
+	if (eip + size - ctxt->decode.eip_orig > 15)
+		return X86EMUL_UNHANDLEABLE;
 	eip += ctxt->cs_base;
 	while (size--) {
 		rc = do_fetch_insn_byte(ctxt, ops, eip++, dest++);
@@ -864,7 +867,7 @@ x86_decode_insn(struct x86_emulate_ctxt
 	/* Shadow copy of register state. Committed on successful emulation. */
 
 	memset(c, 0, sizeof(struct decode_cache));
-	c->eip = kvm_rip_read(ctxt->vcpu);
+	c->eip = c->eip_orig = kvm_rip_read(ctxt->vcpu);
 	ctxt->cs_base = seg_base(ctxt, VCPU_SREG_CS);
 	memcpy(c->regs, ctxt->vcpu->arch.regs, sizeof c->regs);
 


