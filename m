Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3AJPjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 10:39:08 -0500
Received: from multi.imgtec.com ([194.200.65.239]:52711 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab3AJPcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:32:51 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v3 32/44] metag: Optimised library functions
Date: Thu, 10 Jan 2013 15:31:00 +0000
Message-ID: <1357831872-29451-33-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
References: <1357831872-29451-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_01_10_15_32_31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optimised library functions for metag.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/checksum.h |   92 ++++++++++
 arch/metag/include/asm/div64.h    |   12 ++
 arch/metag/include/asm/string.h   |   13 ++
 arch/metag/lib/ashldi3.S          |   33 ++++
 arch/metag/lib/ashrdi3.S          |   33 ++++
 arch/metag/lib/checksum.c         |  168 ++++++++++++++++++
 arch/metag/lib/clear_page.S       |   17 ++
 arch/metag/lib/cmpdi2.S           |   32 ++++
 arch/metag/lib/copy_page.S        |   20 ++
 arch/metag/lib/delay.c            |   55 ++++++
 arch/metag/lib/div64.S            |  108 ++++++++++++
 arch/metag/lib/divsi3.S           |  100 +++++++++++
 arch/metag/lib/ip_fast_csum.S     |   32 ++++
 arch/metag/lib/lshrdi3.S          |   33 ++++
 arch/metag/lib/memcpy.S           |  185 ++++++++++++++++++++
 arch/metag/lib/memmove.S          |  345 +++++++++++++++++++++++++++++++++++++
 arch/metag/lib/memset.S           |   86 +++++++++
 arch/metag/lib/modsi3.S           |   38 ++++
 arch/metag/lib/muldi3.S           |   44 +++++
 arch/metag/lib/ucmpdi2.S          |   27 +++
 20 files changed, 1473 insertions(+), 0 deletions(-)
 create mode 100644 arch/metag/include/asm/checksum.h
 create mode 100644 arch/metag/include/asm/div64.h
 create mode 100644 arch/metag/include/asm/string.h
 create mode 100644 arch/metag/lib/ashldi3.S
 create mode 100644 arch/metag/lib/ashrdi3.S
 create mode 100644 arch/metag/lib/checksum.c
 create mode 100644 arch/metag/lib/clear_page.S
 create mode 100644 arch/metag/lib/cmpdi2.S
 create mode 100644 arch/metag/lib/copy_page.S
 create mode 100644 arch/metag/lib/delay.c
 create mode 100644 arch/metag/lib/div64.S
 create mode 100644 arch/metag/lib/divsi3.S
 create mode 100644 arch/metag/lib/ip_fast_csum.S
 create mode 100644 arch/metag/lib/lshrdi3.S
 create mode 100644 arch/metag/lib/memcpy.S
 create mode 100644 arch/metag/lib/memmove.S
 create mode 100644 arch/metag/lib/memset.S
 create mode 100644 arch/metag/lib/modsi3.S
 create mode 100644 arch/metag/lib/muldi3.S
 create mode 100644 arch/metag/lib/ucmpdi2.S

diff --git a/arch/metag/include/asm/checksum.h b/arch/metag/include/asm/checksum.h
new file mode 100644
index 0000000..999bf76
--- /dev/null
+++ b/arch/metag/include/asm/checksum.h
@@ -0,0 +1,92 @@
+#ifndef _METAG_CHECKSUM_H
+#define _METAG_CHECKSUM_H
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
+extern __wsum csum_partial(const void *buff, int len, __wsum sum);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy(const void *src, void *dst, int len,
+				__wsum sum);
+
+/*
+ * the same as csum_partial_copy, but copies from user space.
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+extern __wsum csum_partial_copy_from_user(const void __user *src, void *dst,
+					int len, __wsum sum, int *csum_err);
+
+#define csum_partial_copy_nocheck(src, dst, len, sum)	\
+	csum_partial_copy((src), (dst), (len), (sum))
+
+/*
+ * Fold a partial checksum
+ */
+static inline __sum16 csum_fold(__wsum csum)
+{
+	u32 sum = (__force u32)csum;
+	sum = (sum & 0xffff) + (sum >> 16);
+	sum = (sum & 0xffff) + (sum >> 16);
+	return (__force __sum16)~sum;
+}
+
+/*
+ * This is a version of ip_compute_csum() optimized for IP headers,
+ * which always checksum on 4 octet boundaries.
+ */
+extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+static inline __wsum csum_tcpudp_nofold(__be32 saddr, __be32 daddr,
+					unsigned short len,
+					unsigned short proto,
+					__wsum sum)
+{
+	unsigned long len_proto = (proto + len) << 8;
+	asm ("ADD    %0, %0, %1\n"
+	     "ADDS   %0, %0, %2\n"
+	     "ADDCS  %0, %0, #1\n"
+	     "ADDS   %0, %0, %3\n"
+	     "ADDCS  %0, %0, #1\n"
+	     : "=d" (sum)
+	     : "d" (daddr), "d" (saddr), "d" (len_proto),
+	       "0" (sum)
+	     : "cc");
+	return sum;
+}
+
+static inline __sum16
+csum_tcpudp_magic(__be32 saddr, __be32 daddr, unsigned short len,
+		  unsigned short proto, __wsum sum)
+{
+	return csum_fold(csum_tcpudp_nofold(saddr, daddr, len, proto, sum));
+}
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+extern __sum16 ip_compute_csum(const void *buff, int len);
+
+#endif /* _METAG_CHECKSUM_H */
diff --git a/arch/metag/include/asm/div64.h b/arch/metag/include/asm/div64.h
new file mode 100644
index 0000000..0fdd116
--- /dev/null
+++ b/arch/metag/include/asm/div64.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_DIV64_H__
+#define __ASM_DIV64_H__
+
+#include <asm-generic/div64.h>
+
+extern u64 div_u64(u64 dividend, u64 divisor);
+extern s64 div_s64(s64 dividend, s64 divisor);
+
+#define div_u64 div_u64
+#define div_s64 div_s64
+
+#endif
diff --git a/arch/metag/include/asm/string.h b/arch/metag/include/asm/string.h
new file mode 100644
index 0000000..53e3806
--- /dev/null
+++ b/arch/metag/include/asm/string.h
@@ -0,0 +1,13 @@
+#ifndef _METAG_STRING_H_
+#define _METAG_STRING_H_
+
+#define __HAVE_ARCH_MEMSET
+extern void *memset(void *__s, int __c, size_t __count);
+
+#define __HAVE_ARCH_MEMCPY
+void *memcpy(void *__to, __const__ void *__from, size_t __n);
+
+#define __HAVE_ARCH_MEMMOVE
+extern void *memmove(void *__dest, __const__ void *__src, size_t __n);
+
+#endif /* _METAG_STRING_H_ */
diff --git a/arch/metag/lib/ashldi3.S b/arch/metag/lib/ashldi3.S
new file mode 100644
index 0000000..78d6974
--- /dev/null
+++ b/arch/metag/lib/ashldi3.S
@@ -0,0 +1,33 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit arithmetic shift left routine.
+!
+
+	.text
+	.global ___ashldi3
+	.type   ___ashldi3,function
+
+___ashldi3:
+	MOV     D0Re0,D0Ar2
+	MOV     D1Re0,D1Ar1
+	CMP     D1Ar3,#0                ! COUNT == 0
+	MOVEQ   PC,D1RtP                ! Yes, return
+
+	SUBS    D0Ar4,D1Ar3,#32         ! N = COUNT - 32
+	BGE     $L10
+
+!! Shift < 32
+	NEG     D0Ar4,D0Ar4             ! N = - N
+	LSL     D1Re0,D1Re0,D1Ar3       ! HI = HI << COUNT
+	LSR     D0Ar6,D0Re0,D0Ar4       ! TMP= LO >> -(COUNT - 32)
+	OR      D1Re0,D1Re0,D0Ar6       ! HI = HI | TMP
+	SWAP    D0Ar4,D1Ar3
+	LSL     D0Re0,D0Re0,D0Ar4       ! LO = LO << COUNT
+	MOV     PC,D1RtP
+
+$L10:
+!! Shift >= 32
+	LSL     D1Re0,D0Re0,D0Ar4       ! HI = LO << N
+	MOV     D0Re0,#0                ! LO = 0
+	MOV     PC,D1RtP
+	.size ___ashldi3,.-___ashldi3
diff --git a/arch/metag/lib/ashrdi3.S b/arch/metag/lib/ashrdi3.S
new file mode 100644
index 0000000..7cb7ed3
--- /dev/null
+++ b/arch/metag/lib/ashrdi3.S
@@ -0,0 +1,33 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit arithmetic shift right routine.
+!
+
+	.text
+	.global ___ashrdi3
+	.type   ___ashrdi3,function
+
+___ashrdi3:
+	MOV     D0Re0,D0Ar2
+	MOV     D1Re0,D1Ar1
+	CMP     D1Ar3,#0                ! COUNT == 0
+	MOVEQ   PC,D1RtP                ! Yes, return
+
+	MOV     D0Ar4,D1Ar3
+	SUBS    D1Ar3,D1Ar3,#32         ! N = COUNT - 32
+	BGE     $L20
+
+!! Shift < 32
+	NEG     D1Ar3,D1Ar3             ! N = - N
+	LSR     D0Re0,D0Re0,D0Ar4       ! LO = LO >> COUNT
+	LSL     D0Ar6,D1Re0,D1Ar3       ! TMP= HI << -(COUNT - 32)
+	OR      D0Re0,D0Re0,D0Ar6       ! LO = LO | TMP
+	SWAP    D1Ar3,D0Ar4
+	ASR     D1Re0,D1Re0,D1Ar3       ! HI = HI >> COUNT
+	MOV     PC,D1RtP
+$L20:
+!! Shift >= 32
+	ASR     D0Re0,D1Re0,D1Ar3       ! LO = HI >> N
+	ASR     D1Re0,D1Re0,#31         ! HI = HI >> 31
+	MOV     PC,D1RtP
+	.size ___ashrdi3,.-___ashrdi3
diff --git a/arch/metag/lib/checksum.c b/arch/metag/lib/checksum.c
new file mode 100644
index 0000000..44d2e19
--- /dev/null
+++ b/arch/metag/lib/checksum.c
@@ -0,0 +1,168 @@
+/*
+ *
+ * INET		An implementation of the TCP/IP protocol suite for the LINUX
+ *		operating system.  INET is implemented using the  BSD Socket
+ *		interface as the means of communication with the user level.
+ *
+ *		IP/TCP/UDP checksumming routines
+ *
+ * Authors:	Jorge Cwik, <jorge@laser.satlink.net>
+ *		Arnt Gulbrandsen, <agulbra@nvg.unit.no>
+ *		Tom May, <ftom@netcom.com>
+ *		Andreas Schwab, <schwab@issan.informatik.uni-dortmund.de>
+ *		Lots of code moved from tcp.c and ip.c; see those files
+ *		for more names.
+ *
+ * 03/02/96	Jes Sorensen, Andreas Schwab, Roman Hodek:
+ *		Fixed some nasty bugs, causing some horrible crashes.
+ *		A: At some points, the sum (%0) was used as
+ *		length-counter instead of the length counter
+ *		(%1). Thanks to Roman Hodek for pointing this out.
+ *		B: GCC seems to mess up if one uses too many
+ *		data-registers to hold input values and one tries to
+ *		specify d0 and d1 as scratch registers. Letting gcc
+ *		choose these registers itself solves the problem.
+ *
+ *		This program is free software; you can redistribute it and/or
+ *		modify it under the terms of the GNU General Public License
+ *		as published by the Free Software Foundation; either version
+ *		2 of the License, or (at your option) any later version.
+ */
+
+/* Revised by Kenneth Albanowski for m68knommu. Basic problem: unaligned access
+ kills, so most of the assembly has to go. */
+
+#include <linux/module.h>
+#include <net/checksum.h>
+
+#include <asm/byteorder.h>
+
+static inline unsigned short from32to16(unsigned int x)
+{
+	/* add up 16-bit and 16-bit for 16+c bit */
+	x = (x & 0xffff) + (x >> 16);
+	/* add up carry.. */
+	x = (x & 0xffff) + (x >> 16);
+	return x;
+}
+
+static unsigned int do_csum(const unsigned char *buff, int len)
+{
+	int odd;
+	unsigned int result = 0;
+
+	if (len <= 0)
+		goto out;
+	odd = 1 & (unsigned long) buff;
+	if (odd) {
+#ifdef __LITTLE_ENDIAN
+		result += (*buff << 8);
+#else
+		result = *buff;
+#endif
+		len--;
+		buff++;
+	}
+	if (len >= 2) {
+		if (2 & (unsigned long) buff) {
+			result += *(unsigned short *) buff;
+			len -= 2;
+			buff += 2;
+		}
+		if (len >= 4) {
+			const unsigned char *end = buff + ((unsigned)len & ~3);
+			unsigned int carry = 0;
+			do {
+				unsigned int w = *(unsigned int *) buff;
+				buff += 4;
+				result += carry;
+				result += w;
+				carry = (w > result);
+			} while (buff < end);
+			result += carry;
+			result = (result & 0xffff) + (result >> 16);
+		}
+		if (len & 2) {
+			result += *(unsigned short *) buff;
+			buff += 2;
+		}
+	}
+	if (len & 1)
+#ifdef __LITTLE_ENDIAN
+		result += *buff;
+#else
+		result += (*buff << 8);
+#endif
+	result = from32to16(result);
+	if (odd)
+		result = ((result >> 8) & 0xff) | ((result & 0xff) << 8);
+out:
+	return result;
+}
+EXPORT_SYMBOL(ip_fast_csum);
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
+__wsum csum_partial(const void *buff, int len, __wsum wsum)
+{
+	unsigned int sum = (__force unsigned int)wsum;
+	unsigned int result = do_csum(buff, len);
+
+	/* add in old sum, and carry.. */
+	result += sum;
+	if (sum > result)
+		result += 1;
+	return (__force __wsum)result;
+}
+EXPORT_SYMBOL(csum_partial);
+
+/*
+ * this routine is used for miscellaneous IP-like checksums, mainly
+ * in icmp.c
+ */
+__sum16 ip_compute_csum(const void *buff, int len)
+{
+	return (__force __sum16)~do_csum(buff, len);
+}
+EXPORT_SYMBOL(ip_compute_csum);
+
+/*
+ * copy from fs while checksumming, otherwise like csum_partial
+ */
+__wsum
+csum_partial_copy_from_user(const void __user *src, void *dst, int len,
+						__wsum sum, int *csum_err)
+{
+	int missing;
+
+	missing = __copy_from_user(dst, src, len);
+	if (missing) {
+		memset(dst + len - missing, 0, missing);
+		*csum_err = -EFAULT;
+	} else
+		*csum_err = 0;
+
+	return csum_partial(dst, len, sum);
+}
+EXPORT_SYMBOL(csum_partial_copy_from_user);
+
+/*
+ * copy from ds while checksumming, otherwise like csum_partial
+ */
+__wsum
+csum_partial_copy(const void *src, void *dst, int len, __wsum sum)
+{
+	memcpy(dst, src, len);
+	return csum_partial(dst, len, sum);
+}
+EXPORT_SYMBOL(csum_partial_copy);
diff --git a/arch/metag/lib/clear_page.S b/arch/metag/lib/clear_page.S
new file mode 100644
index 0000000..43144ee
--- /dev/null
+++ b/arch/metag/lib/clear_page.S
@@ -0,0 +1,17 @@
+        ! Copyright 2007,2008,2009 Imagination Technologies Ltd.
+
+#include <asm/page.h>
+
+        .text
+        .global	_clear_page
+        .type   _clear_page,function
+	!! D1Ar1 - page
+_clear_page:
+	MOV  TXRPT,#((PAGE_SIZE / 8) - 1)
+	MOV  D0Re0,#0
+	MOV  D1Re0,#0
+$Lclear_page_loop:
+	SETL [D1Ar1++],D0Re0,D1Re0
+	BR   $Lclear_page_loop
+	MOV  PC,D1RtP
+        .size	_clear_page,.-_clear_page
diff --git a/arch/metag/lib/cmpdi2.S b/arch/metag/lib/cmpdi2.S
new file mode 100644
index 0000000..9c5c663
--- /dev/null
+++ b/arch/metag/lib/cmpdi2.S
@@ -0,0 +1,32 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit signed compare routine.
+!
+
+	.text
+	.global ___cmpdi2
+	.type   ___cmpdi2,function
+
+!         low    high
+! s64 a  (D0Ar2, D1Ar1)
+! s64 b  (D0Ar4, D1Ar3)
+___cmpdi2:
+	! start at 1 (equal) and conditionally increment or decrement
+	MOV	D0Re0,#1
+
+	! high words differ?
+	CMP	D1Ar1,D1Ar3
+	BNE	$Lhigh_differ
+
+	! unsigned compare low words
+	CMP	D0Ar2,D0Ar4
+	SUBLO	D0Re0,D0Re0,#1
+	ADDHI	D0Re0,D0Re0,#1
+	MOV	PC,D1RtP
+
+$Lhigh_differ:
+	! signed compare high words
+	SUBLT	D0Re0,D0Re0,#1
+	ADDGT	D0Re0,D0Re0,#1
+	MOV	PC,D1RtP
+	.size ___cmpdi2,.-___cmpdi2
diff --git a/arch/metag/lib/copy_page.S b/arch/metag/lib/copy_page.S
new file mode 100644
index 0000000..91f7d46
--- /dev/null
+++ b/arch/metag/lib/copy_page.S
@@ -0,0 +1,20 @@
+        ! Copyright 2007,2008 Imagination Technologies Ltd.
+
+#include <asm/page.h>
+
+        .text
+        .global	_copy_page
+        .type   _copy_page,function
+	!! D1Ar1 - to
+	!! D0Ar2 - from
+_copy_page:
+	MOV  D0FrT,#PAGE_SIZE
+$Lcopy_page_loop:
+	GETL D0Re0,D1Re0,[D0Ar2++]
+	GETL D0Ar6,D1Ar5,[D0Ar2++]
+	SETL [D1Ar1++],D0Re0,D1Re0
+	SETL [D1Ar1++],D0Ar6,D1Ar5
+	SUBS D0FrT,D0FrT,#16
+	BNZ  $Lcopy_page_loop
+	MOV  PC,D1RtP
+        .size	_copy_page,.-_copy_page
diff --git a/arch/metag/lib/delay.c b/arch/metag/lib/delay.c
new file mode 100644
index 0000000..e1cfcbb
--- /dev/null
+++ b/arch/metag/lib/delay.c
@@ -0,0 +1,55 @@
+/*
+ *	Precise Delay Loops for Meta
+ *
+ *	Copyright (C) 1993 Linus Torvalds
+ *	Copyright (C) 1997 Martin Mares <mj@atrey.karlin.mff.cuni.cz>
+ *	Copyright (C) 2007,2009 Imagination Technologies Ltd.
+ *
+ */
+
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+
+#include <asm/processor.h>
+
+/*
+ * TXTACTCYC is only 24 bits, so on chips with fast clocks it will wrap
+ * many times per-second. If it does wrap __delay will return prematurely,
+ * but this is only likely with large delay values.
+ *
+ * We also can't implement read_current_timer() with TXTACTCYC due to
+ * this wrapping behaviour.
+ */
+#define rdtimer(t) asm volatile ("MOV %0,TXACTCYC\n" : "=r" (t));
+
+void __delay(unsigned long loops)
+{
+	unsigned long bclock, now;
+
+	rdtimer(bclock);
+	do {
+		asm("NOP");
+		rdtimer(now);
+	} while ((now-bclock) < loops);
+}
+EXPORT_SYMBOL(__delay);
+
+inline void __const_udelay(unsigned long xloops)
+{
+	u64 loops = (u64)xloops * (u64)loops_per_jiffy * HZ;
+	__delay(loops >> 32);
+}
+EXPORT_SYMBOL(__const_udelay);
+
+void __udelay(unsigned long usecs)
+{
+	__const_udelay(usecs * 0x000010c7); /* 2**32 / 1000000 (rounded up) */
+}
+EXPORT_SYMBOL(__udelay);
+
+void __ndelay(unsigned long nsecs)
+{
+	__const_udelay(nsecs * 0x00005); /* 2**32 / 1000000000 (rounded up) */
+}
+EXPORT_SYMBOL(__ndelay);
diff --git a/arch/metag/lib/div64.S b/arch/metag/lib/div64.S
new file mode 100644
index 0000000..1cfc934
--- /dev/null
+++ b/arch/metag/lib/div64.S
@@ -0,0 +1,108 @@
+! Copyright (C) 2012 Imagination Technologies Ltd.
+!
+! Signed/unsigned 64-bit division routines.
+!
+
+	.text
+	.global _div_u64
+	.type   _div_u64,function
+
+_div_u64:
+$L1:
+	ORS     A0.3,D1Ar3,D0Ar4
+	BNE     $L3
+$L2:
+	MOV     D0Re0,D0Ar2
+	MOV     D1Re0,D1Ar1
+	MOV     PC,D1RtP
+$L3:
+	CMP     D1Ar3,D1Ar1
+	CMPEQ   D0Ar4,D0Ar2
+	MOV     D0Re0,#1
+	MOV     D1Re0,#0
+	BHS     $L6
+$L4:
+	ADDS    D0Ar6,D0Ar4,D0Ar4
+	ADD     D1Ar5,D1Ar3,D1Ar3
+	ADDCS   D1Ar5,D1Ar5,#1
+	CMP     D1Ar5,D1Ar3
+	CMPEQ   D0Ar6,D0Ar4
+	BLO     $L6
+$L5:
+	MOV     D0Ar4,D0Ar6
+	MOV     D1Ar3,D1Ar5
+	ADDS    D0Re0,D0Re0,D0Re0
+	ADD     D1Re0,D1Re0,D1Re0
+	ADDCS   D1Re0,D1Re0,#1
+	CMP     D1Ar3,D1Ar1
+	CMPEQ   D0Ar4,D0Ar2
+	BLO     $L4
+$L6:
+	ORS     A0.3,D1Re0,D0Re0
+	MOV     D0Ar6,#0
+	MOV     D1Ar5,D0Ar6
+	BEQ     $L10
+$L7:
+	CMP     D1Ar1,D1Ar3
+	CMPEQ   D0Ar2,D0Ar4
+	BLO     $L9
+$L8:
+	ADDS    D0Ar6,D0Ar6,D0Re0
+	ADD     D1Ar5,D1Ar5,D1Re0
+	ADDCS   D1Ar5,D1Ar5,#1
+
+	SUBS    D0Ar2,D0Ar2,D0Ar4
+	SUB     D1Ar1,D1Ar1,D1Ar3
+	SUBCS   D1Ar1,D1Ar1,#1
+$L9:
+	LSL     A0.3,D1Re0,#31
+	LSR     D0Re0,D0Re0,#1
+	LSR     D1Re0,D1Re0,#1
+	OR      D0Re0,D0Re0,A0.3
+	LSL     A0.3,D1Ar3,#31
+	LSR     D0Ar4,D0Ar4,#1
+	LSR     D1Ar3,D1Ar3,#1
+	OR      D0Ar4,D0Ar4,A0.3
+	ORS     A0.3,D1Re0,D0Re0
+	BNE     $L7
+$L10:
+	MOV     D0Re0,D0Ar6
+	MOV     D1Re0,D1Ar5
+	MOV     PC,D1RtP
+	.size _div_u64,.-_div_u64
+
+	.text
+	.global _div_s64
+	.type   _div_s64,function
+_div_s64:
+	MSETL   [A0StP],D0FrT,D0.5
+	XOR     D0.5,D0Ar2,D0Ar4
+	XOR     D1.5,D1Ar1,D1Ar3
+	TSTT    D1Ar1,#HI(0x80000000)
+	BZ      $L25
+
+	NEGS    D0Ar2,D0Ar2
+	NEG     D1Ar1,D1Ar1
+	SUBCS   D1Ar1,D1Ar1,#1
+$L25:
+	TSTT    D1Ar3,#HI(0x80000000)
+	BZ      $L27
+
+	NEGS    D0Ar4,D0Ar4
+	NEG     D1Ar3,D1Ar3
+	SUBCS   D1Ar3,D1Ar3,#1
+$L27:
+	CALLR   D1RtP,_div_u64
+	TSTT    D1.5,#HI(0x80000000)
+	BZ      $L29
+
+	NEGS    D0Re0,D0Re0
+	NEG     D1Re0,D1Re0
+	SUBCS   D1Re0,D1Re0,#1
+$L29:
+
+	GETL    D0FrT,D1RtP,[A0StP+#(-16)]
+	GETL    D0.5,D1.5,[A0StP+#(-8)]
+	SUB     A0StP,A0StP,#16
+	MOV     PC,D1RtP
+	.size _div_s64,.-_div_s64
diff --git a/arch/metag/lib/divsi3.S b/arch/metag/lib/divsi3.S
new file mode 100644
index 0000000..7c8a8ae
--- /dev/null
+++ b/arch/metag/lib/divsi3.S
@@ -0,0 +1,100 @@
+! Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006, 2007
+!               Imagination Technologies Ltd
+!
+! Integer divide routines.
+!
+
+	.text
+	.global ___udivsi3
+	.type   ___udivsi3,function
+	.align  2
+___udivsi3:
+!!
+!! Since core is signed divide case, just set control variable
+!!
+	MOV     D1Re0,D0Ar2             ! Au already in A1Ar1, Bu -> D1Re0
+	MOV     D0Re0,#0                ! Result is 0
+	MOV     D0Ar4,#0                ! Return positive result
+	B       $LIDMCUStart
+	.size   ___udivsi3,.-___udivsi3
+
+!!
+!! 32-bit division signed i/p - passed signed 32-bit numbers
+!!
+	.global ___divsi3
+	.type   ___divsi3,function
+	.align  2
+___divsi3:
+!!
+!! A already in D1Ar1, B already in D0Ar2 -> make B abs(B)
+!!
+	MOV     D1Re0,D0Ar2             ! A already in A1Ar1, B -> D1Re0
+	MOV     D0Re0,#0                ! Result is 0
+	XOR     D0Ar4,D1Ar1,D1Re0       ! D0Ar4 -ive if result is -ive
+	ABS     D1Ar1,D1Ar1             ! abs(A) -> Au
+	ABS     D1Re0,D1Re0             ! abs(B) -> Bu
+$LIDMCUStart:
+	CMP     D1Ar1,D1Re0             ! Is ( Au > Bu )?
+	LSR     D1Ar3,D1Ar1,#2          ! Calculate (Au & (~3)) >> 2
+	CMPHI   D1Re0,D1Ar3             ! OR ( (Au & (~3)) <= (Bu << 2) )?
+	LSLSHI  D1Ar3,D1Re0,#1          ! Buq = Bu << 1
+	BLS     $LIDMCUSetup            ! Yes: Do normal divide
+!!
+!! Quick divide setup can assume that CurBit only needs to start at 2
+!!
+$LIDMCQuick:
+	CMP     D1Ar1,D1Ar3             ! ( A >= Buq )?
+	ADDCC   D0Re0,D0Re0,#2          ! If yes result += 2
+	SUBCC   D1Ar1,D1Ar1,D1Ar3       !        and A -= Buq
+	CMP     D1Ar1,D1Re0             ! ( A >= Bu )?
+	ADDCC   D0Re0,D0Re0,#1          ! If yes result += 1
+	SUBCC   D1Ar1,D1Ar1,D1Re0       !        and A -= Bu
+	ORS     D0Ar4,D0Ar4,D0Ar4       ! Return neg result?
+	NEG     D0Ar2,D0Re0             ! Calulate neg result
+	MOVMI   D0Re0,D0Ar2             ! Yes: Take neg result
+$LIDMCRet:
+	MOV     PC,D1RtP
+!!
+!!  Setup for general unsigned divide code
+!!
+!!      D0Re0 is used to form the result, already set to Zero
+!!      D1Re0 is the input Bu value, this gets trashed
+!!      D0Ar6 is curbit which is set to 1 at the start and shifted up
+!!      D0Ar4 is negative if we should return a negative result
+!!      D1Ar1 is the input Au value, eventually this holds the remainder
+!!
+$LIDMCUSetup:
+	CMP     D1Ar1,D1Re0             ! Is ( Au < Bu )?
+	MOV     D0Ar6,#1                ! Set curbit to 1
+	BCS     $LIDMCRet               ! Yes: Return 0 remainder Au
+!!
+!! Calculate alignment using FFB instruction
+!!
+	FFB     D1Ar5,D1Ar1             ! Find first bit of Au
+	ANDN    D1Ar5,D1Ar5,#31         ! Handle exceptional case.
+	ORN     D1Ar5,D1Ar5,#31         ! if N bit set, set to 31
+	FFB     D1Ar3,D1Re0             ! Find first bit of Bu
+	ANDN    D1Ar3,D1Ar3,#31         ! Handle exceptional case.
+	ORN     D1Ar3,D1Ar3,#31         ! if N bit set, set to 31
+	SUBS    D1Ar3,D1Ar5,D1Ar3       ! calculate diff, ffbA - ffbB
+	MOV     D0Ar2,D1Ar3             ! copy into bank 0
+	LSLGT   D1Re0,D1Re0,D1Ar3       ! ( > 0) ? left shift B
+	LSLGT   D0Ar6,D0Ar6,D0Ar2       ! ( > 0) ? left shift curbit
+!!
+!! Now we start the divide proper, logic is
+!!
+!!       if ( A >= B ) add curbit to result and subtract B from A
+!!       shift curbit and B down by 1 in either case
+!!
+$LIDMCLoop:
+	CMP     D1Ar1, D1Re0            ! ( A >= B )?
+	ADDCC   D0Re0, D0Re0, D0Ar6     ! If yes result += curbit
+	SUBCC   D1Ar1, D1Ar1, D1Re0     ! and A -= B
+	LSRS    D0Ar6, D0Ar6, #1        ! Shift down curbit, is it zero?
+	LSR     D1Re0, D1Re0, #1        ! Shift down B
+	BNZ     $LIDMCLoop               ! Was single bit in curbit lost?
+	ORS     D0Ar4,D0Ar4,D0Ar4       ! Return neg result?
+	NEG     D0Ar2,D0Re0             ! Calulate neg result
+	MOVMI   D0Re0,D0Ar2             ! Yes: Take neg result
+	MOV     PC,D1RtP
+	.size   ___divsi3,.-___divsi3
diff --git a/arch/metag/lib/ip_fast_csum.S b/arch/metag/lib/ip_fast_csum.S
new file mode 100644
index 0000000..533b1e7
--- /dev/null
+++ b/arch/metag/lib/ip_fast_csum.S
@@ -0,0 +1,32 @@
+
+	.text
+/*
+ * This is a version of ip_compute_csum() optimized for IP headers,
+ * which always checksum on 4 octet boundaries.
+ *
+ * extern __sum16 ip_fast_csum(const void *iph, unsigned int ihl);
+ *
+ */
+	.global _ip_fast_csum
+	.type   _ip_fast_csum,function
+_ip_fast_csum:
+	!! TXRPT needs loops - 1
+	SUBS	TXRPT,D0Ar2,#1
+	MOV	D0Re0,#0
+	BLO	$Lfast_csum_exit
+$Lfast_csum_loop:
+	GETD	D1Ar3,[D1Ar1++]
+	ADDS	D0Re0,D0Re0,D1Ar3
+	ADDCS   D0Re0,D0Re0,#1
+	BR	$Lfast_csum_loop
+	LSR	D0Ar4,D0Re0,#16
+	AND	D0Re0,D0Re0,#0xffff
+	AND	D0Ar4,D0Ar4,#0xffff
+	ADD	D0Re0,D0Re0,D0Ar4
+	LSR	D0Ar4,D0Re0,#16
+	ADD	D0Re0,D0Re0,D0Ar4
+	XOR	D0Re0,D0Re0,#-1
+	AND	D0Re0,D0Re0,#0xffff
+$Lfast_csum_exit:
+	MOV	PC,D1RtP
+	.size _ip_fast_csum,.-_ip_fast_csum
diff --git a/arch/metag/lib/lshrdi3.S b/arch/metag/lib/lshrdi3.S
new file mode 100644
index 0000000..47f7202
--- /dev/null
+++ b/arch/metag/lib/lshrdi3.S
@@ -0,0 +1,33 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit logical shift right routine.
+!
+
+	.text
+	.global ___lshrdi3
+	.type   ___lshrdi3,function
+
+___lshrdi3:
+	MOV     D0Re0,D0Ar2
+	MOV     D1Re0,D1Ar1
+	CMP     D1Ar3,#0                ! COUNT == 0
+	MOVEQ   PC,D1RtP                ! Yes, return
+
+	MOV     D0Ar4,D1Ar3
+	SUBS    D1Ar3,D1Ar3,#32         ! N = COUNT - 32
+	BGE     $L30
+
+!! Shift < 32
+	NEG     D1Ar3,D1Ar3             ! N = - N
+	LSR     D0Re0,D0Re0,D0Ar4       ! LO = LO >> COUNT
+	LSL     D0Ar6,D1Re0,D1Ar3       ! TMP= HI << -(COUNT - 32)
+	OR      D0Re0,D0Re0,D0Ar6       ! LO = LO | TMP
+	SWAP    D1Ar3,D0Ar4
+	LSR     D1Re0,D1Re0,D1Ar3       ! HI = HI >> COUNT
+	MOV     PC,D1RtP
+$L30:
+!! Shift >= 32
+	LSR     D0Re0,D1Re0,D1Ar3       ! LO = HI >> N
+	MOV     D1Re0,#0                ! HI = 0
+	MOV     PC,D1RtP
+	.size ___lshrdi3,.-___lshrdi3
diff --git a/arch/metag/lib/memcpy.S b/arch/metag/lib/memcpy.S
new file mode 100644
index 0000000..46b7a2b
--- /dev/null
+++ b/arch/metag/lib/memcpy.S
@@ -0,0 +1,185 @@
+!   Copyright (C) 2008-2012 Imagination Technologies Ltd.
+
+	.text
+	.global	_memcpy
+	.type	_memcpy,function
+! D1Ar1 dst
+! D0Ar2 src
+! D1Ar3 cnt
+! D0Re0 dst
+_memcpy:
+	CMP 	D1Ar3, #16
+	MOV 	A1.2, D0Ar2		! source pointer
+	MOV 	A0.2, D1Ar1		! destination pointer
+	MOV 	A0.3, D1Ar1		! for return value
+! If there are less than 16 bytes to copy use the byte copy loop
+	BGE 	$Llong_copy
+
+$Lbyte_copy:
+! Simply copy a byte at a time
+	SUBS	TXRPT, D1Ar3, #1
+	BLT	$Lend
+$Lloop_byte:
+	GETB 	D1Re0, [A1.2++]
+	SETB 	[A0.2++], D1Re0
+	BR	$Lloop_byte
+
+$Lend:
+! Finally set return value and return
+	MOV 	D0Re0, A0.3
+	MOV 	PC, D1RtP
+
+$Llong_copy:
+	ANDS 	D1Ar5, D1Ar1, #7	! test destination alignment
+	BZ	$Laligned_dst
+
+! The destination address is not 8 byte aligned. We will copy bytes from
+! the source to the destination until the remaining data has an 8 byte
+! destination address alignment (i.e we should never copy more than 7
+! bytes here).
+$Lalign_dst:
+	GETB 	D0Re0, [A1.2++]
+	ADD 	D1Ar5, D1Ar5, #1	! dest is aligned when D1Ar5 reaches #8
+	SUB 	D1Ar3, D1Ar3, #1	! decrement count of remaining bytes
+	SETB 	[A0.2++], D0Re0
+	CMP 	D1Ar5, #8
+	BNE 	$Lalign_dst
+
+! We have at least (16 - 7) = 9 bytes to copy - calculate the number of 8 byte
+! blocks, then jump to the unaligned copy loop or fall through to the aligned
+! copy loop as appropriate.
+$Laligned_dst:
+	MOV	D0Ar4, A1.2
+	LSR 	D1Ar5, D1Ar3, #3	! D1Ar5 = number of 8 byte blocks
+	ANDS 	D0Ar4, D0Ar4, #7	! test source alignment
+	BNZ 	$Lunaligned_copy	! if unaligned, use unaligned copy loop
+
+! Both source and destination are 8 byte aligned - the easy case.
+$Laligned_copy:
+	LSRS	D1Ar5, D1Ar3, #5	! D1Ar5 = number of 32 byte blocks
+	BZ	$Lbyte_copy
+	SUB	TXRPT, D1Ar5, #1
+
+$Laligned_32:
+	GETL 	D0Re0, D1Re0, [A1.2++]
+	GETL 	D0Ar6, D1Ar5, [A1.2++]
+	SETL 	[A0.2++], D0Re0, D1Re0
+	SETL 	[A0.2++], D0Ar6, D1Ar5
+	GETL 	D0Re0, D1Re0, [A1.2++]
+	GETL 	D0Ar6, D1Ar5, [A1.2++]
+	SETL 	[A0.2++], D0Re0, D1Re0
+	SETL 	[A0.2++], D0Ar6, D1Ar5
+	BR	$Laligned_32
+
+! If there are any remaining bytes use the byte copy loop, otherwise we are done
+	ANDS 	D1Ar3, D1Ar3, #0x1f
+	BNZ	$Lbyte_copy
+	B	$Lend
+
+! The destination is 8 byte aligned but the source is not, and there are 8
+! or more bytes to be copied.
+$Lunaligned_copy:
+! Adjust the source pointer (A1.2) to the 8 byte boundary before its
+! current value
+	MOV 	D0Ar4, A1.2
+	MOV 	D0Ar6, A1.2
+	ANDMB 	D0Ar4, D0Ar4, #0xfff8
+	MOV 	A1.2, D0Ar4
+! Save the number of bytes of mis-alignment in D0Ar4 for use later
+	SUBS 	D0Ar6, D0Ar6, D0Ar4
+	MOV	D0Ar4, D0Ar6
+! if there is no mis-alignment after all, use the aligned copy loop
+	BZ 	$Laligned_copy
+
+! prefetch 8 bytes
+	GETL 	D0Re0, D1Re0, [A1.2]
+
+	SUB	TXRPT, D1Ar5, #1
+
+! There are 3 mis-alignment cases to be considered. Less than 4 bytes, exactly
+! 4 bytes, and more than 4 bytes.
+	CMP 	D0Ar6, #4
+	BLT 	$Lunaligned_1_2_3	! use 1-3 byte mis-alignment loop
+	BZ 	$Lunaligned_4		! use 4 byte mis-alignment loop
+
+! The mis-alignment is more than 4 bytes
+$Lunaligned_5_6_7:
+	SUB 	D0Ar6, D0Ar6, #4
+! Calculate the bit offsets required for the shift operations necesssary
+! to align the data.
+! D0Ar6 = bit offset, D1Ar5 = (32 - bit offset)
+	MULW 	D0Ar6, D0Ar6, #8
+	MOV	D1Ar5, #32
+	SUB	D1Ar5, D1Ar5, D0Ar6
+! Move data 4 bytes before we enter the main loop
+	MOV 	D0Re0, D1Re0
+
+$Lloop_5_6_7:
+	GETL 	D0Ar2, D1Ar1, [++A1.2]
+! form 64-bit data in D0Re0, D1Re0
+	LSR 	D0Re0, D0Re0, D0Ar6
+	MOV 	D1Re0, D0Ar2
+	LSL 	D1Re0, D1Re0, D1Ar5
+	ADD 	D0Re0, D0Re0, D1Re0
+
+	LSR 	D0Ar2, D0Ar2, D0Ar6
+	LSL 	D1Re0, D1Ar1, D1Ar5
+	ADD 	D1Re0, D1Re0, D0Ar2
+
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D1Ar1
+	BR	$Lloop_5_6_7
+
+	B 	$Lunaligned_end
+
+$Lunaligned_1_2_3:
+! Calculate the bit offsets required for the shift operations necesssary
+! to align the data.
+! D0Ar6 = bit offset, D1Ar5 = (32 - bit offset)
+	MULW 	D0Ar6, D0Ar6, #8
+	MOV	D1Ar5, #32
+	SUB	D1Ar5, D1Ar5, D0Ar6
+
+$Lloop_1_2_3:
+! form 64-bit data in D0Re0,D1Re0
+	LSR 	D0Re0, D0Re0, D0Ar6
+	LSL 	D1Ar1, D1Re0, D1Ar5
+	ADD 	D0Re0, D0Re0, D1Ar1
+	MOV	D0Ar2, D1Re0
+	LSR 	D0FrT, D0Ar2, D0Ar6
+	GETL 	D0Ar2, D1Ar1, [++A1.2]
+
+	MOV 	D1Re0, D0Ar2
+	LSL 	D1Re0, D1Re0, D1Ar5
+	ADD 	D1Re0, D1Re0, D0FrT
+
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D0Ar2
+	MOV 	D1Re0, D1Ar1
+	BR	$Lloop_1_2_3
+
+	B 	$Lunaligned_end
+
+! The 4 byte mis-alignment case - this does not require any shifting, just a
+! shuffling of registers.
+$Lunaligned_4:
+	MOV 	D0Re0, D1Re0
+$Lloop_4:
+	GETL 	D0Ar2, D1Ar1, [++A1.2]
+	MOV 	D1Re0, D0Ar2
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D1Ar1
+	BR	$Lloop_4
+
+$Lunaligned_end:
+! If there are no remaining bytes to copy, we are done.
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ	$Lend
+! Re-adjust the source pointer (A1.2) back to the actual (unaligned) byte
+! address of the remaining bytes, and fall through to the byte copy loop.
+	MOV 	D0Ar6, A1.2
+	ADD 	D1Ar5, D0Ar4, D0Ar6
+	MOV 	A1.2, D1Ar5
+	B	$Lbyte_copy
+
+	.size _memcpy,.-_memcpy
diff --git a/arch/metag/lib/memmove.S b/arch/metag/lib/memmove.S
new file mode 100644
index 0000000..228ea04
--- /dev/null
+++ b/arch/metag/lib/memmove.S
@@ -0,0 +1,345 @@
+!   Copyright (C) 2008-2012 Imagination Technologies Ltd.
+
+	.text
+	.global	_memmove
+	.type	_memmove,function
+! D1Ar1 dst
+! D0Ar2 src
+! D1Ar3 cnt
+! D0Re0 dst
+_memmove:
+	CMP 	D1Ar3, #0
+	MOV 	D0Re0, D1Ar1
+	BZ 	$LEND2
+	MSETL 	[A0StP], D0.5, D0.6, D0.7
+	MOV 	D1Ar5, D0Ar2
+	CMP 	D1Ar1, D1Ar5
+	BLT 	$Lforwards_copy
+	SUB 	D0Ar4, D1Ar1, D1Ar3
+	ADD 	D0Ar4, D0Ar4, #1
+	CMP 	D0Ar2, D0Ar4
+	BLT 	$Lforwards_copy
+	! should copy backwards
+	MOV 	D1Re0, D0Ar2
+	! adjust pointer to the end of mem
+	ADD 	D0Ar2, D1Re0, D1Ar3
+	ADD 	D1Ar1, D1Ar1, D1Ar3
+
+	MOV 	A1.2, D0Ar2
+	MOV 	A0.2, D1Ar1
+	CMP 	D1Ar3, #8
+	BLT 	$Lbbyte_loop
+
+	MOV 	D0Ar4, D0Ar2
+	MOV 	D1Ar5, D1Ar1
+
+	! test 8 byte alignment
+	ANDS 	D1Ar5, D1Ar5, #7
+	BNE 	$Lbdest_unaligned
+
+	ANDS 	D0Ar4, D0Ar4, #7
+	BNE 	$Lbsrc_unaligned
+
+	LSR 	D1Ar5, D1Ar3, #3
+
+$Lbaligned_loop:
+	GETL 	D0Re0, D1Re0, [--A1.2]
+	SETL 	[--A0.2], D0Re0, D1Re0
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lbaligned_loop
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lbbyte_loop_exit
+$Lbbyte_loop:
+	GETB 	D1Re0, [--A1.2]
+	SETB 	[--A0.2], D1Re0
+	SUBS 	D1Ar3, D1Ar3, #1
+	BNE 	$Lbbyte_loop
+$Lbbyte_loop_exit:
+	MOV 	D0Re0, A0.2
+$LEND:
+	SUB 	A0.2, A0StP, #24
+	MGETL 	D0.5, D0.6, D0.7, [A0.2]
+	SUB 	A0StP, A0StP, #24
+$LEND2:
+	MOV 	PC, D1RtP
+
+$Lbdest_unaligned:
+	GETB 	D0Re0, [--A1.2]
+	SETB 	[--A0.2], D0Re0
+	SUBS 	D1Ar5, D1Ar5, #1
+	SUB 	D1Ar3, D1Ar3, #1
+	BNE 	$Lbdest_unaligned
+	CMP 	D1Ar3, #8
+	BLT 	$Lbbyte_loop
+$Lbsrc_unaligned:
+	LSR 	D1Ar5, D1Ar3, #3
+	! adjust A1.2
+	MOV 	D0Ar4, A1.2
+	! save original address
+	MOV 	D0Ar6, A1.2
+
+	ADD 	D0Ar4, D0Ar4, #7
+	ANDMB 	D0Ar4, D0Ar4, #0xfff8
+	! new address is the 8-byte aligned one above the original
+	MOV 	A1.2, D0Ar4
+
+	! A0.2 dst 64-bit is aligned
+	! measure the gap size
+	SUB 	D0Ar6, D0Ar4, D0Ar6
+	MOVS 	D0Ar4, D0Ar6
+	! keep this information for the later adjustment
+	! both aligned
+	BZ 	$Lbaligned_loop
+
+	! prefetch
+	GETL 	D0Re0, D1Re0, [--A1.2]
+
+	CMP 	D0Ar6, #4
+	BLT 	$Lbunaligned_1_2_3
+	! 32-bit aligned
+	BZ 	$Lbaligned_4
+
+	SUB 	D0Ar6, D0Ar6, #4
+	! D1.6 stores the gap size in bits
+	MULW 	D1.6, D0Ar6, #8
+	MOV 	D0.6, #32
+	! D0.6 stores the complement of the gap size
+	SUB 	D0.6, D0.6, D1.6
+
+$Lbunaligned_5_6_7:
+	GETL 	D0.7, D1.7, [--A1.2]
+	! form 64-bit data in D0Re0, D1Re0
+	MOV 	D1Re0, D0Re0
+	! D1Re0 << gap-size
+	LSL 	D1Re0, D1Re0, D1.6
+	MOV 	D0Re0, D1.7
+	! D0Re0 >> complement
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D1.5, D0Re0
+	! combine the both
+	ADD 	D1Re0, D1Re0, D1.5
+
+	MOV 	D1.5, D1.7
+	LSL 	D1.5, D1.5, D1.6
+	MOV 	D0Re0, D0.7
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D0.5, D1.5
+	ADD 	D0Re0, D0Re0, D0.5
+
+	SETL 	[--A0.2], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lbunaligned_5_6_7
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lbbyte_loop_exit
+	! Adjust A1.2
+	! A1.2 <- A1.2 +8 - gapsize
+	ADD 	A1.2, A1.2, #8
+	SUB 	A1.2, A1.2, D0Ar4
+	B 	$Lbbyte_loop
+
+$Lbunaligned_1_2_3:
+	MULW 	D1.6, D0Ar6, #8
+	MOV 	D0.6, #32
+	SUB 	D0.6, D0.6, D1.6
+
+$Lbunaligned_1_2_3_loop:
+	GETL 	D0.7, D1.7, [--A1.2]
+	! form 64-bit data in D0Re0, D1Re0
+	LSL 	D1Re0, D1Re0, D1.6
+	! save D0Re0 for later use
+	MOV 	D0.5, D0Re0
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D1.5, D0Re0
+	ADD 	D1Re0, D1Re0, D1.5
+
+	! orignal data in D0Re0
+	MOV 	D1.5, D0.5
+	LSL 	D1.5, D1.5, D1.6
+	MOV 	D0Re0, D1.7
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D0.5, D1.5
+	ADD 	D0Re0, D0Re0, D0.5
+
+	SETL 	[--A0.2], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lbunaligned_1_2_3_loop
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lbbyte_loop_exit
+	! Adjust A1.2
+	ADD 	A1.2, A1.2, #8
+	SUB 	A1.2, A1.2, D0Ar4
+	B 	$Lbbyte_loop
+
+$Lbaligned_4:
+	GETL 	D0.7, D1.7, [--A1.2]
+	MOV 	D1Re0, D0Re0
+	MOV 	D0Re0, D1.7
+	SETL 	[--A0.2], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lbaligned_4
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lbbyte_loop_exit
+	! Adjust A1.2
+	ADD 	A1.2, A1.2, #8
+	SUB 	A1.2, A1.2, D0Ar4
+	B 	$Lbbyte_loop
+
+$Lforwards_copy:
+	MOV 	A1.2, D0Ar2
+	MOV 	A0.2, D1Ar1
+	CMP 	D1Ar3, #8
+	BLT 	$Lfbyte_loop
+
+	MOV 	D0Ar4, D0Ar2
+	MOV 	D1Ar5, D1Ar1
+
+	ANDS 	D1Ar5, D1Ar5, #7
+	BNE 	$Lfdest_unaligned
+
+	ANDS 	D0Ar4, D0Ar4, #7
+	BNE 	$Lfsrc_unaligned
+
+	LSR 	D1Ar5, D1Ar3, #3
+
+$Lfaligned_loop:
+	GETL 	D0Re0, D1Re0, [A1.2++]
+	SUBS 	D1Ar5, D1Ar5, #1
+	SETL 	[A0.2++], D0Re0, D1Re0
+	BNE 	$Lfaligned_loop
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lfbyte_loop_exit
+$Lfbyte_loop:
+	GETB 	D1Re0, [A1.2++]
+	SETB 	[A0.2++], D1Re0
+	SUBS 	D1Ar3, D1Ar3, #1
+	BNE 	$Lfbyte_loop
+$Lfbyte_loop_exit:
+	MOV 	D0Re0, D1Ar1
+	B 	$LEND
+
+$Lfdest_unaligned:
+	GETB 	D0Re0, [A1.2++]
+	ADD 	D1Ar5, D1Ar5, #1
+	SUB 	D1Ar3, D1Ar3, #1
+	SETB 	[A0.2++], D0Re0
+	CMP 	D1Ar5, #8
+	BNE 	$Lfdest_unaligned
+	CMP 	D1Ar3, #8
+	BLT 	$Lfbyte_loop
+$Lfsrc_unaligned:
+	! adjust A1.2
+	LSR 	D1Ar5, D1Ar3, #3
+
+	MOV 	D0Ar4, A1.2
+	MOV 	D0Ar6, A1.2
+	ANDMB 	D0Ar4, D0Ar4, #0xfff8
+	MOV 	A1.2, D0Ar4
+
+	! A0.2 dst 64-bit is aligned
+	SUB 	D0Ar6, D0Ar6, D0Ar4
+	! keep the information for the later adjustment
+	MOVS 	D0Ar4, D0Ar6
+
+	! both aligned
+	BZ 	$Lfaligned_loop
+
+	! prefetch
+	GETL 	D0Re0, D1Re0, [A1.2]
+
+	CMP 	D0Ar6, #4
+	BLT 	$Lfunaligned_1_2_3
+	BZ 	$Lfaligned_4
+
+	SUB 	D0Ar6, D0Ar6, #4
+	MULW 	D0.6, D0Ar6, #8
+	MOV 	D1.6, #32
+	SUB 	D1.6, D1.6, D0.6
+
+$Lfunaligned_5_6_7:
+	GETL 	D0.7, D1.7, [++A1.2]
+	! form 64-bit data in D0Re0, D1Re0
+	MOV 	D0Re0, D1Re0
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D1Re0, D0.7
+	LSL 	D1Re0, D1Re0, D1.6
+	MOV 	D0.5, D1Re0
+	ADD 	D0Re0, D0Re0, D0.5
+
+	MOV 	D0.5, D0.7
+	LSR 	D0.5, D0.5, D0.6
+	MOV 	D1Re0, D1.7
+	LSL 	D1Re0, D1Re0, D1.6
+	MOV 	D1.5, D0.5
+	ADD 	D1Re0, D1Re0, D1.5
+
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lfunaligned_5_6_7
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lfbyte_loop_exit
+	! Adjust A1.2
+	ADD	A1.2, A1.2, D0Ar4
+	B 	$Lfbyte_loop
+
+$Lfunaligned_1_2_3:
+	MULW 	D0.6, D0Ar6, #8
+	MOV 	D1.6, #32
+	SUB 	D1.6, D1.6, D0.6
+
+$Lfunaligned_1_2_3_loop:
+	GETL 	D0.7, D1.7, [++A1.2]
+	! form 64-bit data in D0Re0, D1Re0
+	LSR 	D0Re0, D0Re0, D0.6
+	MOV 	D1.5, D1Re0
+	LSL 	D1Re0, D1Re0, D1.6
+	MOV 	D0.5, D1Re0
+	ADD 	D0Re0, D0Re0, D0.5
+
+	MOV 	D0.5, D1.5
+	LSR 	D0.5, D0.5, D0.6
+	MOV 	D1Re0, D0.7
+	LSL 	D1Re0, D1Re0, D1.6
+	MOV 	D1.5, D0.5
+	ADD 	D1Re0, D1Re0, D1.5
+
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lfunaligned_1_2_3_loop
+
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lfbyte_loop_exit
+	! Adjust A1.2
+	ADD	A1.2, A1.2, D0Ar4
+	B 	$Lfbyte_loop
+
+$Lfaligned_4:
+	GETL 	D0.7, D1.7, [++A1.2]
+	MOV 	D0Re0, D1Re0
+	MOV 	D1Re0, D0.7
+	SETL 	[A0.2++], D0Re0, D1Re0
+	MOV 	D0Re0, D0.7
+	MOV 	D1Re0, D1.7
+	SUBS 	D1Ar5, D1Ar5, #1
+	BNE 	$Lfaligned_4
+	ANDS 	D1Ar3, D1Ar3, #7
+	BZ 	$Lfbyte_loop_exit
+	! Adjust A1.2
+	ADD	A1.2, A1.2, D0Ar4
+	B 	$Lfbyte_loop
+
+	.size _memmove,.-_memmove
diff --git a/arch/metag/lib/memset.S b/arch/metag/lib/memset.S
new file mode 100644
index 0000000..721085b
--- /dev/null
+++ b/arch/metag/lib/memset.S
@@ -0,0 +1,86 @@
+!   Copyright (C) 2008-2012 Imagination Technologies Ltd.
+
+	.text
+	.global	_memset
+	.type	_memset,function
+! D1Ar1 dst
+! D0Ar2 c
+! D1Ar3 cnt
+! D0Re0 dst
+_memset:
+	AND	D0Ar2,D0Ar2,#0xFF	! Ensure a byte input value
+	MULW 	D0Ar2,D0Ar2,#0x0101	! Duplicate byte value into  0-15
+	ANDS	D0Ar4,D1Ar1,#7		! Extract bottom LSBs of dst
+	LSL 	D0Re0,D0Ar2,#16		! Duplicate byte value into 16-31
+	ADD	A0.2,D0Ar2,D0Re0	! Duplicate byte value into 4 (A0.2)
+	MOV	D0Re0,D1Ar1		! Return dst
+	BZ	$LLongStub		! if start address is aligned
+	! start address is not aligned on an 8 byte boundary, so we
+	! need the number of bytes up to the next 8 byte address
+	! boundary, or the length of the string if less than 8, in D1Ar5
+	MOV	D0Ar2,#8		! Need 8 - N in D1Ar5 ...
+	SUB	D1Ar5,D0Ar2,D0Ar4	!            ... subtract N
+	CMP	D1Ar3,D1Ar5
+	MOVMI	D1Ar5,D1Ar3
+	B	$LByteStub		! dst is mis-aligned, do $LByteStub
+
+!
+! Preamble to LongLoop which generates 4*8 bytes per interation (5 cycles)
+!
+$LLongStub:
+	LSRS	D0Ar2,D1Ar3,#5
+	AND	D1Ar3,D1Ar3,#0x1F
+	MOV	A1.2,A0.2
+	BEQ	$LLongishStub
+	SUB	TXRPT,D0Ar2,#1
+	CMP	D1Ar3,#0
+$LLongLoop:
+	SETL 	[D1Ar1++],A0.2,A1.2
+	SETL 	[D1Ar1++],A0.2,A1.2
+	SETL 	[D1Ar1++],A0.2,A1.2
+	SETL 	[D1Ar1++],A0.2,A1.2
+	BR	$LLongLoop
+	BZ	$Lexit
+!
+! Preamble to LongishLoop which generates 1*8 bytes per interation (2 cycles)
+!
+$LLongishStub:
+	LSRS	D0Ar2,D1Ar3,#3
+	AND	D1Ar3,D1Ar3,#0x7
+	MOV	D1Ar5,D1Ar3
+	BEQ	$LByteStub
+	SUB	TXRPT,D0Ar2,#1
+	CMP	D1Ar3,#0
+$LLongishLoop:
+	SETL 	[D1Ar1++],A0.2,A1.2
+	BR	$LLongishLoop
+	BZ	$Lexit
+!
+! This does a byte structured burst of up to 7 bytes
+!
+!	D1Ar1 should point to the location required
+!	D1Ar3 should be the remaining total byte count
+!	D1Ar5 should be burst size (<= D1Ar3)
+!
+$LByteStub:
+	SUBS	D1Ar3,D1Ar3,D1Ar5	! Reduce count
+	ADD	D1Ar1,D1Ar1,D1Ar5	! Advance pointer to end of area
+	MULW	D1Ar5,D1Ar5,#4		! Scale to (1*4), (2*4), (3*4)
+	SUB	D1Ar5,D1Ar5,#(8*4)	! Rebase to -(7*4), -(6*4), -(5*4), ...
+	MOV	A1.2,D1Ar5
+	SUB	PC,CPC1,A1.2		! Jump into table below
+	SETB 	[D1Ar1+#(-7)],A0.2
+	SETB 	[D1Ar1+#(-6)],A0.2
+	SETB 	[D1Ar1+#(-5)],A0.2
+	SETB 	[D1Ar1+#(-4)],A0.2
+	SETB 	[D1Ar1+#(-3)],A0.2
+	SETB 	[D1Ar1+#(-2)],A0.2
+	SETB 	[D1Ar1+#(-1)],A0.2
+!
+! Return if all data has been output, otherwise do $LLongStub
+!
+	BNZ	$LLongStub
+$Lexit:
+	MOV	PC,D1RtP
+        .size _memset,.-_memset
+
diff --git a/arch/metag/lib/modsi3.S b/arch/metag/lib/modsi3.S
new file mode 100644
index 0000000..210cfa8
--- /dev/null
+++ b/arch/metag/lib/modsi3.S
@@ -0,0 +1,38 @@
+! Copyright (C) 2001, 2002, 2003, 2004, 2005, 2006, 2007
+!               Imagination Technologies Ltd
+!
+! Integer modulus routines.
+!
+!!
+!! 32-bit modulus unsigned i/p - passed unsigned 32-bit numbers
+!!
+	.text
+	.global ___umodsi3
+	.type   ___umodsi3,function
+	.align  2
+___umodsi3:
+	MOV     D0FrT,D1RtP             ! Save original return address
+	CALLR   D1RtP,___udivsi3
+	MOV     D1RtP,D0FrT             ! Recover return address
+	MOV     D0Re0,D1Ar1             ! Return remainder
+	MOV     PC,D1RtP
+	.size   ___umodsi3,.-___umodsi3
+
+!!
+!! 32-bit modulus signed i/p - passed signed 32-bit numbers
+!!
+	.global ___modsi3
+	.type   ___modsi3,function
+	.align  2
+___modsi3:
+	MOV     D0FrT,D1RtP             ! Save original return address
+	MOV     A0.2,D1Ar1              ! Save A in A0.2
+	CALLR   D1RtP,___divsi3
+	MOV     D1RtP,D0FrT             ! Recover return address
+	MOV     D1Re0,A0.2              ! Recover A
+	MOV     D0Re0,D1Ar1             ! Return remainder
+	ORS     D1Re0,D1Re0,D1Re0       ! Was A negative?
+	NEG     D1Ar1,D1Ar1             ! Negate remainder
+	MOVMI   D0Re0,D1Ar1             ! Return neg remainder
+	MOV     PC, D1RtP
+	.size   ___modsi3,.-___modsi3
diff --git a/arch/metag/lib/muldi3.S b/arch/metag/lib/muldi3.S
new file mode 100644
index 0000000..ee66ca8
--- /dev/null
+++ b/arch/metag/lib/muldi3.S
@@ -0,0 +1,44 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit multiply routine.
+!
+
+!
+! 64-bit signed/unsigned multiply
+!
+! A = D1Ar1:D0Ar2 = a 2^48 + b 2^32 +  c 2^16 + d 2^0
+!
+! B = D1Ar3:D0Ar4 = w 2^48 + x 2^32 +  y 2^16 + z 2^0
+!
+	.text
+	.global ___muldi3
+	.type   ___muldi3,function
+
+___muldi3:
+	MULD    D1Re0,D1Ar1,D0Ar4       ! (a 2^48 + b 2^32)(y 2^16 + z 2^0)
+	MULD    D0Re0,D0Ar2,D1Ar3       ! (w 2^48 + x 2^32)(c 2^16 + d 2^0)
+	ADD     D1Re0,D1Re0,D0Re0
+
+	MULW    D0Re0,D0Ar2,D0Ar4       ! (d 2^0)  * (z 2^0)
+
+	RTDW    D0Ar2,D0Ar2
+	MULW    D0Ar6,D0Ar2,D0Ar4       ! (c 2^16)(z 2^0)
+	LSR     D1Ar5,D0Ar6,#16
+	LSL     D0Ar6,D0Ar6,#16
+	ADDS    D0Re0,D0Re0,D0Ar6
+	ADDCS   D1Re0,D1Re0,#1
+	RTDW    D0Ar4,D0Ar4
+	ADD     D1Re0,D1Re0,D1Ar5
+
+	MULW    D0Ar6,D0Ar2,D0Ar4       ! (c 2^16)(y 2^16)
+	ADD     D1Re0,D1Re0,D0Ar6
+
+	RTDW    D0Ar2,D0Ar2
+	MULW    D0Ar6,D0Ar2,D0Ar4       ! (d 2^0)(y 2^16)
+	LSR     D1Ar5,D0Ar6,#16
+	LSL     D0Ar6,D0Ar6,#16
+	ADDS    D0Re0,D0Re0,D0Ar6
+	ADD     D1Re0,D1Re0,D1Ar5
+	ADDCS   D1Re0,D1Re0,#1
+	MOV     PC, D1RtP
+	.size ___muldi3,.-___muldi3
diff --git a/arch/metag/lib/ucmpdi2.S b/arch/metag/lib/ucmpdi2.S
new file mode 100644
index 0000000..6f3347f
--- /dev/null
+++ b/arch/metag/lib/ucmpdi2.S
@@ -0,0 +1,27 @@
+! Copyright (C) 2012 by Imagination Technologies Ltd.
+!
+! 64-bit unsigned compare routine.
+!
+
+	.text
+	.global ___ucmpdi2
+	.type   ___ucmpdi2,function
+
+!         low    high
+! u64 a  (D0Ar2, D1Ar1)
+! u64 b  (D0Ar4, D1Ar3)
+___ucmpdi2:
+	! start at 1 (equal) and conditionally increment or decrement
+	MOV	D0Re0,#1
+
+	! high words
+	CMP	D1Ar1,D1Ar3
+	! or if equal, low words
+	CMPEQ	D0Ar2,D0Ar4
+
+	! unsigned compare
+	SUBLO	D0Re0,D0Re0,#1
+	ADDHI	D0Re0,D0Re0,#1
+
+	MOV	PC,D1RtP
+	.size ___ucmpdi2,.-___ucmpdi2
-- 
1.7.7.6


