Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2FDFkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 01:40:42 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:35395 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab2FDFki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 01:40:38 -0400
From: Len Brown <lenb@kernel.org>
To: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: [PATCH 12/15] tools/power turbostat: fix un-intended affinity of forked program
Date: Mon,  4 Jun 2012 01:40:03 -0400
Message-Id: <d15cf7c129fa4ec4b44c52521e49ffafb9749029.1338786832.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.11.rc0.100.g5498c5f
In-Reply-To: <1338788406-29981-1-git-send-email-lenb@kernel.org>
References: <1338788406-29981-1-git-send-email-lenb@kernel.org>
In-Reply-To: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
References: <c5971456964290da7e98222892797b71ef793e62.1338786831.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Linux 3.4 included a modification to turbostat to
lower cross-call overhead by using scheduler affinity:

15aaa34654831e98dd76f7738b6c7f5d05a66430
(tools turbostat: reduce measurement overhead due to IPIs)

In the use-case where turbostat forks a child program,
that change had the un-intended side-effect of binding
the child to the last cpu in the system.

This change removed the binding before forking the child.

This is a back-port of a fix already included in turbostat v2.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 tools/power/x86/turbostat/turbostat.c | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ab2f682..d5d6a3d 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -73,8 +73,8 @@ int backwards_count;
 char *progname;
 
 int num_cpus;
-cpu_set_t *cpu_mask;
-size_t cpu_mask_size;
+cpu_set_t *cpu_present_set, *cpu_mask;
+size_t cpu_present_setsize, cpu_mask_size;
 
 struct counters {
 	unsigned long long tsc;		/* per thread */
@@ -103,6 +103,12 @@ struct timeval tv_even;
 struct timeval tv_odd;
 struct timeval tv_delta;
 
+int mark_cpu_present(int pkg, int core, int cpu)
+{
+	CPU_SET_S(cpu, cpu_present_setsize, cpu_present_set);
+	return 0;
+}
+
 /*
  * cpu_mask_init(ncpus)
  *
@@ -118,6 +124,18 @@ void cpu_mask_init(int ncpus)
 	}
 	cpu_mask_size = CPU_ALLOC_SIZE(ncpus);
 	CPU_ZERO_S(cpu_mask_size, cpu_mask);
+
+	/*
+	 * Allocate and initialize cpu_present_set
+	 */
+	cpu_present_set = CPU_ALLOC(ncpus);
+	if (cpu_present_set == NULL) {
+		perror("CPU_ALLOC");
+		exit(3);
+	}
+	cpu_present_setsize = CPU_ALLOC_SIZE(ncpus);
+	CPU_ZERO_S(cpu_present_setsize, cpu_present_set);
+	for_all_cpus(mark_cpu_present);
 }
 
 void cpu_mask_uninit()
@@ -125,6 +143,9 @@ void cpu_mask_uninit()
 	CPU_FREE(cpu_mask);
 	cpu_mask = NULL;
 	cpu_mask_size = 0;
+	CPU_FREE(cpu_present_set);
+	cpu_present_set = NULL;
+	cpu_present_setsize = 0;
 }
 
 int cpu_migrate(int cpu)
@@ -1047,6 +1068,9 @@ int fork_it(char **argv)
 	int retval;
 	pid_t child_pid;
 	get_counters(cnt_even);
+
+        /* clear affinity side-effect of get_counters() */
+        sched_setaffinity(0, cpu_present_setsize, cpu_present_set);
 	gettimeofday(&tv_even, (struct timezone *)NULL);
 
 	child_pid = fork();
-- 
1.7.11.rc0.100.g5498c5f

