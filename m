Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1ACLyH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:54:07 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:48697 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1ACLyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:54:05 -0500
From: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv1 7/8] unicore32 additional architecture files: low-level lib: checksum
Date: Mon, 3 Jan 2011 19:54:03 +0800
Message-ID: <013101cbab3c$eb0a7670$c11f6350$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AcurPOOj4M36NFNnT9a7X0eoOisFHQ==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>

Patch 7 implements low-level checksum libraries.

Signed-off-by: Guan Xuetao <guanxuetao@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/checksum.h       |  142 +++++++++++
 arch/unicore32/lib/csumipv6.S               |   36 +++
 arch/unicore32/lib/csumpartial.S            |  126 ++++++++++
 arch/unicore32/lib/csumpartialcopy.S        |   61 +++++
 arch/unicore32/lib/csumpartialcopygeneric.S |  335 +++++++++++++++++++++++++++
 arch/unicore32/lib/csumpartialcopyuser.S    |   92 ++++++++
 6 files changed, 792 insertions(+), 0 deletions(-)

diff --git a/arch/unicore32/include/asm/checksum.h b/arch/unicore32/include/asm/checksum.h
new file mode 100644
index 0000000..59a97d8
--- /dev/null
+++ b/arch/unicore32/include/asm/checksum.h
@@ -0,0 +1,142 @@
+/*
+ * linux/arch/unicore32/include/asm/checksum.h
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * IP checksum routines
+ */
+#ifndef __UNICORE_CHECKSUM_H__
+#define __UNICORE_CHECKSUM_H__
+
+#include <linux/in6.h>
+
+/*
+ * computes the checksum of a memory block at buff, length len,
+ * and adds in "sum" (32-bit)
+ *
+ * returns a 32-bit number suitable for feeding into itself
+ * or csum_tcpudp_magic
+ *
+ * this function must be called with even lengths, except
+ * for the last fragment, which may be odd
+ *
+ * it's best to have buff aligned on a 32-bit boundary
+ */
+__wsum csum_partial(const void *buff, int len, __wsum sum);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums, and handles user-space pointer exceptions correctly, when needed.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+
+__wsum
+csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum);
+
+__wsum
+csum_partial_copy_from_user(const void __user *src, void *dst,
+		int len, __wsum sum, int *err_ptr);
+
+/*
+ *	Fold a partial checksum without adding pseudo headers
+ */
+static inline __sum16 csum_fold(__wsum sum)
+{
+	__asm__(
+	"add	%0, %1, %1 <> #16	@ csum_fold"
+	: "=r" (sum)
+	: "r" (sum)
+	: "cc");
+	return (__force __sum16)(~(__force u32)sum >> 16);
+}
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ */
+static inline __sum16
+ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	unsigned int tmp1;
+	__wsum sum;
+
+	__asm__ __volatile__(
+	"ldw.w	%0, [%1]+, #4		@ ip_fast_csum"
+	"ldw.w	%3, [%1]+, #4"
+	"sub	%2, %2, #5"
+	"add.a	%0, %0, %3"
+	"ldw.w	%3, [%1]+, #4"
+	"addc.a	%0, %0, %3"
+	"ldw.w	%3, [%1]+, #4"
+"1:	addc.a	%0, %0, %3"
+	"ldw.w	%3, [%1]+, #4"
+	"cmpand.a	%2, #15		@ do this carefully"
+	"beq	2f"
+	"sub	%2, %2, #1		@ without destroying"
+	"bne	1b			@ the carry flag"
+"2:	addc.a	%0, %0, %3"
+	"addc	%0, %0, #0"
+	: "=r" (sum), "=r" (iph), "=r" (ihl), "=r" (tmp1)
+	: "1" (iph), "2" (ihl)
+	: "cc", "memory");
+	return csum_fold(sum);
+}
+
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
+{
+	__asm__(
+	"add.a	%0, %1, %2		@ csum_tcpudp_nofold"
+	"addc.a	%0, %0, %3"
+	"addc.a	%0, %0, %4 << #8"
+	"addc.a	%0, %0, %5"
+	"addc	%0, %0, #0"
+	: "=&r"(sum)
+	: "r" (sum), "r" (daddr), "r" (saddr), "r" (len), "Ir" (htons(proto))
+	: "cc");
+	return sum;
+}
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+static inline __sum16
+ip_compute_csum(const void *buff, int len)
+{
+	return csum_fold(csum_partial(buff, len, 0));
+}
+
+#define _HAVE_ARCH_IPV6_CSUM
+extern __wsum
+__csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
+		__be32 len, __be32 proto, __wsum sum);
+
+static inline __sum16
+csum_ipv6_magic(const struct in6_addr *saddr, const struct in6_addr *daddr,
+		__u32 len, unsigned short proto, __wsum sum)
+{
+	return csum_fold(__csum_ipv6_magic(saddr, daddr, htonl(len),
+					   htonl(proto), sum));
+}
+#endif
diff --git a/arch/unicore32/lib/csumipv6.S b/arch/unicore32/lib/csumipv6.S
new file mode 100644
index 0000000..47fad61
--- /dev/null
+++ b/arch/unicore32/lib/csumipv6.S
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/unicore32/lib/csumipv6.S
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
+		.text
+
+ENTRY(__csum_ipv6_magic)
+		stw.w	lr, [sp+], #-4
+		add.a	ip, r2, r3
+
+		ldm   (r1 - r4), [r1]+
+		addc.a	ip, ip, r1
+		addc.a	ip, ip, r2
+		addc.a	ip, ip, r3
+		addc.a	ip, ip, r4
+		ldm	(r0 - r3), [r0]+
+		addc.a	r0, ip, r0
+		addc.a	r0, r0, r1
+		addc.a	r0, r0, r2
+		ldw	r2, [sp+], #4
+		addc.a	r0, r0, r3
+		addc.a	r0, r0, r2
+		addc.a	r0, r0, #0
+		ldm.w	(pc), [sp]+
+ENDPROC(__csum_ipv6_magic)
+
diff --git a/arch/unicore32/lib/csumpartial.S b/arch/unicore32/lib/csumpartial.S
new file mode 100644
index 0000000..23e36c5
--- /dev/null
+++ b/arch/unicore32/lib/csumpartial.S
@@ -0,0 +1,126 @@
+/*
+ * linux/arch/unicore32/lib/csumpartial.S
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
+		.text
+
+/*
+ * Function: __u32 csum_partial(const char *src, int len, __u32 sum)
+ * Params  : r0 = buffer, r1 = len, r2 = checksum
+ * Returns : r0 = new checksum
+ */
+
+buf	.req	r0
+len	.req	r1
+sum	.req	r2
+td0	.req	r3
+td1	.req	r4
+td2	.req	r5
+td3	.req	r6
+
+.Lzero:		mov	r0, sum
+		add	sp, sp, #4
+		ldw.w	pc, [sp]+, #4
+
+		/*
+		 * Handle 0 to 7 bytes, with any alignment of source and
+		 * destination pointers.  Note that when we get here, C = 0
+		 */
+.Lless8:		cxor.a	len, #0			@ check for zero count
+		beq	.Lzero
+
+		/* we must have at least one byte. */
+		cand.a	buf, #1				@ odd address?
+		beq	.Lless4
+		mov	sum, sum <> #8
+		ldb.w	td0, [buf]+, #1
+		sub	len, len, #1
+		addc.a	sum, sum, td0 put_byte_1
+
+.Lless4:	cand.a	len, #6
+		beq	.Lless8_byte
+
+		/* we are now half-word aligned */
+
+.Lless8_wordlp:
+		ldh.w	td0, [buf]+, #2
+		sub	len, len, #2
+		addc.a	sum, sum, td0
+		cand.a	len, #6
+		bne	.Lless8_wordlp
+
+.Lless8_byte:	cand.a	len, #1			@ odd number of bytes
+		beq	.Ldone
+		ldb.w	td0, [buf]+, #1		@ include last byte
+		addc.a	sum, sum, td0 put_byte_0	@ update checksum
+
+.Ldone:		addc	r0, sum, #0		@ collect up the last carry
+		ldw.w	td0, [sp]+, #4
+		cand.a	td0, #1			@ check buffer alignment
+		cmovne	r0, r0 <> #8		@ rotate checksum by 8 bits
+		ldw.w	pc, [sp]+, #4		@ return
+
+.Lnot_aligned:	cand.a	buf, #1			@ odd address
+		beq	201f
+		ldb.w	td0, [buf]+, #1		@ make even
+		sub	len, len, #1
+		addc.a	sum, sum, td0 put_byte_1	@ update checksum
+	201:
+		cand.a	buf, #2			@ 32-bit aligned?
+		beq	201f
+		ldh.w	td0, [buf]+, #2		@ make 32-bit aligned
+		sub	len, len, #2
+		addc.a	sum, sum, td0		@ update checksum
+	201:
+		mov	pc, lr
+
+ENTRY(csum_partial)
+		stm.w	(lr), [sp-]
+		stm.w	(buf), [sp-]
+		csub.a	len, #8			@ Ensure that we have at least
+		bub	.Lless8			@ 8 bytes to copy.
+
+		cand.a	buf, #1
+		cmovne	sum, sum <> #8
+
+		add.a	sum, sum, #0		@ C = 0
+		cand.a	buf, #3			@ Test destination alignment
+		bne.l	.Lnot_aligned		@ align destination, return here
+
+1:		andn.a	ip, len, #31
+		beq	3f
+
+2:		ldm.w	(td0, td1, td2, td3), [buf]+
+		addc.a	sum, sum, td0
+		addc.a	sum, sum, td1
+		addc.a	sum, sum, td2
+		addc.a	sum, sum, td3
+		ldm.w	(td0, td1, td2, td3), [buf]+
+		addc.a	sum, sum, td0
+		addc.a	sum, sum, td1
+		addc.a	sum, sum, td2
+		addc.a	sum, sum, td3
+		sub	ip, ip, #32
+		cxor.a	ip, #0
+		bne	2b
+
+3:		cand.a	len, #0x1c		@ should not change C
+		beq	.Lless4
+
+4:		ldw.w	td0, [buf]+, #4
+		sub	len, len, #4
+		addc.a	sum, sum, td0
+		cand.a	len, #0x1c
+		bne	4b
+		b	.Lless4
+ENDPROC(csum_partial)
diff --git a/arch/unicore32/lib/csumpartialcopy.S b/arch/unicore32/lib/csumpartialcopy.S
new file mode 100644
index 0000000..e4fa5c2
--- /dev/null
+++ b/arch/unicore32/lib/csumpartialcopy.S
@@ -0,0 +1,61 @@
+/*
+ * linux/arch/unicore32/lib/csumpartialcopy.S
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
+		.text
+
+/*
+ * Function: __u32 csum_partial_copy_nocheck
+ * 			(const char *src, char *dst, int len, __u32 sum)
+ * Params  : r0 = src, r1 = dst, r2 = len, r3 = checksum
+ * Returns : r0 = new checksum
+ */
+
+		.macro	save_regs
+		mov	ip, sp
+		stm.w	(fp, ip, lr, pc), [sp-]
+		stm.w	(r1), [sp-]
+		sub	fp, ip, #4
+		.endm
+
+		.macro	load_regs
+		ldm.w	(r1), [sp]+
+		ldm	(fp, sp, pc), [sp]+
+		.endm
+
+		.macro	load1b, reg1
+		ldb.w	\reg1, [r0]+, #1
+		.endm
+
+		.macro	load2b, reg1, reg2
+		ldb.w	\reg1, [r0]+, #1
+		ldb.w	\reg2, [r0]+, #1
+		.endm
+
+		.macro	load1l, reg1
+		ldw.w	\reg1, [r0]+, #4
+		.endm
+
+		.macro	load2l, reg1, reg2
+		ldw.w	\reg1, [r0]+, #4
+		ldw.w	\reg2, [r0]+, #4
+		.endm
+
+		.macro	load4l, reg1, reg2, reg3, reg4
+		ldm.w	(\reg1, \reg2, \reg3, \reg4), [r0]+
+		.endm
+
+#define FN_ENTRY	ENTRY(csum_partial_copy_nocheck)
+#define FN_EXIT		ENDPROC(csum_partial_copy_nocheck)
+
+#include "csumpartialcopygeneric.S"
diff --git a/arch/unicore32/lib/csumpartialcopygeneric.S b/arch/unicore32/lib/csumpartialcopygeneric.S
new file mode 100644
index 0000000..d5a4a3d
--- /dev/null
+++ b/arch/unicore32/lib/csumpartialcopygeneric.S
@@ -0,0 +1,335 @@
+/*
+ * linux/arch/unicore32/lib/csumpartialcopygeneric.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * unsigned int
+ * csum_partial_copy_xxx(const char *src, char *dst, int len, int sum, )
+ *  r0 = src, r1 = dst, r2 = len, r3 = sum
+ *  Returns : r0 = checksum
+ *
+ * Note that 'tst' and 'teq' preserve the carry flag.
+ */
+
+src	.req	r0
+dst	.req	r1
+len	.req	r2
+sum	.req	r3
+
+.Lzero:		mov	r0, sum
+		load_regs
+
+		/*
+		 * Align an unaligned destination pointer.  We know that
+		 * we have >= 8 bytes here, so we don't need to check
+		 * the length.  Note that the source pointer hasn't been
+		 * aligned yet.
+		 */
+.Ldst_unaligned:
+		cand.a	dst, #1
+		beq	.Ldst_16bit
+
+		load1b	ip
+		sub	len, len, #1
+		addc.a	sum, sum, ip put_byte_1		@ update checksum
+		stb.w	ip, [dst]+, #1
+		cand.a	dst, #2
+		cmoveq	pc, lr			@ dst is now 32bit aligned
+
+.Ldst_16bit:	load2b	r8, ip
+		sub	len, len, #2
+		addc.a	sum, sum, r8 put_byte_0
+		stb.w	r8, [dst]+, #1
+		addc.a	sum, sum, ip put_byte_1
+		stb.w	ip, [dst]+, #1
+		mov	pc, lr			@ dst is now 32bit aligned
+
+		/*
+		 * Handle 0 to 7 bytes, with any alignment of source and
+		 * destination pointers.  Note that when we get here, C = 0
+		 */
+.Lless8:	cxor.a	len, #0			@ check for zero count
+		beq	.Lzero
+
+		/* we must have at least one byte. */
+		cand.a	dst, #1				@ dst 16-bit aligned
+		beq	.Lless8_aligned
+
+		/* Align dst */
+		load1b	ip
+		sub	len, len, #1
+		addc.a	sum, sum, ip put_byte_1		@ update checksum
+		stb.w	ip, [dst]+, #1
+		cand.a	len, #6
+		beq	.Lless8_byteonly
+
+1:		load2b	r8, ip
+		sub	len, len, #2
+		addc.a	sum, sum, r8 put_byte_0
+		stb.w	r8, [dst]+, #1
+		addc.a	sum, sum, ip put_byte_1
+		stb.w	ip, [dst]+, #1
+.Lless8_aligned:
+		cand.a	len, #6
+		bne	1b
+.Lless8_byteonly:
+		cand.a	len, #1
+		beq	.Ldone
+		load1b	r8
+		addc.a	sum, sum, r8 put_byte_0		@ update checksum
+		stb.w	r8, [dst]+, #1
+		b	.Ldone
+
+FN_ENTRY
+		save_regs
+
+		csub.a	len, #8			@ Ensure that we have at least
+		bub	.Lless8			@ 8 bytes to copy.
+
+		add.a	sum, sum, #0		@ C = 0
+		cand.a	dst, #3			@ Test destination alignment
+		bne.l	.Ldst_unaligned		@ align destination, return here
+
+		/*
+		 * Ok, the dst pointer is now 32bit aligned, and we know
+		 * that we must have more than 4 bytes to copy.  Note
+		 * that C contains the carry from the dst alignment above.
+		 */
+
+		cand.a	src, #3			@ Test source alignment
+		bne	.Lsrc_not_aligned
+
+		/* Routine for src & dst aligned */
+
+		andn.a	ip, len, #15
+		beq	2f
+
+1:		load4l	r4, r5, r6, r7
+		stm.w	(r4, r5, r6, r7), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		addc.a	sum, sum, r6
+		addc.a	sum, sum, r7
+		sub	ip, ip, #16
+		cxor.a	ip, #0
+		bne	1b
+
+2:		and.a	ip, len, #12
+		beq	4f
+		cand.a	ip, #8
+		beq	3f
+		load2l	r4, r5
+		stm.w	(r4, r5), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		cand.a	ip, #4
+		beq	4f
+
+3:		load1l	r4
+		stw.w	r4, [dst]+, #4
+		addc.a	sum, sum, r4
+
+4:		and.a	len, len, #3
+		beq	.Ldone
+		load1l	r4
+		cand.a	len, #2
+		mov	r5, r4 get_byte_0
+		beq	.Lexit
+		addc.a	sum, sum, r4 push #16
+		stb.w	r5, [dst]+, #1
+		mov	r5, r4 get_byte_1
+		stb.w	r5, [dst]+, #1
+		mov	r5, r4 get_byte_2
+.Lexit:		cand.a	len, #1
+		beq	.Ldone
+		stb.w	r5, [dst]+, #1
+		and	r5, r5, #255
+		addc.a	sum, sum, r5 put_byte_0
+
+		/*
+		 * If the dst pointer was not 16-bit aligned, we
+		 * need to rotate the checksum here to get around
+		 * the inefficient byte manipulations in the
+		 * architecture independent code.
+		 */
+.Ldone:		addc	r0, sum, #0
+		ldw	sum, [sp+], #0		@ dst
+		cand.a	sum, #1
+		cmovne	r0, r0 <> #8
+		load_regs
+
+.Lsrc_not_aligned:
+		addc	sum, sum, #0		@ include C from dst alignment
+		and	ip, src, #3
+		andn	src, src, #3
+		load1l	r5
+		csub.a	ip, #2
+		beq	.Lsrc2_aligned
+		bua	.Lsrc3_aligned
+		mov	r4, r5 pull #8		@ C = 0
+		andn.a	ip, len, #15
+		beq	2f
+1:		load4l	r5, r6, r7, r8
+		or	r4, r4, r5 push #24
+		mov	r5, r5 pull #8
+		or	r5, r5, r6 push #24
+		mov	r6, r6 pull #8
+		or	r6, r6, r7 push #24
+		mov	r7, r7 pull #8
+		or	r7, r7, r8 push #24
+		stm.w	(r4, r5, r6, r7), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		addc.a	sum, sum, r6
+		addc.a	sum, sum, r7
+		mov	r4, r8 pull #8
+		sub	ip, ip, #16
+		cxor.a	ip, #0
+		bne	1b
+2:		and.a	ip, len, #12
+		beq	4f
+		cand.a	ip, #8
+		beq	3f
+		load2l	r5, r6
+		or	r4, r4, r5 push #24
+		mov	r5, r5 pull #8
+		or	r5, r5, r6 push #24
+		stm.w	(r4, r5), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		mov	r4, r6 pull #8
+		cand.a	ip, #4
+		beq	4f
+3:		load1l	r5
+		or	r4, r4, r5 push #24
+		stw.w	r4, [dst]+, #4
+		addc.a	sum, sum, r4
+		mov	r4, r5 pull #8
+4:		and.a	len, len, #3
+		beq	.Ldone
+		mov	r5, r4 get_byte_0
+		cand.a	len, #2
+		beq	.Lexit
+		addc.a	sum, sum, r4 push #16
+		stb.w	r5, [dst]+, #1
+		mov	r5, r4 get_byte_1
+		stb.w	r5, [dst]+, #1
+		mov	r5, r4 get_byte_2
+		b	.Lexit
+
+.Lsrc2_aligned:	mov	r4, r5 pull #16
+		add.a	sum, sum, #0
+		andn.a	ip, len, #15
+		beq	2f
+1:		load4l	r5, r6, r7, r8
+		or	r4, r4, r5 push #16
+		mov	r5, r5 pull #16
+		or	r5, r5, r6 push #16
+		mov	r6, r6 pull #16
+		or	r6, r6, r7 push #16
+		mov	r7, r7 pull #16
+		or	r7, r7, r8 push #16
+		stm.w	(r4, r5, r6, r7), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		addc.a	sum, sum, r6
+		addc.a	sum, sum, r7
+		mov	r4, r8 pull #16
+		sub	ip, ip, #16
+		cxor.a	ip, #0
+		bne	1b
+2:		and.a	ip, len, #12
+		beq	4f
+		cand.a	ip, #8
+		beq	3f
+		load2l	r5, r6
+		or	r4, r4, r5 push #16
+		mov	r5, r5 pull #16
+		or	r5, r5, r6 push #16
+		stm.w	(r4, r5), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		mov	r4, r6 pull #16
+		cand.a	ip, #4
+		beq	4f
+3:		load1l	r5
+		or	r4, r4, r5 push #16
+		stw.w	r4, [dst]+, #4
+		addc.a	sum, sum, r4
+		mov	r4, r5 pull #16
+4:		and.a	len, len, #3
+		beq	.Ldone
+		mov	r5, r4 get_byte_0
+		cand.a	len, #2
+		beq	.Lexit
+		addc.a	sum, sum, r4
+		stb.w	r5, [dst]+, #1
+		mov	r5, r4 get_byte_1
+		stb.w	r5, [dst]+, #1
+		cand.a	len, #1
+		beq	.Ldone
+		load1b	r5
+		b	.Lexit
+
+.Lsrc3_aligned:	mov	r4, r5 pull #24
+		add.a	sum, sum, #0
+		andn.a	ip, len, #15
+		beq	2f
+1:		load4l	r5, r6, r7, r8
+		or	r4, r4, r5 push #8
+		mov	r5, r5 pull #24
+		or	r5, r5, r6 push #8
+		mov	r6, r6 pull #24
+		or	r6, r6, r7 push #8
+		mov	r7, r7 pull #24
+		or	r7, r7, r8 push #8
+		stm.w	(r4, r5, r6, r7), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		addc.a	sum, sum, r6
+		addc.a	sum, sum, r7
+		mov	r4, r8 pull #24
+		sub	ip, ip, #16
+		cxor.a	ip, #0
+		bne	1b
+2:		and.a	ip, len, #12
+		beq	4f
+		cand.a	ip, #8
+		beq	3f
+		load2l	r5, r6
+		or	r4, r4, r5 push #8
+		mov	r5, r5 pull #24
+		or	r5, r5, r6 push #8
+		stm.w	(r4, r5), [dst]+
+		addc.a	sum, sum, r4
+		addc.a	sum, sum, r5
+		mov	r4, r6 pull #24
+		cand.a	ip, #4
+		beq	4f
+3:		load1l	r5
+		or	r4, r4, r5 push #8
+		stw.w	r4, [dst]+, #4
+		addc.a	sum, sum, r4
+		mov	r4, r5 pull #24
+4:		and.a	len, len, #3
+		beq	.Ldone
+		mov	r5, r4 get_byte_0
+		cand.a	len, #2
+		beq	.Lexit
+		stb.w	r5, [dst]+, #1
+		addc.a	sum, sum, r4
+		load1l	r4
+		mov	r5, r4 get_byte_0
+		stb.w	r5, [dst]+, #1
+		addc.a	sum, sum, r4 push #24
+		mov	r5, r4 get_byte_1
+		b	.Lexit
+FN_EXIT
diff --git a/arch/unicore32/lib/csumpartialcopyuser.S b/arch/unicore32/lib/csumpartialcopyuser.S
new file mode 100644
index 0000000..23a292f
--- /dev/null
+++ b/arch/unicore32/lib/csumpartialcopyuser.S
@@ -0,0 +1,92 @@
+/*
+ * linux/arch/unicore32/lib/csumpartialcopyuser.S
+ *
+ * Code specific to PKUnity SoC and UniCore ISA
+ *
+ * Copyright (C) 2001-2010 GUAN Xue-tao
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * 27/03/03 Ian Molton Clean up CONFIG_CPU
+ *
+ */
+#include <linux/linkage.h>
+#include <asm/assembler.h>
+#include <asm/errno.h>
+#include <generated/asm-offsets.h>
+
+		.text
+
+		.macro	save_regs
+		mov	ip, sp
+		stm.w	(fp, ip, lr, pc), [sp-]
+		stm.w	(r1 - r2), [sp-]
+		sub	fp, ip, #4
+		.endm
+
+		.macro	load_regs
+		ldm.w	(r1 - r2), [sp]+
+		ldm	(fp, sp, pc), [sp]+
+		.endm
+
+		.macro	load1b,	reg1
+		ldrusr	\reg1, r0, 1
+		.endm
+
+		.macro	load2b, reg1, reg2
+		ldrusr	\reg1, r0, 1
+		ldrusr	\reg2, r0, 1
+		.endm
+
+		.macro	load1l, reg1
+		ldrusr	\reg1, r0, 4
+		.endm
+
+		.macro	load2l, reg1, reg2
+		ldrusr	\reg1, r0, 4
+		ldrusr	\reg2, r0, 4
+		.endm
+
+		.macro	load4l, reg1, reg2, reg3, reg4
+		ldrusr	\reg1, r0, 4
+		ldrusr	\reg2, r0, 4
+		ldrusr	\reg3, r0, 4
+		ldrusr	\reg4, r0, 4
+		.endm
+
+/*
+ * unsigned int
+ * csum_partial_copy_from_user
+ *		(const char *src, char *dst, int len, int sum, int *err_ptr)
+ *  r0 = src, r1 = dst, r2 = len, r3 = sum, [sp] = *err_ptr
+ *  Returns : r0 = checksum, [[sp, #0], #0] = 0 or -EFAULT
+ */
+
+#define FN_ENTRY	ENTRY(csum_partial_copy_from_user)
+#define FN_EXIT		ENDPROC(csum_partial_copy_from_user)
+
+#include "csumpartialcopygeneric.S"
+
+/*
+ * FIXME: minor buglet here
+ * We don't return the checksum for the data present in the buffer.  To do
+ * so properly, we would have to add in whatever registers were loaded before
+ * the fault, which, with the current asm above is not predictable.
+ */
+		.pushsection .fixup,"ax"
+		.align	4
+9001:		mov	r4, #-EFAULT
+		ldw	r5, [sp+], #8*4		@ *err_ptr
+		stw	r4, [r5]
+		ldm	(r1, r2), [sp]+		@ retrieve dst, len
+		add	r2, r2, r1
+		mov	r0, #0			@ zero the buffer
+9002:		cxor.a	r2, r1
+		beq	201f
+		stb.w	r0, [r1]+, #1
+		b	9002b
+201:
+		load_regs
+		.popsection

