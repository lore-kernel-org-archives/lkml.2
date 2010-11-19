Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837Ab0KSWAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:00:40 -0500
Received: from kroah.org ([198.145.64.141]:45394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757672Ab0KSV7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:09 -0500
X-Mailbox-Line: From gregkh@clark.site Fri Nov 19 13:56:45 2010
Message-Id: <20101119215645.475815683@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 19 Nov 2010 13:56:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [82/82] KVM: x86 emulator: fix regression with cmpxchg8b on i386 hosts
In-Reply-To: <20101119215658.GA7804@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Avi Kivity <avi@redhat.com>

commit 16518d5ada690643453eb0aef3cc7841d3623c2d upstream.

operand::val and operand::orig_val are 32-bit on i386, whereas cmpxchg8b
operands are 64-bit.

Fix by adding val64 and orig_val64 union members to struct operand, and
using them where needed.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/include/asm/kvm_emulate.h |   10 +++++++++-
 arch/x86/kvm/emulate.c             |    9 ++++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -143,7 +143,15 @@ struct x86_emulate_ops {
 struct operand {
 	enum { OP_REG, OP_MEM, OP_IMM, OP_NONE } type;
 	unsigned int bytes;
-	unsigned long val, orig_val, *ptr;
+	union {
+		unsigned long orig_val;
+		u64 orig_val64;
+	};
+	unsigned long *ptr;
+	union {
+		unsigned long val;
+		u64 val64;
+	};
 };
 
 struct fetch_cache {
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1712,17 +1712,16 @@ static inline int emulate_grp9(struct x8
 			       struct x86_emulate_ops *ops)
 {
 	struct decode_cache *c = &ctxt->decode;
-	u64 old = c->dst.orig_val;
+	u64 old = c->dst.orig_val64;
 
 	if (((u32) (old >> 0) != (u32) c->regs[VCPU_REGS_RAX]) ||
 	    ((u32) (old >> 32) != (u32) c->regs[VCPU_REGS_RDX])) {
-
 		c->regs[VCPU_REGS_RAX] = (u32) (old >> 0);
 		c->regs[VCPU_REGS_RDX] = (u32) (old >> 32);
 		ctxt->eflags &= ~EFLG_ZF;
 	} else {
-		c->dst.val = ((u64)c->regs[VCPU_REGS_RCX] << 32) |
-		       (u32) c->regs[VCPU_REGS_RBX];
+		c->dst.val64 = ((u64)c->regs[VCPU_REGS_RCX] << 32) |
+			(u32) c->regs[VCPU_REGS_RBX];
 
 		ctxt->eflags |= EFLG_ZF;
 	}
@@ -2535,7 +2534,7 @@ x86_emulate_insn(struct x86_emulate_ctxt
 					ctxt->vcpu);
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
-		c->src.orig_val = c->src.val;
+		c->src.orig_val64 = c->src.val64;
 	}
 
 	if (c->src2.type == OP_MEM) {


