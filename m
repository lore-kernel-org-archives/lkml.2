Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1ACLwa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:52:30 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:48693 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab1ACLw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:52:27 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 5/8] unicore32 additional architecture files: low-level lib: io
Date: Mon, 3 Jan 2011 19:52:27 +0800
Message-ID: <012d01cbab3c$b180b220$14821660$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPJQlq7AlKVAaQvGOq100RmqISQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 5 implements low-level io libraries.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/io.h |   83 +++++++++++++++++++++++++
 arch/unicore32/lib/io-readsb.S  |  130 +++++++++++++++++++++++++++++++++++++++
 arch/unicore32/lib/io-readsl.S  |   83 +++++++++++++++++++++++++
 arch/unicore32/lib/io-readsw.S  |  110 +++++++++++++++++++++++++++++++++
 arch/unicore32/lib/io-writesb.S |   90 +++++++++++++++++++++++++++
 arch/unicore32/lib/io-writesl.S |   69 +++++++++++++++++++++
 arch/unicore32/lib/io-writesw.S |   87 ++++++++++++++++++++++++++
 7 files changed, 652 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
new file mode 100644
index 0000000..67c5c03
--- /dev/null
+++ b/arch/unicore32/include/asm/io.h
@@ -0,0 +1,83 @@
+/*
+ * linux/arch/unicore32/include/asm/io.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __UNICORE_IO_H__
+#define __UNICORE_IO_H__
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/memory.h>
+#include <asm/system.h>
+
+/*
+ *  IO port access primitives
+ *  -------------------------
+ *
+ * The UniCore doesn't have special IO access instructions; all IO is memory
+ * mapped.  Note that these are defined to perform little endian accesses
+ * only.  Their primary purpose is to access PCI peripherals.
+ *
+ * Note that we prevent GCC re-ordering or caching values in expressions
+ * by introducing sequence points into the in*() definitions.  Note that
+ * __raw_* do not guarantee this behaviour.
+ *
+ * The {in,out}[bwl] macros are for emulating x86-style PCI IO space.
+ */
+extern void __raw_writesb(void __iomem *addr, const void *data, int bytelen);
+extern void __raw_writesw(void __iomem *addr, const void *data, int wordlen);
+extern void __raw_writesl(void __iomem *addr, const void *data, int longlen);
+
+extern void __raw_readsb(const void __iomem *addr, void *data, int bytelen);
+extern void __raw_readsw(const void __iomem *addr, void *data, int wordlen);
+extern void __raw_readsl(const void __iomem *addr, void *data, int longlen);
+
+#define outsb(p, d, l)			__raw_writesb((void __iomem *)p, d, l)
+#define outsw(p, d, l)			__raw_writesw((void __iomem *)p, d, l)
+#define outsl(p, d, l)			__raw_writesl((void __iomem *)p, d, l)
+
+#define insb(p, d, l)			__raw_readsb((void __iomem *)p, d, l)
+#define insw(p, d, l)			__raw_readsw((void __iomem *)p, d, l)
+#define insl(p, d, l)			__raw_readsl((void __iomem *)p, d, l)
+
+#include <asm-generic/io.h>
+
+/*
+ * __uc32_ioremap and __uc32_ioremap_cached takes CPU physical address.
+ */
+extern void __iomem *__uc32_ioremap(unsigned long, size_t);
+extern void __iomem *__uc32_ioremap_cached(unsigned long, size_t);
+extern void __uc32_iounmap(volatile void __iomem *addr);
+
+/*
+ * ioremap and friends.
+ *
+ * ioremap takes a PCI memory address, as specified in
+ * Documentation/IO-mapping.txt.
+ *
+ */
+#define ioremap(cookie, size)		__uc32_ioremap(cookie, size)
+#define ioremap_cached(cookie, size)	__uc32_ioremap_cached(cookie, size)
+#define iounmap(cookie)			__uc32_iounmap(cookie)
+
+extern void __iomem *ioport_map(unsigned long port, unsigned int nr);
+extern void ioport_unmap(void __iomem *addr);
+
+/*
+ * Convert a physical pointer to a virtual kernel pointer for /dev/mem
+ * access
+ */
+#undef xlate_dev_mem_ptr
+#define xlate_dev_mem_ptr(p)	__va(p)
+
+#endif	/* __KERNEL__ */
+#endif	/* __UNICORE_IO_H__ */
diff --git a/arch/unicore32/lib/io-readsb.S b/arch/unicore32/lib/io-readsb.S
new file mode 100644
index 0000000..ff85be3
--- /dev/null
+++ b/arch/unicore32/lib/io-readsb.S
@@ -0,0 +1,130 @@
+/*
+ * linux/arch/unicore32/lib/io-readsb.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+.Linsb_align:	rsub	ip, ip, #4
+		csub.a	ip, r2
+		cmovsg	ip, r2
+		csub.a	ip, #2
+		ldb	r3, [r0]
+		stb.w	r3, [r1]+, #1
+		bsl	201f
+		ldb	r3, [r0]
+		stb.w	r3, [r1]+, #1
+		bel	201f
+		ldb	r3, [r0]
+		stb.w	r3, [r1]+, #1
+201:
+		sub.a	r2, r2, ip
+		bne	.Linsb_aligned
+
+ENTRY(__raw_readsb)
+		cxor.a	r2, #0	@ do we have to check for the zero len?
+		cmoveq	pc, lr
+		and.a	ip, r1, #3
+		bne	.Linsb_align
+
+.Linsb_aligned:
+
+		sub.a	r2, r2, #16
+		bfs	.Linsb_no_16
+
+.Linsb_16_lp:	ldb	r3, [r0]
+		ldb	r4, [r0]
+		ldb	r5, [r0]
+		mov	r3, r3 put_byte_0
+		ldb	r6, [r0]
+		or	r3, r3, r4 put_byte_1
+		ldb	r4, [r0]
+		or	r3, r3, r5 put_byte_2
+		ldb	r5, [r0]
+		or	r3, r3, r6 put_byte_3
+		ldb	r6, [r0]
+		mov	r4, r4 put_byte_0
+		ldb	ip, [r0]
+		or	r4, r4, r5 put_byte_1
+		ldb	r5, [r0]
+		or	r4, r4, r6 put_byte_2
+		ldb	r6, [r0]
+		or	r4, r4, ip put_byte_3
+		ldb	ip, [r0]
+		mov	r5, r5 put_byte_0
+		ldb	r15, [r0]
+		or	r5, r5, r6 put_byte_1
+		ldb	r6, [r0]
+		or	r5, r5, ip put_byte_2
+		ldb	ip, [r0]
+		or	r5, r5, r15 put_byte_3
+		ldb	r15, [r0]
+		mov	r6, r6 put_byte_0
+		or	r6, r6, ip put_byte_1
+		ldb	ip, [r0]
+		or	r6, r6, r15 put_byte_2
+		or	r6, r6, ip put_byte_3
+		stm.w	(r3 - r6), [r1]+
+
+		sub.a	r2, r2, #16
+		bns	.Linsb_16_lp
+
+		cand.a	r2, #15
+		cmoveq	pc, lr
+
+.Linsb_no_16:	cand.a	r2, #8
+		beq	.Linsb_no_8
+
+		ldb	r3, [r0]
+		ldb	r4, [r0]
+		ldb	r5, [r0]
+		mov	r3, r3 put_byte_0
+		ldb	r6, [r0]
+		or	r3, r3, r4 put_byte_1
+		ldb	r4, [r0]
+		or	r3, r3, r5 put_byte_2
+		ldb	r5, [r0]
+		or	r3, r3, r6 put_byte_3
+		ldb	r6, [r0]
+		mov	r4, r4 put_byte_0
+		ldb	ip, [r0]
+		or	r4, r4, r5 put_byte_1
+		or	r4, r4, r6 put_byte_2
+		or	r4, r4, ip put_byte_3
+		stm.w	(r3, r4), [r1]+
+
+.Linsb_no_8:	cand.a	r2, #4
+		beq	.Linsb_no_4
+
+		ldb	r3, [r0]
+		ldb	r4, [r0]
+		ldb	r5, [r0]
+		ldb	r6, [r0]
+		mov	r3, r3 put_byte_0
+		or	r3, r3, r4 put_byte_1
+		or	r3, r3, r5 put_byte_2
+		or	r3, r3, r6 put_byte_3
+		stw.w	r3, [r1]+, #4
+
+.Linsb_no_4:	and.a	r2, r2, #3
+		cmoveq	pc, lr
+
+		csub.a	r2, #2
+		ldb	r3, [r0]
+		stb.w	r3, [r1]+, #1
+		bsl	201f
+		ldb	r3, [r0]
+		stb.w	r3, [r1]+, #1
+		bel	201f
+		ldb	r3, [r0]
+		stb	r3, [r1]
+201:
+		mov	pc, lr
+ENDPROC(__raw_readsb)
diff --git a/arch/unicore32/lib/io-readsl.S b/arch/unicore32/lib/io-readsl.S
new file mode 100644
index 0000000..980b0fc
--- /dev/null
+++ b/arch/unicore32/lib/io-readsl.S
@@ -0,0 +1,83 @@
+/*
+ * linux/arch/unicore32/lib/io-readsl.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+ENTRY(__raw_readsl)
+		cxor.a	r2, #0	@ do we have to check for the zero len?
+		cmoveq	pc, lr
+		and.a	ip, r1, #3
+		bne	3f
+
+		sub.a	r2, r2, #4
+		bfs	2f
+1:		ldw	r3, [r0+], #0
+		ldw	r4, [r0+], #0
+		ldw	r14, [r0+], #0
+		ldw	r15, [r0+], #0
+		sub.a	r2, r2, #4
+		stm.w	(r3, r4, r14, r15), [r1]+
+		bns	1b
+2:		mov.a	r2, r2 << #31
+		bub	201f
+		ldw	r3, [r0+], #0
+		ldw	r14, [r0+], #0
+		stm.w	(r3, r14), [r1]+
+201:		beq	202f
+		ldw	r3, [r0+], #0
+		stw	r3, [r1+], #0
+202:
+		mov	pc, lr
+
+3:		ldw	r3, [r0]
+		csub.a	ip, #2
+		mov	ip, r3 get_byte_0
+		stb.w	ip, [r1]+, #1
+		bsg	6f
+		mov	ip, r3 get_byte_1
+		stb.w	ip, [r1]+, #1
+		beq	5f
+		mov	ip, r3 get_byte_2
+		stb.w	ip, [r1]+, #1
+
+4:		sub.a	r2, r2, #1
+		mov	ip, r3 pull #24
+		beq	8f
+		ldw	r3, [r0]
+		or	ip, ip, r3 push #8
+		stw.w	ip, [r1]+, #4
+		b	4b
+
+5:		sub.a	r2, r2, #1
+		mov	ip, r3 pull #16
+		beq	7f
+		ldw	r3, [r0]
+		or	ip, ip, r3 push #16
+		stw.w	ip, [r1]+, #4
+		b	5b
+
+6:		sub.a	r2, r2, #1
+		mov	ip, r3 pull #8
+		beq	201f
+		ldw	r3, [r0]
+		or	ip, ip, r3 push #24
+		stw.w	ip, [r1]+, #4
+		b	6b
+201:
+		mov	r3, ip get_byte_2
+		stb	r3, [r1+], #2
+7:		mov	r3, ip get_byte_1
+		stb	r3, [r1+], #1
+8:		mov	r3, ip get_byte_0
+		stb	r3, [r1+], #0
+		mov	pc, lr
+ENDPROC(__raw_readsl)
diff --git a/arch/unicore32/lib/io-readsw.S b/arch/unicore32/lib/io-readsw.S
new file mode 100644
index 0000000..7d0b49d
--- /dev/null
+++ b/arch/unicore32/lib/io-readsw.S
@@ -0,0 +1,110 @@
+/*
+ * linux/arch/unicore32/lib/io-readsw.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.macro	pack, rd, hw1, hw2
+		or	\rd, \hw1, \hw2 << #16
+		.endm
+
+.Linsw_align:	mov.a	ip, r1 << #31
+		bne	.Linsw_noalign
+		ldh	ip, [r0]
+		sub	r2, r2, #1
+		sth.w	ip, [r1]+, #2
+
+ENTRY(__raw_readsw)
+		cxor.a	r2, #0
+		cmoveq	pc, lr
+		cand.a	r1, #3
+		bne	.Linsw_align
+
+		sub.a	r2, r2, #8
+		bfs	.Lno_insw_8
+
+.Linsw_8_lp:	ldh	r3, [r0]
+		ldh	r4, [r0]
+		pack	r3, r3, r4
+
+		ldh	r4, [r0]
+		ldh	r5, [r0]
+		pack	r4, r4, r5
+
+		ldh	r5, [r0]
+		ldh	ip, [r0]
+		pack	r5, r5, ip
+
+		ldh	ip, [r0]
+		ldh	r15, [r0]
+		pack	ip, ip, r15
+
+		sub.a	r2, r2, #8
+		stm.w	(r3 - r5), [r1]+
+		stm.w	(ip), [r1]+
+		bns	.Linsw_8_lp
+
+.Lno_insw_8:	cand.a	r2, #4
+		beq	.Lno_insw_4
+
+		ldh	r3, [r0]
+		ldh	r4, [r0]
+		pack	r3, r3, r4
+
+		ldh	r4, [r0]
+		ldh	ip, [r0]
+		pack	r4, r4, ip
+
+		stm.w	(r3, r4), [r1]+
+
+.Lno_insw_4:	mov.a	r2, r2 << #31
+		bub	.Lno_insw_2
+
+		ldh	r3, [r0]
+		ldh	ip, [r0]
+		pack	r3, r3, ip
+		stw.w	r3, [r1]+, #4
+
+.Lno_insw_2:	cmoveq	pc, lr
+		ldh	r3, [r0]
+		sth	r3, [r1]
+		mov	pc, lr
+
+.Linsw_noalign:	bea	201f
+		ldb.w	ip, [r1+], #-1
+		b	1f
+201:
+		ldh	ip, [r0]
+		sub	r2, r2, #1
+		stb.w	ip, [r1]+, #1
+		mov	ip, ip >> #8
+
+1:		sub.a	r2, r2, #2
+		bfs	3f
+
+2:		ldh	r3, [r0]
+		ldh	r4, [r0]
+		sub.a	r2, r2, #2
+		or	ip, ip, r3 << #8
+		or	ip, ip, r4 << #24
+		stw.w	ip, [r1]+, #4
+		mov	ip, r4 >> #8
+		bns	2b
+
+3:		cand.a	r2, #1
+		stb.w	ip, [r1]+, #1
+		cmoveq	pc, lr
+		ldh	ip, [r0]
+		stb.w	ip, [r1]+, #1
+		mov	ip, ip >> #8
+		stb	ip, [r1]
+		mov	pc, lr
+ENDPROC(__raw_readsw)
diff --git a/arch/unicore32/lib/io-writesb.S b/arch/unicore32/lib/io-writesb.S
new file mode 100644
index 0000000..bfcb91e
--- /dev/null
+++ b/arch/unicore32/lib/io-writesb.S
@@ -0,0 +1,90 @@
+/*
+ * linux/arch/unicore32/lib/io-writesb.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.macro	outword, rd
+		stb	\rd, [r0]
+		mov	\rd, \rd >> #8
+		stb	\rd, [r0]
+		mov	\rd, \rd >> #8
+		stb	\rd, [r0]
+		mov	\rd, \rd >> #8
+		stb	\rd, [r0]
+		.endm
+
+.Loutsb_align:	rsub	ip, ip, #4
+		csub.a	ip, r2
+		cmovsg	ip, r2
+		csub.a	ip, #2
+		ldb.w	r3, [r1]+, #1
+		stb	r3, [r0]
+		bsl	201f
+		ldb.w	r3, [r1]+, #1
+		stb	r3, [r0]
+		bel	201f
+		ldb.w	r3, [r1]+, #1
+		stb	r3, [r0]
+201:
+		sub.a	r2, r2, ip
+		bne	.Loutsb_aligned
+
+ENTRY(__raw_writesb)
+		cxor.a	r2, #0	@ do we have to check for the zero len?
+		cmoveq	pc, lr
+		and.a	ip, r1, #3
+		bne	.Loutsb_align
+
+.Loutsb_aligned:
+
+		sub.a	r2, r2, #16
+		bfs	.Loutsb_no_16
+
+.Loutsb_16_lp:	ldm.w	(r3, r4, r5, r14), [r1]+
+		outword	r3
+		outword	r4
+		outword	r5
+		outword	r14
+		sub.a	r2, r2, #16
+		bns	.Loutsb_16_lp
+
+		cand.a	r2, #15
+		cmoveq	pc, lr
+
+.Loutsb_no_16:	cand.a	r2, #8
+		beq	.Loutsb_no_8
+
+		ldm.w	(r3, r4), [r1]+
+		outword	r3
+		outword	r4
+
+.Loutsb_no_8:	cand.a	r2, #4
+		beq	.Loutsb_no_4
+
+		ldw.w	r3, [r1]+, #4
+		outword	r3
+
+.Loutsb_no_4:	and.a	r2, r2, #3
+		cmoveq	pc, lr
+
+		csub.a	r2, #2
+		ldb.w	r3, [r1]+, #1
+		stb	r3, [r0]
+		bsl	201f
+		ldb.w	r3, [r1]+, #1
+		stb	r3, [r0]
+		bel	201f
+		ldb	r3, [r1]
+		stb	r3, [r0]
+201:
+		mov	pc, lr
+ENDPROC(__raw_writesb)
diff --git a/arch/unicore32/lib/io-writesl.S b/arch/unicore32/lib/io-writesl.S
new file mode 100644
index 0000000..a880b47
--- /dev/null
+++ b/arch/unicore32/lib/io-writesl.S
@@ -0,0 +1,69 @@
+/*
+ * linux/arch/unicore32/lib/io-writesl.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+ENTRY(__raw_writesl)
+		cxor.a	r2, #0	@ do we have to check for the zero len?
+		cmoveq	pc, lr
+		and.a	ip, r1, #3
+		bne	3f
+
+		sub.a	r2, r2, #4
+		bfs	2f
+1:		ldm.w	(r3, r4, r14, r15), [r1]+
+		sub.a	r2, r2, #4
+		stw	r3, [r0+], #0
+		stw	r4, [r0+], #0
+		stw	r14, [r0+], #0
+		stw	r15, [r0+], #0
+		bns	1b
+2:		mov.a	r2, r2 << #31
+		bub	201f
+		ldm.w	(r3, r14), [r1]+
+		stw	r3, [r0+], #0
+		stw	r14, [r0+], #0
+201:		cmoveq	pc, lr
+		ldw	r3, [r1+], #0
+		stw	r3, [r0+], #0
+		mov	pc, lr
+
+3:		andn	r1, r1, #3
+		ldw.w	r3, [r1]+, #4
+		csub.a	ip, #2
+		bsl	5f
+		bsg	6f
+
+4:		mov	ip, r3 pull #16
+		ldw.w	r3, [r1]+, #4
+		sub.a	r2, r2, #1
+		or	ip, ip, r3 push #16
+		stw	ip, [r0]
+		bne	4b
+		mov	pc, lr
+
+5:		mov	ip, r3 pull #8
+		ldw.w	r3, [r1]+, #4
+		sub.a	r2, r2, #1
+		or	ip, ip, r3 push #24
+		stw	ip, [r0]
+		bne	5b
+		mov	pc, lr
+
+6:		mov	ip, r3 pull #24
+		ldw.w	r3, [r1]+, #4
+		sub.a	r2, r2, #1
+		or	ip, ip, r3 push #8
+		stw	ip, [r0]
+		bne	6b
+		mov	pc, lr
+ENDPROC(__raw_writesl)
diff --git a/arch/unicore32/lib/io-writesw.S b/arch/unicore32/lib/io-writesw.S
new file mode 100644
index 0000000..23e1f16
--- /dev/null
+++ b/arch/unicore32/lib/io-writesw.S
@@ -0,0 +1,87 @@
+/*
+ * linux/arch/unicore32/lib/io-writesw.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+
+		.macro	outword, rd
+		sth	\rd, [r0]
+		mov	\rd, \rd >> #16
+		sth	\rd, [r0]
+		.endm
+
+.Loutsw_align:	mov.a	ip, r1 << #31
+		bne	.Loutsw_noalign
+
+		ldh.w	r3, [r1]+, #2
+		sub	r2, r2, #1
+		sth	r3, [r0]
+
+ENTRY(__raw_writesw)
+		cxor.a	r2, #0
+		cmoveq	pc, lr
+		and.a	r3, r1, #3
+		bne	.Loutsw_align
+
+		sub.a	r2, r2, #8
+		bfs	.Lno_outsw_8
+
+.Loutsw_8_lp:	ldm.w	(r3, r4, r5, r14), [r1]+
+		sub.a	r2, r2, #8
+		outword	r3
+		outword	r4
+		outword	r5
+		outword	r14
+		bns	.Loutsw_8_lp
+
+.Lno_outsw_8:	cand.a	r2, #4
+		beq	.Lno_outsw_4
+
+		ldm.w	(r3, r14), [r1]+
+		outword	r3
+		outword	r14
+
+.Lno_outsw_4:	mov.a	r2, r2 << #31
+		bub	.Lno_outsw_2
+
+		ldw.w	r3, [r1]+, #4
+		outword	r3
+
+.Lno_outsw_2:	cmoveq	pc, lr
+		ldh	r3, [r1]
+		sth	r3, [r0]
+
+		mov	pc, lr
+
+.Loutsw_noalign:
+		ldw.w	r3, [r1-], r3
+		bub	201f
+		sub	r2, r2, #1
+		b	2f
+201:
+		sub.a	r2, r2, #2
+		bfs	3f
+
+1:		mov	ip, r3 >> #8
+		sth	ip, [r0]
+2:		mov	ip, r3 >> #24
+		ldw.w	r3, [r1+], #4
+		sub.a	r2, r2, #2
+		or	ip, ip, r3 << #8
+		sth	ip, [r0]
+		bns	1b
+
+		cand.a	r2, #1
+3:		cmoveq	pc, lr
+		mov	ip, r3 >> #8
+		sth	ip, [r0]
+		mov	pc, lr
+ENDPROC(__raw_writesw)

