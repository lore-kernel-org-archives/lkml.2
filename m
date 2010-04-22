Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758589Ab0DVUhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:37:47 -0400
Received: from kroah.org ([198.145.64.141]:37486 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab0DVT2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:28:10 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:09:12 2010
Message-Id: <20100422190912.304483692@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:08:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [055/197] KVM: x86 emulator: Fix popf emulation
In-Reply-To: <20100422191857.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Gleb Natapov <gleb@redhat.com>

commit d4c6a1549c056f1d817e8f6f2f97d8b44933472f upstream

POPF behaves differently depending on current CPU mode. Emulate correct
logic to prevent guest from changing flags that it can't change otherwise.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/emulate.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -339,11 +339,18 @@ static u32 group2_table[] = {
 };
 
 /* EFLAGS bit definitions. */
+#define EFLG_ID (1<<21)
+#define EFLG_VIP (1<<20)
+#define EFLG_VIF (1<<19)
+#define EFLG_AC (1<<18)
 #define EFLG_VM (1<<17)
 #define EFLG_RF (1<<16)
+#define EFLG_IOPL (3<<12)
+#define EFLG_NT (1<<14)
 #define EFLG_OF (1<<11)
 #define EFLG_DF (1<<10)
 #define EFLG_IF (1<<9)
+#define EFLG_TF (1<<8)
 #define EFLG_SF (1<<7)
 #define EFLG_ZF (1<<6)
 #define EFLG_AF (1<<4)
@@ -1205,6 +1212,49 @@ static int emulate_pop(struct x86_emulat
 	return rc;
 }
 
+static int emulate_popf(struct x86_emulate_ctxt *ctxt,
+		       struct x86_emulate_ops *ops,
+		       void *dest, int len)
+{
+	int rc;
+	unsigned long val, change_mask;
+	int iopl = (ctxt->eflags & X86_EFLAGS_IOPL) >> IOPL_SHIFT;
+	int cpl = kvm_x86_ops->get_cpl(ctxt->vcpu);
+
+	rc = emulate_pop(ctxt, ops, &val, len);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	change_mask = EFLG_CF | EFLG_PF | EFLG_AF | EFLG_ZF | EFLG_SF | EFLG_OF
+		| EFLG_TF | EFLG_DF | EFLG_NT | EFLG_RF | EFLG_AC | EFLG_ID;
+
+	switch(ctxt->mode) {
+	case X86EMUL_MODE_PROT64:
+	case X86EMUL_MODE_PROT32:
+	case X86EMUL_MODE_PROT16:
+		if (cpl == 0)
+			change_mask |= EFLG_IOPL;
+		if (cpl <= iopl)
+			change_mask |= EFLG_IF;
+		break;
+	case X86EMUL_MODE_VM86:
+		if (iopl < 3) {
+			kvm_inject_gp(ctxt->vcpu, 0);
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+		change_mask |= EFLG_IF;
+		break;
+	default: /* real mode */
+		change_mask |= (EFLG_IOPL | EFLG_IF);
+		break;
+	}
+
+	*(unsigned long *)dest =
+		(ctxt->eflags & ~change_mask) | (val & change_mask);
+
+	return rc;
+}
+
 static inline int emulate_grp1a(struct x86_emulate_ctxt *ctxt,
 				struct x86_emulate_ops *ops)
 {
@@ -1995,7 +2045,10 @@ special_insn:
 		c->dst.type = OP_REG;
 		c->dst.ptr = (unsigned long *) &ctxt->eflags;
 		c->dst.bytes = c->op_bytes;
-		goto pop_instruction;
+		rc = emulate_popf(ctxt, ops, &c->dst.val, c->op_bytes);
+		if (rc != X86EMUL_CONTINUE)
+			goto done;
+		break;
 	case 0xa0 ... 0xa1:	/* mov */
 		c->dst.ptr = (unsigned long *)&c->regs[VCPU_REGS_RAX];
 		c->dst.val = c->src.val;


