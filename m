Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab0KUNo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 08:44:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:60589 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab0KUNo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 08:44:27 -0500
Date: Sun, 21 Nov 2010 13:43:48 GMT
From: tip-bot for Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, ianmunsi@au1.ibm.com,
        hpa@zytor.com, mingo@redhat.com, michaele@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, ianmunsi@au1.ibm.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        michaele@au1.ibm.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
References: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Change and clean up sys_perf_event_open error handling
Message-ID: <tip-d9cf837ef9629ab34167bd6fc0141383ddb8813a@git.kernel.org>
Git-Commit-ID: d9cf837ef9629ab34167bd6fc0141383ddb8813a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 21 Nov 2010 13:43:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9cf837ef9629ab34167bd6fc0141383ddb8813a
Gitweb:     http://git.kernel.org/tip/d9cf837ef9629ab34167bd6fc0141383ddb8813a
Author:     Corey Ashford <cjashfor@linux.vnet.ibm.com>
AuthorDate: Fri, 19 Nov 2010 17:37:24 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 20 Nov 2010 13:04:15 -0200

perf stat: Change and clean up sys_perf_event_open error handling

This patch makes several changes to "perf stat":

- "perf stat" will no longer go ahead and run the application when one or
more of the specified events could not be opened.
- Use error() and die() instead of pr_err() so that the output is more
consistent with "perf top" and "perf record".
- Handle permission errors in a more robust way, and in a similar way to
"perf record" and "perf top".

In addition, the sys_perf_event_open() error handling of "perf top" and "perf
record" is made more consistent and adds the following phrase when an event
doesn't open (with something ther than an access or permission error):

"/bin/dmesg may provide additional information."

This is added because kernel code doesn't have a good way of expressing
detailed errors to user space, so its only avenue is to use printk's.  However,
many users may not think of looking at dmesg to find out why an event is being
rejected.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <fweisbec@gmail.com>
Cc: Ian Munsie <ianmunsi@au1.ibm.com>
Cc: Michael Ellerman <michaele@au1.ibm.com>
LKML-Reference: <1290217044-26293-1-git-send-email-cjashfor@linux.vnet.ibm.com>
Signed-off-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
index b3e568f..970a7f2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -153,9 +153,9 @@ struct stats			walltime_nsecs_stats;
 	 attrs[counter].config == PERF_COUNT_##c)
 
 #define ERR_PERF_OPEN \
-"Error: counter %d, sys_perf_event_open() syscall returned with %d (%s)\n"
+"counter %d, sys_perf_event_open() syscall returned with %d (%s).  /bin/dmesg may provide additional information."
 
-static int create_perf_stat_counter(int counter)
+static int create_perf_stat_counter(int counter, bool *perm_err)
 {
 	struct perf_event_attr *attr = attrs + counter;
 	int thread;
@@ -171,11 +171,14 @@ static int create_perf_stat_counter(int counter)
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
@@ -186,12 +189,15 @@ static int create_perf_stat_counter(int counter)
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
 
@@ -332,6 +338,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 	int status = 0;
 	int counter, ncreated = 0;
 	int child_ready_pipe[2], go_pipe[2];
+	bool perm_err = false;
 	const bool forks = (argc > 0);
 	char buf;
 
@@ -390,12 +397,15 @@ static int run_perf_stat(int argc __used, const char **argv)
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
