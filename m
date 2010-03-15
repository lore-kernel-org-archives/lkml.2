Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965100Ab0COOrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 10:47:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:53622 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965089Ab0COOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 10:47:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Eric B Munson <ebmunson@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf record: Enable the enable_on_exec flag if record forks the target
Date: Mon, 15 Mar 2010 11:46:57 -0300
Message-Id: <1268664418-28328-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric B Munson <ebmunson@us.ibm.com>

When forking its target, perf record can capture data from before the target
application is started.  Perf stat uses the enable_on_exec flag in the event
attributes to keep from displaying events from before the target program
starts, this patch adds the same functionality to perf record when it is will
fork the target process.

Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

