Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2FLVRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 17:17:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:11053 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753660Ab2FLVRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 17:17:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="155455029"
From: Andi Kleen <andi@firstfloor.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] turbostat: Add SMI count to turbostat v2
Date: Tue, 12 Jun 2012 14:17:31 -0700
Message-Id: <1339535851-10305-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

[This version is for the turbostat v2 in -next]

When debugging timing related problems it's often useful to know
the SMI count. Newer Intel CPUs have a MSR to read it. Since turbostat
already has all the required infrastructure for polling MSRs I just
added it there (even though it's strictly not power related)
The counter is printed by default.

Unfortunately since it's a model specific counter needs a model
list number. I added Nehalems and Westmeres for it, and reused
the existing Sandy Bridge model list. This will need to be later
extended for each new CPU.

I also fixed the extra MSR display which didn't line up correctly.

v2: Port to turbostat2 in next. Fix extra MSR too.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/power/x86/turbostat/turbostat.c |   65 +++++++++++++++++++++++++++++++--
 1 files changed, 62 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 8ee4115..9023b67 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -36,6 +36,7 @@
 #include <sched.h>
 
 #define MSR_TSC	0x10
+#define MSR_SMI_COUNT 0x34
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
 #define MSR_NEHALEM_TURBO_RATIO_LIMIT	0x1AD
 #define MSR_APERF	0xE8
@@ -69,6 +70,7 @@ unsigned int show_core;
 unsigned int show_cpu;
 unsigned int show_pkg_only;
 unsigned int show_core_only;
+unsigned int do_smi_count;
 char *output_buffer, *outp;
 
 int aperf_mperf_unstable;
@@ -84,6 +86,7 @@ struct thread_data {
 	unsigned long long mperf;
 	unsigned long long c1;	/* derived */
 	unsigned long long extra_msr;
+	unsigned long long smi_count;
 	unsigned int cpu_id;
 	unsigned int flags;
 #define CPU_IS_FIRST_THREAD_IN_CORE	0x2
@@ -199,6 +202,8 @@ void print_header(void)
 		outp += sprintf(outp, "   %%pc7");
 	if (extra_msr_offset)
 		outp += sprintf(outp, "        MSR 0x%x ", extra_msr_offset);
+	if (do_smi_count)
+		outp += sprintf(outp, "       SMIs");
 
 	outp += sprintf(outp, "\n");
 }
@@ -216,6 +221,7 @@ int dump_counters(struct thread_data *t, struct core_data *c,
 		fprintf(stderr, "c1: %016llX\n", t->c1);
 		fprintf(stderr, "msr0x%x: %016llX\n",
 			extra_msr_offset, t->extra_msr);
+		fprintf(stderr, "smi: %llu\n", t->smi_count);
 	}
 
 	if (c) {
@@ -235,6 +241,18 @@ int dump_counters(struct thread_data *t, struct core_data *c,
 	return 0;
 }
 
+static void to_column(int column)
+{
+	char *p = strrchr(output_buffer, '\n');
+	int len = strlen(p ? p + 1 : output_buffer);
+
+	while (len < column) {
+		*outp++ = ' ';
+		len++;
+	}
+	*outp = 0;
+}
+
 /*
  * column formatting convention & formats
  * package: "pk" 2 columns %2d
@@ -248,6 +266,7 @@ int format_counters(struct thread_data *t, struct core_data *c,
 	struct pkg_data *p)
 {
 	double interval_float;
+	int column, len;
 
 	 /* if showing only 1st thread in core and this isn't one, bail out */
 	if (show_core_only && !(t->flags & CPU_IS_FIRST_THREAD_IN_CORE))
@@ -350,8 +369,19 @@ int format_counters(struct thread_data *t, struct core_data *c,
 	if (do_snb_cstates)
 		outp += sprintf(outp, " %6.2f", 100.0 * p->pc7/t->tsc);
 done:
-	if (extra_msr_offset)
-		outp += sprintf(outp, "  0x%016llx", t->extra_msr);
+	column = 61;
+	if (extra_msr_offset) {
+		to_column(column);
+		len = sprintf(outp, " 0x%016llx", t->extra_msr);
+		column += len;
+		outp += len;
+	}
+	if (do_smi_count) {
+		to_column(column);
+		len = sprintf(outp, " %6llu", t->smi_count);
+		column += len;
+		outp += len;
+	}
 	outp += sprintf(outp, "\n");
 
 	return 0;
@@ -462,6 +492,8 @@ delta_thread(struct thread_data *new, struct thread_data *old,
 	 * for "extra msr", just copy the latest w/o subtracting
 	 */
 	old->extra_msr = new->extra_msr;
+
+	old->smi_count = new->smi_count - old->smi_count;
 }
 
 int delta_cpu(struct thread_data *t, struct core_data *c,
@@ -508,6 +540,7 @@ int sum_counters(struct thread_data *t, struct core_data *c,
 	average.threads.aperf += t->aperf;
 	average.threads.mperf += t->mperf;
 	average.threads.c1 += t->c1;
+	average.threads.smi_count += t->smi_count;
 
 	/* sum per-core values only for 1st thread in core */
 	if (!(t->flags & CPU_IS_FIRST_THREAD_IN_CORE))
@@ -589,6 +622,12 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 		if (get_msr(cpu, extra_msr_offset, &t->extra_msr))
 			return -5;
 
+	if (do_smi_count) {
+		if (get_msr(cpu, MSR_SMI_COUNT, &t->smi_count))
+			return -13;
+		t->smi_count &= 0xffffffff;
+	}
+
 	/* collect core counters only for 1st thread in core */
 	if (!(t->flags & CPU_IS_FIRST_THREAD_IN_CORE))
 		return 0;
@@ -1044,7 +1083,7 @@ int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
 
 int is_snb(unsigned int family, unsigned int model)
 {
-	if (!genuine_intel)
+	if (!genuine_intel || family != 6)
 		return 0;
 
 	switch (model) {
@@ -1057,6 +1096,22 @@ int is_snb(unsigned int family, unsigned int model)
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
@@ -1140,6 +1195,10 @@ void check_cpuid()
 	bclk = discover_bclk(family, model);
 
 	do_nehalem_turbo_ratio_limit = has_nehalem_turbo_ratio_limit(family, model);
+
+	/* Do unconditionally? Started with Nehalem, but may not be on Atoms */
+	if (is_snb(family, model) || is_nhm_wsm(family, model))
+		do_smi_count = 1;
 }
 
 
-- 
1.7.7.6

