Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2FFSdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:33:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:49522 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634Ab2FFSc6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:32:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175618633"
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] turbostat: Add SMI count to turbostat
Date: Wed,  6 Jun 2012 11:32:50 -0700
Message-Id: <1339007570-32505-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When debugging timing related problems it's often useful to know
the SMI count. Newer Intel CPUs have a MSR to read it. Since turbostat
already has all the required infrastructure for polling MSRs I just
added it there (even though it's strictly not power related)
The counter is printed by default.

Unfortunately since it's a model specific counter needs a model
list number. I added Nehalems and Westmeres for it, and reused
the existing Sandy Bridge model list. This will need to be later
extended for each new CPU.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/power/x86/turbostat/turbostat.c |   44 ++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ab2f682..6fa80b4 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -36,6 +36,7 @@
 #include <sched.h>
 
 #define MSR_TSC	0x10
+#define MSR_SMI_COUNT 0x34
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
 #define MSR_NEHALEM_TURBO_RATIO_LIMIT	0x1AD
 #define MSR_APERF	0xE8
@@ -67,6 +68,7 @@ double bclk;
 unsigned int show_pkg;
 unsigned int show_core;
 unsigned int show_cpu;
+unsigned int do_smi_count;
 
 int aperf_mperf_unstable;
 int backwards_count;
@@ -89,6 +91,7 @@ struct counters {
 	unsigned long long pc6;	/* per package */
 	unsigned long long pc7;	/* per package */
 	unsigned long long extra_msr;	/* per thread */
+	unsigned long long smi_count;	/* per thread */
 	int pkg;
 	int core;
 	int cpu;
@@ -192,6 +195,8 @@ void print_header(void)
 		fprintf(stderr, "   %%pc7");
 	if (extra_msr_offset)
 		fprintf(stderr, "        MSR 0x%x ", extra_msr_offset);
+	if (do_smi_count)
+		fprintf(stderr, "   SMIs");
 
 	putc('\n', stderr);
 }
@@ -213,6 +218,7 @@ void dump_cnt(struct counters *cnt)
 	if (cnt->pc6) fprintf(stderr, "pc6: %016llX\n", cnt->pc6);
 	if (cnt->pc7) fprintf(stderr, "pc7: %016llX\n", cnt->pc7);
 	if (cnt->extra_msr) fprintf(stderr, "msr0x%x: %016llX\n", extra_msr_offset, cnt->extra_msr);
+	if (cnt->smi_count) fprintf(stderr, "smi: %llu\n", cnt->smi_count);
 }
 
 void dump_list(struct counters *cnt)
@@ -312,6 +318,8 @@ void print_cnt(struct counters *p)
 		fprintf(stderr, " %6.2f", 100.0 * p->pc7/p->tsc);
 	if (extra_msr_offset)
 		fprintf(stderr, "  0x%016llx", p->extra_msr);
+	if (do_smi_count)
+		fprintf(stderr, "  %5llu", p->smi_count);
 	putc('\n', stderr);
 }
 
@@ -450,6 +458,13 @@ int compute_delta(struct counters *after,
 		 * for "extra msr", just copy the latest w/o subtracting
 		 */
 		delta->extra_msr = after->extra_msr;
+
+		if (SUBTRACT_COUNTER(after->smi_count, before->smi_count, delta->smi_count)) {
+			fprintf(stderr, "cpu%d MSI counter went backwards %llX to %llX\n",
+				before->cpu, before->smi_count, after->smi_count);
+			errors++;
+		}
+
 		if (errors) {
 			fprintf(stderr, "ERROR cpu%d before:\n", before->cpu);
 			dump_cnt(before);
@@ -483,6 +498,7 @@ void compute_average(struct counters *delta, struct counters *avg)
 		sum->pc3 += delta->pc3;
 		sum->pc6 += delta->pc6;
 		sum->pc7 += delta->pc7;
+		sum->smi_count += delta->smi_count;
 	}
 	avg->tsc = sum->tsc/num_cpus;
 	avg->c1 = sum->c1/num_cpus;
@@ -495,6 +511,7 @@ void compute_average(struct counters *delta, struct counters *avg)
 	avg->pc3 = sum->pc3/num_cpus;
 	avg->pc6 = sum->pc6/num_cpus;
 	avg->pc7 = sum->pc7/num_cpus;
+	avg->smi_count = sum->smi_count/num_cpus;
 
 	free(sum);
 }
@@ -542,6 +559,11 @@ int get_counters(struct counters *cnt)
 		if (extra_msr_offset)
 			if (get_msr(cnt->cpu, extra_msr_offset, &cnt->extra_msr))
 				return -1;
+		if (do_smi_count) {
+			if (get_msr(cnt->cpu, MSR_SMI_COUNT, &cnt->smi_count))
+				return -1;
+			cnt->smi_count &= 0xffffffff;
+		}
 	}
 	return 0;
 }
@@ -906,7 +928,7 @@ int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
 
 int is_snb(unsigned int family, unsigned int model)
 {
-	if (!genuine_intel)
+	if (!genuine_intel || family != 6)
 		return 0;
 
 	switch (model) {
@@ -917,6 +939,22 @@ int is_snb(unsigned int family, unsigned int model)
 	return 0;
 }
 
+int is_nhm_wsm(unsigned int family, unsigned int model)
+{
+	if (!genuine_intel || family != 6)
+		return 0;
+
+	switch (model) {
+	case 26:
+	case 30:
+	case 46:
+	case 37:
+	case 44:
+	case 47:
+		return 1;
+	}
+	return 0;
+}
 double discover_bclk(unsigned int family, unsigned int model)
 {
 	if (is_snb(family, model))
@@ -1000,6 +1038,10 @@ void check_cpuid()
 	bclk = discover_bclk(family, model);
 
 	do_nehalem_turbo_ratio_limit = has_nehalem_turbo_ratio_limit(family, model);
+
+	/* Do unconditionally? Started with Nehalem, but may not be on Atoms */
+	if (is_snb(family, model) || is_nhm_wsm(family, model))
+		do_smi_count = 1;
 }
 
 
-- 
1.7.7.6

