Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab0JAHGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:32 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:54800 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101Ab0JAHG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:28 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 10/18] powerpc: Support endian agnostic MMIO
Date: Fri,  1 Oct 2010 17:06:03 +1000
Message-Id: <1285916771-18033-11-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This patch maps the MMIO functions for 32bit PowerPC to their
appropriate instructions depending on CPU endianness.

The macros used to create the corresponding inline functions are also
renamed by this patch. Previously they had BE or LE in their names which
was misleading - they had nothing to do with endianness, but actually
created different instruction forms so their new names reflect the
instruction form they are creating (D-Form and X-Form).

Little endian 64bit PowerPC is not supported, so the lack of mappings
(and corresponding breakage) for that case is intentional to bring the
attention of anyone doing a 64bit little endian port. 64bit big endian
is unaffected.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/include/asm/io.h |   51 ++++++++++++++++++++++++++--------------
 1 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/io.h b/arch/powerpc/include/asm/io.h
index 001f2f1..fd8e922 100644
--- a/arch/powerpc/include/asm/io.h
+++ b/arch/powerpc/include/asm/io.h
@@ -97,7 +97,7 @@ extern resource_size_t isa_mem_base;
 
 /* gcc 4.0 and older doesn't have 'Z' constraint */
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ == 0)
-#define DEF_MMIO_IN_LE(name, size, insn)				\
+#define DEF_MMIO_IN_X(name, size, insn)				\
 static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
 	u##size ret;							\
@@ -106,7 +106,7 @@ static inline u##size name(const volatile u##size __iomem *addr)	\
 	return ret;							\
 }
 
-#define DEF_MMIO_OUT_LE(name, size, insn) 				\
+#define DEF_MMIO_OUT_X(name, size, insn) 				\
 static inline void name(volatile u##size __iomem *addr, u##size val)	\
 {									\
 	__asm__ __volatile__("sync;"#insn" %1,0,%2"			\
@@ -114,7 +114,7 @@ static inline void name(volatile u##size __iomem *addr, u##size val)	\
 	IO_SET_SYNC_FLAG();						\
 }
 #else /* newer gcc */
-#define DEF_MMIO_IN_LE(name, size, insn)				\
+#define DEF_MMIO_IN_X(name, size, insn)				\
 static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
 	u##size ret;							\
@@ -123,7 +123,7 @@ static inline u##size name(const volatile u##size __iomem *addr)	\
 	return ret;							\
 }
 
-#define DEF_MMIO_OUT_LE(name, size, insn) 				\
+#define DEF_MMIO_OUT_X(name, size, insn) 				\
 static inline void name(volatile u##size __iomem *addr, u##size val)	\
 {									\
 	__asm__ __volatile__("sync;"#insn" %1,%y0"			\
@@ -132,7 +132,7 @@ static inline void name(volatile u##size __iomem *addr, u##size val)	\
 }
 #endif
 
-#define DEF_MMIO_IN_BE(name, size, insn)				\
+#define DEF_MMIO_IN_D(name, size, insn)				\
 static inline u##size name(const volatile u##size __iomem *addr)	\
 {									\
 	u##size ret;							\
@@ -141,7 +141,7 @@ static inline u##size name(const volatile u##size __iomem *addr)	\
 	return ret;							\
 }
 
-#define DEF_MMIO_OUT_BE(name, size, insn)				\
+#define DEF_MMIO_OUT_D(name, size, insn)				\
 static inline void name(volatile u##size __iomem *addr, u##size val)	\
 {									\
 	__asm__ __volatile__("sync;"#insn"%U0%X0 %1,%0"			\
@@ -149,22 +149,37 @@ static inline void name(volatile u##size __iomem *addr, u##size val)	\
 	IO_SET_SYNC_FLAG();						\
 }
 
+DEF_MMIO_IN_D(in_8,     8, lbz);
+DEF_MMIO_OUT_D(out_8,   8, stb);
 
-DEF_MMIO_IN_BE(in_8,     8, lbz);
-DEF_MMIO_IN_BE(in_be16, 16, lhz);
-DEF_MMIO_IN_BE(in_be32, 32, lwz);
-DEF_MMIO_IN_LE(in_le16, 16, lhbrx);
-DEF_MMIO_IN_LE(in_le32, 32, lwbrx);
+#ifdef __BIG_ENDIAN__
+DEF_MMIO_IN_D(in_be16, 16, lhz);
+DEF_MMIO_IN_D(in_be32, 32, lwz);
+DEF_MMIO_IN_X(in_le16, 16, lhbrx);
+DEF_MMIO_IN_X(in_le32, 32, lwbrx);
 
-DEF_MMIO_OUT_BE(out_8,     8, stb);
-DEF_MMIO_OUT_BE(out_be16, 16, sth);
-DEF_MMIO_OUT_BE(out_be32, 32, stw);
-DEF_MMIO_OUT_LE(out_le16, 16, sthbrx);
-DEF_MMIO_OUT_LE(out_le32, 32, stwbrx);
+DEF_MMIO_OUT_D(out_be16, 16, sth);
+DEF_MMIO_OUT_D(out_be32, 32, stw);
+DEF_MMIO_OUT_X(out_le16, 16, sthbrx);
+DEF_MMIO_OUT_X(out_le32, 32, stwbrx);
+#else
+DEF_MMIO_IN_X(in_be16, 16, lhbrx);
+DEF_MMIO_IN_X(in_be32, 32, lwbrx);
+DEF_MMIO_IN_D(in_le16, 16, lhz);
+DEF_MMIO_IN_D(in_le32, 32, lwz);
+
+DEF_MMIO_OUT_X(out_be16, 16, sthbrx);
+DEF_MMIO_OUT_X(out_be32, 32, stwbrx);
+DEF_MMIO_OUT_D(out_le16, 16, sth);
+DEF_MMIO_OUT_D(out_le32, 32, stw);
+#endif /* __BIG_ENDIAN */
 
 #ifdef __powerpc64__
-DEF_MMIO_OUT_BE(out_be64, 64, std);
-DEF_MMIO_IN_BE(in_be64, 64, ld);
+
+#ifndef __LITTLE_ENDIAN__
+DEF_MMIO_OUT_D(out_be64, 64, std);
+DEF_MMIO_IN_D(in_be64, 64, ld);
+#endif
 
 /* There is no asm instructions for 64 bits reverse loads and stores */
 static inline u64 in_le64(const volatile u64 __iomem *addr)
-- 
1.7.1

