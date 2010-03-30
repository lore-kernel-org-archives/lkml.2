Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0C3W7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 18:59:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:39396 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972Ab0C3W7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 18:59:45 -0400
Date: Tue, 30 Mar 2010 15:08:23 -0700
From: Tony Jones <tonyj@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH] perf: limit memory allocation to number cpus online
Message-ID: <20100330220823.GA16876@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: perf: limit memory allocation to number cpus online
From: Tony Jones <tonyj@suse.de>
Date: Tue, 30 Mar 2010 12:18:08 -0700

Limit the dynamic allocation of fd, event_array and mmap_array to #cpus online 
rather than MAX_NR_CPUS.

Cc: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Signed-off-by: Tony Jones <tonyj@suse.de>
---
 tools/perf/builtin-record.c |   10 +++++++---
 tools/perf/builtin-stat.c   |    4 ++--
 tools/perf/builtin-top.c    |   14 +++++++-------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 60ecdd3..25b5536 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -560,7 +560,6 @@ static int __cmd_record(int argc, const char **argv)
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
 		open_counters(profile_cpu);
 	} else {
-		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
 			open_counters(cpumap[i]);
 	}
@@ -748,7 +747,12 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
+	if (system_wide && profile_cpu == -1)
+		nr_cpus = read_cpu_map();
+	else
+		nr_cpus = 1;
+
+	for (i = 0; i < nr_cpus; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
 			mmap_array[i][j] = zalloc(
@@ -758,7 +762,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 	event_array = malloc(
-		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+		sizeof(struct pollfd)*nr_cpus*MAX_COUNTERS*thread_num);
 	if (!event_array)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 1036ca7..d9b672e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -540,7 +540,7 @@ static const struct option options[] = {
 int cmd_stat(int argc, const char **argv, const char *prefix __used)
 {
 	int status;
-	int i,j;
+	unsigned int i,j;
 
 	argc = parse_options(argc, argv, options, stat_usage,
 		PARSE_OPT_STOP_AT_NON_OPTION);
@@ -577,7 +577,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
+	for (i = 0; i < nr_cpus; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
 			if (!fd[i][j])
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4abdd9b..f05d270 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1368,7 +1368,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		thread_num = 1;
 	}
 
-	for (i = 0; i < MAX_NR_CPUS; i++) {
+	if (target_tid != -1 || profile_cpu != -1)
+		nr_cpus = 1;
+	else
+		nr_cpus = read_cpu_map();
+
+	for (i = 0; i < nr_cpus; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
 			mmap_array[i][j] = zalloc(
@@ -1378,7 +1383,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 	event_array = malloc(
-		sizeof(struct pollfd)*MAX_NR_CPUS*MAX_COUNTERS*thread_num);
+		sizeof(struct pollfd)*nr_cpus*MAX_COUNTERS*thread_num);
 	if (!event_array)
 		return -ENOMEM;
 
@@ -1424,11 +1429,6 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		attrs[counter].sample_period = default_interval;
 	}
 
-	if (target_tid != -1 || profile_cpu != -1)
-		nr_cpus = 1;
-	else
-		nr_cpus = read_cpu_map();
-
 	get_term_dimensions(&winsize);
 	if (print_entries == 0) {
 		update_print_entries(&winsize);
-- 
1.6.4.2

