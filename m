Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1IIBSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:18:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6446 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab1IIBK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:10:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6463"; a="116679173"
Message-Id: <20110909010915.544457671@codeaurora.org>
User-Agent: quilt/0.48-1
Date: Thu, 08 Sep 2011 20:08:56 -0500
From: Richard Kuo <rkuo@codeaurora.org>
To: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Linas Vepstas <linas@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [patch v3 09/36] Hexagon: Add checksum functions
References: <20110909010847.294039464@codeaurora.org>
Content-Disposition: inline; filename=checksum.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed most non-assembly functions and use the generic ones instead.

Made a few more minor changes to use the generic header file.

Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
Signed-off-by: Linas Vepstas <linas@codeaurora.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>

---
 arch/hexagon/include/asm/checksum.h   |   50 ++++++++
 arch/hexagon/include/asm/intrinsics.h |   26 ++++
 arch/hexagon/lib/checksum.c           |  203 ++++++++++++++++++++++++++++++++++
 3 files changed, 279 insertions(+)

Index: linux-hexagon-kernel/arch/hexagon/include/asm/checksum.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/checksum.h	2011-09-03 20:14:59.564980943 -0500
@@ -0,0 +1,50 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_CHECKSUM_H
+#define _ASM_CHECKSUM_H
+
+#define do_csum	do_csum
+unsigned int do_csum(const void *voidptr, int len);
+
+/*
+ * the same as csum_partial, but copies from src while it
+ * checksums
+ *
+ * here even more important to align src and dst on a 32-bit (or even
+ * better 64-bit) boundary
+ */
+#define csum_partial_copy_nocheck csum_partial_copy_nocheck
+__wsum csum_partial_copy_nocheck(const void *src, void *dst,
+					int len, __wsum sum);
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented
+ */
+#define csum_tcpudp_nofold csum_tcpudp_nofold
+__wsum csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr,
+	unsigned short len, unsigned short proto, __wsum sum);
+
+#define csum_tcpudp_magic csum_tcpudp_magic
+__sum16 csum_tcpudp_magic(unsigned long saddr, unsigned long daddr,
+	unsigned short len, unsigned short proto, __wsum sum);
+
+#include <asm-generic/checksum.h>
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/include/asm/intrinsics.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/include/asm/intrinsics.h	2011-09-03 20:14:59.574980971 -0500
@@ -0,0 +1,26 @@
+/*
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#ifndef _ASM_HEXAGON_INTRINSICS_H
+#define _ASM_HEXAGON_INTRINSICS_H
+
+#define HEXAGON_P_vrmpyhacc_PP	__builtin_HEXAGON_M2_vrmac_s0
+#define HEXAGON_P_vrmpyh_PP	__builtin_HEXAGON_M2_vrmpy_s0
+#define HEXAGON_R_cl0_R		__builtin_HEXAGON_S2_cl0
+
+#endif
Index: linux-hexagon-kernel/arch/hexagon/lib/checksum.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hexagon-kernel/arch/hexagon/lib/checksum.c	2011-09-03 20:14:59.574980971 -0500
@@ -0,0 +1,203 @@
+/*
+ * Checksum functions for Hexagon
+ *
+ * Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+/*  This was derived from arch/alpha/lib/checksum.c  */
+
+
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <asm/byteorder.h>
+#include <net/checksum.h>
+#include <linux/uaccess.h>
+#include <asm/intrinsics.h>
+
+
+/*  Vector value operations  */
+#define SIGN(x, y)	((0x8000ULL*x)<<y)
+#define CARRY(x, y)	((0x0002ULL*x)<<y)
+#define SELECT(x, y)	((0x0001ULL*x)<<y)
+
+#define VR_NEGATE(a, b, c, d)	(SIGN(a, 48) + SIGN(b, 32) + SIGN(c, 16) \
+	+ SIGN(d, 0))
+#define VR_CARRY(a, b, c, d)	(CARRY(a, 48) + CARRY(b, 32) + CARRY(c, 16) \
+	+ CARRY(d, 0))
+#define VR_SELECT(a, b, c, d)	(SELECT(a, 48) + SELECT(b, 32) + SELECT(c, 16) \
+	+ SELECT(d, 0))
+
+
+/* optimized HEXAGON V3 intrinsic version */
+static inline unsigned short from64to16(u64 x)
+{
+	u64 sum;
+
+	sum = HEXAGON_P_vrmpyh_PP(x^VR_NEGATE(1, 1, 1, 1),
+			     VR_SELECT(1, 1, 1, 1));
+	sum += VR_CARRY(0, 0, 1, 0);
+	sum = HEXAGON_P_vrmpyh_PP(sum, VR_SELECT(0, 0, 1, 1));
+
+	return 0xFFFF & sum;
+}
+
+/*
+ * computes the checksum of the TCP/UDP pseudo-header
+ * returns a 16-bit checksum, already complemented.
+ */
+__sum16 csum_tcpudp_magic(unsigned long saddr, unsigned long daddr,
+			  unsigned short len, unsigned short proto,
+			  __wsum sum)
+{
+	return (__force __sum16)~from64to16(
+		(__force u64)saddr + (__force u64)daddr +
+		(__force u64)sum + ((len + proto) << 8));
+}
+
+__wsum csum_tcpudp_nofold(unsigned long saddr, unsigned long daddr,
+			  unsigned short len, unsigned short proto,
+			  __wsum sum)
+{
+	u64 result;
+
+	result = (__force u64)saddr + (__force u64)daddr +
+		 (__force u64)sum + ((len + proto) << 8);
+
+	/* Fold down to 32-bits so we don't lose in the typedef-less
+	   network stack.  */
+	/* 64 to 33 */
+	result = (result & 0xffffffffUL) + (result >> 32);
+	/* 33 to 32 */
+	result = (result & 0xffffffffUL) + (result >> 32);
+	return (__force __wsum)result;
+}
+EXPORT_SYMBOL(csum_tcpudp_nofold);
+
+/*
+ * Do a 64-bit checksum on an arbitrary memory area..
+ *
+ * This isn't a great routine, but it's not _horrible_ either. The
+ * inner loop could be unrolled a bit further, and there are better
+ * ways to do the carry, but this is reasonable.
+ */
+
+/* optimized HEXAGON intrinsic version, with over read fixed */
+unsigned int do_csum(const void *voidptr, int len)
+{
+	u64 sum0, sum1, x0, x1, *ptr8_o, *ptr8_e, *ptr8;
+	int i, start, mid, end, mask;
+	const char *ptr = voidptr;
+	unsigned short *ptr2;
+	unsigned int *ptr4;
+
+	if (len <= 0)
+		return 0;
+
+	start = 0xF & (16-(((int) ptr) & 0xF)) ;
+	mask  = 0x7fffffffUL >> HEXAGON_R_cl0_R(len);
+	start = start & mask ;
+
+	mid = len - start;
+	end = mid & 0xF;
+	mid = mid>>4;
+	sum0 = mid << 18;
+	sum1 = 0;
+
+	if (start & 1)
+		sum0 += (u64) (ptr[0] << 8);
+	ptr2 = (unsigned short *) &ptr[start & 1];
+	if (start & 2)
+		sum1 += (u64) ptr2[0];
+	ptr4 = (unsigned int *) &ptr[start & 3];
+	if (start & 4) {
+		sum0 = HEXAGON_P_vrmpyhacc_PP(sum0,
+			VR_NEGATE(0, 0, 1, 1)^((u64)ptr4[0]),
+			VR_SELECT(0, 0, 1, 1));
+		sum0 += VR_SELECT(0, 0, 1, 0);
+	}
+	ptr8 = (u64 *) &ptr[start & 7];
+	if (start & 8) {
+		sum1 = HEXAGON_P_vrmpyhacc_PP(sum1,
+			VR_NEGATE(1, 1, 1, 1)^(ptr8[0]),
+			VR_SELECT(1, 1, 1, 1));
+		sum1 += VR_CARRY(0, 0, 1, 0);
+	}
+	ptr8_o = (u64 *) (ptr + start);
+	ptr8_e = (u64 *) (ptr + start + 8);
+
+	if (mid) {
+		x0 = *ptr8_e; ptr8_e += 2;
+		x1 = *ptr8_o; ptr8_o += 2;
+		if (mid > 1)
+			for (i = 0; i < mid-1; i++) {
+				sum0 = HEXAGON_P_vrmpyhacc_PP(sum0,
+					x0^VR_NEGATE(1, 1, 1, 1),
+					VR_SELECT(1, 1, 1, 1));
+				sum1 = HEXAGON_P_vrmpyhacc_PP(sum1,
+					x1^VR_NEGATE(1, 1, 1, 1),
+					VR_SELECT(1, 1, 1, 1));
+				x0 = *ptr8_e; ptr8_e += 2;
+				x1 = *ptr8_o; ptr8_o += 2;
+			}
+		sum0 = HEXAGON_P_vrmpyhacc_PP(sum0, x0^VR_NEGATE(1, 1, 1, 1),
+			VR_SELECT(1, 1, 1, 1));
+		sum1 = HEXAGON_P_vrmpyhacc_PP(sum1, x1^VR_NEGATE(1, 1, 1, 1),
+			VR_SELECT(1, 1, 1, 1));
+	}
+
+	ptr4 = (unsigned int *) &ptr[start + (mid * 16) + (end & 8)];
+	if (end & 4) {
+		sum1 = HEXAGON_P_vrmpyhacc_PP(sum1,
+			VR_NEGATE(0, 0, 1, 1)^((u64)ptr4[0]),
+			VR_SELECT(0, 0, 1, 1));
+		sum1 += VR_SELECT(0, 0, 1, 0);
+	}
+	ptr2 = (unsigned short *) &ptr[start + (mid * 16) + (end & 12)];
+	if (end & 2)
+		sum0 += (u64) ptr2[0];
+
+	if (end & 1)
+		sum1 += (u64) ptr[start + (mid * 16) + (end & 14)];
+
+	ptr8 = (u64 *) &ptr[start + (mid * 16)];
+	if (end & 8) {
+		sum0 = HEXAGON_P_vrmpyhacc_PP(sum0,
+			VR_NEGATE(1, 1, 1, 1)^(ptr8[0]),
+			VR_SELECT(1, 1, 1, 1));
+		sum0 += VR_CARRY(0, 0, 1, 0);
+	}
+	sum0 = HEXAGON_P_vrmpyh_PP((sum0+sum1)^VR_NEGATE(0, 0, 0, 1),
+		VR_SELECT(0, 0, 1, 1));
+	sum0 += VR_NEGATE(0, 0, 0, 1);
+	sum0 = HEXAGON_P_vrmpyh_PP(sum0, VR_SELECT(0, 0, 1, 1));
+
+	if (start & 1)
+		sum0 = (sum0 << 8) | (0xFF & (sum0 >> 8));
+
+	return 0xFFFF & sum0;
+}
+
+/*
+ * copy from ds while checksumming, otherwise like csum_partial
+ */
+__wsum
+csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
+{
+	memcpy(dst, src, len);
+	return csum_partial(dst, len, sum);
+}

--

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

