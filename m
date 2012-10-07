Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab2JGCno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:43:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47373 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab2JGCni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:43:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 42/49] tools/power turbostat: print more turbo-limit information
Date: Sat,  6 Oct 2012 22:43:12 -0400
Message-Id: <6574a5d5053cd3b8e7c088900b80a9ff51895450.1349554106.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <1349577799-566-1-git-send-email-lenb@kernel.org>
References: <1349577799-566-1-git-send-email-lenb@kernel.org>
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
References: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The "turbo-limit" is the maximum opportunistic processor
speed, assuming no electrical or thermal constraints.
For a given processor, the turbo-limit varies, depending
on the number of active cores.  Generally, there is more
opportunity when fewer cores are active.

Under the "-v" verbose option, turbostat would
print the turbo-limits for the four cases
of 1 to 4 cores active.

Expand that capability to cover the cases of turbo
opportunities with up to 16 cores active.

Note that not all hardware platforms supply this information,
and that sometimes a valid limit may be specified for
a core which is not actually present.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 95 ++++++++++++++++++++++++++++++++++-
 1 file changed, 93 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 3c9dc54..5db4add 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -37,6 +37,7 @@
 
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
 #define MSR_NEHALEM_TURBO_RATIO_LIMIT	0x1AD
+#define MSR_IVT_TURBO_RATIO_LIMIT	0x1AE
 #define MSR_APERF	0xE8
 #define MSR_MPERF	0xE7
 #define MSR_PKG_C2_RESIDENCY	0x60D	/* SNB only */
@@ -61,6 +62,7 @@ unsigned int genuine_intel;
 unsigned int has_invariant_tsc;
 unsigned int do_nehalem_platform_info;
 unsigned int do_nehalem_turbo_ratio_limit;
+unsigned int do_ivt_turbo_ratio_limit;
 unsigned int extra_msr_offset;
 double bclk;
 unsigned int show_pkg;
@@ -676,6 +678,9 @@ void print_verbose_header(void)
 
 	get_msr(0, MSR_NEHALEM_PLATFORM_INFO, &msr);
 
+	if (verbose > 1)
+		fprintf(stderr, "MSR_NEHALEM_PLATFORM_INFO: 0x%llx\n", msr);
+
 	ratio = (msr >> 40) & 0xFF;
 	fprintf(stderr, "%d * %.0f = %.0f MHz max efficiency\n",
 		ratio, bclk, ratio * bclk);
@@ -684,14 +689,84 @@ void print_verbose_header(void)
 	fprintf(stderr, "%d * %.0f = %.0f MHz TSC frequency\n",
 		ratio, bclk, ratio * bclk);
 
+	if (!do_ivt_turbo_ratio_limit)
+		goto print_nhm_turbo_ratio_limits;
+
+	get_msr(0, MSR_IVT_TURBO_RATIO_LIMIT, &msr);
+
 	if (verbose > 1)
-		fprintf(stderr, "MSR_NEHALEM_PLATFORM_INFO: 0x%llx\n", msr);
+		fprintf(stderr, "MSR_IVT_TURBO_RATIO_LIMIT: 0x%llx\n", msr);
+
+	ratio = (msr >> 56) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 16 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 48) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 15 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 40) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 14 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 32) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 13 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 24) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 12 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 16) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 11 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 8) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 10 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 0) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 9 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+print_nhm_turbo_ratio_limits:
 
 	if (!do_nehalem_turbo_ratio_limit)
 		return;
 
 	get_msr(0, MSR_NEHALEM_TURBO_RATIO_LIMIT, &msr);
 
+	if (verbose > 1)
+		fprintf(stderr, "MSR_NEHALEM_TURBO_RATIO_LIMIT: 0x%llx\n", msr);
+
+	ratio = (msr >> 56) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 8 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 48) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 7 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 40) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 6 active cores\n",
+			ratio, bclk, ratio * bclk);
+
+	ratio = (msr >> 32) & 0xFF;
+	if (ratio)
+		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 5 active cores\n",
+			ratio, bclk, ratio * bclk);
+
 	ratio = (msr >> 24) & 0xFF;
 	if (ratio)
 		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 4 active cores\n",
@@ -711,7 +786,6 @@ void print_verbose_header(void)
 	if (ratio)
 		fprintf(stderr, "%d * %.0f = %.0f MHz max turbo 1 active cores\n",
 			ratio, bclk, ratio * bclk);
-
 }
 
 void free_all_buffers(void)
@@ -1045,6 +1119,22 @@ int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
 		return 0;
 	}
 }
+int has_ivt_turbo_ratio_limit(unsigned int family, unsigned int model)
+{
+	if (!genuine_intel)
+		return 0;
+
+	if (family != 6)
+		return 0;
+
+	switch (model) {
+	case 0x3E:	/* IVB Xeon */
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 
 int is_snb(unsigned int family, unsigned int model)
 {
@@ -1144,6 +1234,7 @@ void check_cpuid()
 	bclk = discover_bclk(family, model);
 
 	do_nehalem_turbo_ratio_limit = has_nehalem_turbo_ratio_limit(family, model);
+	do_ivt_turbo_ratio_limit = has_ivt_turbo_ratio_limit(family, model);
 }
 
 
-- 
1.8.0.rc0.18.gf84667d

