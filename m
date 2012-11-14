Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423449Ab2KNUoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 15:44:21 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62951 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab2KNUnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 15:43:40 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 7/7] tools/power turbostat: print Watts
Date: Wed, 14 Nov 2012 15:43:24 -0500
Message-Id: <f3c7bfa850840c6c96a26796786ffdc7761519ef.1352925508.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352925804-6746-1-git-send-email-lenb@kernel.org>
References: <1352925804-6746-1-git-send-email-lenb@kernel.org>
In-Reply-To: <39300ffb9b6666714c60735cf854e1280e4e75f4.1352925508.git.len.brown@intel.com>
References: <39300ffb9b6666714c60735cf854e1280e4e75f4.1352925508.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Intel's Sandy Bridge and Ivy Bridge processor generations support RAPL (Run-Time-Average-Power-Limiting).
Per the Intel SDM (Intel® 64 and IA-32 Architectures Software Developer Manual)
RAPL provides hardware power information and control via MSRs (Model Specific Registers).
RAPL MSRs are designed primarily as a method to implement power capping.
However, even if power capping is not enabled, the RAPL regsiters
are useful for monitoring system power and operation.

Turbostat now displays the information provided by reading RAPL MSRs.
As always, turbostat never writes any MSRs.

turbostat's default display now includes Watts for hardware that
supports RAPL:

[root@sandy]# turbostat
cor CPU    %c0  GHz  TSC    %c1    %c3    %c6    %c7   %pc2   %pc3 %pc6   %pc7  Pkg_W  Cor_W GFX_W
          0.07 0.80 2.29   0.13   0.00   0.00  99.80   0.43   0.00 0.72  98.16   3.49   0.12  0.14
  0   0   0.14 0.80 2.29   0.12   0.00   0.00  99.74   0.43   0.00 0.72  98.16   3.49   0.12  0.14
  0   4   0.04 0.80 2.29   0.22
  1   1   0.06 0.80 2.29   0.08   0.00   0.00  99.86
  1   5   0.03 0.80 2.29   0.10
  2   2   0.17 0.80 2.29   0.14   0.00   0.00  99.69
  2   6   0.03 0.79 2.29   0.28
  3   3   0.03 0.80 2.29   0.07   0.00   0.00  99.90
  3   7   0.04 0.80 2.29   0.06

The Pkg_W column shows Watts for each package (socket) in the system.
On multi-socket systems, the system summary on the 1st row shows the total.

The Cor_W column shows Watts due to processors cores.
Core_W is included in Pkg_W.

The optional GFX_W column shows Watts due to the graphics "un-core".
GFX_W is included in Pkg_W.

The optional PKG_% column shows the % of time in the measurement interval that
RAPL power limiting is in effect.

Note that the RAPL energy counters have some limitations.

First hardware updates the countesr about once every milli-second.
This is fine for typical turbostat measurement intervals > 1 sec.
However, when turbostat is used to measure events that approach
1ms, the counters are less useful.

Second, the energy counters are 32-bits long and subject to wrapping.
For example, the counter increments in 15 micro-Joule units on my
local server, and the part could (in theory) consume energy at
its TDP specification of 130 Watts.  Here the 32-bit Joule counter
coult wrap as soon as 8 minutes.
Turbostat detects and handles up to 1 counter overflow per interval.
But when the measurement interval exceeds the guaranteed
counter range, we can't detect if more than 1 overflow occured.
So in this case turbostat indicates that the results are
in question by replacing the fractional part of the result
with "**":

Pkg_W  Cor_W GFX_W
  3**    0**   0**

Third, the RAPL counters are energy (Joule) counters -- they sum up
weighted events in the package to estimate energy consumed.  They are
not analong power (Watt) meters.  In practice, they tend to under-count
because they don't cover every possible use of energy in the package.
Also, the accuracy of the RAPL counters will vary between product generations,
and between SKU's in the same product generation.

turbostat's -v option now displays per-Package Thermal Design Power (TDP).
This is the specification for the part's maximum power consumption.
eg. on a 2-package SNB-Xeon system:

cpu0: 130.00 Watts Pkg Thermal Design Spec
cpu8: 130.00 Watts Pkg Thermal Design Spec

Finally, turbostat's -R option enables decoding and output of all RAPL registers
on turbostat startup.

Increment turbostat version number to 3.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.8 |  35 ++--
 tools/power/x86/turbostat/turbostat.c | 339 +++++++++++++++++++++++++++++++++-
 2 files changed, 350 insertions(+), 24 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index e4d0690..8094caa 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -31,6 +31,8 @@ The \fB-S\fP option limits output to a 1-line System Summary for each interval.
 .PP
 The \fB-v\fP option increases verbosity.
 .PP
+The \fB-R\fP option enables verbose RAPL register decoding on startup.
+.PP
 The \fB-s\fP option prints the SMI counter, equivalent to "-c 0x34"
 .PP
 The \fB-c MSR#\fP option includes the delta of the specified 32-bit MSR counter.
@@ -58,6 +60,10 @@ Note that multiple CPUs per core indicate support for Intel(R) Hyper-Threading T
 \fBTSC\fP average GHz that the TSC ran during the entire interval.
 \fB%c1, %c3, %c6, %c7\fP show the percentage residency in hardware core idle states.
 \fB%pc2, %pc3, %pc6, %pc7\fP percentage residency in hardware package idle states.
+\fBPkg_W\fP Watts consumed by the whole package.
+\fBCor_W\fP Watts consumed by the core part of the package.
+\fBGFX_W\fP Watts consumed by the Graphics part of the package.
+\fBPKG_%\fP percent of the interval that RAPL throttling was active.
 .fi
 .PP
 .SH EXAMPLE
@@ -66,25 +72,22 @@ Without any parameters, turbostat prints out counters ever 5 seconds.
 for turbostat to fork).
 
 The first row of statistics is a summary for the entire system.
-Note that the summary is a weighted average.
+For residency % columns, the summary is a weighted average.
+For Watts columns, the summary is a system total.
 Subsequent rows show per-CPU statistics.
 
 .nf
-[root@x980]# ./turbostat
-cor CPU    %c0  GHz  TSC    %c1    %c3    %c6   %pc3   %pc6
-          0.09 1.62 3.38   1.83   0.32  97.76   1.26  83.61
-  0   0   0.15 1.62 3.38  10.23   0.05  89.56   1.26  83.61
-  0   6   0.05 1.62 3.38  10.34
-  1   2   0.03 1.62 3.38   0.07   0.05  99.86
-  1   8   0.03 1.62 3.38   0.06
-  2   4   0.21 1.62 3.38   0.10   1.49  98.21
-  2  10   0.02 1.62 3.38   0.29
-  8   1   0.04 1.62 3.38   0.04   0.08  99.84
-  8   7   0.01 1.62 3.38   0.06
-  9   3   0.53 1.62 3.38   0.10   0.20  99.17
-  9   9   0.02 1.62 3.38   0.60
- 10   5   0.01 1.62 3.38   0.02   0.04  99.92
- 10  11   0.02 1.62 3.38   0.02
+[root@sandy]# ./turbostat
+cor CPU    %c0  GHz  TSC    %c1    %c3    %c6    %c7   %pc2   %pc3   %pc6   %pc7  Pkg_W  Cor_W GFX_W
+          0.07 0.80 2.29   0.13   0.00   0.00  99.80   0.43   0.00   0.72  98.16   3.49   0.12  0.14
+  0   0   0.14 0.80 2.29   0.12   0.00   0.00  99.74   0.43   0.00   0.72  98.16   3.49   0.12  0.14
+  0   4   0.04 0.80 2.29   0.22
+  1   1   0.06 0.80 2.29   0.08   0.00   0.00  99.86
+  1   5   0.03 0.80 2.29   0.10
+  2   2   0.17 0.80 2.29   0.14   0.00   0.00  99.69
+  2   6   0.03 0.79 2.29   0.28
+  3   3   0.03 0.80 2.29   0.07   0.00   0.00  99.90
+  3   7   0.04 0.80 2.29   0.06
 .fi
 .SH SUMMARY EXAMPLE
 The "-s" option prints the column headers just once,
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 77e76b1..7315c41 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -39,6 +39,7 @@
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
 unsigned int verbose;		/* set with -v */
+unsigned int rapl_verbose;	/* set with -R */
 unsigned int summary_only;	/* set with -s */
 unsigned int skip_c0;
 unsigned int skip_c1;
@@ -62,6 +63,17 @@ unsigned int show_cpu;
 unsigned int show_pkg_only;
 unsigned int show_core_only;
 char *output_buffer, *outp;
+unsigned int has_rapl;
+unsigned int do_rapl;
+double rapl_power_units, rapl_energy_units, rapl_time_units;
+double rapl_joule_counter_range;
+
+#define RAPL_PKG	(1 << 0)
+#define RAPL_CORES	(1 << 1)
+#define RAPL_GFX	(1 << 2)
+#define RAPL_DRAM	(1 << 3)
+#define RAPL_PKG_PERF_STATUS	(1 << 4)
+#define RAPL_DRAM_PERF_STATUS	(1 << 5)
 
 int aperf_mperf_unstable;
 int backwards_count;
@@ -98,6 +110,13 @@ struct pkg_data {
 	unsigned long long pc6;
 	unsigned long long pc7;
 	unsigned int package_id;
+	unsigned int energy_pkg;	/* MSR_PKG_ENERGY_STATUS */
+	unsigned int energy_dram;	/* MSR_DRAM_ENERGY_STATUS */
+	unsigned int energy_cores;	/* MSR_PP0_ENERGY_STATUS */
+	unsigned int energy_gfx;	/* MSR_PP1_ENERGY_STATUS */
+	unsigned int rapl_pkg_perf_status;	/* MSR_PKG_PERF_STATUS */
+	unsigned int rapl_dram_perf_status;	/* MSR_DRAM_PERF_STATUS */
+
 } *package_even, *package_odd;
 
 #define ODD_COUNTERS thread_odd, core_odd, package_odd
@@ -244,6 +263,19 @@ void print_header(void)
 	if (do_snb_cstates)
 		outp += sprintf(outp, "   %%pc7");
 
+	if (do_rapl & RAPL_PKG)
+		outp += sprintf(outp, "  Pkg_W");
+	if (do_rapl & RAPL_CORES)
+		outp += sprintf(outp, "  Cor_W");
+	if (do_rapl & RAPL_GFX)
+		outp += sprintf(outp, " GFX_W");
+	if (do_rapl & RAPL_DRAM)
+		outp += sprintf(outp, " RAM_W");
+	if (do_rapl & RAPL_PKG_PERF_STATUS)
+		outp += sprintf(outp, " PKG_%%");
+	if (do_rapl & RAPL_DRAM_PERF_STATUS)
+		outp += sprintf(outp, " RAM_%%");
+
 	outp += sprintf(outp, "\n");
 }
 
@@ -281,6 +313,12 @@ int dump_counters(struct thread_data *t, struct core_data *c,
 		fprintf(stderr, "pc3: %016llX\n", p->pc3);
 		fprintf(stderr, "pc6: %016llX\n", p->pc6);
 		fprintf(stderr, "pc7: %016llX\n", p->pc7);
+		fprintf(stderr, "Joules PKG: %0X\n", p->energy_pkg);
+		fprintf(stderr, "Joules COR: %0X\n", p->energy_cores);
+		fprintf(stderr, "Joules GFX: %0X\n", p->energy_gfx);
+		fprintf(stderr, "Joules RAM: %0X\n", p->energy_dram);
+		fprintf(stderr, "Throttle PKG: %0X\n", p->rapl_pkg_perf_status);
+		fprintf(stderr, "Throttle RAM: %0X\n", p->rapl_dram_perf_status);
 	}
 	return 0;
 }
@@ -290,14 +328,20 @@ int dump_counters(struct thread_data *t, struct core_data *c,
  * package: "pk" 2 columns %2d
  * core: "cor" 3 columns %3d
  * CPU: "CPU" 3 columns %3d
+ * Pkg_W: %6.2
+ * Cor_W: %6.2
+ * GFX_W: %5.2
+ * RAM_W: %5.2
  * GHz: "GHz" 3 columns %3.2
  * TSC: "TSC" 3 columns %3.2
  * percentage " %pc3" %6.2
+ * Perf Status percentage: %5.2
  */
 int format_counters(struct thread_data *t, struct core_data *c,
 	struct pkg_data *p)
 {
 	double interval_float;
+	char *fmt5, *fmt6;
 
 	 /* if showing only 1st thread in core and this isn't one, bail out */
 	if (show_core_only && !(t->flags & CPU_IS_FIRST_THREAD_IN_CORE))
@@ -337,7 +381,6 @@ int format_counters(struct thread_data *t, struct core_data *c,
 		if (show_cpu)
 			outp += sprintf(outp, " %3d", t->cpu_id);
 	}
-
 	/* %c0 */
 	if (do_nhm_cstates) {
 		if (show_pkg || show_core || show_cpu)
@@ -414,6 +457,31 @@ int format_counters(struct thread_data *t, struct core_data *c,
 		outp += sprintf(outp, " %6.2f", 100.0 * p->pc6/t->tsc);
 	if (do_snb_cstates)
 		outp += sprintf(outp, " %6.2f", 100.0 * p->pc7/t->tsc);
+
+	/*
+ 	 * If measurement interval exceeds minimum RAPL Joule Counter range,
+ 	 * indicate that results are suspect by printing "**" in fraction place.
+ 	 */
+	if (interval_float < rapl_joule_counter_range) {
+		fmt5 = " %5.2f";
+		fmt6 = " %6.2f";
+	} else {
+		fmt5 = " %3.0f**";
+		fmt6 = " %4.0f**";
+	}
+
+	if (do_rapl & RAPL_PKG)
+		outp += sprintf(outp, fmt6, p->energy_pkg * rapl_energy_units / interval_float);
+	if (do_rapl & RAPL_CORES)
+		outp += sprintf(outp, fmt6, p->energy_cores * rapl_energy_units / interval_float);
+	if (do_rapl & RAPL_GFX)
+		outp += sprintf(outp, fmt5, p->energy_gfx * rapl_energy_units / interval_float); 
+	if (do_rapl & RAPL_DRAM)
+		outp += sprintf(outp, fmt5, p->energy_dram * rapl_energy_units / interval_float);
+	if (do_rapl & RAPL_PKG_PERF_STATUS )
+		outp += sprintf(outp, fmt5, 100.0 * p->rapl_pkg_perf_status * rapl_time_units / interval_float);
+	if (do_rapl & RAPL_DRAM_PERF_STATUS )
+		outp += sprintf(outp, fmt5, 100.0 * p->rapl_dram_perf_status * rapl_time_units / interval_float);
 done:
 	outp += sprintf(outp, "\n");
 
@@ -449,6 +517,13 @@ void format_all_counters(struct thread_data *t, struct core_data *c, struct pkg_
 	for_all_cpus(format_counters, t, c, p);
 }
 
+#define DELTA_WRAP32(new, old)			\
+	if (new > old) {			\
+		old = new - old;		\
+	} else {				\
+		old = 0x100000000 + new - old;	\
+	}
+
 void
 delta_package(struct pkg_data *new, struct pkg_data *old)
 {
@@ -456,6 +531,13 @@ delta_package(struct pkg_data *new, struct pkg_data *old)
 	old->pc3 = new->pc3 - old->pc3;
 	old->pc6 = new->pc6 - old->pc6;
 	old->pc7 = new->pc7 - old->pc7;
+
+	DELTA_WRAP32(new->energy_pkg, old->energy_pkg);
+	DELTA_WRAP32(new->energy_cores, old->energy_cores);
+	DELTA_WRAP32(new->energy_gfx, old->energy_gfx);
+	DELTA_WRAP32(new->energy_dram, old->energy_dram);
+	DELTA_WRAP32(new->rapl_pkg_perf_status, old->rapl_pkg_perf_status);
+	DELTA_WRAP32(new->rapl_dram_perf_status, old->rapl_dram_perf_status);
 }
 
 void
@@ -575,6 +657,13 @@ void clear_counters(struct thread_data *t, struct core_data *c, struct pkg_data
 	p->pc3 = 0;
 	p->pc6 = 0;
 	p->pc7 = 0;
+
+	p->energy_pkg = 0;
+	p->energy_dram = 0;
+	p->energy_cores = 0;
+	p->energy_gfx = 0;
+	p->rapl_pkg_perf_status = 0;
+	p->rapl_dram_perf_status = 0;
 }
 int sum_counters(struct thread_data *t, struct core_data *c,
 	struct pkg_data *p)
@@ -604,6 +693,13 @@ int sum_counters(struct thread_data *t, struct core_data *c,
 	average.packages.pc6 += p->pc6;
 	average.packages.pc7 += p->pc7;
 
+	average.packages.energy_pkg += p->energy_pkg;
+	average.packages.energy_dram += p->energy_dram;
+	average.packages.energy_cores += p->energy_cores;
+	average.packages.energy_gfx += p->energy_gfx;
+
+	average.packages.rapl_pkg_perf_status += p->rapl_pkg_perf_status;
+	average.packages.rapl_dram_perf_status += p->rapl_dram_perf_status;
 	return 0;
 }
 /*
@@ -655,6 +751,7 @@ static unsigned long long rdtsc(void)
 int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 {
 	int cpu = t->cpu_id;
+	unsigned long long msr;
 
 	if (cpu_migrate(cpu)) {
 		fprintf(stderr, "Could not migrate to CPU %d\n", cpu);
@@ -671,9 +768,9 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 	}
 
 	if (extra_delta_offset32) {
-		if (get_msr(cpu, extra_delta_offset32, &t->extra_delta32))
+		if (get_msr(cpu, extra_delta_offset32, &msr))
 			return -5;
-		t->extra_delta32 &= 0xFFFFFFFF;
+		t->extra_delta32 = msr & 0xFFFFFFFF;
 	}
 
 	if (extra_delta_offset64)
@@ -681,9 +778,9 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 			return -5;
 
 	if (extra_msr_offset32) {
-		if (get_msr(cpu, extra_msr_offset32, &t->extra_msr32))
+		if (get_msr(cpu, extra_msr_offset32, &msr))
 			return -5;
-		t->extra_msr32 &= 0xFFFFFFFF;
+		t->extra_msr32 = msr & 0xFFFFFFFF;
 	}
 
 	if (extra_msr_offset64)
@@ -721,6 +818,36 @@ int get_counters(struct thread_data *t, struct core_data *c, struct pkg_data *p)
 		if (get_msr(cpu, MSR_PKG_C7_RESIDENCY, &p->pc7))
 			return -12;
 	}
+	if (do_rapl & RAPL_PKG) {
+		if (get_msr(cpu, MSR_PKG_ENERGY_STATUS, &msr))
+			return -13;
+		p->energy_pkg = msr & 0xFFFFFFFF;
+	}
+	if (do_rapl & RAPL_CORES) {
+		if (get_msr(cpu, MSR_PP0_ENERGY_STATUS, &msr))
+			return -14;
+		p->energy_cores = msr & 0xFFFFFFFF;
+	}
+	if (do_rapl & RAPL_DRAM) {
+		if (get_msr(cpu, MSR_DRAM_ENERGY_STATUS, &msr))
+			return -15;
+		p->energy_dram = msr & 0xFFFFFFFF;
+	}
+	if (do_rapl & RAPL_GFX) {
+		if (get_msr(cpu, MSR_PP1_ENERGY_STATUS, &msr))
+			return -16;
+		p->energy_gfx = msr & 0xFFFFFFFF;
+	}
+	if (do_rapl & RAPL_PKG_PERF_STATUS) {
+		if (get_msr(cpu, MSR_PKG_PERF_STATUS, &msr))
+			return -16;
+		p->rapl_pkg_perf_status = msr & 0xFFFFFFFF;
+	}
+	if (do_rapl & RAPL_DRAM_PERF_STATUS) {
+		if (get_msr(cpu, MSR_DRAM_PERF_STATUS, &msr))
+			return -16;
+		p->rapl_dram_perf_status = msr & 0xFFFFFFFF;
+	}
 	return 0;
 }
 
@@ -1204,6 +1331,194 @@ int has_ivt_turbo_ratio_limit(unsigned int family, unsigned int model)
 	}
 }
 
+#define	RAPL_POWER_GRANULARITY	0x7FFF	/* 15 bit power granularity */
+#define	RAPL_TIME_GRANULARITY	0x3F /* 6 bit time granularity */
+
+/*
+ * rapl_probe()
+ *
+ * sets has_rapl
+ */
+void rapl_probe(unsigned int family, unsigned int model)
+{
+	unsigned long long msr;
+	double tdp;
+
+	if (!genuine_intel)
+		return;
+
+	if (family != 6)
+		return;
+
+	switch (model) {
+	case 0x2A:
+	case 0x3A:
+		has_rapl = RAPL_PKG | RAPL_CORES | RAPL_GFX;
+		break;
+	case 0x2D:
+	case 0x3E:
+		has_rapl = RAPL_PKG | RAPL_CORES | RAPL_PKG_PERF_STATUS ;
+		break;
+	default:
+		return;
+	}
+
+	/* units on package 0, verify later other packages match */
+	if (get_msr(0, MSR_RAPL_POWER_UNIT, &msr))
+		return;
+
+	rapl_power_units = 1.0 / (1 << (msr & 0xF));
+	rapl_energy_units = 1.0 / (1 << (msr >> 8 & 0x1F));
+	rapl_time_units = 1.0 / (1 << (msr >> 16 & 0xF));
+
+	/* get TDP to determine energy counter range */
+	if (get_msr(0, MSR_PKG_POWER_INFO, &msr))
+		return;
+
+	tdp = ((msr >> 0) & RAPL_POWER_GRANULARITY) * rapl_power_units;
+
+	rapl_joule_counter_range = 0xFFFFFFFF * rapl_energy_units / tdp;
+
+	if (verbose || rapl_verbose)
+		fprintf(stderr, "%.0f sec RAPL Joule Counter Range\n", rapl_joule_counter_range);
+
+	return;
+}
+	
+void print_power_limit_msr(int cpu, unsigned long long msr, char *label)
+{
+	fprintf(stderr, "cpu%d: %s: %f Watts %sabled, %f sec clamp %sabled\n",
+		cpu, label,
+		((msr >> 0) & 0x7FFF) * rapl_power_units,
+		((msr >> 15) & 1) ? "EN" : "DIS",
+		((msr >> 17) & 0x7F) * rapl_time_units,
+		((msr >> 16) & 1) ? "EN" : "DIS");
+
+	return;
+}
+
+int print_rapl(struct thread_data *t, struct core_data *c, struct pkg_data *p)
+{
+	unsigned long long msr;
+	int cpu;
+	double local_rapl_power_units, local_rapl_energy_units, local_rapl_time_units;
+
+	if (!has_rapl)
+		return 0;
+
+	/* RAPL counters are per package, so print only for 1st thread/package */
+	if (!(t->flags & CPU_IS_FIRST_THREAD_IN_CORE) || !(t->flags & CPU_IS_FIRST_CORE_IN_PACKAGE))
+		return 0;
+
+	cpu = t->cpu_id;
+
+	if (get_msr(cpu, MSR_RAPL_POWER_UNIT, &msr))
+		return -1;
+
+	local_rapl_power_units = 1.0 / (1 << (msr & 0xF));
+	local_rapl_energy_units = 1.0 / (1 << (msr >> 8 & 0x1F));
+	local_rapl_time_units = 1.0 / (1 << (msr >> 16 & 0xF));
+
+	if (local_rapl_power_units != rapl_power_units)
+		fprintf(stderr, "cpu%d, ERROR: Power units mis-match\n", cpu);
+	if (local_rapl_energy_units != rapl_energy_units)
+		fprintf(stderr, "cpu%d, ERROR: Energy units mis-match\n", cpu);
+	if (local_rapl_time_units != rapl_time_units)
+		fprintf(stderr, "cpu%d, ERROR: Time units mis-match\n", cpu);
+
+	if (verbose > 1 || rapl_verbose) {
+		fprintf(stderr, "cpu%d: MSR_RAPL_POWER_UNIT: 0x%08llx "
+			"%f Watts, %f Joules, %f Seconds\n", cpu, msr,
+			local_rapl_power_units, local_rapl_energy_units, local_rapl_time_units);
+	}
+	if (has_rapl & RAPL_PKG) {
+		double tdp;
+
+		if (get_msr(cpu, MSR_PKG_POWER_INFO, &msr))
+                	return -5;
+
+		tdp = ((msr >>  0) & RAPL_POWER_GRANULARITY) * rapl_power_units;
+
+		fprintf(stderr, "cpu%d: %.2f Watts Pkg Thermal Design Spec\n",
+			cpu, tdp);
+
+		if (verbose > 1 || rapl_verbose) {
+			fprintf(stderr, "cpu%d: MSR_PKG_POWER_INFO: 0x%016llx\n", cpu, msr);
+			fprintf(stderr, "%.2f Watts Pkg RAPL Minimum\n",
+				((msr >> 16) & RAPL_POWER_GRANULARITY) * rapl_power_units);
+			fprintf(stderr, "%.2f Watts Pkg RAPL Maximum\n",
+				((msr >> 32) & RAPL_POWER_GRANULARITY) * rapl_power_units);
+			fprintf(stderr, "%f Sec. Maximum Pkg RAPL Time Window\n",
+				((msr >> 48) & RAPL_TIME_GRANULARITY) * rapl_time_units);
+
+			if (get_msr(cpu, MSR_PKG_POWER_LIMIT, &msr))
+				return -9;
+			fprintf(stderr, "cpu%d: MSR_PKG_POWER_LIMIT: %llx %sLOCKED\n",
+					cpu, msr, (msr >> 63) & 1 ? "": "UN-");
+			print_power_limit_msr(cpu, msr, "PKG Limit #1");
+			fprintf(stderr, "cpu%d: PKG Limit #2: %f Watts %sabled, %f sec clamp %sabled\n",
+					cpu,
+					((msr >> 32) & 0x7FFF) * rapl_power_units,
+					((msr >> 47) & 1) ? "EN" : "DIS",
+					((msr >> 49) & 0x7F) * rapl_time_units,
+					((msr >> 48) & 1) ? "EN" : "DIS");
+		}
+	}
+
+	if (has_rapl & RAPL_DRAM) {
+		if (get_msr(cpu, MSR_DRAM_POWER_INFO, &msr))
+                	return -6;
+
+		fprintf(stderr, "cpu%d: %.2f Watts DRAM Thermal Design Spec\n", cpu,
+			((msr >>  0) & RAPL_POWER_GRANULARITY) * rapl_power_units);
+
+		if (verbose > 1 || rapl_verbose) {
+			fprintf(stderr, "cpu%d: MSR_DRAM_POWER_INFO: 0x%016llx\n", cpu, msr);
+			fprintf(stderr, "%.2f Watts DRAM RAPL Minimum\n",
+				((msr >> 16) & RAPL_POWER_GRANULARITY) * rapl_power_units);
+			fprintf(stderr, "%.2f Watts DRAM RAPL Maximum\n",
+				((msr >> 32) & RAPL_POWER_GRANULARITY) * rapl_power_units);
+			fprintf(stderr, "%f Sec. Maximum DRAM RAPL Time Window\n",
+				((msr >> 48) & RAPL_TIME_GRANULARITY) * rapl_time_units);
+
+			if (get_msr(cpu, MSR_DRAM_POWER_LIMIT, &msr))
+				return -9;
+			fprintf(stderr, "cpu%d: MSR_DRAM_POWER_LIMIT: %llx %sLOCKED\n",
+					cpu, msr, (msr >> 31) & 1 ? "": "UN-");
+			print_power_limit_msr(cpu, msr, "DRAM Limit");
+		}
+	}
+	if (has_rapl & RAPL_CORES) {
+		if (verbose > 1 || rapl_verbose) {
+			if (get_msr(cpu, MSR_PP0_POLICY, &msr))
+				return -7;
+
+			fprintf(stderr, "cpu%d: MSR_PP0_POLICY: %lld\n", cpu, msr & 0xF);
+
+			if (get_msr(cpu, MSR_PP0_POWER_LIMIT, &msr))
+				return -9;
+			fprintf(stderr, "cpu%d: MSR_PP0_POWER_LIMIT: %llx %sLOCKED\n",
+					cpu, msr, (msr >> 31) & 1 ? "": "UN-");
+			print_power_limit_msr(cpu, msr, "Cores Limit");
+		}
+	}
+	if (has_rapl & RAPL_GFX) {
+		if (verbose > 1 || rapl_verbose) {
+			if (get_msr(cpu, MSR_PP1_POLICY, &msr))
+				return -8;
+
+			fprintf(stderr, "cpu%d: MSR_PP1_POLICY: %lld\n", cpu, msr & 0xF);
+
+			if (get_msr(cpu, MSR_PP1_POWER_LIMIT, &msr))
+				return -9;
+			fprintf(stderr, "cpu%d: MSR_PP1_POWER_LIMIT: %llx %sLOCKED\n",
+					cpu, msr, (msr >> 31) & 1 ? "": "UN-");
+			print_power_limit_msr(cpu, msr, "GFX Limit");
+		}
+	}
+	return 0;
+}
+
 
 int is_snb(unsigned int family, unsigned int model)
 {
@@ -1304,12 +1619,14 @@ void check_cpuid()
 
 	do_nehalem_turbo_ratio_limit = has_nehalem_turbo_ratio_limit(family, model);
 	do_ivt_turbo_ratio_limit = has_ivt_turbo_ratio_limit(family, model);
+	rapl_probe(family, model);
+	do_rapl = has_rapl; /* for now */
 }
 
 
 void usage()
 {
-	fprintf(stderr, "%s: [-v][-p|-P|-S][-c MSR# | -s]][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
+	fprintf(stderr, "%s: [-v][-R][-p|-P|-S][-c MSR# | -s]][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
 		progname);
 	exit(1);
 }
@@ -1545,6 +1862,9 @@ void turbostat_init()
 
 	if (verbose)
 		print_verbose_header();
+
+	if (verbose || rapl_verbose)
+		for_all_cpus(print_rapl, ODD_COUNTERS);
 }
 
 int fork_it(char **argv)
@@ -1601,7 +1921,7 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+pPSvi:sc:sC:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "+pPSvi:sc:sC:m:M:R")) != -1) {
 		switch (opt) {
 		case 'p':
 			show_core_only++;
@@ -1633,6 +1953,9 @@ void cmdline(int argc, char **argv)
 		case 'M':
 			sscanf(optarg, "%x", &extra_msr_offset64);
 			break;
+		case 'R':
+			rapl_verbose++;
+			break;
 		default:
 			usage();
 		}
@@ -1644,7 +1967,7 @@ int main(int argc, char **argv)
 	cmdline(argc, argv);
 
 	if (verbose > 1)
-		fprintf(stderr, "turbostat v2.1 October 6, 2012"
+		fprintf(stderr, "turbostat v3.0 November 14, 2012"
 			" - Len Brown <lenb@kernel.org>\n");
 
 	turbostat_init();
-- 
1.8.0

