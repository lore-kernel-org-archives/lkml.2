Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab2KGJwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:52:36 -0500
Received: from us02smtp2.synopsys.com ([198.182.60.77]:39269 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2KGJs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:28 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 10/31] ARC: string library
Date: Wed,  7 Nov 2012 10:47:33 +0100
Message-Id: <1352281674-2186-11-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/string.h |   40 +++++++++++++
 arch/arc/lib/memcmp.S         |  124 +++++++++++++++++++++++++++++++++++++++++
 arch/arc/lib/memcpy-700.S     |   66 ++++++++++++++++++++++
 arch/arc/lib/memset.S         |   59 +++++++++++++++++++
 arch/arc/lib/strchr-700.S     |  123 ++++++++++++++++++++++++++++++++++++++++
 arch/arc/lib/strcmp.S         |   96 +++++++++++++++++++++++++++++++
 arch/arc/lib/strcpy-700.S     |   70 +++++++++++++++++++++++
 arch/arc/lib/strlen.S         |   83 +++++++++++++++++++++++++++
 8 files changed, 661 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/string.h
 create mode 100644 arch/arc/lib/memcmp.S
 create mode 100644 arch/arc/lib/memcpy-700.S
 create mode 100644 arch/arc/lib/memset.S
 create mode 100644 arch/arc/lib/strchr-700.S
 create mode 100644 arch/arc/lib/strcmp.S
 create mode 100644 arch/arc/lib/strcpy-700.S
 create mode 100644 arch/arc/lib/strlen.S

diff --git a/arch/arc/include/asm/string.h b/arch/arc/include/asm/string.h
new file mode 100644
index 0000000..87676c8
--- /dev/null
+++ b/arch/arc/include/asm/string.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: May 2011
+ *  -We had half-optimised memset/memcpy, got better versions of those
+ *  -Added memcmp, strchr, strcpy, strcmp, strlen
+ *
+ * Amit Bhor: Codito Technologies 2004
+ */
+
+#ifndef _ASM_ARC_STRING_H
+#define _ASM_ARC_STRING_H
+
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+
+#define __HAVE_ARCH_MEMSET
+#define __HAVE_ARCH_MEMCPY
+#define __HAVE_ARCH_MEMCMP
+#define __HAVE_ARCH_STRCHR
+#define __HAVE_ARCH_STRCPY
+#define __HAVE_ARCH_STRCMP
+#define __HAVE_ARCH_STRLEN
+
+extern void *memset(void *ptr, int, __kernel_size_t);
+extern void *memcpy(void *, const void *, __kernel_size_t);
+extern void memzero(void *ptr, __kernel_size_t n);
+extern int memcmp(const void *, const void *, __kernel_size_t);
+extern char *strchr(const char *s, int c);
+extern char *strcpy(char *dest, const char *src);
+extern int strcmp(const char *cs, const char *ct);
+extern __kernel_size_t strlen(const char *);
+
+#endif /* __KERNEL__ */
+#endif /* _ASM_ARC_STRING_H */
diff --git a/arch/arc/lib/memcmp.S b/arch/arc/lib/memcmp.S
new file mode 100644
index 0000000..bc813d5
--- /dev/null
+++ b/arch/arc/lib/memcmp.S
@@ -0,0 +1,124 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/linkage.h>
+
+#ifdef __LITTLE_ENDIAN__
+#define WORD2 r2
+#define SHIFT r3
+#else /* BIG ENDIAN */
+#define WORD2 r3
+#define SHIFT r2
+#endif
+
+ARC_ENTRY memcmp
+	or	r12,r0,r1
+	asl_s	r12,r12,30
+	sub	r3,r2,1
+	brls	r2,r12,.Lbytewise
+	ld	r4,[r0,0]
+	ld	r5,[r1,0]
+	lsr.f	lp_count,r3,3
+	lpne	.Loop_end
+	ld_s	WORD2,[r0,4]
+	ld_s	r12,[r1,4]
+	brne	r4,r5,.Leven
+	ld.a	r4,[r0,8]
+	ld.a	r5,[r1,8]
+	brne	WORD2,r12,.Lodd
+.Loop_end:
+	asl_s	SHIFT,SHIFT,3
+	bhs_s	.Last_cmp
+	brne	r4,r5,.Leven
+	ld	r4,[r0,4]
+	ld	r5,[r1,4]
+#ifdef __LITTLE_ENDIAN__
+	nop_s
+	; one more load latency cycle
+.Last_cmp:
+	xor	r0,r4,r5
+	bset	r0,r0,SHIFT
+	sub_s	r1,r0,1
+	bic_s	r1,r1,r0
+	norm	r1,r1
+	b.d	.Leven_cmp
+	and	r1,r1,24
+.Leven:
+	xor	r0,r4,r5
+	sub_s	r1,r0,1
+	bic_s	r1,r1,r0
+	norm	r1,r1
+	; slow track insn
+	and	r1,r1,24
+.Leven_cmp:
+	asl	r2,r4,r1
+	asl	r12,r5,r1
+	lsr_s	r2,r2,1
+	lsr_s	r12,r12,1
+	j_s.d	[blink]
+	sub	r0,r2,r12
+	.balign	4
+.Lodd:
+	xor	r0,WORD2,r12
+	sub_s	r1,r0,1
+	bic_s	r1,r1,r0
+	norm	r1,r1
+	; slow track insn
+	and	r1,r1,24
+	asl_s	r2,r2,r1
+	asl_s	r12,r12,r1
+	lsr_s	r2,r2,1
+	lsr_s	r12,r12,1
+	j_s.d	[blink]
+	sub	r0,r2,r12
+#else /* BIG ENDIAN */
+.Last_cmp:
+	neg_s	SHIFT,SHIFT
+	lsr	r4,r4,SHIFT
+	lsr	r5,r5,SHIFT
+	; slow track insn
+.Leven:
+	sub.f	r0,r4,r5
+	mov.ne	r0,1
+	j_s.d	[blink]
+	bset.cs	r0,r0,31
+.Lodd:
+	cmp_s	WORD2,r12
+
+	mov_s	r0,1
+	j_s.d	[blink]
+	bset.cs	r0,r0,31
+#endif /* ENDIAN */
+	.balign	4
+.Lbytewise:
+	breq	r2,0,.Lnil
+	ldb	r4,[r0,0]
+	ldb	r5,[r1,0]
+	lsr.f	lp_count,r3
+	lpne	.Lbyte_end
+	ldb_s	r3,[r0,1]
+	ldb	r12,[r1,1]
+	brne	r4,r5,.Lbyte_even
+	ldb.a	r4,[r0,2]
+	ldb.a	r5,[r1,2]
+	brne	r3,r12,.Lbyte_odd
+.Lbyte_end:
+	bcc	.Lbyte_even
+	brne	r4,r5,.Lbyte_even
+	ldb_s	r3,[r0,1]
+	ldb_s	r12,[r1,1]
+.Lbyte_odd:
+	j_s.d	[blink]
+	sub	r0,r3,r12
+.Lbyte_even:
+	j_s.d	[blink]
+	sub	r0,r4,r5
+.Lnil:
+	j_s.d	[blink]
+	mov	r0,0
+ARC_EXIT memcmp
diff --git a/arch/arc/lib/memcpy-700.S b/arch/arc/lib/memcpy-700.S
new file mode 100644
index 0000000..b64cc10
--- /dev/null
+++ b/arch/arc/lib/memcpy-700.S
@@ -0,0 +1,66 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/linkage.h>
+
+ARC_ENTRY memcpy
+	or	r3,r0,r1
+	asl_s	r3,r3,30
+	mov_s	r5,r0
+	brls.d	r2,r3,.Lcopy_bytewise
+	sub.f	r3,r2,1
+	ld_s	r12,[r1,0]
+	asr.f	lp_count,r3,3
+	bbit0.d	r3,2,.Lnox4
+	bmsk_s	r2,r2,1
+	st.ab	r12,[r5,4]
+	ld.a	r12,[r1,4]
+.Lnox4:
+	lppnz	.Lendloop
+	ld_s	r3,[r1,4]
+	st.ab	r12,[r5,4]
+	ld.a	r12,[r1,8]
+	st.ab	r3,[r5,4]
+.Lendloop:
+	breq	r2,0,.Last_store
+	ld	r3,[r5,0]
+#ifdef __LITTLE_ENDIAN__
+	add3	r2,-1,r2
+	; uses long immediate
+	xor_s	r12,r12,r3
+	bmsk	r12,r12,r2
+    xor_s	r12,r12,r3
+#else /* BIG ENDIAN */
+	sub3	r2,31,r2
+	; uses long immediate
+        xor_s	r3,r3,r12
+        bmsk	r3,r3,r2
+        xor_s	r12,r12,r3
+#endif /* ENDIAN */
+.Last_store:
+	j_s.d	[blink]
+	st	r12,[r5,0]
+
+	.balign	4
+.Lcopy_bytewise:
+	jcs	[blink]
+	ldb_s	r12,[r1,0]
+	lsr.f	lp_count,r3
+	bhs_s	.Lnox1
+	stb.ab	r12,[r5,1]
+	ldb.a	r12,[r1,1]
+.Lnox1:
+	lppnz	.Lendbloop
+	ldb_s	r3,[r1,1]
+	stb.ab	r12,[r5,1]
+	ldb.a	r12,[r1,2]
+	stb.ab	r3,[r5,1]
+.Lendbloop:
+	j_s.d	[blink]
+	stb	r12,[r5,0]
+ARC_EXIT memcpy
diff --git a/arch/arc/lib/memset.S b/arch/arc/lib/memset.S
new file mode 100644
index 0000000..9b2d88d
--- /dev/null
+++ b/arch/arc/lib/memset.S
@@ -0,0 +1,59 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/linkage.h>
+
+#define SMALL	7 /* Must be at least 6 to deal with alignment/loop issues.  */
+
+ARC_ENTRY memset
+	mov_s	r4,r0
+	or	r12,r0,r2
+	bmsk.f	r12,r12,1
+	extb_s	r1,r1
+	asl	r3,r1,8
+	beq.d	.Laligned
+	or_s	r1,r1,r3
+	brls	r2,SMALL,.Ltiny
+	add	r3,r2,r0
+	stb	r1,[r3,-1]
+	bclr_s	r3,r3,0
+	stw	r1,[r3,-2]
+	bmsk.f	r12,r0,1
+	add_s	r2,r2,r12
+	sub.ne	r2,r2,4
+	stb.ab	r1,[r4,1]
+	and	r4,r4,-2
+	stw.ab	r1,[r4,2]
+	and	r4,r4,-4
+.Laligned:	; This code address should be aligned for speed.
+	asl	r3,r1,16
+	lsr.f	lp_count,r2,2
+	or_s	r1,r1,r3
+	lpne	.Loop_end
+	st.ab	r1,[r4,4]
+.Loop_end:
+	j_s	[blink]
+
+	.balign	4
+.Ltiny:
+	mov.f	lp_count,r2
+	lpne	.Ltiny_end
+	stb.ab	r1,[r4,1]
+.Ltiny_end:
+	j_s	[blink]
+ARC_EXIT memset
+
+; memzero: @r0 = mem, @r1 = size_t
+; memset:  @r0 = mem, @r1 = char, @r2 = size_t
+
+ARC_ENTRY memzero
+    ; adjust bzero args to memset args
+    mov r2, r1
+    mov r1, 0
+    b  memset    ;tail call so need to tinker with blink
+ARC_EXIT memzero
diff --git a/arch/arc/lib/strchr-700.S b/arch/arc/lib/strchr-700.S
new file mode 100644
index 0000000..99c1047
--- /dev/null
+++ b/arch/arc/lib/strchr-700.S
@@ -0,0 +1,123 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* ARC700 has a relatively long pipeline and branch prediction, so we want
+   to avoid branches that are hard to predict.  On the other hand, the
+   presence of the norm instruction makes it easier to operate on whole
+   words branch-free.  */
+
+#include <asm/linkage.h>
+
+ARC_ENTRY strchr
+	extb_s	r1,r1
+	asl	r5,r1,8
+	bmsk	r2,r0,1
+	or	r5,r5,r1
+	mov_s	r3,0x01010101
+	breq.d	r2,r0,.Laligned
+	asl	r4,r5,16
+	sub_s	r0,r0,r2
+	asl	r7,r2,3
+	ld_s	r2,[r0]
+#ifdef __LITTLE_ENDIAN__
+	asl	r7,r3,r7
+#else
+	lsr	r7,r3,r7
+#endif
+	or	r5,r5,r4
+	ror	r4,r3
+	sub	r12,r2,r7
+	bic_s	r12,r12,r2
+	and	r12,r12,r4
+	brne.d	r12,0,.Lfound0_ua
+	xor	r6,r2,r5
+	ld.a	r2,[r0,4]
+	sub	r12,r6,r7
+	bic	r12,r12,r6
+	and	r7,r12,r4
+	breq	r7,0,.Loop ; For speed, we want this branch to be unaligned.
+	b	.Lfound_char ; Likewise this one.
+; /* We require this code address to be unaligned for speed...  */
+.Laligned:
+	ld_s	r2,[r0]
+	or	r5,r5,r4
+	ror	r4,r3
+; /* ... so that this code address is aligned, for itself and ...  */
+.Loop:
+	sub	r12,r2,r3
+	bic_s	r12,r12,r2
+	and	r12,r12,r4
+	brne.d	r12,0,.Lfound0
+	xor	r6,r2,r5
+	ld.a	r2,[r0,4]
+	sub	r12,r6,r3
+	bic	r12,r12,r6
+	and	r7,r12,r4
+	breq	r7,0,.Loop /* ... so that this branch is unaligned.  */
+	; Found searched-for character.  r0 has already advanced to next word.
+#ifdef __LITTLE_ENDIAN__
+/* We only need the information about the first matching byte
+   (i.e. the least significant matching byte) to be exact,
+   hence there is no problem with carry effects.  */
+.Lfound_char:
+	sub	r3,r7,1
+	bic	r3,r3,r7
+	norm	r2,r3
+	sub_s	r0,r0,1
+	asr_s	r2,r2,3
+	j.d	[blink]
+	sub_s	r0,r0,r2
+
+	.balign	4
+.Lfound0_ua:
+	mov	r3,r7
+.Lfound0:
+	sub	r3,r6,r3
+	bic	r3,r3,r6
+	and	r2,r3,r4
+	or_s	r12,r12,r2
+	sub_s	r3,r12,1
+	bic_s	r3,r3,r12
+	norm	r3,r3
+	add_s	r0,r0,3
+	asr_s	r12,r3,3
+	asl.f	0,r2,r3
+	sub_s	r0,r0,r12
+	j_s.d	[blink]
+	mov.pl	r0,0
+#else /* BIG ENDIAN */
+.Lfound_char:
+	lsr	r7,r7,7
+
+	bic	r2,r7,r6
+	norm	r2,r2
+	sub_s	r0,r0,4
+	asr_s	r2,r2,3
+	j.d	[blink]
+	add_s	r0,r0,r2
+
+.Lfound0_ua:
+	mov_s	r3,r7
+.Lfound0:
+	asl_s	r2,r2,7
+	or	r7,r6,r4
+	bic_s	r12,r12,r2
+	sub	r2,r7,r3
+	or	r2,r2,r6
+	bic	r12,r2,r12
+	bic.f	r3,r4,r12
+	norm	r3,r3
+
+	add.pl	r3,r3,1
+	asr_s	r12,r3,3
+	asl.f	0,r2,r3
+	add_s	r0,r0,r12
+	j_s.d	[blink]
+	mov.mi	r0,0
+#endif /* ENDIAN */
+ARC_EXIT strchr
diff --git a/arch/arc/lib/strcmp.S b/arch/arc/lib/strcmp.S
new file mode 100644
index 0000000..5dc802b
--- /dev/null
+++ b/arch/arc/lib/strcmp.S
@@ -0,0 +1,96 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* This is optimized primarily for the ARC700.
+   It would be possible to speed up the loops by one cycle / word
+   respective one cycle / byte by forcing double source 1 alignment, unrolling
+   by a factor of two, and speculatively loading the second word / byte of
+   source 1; however, that would increase the overhead for loop setup / finish,
+   and strcmp might often terminate early.  */
+
+#include <asm/linkage.h>
+
+ARC_ENTRY strcmp
+	or	r2,r0,r1
+	bmsk_s	r2,r2,1
+	brne	r2,0,.Lcharloop
+	mov_s	r12,0x01010101
+	ror	r5,r12
+.Lwordloop:
+	ld.ab	r2,[r0,4]
+	ld.ab	r3,[r1,4]
+	nop_s
+	sub	r4,r2,r12
+	bic	r4,r4,r2
+	and	r4,r4,r5
+	brne	r4,0,.Lfound0
+	breq	r2,r3,.Lwordloop
+#ifdef	__LITTLE_ENDIAN__
+	xor	r0,r2,r3	; mask for difference
+	sub_s	r1,r0,1
+	bic_s	r0,r0,r1	; mask for least significant difference bit
+	sub	r1,r5,r0
+	xor	r0,r5,r1	; mask for least significant difference byte
+	and_s	r2,r2,r0
+	and_s	r3,r3,r0
+#endif /* LITTLE ENDIAN */
+	cmp_s	r2,r3
+	mov_s	r0,1
+	j_s.d	[blink]
+	bset.lo	r0,r0,31
+
+	.balign	4
+#ifdef __LITTLE_ENDIAN__
+.Lfound0:
+	xor	r0,r2,r3	; mask for difference
+	or	r0,r0,r4	; or in zero indicator
+	sub_s	r1,r0,1
+	bic_s	r0,r0,r1	; mask for least significant difference bit
+	sub	r1,r5,r0
+	xor	r0,r5,r1	; mask for least significant difference byte
+	and_s	r2,r2,r0
+	and_s	r3,r3,r0
+	sub.f	r0,r2,r3
+	mov.hi	r0,1
+	j_s.d	[blink]
+	bset.lo	r0,r0,31
+#else /* BIG ENDIAN */
+	/* The zero-detection above can mis-detect 0x01 bytes as zeroes
+	   because of carry-propagateion from a lower significant zero byte.
+	   We can compensate for this by checking that bit0 is zero.
+	   This compensation is not necessary in the step where we
+	   get a low estimate for r2, because in any affected bytes
+	   we already have 0x00 or 0x01, which will remain unchanged
+	   when bit 7 is cleared.  */
+	.balign	4
+.Lfound0:
+	lsr	r0,r4,8
+	lsr_s	r1,r2
+	bic_s	r2,r2,r0	; get low estimate for r2 and get ...
+	bic_s	r0,r0,r1	; <this is the adjusted mask for zeros>
+	or_s	r3,r3,r0	; ... high estimate r3 so that r2 > r3 will ...
+	cmp_s	r3,r2		; ... be independent of trailing garbage
+	or_s	r2,r2,r0	; likewise for r3 > r2
+	bic_s	r3,r3,r0
+	rlc	r0,0		; r0 := r2 > r3 ? 1 : 0
+	cmp_s	r2,r3
+	j_s.d	[blink]
+	bset.lo	r0,r0,31
+#endif /* ENDIAN */
+
+	.balign	4
+.Lcharloop:
+	ldb.ab	r2,[r0,1]
+	ldb.ab	r3,[r1,1]
+	nop_s
+	breq	r2,0,.Lcmpend
+	breq	r2,r3,.Lcharloop
+.Lcmpend:
+	j_s.d	[blink]
+	sub	r0,r2,r3
+ARC_EXIT strcmp
diff --git a/arch/arc/lib/strcpy-700.S b/arch/arc/lib/strcpy-700.S
new file mode 100644
index 0000000..b7ca4ae
--- /dev/null
+++ b/arch/arc/lib/strcpy-700.S
@@ -0,0 +1,70 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/* If dst and src are 4 byte aligned, copy 8 bytes at a time.
+   If the src is 4, but not 8 byte aligned, we first read 4 bytes to get
+   it 8 byte aligned.  Thus, we can do a little read-ahead, without
+   dereferencing a cache line that we should not touch.
+   Note that short and long instructions have been scheduled to avoid
+   branch stalls.
+   The beq_s to r3z could be made unaligned & long to avoid a stall
+   there, but the it is not likely to be taken often, and it
+   would also be likey to cost an unaligned mispredict at the next call.  */
+
+#include <asm/linkage.h>
+
+ARC_ENTRY strcpy
+	or	r2,r0,r1
+	bmsk_s	r2,r2,1
+	brne.d	r2,0,charloop
+	mov_s	r10,r0
+	ld_s	r3,[r1,0]
+	mov	r8,0x01010101
+	bbit0.d	r1,2,loop_start
+	ror	r12,r8
+	sub	r2,r3,r8
+	bic_s	r2,r2,r3
+	tst_s	r2,r12
+	bne	r3z
+	mov_s	r4,r3
+	.balign 4
+loop:
+	ld.a	r3,[r1,4]
+	st.ab	r4,[r10,4]
+loop_start:
+	ld.a	r4,[r1,4]
+	sub	r2,r3,r8
+	bic_s	r2,r2,r3
+	tst_s	r2,r12
+	bne_s	r3z
+	st.ab	r3,[r10,4]
+	sub	r2,r4,r8
+	bic	r2,r2,r4
+	tst	r2,r12
+	beq	loop
+	mov_s	r3,r4
+#ifdef __LITTLE_ENDIAN__
+r3z:	bmsk.f	r1,r3,7
+	lsr_s	r3,r3,8
+#else
+r3z:	lsr.f	r1,r3,24
+	asl_s	r3,r3,8
+#endif
+	bne.d	r3z
+	stb.ab	r1,[r10,1]
+	j_s	[blink]
+
+	.balign	4
+charloop:
+	ldb.ab	r3,[r1,1]
+
+
+	brne.d	r3,0,charloop
+	stb.ab	r3,[r10,1]
+	j	[blink]
+ARC_EXIT strcpy
diff --git a/arch/arc/lib/strlen.S b/arch/arc/lib/strlen.S
new file mode 100644
index 0000000..39759e0
--- /dev/null
+++ b/arch/arc/lib/strlen.S
@@ -0,0 +1,83 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/linkage.h>
+
+ARC_ENTRY strlen
+	or	r3,r0,7
+	ld	r2,[r3,-7]
+	ld.a	r6,[r3,-3]
+	mov	r4,0x01010101
+	; uses long immediate
+#ifdef __LITTLE_ENDIAN__
+	asl_s	r1,r0,3
+	btst_s	r0,2
+	asl	r7,r4,r1
+	ror	r5,r4
+	sub	r1,r2,r7
+	bic_s	r1,r1,r2
+	mov.eq	r7,r4
+	sub	r12,r6,r7
+	bic	r12,r12,r6
+	or.eq	r12,r12,r1
+	and	r12,r12,r5
+	brne	r12,0,.Learly_end
+#else /* BIG ENDIAN */
+	ror	r5,r4
+	btst_s	r0,2
+	mov_s	r1,31
+	sub3	r7,r1,r0
+	sub	r1,r2,r4
+	bic_s	r1,r1,r2
+	bmsk	r1,r1,r7
+	sub	r12,r6,r4
+	bic	r12,r12,r6
+	bmsk.ne	r12,r12,r7
+	or.eq	r12,r12,r1
+	and	r12,r12,r5
+	brne	r12,0,.Learly_end
+#endif /* ENDIAN */
+
+.Loop:
+	ld_s	r2,[r3,4]
+	ld.a	r6,[r3,8]
+	; stall for load result
+	sub	r1,r2,r4
+	bic_s	r1,r1,r2
+	sub	r12,r6,r4
+	bic	r12,r12,r6
+	or	r12,r12,r1
+	and	r12,r12,r5
+	breq r12,0,.Loop
+.Lend:
+	and.f	r1,r1,r5
+	sub.ne	r3,r3,4
+	mov.eq	r1,r12
+#ifdef __LITTLE_ENDIAN__
+	sub_s	r2,r1,1
+	bic_s	r2,r2,r1
+	norm	r1,r2
+	sub_s	r0,r0,3
+	lsr_s	r1,r1,3
+	sub	    r0,r3,r0
+	j_s.d	[blink]
+	sub	    r0,r0,r1
+#else /* BIG ENDIAN */
+	lsr_s	r1,r1,7
+	mov.eq	r2,r6
+	bic_s	r1,r1,r2
+	norm	r1,r1
+	sub	    r0,r3,r0
+	lsr_s	r1,r1,3
+	j_s.d	[blink]
+	add	    r0,r0,r1
+#endif /* ENDIAN */
+.Learly_end:
+	b.d	.Lend
+	sub_s.ne r1,r1,r1
+ARC_EXIT strlen
-- 
1.7.4.1

