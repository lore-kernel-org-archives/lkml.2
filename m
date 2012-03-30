Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934079Ab2C3KZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:25:08 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760591Ab2C3KSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 39/76] tools turbostat: add summary option
Date: Fri, 30 Mar 2012 06:13:42 -0400
Message-id: <e23da0370f80834e971142e50253f5b79be83631.1333101989.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.10.rc2.19.gfae9d
In-reply-to: <1333102459-23750-1-git-send-email-lenb@kernel.org>
References: <1333102459-23750-1-git-send-email-lenb@kernel.org>
In-reply-to: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
References: <09f98a825a821f7a3f1b162f9ed023f37213a63b.1333101989.git.len.brown@intel.com>
Reply-to: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

turbostat -s
cuts down on the amount of output, per user request.

also treak some output whitespace and the man page.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.8 |   99 +++++++++++++++++++--------------
 tools/power/x86/turbostat/turbostat.c |   90 ++++++++++++++++++++----------
 2 files changed, 120 insertions(+), 69 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 555c69a..adf175f 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -4,11 +4,13 @@ turbostat \- Report processor frequency and idle statistics
 .SH SYNOPSIS
 .ft B
 .B turbostat
+.RB [ "\-s" ]
 .RB [ "\-v" ]
 .RB [ "\-M MSR#" ]
 .RB command
 .br
 .B turbostat
+.RB [ "\-s" ]
 .RB [ "\-v" ]
 .RB [ "\-M MSR#" ]
 .RB [ "\-i interval_sec" ]
@@ -25,6 +27,8 @@ supports an "invariant" TSC, plus the APERF and MPERF MSRs.
 on processors that additionally support C-state residency counters.
 
 .SS Options
+The \fB-s\fP option prints only a 1-line summary for each sample interval.
+.PP
 The \fB-v\fP option increases verbosity.
 .PP
 The \fB-M MSR#\fP option dumps the specified MSR,
@@ -39,13 +43,14 @@ displays the statistics gathered since it was forked.
 .SH FIELD DESCRIPTIONS
 .nf
 \fBpk\fP processor package number.
-\fBcr\fP processor core number.
+\fBcor\fP processor core number.
 \fBCPU\fP Linux CPU (logical processor) number.
+Note that multiple CPUs per core indicate support for Intel(R) Hyper-Threading Technology.
 \fB%c0\fP percent of the interval that the CPU retired instructions.
 \fBGHz\fP average clock rate while the CPU was in c0 state.
 \fBTSC\fP average GHz that the TSC ran during the entire interval.
-\fB%c1, %c3, %c6\fP show the percentage residency in hardware core idle states.
-\fB%pc3, %pc6\fP percentage residency in hardware package idle states.
+\fB%c1, %c3, %c6, %c7\fP show the percentage residency in hardware core idle states.
+\fB%pc2, %pc3, %pc6, %pc7\fP percentage residency in hardware package idle states.
 .fi
 .PP
 .SH EXAMPLE
@@ -53,25 +58,37 @@ Without any parameters, turbostat prints out counters ever 5 seconds.
 (override interval with "-i sec" option, or specify a command
 for turbostat to fork).
 
-The first row of statistics reflect the average for the entire system.
+The first row of statistics is a summary for the entire system.
+Note that the summary is a weighted average.
 Subsequent rows show per-CPU statistics.
 
 .nf
 [root@x980]# ./turbostat
-cr   CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
-          0.04 1.62 3.38   0.11   0.00  99.85   0.00  95.07
-  0   0   0.04 1.62 3.38   0.06   0.00  99.90   0.00  95.07
-  0   6   0.02 1.62 3.38   0.08   0.00  99.90   0.00  95.07
-  1   2   0.10 1.62 3.38   0.29   0.00  99.61   0.00  95.07
-  1   8   0.11 1.62 3.38   0.28   0.00  99.61   0.00  95.07
-  2   4   0.01 1.62 3.38   0.01   0.00  99.98   0.00  95.07
-  2  10   0.01 1.61 3.38   0.02   0.00  99.98   0.00  95.07
-  8   1   0.07 1.62 3.38   0.15   0.00  99.78   0.00  95.07
-  8   7   0.03 1.62 3.38   0.19   0.00  99.78   0.00  95.07
-  9   3   0.01 1.62 3.38   0.02   0.00  99.98   0.00  95.07
-  9   9   0.01 1.62 3.38   0.02   0.00  99.98   0.00  95.07
- 10   5   0.01 1.62 3.38   0.13   0.00  99.86   0.00  95.07
- 10  11   0.08 1.62 3.38   0.05   0.00  99.86   0.00  95.07
+cor CPU    %c0  GHz  TSC    %c1    %c3    %c6   %pc3   %pc6
+          0.60 1.63 3.38   2.91   0.00  96.49   0.00  76.64
+  0   0   0.59 1.62 3.38   4.51   0.00  94.90   0.00  76.64
+  0   6   1.13 1.64 3.38   3.97   0.00  94.90   0.00  76.64
+  1   2   0.08 1.62 3.38   0.07   0.00  99.85   0.00  76.64
+  1   8   0.03 1.62 3.38   0.12   0.00  99.85   0.00  76.64
+  2   4   0.01 1.62 3.38   0.06   0.00  99.93   0.00  76.64
+  2  10   0.04 1.62 3.38   0.02   0.00  99.93   0.00  76.64
+  8   1   2.85 1.62 3.38  11.71   0.00  85.44   0.00  76.64
+  8   7   1.98 1.62 3.38  12.58   0.00  85.44   0.00  76.64
+  9   3   0.36 1.62 3.38   0.71   0.00  98.93   0.00  76.64
+  9   9   0.09 1.62 3.38   0.98   0.00  98.93   0.00  76.64
+ 10   5   0.03 1.62 3.38   0.09   0.00  99.87   0.00  76.64
+ 10  11   0.07 1.62 3.38   0.06   0.00  99.87   0.00  76.64
+.fi
+.SH SUMMARY EXAMPLE
+The "-s" option prints the column headers just once,
+and then the one line system summary for each sample interval.
+
+.nf
+[root@x980]# ./turbostat -s
+   %c0  GHz  TSC    %c1    %c3    %c6   %pc3   %pc6
+  0.61 1.89 3.38   5.95   0.00  93.44   0.00  66.33
+  0.52 1.62 3.38   6.83   0.00  92.65   0.00  61.11
+  0.62 1.92 3.38   5.47   0.00  93.91   0.00  67.31
 .fi
 .SH VERBOSE EXAMPLE
 The "-v" option adds verbosity to the output:
@@ -101,33 +118,33 @@ until ^C while the other CPUs are mostly idle:
 
 .nf
 [root@x980 lenb]# ./turbostat cat /dev/zero > /dev/null
-
-^Ccr   CPU   %c0   GHz  TSC   %c1    %c3    %c6   %pc3   %pc6
-           8.49 3.63 3.38  16.23   0.66  74.63   0.00   0.00
-   0   0   1.22 3.62 3.38  32.18   0.00  66.60   0.00   0.00
-   0   6   0.40 3.61 3.38  33.00   0.00  66.60   0.00   0.00
-   1   2   0.11 3.14 3.38   0.19   3.95  95.75   0.00   0.00
-   1   8   0.05 2.88 3.38   0.25   3.95  95.75   0.00   0.00
-   2   4   0.00 3.13 3.38   0.02   0.00  99.98   0.00   0.00
-   2  10   0.00 3.09 3.38   0.02   0.00  99.98   0.00   0.00
-   8   1   0.04 3.50 3.38  14.43   0.00  85.54   0.00   0.00
-   8   7   0.03 2.98 3.38  14.43   0.00  85.54   0.00   0.00
-   9   3   0.00 3.16 3.38 100.00   0.00   0.00   0.00   0.00
-   9   9  99.93 3.63 3.38   0.06   0.00   0.00   0.00   0.00
-  10   5   0.01 2.82 3.38   0.08   0.00  99.91   0.00   0.00
-  10  11   0.02 3.36 3.38   0.06   0.00  99.91   0.00   0.00
-6.950866 sec
+^C
+cor CPU    %c0  GHz  TSC    %c1    %c3    %c6   %pc3   %pc6
+          8.63 3.64 3.38  14.46   0.49  76.42   0.00   0.00
+  0   0   0.34 3.36 3.38  99.66   0.00   0.00   0.00   0.00
+  0   6  99.96 3.64 3.38   0.04   0.00   0.00   0.00   0.00
+  1   2   0.14 3.50 3.38   1.75   2.04  96.07   0.00   0.00
+  1   8   0.38 3.57 3.38   1.51   2.04  96.07   0.00   0.00
+  2   4   0.01 2.65 3.38   0.06   0.00  99.93   0.00   0.00
+  2  10   0.03 2.12 3.38   0.04   0.00  99.93   0.00   0.00
+  8   1   0.91 3.59 3.38  35.27   0.92  62.90   0.00   0.00
+  8   7   1.61 3.63 3.38  34.57   0.92  62.90   0.00   0.00
+  9   3   0.04 3.38 3.38   0.20   0.00  99.76   0.00   0.00
+  9   9   0.04 3.29 3.38   0.20   0.00  99.76   0.00   0.00
+ 10   5   0.03 3.08 3.38   0.12   0.00  99.85   0.00   0.00
+ 10  11   0.05 3.07 3.38   0.10   0.00  99.85   0.00   0.00
+4.907015 sec
 
 .fi
-Above the cycle soaker drives cpu9 up 3.6 Ghz turbo limit
+Above the cycle soaker drives cpu6 up 3.6 Ghz turbo limit
 while the other processors are generally in various states of idle.
 
-Note that cpu3 is an HT sibling sharing core9
-with cpu9, and thus it is unable to get to an idle state
-deeper than c1 while cpu9 is busy.
+Note that cpu0 is an HT sibling sharing core0
+with cpu6, and thus it is unable to get to an idle state
+deeper than c1 while cpu6 is busy.
 
-Note that turbostat reports average GHz of 3.61, while
-the arithmetic average of the GHz column above is 3.24.
+Note that turbostat reports average GHz of 3.64, while
+the arithmetic average of the GHz column above is lower.
 This is a weighted average, where the weight is %c0.  ie. it is the total number of
 un-halted cycles elapsed per time divided by the number of CPUs.
 .SH NOTES
@@ -167,6 +184,6 @@ http://www.intel.com/products/processor/manuals/
 .SH "SEE ALSO"
 msr(4), vmstat(8)
 .PP
-.SH AUTHORS
+.SH AUTHOR
 .nf
 Written by Len Brown <len.brown@intel.com>
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 310d3dd..6436d54 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2,7 +2,7 @@
  * turbostat -- show CPU frequency and C-state residency
  * on modern Intel turbo-capable processors.
  *
- * Copyright (c) 2010, Intel Corporation.
+ * Copyright (c) 2012 Intel Corporation.
  * Len Brown <len.brown@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -49,6 +49,7 @@
 char *proc_stat = "/proc/stat";
 unsigned int interval_sec = 5;	/* set with -i interval_sec */
 unsigned int verbose;		/* set with -v */
+unsigned int summary_only;	/* set with -s */
 unsigned int skip_c0;
 unsigned int skip_c1;
 unsigned int do_nhm_cstates;
@@ -129,14 +130,18 @@ void print_header(void)
 {
 	if (show_pkg)
 		fprintf(stderr, "pk");
+	if (show_pkg)
+		fprintf(stderr, " ");
 	if (show_core)
-		fprintf(stderr, " cr");
+		fprintf(stderr, "cor");
 	if (show_cpu)
 		fprintf(stderr, " CPU");
+	if (show_pkg || show_core || show_cpu)
+		fprintf(stderr, " ");
 	if (do_nhm_cstates)
-		fprintf(stderr, "    %%c0 ");
+		fprintf(stderr, "   %%c0");
 	if (has_aperf)
-		fprintf(stderr, " GHz");
+		fprintf(stderr, "  GHz");
 	fprintf(stderr, "  TSC");
 	if (do_nhm_cstates)
 		fprintf(stderr, "    %%c1");
@@ -147,13 +152,13 @@ void print_header(void)
 	if (do_snb_cstates)
 		fprintf(stderr, "    %%c7");
 	if (do_snb_cstates)
-		fprintf(stderr, "  %%pc2");
+		fprintf(stderr, "   %%pc2");
 	if (do_nhm_cstates)
-		fprintf(stderr, "  %%pc3");
+		fprintf(stderr, "   %%pc3");
 	if (do_nhm_cstates)
-		fprintf(stderr, "  %%pc6");
+		fprintf(stderr, "   %%pc6");
 	if (do_snb_cstates)
-		fprintf(stderr, "  %%pc7");
+		fprintf(stderr, "   %%pc7");
 	if (extra_msr_offset)
 		fprintf(stderr, "        MSR 0x%x ", extra_msr_offset);
 
@@ -187,6 +192,15 @@ void dump_list(struct counters *cnt)
 		dump_cnt(cnt);
 }
 
+/*
+ * column formatting convention & formats
+ * package: "pk" 2 columns %2d
+ * core: "cor" 3 columns %3d
+ * CPU: "CPU" 3 columns %3d
+ * GHz: "GHz" 3 columns %3.2
+ * TSC: "TSC" 3 columns %3.2
+ * percentage " %pc3" %6.2
+ */
 void print_cnt(struct counters *p)
 {
 	double interval_float;
@@ -196,39 +210,45 @@ void print_cnt(struct counters *p)
 	/* topology columns, print blanks on 1st (average) line */
 	if (p == cnt_average) {
 		if (show_pkg)
+			fprintf(stderr, "  ");
+		if (show_pkg && show_core)
 			fprintf(stderr, " ");
 		if (show_core)
-			fprintf(stderr, "    ");
+			fprintf(stderr, "   ");
 		if (show_cpu)
-			fprintf(stderr, "    ");
+			fprintf(stderr, " " "   ");
 	} else {
 		if (show_pkg)
-			fprintf(stderr, "%d", p->pkg);
+			fprintf(stderr, "%2d", p->pkg);
+		if (show_pkg && show_core)
+			fprintf(stderr, " ");
 		if (show_core)
-			fprintf(stderr, "%4d", p->core);
+			fprintf(stderr, "%3d", p->core);
 		if (show_cpu)
-			fprintf(stderr, "%4d", p->cpu);
+			fprintf(stderr, " %3d", p->cpu);
 	}
 
 	/* %c0 */
 	if (do_nhm_cstates) {
+		if (show_pkg || show_core || show_cpu)
+			fprintf(stderr, " ");
 		if (!skip_c0)
-			fprintf(stderr, "%7.2f", 100.0 * p->mperf/p->tsc);
+			fprintf(stderr, "%6.2f", 100.0 * p->mperf/p->tsc);
 		else
-			fprintf(stderr, "   ****");
+			fprintf(stderr, "  ****");
 	}
 
 	/* GHz */
 	if (has_aperf) {
 		if (!aperf_mperf_unstable) {
-			fprintf(stderr, "%5.2f",
+			fprintf(stderr, " %3.2f",
 				1.0 * p->tsc / units * p->aperf /
 				p->mperf / interval_float);
 		} else {
 			if (p->aperf > p->tsc || p->mperf > p->tsc) {
-				fprintf(stderr, " ****");
+				fprintf(stderr, " ***");
 			} else {
-				fprintf(stderr, "%4.1f*",
+				fprintf(stderr, "%3.1f*",
 					1.0 * p->tsc /
 					units * p->aperf /
 					p->mperf / interval_float);
@@ -241,7 +261,7 @@ void print_cnt(struct counters *p)
 
 	if (do_nhm_cstates) {
 		if (!skip_c1)
-			fprintf(stderr, "%7.2f", 100.0 * p->c1/p->tsc);
+			fprintf(stderr, " %6.2f", 100.0 * p->c1/p->tsc);
 		else
 			fprintf(stderr, "  ****");
 	}
@@ -252,13 +272,13 @@ void print_cnt(struct counters *p)
 	if (do_snb_cstates)
 		fprintf(stderr, " %6.2f", 100.0 * p->c7/p->tsc);
 	if (do_snb_cstates)
-		fprintf(stderr, " %5.2f", 100.0 * p->pc2/p->tsc);
+		fprintf(stderr, " %6.2f", 100.0 * p->pc2/p->tsc);
 	if (do_nhm_cstates)
-		fprintf(stderr, " %5.2f", 100.0 * p->pc3/p->tsc);
+		fprintf(stderr, " %6.2f", 100.0 * p->pc3/p->tsc);
 	if (do_nhm_cstates)
-		fprintf(stderr, " %5.2f", 100.0 * p->pc6/p->tsc);
+		fprintf(stderr, " %6.2f", 100.0 * p->pc6/p->tsc);
 	if (do_snb_cstates)
-		fprintf(stderr, " %5.2f", 100.0 * p->pc7/p->tsc);
+		fprintf(stderr, " %6.2f", 100.0 * p->pc7/p->tsc);
 	if (extra_msr_offset)
 		fprintf(stderr, "  0x%016llx", p->extra_msr);
 	putc('\n', stderr);
@@ -267,12 +287,20 @@ void print_cnt(struct counters *p)
 void print_counters(struct counters *counters)
 {
 	struct counters *cnt;
+	static int printed;
 
-	print_header();
+
+	if (!printed || !summary_only)
+		print_header();
 
 	if (num_cpus > 1)
 		print_cnt(cnt_average);
 
+	printed = 1;
+
+	if (summary_only)
+		return;
+
 	for (cnt = counters; cnt != NULL; cnt = cnt->next)
 		print_cnt(cnt);
 
@@ -557,7 +585,8 @@ void insert_counters(struct counters **list,
 		return;
 	}
 
-	show_cpu = 1;	/* there is more than one CPU */
+	if (!summary_only)
+		show_cpu = 1;	/* there is more than one CPU */
 
 	/*
 	 * insert on front of list.
@@ -575,13 +604,15 @@ void insert_counters(struct counters **list,
 
 	while (prev->next && (prev->next->pkg < new->pkg)) {
 		prev = prev->next;
-		show_pkg = 1;	/* there is more than 1 package */
+		if (!summary_only)
+			show_pkg = 1;	/* there is more than 1 package */
 	}
 
 	while (prev->next && (prev->next->pkg == new->pkg)
 		&& (prev->next->core < new->core)) {
 		prev = prev->next;
-		show_core = 1;	/* there is more than 1 core */
+		if (!summary_only)
+			show_core = 1;	/* there is more than 1 core */
 	}
 
 	while (prev->next && (prev->next->pkg == new->pkg)
@@ -1005,8 +1036,11 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+vi:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "+svi:M:")) != -1) {
 		switch (opt) {
+		case 's':
+			summary_only++;
+			break;
 		case 'v':
 			verbose++;
 			break;
-- 
1.7.10.rc2.19.gfae9d

