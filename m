Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab2DRW6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:58:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:7546 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab2DRW62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:58:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="134127952"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: neilb@suse.de
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: [PATCH] raid5: add AVX optimized RAID5 checksumming
Date: Wed, 18 Apr 2012 15:58:48 -0700
Message-Id: <1334789928-7238-2-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334789928-7238-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize RAID5 xor checksumming by taking advantage of
256-bit YMM registers introduced in AVX.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 arch/x86/Makefile              |    5 +-
 arch/x86/include/asm/xor_32.h  |    6 +-
 arch/x86/include/asm/xor_64.h  |    8 ++-
 arch/x86/include/asm/xor_avx.h |  215 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 230 insertions(+), 4 deletions(-)
 create mode 100644 arch/x86/include/asm/xor_avx.h

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba12..803c76d 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -99,9 +99,10 @@ cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTI
 
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
+avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index 133b40a..4545708 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -861,6 +861,9 @@ static struct xor_block_template xor_block_pIII_sse = {
 	.do_5 = xor_sse_5,
 };
 
+/* Also try the AVX routines */
+#include "xor_avx.h"
+
 /* Also try the generic routines.  */
 #include <asm-generic/xor.h>
 
@@ -871,6 +874,7 @@ do {							\
 	xor_speed(&xor_block_8regs_p);			\
 	xor_speed(&xor_block_32regs);			\
 	xor_speed(&xor_block_32regs_p);			\
+	AVX_XOR_SPEED;					\
 	if (cpu_has_xmm)				\
 		xor_speed(&xor_block_pIII_sse);		\
 	if (cpu_has_mmx) {				\
@@ -883,6 +887,6 @@ do {							\
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
 #define XOR_SELECT_TEMPLATE(FASTEST)			\
-	(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
+	AVX_SELECT(cpu_has_xmm ? &xor_block_pIII_sse : FASTEST)
 
 #endif /* _ASM_X86_XOR_32_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 1549b5e..b9b2323 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -347,15 +347,21 @@ static struct xor_block_template xor_block_sse = {
 	.do_5 = xor_sse_5,
 };
 
+
+/* Also try the AVX routines */
+#include "xor_avx.h"
+
 #undef XOR_TRY_TEMPLATES
 #define XOR_TRY_TEMPLATES			\
 do {						\
+	AVX_XOR_SPEED;				\
 	xor_speed(&xor_block_sse);		\
 } while (0)
 
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
-#define XOR_SELECT_TEMPLATE(FASTEST) (&xor_block_sse)
+#define XOR_SELECT_TEMPLATE(FASTEST) \
+	AVX_SELECT(&xor_block_sse)
 
 #endif /* _ASM_X86_XOR_64_H */
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
new file mode 100644
index 0000000..a2c9aa5
--- /dev/null
+++ b/arch/x86/include/asm/xor_avx.h
@@ -0,0 +1,215 @@
+#ifndef _ASM_X86_XOR_AVX_H
+#define _ASM_X86_XOR_AVX_H
+
+/*
+ * Optimized RAID-5 checksumming functions for AVX
+ *
+ * Copyright (C) 2012 Intel Corporation
+ * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
+ *
+ * Based on Ingo Molnar and Zach Brown's respective MMX and SSE routines
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#ifdef CONFIG_AS_AVX
+
+#include <linux/compiler.h>
+#include <asm/i387.h>
+
+#define ALIGN32 __aligned(32)
+
+#define YMM_SAVED_REGS 4
+
+#define YMMS_SAVE \
+do { \
+	preempt_disable(); \
+	cr0 = read_cr0(); \
+	clts(); \
+	asm volatile("vmovaps %%ymm0, %0" : "=m" (ymm_save[0]) : : "memory"); \
+	asm volatile("vmovaps %%ymm1, %0" : "=m" (ymm_save[32]) : : "memory"); \
+	asm volatile("vmovaps %%ymm2, %0" : "=m" (ymm_save[64]) : : "memory"); \
+	asm volatile("vmovaps %%ymm3, %0" : "=m" (ymm_save[96]) : : "memory"); \
+} while (0);
+
+#define YMMS_RESTORE \
+do { \
+	asm volatile("sfence" : : : "memory"); \
+	asm volatile("vmovaps %0, %%ymm3" : : "m" (ymm_save[96])); \
+	asm volatile("vmovaps %0, %%ymm2" : : "m" (ymm_save[64])); \
+	asm volatile("vmovaps %0, %%ymm1" : : "m" (ymm_save[32])); \
+	asm volatile("vmovaps %0, %%ymm0" : : "m" (ymm_save[0])); \
+	write_cr0(cr0); \
+	preempt_enable(); \
+} while (0);
+
+#define BLOCK4(i) \
+		BLOCK(32 * i, 0) \
+		BLOCK(32 * (i + 1), 1) \
+		BLOCK(32 * (i + 2), 2) \
+		BLOCK(32 * (i + 3), 3)
+
+#define BLOCK16() \
+		BLOCK4(0) \
+		BLOCK4(4) \
+		BLOCK4(8) \
+		BLOCK4(12)
+
+static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned long *p1)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+do { \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm"  #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
+		"=m" (p0[i / sizeof(*p0)])); \
+} while (0);
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_3(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+do { \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
+		"=m" (p0[i / sizeof(*p0)])); \
+} while (0);
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_4(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2, unsigned long *p3)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+do { \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p3[i / sizeof(*p3)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
+		"=m" (p0[i / sizeof(*p0)])); \
+} while (0);
+
+		BLOCK16();
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+		p3 = (unsigned long *)((uintptr_t)p3 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static void xor_avx_5(unsigned long bytes, unsigned long *p0, unsigned long *p1,
+	unsigned long *p2, unsigned long *p3, unsigned long *p4)
+{
+	unsigned long cr0, lines = bytes >> 9;
+	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+
+	YMMS_SAVE
+
+	while (lines--) {
+#undef BLOCK
+#define BLOCK(i, reg) \
+do { \
+	asm volatile("vmovdqa %0, %%ymm" #reg : : "m" (p4[i / sizeof(*p4)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p3[i / sizeof(*p3)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p2[i / sizeof(*p2)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p1[i / sizeof(*p1)])); \
+	asm volatile("vxorps %0, %%ymm" #reg ", %%ymm" #reg : : \
+		"m" (p0[i / sizeof(*p0)])); \
+	asm volatile("vmovdqa %%ymm" #reg ", %0" : \
+		"=m" (p0[i / sizeof(*p0)])); \
+} while (0);
+
+		BLOCK16()
+
+		p0 = (unsigned long *)((uintptr_t)p0 + 512);
+		p1 = (unsigned long *)((uintptr_t)p1 + 512);
+		p2 = (unsigned long *)((uintptr_t)p2 + 512);
+		p3 = (unsigned long *)((uintptr_t)p3 + 512);
+		p4 = (unsigned long *)((uintptr_t)p4 + 512);
+	}
+
+	YMMS_RESTORE
+}
+
+static struct xor_block_template xor_block_avx = {
+	.name = "avx",
+	.do_2 = xor_avx_2,
+	.do_3 = xor_avx_3,
+	.do_4 = xor_avx_4,
+	.do_5 = xor_avx_5,
+};
+
+#define AVX_XOR_SPEED \
+do { \
+	if (cpu_has_avx) \
+		xor_speed(&xor_block_avx); \
+} while (0)
+
+#define AVX_SELECT(FASTEST) \
+	(cpu_has_avx ? &xor_block_avx : FASTEST)
+
+#else
+
+#define AVX_XOR_SPEED {}
+
+#define AVX_SELECT(FASTEST) (FASTEST)
+
+#endif
+#endif
+
-- 
1.7.8.5

