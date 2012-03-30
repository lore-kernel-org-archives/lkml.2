Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab2C3LTK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:19:10 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:51544 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740Ab2C3LSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:18:35 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH 40/76] tools turbostat: reduce measurement overhead due to IPIs
Date: Fri, 30 Mar 2012 06:13:43 -0400
Message-id: <88c3281f7ba449992f7a33bd2452a8c6fa5503cb.1333101989.git.len.brown@intel.com>
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

turbostat uses /dev/cpu/*/msr interface to read MSRs.
For modern systems, it reads 10 MSR/CPU.  This can
be observed as 10 "Function Call Interrupts"
per CPU per sample added to /proc/interrupts.

This overhead is measurable on large idle systems,
and as Yoquan Song pointed out, it can even trick
cpuidle into thinking the system is busy.

Here turbostat re-schedules itself in-turn to each
CPU so that its MSR reads will always be local.
This replaces the 10 "Function Call Interrupts"
with a single "Rescheduling interrupt" per sample
per CPU.

On an idle 32-CPU system, this shifts some residency from
the shallow c1 state to the deeper c7 state:

 # ./turbostat.old -s
   %c0  GHz  TSC    %c1    %c3    %c6    %c7   %pc2   %pc3   %pc6   %pc7
  0.27 1.29 2.29   0.95   0.02   0.00  98.77  20.23   0.00  77.41   0.00
  0.25 1.24 2.29   0.98   0.02   0.00  98.75  20.34   0.03  77.74   0.00
  0.27 1.22 2.29   0.54   0.00   0.00  99.18  20.64   0.00  77.70   0.00
  0.26 1.22 2.29   1.22   0.00   0.00  98.52  20.22   0.00  77.74   0.00
  0.26 1.38 2.29   0.78   0.02   0.00  98.95  20.51   0.05  77.56   0.00
^C
 i# ./turbostat.new -s
   %c0  GHz  TSC    %c1    %c3    %c6    %c7   %pc2   %pc3   %pc6   %pc7
  0.27 1.20 2.29   0.24   0.01   0.00  99.49  20.58   0.00  78.20   0.00
  0.27 1.22 2.29   0.25   0.00   0.00  99.48  20.79   0.00  77.85   0.00
  0.27 1.20 2.29   0.25   0.02   0.00  99.46  20.71   0.03  77.89   0.00
  0.28 1.26 2.29   0.25   0.01   0.00  99.46  20.89   0.02  77.67   0.00
  0.27 1.20 2.29   0.24   0.01   0.00  99.48  20.65   0.00  78.04   0.00

cc: Youquan Song <youquan.song@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c |   46 +++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 6436d54..fa60872 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -19,6 +19,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
@@ -32,6 +33,7 @@
 #include <dirent.h>
 #include <string.h>
 #include <ctype.h>
+#include <sched.h>
 
 #define MSR_TSC	0x10
 #define MSR_NEHALEM_PLATFORM_INFO	0xCE
@@ -72,6 +74,8 @@ char *progname;
 int need_reinitialize;
 
 int num_cpus;
+cpu_set_t *cpu_mask;
+size_t cpu_mask_size;
 
 struct counters {
 	unsigned long long tsc;		/* per thread */
@@ -100,6 +104,40 @@ struct timeval tv_even;
 struct timeval tv_odd;
 struct timeval tv_delta;
 
+/*
+ * cpu_mask_init(ncpus)
+ *
+ * allocate and clear cpu_mask
+ * set cpu_mask_size
+ */
+void cpu_mask_init(int ncpus)
+{
+	cpu_mask = CPU_ALLOC(ncpus);
+	if (cpu_mask == NULL) {
+		perror("CPU_ALLOC");
+		exit(3);
+	}
+	cpu_mask_size = CPU_ALLOC_SIZE(ncpus);
+	CPU_ZERO_S(cpu_mask_size, cpu_mask);
+}
+
+void cpu_mask_uninit()
+{
+	CPU_FREE(cpu_mask);
+	cpu_mask = NULL;
+	cpu_mask_size = 0;
+}
+
+int cpu_migrate(int cpu)
+{
+	CPU_ZERO_S(cpu_mask_size, cpu_mask);
+	CPU_SET_S(cpu, cpu_mask_size, cpu_mask);
+	if (sched_setaffinity(0, cpu_mask_size, cpu_mask) == -1)
+		return -1;
+	else
+		return 0;
+}
+
 unsigned long long get_msr(int cpu, off_t offset)
 {
 	ssize_t retval;
@@ -471,6 +509,11 @@ void compute_average(struct counters *delta, struct counters *avg)
 void get_counters(struct counters *cnt)
 {
 	for ( ; cnt; cnt = cnt->next) {
+		if (cpu_migrate(cnt->cpu)) {
+			need_reinitialize = 1;
+			return;
+		}
+
 		cnt->tsc = get_msr(cnt->cpu, MSR_TSC);
 		if (do_nhm_cstates)
 			cnt->c3 = get_msr(cnt->cpu, MSR_CORE_C3_RESIDENCY);
@@ -752,6 +795,8 @@ void re_initialize(void)
 	free_all_counters();
 	num_cpus = for_all_cpus(alloc_new_counters);
 	need_reinitialize = 0;
+	cpu_mask_uninit();
+	cpu_mask_init(num_cpus);
 	printf("num_cpus is now %d\n", num_cpus);
 }
 
@@ -984,6 +1029,7 @@ void turbostat_init()
 	check_super_user();
 
 	num_cpus = for_all_cpus(alloc_new_counters);
+	cpu_mask_init(num_cpus);
 
 	if (verbose)
 		print_nehalem_info();
-- 
1.7.10.rc2.19.gfae9d

