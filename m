Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab2KHVsH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 16:48:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:19272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab2KHVsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 16:48:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,740,1344236400"; 
   d="scan'208";a="239204440"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: Linux Raid <linux-raid@vger.kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] lib/raid6: Add AVX2 optimized recovery functions
Date: Thu,  8 Nov 2012 13:47:44 -0800
Message-Id: <1352411264-5156-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize RAID6 recovery functions to take advantage of
the 256-bit YMM integer instructions introduced in AVX2.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 arch/x86/Makefile       |   5 +-
 include/linux/raid/pq.h |   1 +
 lib/raid6/Makefile      |   2 +-
 lib/raid6/algos.c       |   3 +
 lib/raid6/recov_avx2.c  | 327 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/raid6/test/Makefile |   2 +-
 lib/raid6/x86.h         |  14 ++-
 7 files changed, 345 insertions(+), 9 deletions(-)
 create mode 100644 lib/raid6/recov_avx2.c

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 682e9c2..f24c037 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -123,9 +123,10 @@ cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTI
 # does binutils support specific instructions?
 asinstr := $(call as-instr,fxsaveq (%rax),-DCONFIG_AS_FXSAVEQ=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
+avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 
-KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
-KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr)
+KBUILD_AFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr)
+KBUILD_CFLAGS += $(cfi) $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr)
 
 LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 640c69c..3156347 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -109,6 +109,7 @@ struct raid6_recov_calls {
 
 extern const struct raid6_recov_calls raid6_recov_intx1;
 extern const struct raid6_recov_calls raid6_recov_ssse3;
+extern const struct raid6_recov_calls raid6_recov_avx2;
 
 /* Algorithm list */
 extern const struct raid6_calls * const raid6_algos[];
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index de06dfe..8c2e22b 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
 
-raid6_pq-y	+= algos.o recov.o recov_ssse3.o tables.o int1.o int2.o int4.o \
+raid6_pq-y	+= algos.o recov.o recov_ssse3.o recov_avx2.o tables.o int1.o int2.o int4.o \
 		   int8.o int16.o int32.o altivec1.o altivec2.o altivec4.o \
 		   altivec8.o mmx.o sse1.o sse2.o
 hostprogs-y	+= mktables
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 589f5f5..8b7f55c 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -72,6 +72,9 @@ EXPORT_SYMBOL_GPL(raid6_datap_recov);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
 #if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
+#ifdef CONFIG_AS_AVX2
+	&raid6_recov_avx2,
+#endif
 	&raid6_recov_ssse3,
 #endif
 	&raid6_recov_intx1,
diff --git a/lib/raid6/recov_avx2.c b/lib/raid6/recov_avx2.c
new file mode 100644
index 0000000..43a9bab
--- /dev/null
+++ b/lib/raid6/recov_avx2.c
@@ -0,0 +1,327 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ * Author: Jim Kukunas <james.t.kukunas@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
+
+#if CONFIG_AS_AVX2
+
+#include <linux/raid/pq.h>
+#include "x86.h"
+
+static int raid6_has_avx2(void)
+{
+	return boot_cpu_has(X86_FEATURE_AVX2) &&
+		boot_cpu_has(X86_FEATURE_AVX);
+}
+
+static void raid6_2data_recov_avx2(int disks, size_t bytes, int faila,
+		int failb, void **ptrs)
+{
+	u8 *p, *q, *dp, *dq;
+	const u8 *pbmul;	/* P multiplier table for B data */
+	const u8 *qmul;		/* Q multiplier table (for both) */
+	const u8 x0f = 0x0f;
+
+	p = (u8 *)ptrs[disks-2];
+	q = (u8 *)ptrs[disks-1];
+
+	/* Compute syndrome with zero for the missing data pages
+	   Use the dead data pages as temporary storage for
+	   delta p and delta q */
+	dp = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks-2] = dp;
+	dq = (u8 *)ptrs[failb];
+	ptrs[failb] = (void *)raid6_empty_zero_page;
+	ptrs[disks-1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]   = dp;
+	ptrs[failb]   = dq;
+	ptrs[disks-2] = p;
+	ptrs[disks-1] = q;
+
+	/* Now, pick the proper data tables */
+	pbmul = raid6_vgfmul[raid6_gfexi[failb-faila]];
+	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
+		raid6_gfexp[failb]]];
+
+	kernel_fpu_begin();
+
+	/* ymm0 = x0f[16] */
+	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
+
+	while (bytes) {
+#ifdef CONFIG_X86_64
+		asm volatile("vmovdqa %0, %%ymm1" : : "m" (q[0]));
+		asm volatile("vmovdqa %0, %%ymm9" : : "m" (q[32]));
+		asm volatile("vmovdqa %0, %%ymm0" : : "m" (p[0]));
+		asm volatile("vmovdqa %0, %%ymm8" : : "m" (p[32]));
+		asm volatile("vpxor %0, %%ymm1, %%ymm1" : : "m" (dq[0]));
+		asm volatile("vpxor %0, %%ymm9, %%ymm9" : : "m" (dq[32]));
+		asm volatile("vpxor %0, %%ymm0, %%ymm0" : : "m" (dp[0]));
+		asm volatile("vpxor %0, %%ymm8, %%ymm8" : : "m" (dp[32]));
+
+		/*
+		 * 1 = dq[0]  ^ q[0]
+		 * 9 = dq[32] ^ q[32]
+		 * 0 = dp[0]  ^ p[0]
+		 * 8 = dp[32] ^ p[32]
+		 */
+
+		asm volatile("vbroadcasti128 %0, %%ymm4" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti128 %0, %%ymm5" : : "m" (qmul[16]));
+
+		asm volatile("vpsraw $4, %ymm1, %ymm3");
+		asm volatile("vpsraw $4, %ymm9, %ymm12");
+		asm volatile("vpand %ymm7, %ymm1, %ymm1");
+		asm volatile("vpand %ymm7, %ymm9, %ymm9");
+		asm volatile("vpand %ymm7, %ymm3, %ymm3");
+		asm volatile("vpand %ymm7, %ymm12, %ymm12");
+		asm volatile("vpshufb %ymm9, %ymm4, %ymm14");
+		asm volatile("vpshufb %ymm1, %ymm4, %ymm4");
+		asm volatile("vpshufb %ymm12, %ymm5, %ymm15");
+		asm volatile("vpshufb %ymm3, %ymm5, %ymm5");
+		asm volatile("vpxor %ymm14, %ymm15, %ymm15");
+		asm volatile("vpxor %ymm4, %ymm5, %ymm5");
+
+		/*
+		 * 5 = qx[0]
+		 * 15 = qx[32]
+		 */
+
+		asm volatile("vbroadcasti128 %0, %%ymm4" : : "m" (pbmul[0]));
+		asm volatile("vbroadcasti128 %0, %%ymm1" : : "m" (pbmul[16]));
+		asm volatile("vpsraw $4, %ymm0, %ymm2");
+		asm volatile("vpsraw $4, %ymm8, %ymm6");
+		asm volatile("vpand %ymm7, %ymm0, %ymm3");
+		asm volatile("vpand %ymm7, %ymm8, %ymm14");
+		asm volatile("vpand %ymm7, %ymm2, %ymm2");
+		asm volatile("vpand %ymm7, %ymm6, %ymm6");
+		asm volatile("vpshufb %ymm14, %ymm4, %ymm12");
+		asm volatile("vpshufb %ymm3, %ymm4, %ymm4");
+		asm volatile("vpshufb %ymm6, %ymm1, %ymm13");
+		asm volatile("vpshufb %ymm2, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm4, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm12, %ymm13, %ymm13");
+
+		/*
+		 * 1  = pbmul[px[0]]
+		 * 13 = pbmul[px[32]]
+		 */
+		asm volatile("vpxor %ymm5, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm15, %ymm13, %ymm13");
+
+		/*
+		 * 1 = db = DQ
+		 * 13 = db[32] = DQ[32]
+		 */
+		asm volatile("vmovdqa %%ymm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa %%ymm13,%0" : "=m" (dq[32]));
+		asm volatile("vpxor %ymm1, %ymm0, %ymm0");
+		asm volatile("vpxor %ymm13, %ymm8, %ymm8");
+
+		asm volatile("vmovdqa %%ymm0, %0" : "=m" (dp[0]));
+		asm volatile("vmovdqa %%ymm8, %0" : "=m" (dp[32]));
+
+		bytes -= 64;
+		p += 64;
+		q += 64;
+		dp += 64;
+		dq += 64;
+#else
+		asm volatile("vmovdqa %0, %%ymm1" : : "m" (*q));
+		asm volatile("vmovdqa %0, %%ymm0" : : "m" (*p));
+		asm volatile("vpxor %0, %%ymm1, %%ymm1" : : "m" (*dq));
+		asm volatile("vpxor %0, %%ymm0, %%ymm0" : : "m" (*dp));
+
+		/* 1 = dq ^ q;  0 = dp ^ p */
+
+		asm volatile("vbroadcasti128 %0, %%ymm4" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti128 %0, %%ymm5" : : "m" (qmul[16]));
+
+		/*
+		 * 1 = dq ^ q
+		 * 3 = dq ^ p >> 4
+		 */
+		asm volatile("vpsraw $4, %ymm1, %ymm3");
+		asm volatile("vpand %ymm7, %ymm1, %ymm1");
+		asm volatile("vpand %ymm7, %ymm3, %ymm3");
+		asm volatile("vpshufb %ymm1, %ymm4, %ymm4");
+		asm volatile("vpshufb %ymm3, %ymm5, %ymm5");
+		asm volatile("vpxor %ymm4, %ymm5, %ymm5");
+
+		/* 5 = qx */
+
+		asm volatile("vbroadcasti128 %0, %%ymm4" : : "m" (pbmul[0]));
+		asm volatile("vbroadcasti128 %0, %%ymm1" : : "m" (pbmul[16]));
+
+		asm volatile("vpsraw $4, %ymm0, %ymm2");
+		asm volatile("vpand %ymm7, %ymm0, %ymm3");
+		asm volatile("vpand %ymm7, %ymm2, %ymm2");
+		asm volatile("vpshufb %ymm3, %ymm4, %ymm4");
+		asm volatile("vpshufb %ymm2, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm4, %ymm1, %ymm1");
+
+		/* 1 = pbmul[px] */
+		asm volatile("vpxor %ymm5, %ymm1, %ymm1");
+		/* 1 = db = DQ */
+		asm volatile("vmovdqa %%ymm1, %0" : "=m" (dq[0]));
+
+		asm volatile("vpxor %ymm1, %ymm0, %ymm0");
+		asm volatile("vmovdqa %%ymm0, %0" : "=m" (dp[0]));
+
+		bytes -= 32;
+		p += 32;
+		q += 32;
+		dp += 32;
+		dq += 32;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+static void raid6_datap_recov_avx2(int disks, size_t bytes, int faila,
+		void **ptrs)
+{
+	u8 *p, *q, *dq;
+	const u8 *qmul;		/* Q multiplier table */
+	const u8 x0f = 0x0f;
+
+	p = (u8 *)ptrs[disks-2];
+	q = (u8 *)ptrs[disks-1];
+
+	/* Compute syndrome with zero for the missing data page
+	   Use the dead data page as temporary storage for delta q */
+	dq = (u8 *)ptrs[faila];
+	ptrs[faila] = (void *)raid6_empty_zero_page;
+	ptrs[disks-1] = dq;
+
+	raid6_call.gen_syndrome(disks, bytes, ptrs);
+
+	/* Restore pointer table */
+	ptrs[faila]   = dq;
+	ptrs[disks-1] = q;
+
+	/* Now, pick the proper data tables */
+	qmul  = raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
+
+	kernel_fpu_begin();
+
+	asm volatile("vpbroadcastb %0, %%ymm7" : : "m" (x0f));
+
+	while (bytes) {
+#ifdef CONFIG_X86_64
+		asm volatile("vmovdqa %0, %%ymm3" : : "m" (dq[0]));
+		asm volatile("vmovdqa %0, %%ymm8" : : "m" (dq[32]));
+		asm volatile("vpxor %0, %%ymm3, %%ymm3" : : "m" (q[0]));
+		asm volatile("vpxor %0, %%ymm8, %%ymm8" : : "m" (q[32]));
+
+		/*
+		 * 3 = q[0] ^ dq[0]
+		 * 8 = q[32] ^ dq[32]
+		 */
+		asm volatile("vbroadcasti128 %0, %%ymm0" : : "m" (qmul[0]));
+		asm volatile("vmovapd %ymm0, %ymm13");
+		asm volatile("vbroadcasti128 %0, %%ymm1" : : "m" (qmul[16]));
+		asm volatile("vmovapd %ymm1, %ymm14");
+
+		asm volatile("vpsraw $4, %ymm3, %ymm6");
+		asm volatile("vpsraw $4, %ymm8, %ymm12");
+		asm volatile("vpand %ymm7, %ymm3, %ymm3");
+		asm volatile("vpand %ymm7, %ymm8, %ymm8");
+		asm volatile("vpand %ymm7, %ymm6, %ymm6");
+		asm volatile("vpand %ymm7, %ymm12, %ymm12");
+		asm volatile("vpshufb %ymm3, %ymm0, %ymm0");
+		asm volatile("vpshufb %ymm8, %ymm13, %ymm13");
+		asm volatile("vpshufb %ymm6, %ymm1, %ymm1");
+		asm volatile("vpshufb %ymm12, %ymm14, %ymm14");
+		asm volatile("vpxor %ymm0, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm13, %ymm14, %ymm14");
+
+		/*
+		 * 1  = qmul[q[0]  ^ dq[0]]
+		 * 14 = qmul[q[32] ^ dq[32]]
+		 */
+		asm volatile("vmovdqa %0, %%ymm2" : : "m" (p[0]));
+		asm volatile("vmovdqa %0, %%ymm12" : : "m" (p[32]));
+		asm volatile("vpxor %ymm1, %ymm2, %ymm2");
+		asm volatile("vpxor %ymm14, %ymm12, %ymm12");
+
+		/*
+		 * 2  = p[0]  ^ qmul[q[0]  ^ dq[0]]
+		 * 12 = p[32] ^ qmul[q[32] ^ dq[32]]
+		 */
+
+		asm volatile("vmovdqa %%ymm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa %%ymm14, %0" : "=m" (dq[32]));
+		asm volatile("vmovdqa %%ymm2, %0" : "=m" (p[0]));
+		asm volatile("vmovdqa %%ymm12,%0" : "=m" (p[32]));
+
+		bytes -= 64;
+		p += 64;
+		q += 64;
+		dq += 64;
+#else
+		asm volatile("vmovdqa %0, %%ymm3" : : "m" (dq[0]));
+		asm volatile("vpxor %0, %%ymm3, %%ymm3" : : "m" (q[0]));
+
+		/* 3 = q ^ dq */
+
+		asm volatile("vbroadcasti128 %0, %%ymm0" : : "m" (qmul[0]));
+		asm volatile("vbroadcasti128 %0, %%ymm1" : : "m" (qmul[16]));
+
+		asm volatile("vpsraw $4, %ymm3, %ymm6");
+		asm volatile("vpand %ymm7, %ymm3, %ymm3");
+		asm volatile("vpand %ymm7, %ymm6, %ymm6");
+		asm volatile("vpshufb %ymm3, %ymm0, %ymm0");
+		asm volatile("vpshufb %ymm6, %ymm1, %ymm1");
+		asm volatile("vpxor %ymm0, %ymm1, %ymm1");
+
+		/* 1 = qmul[q ^ dq] */
+
+		asm volatile("vmovdqa %0, %%ymm2" : : "m" (p[0]));
+		asm volatile("vpxor %ymm1, %ymm2, %ymm2");
+
+		/* 2 = p ^ qmul[q ^ dq] */
+
+		asm volatile("vmovdqa %%ymm1, %0" : "=m" (dq[0]));
+		asm volatile("vmovdqa %%ymm2, %0" : "=m" (p[0]));
+
+		bytes -= 32;
+		p += 32;
+		q += 32;
+		dq += 32;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+const struct raid6_recov_calls raid6_recov_avx2 = {
+	.data2 = raid6_2data_recov_avx2,
+	.datap = raid6_datap_recov_avx2,
+	.valid = raid6_has_avx2,
+#ifdef CONFIG_X86_64
+	.name = "avx2x2",
+#else
+	.name = "avx2x1",
+#endif
+	.priority = 2,
+};
+
+#else
+#warning "your version of binutils lacks AVX2 support"
+#endif
+
+#endif
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index c76151d..d919c98 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -23,7 +23,7 @@ RANLIB	 = ranlib
 all:	raid6.a raid6test
 
 raid6.a: int1.o int2.o int4.o int8.o int16.o int32.o mmx.o sse1.o sse2.o \
-	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o recov_ssse3.o algos.o \
+	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o recov_ssse3.o recov_avx2.o algos.o \
 	 tables.o
 	 rm -f $@
 	 $(AR) cq $@ $^
diff --git a/lib/raid6/x86.h b/lib/raid6/x86.h
index d55d632..b759548 100644
--- a/lib/raid6/x86.h
+++ b/lib/raid6/x86.h
@@ -45,19 +45,23 @@ static inline void kernel_fpu_end(void)
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
 #define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
 #define X86_FEATURE_AVX	(4*32+28) /* Advanced Vector Extensions */
+#define X86_FEATURE_AVX2        (9*32+ 5) /* AVX2 instructions */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
 
 /* Should work well enough on modern CPUs for testing */
 static inline int boot_cpu_has(int flag)
 {
-	u32 eax = (flag & 0x20) ? 0x80000001 : 1;
-	u32 ecx, edx;
+	u32 eax, ebx, ecx, edx;
+
+	eax = (flag & 0x100) ? 7 :
+		(flag & 0x20) ? 0x80000001 : 1;
+	ecx = 0;
 
 	asm volatile("cpuid"
-		     : "+a" (eax), "=d" (edx), "=c" (ecx)
-		     : : "ebx");
+		     : "+a" (eax), "=b" (ebx), "=d" (edx), "+c" (ecx));
 
-	return ((flag & 0x80 ? ecx : edx) >> (flag & 31)) & 1;
+	return ((flag & 0x100 ? ebx :
+		(flag & 0x80) ? ecx : edx) >> (flag & 31)) & 1;
 }
 
 #endif /* ndef __KERNEL__ */
-- 
1.8.0

