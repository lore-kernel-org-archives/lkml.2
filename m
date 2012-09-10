Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab2IJMj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:39:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38018 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab2IJMjZ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:39:25 -0400
Message-Id: <504DFB98020000780009A32A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:39:20 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] x86/xor: add alternative SSE implementation only
 prefetching once per 64-byte line
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On CPUs with 64-byte last level cache lines, the yields roughly 10%
better performance, independent of CPU vendor or specific model (as far
as I was able to test).

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/xor.h    |  176 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/xor_32.h |   23 ++---
 arch/x86/include/asm/xor_64.h |   10 --
 3 files changed, 191 insertions(+), 18 deletions(-)

--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor.h
@@ -107,6 +107,14 @@ do {						\
 #define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
 #define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
 #define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+#define NOP(x)
+
+#define BLK64(pf, op, i)				\
+		pf(i)					\
+		op(i, 0)				\
+			op(i + 1, 1)			\
+				op(i + 2, 2)		\
+					op(i + 3, 3)
 
 static void XOR_ALIGN_STACK
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
@@ -161,6 +169,41 @@ xor_sse_2(unsigned long bytes, unsigned
 }
 
 static void XOR_ALIGN_STACK
+xor_sse_2_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	XMMS_RESTORE;
+}
+
+static void XOR_ALIGN_STACK
 xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
@@ -221,6 +264,44 @@ xor_sse_3(unsigned long bytes, unsigned
 }
 
 static void XOR_ALIGN_STACK
+xor_sse_3_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines),
+	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	XMMS_RESTORE;
+}
+
+static void XOR_ALIGN_STACK
 xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
@@ -288,6 +369,46 @@ xor_sse_4(unsigned long bytes, unsigned
 }
 
 static void XOR_ALIGN_STACK
+xor_sse_4_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1),
+	  [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	XMMS_RESTORE;
+}
+
+static void XOR_ALIGN_STACK
 xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
@@ -361,12 +482,64 @@ xor_sse_5(unsigned long bytes, unsigned
 	XMMS_RESTORE;
 }
 
+static void XOR_ALIGN_STACK
+xor_sse_5_pf64(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	       unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(XOR_ALIGN);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)			\
+		BLK64(PF0, LD, i)	\
+		BLK64(PF1, XO1, i)	\
+		BLK64(PF2, XO2, i)	\
+		BLK64(PF3, XO3, i)	\
+		BLK64(PF4, XO4, i)	\
+		BLK64(NOP, ST, i)	\
+
+	" .align 32			;\n"
+	" 1:                            ;\n"
+
+		BLOCK(0)
+		BLOCK(4)
+		BLOCK(8)
+		BLOCK(12)
+
+	"       add %[inc], %[p1]       ;\n"
+	"       add %[inc], %[p2]       ;\n"
+	"       add %[inc], %[p3]       ;\n"
+	"       add %[inc], %[p4]       ;\n"
+	"       add %[inc], %[p5]       ;\n"
+	"       dec %[cnt]              ;\n"
+	"       jnz 1b                  ;\n"
+	: [cnt] "+r" (lines), [p1] "+r" (p1), [p2] "+r" (p2),
+	  [p3] "+r" (p3), [p4] "+r" (p4), [p5] "+r" (p5)
+	: [inc] XOR_CONSTANT_CONSTRAINT (256UL)
+	: "memory");
+
+	XMMS_RESTORE;
+}
+
+static struct xor_block_template xor_block_sse_pf64 = {
+	.name = "prefetch64-sse",
+	.do_2 = xor_sse_2_pf64,
+	.do_3 = xor_sse_3_pf64,
+	.do_4 = xor_sse_4_pf64,
+	.do_5 = xor_sse_5_pf64,
+};
+
 #undef LD
 #undef XO1
 #undef XO2
 #undef XO3
 #undef XO4
 #undef ST
+#undef NOP
+#undef BLK64
 #undef BLOCK
 
 #undef XOR_ALIGN_STACK
@@ -380,4 +553,7 @@ xor_sse_5(unsigned long bytes, unsigned
 # include "xor_64.h"
 #endif
 
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+	AVX_SELECT(FASTEST)
+
 #endif /* _ASM_X86_XOR_H */
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_32.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_32.h
@@ -543,26 +543,25 @@ static struct xor_block_template xor_blo
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES				\
 do {							\
-	xor_speed(&xor_block_8regs);			\
-	xor_speed(&xor_block_8regs_p);			\
-	xor_speed(&xor_block_32regs);			\
-	xor_speed(&xor_block_32regs_p);			\
 	AVX_XOR_SPEED;					\
-	if (cpu_has_xmm)				\
+	if (cpu_has_xmm) {				\
 		xor_speed(&xor_block_pIII_sse);		\
-	if (cpu_has_mmx) {				\
+		xor_speed(&xor_block_sse_pf64);		\
+	} else if (cpu_has_mmx) {			\
 		xor_speed(&xor_block_pII_mmx);		\
 		xor_speed(&xor_block_p5_mmx);		\
+	} else {					\
+		xor_speed(&xor_block_8regs);		\
+		xor_speed(&xor_block_8regs_p);		\
+		xor_speed(&xor_block_32regs);		\
+		xor_speed(&xor_block_32regs_p);		\
 	}						\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST)			\
-	AVX_SELECT(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
-
 #endif /* _ASM_X86_XOR_32_H */
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_64.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_64.h
@@ -13,17 +13,15 @@ static struct xor_block_template xor_blo
 /* Also try the AVX routines */
 #include "xor_avx.h"
 
+/* We force the use of the SSE xor block because it can write around L2.
+   We may also be able to load into the L1 only depending on how the cpu
+   deals with a load to a line that is being prefetched.  */
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 do {						\
 	AVX_XOR_SPEED;				\
+	xor_speed(&xor_block_sse_pf64);		\
 	xor_speed(&xor_block_sse);		\
 } while (0)
 
-/* We force the use of the SSE xor block because it can write around L2.
-   We may also be able to load into the L1 only depending on how the cpu
-   deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(&xor_block_sse)
-
 #endif /* _ASM_X86_XOR_64_H */


