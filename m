Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab2HXVQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:16:22 -0400
Received: from mga03.intel.com ([143.182.124.21]:19435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841Ab2HXVPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:15:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,304,1344236400"; 
   d="scan'208";a="190967396"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 4/6] x86, fpu: always use kernel_fpu_begin/end() for in-kernel FPU usage
Date: Fri, 24 Aug 2012 14:13:00 -0700
Message-Id: <1345842782-24175-5-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use kernel_fpu_begin/end() instead of unconditionally accessing cr0 and
saving/restoring just the few used xmm/ymm registers.

This has some advantages like:
* If the task's FPU state is already active, then kernel_fpu_begin()
  will just save the user-state and avoiding the read/write of cr0.
  In general, cr0 accesses are much slower.

* Manual save/restore of xmm/ymm registers will affect the 'modified' and
  the 'init' optimizations brought in the by xsaveopt/xrstor
  infrastructure.

* Foward compatibility with future vector register extensions will be a
  problem if the xmm/ymm registers are manually saved and restored
  (corrupting the extended state of those vector registers).

With this patch, there was no significant difference in the xor throughput
using AVX, measured during boot.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Jim Kukunas <james.t.kukunas@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>
---
 arch/x86/include/asm/xor_32.h  |   56 +++++-------------------------------
 arch/x86/include/asm/xor_64.h  |   61 ++++++----------------------------------
 arch/x86/include/asm/xor_avx.h |   54 ++++++++---------------------------
 3 files changed, 29 insertions(+), 142 deletions(-)

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
index b9b2323..5fc06d0 100644
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
@@ -143,11 +107,8 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
-
-	XMMS_SAVE;
 
+	kernel_fpu_begin();
 	asm volatile(
 #undef BLOCK
 #define BLOCK(i) \
@@ -194,7 +155,7 @@ xor_sse_3(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  [p1] "+r" (p1), [p2] "+r" (p2), [p3] "+r" (p3)
 	: [inc] "r" (256UL)
 	: "memory");
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -202,10 +163,8 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -261,7 +220,7 @@ xor_sse_4(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory" );
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static void
@@ -269,10 +228,8 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	  unsigned long *p3, unsigned long *p4, unsigned long *p5)
 {
 	unsigned int lines = bytes >> 8;
-	xmm_store_t xmm_save[4];
-	unsigned long cr0;
 
-	XMMS_SAVE;
+	kernel_fpu_begin();
 
 	asm volatile(
 #undef BLOCK
@@ -336,7 +293,7 @@ xor_sse_5(unsigned long bytes, unsigned long *p1, unsigned long *p2,
 	: [inc] "r" (256UL)
 	: "memory");
 
-	XMMS_RESTORE;
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_sse = {
diff --git a/arch/x86/include/asm/xor_avx.h b/arch/x86/include/asm/xor_avx.h
index 2510d35..7ea79c5 100644
--- a/arch/x86/include/asm/xor_avx.h
+++ b/arch/x86/include/asm/xor_avx.h
@@ -20,32 +20,6 @@
 #include <linux/compiler.h>
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
@@ -60,10 +34,9 @@ do { \
 
 static void xor_avx_2(unsigned long bytes, unsigned long *p0, unsigned long *p1)
 {
-	unsigned long cr0, lines = bytes >> 9;
-	char ymm_save[32 * YMM_SAVED_REGS] ALIGN32;
+	unsigned long lines = bytes >> 9;
 
-	YMMS_SAVE
+	kernel_fpu_begin();
 
 	while (lines--) {
 #undef BLOCK
@@ -82,16 +55,15 @@ do { \
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
@@ -113,16 +85,15 @@ do { \
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
@@ -147,16 +118,15 @@ do { \
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
@@ -184,7 +154,7 @@ do { \
 		p4 = (unsigned long *)((uintptr_t)p4 + 512);
 	}
 
-	YMMS_RESTORE
+	kernel_fpu_end();
 }
 
 static struct xor_block_template xor_block_avx = {
-- 
1.7.6.5

