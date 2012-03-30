Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671Ab2C3KSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:18:38 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:52218 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760584Ab2C3KSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:18:32 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 41/76] tools turbostat: harden against cpu online/offline
Date: Fri, 30 Mar 2012 06:13:44 -0400
Message-id: <15aaa34654831e98dd76f7738b6c7f5d05a66430.1333101989.git.len.brown@intel.com>
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

Sometimes users have turbostat running in interval mode
when they take processors offline/online.

Previously, turbostat would survive, but not gracefully.

Tighten up the error checking so turbostat notices
changesn sooner, and print just 1 line on change:

turbostat: re-initialized with num_cpus %d

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c |  115 +++++++++++++++++----------------
 1 file changed, 61 insertions(+), 54 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index fa60872..ab2f682 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -71,7 +71,6 @@ unsigned int show_cpu;
 int aperf_mperf_unstable;
 int backwards_count;
 char *progname;
-int need_reinitialize;
 
 int num_cpus;
 cpu_set_t *cpu_mask;
@@ -138,30 +137,24 @@ int cpu_migrate(int cpu)
 		return 0;
 }
 
-unsigned long long get_msr(int cpu, off_t offset)
+int get_msr(int cpu, off_t offset, unsigned long long *msr)
 {
 	ssize_t retval;
-	unsigned long long msr;
 	char pathname[32];
 	int fd;
 
 	sprintf(pathname, "/dev/cpu/%d/msr", cpu);
 	fd = open(pathname, O_RDONLY);
-	if (fd < 0) {
-		perror(pathname);
-		need_reinitialize = 1;
-		return 0;
-	}
-
-	retval = pread(fd, &msr, sizeof msr, offset);
-	if (retval != sizeof msr) {
-		fprintf(stderr, "cpu%d pread(..., 0x%zx) = %jd\n",
-			cpu, offset, retval);
-		exit(-2);
-	}
+	if (fd < 0)
+		return -1;
 
+	retval = pread(fd, msr, sizeof *msr, offset);
 	close(fd);
-	return msr;
+
+	if (retval != sizeof *msr)
+		return -1;
+
+	return 0;
 }
 
 void print_header(void)
@@ -506,36 +499,51 @@ void compute_average(struct counters *delta, struct counters *avg)
 	free(sum);
 }
 
-void get_counters(struct counters *cnt)
+int get_counters(struct counters *cnt)
 {
 	for ( ; cnt; cnt = cnt->next) {
-		if (cpu_migrate(cnt->cpu)) {
-			need_reinitialize = 1;
-			return;
+
+		if (cpu_migrate(cnt->cpu))
+			return -1;
+
+		if (get_msr(cnt->cpu, MSR_TSC, &cnt->tsc))
+			return -1;
+
+		if (has_aperf) {
+			if (get_msr(cnt->cpu, MSR_APERF, &cnt->aperf))
+				return -1;
+			if (get_msr(cnt->cpu, MSR_MPERF, &cnt->mperf))
+				return -1;
+		}
+
+		if (do_nhm_cstates) {
+			if (get_msr(cnt->cpu, MSR_CORE_C3_RESIDENCY, &cnt->c3))
+				return -1;
+			if (get_msr(cnt->cpu, MSR_CORE_C6_RESIDENCY, &cnt->c6))
+				return -1;
 		}
 
-		cnt->tsc = get_msr(cnt->cpu, MSR_TSC);
-		if (do_nhm_cstates)
-			cnt->c3 = get_msr(cnt->cpu, MSR_CORE_C3_RESIDENCY);
-		if (do_nhm_cstates)
-			cnt->c6 = get_msr(cnt->cpu, MSR_CORE_C6_RESIDENCY);
-		if (do_snb_cstates)
-			cnt->c7 = get_msr(cnt->cpu, MSR_CORE_C7_RESIDENCY);
-		if (has_aperf)
-			cnt->aperf = get_msr(cnt->cpu, MSR_APERF);
-		if (has_aperf)
-			cnt->mperf = get_msr(cnt->cpu, MSR_MPERF);
-		if (do_snb_cstates)
-			cnt->pc2 = get_msr(cnt->cpu, MSR_PKG_C2_RESIDENCY);
-		if (do_nhm_cstates)
-			cnt->pc3 = get_msr(cnt->cpu, MSR_PKG_C3_RESIDENCY);
-		if (do_nhm_cstates)
-			cnt->pc6 = get_msr(cnt->cpu, MSR_PKG_C6_RESIDENCY);
 		if (do_snb_cstates)
-			cnt->pc7 = get_msr(cnt->cpu, MSR_PKG_C7_RESIDENCY);
+			if (get_msr(cnt->cpu, MSR_CORE_C7_RESIDENCY, &cnt->c7))
+				return -1;
+
+		if (do_nhm_cstates) {
+			if (get_msr(cnt->cpu, MSR_PKG_C3_RESIDENCY, &cnt->pc3))
+				return -1;
+			if (get_msr(cnt->cpu, MSR_PKG_C6_RESIDENCY, &cnt->pc6))
+				return -1;
+		}
+		if (do_snb_cstates) {
+			if (get_msr(cnt->cpu, MSR_PKG_C2_RESIDENCY, &cnt->pc2))
+				return -1;
+			if (get_msr(cnt->cpu, MSR_PKG_C7_RESIDENCY, &cnt->pc7))
+				return -1;
+		}
 		if (extra_msr_offset)
-			cnt->extra_msr = get_msr(cnt->cpu, extra_msr_offset);
+			if (get_msr(cnt->cpu, extra_msr_offset, &cnt->extra_msr))
+				return -1;
 	}
+	return 0;
 }
 
 void print_nehalem_info(void)
@@ -546,7 +554,7 @@ void print_nehalem_info(void)
 	if (!do_nehalem_platform_info)
 		return;
 
-	msr = get_msr(0, MSR_NEHALEM_PLATFORM_INFO);
+	get_msr(0, MSR_NEHALEM_PLATFORM_INFO, &msr);
 
 	ratio = (msr >> 40) & 0xFF;
 	fprintf(stderr, "%d * %.0f = %.0f MHz max efficiency\n",
@@ -562,7 +570,7 @@ void print_nehalem_info(void)
 	if (!do_nehalem_turbo_ratio_limit)
 		return;
 
-	msr = get_msr(0, MSR_NEHALEM_TURBO_RATIO_LIMIT);
+	get_msr(0, MSR_NEHALEM_TURBO_RATIO_LIMIT, &msr);
 
 	ratio = (msr >> 24) & 0xFF;
 	if (ratio)
@@ -755,7 +763,7 @@ int get_core_id(int cpu)
 }
 
 /*
- * run func(index, cpu) on every cpu in /proc/stat
+ * run func(pkg, core, cpu) on every cpu in /proc/stat
  */
 
 int for_all_cpus(void (func)(int, int, int))
@@ -791,20 +799,18 @@ int for_all_cpus(void (func)(int, int, int))
 
 void re_initialize(void)
 {
-	printf("turbostat: topology changed, re-initializing.\n");
 	free_all_counters();
 	num_cpus = for_all_cpus(alloc_new_counters);
-	need_reinitialize = 0;
 	cpu_mask_uninit();
 	cpu_mask_init(num_cpus);
-	printf("num_cpus is now %d\n", num_cpus);
+	printf("turbostat: re-initialized with num_cpus %d\n", num_cpus);
 }
 
 void dummy(int pkg, int core, int cpu) { return; }
 /*
  * check to see if a cpu came on-line
  */
-void verify_num_cpus(void)
+int verify_num_cpus(void)
 {
 	int new_num_cpus;
 
@@ -814,8 +820,9 @@ void verify_num_cpus(void)
 		if (verbose)
 			printf("num_cpus was %d, is now  %d\n",
 				num_cpus, new_num_cpus);
-		need_reinitialize = 1;
+		return -1;
 	}
+	return 0;
 }
 
 void turbostat_loop()
@@ -825,25 +832,25 @@ restart:
 	gettimeofday(&tv_even, (struct timezone *)NULL);
 
 	while (1) {
-		verify_num_cpus();
-		if (need_reinitialize) {
+		if (verify_num_cpus()) {
 			re_initialize();
 			goto restart;
 		}
 		sleep(interval_sec);
-		get_counters(cnt_odd);
+		if (get_counters(cnt_odd)) {
+			re_initialize();
+			goto restart;
+		}
 		gettimeofday(&tv_odd, (struct timezone *)NULL);
-
 		compute_delta(cnt_odd, cnt_even, cnt_delta);
 		timersub(&tv_odd, &tv_even, &tv_delta);
 		compute_average(cnt_delta, cnt_average);
 		print_counters(cnt_delta);
-		if (need_reinitialize) {
+		sleep(interval_sec);
+		if (get_counters(cnt_even)) {
 			re_initialize();
 			goto restart;
 		}
-		sleep(interval_sec);
-		get_counters(cnt_even);
 		gettimeofday(&tv_even, (struct timezone *)NULL);
 		compute_delta(cnt_even, cnt_odd, cnt_delta);
 		timersub(&tv_even, &tv_odd, &tv_delta);
-- 
1.7.10.rc2.19.gfae9d

