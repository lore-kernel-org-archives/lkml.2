Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026Ab2DKTlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:41:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:24742 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932997Ab2DKTko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131319269"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, hpa@zytor.com
Subject: [PATCH 2/4] lib/raid6: Add SSSE3 optimized recovery functions
Date: Wed, 11 Apr 2012 12:40:29 -0700
Message-Id: <1334173231-28595-3-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <1334173231-28595-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SSSE3 optimized recovery functions, as well as a system
for selecting the most appropriate recovery functions to use.

Originally-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 include/linux/raid/pq.h |   18 +++-
 lib/raid6/Makefile      |    2 +-
 lib/raid6/algos.c       |   37 +++++
 lib/raid6/mktables.c    |   25 ++++
 lib/raid6/recov.c       |   15 ++-
 lib/raid6/recov_ssse3.c |  336 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 426 insertions(+), 7 deletions(-)
 create mode 100644 lib/raid6/recov_ssse3.c

diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
index 53272e9..640c69c 100644
--- a/include/linux/raid/pq.h
+++ b/include/linux/raid/pq.h
@@ -99,8 +99,20 @@ extern const struct raid6_calls raid6_altivec2;
 extern const struct raid6_calls raid6_altivec4;
 extern const struct raid6_calls raid6_altivec8;
 
+struct raid6_recov_calls {
+	void (*data2)(int, size_t, int, int, void **);
+	void (*datap)(int, size_t, int, void **);
+	int  (*valid)(void);
+	const char *name;
+	int priority;
+};
+
+extern const struct raid6_recov_calls raid6_recov_intx1;
+extern const struct raid6_recov_calls raid6_recov_ssse3;
+
 /* Algorithm list */
 extern const struct raid6_calls * const raid6_algos[];
+extern const struct raid6_recov_calls *const raid6_recov_algos[];
 int raid6_select_algo(void);
 
 /* Return values from chk_syndrome */
@@ -111,14 +123,16 @@ int raid6_select_algo(void);
 
 /* Galois field tables */
 extern const u8 raid6_gfmul[256][256] __attribute__((aligned(256)));
+extern const u8 raid6_vgfmul[256][32] __attribute__((aligned(256)));
 extern const u8 raid6_gfexp[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfinv[256]      __attribute__((aligned(256)));
 extern const u8 raid6_gfexi[256]      __attribute__((aligned(256)));
 
 /* Recovery routines */
-void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
+extern void (*raid6_2data_recov)(int disks, size_t bytes, int faila, int failb,
 		       void **ptrs);
-void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs);
+extern void (*raid6_datap_recov)(int disks, size_t bytes, int faila,
+			void **ptrs);
 void raid6_dual_recov(int disks, size_t bytes, int faila, int failb,
 		      void **ptrs);
 
diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
index 8a38102..de06dfe 100644
--- a/lib/raid6/Makefile
+++ b/lib/raid6/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_RAID6_PQ)	+= raid6_pq.o
 
-raid6_pq-y	+= algos.o recov.o tables.o int1.o int2.o int4.o \
+raid6_pq-y	+= algos.o recov.o recov_ssse3.o tables.o int1.o int2.o int4.o \
 		   int8.o int16.o int32.o altivec1.o altivec2.o altivec4.o \
 		   altivec8.o mmx.o sse1.o sse2.o
 hostprogs-y	+= mktables
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index f6a0f78..5a7f802 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -64,6 +64,20 @@ const struct raid6_calls * const raid6_algos[] = {
 	NULL
 };
 
+void (*raid6_2data_recov)(int, size_t, int, int, void **);
+EXPORT_SYMBOL_GPL(raid6_2data_recov);
+
+void (*raid6_datap_recov)(int, size_t, int, void **);
+EXPORT_SYMBOL_GPL(raid6_datap_recov);
+
+const struct raid6_recov_calls *const raid6_recov_algos[] = {
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
+	&raid6_recov_ssse3,
+#endif
+	&raid6_recov_intx1,
+	NULL
+};
+
 #ifdef __KERNEL__
 #define RAID6_TIME_JIFFIES_LG2	4
 #else
@@ -72,6 +86,26 @@ const struct raid6_calls * const raid6_algos[] = {
 #define time_before(x, y) ((x) < (y))
 #endif
 
+static inline void raid6_choose_recov(void)
+{
+	const struct raid6_recov_calls *const *algo;
+	const struct raid6_recov_calls *best;
+
+	for (best = NULL, algo = raid6_recov_algos; *algo; algo++)
+		if (!best || (*algo)->priority > best->priority)
+			if (!(*algo)->valid || (*algo)->valid())
+				best = *algo;
+
+	if (best) {
+		raid6_2data_recov = best->data2;
+		raid6_datap_recov = best->datap;
+
+		printk("raid6: using %s recovery algorithm\n", best->name);
+	} else
+		printk("raid6: Yikes! No recovery algorithm found!\n");
+}
+
+
 /* Try to pick the best algorithm */
 /* This code uses the gfmul table as convenient data set to abuse */
 
@@ -141,6 +175,9 @@ int __init raid6_select_algo(void)
 
 	free_pages((unsigned long)syndromes, 1);
 
+	/* select raid recover functions */
+	raid6_choose_recov();
+
 	return best ? 0 : -EINVAL;
 }
 
diff --git a/lib/raid6/mktables.c b/lib/raid6/mktables.c
index 8a37809..39787db 100644
--- a/lib/raid6/mktables.c
+++ b/lib/raid6/mktables.c
@@ -81,6 +81,31 @@ int main(int argc, char *argv[])
 	printf("EXPORT_SYMBOL(raid6_gfmul);\n");
 	printf("#endif\n");
 
+	/* Compute vector multiplication table */
+	printf("\nconst u8  __attribute__((aligned(256)))\n"
+		"raid6_vgfmul[256][32] =\n"
+		"{\n");
+	for (i = 0; i < 256; i++) {
+		printf("\t{\n");
+		for (j = 0; j < 16; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x,%c", gfmul(i, j + k),
+				       (k == 7) ? '\n' : ' ');
+		}
+		for (j = 0; j < 16; j += 8) {
+			printf("\t\t");
+			for (k = 0; k < 8; k++)
+				printf("0x%02x,%c", gfmul(i, (j + k) << 4),
+				       (k == 7) ? '\n' : ' ');
+		}
+		printf("\t},\n");
+	}
+	printf("};\n");
+	printf("#ifdef __KERNEL__\n");
+	printf("EXPORT_SYMBOL(raid6_vgfmul);\n");
+	printf("#endif\n");
+
 	/* Compute power-of-2 table (exponent) */
 	v = 1;
 	printf("\nconst u8 __attribute__((aligned(256)))\n"
diff --git a/lib/raid6/recov.c b/lib/raid6/recov.c
index fe275d7..1805a5c 100644
--- a/lib/raid6/recov.c
+++ b/lib/raid6/recov.c
@@ -22,7 +22,7 @@
 #include <linux/raid/pq.h>
 
 /* Recover two failed data blocks. */
-void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
+void raid6_2data_recov_intx1(int disks, size_t bytes, int faila, int failb,
 		       void **ptrs)
 {
 	u8 *p, *q, *dp, *dq;
@@ -64,10 +64,9 @@ void raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 		p++; q++;
 	}
 }
-EXPORT_SYMBOL_GPL(raid6_2data_recov);
 
 /* Recover failure of one data block plus the P block */
-void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs)
+void raid6_datap_recov_intx1(int disks, size_t bytes, int faila, void **ptrs)
 {
 	u8 *p, *q, *dq;
 	const u8 *qmul;		/* Q multiplier table */
@@ -96,7 +95,15 @@ void raid6_datap_recov(int disks, size_t bytes, int faila, void **ptrs)
 		q++; dq++;
 	}
 }
-EXPORT_SYMBOL_GPL(raid6_datap_recov);
+
+
+const struct raid6_recov_calls raid6_recov_intx1 = {
+	.data2 = raid6_2data_recov_intx1,
+	.datap = raid6_datap_recov_intx1,
+	.valid = NULL,
+	.name = "intx1",
+	.priority = 0,
+};
 
 #ifndef __KERNEL__
 /* Testing only */
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
new file mode 100644
index 0000000..43eb383
--- /dev/null
+++ b/lib/raid6/recov_ssse3.c
@@ -0,0 +1,336 @@
+/*
+ * Copyright (C) 2012 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#if (defined(__i386__) || defined(__x86_64__)) && !defined(__arch_um__)
+
+#include <linux/raid/pq.h>
+#include "x86.h"
+
+static int raid6_has_ssse3(void)
+{
+	return boot_cpu_has(X86_FEATURE_XMM) &&
+		boot_cpu_has(X86_FEATURE_XMM2) &&
+		boot_cpu_has(X86_FEATURE_SSSE3);
+}
+
+void raid6_2data_recov_ssse3(int disks, size_t bytes, int faila, int failb,
+		       void **ptrs)
+{
+	u8 *p, *q, *dp, *dq;
+	const u8 *pbmul;	/* P multiplier table for B data */
+	const u8 *qmul;		/* Q multiplier table (for both) */
+	static const u8 __attribute__((aligned(16))) x0f[16] = {
+		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f};
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
+	asm volatile("movdqa %0,%%xmm7" : : "m" (x0f[0]));
+
+#ifdef CONFIG_X86_64
+	asm volatile("movdqa %0,%%xmm6" : : "m" (qmul[0]));
+	asm volatile("movdqa %0,%%xmm14" : : "m" (pbmul[0]));
+	asm volatile("movdqa %0,%%xmm15" : : "m" (pbmul[16]));
+#endif
+
+	/* Now do it... */
+	while (bytes) {
+#ifdef CONFIG_X86_64
+	/* xmm6, xmm14, xmm15 */
+
+		asm volatile("movdqa %0,%%xmm1" : : "m" (q[0]));
+		asm volatile("movdqa %0,%%xmm9" : : "m" (q[16]));
+		asm volatile("movdqa %0,%%xmm0" : : "m" (p[0]));
+		asm volatile("movdqa %0,%%xmm8" : : "m" (p[16]));
+		asm volatile("pxor   %0,%%xmm1" : : "m" (dq[0]));
+		asm volatile("pxor   %0,%%xmm9" : : "m" (dq[16]));
+		asm volatile("pxor   %0,%%xmm0" : : "m" (dp[0]));
+		asm volatile("pxor   %0,%%xmm8" : : "m" (dp[16]));
+
+		/* xmm0/8 = px */
+
+		asm volatile("movdqa %xmm6,%xmm4");
+		asm volatile("movdqa %0,%%xmm5" : : "m" (qmul[16]));
+		asm volatile("movdqa %xmm6,%xmm12");
+		asm volatile("movdqa %xmm5,%xmm13");
+		asm volatile("movdqa %xmm1,%xmm3");
+		asm volatile("movdqa %xmm9,%xmm11");
+		asm volatile("movdqa %xmm0,%xmm2"); /* xmm2/10 = px */
+		asm volatile("movdqa %xmm8,%xmm10");
+		asm volatile("psraw  $4,%xmm1");
+		asm volatile("psraw  $4,%xmm9");
+		asm volatile("pand   %xmm7,%xmm3");
+		asm volatile("pand   %xmm7,%xmm11");
+		asm volatile("pand   %xmm7,%xmm1");
+		asm volatile("pand   %xmm7,%xmm9");
+		asm volatile("pshufb %xmm3,%xmm4");
+		asm volatile("pshufb %xmm11,%xmm12");
+		asm volatile("pshufb %xmm1,%xmm5");
+		asm volatile("pshufb %xmm9,%xmm13");
+		asm volatile("pxor   %xmm4,%xmm5");
+		asm volatile("pxor   %xmm12,%xmm13");
+
+		/* xmm5/13 = qx */
+
+		asm volatile("movdqa %xmm14,%xmm4");
+		asm volatile("movdqa %xmm15,%xmm1");
+		asm volatile("movdqa %xmm14,%xmm12");
+		asm volatile("movdqa %xmm15,%xmm9");
+		asm volatile("movdqa %xmm2,%xmm3");
+		asm volatile("movdqa %xmm10,%xmm11");
+		asm volatile("psraw  $4,%xmm2");
+		asm volatile("psraw  $4,%xmm10");
+		asm volatile("pand   %xmm7,%xmm3");
+		asm volatile("pand   %xmm7,%xmm11");
+		asm volatile("pand   %xmm7,%xmm2");
+		asm volatile("pand   %xmm7,%xmm10");
+		asm volatile("pshufb %xmm3,%xmm4");
+		asm volatile("pshufb %xmm11,%xmm12");
+		asm volatile("pshufb %xmm2,%xmm1");
+		asm volatile("pshufb %xmm10,%xmm9");
+		asm volatile("pxor   %xmm4,%xmm1");
+		asm volatile("pxor   %xmm12,%xmm9");
+
+		/* xmm1/9 = pbmul[px] */
+		asm volatile("pxor   %xmm5,%xmm1");
+		asm volatile("pxor   %xmm13,%xmm9");
+		/* xmm1/9 = db = DQ */
+		asm volatile("movdqa %%xmm1,%0" : "=m" (dq[0]));
+		asm volatile("movdqa %%xmm9,%0" : "=m" (dq[16]));
+
+		asm volatile("pxor   %xmm1,%xmm0");
+		asm volatile("pxor   %xmm9,%xmm8");
+		asm volatile("movdqa %%xmm0,%0" : "=m" (dp[0]));
+		asm volatile("movdqa %%xmm8,%0" : "=m" (dp[16]));
+
+		bytes -= 32;
+		p += 32;
+		q += 32;
+		dp += 32;
+		dq += 32;
+#else
+		asm volatile("movdqa %0,%%xmm1" : : "m" (*q));
+		asm volatile("movdqa %0,%%xmm0" : : "m" (*p));
+		asm volatile("pxor   %0,%%xmm1" : : "m" (*dq));
+		asm volatile("pxor   %0,%%xmm0" : : "m" (*dp));
+
+		/* 1 = dq ^ q
+		 * 0 = dp ^ p
+		 */
+		asm volatile("movdqa %0,%%xmm4" : : "m" (qmul[0]));
+		asm volatile("movdqa %0,%%xmm5" : : "m" (qmul[16]));
+
+		asm volatile("movdqa %xmm1,%xmm3");
+		asm volatile("psraw  $4,%xmm1");
+		asm volatile("pand   %xmm7,%xmm3");
+		asm volatile("pand   %xmm7,%xmm1");
+		asm volatile("pshufb %xmm3,%xmm4");
+		asm volatile("pshufb %xmm1,%xmm5");
+		asm volatile("pxor   %xmm4,%xmm5");
+
+		asm volatile("movdqa %xmm0,%xmm2"); /* xmm2 = px */
+
+		/* xmm5 = qx */
+
+		asm volatile("movdqa %0,%%xmm4" : : "m" (pbmul[0]));
+		asm volatile("movdqa %0,%%xmm1" : : "m" (pbmul[16]));
+		asm volatile("movdqa %xmm2,%xmm3");
+		asm volatile("psraw  $4,%xmm2");
+		asm volatile("pand   %xmm7,%xmm3");
+		asm volatile("pand   %xmm7,%xmm2");
+		asm volatile("pshufb %xmm3,%xmm4");
+		asm volatile("pshufb %xmm2,%xmm1");
+		asm volatile("pxor   %xmm4,%xmm1");
+
+		/* xmm1 = pbmul[px] */
+		asm volatile("pxor   %xmm5,%xmm1");
+		/* xmm1 = db = DQ */
+		asm volatile("movdqa %%xmm1,%0" : "=m" (*dq));
+
+		asm volatile("pxor   %xmm1,%xmm0");
+		asm volatile("movdqa %%xmm0,%0" : "=m" (*dp));
+
+		bytes -= 16;
+		p += 16;
+		q += 16;
+		dp += 16;
+		dq += 16;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+
+void raid6_datap_recov_ssse3(int disks, size_t bytes, int faila, void **ptrs)
+{
+	u8 *p, *q, *dq;
+	const u8 *qmul;		/* Q multiplier table */
+	static const u8 __attribute__((aligned(16))) x0f[16] = {
+		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
+		 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f};
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
+	asm volatile("movdqa %0, %%xmm7" : : "m" (x0f[0]));
+
+	while (bytes) {
+#ifdef CONFIG_X86_64
+		asm volatile("movdqa %0, %%xmm3" : : "m" (dq[0]));
+		asm volatile("movdqa %0, %%xmm4" : : "m" (dq[16]));
+		asm volatile("pxor %0, %%xmm3" : : "m" (q[0]));
+		asm volatile("movdqa %0, %%xmm0" : : "m" (qmul[0]));
+
+		/* xmm3 = q[0] ^ dq[0] */
+
+		asm volatile("pxor %0, %%xmm4" : : "m" (q[16]));
+		asm volatile("movdqa %0, %%xmm1" : : "m" (qmul[16]));
+
+		/* xmm4 = q[16] ^ dq[16] */
+
+		asm volatile("movdqa %xmm3, %xmm6");
+		asm volatile("movdqa %xmm4, %xmm8");
+
+		/* xmm4 = xmm8 = q[16] ^ dq[16] */
+
+		asm volatile("psraw $4, %xmm3");
+		asm volatile("pand %xmm7, %xmm6");
+		asm volatile("pand %xmm7, %xmm3");
+		asm volatile("pshufb %xmm6, %xmm0");
+		asm volatile("pshufb %xmm3, %xmm1");
+		asm volatile("movdqa %0, %%xmm10" : : "m" (qmul[0]));
+		asm volatile("pxor %xmm0, %xmm1");
+		asm volatile("movdqa %0, %%xmm11" : : "m" (qmul[16]));
+
+		/* xmm1 = qmul[q[0] ^ dq[0]] */
+
+		asm volatile("psraw $4, %xmm4");
+		asm volatile("pand %xmm7, %xmm8");
+		asm volatile("pand %xmm7, %xmm4");
+		asm volatile("pshufb %xmm8, %xmm10");
+		asm volatile("pshufb %xmm4, %xmm11");
+		asm volatile("movdqa %0, %%xmm2" : : "m" (p[0]));
+		asm volatile("pxor %xmm10, %xmm11");
+		asm volatile("movdqa %0, %%xmm12" : : "m" (p[16]));
+
+		/* xmm11 = qmul[q[16] ^ dq[16]] */
+
+		asm volatile("pxor %xmm1, %xmm2");
+
+		/* xmm2 = p[0] ^ qmul[q[0] ^ dq[0]] */
+
+		asm volatile("pxor %xmm11, %xmm12");
+
+		/* xmm12 = p[16] ^ qmul[q[16] ^ dq[16]] */
+
+		asm volatile("movdqa %%xmm1, %0" : "=m" (dq[0]));
+		asm volatile("movdqa %%xmm11, %0" : "=m" (dq[16]));
+
+		asm volatile("movdqa %%xmm2, %0" : "=m" (p[0]));
+		asm volatile("movdqa %%xmm12, %0" : "=m" (p[16]));
+
+		bytes -= 32;
+		p += 32;
+		q += 32;
+		dq += 32;
+
+#else
+		asm volatile("movdqa %0, %%xmm3" : : "m" (dq[0]));
+		asm volatile("movdqa %0, %%xmm0" : : "m" (qmul[0]));
+		asm volatile("pxor %0, %%xmm3" : : "m" (q[0]));
+		asm volatile("movdqa %0, %%xmm1" : : "m" (qmul[16]));
+
+		/* xmm3 = *q ^ *dq */
+
+		asm volatile("movdqa %xmm3, %xmm6");
+		asm volatile("movdqa %0, %%xmm2" : : "m" (p[0]));
+		asm volatile("psraw $4, %xmm3");
+		asm volatile("pand %xmm7, %xmm6");
+		asm volatile("pand %xmm7, %xmm3");
+		asm volatile("pshufb %xmm6, %xmm0");
+		asm volatile("pshufb %xmm3, %xmm1");
+		asm volatile("pxor %xmm0, %xmm1");
+
+		/* xmm1 = qmul[*q ^ *dq */
+
+		asm volatile("pxor %xmm1, %xmm2");
+
+		/* xmm2 = *p ^ qmul[*q ^ *dq] */
+
+		asm volatile("movdqa %%xmm1, %0" : "=m" (dq[0]));
+		asm volatile("movdqa %%xmm2, %0" : "=m" (p[0]));
+
+		bytes -= 16;
+		p += 16;
+		q += 16;
+		dq += 16;
+#endif
+	}
+
+	kernel_fpu_end();
+}
+
+const struct raid6_recov_calls raid6_recov_ssse3 = {
+	.data2 = raid6_2data_recov_ssse3,
+	.datap = raid6_datap_recov_ssse3,
+	.valid = raid6_has_ssse3,
+#ifdef CONFIG_X86_64
+	.name = "ssse3x2",
+#else
+	.name = "ssse3x1",
+#endif
+	.priority = 1,
+};
+
+#endif
+
-- 
1.7.8.5

