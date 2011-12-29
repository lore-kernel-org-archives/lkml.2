Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1L2UsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:48:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1L2UsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:48:11 -0500
Date: Thu, 29 Dec 2011 12:47:43 -0800
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-f5faf726184a6a5ca1735f610cb97e509fce33e2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1324578603-12762-3-git-send-email-dsahern@gmail.com>
References: <1324578603-12762-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Look up thread names for system wide profiling
Git-Commit-ID: f5faf726184a6a5ca1735f610cb97e509fce33e2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:47:49 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5faf726184a6a5ca1735f610cb97e509fce33e2
Gitweb:     http://git.kernel.org/tip/f5faf726184a6a5ca1735f610cb97e509fce33e2
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 22 Dec 2011 11:30:02 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 23 Dec 2011 16:33:57 -0200

perf tools: Look up thread names for system wide profiling

This handles multithreaded processes with named threads when doing
system wide profiling: the comm for each thread is looked up allowing
them to be different from the thread group leader.

v2:
- fixed sizeof arg to perf_event__get_comm_tgid

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1324578603-12762-3-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c |   75 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index a578726..73ddaf0 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -43,37 +43,27 @@ static struct perf_sample synth_sample = {
 	.period	   = 1,
 };
 
-static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
-					 union perf_event *event, pid_t pid,
-					 int full, perf_event__handler_t process,
-					 struct machine *machine)
+static pid_t perf_event__get_comm_tgid(pid_t pid, char *comm, size_t len)
 {
 	char filename[PATH_MAX];
 	char bf[BUFSIZ];
 	FILE *fp;
 	size_t size = 0;
-	DIR *tasks;
-	struct dirent dirent, *next;
-	pid_t tgid = 0;
+	pid_t tgid = -1;
 
 	snprintf(filename, sizeof(filename), "/proc/%d/status", pid);
 
 	fp = fopen(filename, "r");
 	if (fp == NULL) {
-out_race:
-		/*
-		 * We raced with a task exiting - just return:
-		 */
 		pr_debug("couldn't open %s\n", filename);
 		return 0;
 	}
 
-	memset(&event->comm, 0, sizeof(event->comm));
-
-	while (!event->comm.comm[0] || !event->comm.pid) {
+	while (!comm[0] || (tgid < 0)) {
 		if (fgets(bf, sizeof(bf), fp) == NULL) {
-			pr_warning("couldn't get COMM and pgid, malformed %s\n", filename);
-			goto out;
+			pr_warning("couldn't get COMM and pgid, malformed %s\n",
+				   filename);
+			break;
 		}
 
 		if (memcmp(bf, "Name:", 5) == 0) {
@@ -81,16 +71,46 @@ out_race:
 			while (*name && isspace(*name))
 				++name;
 			size = strlen(name) - 1;
-			memcpy(event->comm.comm, name, size++);
+			if (size >= len)
+				size = len - 1;
+			memcpy(comm, name, size);
+
 		} else if (memcmp(bf, "Tgid:", 5) == 0) {
 			char *tgids = bf + 5;
 			while (*tgids && isspace(*tgids))
 				++tgids;
-			tgid = event->comm.pid = atoi(tgids);
+			tgid = atoi(tgids);
 		}
 	}
 
+	fclose(fp);
+
+	return tgid;
+}
+
+static pid_t perf_event__synthesize_comm(struct perf_tool *tool,
+					 union perf_event *event, pid_t pid,
+					 int full,
+					 perf_event__handler_t process,
+					 struct machine *machine)
+{
+	char filename[PATH_MAX];
+	size_t size;
+	DIR *tasks;
+	struct dirent dirent, *next;
+	pid_t tgid;
+
+	memset(&event->comm, 0, sizeof(event->comm));
+
+	tgid = perf_event__get_comm_tgid(pid, event->comm.comm,
+					 sizeof(event->comm.comm));
+	if (tgid < 0)
+		goto out;
+
+	event->comm.pid = tgid;
 	event->comm.header.type = PERF_RECORD_COMM;
+
+	size = strlen(event->comm.comm) + 1;
 	size = ALIGN(size, sizeof(u64));
 	memset(event->comm.comm + size, 0, machine->id_hdr_size);
 	event->comm.header.size = (sizeof(event->comm) -
@@ -106,8 +126,10 @@ out_race:
 	snprintf(filename, sizeof(filename), "/proc/%d/task", pid);
 
 	tasks = opendir(filename);
-	if (tasks == NULL)
-		goto out_race;
+	if (tasks == NULL) {
+		pr_debug("couldn't open %s\n", filename);
+		return 0;
+	}
 
 	while (!readdir_r(tasks, &dirent, &next) && next) {
 		char *end;
@@ -115,6 +137,17 @@ out_race:
 		if (*end)
 			continue;
 
+		/* already have tgid; jut want to update the comm */
+		(void) perf_event__get_comm_tgid(pid, event->comm.comm,
+					 sizeof(event->comm.comm));
+
+		size = strlen(event->comm.comm) + 1;
+		size = ALIGN(size, sizeof(u64));
+		memset(event->comm.comm + size, 0, machine->id_hdr_size);
+		event->comm.header.size = (sizeof(event->comm) -
+					  (sizeof(event->comm.comm) - size) +
+					  machine->id_hdr_size);
+
 		event->comm.tid = pid;
 
 		process(tool, event, &synth_sample, machine);
@@ -122,8 +155,6 @@ out_race:
 
 	closedir(tasks);
 out:
-	fclose(fp);
-
 	return tgid;
 }
 
