Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0KICZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:25:11 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47575 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0KICZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:25:10 -0500
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
To: a.p.zijlstra@chello.nl, acme@redhat.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>
Subject: [PATCH] perf: convert usages of profile_cpu in builtin-top.c to use cpu_list
Date: Mon,  8 Nov 2010 18:20:45 -0800
Message-Id: <1289269245-9388-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

profile_cpu was left over from an earlier implementation that supported
running perf top on a single CPU.  profile_cpu was no longer set by
any switch and usages of it resulted in dead code.

Instead, convert the code to use cpu_list, which is set by the -C <cpu_list>
option.

Also improved the printing of nr_cpus and cpu_list by correcting the plurals.

Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 tools/perf/builtin-top.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index b513e40..dd62580 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -69,7 +69,6 @@ static int			target_tid			=     -1;
 static pid_t			*all_tids			=      NULL;
 static int			thread_num			=      0;
 static bool			inherit				=  false;
-static int			profile_cpu			=     -1;
 static int			nr_cpus				=      0;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
@@ -558,13 +557,13 @@ static void print_sym_table(void)
 	else
 		printf(" (all");
 
-	if (profile_cpu != -1)
-		printf(", cpu: %d)\n", profile_cpu);
+	if (cpu_list)
+		printf(", CPU%s: %s)\n", nr_cpus > 1 ? "s" : "", cpu_list);
 	else {
 		if (target_tid != -1)
 			printf(")\n");
 		else
-			printf(", %d CPUs)\n", nr_cpus);
+			printf(", %d CPU%s)\n", nr_cpus, nr_cpus > 1 ? "s" : "");
 	}
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
@@ -1187,11 +1186,10 @@ int group_fd;
 static void start_counter(int i, int counter)
 {
 	struct perf_event_attr *attr;
-	int cpu;
+	int cpu = -1;
 	int thread_index;
 
-	cpu = profile_cpu;
-	if (target_tid == -1 && profile_cpu == -1)
+	if (target_tid == -1)
 		cpu = cpumap[i];
 
 	attr = attrs + counter;
-- 
1.7.0.4

