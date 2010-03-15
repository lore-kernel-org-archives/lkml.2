Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965175Ab0COPQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:16:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:57192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965070Ab0COPQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:16:28 -0400
Date: Mon, 15 Mar 2010 15:15:35 GMT
From: tip-bot for Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, ebmunson@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, ebmunson@us.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1268664418-28328-1-git-send-email-acme@infradead.org>
References: <1268664418-28328-1-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf record: Enable the enable_on_exec flag if record forks the target
Message-ID: <tip-bedbfdea31daf3880745001d56450c683959ee7e@git.kernel.org>
Git-Commit-ID: bedbfdea31daf3880745001d56450c683959ee7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 15 Mar 2010 15:15:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bedbfdea31daf3880745001d56450c683959ee7e
Gitweb:     http://git.kernel.org/tip/bedbfdea31daf3880745001d56450c683959ee7e
Author:     Eric B Munson <ebmunson@us.ibm.com>
AuthorDate: Mon, 15 Mar 2010 11:46:57 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 15 Mar 2010 16:08:22 +0100

perf record: Enable the enable_on_exec flag if record forks the target

When forking its target, perf record can capture data from
before the target application is started.  Perf stat uses the
enable_on_exec flag in the event attributes to keep from
displaying events from before the target program starts, this
patch adds the same functionality to perf record when it is will
fork the target process.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <1268664418-28328-1-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index bed175d..962cdbf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -225,7 +225,7 @@ static struct perf_header_attr *get_header_attr(struct perf_event_attr *a, int n
 	return h_attr;
 }
 
-static void create_counter(int counter, int cpu, pid_t pid)
+static void create_counter(int counter, int cpu, pid_t pid, bool forks)
 {
 	char *filter = filters[counter];
 	struct perf_event_attr *attr = attrs + counter;
@@ -277,6 +277,9 @@ static void create_counter(int counter, int cpu, pid_t pid)
 	attr->inherit		= inherit;
 	attr->disabled		= 1;
 
+	if (forks)
+		attr->enable_on_exec = 1;
+
 try_again:
 	fd[nr_cpu][counter] = sys_perf_event_open(attr, pid, cpu, group_fd, 0);
 
@@ -381,13 +384,13 @@ try_again:
 	ioctl(fd[nr_cpu][counter], PERF_EVENT_IOC_ENABLE);
 }
 
-static void open_counters(int cpu, pid_t pid)
+static void open_counters(int cpu, pid_t pid, bool forks)
 {
 	int counter;
 
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
-		create_counter(counter, cpu, pid);
+		create_counter(counter, cpu, pid, forks);
 
 	nr_cpu++;
 }
@@ -547,11 +550,11 @@ static int __cmd_record(int argc, const char **argv)
 
 
 	if ((!system_wide && !inherit) || profile_cpu != -1) {
-		open_counters(profile_cpu, target_pid);
+		open_counters(profile_cpu, target_pid, forks);
 	} else {
 		nr_cpus = read_cpu_map();
 		for (i = 0; i < nr_cpus; i++)
-			open_counters(cpumap[i], target_pid);
+			open_counters(cpumap[i], target_pid, forks);
 	}
 
 	if (file_new) {
