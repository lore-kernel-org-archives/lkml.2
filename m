Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab2D3Xuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:50:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:26950 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab2D3Xux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="138484151"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86: use kernel_fpu_[begin|end] for RAID5 checksumming
Date: Mon, 30 Apr 2012 16:51:15 -0700
Message-Id: <1335829875-18481-1-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the SSE and AVX xor functions manually save and restore the
[X|Y]MM registers. Instead, we should use kernel_fpu_[begin|end].

This patch sacrifices some throughput,~5-10% for AVX and ~2% for SSE, in
exchange for safety against future FPU corruption bugs.

Patch applies to md/for-next.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 arch/x86/include/asm/xor_32.h  |   56 +++++-------------------------------
 arch/x86/include/asm/xor_64.h  |   61 ++++++---------------------------------
 arch/x86/include/asm/xor_avx.h |   55 ++++++++----------------------------
 3 files changed, 30 insertions(+), 142 deletions(-)

diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index 4545708..aabd585 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -534,38 +534,6 @@ static struct xor_block_template xor_block_p5_mmx = {
  * Copyright (C) 1999 Zach Brown (with obvious credit due Ingo)
  */
 
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	cr0 = read_cr0();			\
-	clts();					\
-	asm volatile(				\
-		"movups %%xmm0,(%0)	;\n\t"	\
-		"movups %%xmm1,0x10(%0)	;\n\t"	\
-		"movups %%xmm2,0x20(%0)	;\n\t"	\
-		"movups %%xmm3,0x30(%0)	;\n\t"	\
-		:				\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%0),%%xmm0	;\n\t"	\
-		"movups 0x10(%0),%%xmm1	;\n\t"	\
-		"movups 0x20(%0),%%xmm2	;\n\t"	\
-		"movups 0x30(%0),%%xmm3	;\n\t"	\
-		:				\
-		: "r" (xmm_save)		\
-		: "memory");			\
-	write_cr0(cr0);				\
-	preempt_enable();			\
-} while (0)
-
-#define ALIGN16 __attribute__((aligned(16)))
-
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
 #define	PF0(x)		"	prefetchnta "PF_OFFS(x)"(%1)		;\n"
@@ -587,10 +555,8 @@ static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -633,7 +599,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 	:
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -641,10 +607,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -694,7 +658,7 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	:
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -702,10 +666,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -762,7 +724,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	:
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -770,10 +732,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned long lines = bytes >> 8;
-	char xmm_save[16*4] ALIGN16;
-	int cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	/* Make sure GCC forgets anything it knows about p4 or p5,
 	   such that it won't pass to the asm volatile below a
@@ -850,7 +810,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	   like assuming they have some legal value.  */
 	asm("" : "=r" (p4), "=r" (p5));
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_pIII_sse = {
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index b9b2323..715f904 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -34,41 +34,7 @@
  * no advantages to be gotten from x86-64 here anyways.
  */
 
-typedef struct {
-	unsigned long a, b;
-} __attribute__((aligned(16))) xmm_store_t;
-
-/* Doesn't use gcc to save the XMM registers, because there is no easy way to
-   tell it to do a clts before the register saving. */
-#define XMMS_SAVE				\
-do {						\
-	preempt_disable();			\
-	asm volatile(				\
-		"movq %%cr0,%0		;\n\t"	\
-		"clts			;\n\t"	\
-		"movups %%xmm0,(%1)	;\n\t"	\
-		"movups %%xmm1,0x10(%1)	;\n\t"	\
-		"movups %%xmm2,0x20(%1)	;\n\t"	\
-		"movups %%xmm3,0x30(%1)	;\n\t"	\
-		: "=&r" (cr0)			\
-		: "r" (xmm_save) 		\
-		: "memory");			\
-} while (0)
-
-#define XMMS_RESTORE				\
-do {						\
-	asm volatile(				\
-		"sfence			;\n\t"	\
-		"movups (%1),%%xmm0	;\n\t"	\
-		"movups 0x10(%1),%%xmm1	;\n\t"	\
-		"movups 0x20(%1),%%xmm2	;\n\t"	\
-		"movups 0x30(%1),%%xmm3	;\n\t"	\
-		"movq 	%0,%%cr0	;\n\t"	\
-		:				\
-		: "r" (cr0), "r" (xmm_save)	\
-		: "memory");			\
-	preempt_enable();			\
-} while (0)
+#include <asm/i387.h>
 
 #define OFFS(x)		"16*("#x")"
 #define PF_OFFS(x)	"256+16*("#x")"
@@ -91,10 +57,8 @@ static void
 xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 {
 	unsigned int lines = bytes >> 8;
-	unsigned long cr0;
-	xmm_store_t xmm_save[4];
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -135,7 +99,7 @@ xor_sse_2(unsigned long bytes, unsigned long *p1, unsigned long *p2)
 	: [inc] "r" (256UL)
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -143,10 +107,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -194,7 +156,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
 	: [inc] "r" (256UL)
 	: "memory");
-	XMMS_RESTORE;
+
+	kernel_fpu_end();
 }
 
 static void
@@ -202,10 +165,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -261,7 +222,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -269,10 +230,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -336,7 +295,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_sse = {
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 2510d35..8d2795a 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -17,35 +17,8 @@
 
 #ifdef CONFIG_AS_AVX
 
-#include <linux/compiler.h>
 #include <asm/i387.h>
 
-#define ALIGN32 __aligned(32)
-
-#define YMM_SAVED_REGS 4
-
-#define YMMS_SAVE \
-do { \
-	preempt_disable(); \
-	cr0 = read_cr0(); \
-	clts(); \
-	asm volatile("vmovaps %%ymm0, %0" : "=m" (ymm_save[0]) : : "memory"); \
-	asm volatile("vmovaps %%ymm1, %0" : "=m" (ymm_save[32]) : : "memory"); \
-	asm volatile("vmovaps %%ymm2, %0" : "=m" (ymm_save[64]) : : "memory"); \
-	asm volatile("vmovaps %%ymm3, %0" : "=m" (ymm_save[96]) : : "memory"); \
-} while (0);
-
-#define YMMS_RESTORE \
-do { \
-	asm volatile("sfence" : : : "memory"); \
-	asm volatile("vmovaps %0, %%ymm3" : : "m" (ymm_save[96])); \
-	asm volatile("vmovaps %0, %%ymm2" : : "m" (ymm_save[64])); \
-	asm volatile("vmovaps %0, %%ymm1" : : "m" (ymm_save[32])); \
-	asm volatile("vmovaps %0, %%ymm0" : : "m" (ymm_save[0])); \
-	write_cr0(cr0); \
-	preempt_enable(); \
-} while (0);
-
 #define BLOCK4(i) \
 		BLOCK(32 * i, 0) \
 		BLOCK(32 * (i + 1), 1) \
@@ -60,10 +33,9 @@ do { \
 
 static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned long *p1)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -82,16 +54,15 @@ do { \
 		p1 = (unsigned long *)((uintptr_t)p1 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_3(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -113,16 +84,15 @@ do { \
 		p2 = (unsigned long *)((uintptr_t)p2 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_4(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2, unsigned long *p3)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -147,16 +117,15 @@ do { \
 		p3 = (unsigned long *)((uintptr_t)p3 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static void xor_avx_5(unsigned long bytes, unsigned long *p0, unsigned long *p1,
 	unsigned long *p2, unsigned long *p3, unsigned long *p4)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -184,7 +153,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_avx = {
-- 
1.7.8.6

