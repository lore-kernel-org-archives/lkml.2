Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab2JGCod (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 22:44:33 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63438 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2JGCo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 22:44:28 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 47/49] tools/power/turbostat: add option to count SMIs, re-name some options
Date: Sat,  6 Oct 2012 22:43:17 -0400
Message-Id: <f9240813e61cb3e5838c9ab0237af831c61df7cf.1349554106.git.len.brown@intel.com>
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

Counting SMIs is popular, so add a dedicated "-s" option to do it,
and juggle some of the other option letters.

-S is now system summary (was -s)
-c is 32 bit counter (was -d)
-C is 64-bit counter (was -D)
-p is 1st thread in core (was -c)
-P is 1st thread in package (was -p)

bump the minor version number

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.8 | 12 +++++++-----
 tools/power/x86/turbostat/turbostat.c | 23 +++++++++++++----------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 0fc7a11..e4d0690 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -23,17 +23,19 @@ supports an "invariant" TSC, plus the APERF and MPERF MSRs.
 on processors that additionally support C-state residency counters.
 
 .SS Options
-The \fB-s\fP option limits output to a 1-line system summary for each interval.
+The \fB-p\fP option limits output to the 1st thread in 1st core of each package.
 .PP
-The \fB-c\fP option limits output to the 1st thread in each core.
+The \fB-P\fP option limits output to the 1st thread in each Package.
 .PP
-The \fB-p\fP option limits output to the 1st thread in each package.
+The \fB-S\fP option limits output to a 1-line System Summary for each interval.
 .PP
 The \fB-v\fP option increases verbosity.
 .PP
-The \fB-d MSR#\fP option includes the delta of the specified 32-bit MSR counter.
+The \fB-s\fP option prints the SMI counter, equivalent to "-c 0x34"
 .PP
-The \fB-D MSR#\fP option includes the delta of the specified 64-bit MSR counter.
+The \fB-c MSR#\fP option includes the delta of the specified 32-bit MSR counter.
+.PP
+The \fB-C MSR#\fP option includes the delta of the specified 64-bit MSR counter.
 .PP
 The \fB-m MSR#\fP option includes the the specified 32-bit MSR value.
 .PP
diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index e38976c..2655ae9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -230,9 +230,9 @@ void print_header(void)
 		outp += sprintf(outp, "  GHz");
 	outp += sprintf(outp, "  TSC");
 	if (extra_delta_offset32)
-		outp += sprintf(outp, "  delta 0x%03X", extra_delta_offset32);
+		outp += sprintf(outp, "  count 0x%03X", extra_delta_offset32);
 	if (extra_delta_offset64)
-		outp += sprintf(outp, "  DELTA 0x%03X", extra_delta_offset64);
+		outp += sprintf(outp, "  COUNT 0x%03X", extra_delta_offset64);
 	if (extra_msr_offset32)
 		outp += sprintf(outp, "   MSR 0x%03X", extra_msr_offset32);
 	if (extra_msr_offset64)
@@ -1304,7 +1304,7 @@ void check_cpuid()
 
 void usage()
 {
-	fprintf(stderr, "%s: [-v][-d MSR#][-D MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
+	fprintf(stderr, "%s: [-v][-p|-P|-S][-c MSR# | -s]][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
 		progname);
 	exit(1);
 }
@@ -1594,15 +1594,15 @@ void cmdline(int argc, char **argv)
 
 	progname = argv[0];
 
-	while ((opt = getopt(argc, argv, "+cpsvid:D:m:M:")) != -1) {
+	while ((opt = getopt(argc, argv, "+pPSvisc:sC:m:M:")) != -1) {
 		switch (opt) {
-		case 'c':
+		case 'p':
 			show_core_only++;
 			break;
-		case 'p':
+		case 'P':
 			show_pkg_only++;
 			break;
-		case 's':
+		case 'S':
 			summary_only++;
 			break;
 		case 'v':
@@ -1611,10 +1611,13 @@ void cmdline(int argc, char **argv)
 		case 'i':
 			interval_sec = atoi(optarg);
 			break;
-		case 'd':
+		case 'c':
 			sscanf(optarg, "%x", &extra_delta_offset32);
 			break;
-		case 'D':
+		case 's':
+			extra_delta_offset32 = 0x34;	/* SMI counter */
+			break;
+		case 'C':
 			sscanf(optarg, "%x", &extra_delta_offset64);
 			break;
 		case 'm':
@@ -1634,7 +1637,7 @@ int main(int argc, char **argv)
 	cmdline(argc, argv);
 
 	if (verbose > 1)
-		fprintf(stderr, "turbostat v2.0 May 16, 2012"
+		fprintf(stderr, "turbostat v2.1 October 6, 2012"
 			" - Len Brown <lenb@kernel.org>\n");
 
 	turbostat_init();
-- 
1.8.0.rc0.18.gf84667d

