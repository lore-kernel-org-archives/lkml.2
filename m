Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965999Ab2DLUGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:06:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:38274 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934651Ab2DLUFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="131781381"
From: Jim Kukunas <james.t.kukunas@linux.intel.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH 3/4] lib/raid6: update test program for recovery functions
Date: Thu, 12 Apr 2012 13:04:32 -0700
Message-Id: <1334261073-14781-4-git-send-email-james.t.kukunas@linux.intel.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
References: <20120412161805.133c4ad0@notabene.brown>
 <1334261073-14781-1-git-send-email-james.t.kukunas@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test each combination of recovery and syndrome generation
functions.

Signed-off-by: Jim Kukunas <james.t.kukunas@linux.intel.com>
---
 lib/raid6/test/Makefile |    2 +-
 lib/raid6/test/test.c   |   32 +++++++++++++++++++++-----------
 lib/raid6/x86.h         |   15 ++++++++++-----
 3 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index aa65169..c76151d 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -23,7 +23,7 @@ RANLIB	 = ranlib
 all:	raid6.a raid6test
 
 raid6.a: int1.o int2.o int4.o int8.o int16.o int32.o mmx.o sse1.o sse2.o \
-	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o algos.o \
+	 altivec1.o altivec2.o altivec4.o altivec8.o recov.o recov_ssse3.o algos.o \
 	 tables.o
 	 rm -f $@
 	 $(AR) cq $@ $^
diff --git a/lib/raid6/test/test.c b/lib/raid6/test/test.c
index 7a93031..5a485b7 100644
--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -90,25 +90,35 @@ static int test_disks(int i, int j)
 int main(int argc, char *argv[])
 {
 	const struct raid6_calls *const *algo;
+	const struct raid6_recov_calls *const *ra;
 	int i, j;
 	int err = 0;
 
 	makedata();
 
-	for (algo = raid6_algos; *algo; algo++) {
-		if (!(*algo)->valid || (*algo)->valid()) {
-			raid6_call = **algo;
+	for (ra = raid6_recov_algos; *ra; ra++) {
+		if ((*ra)->valid  && !(*ra)->valid())
+			continue;
+		raid6_2data_recov = (*ra)->data2;
+		raid6_datap_recov = (*ra)->datap;
 
-			/* Nuke syndromes */
-			memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+		printf("using recovery %s\n", (*ra)->name);
 
-			/* Generate assumed good syndrome */
-			raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
-						(void **)&dataptrs);
+		for (algo = raid6_algos; *algo; algo++) {
+			if (!(*algo)->valid || (*algo)->valid()) {
+				raid6_call = **algo;
 
-			for (i = 0; i < NDISKS-1; i++)
-				for (j = i+1; j < NDISKS; j++)
-					err += test_disks(i, j);
+				/* Nuke syndromes */
+				memset(data[NDISKS-2], 0xee, 2*PAGE_SIZE);
+
+				/* Generate assumed good syndrome */
+				raid6_call.gen_syndrome(NDISKS, PAGE_SIZE,
+							(void **)&dataptrs);
+
+				for (i = 0; i < NDISKS-1; i++)
+					for (j = i+1; j < NDISKS; j++)
+						err += test_disks(i, j);
+			}
 		}
 		printf("\n");
 	}
diff --git a/lib/raid6/x86.h b/lib/raid6/x86.h
index cb2a8c9..d55d632 100644
--- a/lib/raid6/x86.h
+++ b/lib/raid6/x86.h
@@ -35,24 +35,29 @@ static inline void kernel_fpu_end(void)
 {
 }
 
+#define __aligned(x) __attribute__((aligned(x)))
+
 #define X86_FEATURE_MMX		(0*32+23) /* Multimedia Extensions */
 #define X86_FEATURE_FXSR	(0*32+24) /* FXSAVE and FXRSTOR instructions
 					   * (fast save and restore) */
 #define X86_FEATURE_XMM		(0*32+25) /* Streaming SIMD Extensions */
 #define X86_FEATURE_XMM2	(0*32+26) /* Streaming SIMD Extensions-2 */
+#define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
+#define X86_FEATURE_SSSE3	(4*32+ 9) /* Supplemental SSE-3 */
+#define X86_FEATURE_AVX	(4*32+28) /* Advanced Vector Extensions */
 #define X86_FEATURE_MMXEXT	(1*32+22) /* AMD MMX extensions */
 
 /* Should work well enough on modern CPUs for testing */
 static inline int boot_cpu_has(int flag)
 {
-	u32 eax = (flag >> 5) ? 0x80000001 : 1;
-	u32 edx;
+	u32 eax = (flag & 0x20) ? 0x80000001 : 1;
+	u32 ecx, edx;
 
 	asm volatile("cpuid"
-		     : "+a" (eax), "=d" (edx)
-		     : : "ecx", "ebx");
+		     : "+a" (eax), "=d" (edx), "=c" (ecx)
+		     : : "ebx");
 
-	return (edx >> (flag & 31)) & 1;
+	return ((flag & 0x80 ? ecx : edx) >> (flag & 31)) & 1;
 }
 
 #endif /* ndef __KERNEL__ */
-- 
1.7.8.5

