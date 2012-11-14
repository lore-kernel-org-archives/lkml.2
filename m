Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab2KNUnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:43:41 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:46838 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab2KNUnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:43:35 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 3/7] tools/power/x86/turbostat: use kernel MSR #defines
Date: Wed, 14 Nov 2012 15:43:20 -0500
Message-Id: <38fbc0a1ee900bbdc18fba2d7cfbc4e9b5d51ce8.1352925508.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352925804-6746-1-git-send-email-lenb@kernel.org>
References: <1352925804-6746-1-git-send-email-lenb@kernel.org>
In-Reply-To: <39300ffb9b6666714c60735cf854e1280e4e75f4.1352925508.git.len.brown@intel.com>
References: <39300ffb9b6666714c60735cf854e1280e4e75f4.1352925508.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Now that turbostat is built in the kernel tree,
it can share MSR #defines with the kernel.

Signed-off-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
---
 arch/x86/include/asm/msr-index.h      | 12 ++++++++++++
 tools/power/x86/turbostat/Makefile    |  1 +
 tools/power/x86/turbostat/turbostat.c | 26 +++++++-------------------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 7f0edce..c9775a3 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -35,6 +35,7 @@
 #define MSR_IA32_PERFCTR0		0x000000c1
 #define MSR_IA32_PERFCTR1		0x000000c2
 #define MSR_FSB_FREQ			0x000000cd
+#define MSR_NHM_PLATFORM_INFO		0x000000ce
 
 #define MSR_NHM_SNB_PKG_CST_CFG_CTL	0x000000e2
 #define NHM_C3_AUTO_DEMOTE		(1UL << 25)
@@ -55,6 +56,8 @@
 
 #define MSR_OFFCORE_RSP_0		0x000001a6
 #define MSR_OFFCORE_RSP_1		0x000001a7
+#define MSR_NHM_TURBO_RATIO_LIMIT	0x000001ad
+#define MSR_IVT_TURBO_RATIO_LIMIT	0x000001ae
 
 #define MSR_LBR_SELECT			0x000001c8
 #define MSR_LBR_TOS			0x000001c9
@@ -103,6 +106,15 @@
 #define MSR_IA32_MC0_ADDR		0x00000402
 #define MSR_IA32_MC0_MISC		0x00000403
 
+/* C-state Residency Counters */
+#define MSR_PKG_C3_RESIDENCY		0x000003f8
+#define MSR_PKG_C6_RESIDENCY		0x000003f9
+#define MSR_PKG_C7_RESIDENCY		0x000003fa
+#define MSR_CORE_C3_RESIDENCY		0x000003fc
+#define MSR_CORE_C6_RESIDENCY		0x000003fd
+#define MSR_CORE_C7_RESIDENCY		0x000003fe
+#define MSR_PKG_C2_RESIDENCY		0x0000060d
+
 #define MSR_AMD64_MC0_MASK		0xc0010044
 
 #define MSR_IA32_MCx_CTL(x)		(MSR_IA32_MC0_CTL + 4*(x))
diff --git a/tools/power/x86/turbostat/Makefile b/tools/power/x86/turbostat/Makefile
index f856495..51880e8 100644
--- a/tools/power/x86/turbostat/Makefile
+++ b/tools/power/x86/turbostat/Makefile
@@ -1,5 +1,6 @@
 turbostat : turbostat.c
 CFLAGS +=	-Wall
+CFLAGS +=	-I../../../../arch/x86/include/
 
 clean :
 	rm -f turbostat
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ea095ab..3c063a0 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -20,6 +20,7 @@
  */
 
 #define _GNU_SOURCE
+#include <asm/msr.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
@@ -35,19 +36,6 @@
 #include <ctype.h>
 #include <sched.h>
 
-#define MSR_NEHALEM_PLATFORM_INFO	0xCE
-#define MSR_NEHALEM_TURBO_RATIO_LIMIT	0x1AD
-#define MSR_IVT_TURBO_RATIO_LIMIT	0x1AE
-#define MSR_APERF	0xE8
-#define MSR_MPERF	0xE7
-#define MSR_PKG_C2_RESIDENCY	0x60D	/* SNB only */
-#define MSR_PKG_C3_RESIDENCY	0x3F8
-#define MSR_PKG_C6_RESIDENCY	0x3F9
-#define MSR_PKG_C7_RESIDENCY	0x3FA	/* SNB only */
-#define MSR_CORE_C3_RESIDENCY	0x3FC
-#define MSR_CORE_C6_RESIDENCY	0x3FD
-#define MSR_CORE_C7_RESIDENCY	0x3FE	/* SNB only */
-
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
 unsigned int verbose;		/* set with -v */
@@ -674,9 +662,9 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 	t->tsc = rdtsc();	/* we are running on local CPU of interest */
 
 	if (has_aperf) {
-		if (get_msr(cpu, MSR_APERF, &t->aperf))
+		if (get_msr(cpu, MSR_IA32_APERF, &t->aperf))
 			return -3;
-		if (get_msr(cpu, MSR_MPERF, &t->mperf))
+		if (get_msr(cpu, MSR_IA32_MPERF, &t->mperf))
 			return -4;
 	}
 
@@ -742,10 +730,10 @@ void print_verbose_header(void)
 	if (!do_nehalem_platform_info)
 		return;
 
-	get_msr(0, MSR_NEHALEM_PLATFORM_INFO, &msr);
+	get_msr(0, MSR_NHM_PLATFORM_INFO, &msr);
 
 	if (verbose > 1)
-		fprintf(stderr, "MSR_NEHALEM_PLATFORM_INFO: 0x%llx\n", msr);
+		fprintf(stderr, "MSR_NHM_PLATFORM_INFO: 0x%llx\n", msr);
 
 	ratio = (msr >> 40) & 0xFF;
 	fprintf(stderr, "%d * %.0f = %.0f MHz max efficiency\n",
@@ -808,10 +796,10 @@ print_nhm_turbo_ratio_limits:
 	if (!do_nehalem_turbo_ratio_limit)
 		return;
 
-	get_msr(0, MSR_NEHALEM_TURBO_RATIO_LIMIT, &msr);
+	get_msr(0, MSR_NHM_TURBO_RATIO_LIMIT, &msr);
 
 	if (verbose > 1)
-		fprintf(stderr, "MSR_NEHALEM_TURBO_RATIO_LIMIT: 0x%llx\n", msr);
+		fprintf(stderr, "MSR_NHM_TURBO_RATIO_LIMIT: 0x%llx\n", msr);
 
 	ratio = (msr >> 56) & 0xFF;
 	if (ratio)
-- 
1.8.0

