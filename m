Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab2AKQnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 11:43:45 -0500
Received: from mailgw12.technion.ac.il ([132.68.225.12]:35396 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2AKQnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 11:43:43 -0500
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 11:43:43 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEACS5DU+ERM5e/2dsb2JhbABCrGuBBYIgUoECPBO/UowdBKACh0g
X-IronPort-AV: E=Sophos;i="4.71,493,1320616800"; 
   d="scan'208";a="74148364"
From: Nadav Amit <namit@cs.technion.ac.il>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nadav Amit <namit@cs.technion.ac.il>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH v2] KVM: fix mov immediate emulation for 64-bit operands
Date: Wed, 11 Jan 2012 18:33:39 +0200
Message-Id: <1326299619-16724-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MOV immediate instruction (opcodes 0xB8-0xBF) may take 64-bit operand.
The previous emulation implementation assumes the operand is no longer than 32.
Adding OpImm64 for this matter.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 arch/x86/kvm/emulate.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 05a562b..9ad5c0b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -43,7 +43,7 @@
 #define OpCL               9ull  /* CL register (for shifts) */
 #define OpImmByte         10ull  /* 8-bit sign extended immediate */
 #define OpOne             11ull  /* Implied 1 */
-#define OpImm             12ull  /* Sign extended immediate */
+#define OpImm             12ull  /* Sign extended up to 32-bit immediate */
 #define OpMem16           13ull  /* Memory operand (16-bit). */
 #define OpMem32           14ull  /* Memory operand (32-bit). */
 #define OpImmU            15ull  /* Immediate operand, zero extended */
@@ -57,6 +57,7 @@
 #define OpDS              23ull  /* DS */
 #define OpFS              24ull  /* FS */
 #define OpGS              25ull  /* GS */
+#define OpImm64	          26ull	 /* Sign extended 16/32/64-bit immediate */
 
 #define OpBits             5  /* Width of operand field */
 #define OpMask             ((1ull << OpBits) - 1)
@@ -100,6 +101,7 @@
 #define SrcMemFAddr (OpMemFAddr << SrcShift)
 #define SrcAcc      (OpAcc << SrcShift)
 #define SrcImmU16   (OpImmU16 << SrcShift)
+#define SrcImm64    (OpImm64 << SrcShift)
 #define SrcDX       (OpDX << SrcShift)
 #define SrcMask     (OpMask << SrcShift)
 #define BitOp       (1<<11)
@@ -3365,7 +3367,7 @@ static struct opcode opcode_table[256] = {
 	/* 0xB0 - 0xB7 */
 	X8(I(ByteOp | DstReg | SrcImm | Mov, em_mov)),
 	/* 0xB8 - 0xBF */
-	X8(I(DstReg | SrcImm | Mov, em_mov)),
+	X8(I(DstReg | SrcImm64 | Mov, em_mov)),
 	/* 0xC0 - 0xC7 */
 	D2bv(DstMem | SrcImmByte | ModRM),
 	I(ImplicitOps | Stack | SrcImmU16, em_ret_near_imm),
@@ -3526,6 +3528,9 @@ static int decode_imm(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	case 4:
 		op->val = insn_fetch(s32, ctxt);
 		break;
+	case 8:
+		op->val = insn_fetch(s64, ctxt);
+		break;
 	}
 	if (!sign_extension) {
 		switch (op->bytes) {
@@ -3605,6 +3610,9 @@ static int decode_operand(struct x86_emulate_ctxt *ctxt, struct operand *op,
 	case OpImm:
 		rc = decode_imm(ctxt, op, imm_size(ctxt), true);
 		break;
+	case OpImm64:
+		rc = decode_imm(ctxt, op, ctxt->op_bytes, true);
+		break;
 	case OpMem16:
 		ctxt->memop.bytes = 2;
 		goto mem_common;
-- 
1.7.4.1

