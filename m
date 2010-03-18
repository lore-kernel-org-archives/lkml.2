Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab0CROgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:36:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42910 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab0CROgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:36:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       <zhiteng.huang@intel.com>, Zachary Amsden <zamsden@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf record: Enable counters only when kernel is execing subcommand
Date: Thu, 18 Mar 2010 11:36:04 -0300
Message-Id: <1268922965-14774-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1268922965-14774-1-git-send-email-acme@infradead.org>
References: <1268922965-14774-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

'perf record' starts counters before subcommand is execed, so the
statistics is not precise because it includes data of some preparation
steps. I fix it with the patch.

In addition, Change the condition to fork/exec subcommand. If there is a
subcommand parameter, perf always fork/exec it. The usage example is:

 # perf record -f -a sleep 10

So this command could collect statistics for 10 seconds precisely. User
still could stop it by CTRL+C. Without the new capability, user could
only input CTRL+C to stop it without precise time clock.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Sheng Yang <sheng@linux.intel.com>
Cc: oerg Roedel <joro@8bytes.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: <zhiteng.huang@intel.com>
Cc: Zachary Amsden <zamsden@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   33 +++++++++++++++------------------
 1 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 962cdbf..e2b35ad 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -225,7 +225,7 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid, bool forks)
+static void create_counter(int counter, int cpu, pid_t pid)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
@@ -275,10 +275,10 @@ static void create_counter(int counter, int cpu, pid_t pid, bool forks)
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= inherit;
-	attr->disabled		= 1;
-
-	if (forks)
+	if (target_pid == -1 && !system_wide) {
+		attr->disabled = 1;
 		attr->enable_on_exec = 1;
+	}
 
 try_again:
 	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
@@ -380,17 +380,15 @@ try_again:
 			exit(-1);
 		}
 	}
-
-	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
 }
 
-static void open_counters(int cpu, pid_t pid, bool forks)
+static void open_counters(int cpu, pid_t pid)
 {
 	int counter;
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid, forks);
+		create_counter(counter, cpu, pid);
 
 	nr_cpu++;
 }
@@ -425,7 +423,7 @@ static int __cmd_record(int argc, const char **argv)
 	int err;
 	unsigned long waking = 0;
 	int child_ready_pipe[2], go_pipe[2];
-	const bool forks = target_pid == -1 && argc > 0;
+	const bool forks = argc > 0;
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -496,13 +494,13 @@ static int __cmd_record(int argc, const char **argv)
 	atexit(atexit_header);
 
 	if (forks) {
-		pid = fork();
+		child_pid = fork();
 		if (pid < 0) {
 			perror("failed to fork");
 			exit(-1);
 		}
 
-		if (!pid) {
+		if (!child_pid) {
 			close(child_ready_pipe[0]);
 			close(go_pipe[1]);
 			fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
@@ -531,11 +529,6 @@ static int __cmd_record(int argc, const char **argv)
 			exit(-1);
 		}
 
-		child_pid = pid;
-
-		if (!system_wide)
-			target_pid = pid;
-
 		close(child_ready_pipe[1]);
 		close(go_pipe[0]);
 		/*
@@ -548,13 +541,17 @@ static int __cmd_record(int argc, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	if (forks && target_pid == -1 && !system_wide)
+		pid = child_pid;
+	else
+		pid = target_pid;
 
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu, target_pid, forks);
+		open_counters(profile_cpu, pid);
 	} else {
 		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(cpumap[i], target_pid, forks);
+			open_counters(cpumap[i], pid);
 	}
 
 	if (file_new) {
-- 
1.6.2.5

