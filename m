Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab2EDLrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 07:47:23 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:35652 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701Ab2EDLrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 07:47:22 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bh)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M3HY2Q-01-CB7-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] KVM: X86: Add mmx movq emulation
Date: Fri, 4 May 2012 13:47:09 +0200
Message-ID: <1336132029-13523-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to the MMX versions of the movq instructions to
the instruction emulator. Also handle possible exceptions
they may cause.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/kvm_emulate.h |    2 +-
 arch/x86/kvm/emulate.c             |  155 +++++++++++++++++++++++++++++++++++-
 2 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index c222e1a..e4833f8 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -200,7 +200,7 @@ typedef u32 __attribute__((vector_size(16))) sse128_t;
 
 /* Type, address-of, and value of an instruction's operand. */
 struct operand {
-	enum { OP_REG, OP_MEM, OP_IMM, OP_XMM, OP_NONE } type;
+	enum { OP_REG, OP_MEM, OP_IMM, OP_XMM, OP_MMX, OP_NONE } type;
 	unsigned int bytes;
 	union {
 		unsigned long orig_val;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 8375622..d4bf50c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -142,6 +142,7 @@
 #define Src2FS      (OpFS << Src2Shift)
 #define Src2GS      (OpGS << Src2Shift)
 #define Src2Mask    (OpMask << Src2Shift)
+#define Mmx         (1ULL<<35)
 
 #define X2(x...) x, x
 #define X3(x...) X2(x), x
@@ -537,6 +538,11 @@ static int emulate_nm(struct x86_emulate_ctxt *ctxt)
 	return emulate_exception(ctxt, NM_VECTOR, 0, false);
 }
 
+static int emulate_mf(struct x86_emulate_ctxt *ctxt)
+{
+	return emulate_exception(ctxt, MF_VECTOR, 0, false);
+}
+
 static u16 get_segment_selector(struct x86_emulate_ctxt *ctxt, unsigned seg)
 {
 	u16 selector;
@@ -859,6 +865,110 @@ static void write_sse_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
 	ctxt->ops->put_fpu(ctxt);
 }
 
+#define __READ_MMX_SAFE(mmxreg)					\
+	asm volatile("2: movq %%" mmxreg ", %[d]\n\t"		\
+		     "xor %[err], %[err]\n\t"			\
+		     "1:\n\t"					\
+		     ".section .fixup,\"ax\"\n\t"		\
+		     "3: mov %[fault], %[err]; jmp 1b\n\t"	\
+		     ".previous\n\t"				\
+		     _ASM_EXTABLE(2b, 3b)			\
+		     : [err] "=r" (err), [d] "=m"(*data)	\
+		     : [fault] "i" (X86EMUL_PROPAGATE_FAULT));
+
+
+#define __WRITE_MMX_SAFE(mmxreg)				\
+	asm volatile("2: movq %[d], %%" mmxreg "\n\t"		\
+		     " xor %[err], %[err]\n\t"			\
+		     "1:\n\t"					\
+		     ".section .fixup,\"ax\"\n\t"		\
+		     "3: mov %[fault], %[err]; jmp 1b\n\t"	\
+		     ".previous\n\t"				\
+		     _ASM_EXTABLE(2b, 3b)			\
+		     : [err] "=r" (err)				\
+		     : [d] "m"(*data),				\
+		       [fault] "i" (X86EMUL_PROPAGATE_FAULT));
+
+static int read_mmx_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data, int reg)
+{
+	int err = X86EMUL_CONTINUE;
+
+	ctxt->ops->get_fpu(ctxt);
+	switch (reg) {
+	case 0:
+		__READ_MMX_SAFE("mm0");
+		break;
+	case 1:
+		__READ_MMX_SAFE("mm1");
+		break;
+	case 2:
+		__READ_MMX_SAFE("mm2");
+		break;
+	case 3:
+		__READ_MMX_SAFE("mm3");
+		break;
+	case 4:
+		__READ_MMX_SAFE("mm4");
+		break;
+	case 5:
+		__READ_MMX_SAFE("mm5");
+		break;
+	case 6:
+		__READ_MMX_SAFE("mm6");
+		break;
+	case 7:
+		__READ_MMX_SAFE("mm7");
+		break;
+	default:
+		BUG();
+	}
+	ctxt->ops->put_fpu(ctxt);
+
+	return err;
+}
+
+static int write_mmx_reg(struct x86_emulate_ctxt *ctxt, sse128_t *data,
+			 int reg)
+{
+	int err = X86EMUL_CONTINUE;
+
+	ctxt->ops->get_fpu(ctxt);
+	switch (reg) {
+	case 0:
+		__WRITE_MMX_SAFE("mm0");
+		break;
+	case 1:
+		__WRITE_MMX_SAFE("mm1");
+		break;
+	case 2:
+		__WRITE_MMX_SAFE("mm2");
+		break;
+	case 3:
+		__WRITE_MMX_SAFE("mm3");
+		break;
+	case 4:
+		__WRITE_MMX_SAFE("mm4");
+		break;
+	case 5:
+		__WRITE_MMX_SAFE("mm5");
+		break;
+	case 6:
+		__WRITE_MMX_SAFE("mm6");
+		break;
+	case 7:
+		__WRITE_MMX_SAFE("mm7");
+		break;
+	default:
+		BUG();
+	}
+	ctxt->ops->put_fpu(ctxt);
+
+	return err;
+}
+
+#undef __READ_MMX_SAFE
+#undef __WRITE_MMX_SAFE
+
 static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 				    struct operand *op)
 {
@@ -874,6 +984,11 @@ static void decode_register_operand(struct x86_emulate_ctxt *ctxt,
 		op->addr.xmm = reg;
 		read_sse_reg(ctxt, &op->vec_val, reg);
 		return;
+	} else if (ctxt->d & Mmx) {
+		op->type = OP_MMX;
+		op->bytes = 8;
+		op->addr.xmm = reg;
+		return;
 	}
 
 	op->type = OP_REG;
@@ -919,6 +1034,10 @@ static int decode_modrm(struct x86_emulate_ctxt *ctxt,
 			op->addr.xmm = ctxt->modrm_rm;
 			read_sse_reg(ctxt, &op->vec_val, ctxt->modrm_rm);
 			return rc;
+		} else if (ctxt->d & Mmx) {
+			op->type = OP_MMX;
+			op->bytes = 8;
+			op->addr.xmm = ctxt->modrm_rm;
 		}
 		fetch_register_operand(op);
 		return rc;
@@ -1387,6 +1506,19 @@ static int writeback(struct x86_emulate_ctxt *ctxt)
 	case OP_XMM:
 		write_sse_reg(ctxt, &ctxt->dst.vec_val, ctxt->dst.addr.xmm);
 		break;
+	case OP_MMX:
+		if (ctxt->dst.addr.xmm > 7) {
+			emulate_ud(ctxt);
+			return X86EMUL_PROPAGATE_FAULT;
+		}
+
+		rc = write_mmx_reg(ctxt, &ctxt->dst.vec_val, ctxt->dst.addr.xmm);
+
+		if (rc != X86EMUL_CONTINUE) {
+			emulate_mf(ctxt);
+			return rc;
+		}
+		break;
 	case OP_NONE:
 		/* no writeback */
 		break;
@@ -3415,7 +3547,7 @@ static struct opcode group11[] = {
 };
 
 static struct gprefix pfx_0f_6f_0f_7f = {
-	N, N, N, I(Sse, em_movdqu),
+	I(Mmx, em_movdqu), N, N, I(Sse, em_movdqu),
 };
 
 static struct opcode opcode_table[256] = {
@@ -3960,6 +4092,8 @@ done_prefixes:
 
 	if (ctxt->d & Sse)
 		ctxt->op_bytes = 16;
+	else if (ctxt->d & Mmx)
+		ctxt->op_bytes = 8;
 
 	/* ModRM and SIB bytes. */
 	if (ctxt->d & ModRM) {
@@ -4061,7 +4195,7 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		goto done;
 	}
 
-	if ((ctxt->d & Sse) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
+	if ((ctxt->d & (Sse | Mmx)) && (ops->get_cr(ctxt, 0) & X86_CR0_TS)) {
 		rc = emulate_nm(ctxt);
 		goto done;
 	}
@@ -4133,6 +4267,23 @@ int x86_emulate_insn(struct x86_emulate_ctxt *ctxt)
 		if (rc != X86EMUL_CONTINUE)
 			goto done;
 	}
+
+	if ((ctxt->d & Mmx) && (ctxt->src.type == OP_MMX)) {
+		unsigned reg = ctxt->src.addr.xmm;
+
+		if (reg > 7) {
+			emulate_ud(ctxt);
+			goto done;
+		}
+
+		rc = read_mmx_reg(ctxt, &ctxt->src.vec_val, reg);
+
+		if (rc != X86EMUL_CONTINUE) {
+			emulate_mf(ctxt);
+			goto done;
+		}
+	}
+
 	ctxt->dst.orig_val = ctxt->dst.val;
 
 special_insn:
-- 
1.7.9.5


