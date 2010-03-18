Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990Ab0CRJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 05:29:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:3674 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751847Ab0CRJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 05:29:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,265,1267430400"; 
   d="scan'208";a="781871075"
Subject: [PATCH 2/3] perf events: Enable counters only when kernel is
 execing the subcommand of 'perf record'
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 18 Mar 2010 17:31:04 +0800
Message-Id: <1268904664.2813.171.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>

'perf record' starts counters before subcommand is execed, so the statistics is
not precise because it includes data of some preparation steps. I fix it with the
patch.

In addition, Change the condition to fork/exec subcommand. If there is a subcommand
parameter, perf always fork/exec it. The usage example is:
#perf record -f -a sleep 10

So this command could collect statistics for 10 seconds precisely. User
still could stop it by CTRL+C. Without the new capability, user could only
input CTRL+C to stop it without precise time clock.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0317/tools/perf/builtin-record.c linux-2.6_tip0317_fixrecord/tools/perf/builtin-record.c
--- linux-2.6_tip0317/tools/perf/builtin-record.c	2010-03-18 09:04:40.942263175 +0800
+++ linux-2.6_tip0317_fixrecord/tools/perf/builtin-record.c	2010-03-18 13:33:24.254359348 +0800
@@ -225,7 +225,7 @@ static struct perf_header_attr *get_head
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid, bool forks)
+static void create_counter(int counter, int cpu, pid_t pid)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
@@ -275,10 +275,10 @@ static void create_counter(int counter, 
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
@@ -425,7 +423,7 @@ static int __cmd_record(int argc, const 
 	int err;
 	unsigned long waking = 0;
 	int child_ready_pipe[2], go_pipe[2];
-	const bool forks = target_pid == -1 && argc > 0;
+	const bool forks = argc > 0;
 	char buf;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
@@ -496,13 +494,13 @@ static int __cmd_record(int argc, const 
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
@@ -531,11 +529,6 @@ static int __cmd_record(int argc, const 
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
@@ -548,13 +541,17 @@ static int __cmd_record(int argc, const 
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


