Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab2KGJs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 04:48:27 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:53854 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2KGJsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 04:48:23 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, arnd@arndb.de,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [RFC PATCH v1 07/31] ARC: checksum/byteorder/swab routines
Date: Wed,  7 Nov 2012 10:47:30 +0100
Message-Id: <1352281674-2186-8-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TBD: do_csum still needs to be written in asm

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/include/asm/byteorder.h |   18 +++++++
 arch/arc/include/asm/checksum.h  |  101 ++++++++++++++++++++++++++++++++++++++
 arch/arc/include/asm/swab.h      |   99 +++++++++++++++++++++++++++++++++++++
 3 files changed, 218 insertions(+), 0 deletions(-)
 create mode 100644 arch/arc/include/asm/byteorder.h
 create mode 100644 arch/arc/include/asm/checksum.h
 create mode 100644 arch/arc/include/asm/swab.h

diff --git a/arch/arc/include/asm/byteorder.h b/arch/arc/include/asm/byteorder.h
new file mode 100644
index 0000000..9da71d4
--- /dev/null
+++ b/arch/arc/include/asm/byteorder.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_ARC_BYTEORDER_H
+#define __ASM_ARC_BYTEORDER_H
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#include <linux/byteorder/big_endian.h>
+#else
+#include <linux/byteorder/little_endian.h>
+#endif
+
+#endif /* ASM_ARC_BYTEORDER_H */
diff --git a/arch/arc/include/asm/checksum.h b/arch/arc/include/asm/checksum.h
new file mode 100644
index 0000000..1095729
--- /dev/null
+++ b/arch/arc/include/asm/checksum.h
@@ -0,0 +1,101 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Joern Rennecke  <joern.rennecke@embecosm.com>: Jan 2012
+ *  -Insn Scheduling improvements to csum core routines.
+ *      = csum_fold( ) largely derived from ARM version.
+ *      = ip_fast_cum( ) to have module scheduling
+ *  -gcc 4.4.x broke networking. Alias analysis needed to be primed.
+ *   worked around by adding memory clobber to ip_fast_csum( )
+ *
+ * vineetg: May 2010
+ *  -Rewrote ip_fast_cscum( ) and csum_fold( ) with fast inline asm
+ */
+
+#ifndef _ASM_ARC_CHECKSUM_H
+#define _ASM_ARC_CHECKSUM_H
+
+/*
+ *	Fold a partial checksum
+ *
+ *  The 2 swords comprising the 32bit sum are added, any carry to 16th bit
+ *  added back and final sword result inverted.
+ */
+static inline __sum16 csum_fold(__wsum s)
+{
+	unsigned r = s << 16 | s >> 16;	/* ror */
+	s = ~s;
+	s -= r;
+	return s >> 16;
+}
+
+/*
+ *	This is a version of ip_compute_csum() optimized for IP headers,
+ *	which always checksum on 4 octet boundaries.
+ */
+static inline __sum16
+ip_fast_csum(const void *iph, unsigned int ihl)
+{
+	const void *ptr = iph;
+	unsigned int tmp, tmp2, sum;
+
+	__asm__(
+	"	ld.ab  %0, [%3, 4]		\n"
+	"	ld.ab  %2, [%3, 4]		\n"
+	"	sub    %1, %4, 2		\n"
+	"	lsr.f  lp_count, %1, 1		\n"
+	"	bcc    0f			\n"
+	"	add.f  %0, %0, %2		\n"
+	"	ld.ab  %2, [%3, 4]		\n"
+	"0:	lp     1f			\n"
+	"	ld.ab  %1, [%3, 4]		\n"
+	"	adc.f  %0, %0, %2		\n"
+	"	ld.ab  %2, [%3, 4]		\n"
+	"	adc.f  %0, %0, %1		\n"
+	"1:	adc.f  %0, %0, %2		\n"
+	"	add.cs %0,%0,1			\n"
+	: "=&r"(sum), "=r"(tmp), "=&r"(tmp2), "+&r" (ptr)
+	: "r"(ihl)
+	: "cc", "lp_count", "memory");
+
+	return csum_fold(sum);
+}
+
+/*
+ * TCP pseudo Header is 12 bytes:
+ * SA [4], DA [4], zeroes [1], Proto[1], TCP Seg(hdr+data) Len [2]
+ */
+static inline __wsum
+csum_tcpudp_nofold(__be32 saddr, __be32 daddr, unsigned short len,
+		   unsigned short proto, __wsum sum)
+{
+	__asm__ __volatile__(
+	"	add.f %0, %0, %1	\n"
+	"	adc.f %0, %0, %2	\n"
+	"	adc.f %0, %0, %3	\n"
+	"	adc.f %0, %0, %4	\n"
+	"	adc   %0, %0, 0		\n"
+	: "+&r"(sum)
+	: "r"(saddr), "r"(daddr),
+#ifdef CONFIG_CPU_BIG_ENDIAN
+	  "r"(len),
+#else
+	  "r"(len << 8),
+#endif
+	  "r"(htons(proto))
+	: "cc");
+
+	return sum;
+}
+
+#define csum_fold csum_fold
+#define ip_fast_csum ip_fast_csum
+#define csum_tcpudp_nofold csum_tcpudp_nofold
+
+#include <asm-generic/checksum.h>
+
+#endif /* _ASM_ARC_CHECKSUM_H */
diff --git a/arch/arc/include/asm/swab.h b/arch/arc/include/asm/swab.h
new file mode 100644
index 0000000..9f6dcbb
--- /dev/null
+++ b/arch/arc/include/asm/swab.h
@@ -0,0 +1,99 @@
+/*
+ * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * vineetg: May 2011
+ *  -Support single cycle endian-swap insn in ARC700 4.10
+ *
+ * vineetg: June 2009
+ *  -Better htonl implementation (5 instead of 9 ALU instructions)
+ *  -Hardware assisted single cycle bswap (Use Case of ARC custom instrn)
+ */
+
+#ifndef __ASM_ARC_SWAB_H
+#define __ASM_ARC_SWAB_H
+
+#include <linux/types.h>
+
+/* Native single cycle endian swap insn */
+#ifdef CONFIG_ARC_HAS_SWAPE
+
+#define __arch_swab32(x)		\
+({					\
+	unsigned int tmp = x;		\
+	__asm__(			\
+	"	swape	%0, %1	\n"	\
+	: "=r" (tmp)			\
+	: "r" (tmp));			\
+	tmp;				\
+})
+
+#else
+
+/* Several ways of Endian-Swap Emulation for ARC
+ * 0: kernel generic
+ * 1: ARC optimised "C"
+ * 2: ARC Custom instruction
+ */
+#define ARC_BSWAP_TYPE	1
+
+#if (ARC_BSWAP_TYPE == 1)		/******* Software only ********/
+
+/* The kernel default implementation of htonl is
+ *		return  x<<24 | x>>24 |
+ *		 (x & (__u32)0x0000ff00UL)<<8 | (x & (__u32)0x00ff0000UL)>>8;
+ *
+ * This generates 9 instructions on ARC (excluding the ld/st)
+ *
+ * 8051fd8c:	ld     r3,[r7,20]	; Mem op : Get the value to be swapped
+ * 8051fd98:	asl    r5,r3,24		; get  3rd Byte
+ * 8051fd9c:	lsr    r2,r3,24		; get  0th Byte
+ * 8051fda0:	and    r4,r3,0xff00
+ * 8051fda8:	asl    r4,r4,8		; get 1st Byte
+ * 8051fdac:	and    r3,r3,0x00ff0000
+ * 8051fdb4:	or     r2,r2,r5		; combine 0th and 3rd Bytes
+ * 8051fdb8:	lsr    r3,r3,8		; 2nd Byte at correct place in Dst Reg
+ * 8051fdbc:	or     r2,r2,r4		; combine 0,3 Bytes with 1st Byte
+ * 8051fdc0:	or     r2,r2,r3		; combine 0,3,1 Bytes with 2nd Byte
+ * 8051fdc4:	st     r2,[r1,20]	; Mem op : save result back to mem
+ *
+ * Joern suggested a better "C" algorithm which is great since
+ * (1) It is portable to any architecure
+ * (2) At the same time it takes advantage of ARC ISA (rotate intrns)
+ */
+
+#define __arch_swab32(x)					\
+({	unsigned long __in = (x), __tmp;			\
+	__tmp = __in << 8 | __in >> 24; /* ror tmp,in,24 */	\
+	__in = __in << 24 | __in >> 8; /* ror in,in,8 */	\
+	__tmp ^= __in;						\
+	__tmp &= 0xff00ff;					\
+	__tmp ^ __in;						\
+})
+
+#elif (ARC_BSWAP_TYPE == 2)	/* Custom single cycle bwap instruction */
+
+#define __arch_swab32(x)						\
+({									\
+	unsigned int tmp = x;						\
+	__asm__(							\
+	"	.extInstruction	bswap, 7, 0x00, SUFFIX_NONE, SYNTAX_2OP	\n"\
+	"	bswap  %0, %1						\n"\
+	: "=r" (tmp)							\
+	: "r" (tmp));							\
+	tmp;								\
+})
+
+#endif /* ARC_BSWAP_TYPE=zzz */
+
+#endif /* CONFIG_ARC_HAS_SWAPE */
+
+#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
+#define __BYTEORDER_HAS_U64__
+#define __SWAB_64_THRU_32__
+#endif
+
+#endif
-- 
1.7.4.1

