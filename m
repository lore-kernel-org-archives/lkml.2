Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab0KTBmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 20:42:38 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47308 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756431Ab0KTBmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 20:42:36 -0500
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, acme@infradead.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com
Cc: michaele@au1.ibm.com, ianmunsi@au1.ibm.com, cjashfor@linux.vnet.ibm.com
Subject: [PATCH] perf: Change and clean up sys_perf_event_open error handling
Date: Fri, 19 Nov 2010 17:37:24 -0800
Message-Id: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes several changes to "perf stat":

- "perf stat" will no longer go ahead and run the application when one or
more of the specified events could not be opened.
- Use error() and die() instead of pr_err() so that the output is more
consistent with "perf top" and "perf record".
- Handle permission errors in a more robust way, and in a similar way to
"perf record" and "perf top".

In addition, the sys_perf_event_open() error handling of "perf top" and
"perf record" is made more consistent and adds the following phrase when an
event doesn't open (with something ther than an access or permission
error):

"/bin/dmesg may provide additional information."

This is added because kernel code doesn't have a good way of expressing
detailed errors to user space, so its only avenue is to use printk's.
However, many users may not think of looking at dmesg to find out why an
event is being rejected.

Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-stat.c   |   38 ++++++++++++++++++++++++--------------
 tools/perf/builtin-top.c    |    6 ++++--
 3 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 93bd2ff..d9dd478 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -326,7 +326,7 @@ try_again:
 				goto try_again;
 			}
 			printf("\n");
-			error("perfcounter syscall returned with %d (%s)\n",
+			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 					fd[nr_cpu][counter][thread_index], strerror(err));
 
 #if defined(__i386__) || defined(__x86_64__)
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index a6b4d44..8b9afa6 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -146,9 +146,9 @@ struct stats			runtime_branches_stats;
 	 attrs[counter].config == PERF_COUNT_##c)
 
 #define ERR_PERF_OPEN \
-"Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
+"counter %d, sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information."
 
-static int create_perf_stat_counter(int counter)
+static int create_perf_stat_counter(int counter, bool *perm_err)
 {
 	struct perf_event_attr *attr = attrs + counter;
 	int thread;
@@ -164,11 +164,14 @@ static int create_perf_stat_counter(int counter)
 		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter][0] = sys_perf_event_open(attr,
 					-1, cpumap[cpu], -1, 0);
-			if (fd[cpu][counter][0] < 0)
-				pr_debug(ERR_PERF_OPEN, counter,
+			if (fd[cpu][counter][0] < 0) {
+				if (errno == EPERM || errno == EACCES)
+					*perm_err = true;
+				error(ERR_PERF_OPEN, counter,
 					 fd[cpu][counter][0], strerror(errno));
-			else
+			} else {
 				++ncreated;
+			}
 		}
 	} else {
 		attr->inherit = !no_inherit;
@@ -179,12 +182,15 @@ static int create_perf_stat_counter(int counter)
 		for (thread = 0; thread < thread_num; thread++) {
 			fd[0][counter][thread] = sys_perf_event_open(attr,
 				all_tids[thread], -1, -1, 0);
-			if (fd[0][counter][thread] < 0)
-				pr_debug(ERR_PERF_OPEN, counter,
+			if (fd[0][counter][thread] < 0) {
+				if (errno == EPERM || errno == EACCES)
+					*perm_err = true;
+				error(ERR_PERF_OPEN, counter,
 					 fd[0][counter][thread],
 					 strerror(errno));
-			else
+			} else {
 				++ncreated;
+			}
 		}
 	}
 
@@ -277,6 +283,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	int status = 0;
 	int counter, ncreated = 0;
 	int child_ready_pipe[2], go_pipe[2];
+	bool perm_err = false;
 	const bool forks = (argc > 0);
 	char buf;
 
@@ -335,12 +342,15 @@ static int run_perf_stat(int argc __used, const char **argv)
 	}
 
 	for (counter = 0; counter < nr_counters; counter++)
-		ncreated += create_perf_stat_counter(counter);
-
-	if (ncreated == 0) {
-		pr_err("No permission to collect %sstats.\n"
-		       "Consider tweaking /proc/sys/kernel/perf_event_paranoid.\n",
-		       system_wide ? "system-wide " : "");
+		ncreated += create_perf_stat_counter(counter, &perm_err);
+
+	if (ncreated < nr_counters) {
+		if (perm_err)
+			error("You may not have permission to collect %sstats.\n"
+			      "\t Consider tweaking"
+			      " /proc/sys/kernel/perf_event_paranoid or running as root.",
+			      system_wide ? "system-wide " : "");
+		die("Not all events could be opened.\n");
 		if (child_pid != -1)
 			kill(child_pid, SIGTERM);
 		return -1;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index dd62580..3d2b47d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1214,7 +1214,9 @@ try_again:
 			int err = errno;
 
 			if (err == EPERM || err == EACCES)
-				die("No permission - are you root?\n");
+				die("Permission error - are you root?\n"
+					"\t Consider tweaking"
+					" /proc/sys/kernel/perf_event_paranoid.\n");
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
@@ -1231,7 +1233,7 @@ try_again:
 				goto try_again;
 			}
 			printf("\n");
-			error("perfcounter syscall returned with %d (%s)\n",
+			error("sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information.\n",
 					fd[i][counter][thread_index], strerror(err));
 			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			exit(-1);
-- 
1.7.0.4

