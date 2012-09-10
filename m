Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab2IJMiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:38:19 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37925 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757750Ab2IJMhw convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 10 Sep 2012 08:37:52 -0400
Message-Id: <504DFB3A020000780009A324@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 10 Sep 2012 13:37:46 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] x86: unify SSE-base xor-block routines
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides folding duplicate code, this has the advantage of fixing
x86-64's failure to use proper (para-virtualizable) accessors for
dealing with CR0.TS.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/include/asm/xor.h    |  351 +++++++++++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/xor_32.h |  326 ---------------------------------------
 arch/x86/include/asm/xor_64.h |  338 ----------------------------------------
 3 files changed, 351 insertions(+), 664 deletions(-)

--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor.h
@@ -1,10 +1,359 @@
 #ifdef CONFIG_KMEMCHECK
 /* kmemcheck doesn't handle MMX/SSE/SSE2 instructions */
 # include <asm-generic/xor.h>
+#elif !defined(_ASM_X86_XOR_H)
+#define _ASM_X86_XOR_H
+
+/*
+ * Optimized RAID-5 checksumming functions for SSE.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ *
+ * You should have received a copy of the GNU General Public License
+ * (for example /usr/src/linux/COPYING); if not, write to the Free
+ * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+/*
+ * Cache avoiding checksumming functions utilizing KNI instructions
+ * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
+ */
+
+/*
+ * Based on
+ * High-speed RAID5 checksumming functions utilizing SSE instructions.
+ * Copyright (C) 1998 Ingo Molnar.
+ */
+
+/*
+ * x86-64 changes / gcc fixes from Andi Kleen.
+ * Copyright 2002 Andi Kleen, SuSE Labs.
+ *
+ * This hasn't been optimized for the hammer yet, but there are likely
+ * no advantages to be gotten from x86-64 here anyways.
+ */
+
+#define XMMS_SAVE				\
+do {						\
+	preempt_disable();			\
+	cr0 = read_cr0();			\
+	clts();					\
+	asm volatile(				\
+		"movups %%xmm0,(%0)	;\n\t"	\
+		"movups %%xmm1,0x10(%0)	;\n\t"	\
+		"movups %%xmm2,0x20(%0)	;\n\t"	\
+		"movups %%xmm3,0x30(%0)	;\n\t"	\
+		:				\
+		: "r" (xmm_save) 		\
+		: "memory");			\
+} while (0)
+
+#define XMMS_RESTORE				\
+do {						\
+	asm volatile(				\
+		"sfence			;\n\t"	\
+		"movups (%0),%%xmm0	;\n\t"	\
+		"movups 0x10(%0),%%xmm1	;\n\t"	\
+		"movups 0x20(%0),%%xmm2	;\n\t"	\
+		"movups 0x30(%0),%%xmm3	;\n\t"	\
+		:				\
+		: "r" (xmm_save)		\
+		: "memory");			\
+	write_cr0(cr0);				\
+	preempt_enable();			\
+} while (0)
+
+#ifdef CONFIG_X86_32
+/* reduce register pressure */
+# define XOR_CONSTANT_CONSTRAINT "i"
 #else
+# define XOR_CONSTANT_CONSTRAINT "re"
+#endif
+
+#define OFFS(x)		"16*("#x")"
+#define PF_OFFS(x)	"256+16*("#x")"
+#define PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
+#define LD(x, y)	"	movaps "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
+#define ST(x, y)	"	movaps %%xmm"#y", "OFFS(x)"(%[p1])	;\n"
+#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
+#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
+#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
+#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
+#define XO1(x, y)	"	xorps "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
+#define XO2(x, y)	"	xorps "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
+#define XO3(x, y)	"	xorps "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
+#define XO4(x, y)	"	xorps "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
+
+static void
+xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(16);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i)					\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+		PF1(i)					\
+				PF1(i + 2)		\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
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
+static void
+xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(16);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
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
+static void
+xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(16);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
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
+static void
+xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
+	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
+{
+	unsigned long cr0, lines = bytes >> 8;
+	char xmm_save[16*4] __aligned(16);
+
+	XMMS_SAVE;
+
+	asm volatile(
+#undef BLOCK
+#define BLOCK(i) \
+		PF1(i)					\
+				PF1(i + 2)		\
+		LD(i, 0)				\
+			LD(i + 1, 1)			\
+				LD(i + 2, 2)		\
+					LD(i + 3, 3)	\
+		PF2(i)					\
+				PF2(i + 2)		\
+		XO1(i, 0)				\
+			XO1(i + 1, 1)			\
+				XO1(i + 2, 2)		\
+					XO1(i + 3, 3)	\
+		PF3(i)					\
+				PF3(i + 2)		\
+		XO2(i, 0)				\
+			XO2(i + 1, 1)			\
+				XO2(i + 2, 2)		\
+					XO2(i + 3, 3)	\
+		PF4(i)					\
+				PF4(i + 2)		\
+		PF0(i + 4)				\
+				PF0(i + 6)		\
+		XO3(i, 0)				\
+			XO3(i + 1, 1)			\
+				XO3(i + 2, 2)		\
+					XO3(i + 3, 3)	\
+		XO4(i, 0)				\
+			XO4(i + 1, 1)			\
+				XO4(i + 2, 2)		\
+					XO4(i + 3, 3)	\
+		ST(i, 0)				\
+			ST(i + 1, 1)			\
+				ST(i + 2, 2)		\
+					ST(i + 3, 3)	\
+
+
+		PF0(0)
+				PF0(2)
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
+#undef LD
+#undef XO1
+#undef XO2
+#undef XO3
+#undef XO4
+#undef ST
+#undef BLOCK
+
+#undef XOR_CONSTANT_CONSTRAINT
+
 #ifdef CONFIG_X86_32
 # include "xor_32.h"
 #else
 # include "xor_64.h"
 #endif
-#endif
+
+#endif /* _ASM_X86_XOR_H */
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_32.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_32.h
@@ -2,7 +2,7 @@
 #define _ASM_X86_XOR_32_H
 
 /*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
+ * Optimized RAID-5 checksumming functions for MMX.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -529,330 +529,6 @@ static struct xor_block_template xor_blo
 	.do_5 = xor_p5_mmx_5,
 };
 
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	cr0 = read_cr0();			\
-	clts();					\
-	asm volatile(				\
-		"movups %%xmm0,(%0)	;\n\t"	\
-		"movups %%xmm1,0x10(%0)	;\n\t"	\
-		"movups %%xmm2,0x20(%0)	;\n\t"	\
-		"movups %%xmm3,0x30(%0)	;\n\t"	\
-		:				\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%0),%%xmm0	;\n\t"	\
-		"movups 0x10(%0),%%xmm1	;\n\t"	\
-		"movups 0x20(%0),%%xmm2	;\n\t"	\
-		"movups 0x30(%0),%%xmm3	;\n\t"	\
-		:				\
-		: "r" (xmm_save)		\
-		: "memory");			\
-	write_cr0(cr0);				\
-	preempt_enable();			\
-} while (0)
-
-#define ALIGN16 __attribute__((aligned(16)))
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%1), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%1)	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%2)		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%3)		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%4)		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%5)		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%6)		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%2), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%3), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%4), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%5), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%6), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i)					\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2)
-	:
-	: "memory");
-
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r"(p2), "+r"(p3)
-	:
-	: "memory" );
-
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3), "+r" (p4)
-	:
-	: "memory" );
-
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
-
-	XMMS_SAVE;
-
-	/* Make sure GCC forgets anything it knows about p4 or p5,
-	   such that it won't pass to the asm volatile below a
-	   register that is shared with any other variable.  That's
-	   because we modify p4 and p5 there, but we can't mark them
-	   as read/write, otherwise we'd overflow the 10-asm-operands
-	   limit of GCC < 3.1.  */
-	asm("" : "+r" (p4), "+r" (p5));
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i,0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i,0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i,0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i,0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i,0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i,0)					\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addl $256, %1           ;\n"
-	"       addl $256, %2           ;\n"
-	"       addl $256, %3           ;\n"
-	"       addl $256, %4           ;\n"
-	"       addl $256, %5           ;\n"
-	"       decl %0                 ;\n"
-	"       jnz 1b                  ;\n"
-	: "+r" (lines),
-	  "+r" (p1), "+r" (p2), "+r" (p3)
-	: "r" (p4), "r" (p5)
-	: "memory");
-
-	/* p4 and p5 were modified, and now the variables are dead.
-	   Clobber them just to be sure nobody does something stupid
-	   like assuming they have some legal value.  */
-	asm("" : "=r" (p4), "=r" (p5));
-
-	XMMS_RESTORE;
-}
-
 static struct xor_block_template xor_block_pIII_sse = {
 	.name = "pIII_sse",
 	.do_2 = xor_sse_2,
--- 3.6-rc5-x86-xor.orig/arch/x86/include/asm/xor_64.h
+++ 3.6-rc5-x86-xor/arch/x86/include/asm/xor_64.h
@@ -1,344 +1,6 @@
 #ifndef _ASM_X86_XOR_64_H
 #define _ASM_X86_XOR_64_H
 
-/*
- * Optimized RAID-5 checksumming functions for MMX and SSE.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * You should have received a copy of the GNU General Public License
- * (for example /usr/src/linux/COPYING); if not, write to the Free
- * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-
-/*
- * Cache avoiding checksumming functions utilizing KNI instructions
- * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
- */
-
-/*
- * Based on
- * High-speed RAID5 checksumming functions utilizing SSE instructions.
- * Copyright (C) 1998 Ingo Molnar.
- */
-
-/*
- * x86-64 changes / gcc fixes from Andi Kleen.
- * Copyright 2002 Andi Kleen, SuSE Labs.
- *
- * This hasn't been optimized for the hammer yet, but there are likely
- * no advantages to be gotten from x86-64 here anyways.
- */
-
-typedef struct {
-	unsigned long a, b;
-} __attribute__((aligned(16))) xmm_store_t;
-
-/* Doesn't use gcc to save the XMM registers, because there is no easy way to
-   tell it to do a clts before the register saving. */
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	asm volatile(				\
-		"movq %%cr0,%0		;\n\t"	\
-		"clts			;\n\t"	\
-		"movups %%xmm0,(%1)	;\n\t"	\
-		"movups %%xmm1,0x10(%1)	;\n\t"	\
-		"movups %%xmm2,0x20(%1)	;\n\t"	\
-		"movups %%xmm3,0x30(%1)	;\n\t"	\
-		: "=&r" (cr0)			\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%1),%%xmm0	;\n\t"	\
-		"movups 0x10(%1),%%xmm1	;\n\t"	\
-		"movups 0x20(%1),%%xmm2	;\n\t"	\
-		"movups 0x30(%1),%%xmm3	;\n\t"	\
-		"movq 	%0,%%cr0	;\n\t"	\
-		:				\
-		: "r" (cr0), "r" (xmm_save)	\
-		: "memory");			\
-	preempt_enable();			\
-} while (0)
-
-#define OFFS(x)		"16*("#x")"
-#define PF_OFFS(x)	"256+16*("#x")"
-#define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%[p1])		;\n"
-#define LD(x, y)	"       movaps   "OFFS(x)"(%[p1]), %%xmm"#y"	;\n"
-#define ST(x, y)	"       movaps %%xmm"#y",   "OFFS(x)"(%[p1])	;\n"
-#define PF1(x)		"	prefetchnta "PF_OFFS(x)"(%[p2])		;\n"
-#define PF2(x)		"	prefetchnta "PF_OFFS(x)"(%[p3])		;\n"
-#define PF3(x)		"	prefetchnta "PF_OFFS(x)"(%[p4])		;\n"
-#define PF4(x)		"	prefetchnta "PF_OFFS(x)"(%[p5])		;\n"
-#define PF5(x)		"	prefetchnta "PF_OFFS(x)"(%[p6])		;\n"
-#define XO1(x, y)	"       xorps   "OFFS(x)"(%[p2]), %%xmm"#y"	;\n"
-#define XO2(x, y)	"       xorps   "OFFS(x)"(%[p3]), %%xmm"#y"	;\n"
-#define XO3(x, y)	"       xorps   "OFFS(x)"(%[p4]), %%xmm"#y"	;\n"
-#define XO4(x, y)	"       xorps   "OFFS(x)"(%[p5]), %%xmm"#y"	;\n"
-#define XO5(x, y)	"       xorps   "OFFS(x)"(%[p6]), %%xmm"#y"	;\n"
-
-
-static void
-xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
-{
-	unsigned int lines = bytes >> 8;
-	unsigned long cr0;
-	xmm_store_t xmm_save[4];
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-		PF1(i)					\
-				PF1(i + 2)		\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [p1] "+r" (p1), [p2] "+r" (p2), [cnt] "+r" (lines)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3)
-{
-	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)					\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]          ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-		"		decl %[cnt] ; jnz 1b"
-	: [cnt] "+r" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
-	: [inc] "r" (256UL)
-	: "memory");
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4)
-{
-	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4)
-	: [inc] "r" (256UL)
-	: "memory" );
-
-	XMMS_RESTORE;
-}
-
-static void
-xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
-	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
-{
-	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
-
-	XMMS_SAVE;
-
-	asm volatile(
-#undef BLOCK
-#define BLOCK(i) \
-		PF1(i)					\
-				PF1(i + 2)		\
-		LD(i, 0)				\
-			LD(i + 1, 1)			\
-				LD(i + 2, 2)		\
-					LD(i + 3, 3)	\
-		PF2(i)					\
-				PF2(i + 2)		\
-		XO1(i, 0)				\
-			XO1(i + 1, 1)			\
-				XO1(i + 2, 2)		\
-					XO1(i + 3, 3)	\
-		PF3(i)					\
-				PF3(i + 2)		\
-		XO2(i, 0)				\
-			XO2(i + 1, 1)			\
-				XO2(i + 2, 2)		\
-					XO2(i + 3, 3)	\
-		PF4(i)					\
-				PF4(i + 2)		\
-		PF0(i + 4)				\
-				PF0(i + 6)		\
-		XO3(i, 0)				\
-			XO3(i + 1, 1)			\
-				XO3(i + 2, 2)		\
-					XO3(i + 3, 3)	\
-		XO4(i, 0)				\
-			XO4(i + 1, 1)			\
-				XO4(i + 2, 2)		\
-					XO4(i + 3, 3)	\
-		ST(i, 0)				\
-			ST(i + 1, 1)			\
-				ST(i + 2, 2)		\
-					ST(i + 3, 3)	\
-
-
-		PF0(0)
-				PF0(2)
-
-	" .align 32			;\n"
-	" 1:                            ;\n"
-
-		BLOCK(0)
-		BLOCK(4)
-		BLOCK(8)
-		BLOCK(12)
-
-	"       addq %[inc], %[p1]           ;\n"
-	"       addq %[inc], %[p2]           ;\n"
-	"       addq %[inc], %[p3]           ;\n"
-	"       addq %[inc], %[p4]           ;\n"
-	"       addq %[inc], %[p5]           ;\n"
-	"	decl %[cnt] ; jnz 1b"
-	: [cnt] "+c" (lines),
-	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3), [p4] "+r" (p4),
-	  [p5] "+r" (p5)
-	: [inc] "r" (256UL)
-	: "memory");
-
-	XMMS_RESTORE;
-}
-
 static struct xor_block_template xor_block_sse = {
 	.name = "generic_sse",
 	.do_2 = xor_sse_2,


