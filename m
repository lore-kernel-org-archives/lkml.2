Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab2LEQNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:13:08 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55549 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539Ab2LEQJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:09:43 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH v2 32/44] metag: Optimised library functions
Date: Wed, 5 Dec 2012 16:08:50 +0000
Message-ID: <1354723742-6195-33-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_12_05_16_09_33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add optimised library functions for metag.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/include/asm/checksum.h |   92 +++
 arch/metag/include/asm/div64.h    |   12 +
 arch/metag/include/asm/string.h   |   13 +
 arch/metag/lib/ashldi3.S          |   33 +
 arch/metag/lib/ashrdi3.S          |   33 +
 arch/metag/lib/checksum.c         |  169 +++++
 arch/metag/lib/clear_page.S       |   17 +
 arch/metag/lib/cmpdi2.S           |   32 +
 arch/metag/lib/copy_page.S        |   20 +
 arch/metag/lib/delay.c            |   55 ++
 arch/metag/lib/div64.S            |  108 +++
 arch/metag/lib/divsi3.S           |  100 +++
 arch/metag/lib/ip_fast_csum.S     |   32 +
 arch/metag/lib/lshrdi3.S          |   33 +
 arch/metag/lib/memcpy.S           |  185 +++++
 arch/metag/lib/memmove.S          |  345 ++++++++++
 arch/metag/lib/memset.S           |   86 +++
 arch/metag/lib/modsi3.S           |   38 +
 arch/metag/lib/muldi3.S           |   44 ++
 arch/metag/lib/ucmpdi2.S          |   27 +
 arch/metag/lib/usercopy.c         | 1341 +++++++++++++++++++++++++++++++++++++
 21 files changed, 2815 insertions(+), 0 deletions(-)
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
 create mode 100644 arch/metag/lib/usercopy.c

diff --git a/arch/metag/include/asm/checksum.h b/arch/metag/include/asm/checksum.h
new file mode 100644
index 0000000..1113f4b
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
+	__asm__("ADD    %0, %0, %1\n"
+		"ADDS   %0, %0, %2\n"
+		"ADDCS  %0, %0, #1\n"
+		"ADDS   %0, %0, %3\n"
+		"ADDCS  %0, %0, #1\n"
+		: "=d"(sum)
+		: "d"(daddr), "d"(saddr), "d"(len_proto),
+		  "0"(sum)
+		: "cc");
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
index 0000000..ac2daa2
--- /dev/null
+++ b/arch/metag/lib/checksum.c
@@ -0,0 +1,169 @@
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
+
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
diff --git a/arch/metag/lib/usercopy.c b/arch/metag/lib/usercopy.c
new file mode 100644
index 0000000..72a4c6d
--- /dev/null
+++ b/arch/metag/lib/usercopy.c
@@ -0,0 +1,1341 @@
+/*
+ * User address space access functions.
+ * The non-inlined parts of asm-metag/uaccess.h are here.
+ *
+ * Copyright (C) 2006, Imagination Technologies.
+ * Copyright (C) 2000, Axis Communications AB.
+ *
+ * Written by Hans-Peter Nilsson.
+ * Pieces used from memcpy, originally by Kenny Ranerup long time ago.
+ * Modified for Meta by Will Newton.
+ */
+
+#include <linux/uaccess.h>
+#include <asm/cache.h>			/* def of L1_CACHE_BYTES */
+
+#define USE_RAPF
+#define RAPF_MIN_BUF_SIZE	(3*L1_CACHE_BYTES)
+
+
+/* The "double write" in this code is because the Meta will not fault
+ * immediately unless the memory pipe is forced to by e.g. a data stall or
+ * another memory op. The second write should be discarded by the write
+ * combiner so should have virtually no cost.
+ */
+
+#define __asm_copy_user_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm__ __volatile__ (				\
+			COPY				\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"	MOV D1Ar1,#0\n"			\
+			FIXUP				\
+		"	MOVT    D1Ar1,#HI(1b)\n"	\
+		"	JUMP    D1Ar1,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+			TENTRY				\
+		"	.previous\n"			\
+		: "=r" (to), "=r" (from), "=r" (ret)	\
+		: "0" (to), "1" (from), "2" (ret)	\
+		: "D1Ar1", "memory")
+
+
+#define __asm_copy_to_user_1(to, from, ret)	\
+	__asm_copy_user_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"	\
+		"	SETB [%0],D1Ar1\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %2,%2,#1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_copy_to_user_2x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"2:	SETW [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_to_user_2(to, from, ret) \
+	__asm_copy_to_user_2x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_3(to, from, ret) \
+	__asm_copy_to_user_2x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_to_user_4x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"2:	SETD [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_to_user_4(to, from, ret) \
+	__asm_copy_to_user_4x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_5(to, from, ret) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_to_user_6x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"4:	SETW [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_to_user_6(to, from, ret) \
+	__asm_copy_to_user_6x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_7(to, from, ret) \
+	__asm_copy_to_user_6x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_to_user_8x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_4x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"4:	SETD [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#4\n"  FIXUP,	\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_to_user_8(to, from, ret) \
+	__asm_copy_to_user_8x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_9(to, from, ret) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_to_user_10x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"6:	SETW [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_to_user_10(to, from, ret) \
+	__asm_copy_to_user_10x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_11(to, from, ret) \
+	__asm_copy_to_user_10x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_to_user_12x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_8x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"6:	SETD [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+#define __asm_copy_to_user_12(to, from, ret) \
+	__asm_copy_to_user_12x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_13(to, from, ret) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_to_user_14x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"	SETW [%0],D1Ar1\n"		\
+		"8:	SETW [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#2\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_to_user_14(to, from, ret) \
+	__asm_copy_to_user_14x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_15(to, from, ret) \
+	__asm_copy_to_user_14x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"	SETB [%0],D1Ar1\n"		\
+		"10:	SETB [%0++],D1Ar1\n",		\
+		"11:	ADD  %2,%2,#1\n",		\
+		"	.long 10b,11b\n")
+
+#define __asm_copy_to_user_16x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_to_user_12x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"	SETD [%0],D1Ar1\n"		\
+		"8:	SETD [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#4\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_to_user_16(to, from, ret) \
+		__asm_copy_to_user_16x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_to_user_8x64(to, from, ret) \
+	__asm__ __volatile__ (				\
+		"	GETL D0Ar2,D1Ar1,[%1++]\n"	\
+		"	SETL [%0],D0Ar2,D1Ar1\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"3:	ADD  %2,%2,#8\n"		\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=r" (to), "=r" (from), "=r" (ret)	\
+		: "0" (to), "1" (from), "2" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*
+ *	optimized copying loop using RAPF when 64 bit aligned
+ *
+ *	n		will be automatically decremented inside the loop
+ *	ret		will be left intact. if error occurs we will rewind
+ *			so that the original non optimized code will fill up
+ *			this value correctly.
+ *
+ *	on fault:
+ *		>	n will hold total number of uncopied bytes
+ *
+ *		>	{'to','from'} will be rewind back so that
+ *			the non-optimized code will do the proper fix up
+ *
+ *	DCACHE drops the cacheline which helps in reducing cache
+ *	pollution.
+ *
+ *	We introduce an extra SETL at the end of the loop to
+ *	ensure we don't fall off the loop before we catch all
+ *	erros.
+ *
+ *	NOTICE:
+ *		LSM_STEP in TXSTATUS must be cleared in fix up code.
+ *		since we're using M{S,G}ETL, a fault might happen at
+ *		any address in the middle of M{S,G}ETL causing
+ *		the value of LSM_STEP to be incorrect which can
+ *		cause subsequent use of M{S,G}ET{L,D} to go wrong.
+ *		ie: if LSM_STEP was 1 when a fault occurs, the
+ *		next call to M{S,G}ET{L,D} will skip the first
+ *		copy/getting as it think that the first 1 has already
+ *		been done.
+ *
+ */
+#define __asm_copy_user_64bit_rapf_loop(				\
+		to, from, ret, n, id, FIXUP)				\
+	__asm__ __volatile__ (						\
+		".balign 8\n"						\
+		"MOV	RAPF, %1\n"					\
+		"MSETL	[A0StP++], D0Ar6, D0FrT, D0.5, D0.6, D0.7\n"	\
+		"MOV	D0Ar6, #0\n"					\
+		"LSR	D1Ar5, %3, #6\n"				\
+		"SUB	TXRPT, D1Ar5, #2\n"				\
+		"MOV	RAPF, %1\n"					\
+	"$Lloop"id":\n"							\
+		"ADD	RAPF, %1, #64\n"				\
+		"21:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"22:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"23:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"24:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"BR	$Lloop"id"\n"					\
+									\
+		"MOV	RAPF, %1\n"					\
+		"25:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"26:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #32\n"					\
+		"27:\n"							\
+		"MGETL	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"28:\n"							\
+		"MSETL	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%0, %0, #8\n"					\
+		"29:\n"							\
+		"SETL	[%0++], D0.7, D1.7\n"				\
+		"SUB	%3, %3, #32\n"					\
+		"1:"							\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"GETL    D0Ar6, D1Ar5, [A0StP+#-40]\n"			\
+		"GETL    D0FrT, D1RtP, [A0StP+#-32]\n"			\
+		"GETL    D0.5, D1.5, [A0StP+#-24]\n"			\
+		"GETL    D0.6, D1.6, [A0StP+#-16]\n"			\
+		"GETL    D0.7, D1.7, [A0StP+#-8]\n"			\
+		"SUB A0StP, A0StP, #40\n"				\
+		"	.section .fixup,\"ax\"\n"			\
+		"4:\n"							\
+		"	ADD	%0, %0, #8\n"				\
+		"3:\n"							\
+		"	MOV	D0Ar2, TXSTATUS\n"			\
+		"	MOV	D1Ar1, TXSTATUS\n"			\
+		"	AND	D1Ar1, D1Ar1, #0xFFFFF8FF\n"		\
+		"	MOV	TXSTATUS, D1Ar1\n"			\
+			FIXUP						\
+		"	MOVT    D0Ar2,#HI(1b)\n"			\
+		"	JUMP    D0Ar2,#LO(1b)\n"			\
+		"	.previous\n"					\
+		"	.section __ex_table,\"a\"\n"			\
+		"	.long 21b,3b\n"					\
+		"	.long 22b,3b\n"					\
+		"	.long 23b,3b\n"					\
+		"	.long 24b,3b\n"					\
+		"	.long 25b,3b\n"					\
+		"	.long 26b,3b\n"					\
+		"	.long 27b,3b\n"					\
+		"	.long 28b,3b\n"					\
+		"	.long 29b,4b\n"					\
+		"	.previous\n"					\
+		: "=r" (to), "=r" (from), "=r" (ret), "=d" (n)		\
+		: "0" (to), "1" (from), "2" (ret), "3" (n)		\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'to' and 'from'  pointers when a fault occurs
+ *
+ *	Rationale:
+ *		A fault always occurs on writing to user buffer. A fault
+ *		is at a single address, so we need to rewind by only 4
+ *		bytes.
+ *		Since we do a complete read from kernel buffer before
+ *		writing, we need to rewind it also. The amount to be
+ *		rewind equals the number of faulty writes in MSETD
+ *		which is: [4 - (LSM_STEP-1)]*8
+ *		LSM_STEP is bits 10:8 in TXSTATUS which is already read
+ *		and stored in D0Ar2
+ *
+ *		NOTE: If a fault occurs at the last operation in M{G,S}ETL
+ *			LSM_STEP will be 0. ie: we do 4 writes in our case, if
+ *			a fault happens at the 4th write, LSM_STEP will be 0
+ *			instead of 4. The code copes with that.
+ *
+ *		n is updated by the number of successful writes, which is:
+ *		n = n - (LSM_STEP-1)*8
+ */
+#define __asm_copy_to_user_64bit_rapf_loop(to,	from, ret, n, id)\
+	__asm_copy_user_64bit_rapf_loop(to, from, ret, n, id,		\
+		"LSR	D0Ar2, D0Ar2, #8\n"				\
+		"AND	D0Ar2, D0Ar2, #0x7\n"				\
+		"ADDZ	D0Ar2, D0Ar2, #4\n"				\
+		"SUB	D0Ar2, D0Ar2, #1\n"				\
+		"MOV	D1Ar1, #4\n"					\
+		"SUB	D0Ar2, D1Ar1, D0Ar2\n"				\
+		"LSL	D0Ar2, D0Ar2, #3\n"				\
+		"LSL	D1Ar1, D1Ar1, #3\n"				\
+		"SUB	D1Ar1, D1Ar1, D0Ar2\n"				\
+		"SUB	%0, %0, #8\n"					\
+		"SUB	%1,	%1,D0Ar2\n"				\
+		"SUB	%3, %3, D1Ar1\n")
+
+/*
+ *	optimized copying loop using RAPF when 32 bit aligned
+ *
+ *	n		will be automatically decremented inside the loop
+ *	ret		will be left intact. if error occurs we will rewind
+ *			so that the original non optimized code will fill up
+ *			this value correctly.
+ *
+ *	on fault:
+ *		>	n will hold total number of uncopied bytes
+ *
+ *		>	{'to','from'} will be rewind back so that
+ *			the non-optimized code will do the proper fix up
+ *
+ *	DCACHE drops the cacheline which helps in reducing cache
+ *	pollution.
+ *
+ *	We introduce an extra SETD at the end of the loop to
+ *	ensure we don't fall off the loop before we catch all
+ *	erros.
+ *
+ *	NOTICE:
+ *		LSM_STEP in TXSTATUS must be cleared in fix up code.
+ *		since we're using M{S,G}ETL, a fault might happen at
+ *		any address in the middle of M{S,G}ETL causing
+ *		the value of LSM_STEP to be incorrect which can
+ *		cause subsequent use of M{S,G}ET{L,D} to go wrong.
+ *		ie: if LSM_STEP was 1 when a fault occurs, the
+ *		next call to M{S,G}ET{L,D} will skip the first
+ *		copy/getting as it think that the first 1 has already
+ *		been done.
+ *
+ */
+#define __asm_copy_user_32bit_rapf_loop(				\
+			to,	from, ret, n, id, FIXUP)		\
+	__asm__ __volatile__ (						\
+		".balign 8\n"						\
+		"MOV	RAPF, %1\n"					\
+		"MSETL	[A0StP++], D0Ar6, D0FrT, D0.5, D0.6, D0.7\n"	\
+		"MOV	D0Ar6, #0\n"					\
+		"LSR	D1Ar5, %3, #6\n"				\
+		"SUB	TXRPT, D1Ar5, #2\n"				\
+		"MOV	RAPF, %1\n"					\
+	"$Lloop"id":\n"							\
+		"ADD	RAPF, %1, #64\n"				\
+		"21:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"22:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"23:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"24:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"25:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"26:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"27:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"28:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"BR	$Lloop"id"\n"					\
+									\
+		"MOV	RAPF, %1\n"					\
+		"29:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"30:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"31:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"32:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"33:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"34:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%3, %3, #16\n"					\
+		"35:\n"							\
+		"MGETD	D0FrT, D0.5, D0.6, D0.7, [%1++]\n"		\
+		"36:\n"							\
+		"MSETD	[%0++], D0FrT, D0.5, D0.6, D0.7\n"		\
+		"SUB	%0, %0, #4\n"					\
+		"37:\n"							\
+		"SETD	[%0++], D0.7\n"					\
+		"SUB	%3, %3, #16\n"					\
+		"1:"							\
+		"DCACHE	[%1+#-64], D0Ar6\n"				\
+		"GETL    D0Ar6, D1Ar5, [A0StP+#-40]\n"			\
+		"GETL    D0FrT, D1RtP, [A0StP+#-32]\n"			\
+		"GETL    D0.5, D1.5, [A0StP+#-24]\n"			\
+		"GETL    D0.6, D1.6, [A0StP+#-16]\n"			\
+		"GETL    D0.7, D1.7, [A0StP+#-8]\n"			\
+		"SUB A0StP, A0StP, #40\n"				\
+		"	.section .fixup,\"ax\"\n"			\
+		"4:\n"							\
+		"	ADD		%0, %0, #4\n"			\
+		"3:\n"							\
+		"	MOV	D0Ar2, TXSTATUS\n"			\
+		"	MOV	D1Ar1, TXSTATUS\n"			\
+		"	AND	D1Ar1, D1Ar1, #0xFFFFF8FF\n"		\
+		"	MOV	TXSTATUS, D1Ar1\n"			\
+			FIXUP						\
+		"	MOVT    D0Ar2,#HI(1b)\n"			\
+		"	JUMP    D0Ar2,#LO(1b)\n"			\
+		"	.previous\n"					\
+		"	.section __ex_table,\"a\"\n"			\
+		"	.long 21b,3b\n"					\
+		"	.long 22b,3b\n"					\
+		"	.long 23b,3b\n"					\
+		"	.long 24b,3b\n"					\
+		"	.long 25b,3b\n"					\
+		"	.long 26b,3b\n"					\
+		"	.long 27b,3b\n"					\
+		"	.long 28b,3b\n"					\
+		"	.long 29b,3b\n"					\
+		"	.long 30b,3b\n"					\
+		"	.long 31b,3b\n"					\
+		"	.long 32b,3b\n"					\
+		"	.long 33b,3b\n"					\
+		"	.long 34b,3b\n"					\
+		"	.long 35b,3b\n"					\
+		"	.long 36b,3b\n"					\
+		"	.long 37b,4b\n"					\
+		"	.previous\n"					\
+		: "=r" (to), "=r" (from), "=r" (ret), "=d" (n)		\
+		: "0" (to), "1" (from), "2" (ret), "3" (n)		\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'to' and 'from'  pointers when a fault occurs
+ *
+ *	Rationale:
+ *		A fault always occurs on writing to user buffer. A fault
+ *		is at a single address, so we need to rewind by only 4
+ *		bytes.
+ *		Since we do a complete read from kernel buffer before
+ *		writing, we need to rewind it also. The amount to be
+ *		rewind equals the number of faulty writes in MSETD
+ *		which is: [4 - (LSM_STEP-1)]*4
+ *		LSM_STEP is bits 10:8 in TXSTATUS which is already read
+ *		and stored in D0Ar2
+ *
+ *		NOTE: If a fault occurs at the last operation in M{G,S}ETL
+ *			LSM_STEP will be 0. ie: we do 4 writes in our case, if
+ *			a fault happens at the 4th write, LSM_STEP will be 0
+ *			instead of 4. The code copes with that.
+ *
+ *		n is updated by the number of successful writes, which is:
+ *		n = n - (LSM_STEP-1)*4
+ */
+#define __asm_copy_to_user_32bit_rapf_loop(to, from, ret, n, id)\
+	__asm_copy_user_32bit_rapf_loop(to, from, ret, n, id,		\
+		"LSR	D0Ar2, D0Ar2, #8\n"				\
+		"AND	D0Ar2, D0Ar2, #0x7\n"				\
+		"ADDZ	D0Ar2, D0Ar2, #4\n"				\
+		"SUB	D0Ar2, D0Ar2, #1\n"				\
+		"MOV	D1Ar1, #4\n"					\
+		"SUB	D0Ar2, D1Ar1, D0Ar2\n"				\
+		"LSL	D0Ar2, D0Ar2, #2\n"				\
+		"LSL	D1Ar1, D1Ar1, #2\n"				\
+		"SUB	D1Ar1, D1Ar1, D0Ar2\n"				\
+		"SUB	%0, %0, #4\n"					\
+		"SUB	%1,	%1,	D0Ar2\n"			\
+		"SUB	%3, %3, D1Ar1\n")
+
+unsigned long __copy_user(void __user *pdst, const void *psrc,
+			  unsigned long n)
+{
+	register char __user *dst __asm__ ("A0.2") = pdst;
+	register const char *src __asm__ ("A1.2") = psrc;
+	unsigned long retn = 0;
+
+	if (n == 0)
+		return 0;
+
+	if ((unsigned long) src & 1) {
+		__asm_copy_to_user_1(dst, src, retn);
+		n--;
+	}
+	if ((unsigned long) dst & 1) {
+		/* Worst case - byte copy */
+		while (n > 0) {
+			__asm_copy_to_user_1(dst, src, retn);
+			n--;
+		}
+	}
+	if (((unsigned long) src & 2) && n >= 2) {
+		__asm_copy_to_user_2(dst, src, retn);
+		n -= 2;
+	}
+	if ((unsigned long) dst & 2) {
+		/* Second worst case - word copy */
+		while (n >= 2) {
+			__asm_copy_to_user_2(dst, src, retn);
+			n -= 2;
+		}
+	}
+
+#ifdef USE_RAPF
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (__force unsigned long) dst) & 7)) {
+		if (n >= RAPF_MIN_BUF_SIZE) {
+			/* copy user using 64 bit rapf copy */
+			__asm_copy_to_user_64bit_rapf_loop(dst, src, retn,
+							n, "64cu");
+		}
+		while (n >= 8) {
+			__asm_copy_to_user_8x64(dst, src, retn);
+			n -= 8;
+		}
+	}
+	if (n >= RAPF_MIN_BUF_SIZE) {
+		/* copy user using 32 bit rapf copy */
+		__asm_copy_to_user_32bit_rapf_loop(dst, src, retn, n, "32cu");
+	}
+#else
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (__force unsigned long) dst) & 7)) {
+		while (n >= 8) {
+			__asm_copy_to_user_8x64(dst, src, retn);
+			n -= 8;
+		}
+	}
+#endif
+
+	while (n >= 16) {
+		__asm_copy_to_user_16(dst, src, retn);
+		n -= 16;
+	}
+
+	while (n >= 4) {
+		__asm_copy_to_user_4(dst, src, retn);
+		n -= 4;
+	}
+
+	switch (n) {
+	case 0:
+		break;
+	case 1:
+		__asm_copy_to_user_1(dst, src, retn);
+		break;
+	case 2:
+		__asm_copy_to_user_2(dst, src, retn);
+		break;
+	case 3:
+		__asm_copy_to_user_3(dst, src, retn);
+		break;
+	}
+
+	return retn;
+}
+
+#define __asm_copy_from_user_1(to, from, ret) \
+	__asm_copy_user_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %2,%2,#1\n"	\
+		"	SETB [%0++],D1Ar1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_copy_from_user_2x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"2:	SETW [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_from_user_2(to, from, ret) \
+	__asm_copy_from_user_2x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_3(to, from, ret)		\
+	__asm_copy_from_user_2x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_from_user_4x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_user_cont(to, from, ret,		\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"2:	SETD [%0++],D1Ar1\n" COPY,	\
+		"3:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_copy_from_user_4(to, from, ret) \
+	__asm_copy_from_user_4x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_5(to, from, ret) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"4:	SETB [%0++],D1Ar1\n",		\
+		"5:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 4b,5b\n")
+
+#define __asm_copy_from_user_6x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"4:	SETW [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_from_user_6(to, from, ret) \
+	__asm_copy_from_user_6x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_7(to, from, ret) \
+	__asm_copy_from_user_6x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_from_user_8x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_4x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"4:	SETD [%0++],D1Ar1\n" COPY,	\
+		"5:	ADD  %2,%2,#4\n"			\
+		"	SETD [%0++],D1Ar1\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_copy_from_user_8(to, from, ret) \
+	__asm_copy_from_user_8x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_9(to, from, ret) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"6:	SETB [%0++],D1Ar1\n",		\
+		"7:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 6b,7b\n")
+
+#define __asm_copy_from_user_10x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"6:	SETW [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_from_user_10(to, from, ret) \
+	__asm_copy_from_user_10x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_11(to, from, ret)		\
+	__asm_copy_from_user_10x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_from_user_12x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_8x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"6:	SETD [%0++],D1Ar1\n" COPY,	\
+		"7:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_copy_from_user_12(to, from, ret) \
+	__asm_copy_from_user_12x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_13(to, from, ret) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"8:	SETB [%0++],D1Ar1\n",		\
+		"9:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 8b,9b\n")
+
+#define __asm_copy_from_user_14x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETW D1Ar1,[%1++]\n"		\
+		"8:	SETW [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#2\n"		\
+		"	SETW [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_from_user_14(to, from, ret) \
+	__asm_copy_from_user_14x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_15(to, from, ret) \
+	__asm_copy_from_user_14x_cont(to, from, ret,	\
+		"	GETB D1Ar1,[%1++]\n"		\
+		"10:	SETB [%0++],D1Ar1\n",		\
+		"11:	ADD  %2,%2,#1\n"		\
+		"	SETB [%0++],D1Ar1\n",		\
+		"	.long 10b,11b\n")
+
+#define __asm_copy_from_user_16x_cont(to, from, ret, COPY, FIXUP, TENTRY) \
+	__asm_copy_from_user_12x_cont(to, from, ret,	\
+		"	GETD D1Ar1,[%1++]\n"		\
+		"8:	SETD [%0++],D1Ar1\n" COPY,	\
+		"9:	ADD  %2,%2,#4\n"		\
+		"	SETD [%0++],D1Ar1\n" FIXUP,	\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_copy_from_user_16(to, from, ret) \
+	__asm_copy_from_user_16x_cont(to, from, ret, "", "", "")
+
+#define __asm_copy_from_user_8x64(to, from, ret) \
+	__asm__ __volatile__ (				\
+		"	GETL D0Ar2,D1Ar1,[%1++]\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"	MOV D1Ar1,#0\n"			\
+		"	MOV D0Ar2,#0\n"			\
+		"3:	ADD  %2,%2,#8\n"		\
+		"	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=a" (to), "=r" (from), "=r" (ret)	\
+		: "0" (to), "1" (from), "2" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/*	rewind 'from' pointer when a fault occurs
+ *
+ *	Rationale:
+ *		A fault occurs while reading from user buffer, which is the
+ *		source. Since the fault is at a single address, we only
+ *		need to rewind by 8 bytes.
+ *		Since we don't write to kernel buffer until we read first,
+ *		the kernel buffer is at the right state and needn't be
+ *		corrected.
+ */
+#define __asm_copy_from_user_64bit_rapf_loop(to, from, ret, n, id)	\
+	__asm_copy_user_64bit_rapf_loop(to, from, ret, n, id,		\
+		"SUB	%1, %1, #8\n")
+
+/*	rewind 'from' pointer when a fault occurs
+ *
+ *	Rationale:
+ *		A fault occurs while reading from user buffer, which is the
+ *		source. Since the fault is at a single address, we only
+ *		need to rewind by 4 bytes.
+ *		Since we don't write to kernel buffer until we read first,
+ *		the kernel buffer is at the right state and needn't be
+ *		corrected.
+ */
+#define __asm_copy_from_user_32bit_rapf_loop(to, from, ret, n, id)	\
+	__asm_copy_user_32bit_rapf_loop(to, from, ret, n, id,		\
+		"SUB	%1, %1, #4\n")
+
+
+/* Copy from user to kernel, zeroing the bytes that were inaccessible in
+   userland.  The return-value is the number of bytes that were
+   inaccessible.  */
+unsigned long __copy_user_zeroing(void *pdst, const void __user *psrc,
+				  unsigned long n)
+{
+	register char *dst __asm__ ("A0.2") = pdst;
+	register const char __user *src __asm__ ("A1.2") = psrc;
+	unsigned long retn = 0;
+
+	if (n == 0)
+		return 0;
+
+	if ((unsigned long) src & 1) {
+		__asm_copy_from_user_1(dst, src, retn);
+		n--;
+	}
+	if ((unsigned long) dst & 1) {
+		/* Worst case - byte copy */
+		while (n > 0) {
+			__asm_copy_from_user_1(dst, src, retn);
+			n--;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+	if (((unsigned long) src & 2) && n >= 2) {
+		__asm_copy_from_user_2(dst, src, retn);
+		n -= 2;
+	}
+	if ((unsigned long) dst & 2) {
+		/* Second worst case - word copy */
+		while (n >= 2) {
+			__asm_copy_from_user_2(dst, src, retn);
+			n -= 2;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+
+	/* We only need one check after the unalignment-adjustments,
+	   because if both adjustments were done, either both or
+	   neither reference had an exception.  */
+	if (retn != 0)
+		goto copy_exception_bytes;
+
+#ifdef USE_RAPF
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (unsigned long) dst) & 7)) {
+		if (n >= RAPF_MIN_BUF_SIZE) {
+			/* Copy using fast 64bit rapf */
+			__asm_copy_from_user_64bit_rapf_loop(dst, src, retn,
+							n, "64cuz");
+		}
+		while (n >= 8) {
+			__asm_copy_from_user_8x64(dst, src, retn);
+			n -= 8;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+
+	if (n >= RAPF_MIN_BUF_SIZE) {
+		/* Copy using fast 32bit rapf */
+		__asm_copy_from_user_32bit_rapf_loop(dst, src, retn,
+						n, "32cuz");
+	}
+#else
+	/* 64 bit copy loop */
+	if (!(((unsigned long) src | (unsigned long) dst) & 7)) {
+		while (n >= 8) {
+			__asm_copy_from_user_8x64(dst, src, retn);
+			n -= 8;
+			if (retn)
+				goto copy_exception_bytes;
+		}
+	}
+#endif
+
+	while (n >= 4) {
+		__asm_copy_from_user_4(dst, src, retn);
+		n -= 4;
+
+		if (retn)
+			goto copy_exception_bytes;
+	}
+
+	/* If we get here, there were no memory read faults.  */
+	switch (n) {
+		/* These copies are at least "naturally aligned" (so we don't
+		   have to check each byte), due to the src alignment code.
+		   The *_3 case *will* get the correct count for retn.  */
+	case 0:
+		/* This case deliberately left in (if you have doubts check the
+		   generated assembly code).  */
+		break;
+	case 1:
+		__asm_copy_from_user_1(dst, src, retn);
+		break;
+	case 2:
+		__asm_copy_from_user_2(dst, src, retn);
+		break;
+	case 3:
+		__asm_copy_from_user_3(dst, src, retn);
+		break;
+	}
+
+	/* If we get here, retn correctly reflects the number of failing
+	   bytes.  */
+	return retn;
+
+ copy_exception_bytes:
+	/* We already have "retn" bytes cleared, and need to clear the
+	   remaining "n" bytes.  A non-optimized simple byte-for-byte in-line
+	   memset is preferred here, since this isn't speed-critical code and
+	   we'd rather have this a leaf-function than calling memset.  */
+	{
+		char *endp;
+		for (endp = dst + n; dst < endp; dst++)
+			*dst = 0;
+	}
+
+	return retn + n;
+}
+
+#define __asm_clear_8x64(to, ret) \
+	__asm__ __volatile__ (				\
+		"	MOV  D0Ar2,#0\n"		\
+		"	MOV  D1Ar1,#0\n"		\
+		"	SETL [%0],D0Ar2,D1Ar1\n"	\
+		"2:	SETL [%0++],D0Ar2,D1Ar1\n"	\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+		"3:	ADD  %1,%1,#8\n"		\
+		"	MOVT    D0Ar2,#HI(1b)\n"	\
+		"	JUMP    D0Ar2,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+		"	.long 2b,3b\n"			\
+		"	.previous\n"			\
+		: "=r" (to), "=r" (ret)	\
+		: "0" (to), "1" (ret)	\
+		: "D1Ar1", "D0Ar2", "memory")
+
+/* Zero userspace.  */
+
+#define __asm_clear(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm__ __volatile__ (				\
+		"	MOV D1Ar1,#0\n"			\
+			CLEAR				\
+		"1:\n"					\
+		"	.section .fixup,\"ax\"\n"	\
+			FIXUP				\
+		"	MOVT    D1Ar1,#HI(1b)\n"	\
+		"	JUMP    D1Ar1,#LO(1b)\n"	\
+		"	.previous\n"			\
+		"	.section __ex_table,\"a\"\n"	\
+			TENTRY				\
+		"	.previous"			\
+		: "=r" (to), "=r" (ret)			\
+		: "0" (to), "1" (ret)			\
+		: "D1Ar1", "memory")
+
+#define __asm_clear_1(to, ret) \
+	__asm_clear(to, ret,			\
+		"	SETB [%0],D1Ar1\n"	\
+		"2:	SETB [%0++],D1Ar1\n",	\
+		"3:	ADD  %1,%1,#1\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_clear_2(to, ret) \
+	__asm_clear(to, ret,			\
+		"	SETW [%0],D1Ar1\n"	\
+		"2:	SETW [%0++],D1Ar1\n",	\
+		"3:	ADD  %1,%1,#2\n",	\
+		"	.long 2b,3b\n")
+
+#define __asm_clear_3(to, ret) \
+	__asm_clear(to, ret,			\
+		 "2:	SETW [%0++],D1Ar1\n"	\
+		 "	SETB [%0],D1Ar1\n"	\
+		 "3:	SETB [%0++],D1Ar1\n",	\
+		 "4:	ADD  %1,%1,#2\n"	\
+		 "5:	ADD  %1,%1,#1\n",	\
+		 "	.long 2b,4b\n"		\
+		 "	.long 3b,5b\n")
+
+#define __asm_clear_4x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear(to, ret,				\
+		"	SETD [%0],D1Ar1\n"		\
+		"2:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"3:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 2b,3b\n" TENTRY)
+
+#define __asm_clear_4(to, ret) \
+	__asm_clear_4x_cont(to, ret, "", "", "")
+
+#define __asm_clear_8x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_4x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"4:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"5:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 4b,5b\n" TENTRY)
+
+#define __asm_clear_8(to, ret) \
+	__asm_clear_8x_cont(to, ret, "", "", "")
+
+#define __asm_clear_12x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_8x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"6:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"7:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 6b,7b\n" TENTRY)
+
+#define __asm_clear_12(to, ret) \
+	__asm_clear_12x_cont(to, ret, "", "", "")
+
+#define __asm_clear_16x_cont(to, ret, CLEAR, FIXUP, TENTRY) \
+	__asm_clear_12x_cont(to, ret,			\
+		"	SETD [%0],D1Ar1\n"		\
+		"8:	SETD [%0++],D1Ar1\n" CLEAR,	\
+		"9:	ADD  %1,%1,#4\n" FIXUP,		\
+		"	.long 8b,9b\n" TENTRY)
+
+#define __asm_clear_16(to, ret) \
+	__asm_clear_16x_cont(to, ret, "", "", "")
+
+unsigned long __do_clear_user(void __user *pto, unsigned long pn)
+{
+	register char __user *dst __asm__ ("D0Re0") = pto;
+	register unsigned long n __asm__ ("D1Re0") = pn;
+	register unsigned long retn __asm__ ("D0Ar6") = 0;
+
+	if ((unsigned long) dst & 1) {
+		__asm_clear_1(dst, retn);
+		n--;
+	}
+
+	if ((unsigned long) dst & 2) {
+		__asm_clear_2(dst, retn);
+		n -= 2;
+	}
+
+	/* 64 bit copy loop */
+	if (!((__force unsigned long) dst & 7)) {
+		while (n >= 8) {
+			__asm_clear_8x64(dst, retn);
+			n -= 8;
+		}
+	}
+
+	while (n >= 16) {
+		__asm_clear_16(dst, retn);
+		n -= 16;
+	}
+
+	while (n >= 4) {
+		__asm_clear_4(dst, retn);
+		n -= 4;
+	}
+
+	switch (n) {
+	case 0:
+		break;
+	case 1:
+		__asm_clear_1(dst, retn);
+		break;
+	case 2:
+		__asm_clear_2(dst, retn);
+		break;
+	case 3:
+		__asm_clear_3(dst, retn);
+		break;
+	}
+
+	return retn;
+}
+
+unsigned char __get_user_asm_b(const void __user *addr, long *err)
+{
+	register unsigned char x __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	GETB %0,[%2]\n"
+		"1:\n"
+		"	GETB %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+unsigned short __get_user_asm_w(const void __user *addr, long *err)
+{
+	register unsigned short x __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	GETW %0,[%2]\n"
+		"1:\n"
+		"	GETW %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+unsigned int __get_user_asm_d(const void __user *addr, long *err)
+{
+	register unsigned int x __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	GETD %0,[%2]\n"
+		"1:\n"
+		"	GETD %0,[%2]\n"
+		"2:\n"
+		"	.section .fixup,\"ax\"\n"
+		"3:	MOV     D0FrT,%3\n"
+		"	SETD    [%1],D0FrT\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		"	.previous\n"
+		"	.section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		"	.previous\n"
+		: "=r" (x)
+		: "r" (err), "r" (addr), "P" (-EFAULT)
+		: "D0FrT");
+	return x;
+}
+
+long __put_user_asm_b(unsigned int x, void __user *addr)
+{
+	register unsigned int err __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	MOV  %0,#0\n"
+		"	SETB [%2],%1\n"
+		"1:\n"
+		"	SETB [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_w(unsigned int x, void __user *addr)
+{
+	register unsigned int err __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	MOV  %0,#0\n"
+		"	SETW [%2],%1\n"
+		"1:\n"
+		"	SETW [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_d(unsigned int x, void __user *addr)
+{
+	register unsigned int err __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	MOV  %0,#0\n"
+		"	SETD [%2],%1\n"
+		"1:\n"
+		"	SETD [%2],%1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long __put_user_asm_l(unsigned long long x, void __user *addr)
+{
+	register unsigned int err __asm__ ("D0Re0") = 0;
+	__asm__ __volatile__(
+		"	MOV  %0,#0\n"
+		"	SETL [%2],%1,%t1\n"
+		"1:\n"
+		"	SETL [%2],%1,%t1\n"
+		"2:\n"
+		".section .fixup,\"ax\"\n"
+		"3:	MOV     %0,%3\n"
+		"	MOVT    D0FrT,#HI(2b)\n"
+		"	JUMP    D0FrT,#LO(2b)\n"
+		".previous\n"
+		".section __ex_table,\"a\"\n"
+		"	.long 1b,3b\n"
+		".previous"
+		: "=r"(err)
+		: "d" (x), "a" (addr), "P"(-EFAULT)
+		: "D0FrT");
+	return err;
+}
+
+long strnlen_user(const char __user *src, long count)
+{
+	long res;
+
+	if (!access_ok(VERIFY_READ, src, 0))
+		return 0;
+
+	asm volatile ("	MOV     D0Ar4, %1\n"
+		      "	MOV     D0Ar6, %2\n"
+		      "0:\n"
+		      "	SUBS    D0FrT, D0Ar6, #0\n"
+		      "	SUB     D0Ar6, D0Ar6, #1\n"
+		      "	BLE     2f\n"
+		      "	GETB    D0FrT, [D0Ar4+#1++]\n"
+		      "1:\n"
+		      "	TST     D0FrT, #255\n"
+		      "	BNE     0b\n"
+		      "2:\n"
+		      "	SUB     %0, %2, D0Ar6\n"
+		      "3:\n"
+		      "	.section .fixup,\"ax\"\n"
+		      "4:\n"
+		      "	MOV     %0, #0\n"
+		      "	MOVT    D0FrT,#HI(3b)\n"
+		      "	JUMP    D0FrT,#LO(3b)\n"
+		      "	.previous\n"
+		      "	.section __ex_table,\"a\"\n"
+		      "	.long 1b,4b\n"
+		      "	.previous\n"
+		      : "=r" (res)
+		      : "r" (src), "r" (count)
+		      : "D0FrT", "D0Ar4", "D0Ar6", "cc");
+
+	return res;
+}
+
+long __strncpy_from_user(char *dst, const char __user *src, long count)
+{
+	long res;
+
+	if (count == 0)
+		return 0;
+
+	/*
+	 * Currently, in 2.4.0-test9, most ports use a simple byte-copy loop.
+	 *  So do we.
+	 *
+	 *  This code is deduced from:
+	 *
+	 *      char tmp2;
+	 *      long tmp1, tmp3;
+	 *      tmp1 = count;
+	 *      while ((*dst++ = (tmp2 = *src++)) != 0
+	 *             && --tmp1)
+	 *        ;
+	 *
+	 *      res = count - tmp1;
+	 *
+	 *  with tweaks.
+	 */
+
+	__asm__ __volatile__("	MOV  %0,%3\n"
+			     "1:\n"
+			     "	GETB D0FrT,[%2++]\n"
+			     "2:\n"
+			     "	CMP  D0FrT,#0\n"
+			     "	SETB [%1++],D0FrT\n"
+			     "	BEQ  3f\n"
+			     "	SUBS %0,%0,#1\n"
+			     "	BNZ  1b\n"
+			     "3:\n"
+			     "	SUB  %0,%3,%0\n"
+			     "4:\n"
+			     "	.section .fixup,\"ax\"\n"
+			     "5:\n"
+			     "	MOV  %0,%7\n"
+			     "	MOVT    D0FrT,#HI(4b)\n"
+			     "	JUMP    D0FrT,#LO(4b)\n"
+			     "	.previous\n"
+			     "	.section __ex_table,\"a\"\n"
+			     "	.long 2b,5b\n"
+			     "	.previous"
+			     : "=r" (res), "=r" (dst), "=r" (src), "=r" (count)
+			     : "3" (count), "1" (dst), "2" (src), "P" (-EFAULT)
+			     : "D0FrT", "memory", "cc");
+
+	return res;
+}
-- 
1.7.7.6


