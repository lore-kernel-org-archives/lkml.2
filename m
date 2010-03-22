Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0CVQKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:10:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56550 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0CVQKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:10:40 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 4/5] perf stat: Better report failure to collect system wide stats
Date: Mon, 22 Mar 2010 13:10:28 -0300
Message-Id: <1269274229-20442-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269274229-20442-1-git-send-email-acme@infradead.org>
References: <1269274229-20442-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before:

[acme@doppio linux-2.6-tip]$ perf stat -a sleep 1s

 Performance counter stats for 'sleep 1s':

  <not counted>  task-clock-msecs
  <not counted>  context-switches
  <not counted>  CPU-migrations
  <not counted>  page-faults
  <not counted>  cycles
  <not counted>  instructions
  <not counted>  branches
  <not counted>  branch-misses
  <not counted>  cache-references
  <not counted>  cache-misses

    1.016998463  seconds time elapsed

[acme@doppio linux-2.6-tip]$

Now:

[acme@doppio linux-2.6-tip]$ perf stat -a sleep 1s
No permission to collect system-wide stats.
Consider tweaking /proc/sys/kernel/perf_event_paranoid.
[acme@doppio linux-2.6-tip]$

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |   39 ++++++++++++++++++++++++++++-----------
 1 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c92f90f..1036ca7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -144,10 +144,11 @@ struct stats			runtime_branches_stats;
 #define ERR_PERF_OPEN \
 "Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
 
-static void create_perf_stat_counter(int counter)
+static int create_perf_stat_counter(int counter)
 {
 	struct perf_event_attr *attr = attrs + counter;
 	int thread;
+	int ncreated = 0;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -159,9 +160,11 @@ static void create_perf_stat_counter(int counter)
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
 					-1, cpumap[cpu], -1, 0);
-			if (fd[cpu][counter][0] < 0 && verbose)
-				fprintf(stderr, ERR_PERF_OPEN, counter,
-					fd[cpu][counter][0], strerror(errno));
+			if (fd[cpu][counter][0] < 0)
+				pr_debug(ERR_PERF_OPEN, counter,
+					 fd[cpu][counter][0], strerror(errno));
+			else
+				++ncreated;
 		}
 	} else {
 		attr->inherit	     = inherit;
@@ -172,12 +175,16 @@ static void create_perf_stat_counter(int counter)
 		for (thread = 0; thread < thread_num; thread++) {
 			fd[0][counter][thread] = sys_perf_event_open(attr,
 				all_tids[thread], -1, -1, 0);
-			if (fd[0][counter][thread] < 0 && verbose)
-				fprintf(stderr, ERR_PERF_OPEN, counter,
-					fd[0][counter][thread],
-					strerror(errno));
+			if (fd[0][counter][thread] < 0)
+				pr_debug(ERR_PERF_OPEN, counter,
+					 fd[0][counter][thread],
+					 strerror(errno));
+			else
+				++ncreated;
 		}
 	}
+
+	return ncreated;
 }
 
 /*
@@ -264,7 +271,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
 	int status = 0;
-	int counter;
+	int counter, ncreated = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
 	char buf;
@@ -324,7 +331,16 @@ static int run_perf_stat(int argc __used, const char **argv)
 	}
 
 	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter);
+		ncreated += create_perf_stat_counter(counter);
+
+	if (ncreated == 0) {
+		pr_err("No permission to collect %sstats.\n"
+		       "Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n",
+		       system_wide ? "system-wide " : "");
+		if (child_pid != -1)
+			kill(child_pid, SIGTERM);
+		return -1;
+	}
 
 	/*
 	 * Enable counters and exec the command:
@@ -587,7 +603,8 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		status = run_perf_stat(argc, argv);
 	}
 
-	print_stat(argc, argv);
+	if (status != -1)
+		print_stat(argc, argv);
 
 	return status;
 }
-- 
1.6.2.5

