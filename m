Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab1LIRn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 12:43:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab1LIRny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 12:43:54 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/3] perf: look up thread names for system wide profiling
Date: Fri,  9 Dec 2011 10:43:38 -0700
Message-Id: <1323452619-10374-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
References: <1323452619-10374-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This handles multithreaded processes with named threads when
doing system wide profiling: the comm for each thread is
looked up allowing them to be different from the thread
group leader.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/event.c |   75 +++++++++++++++++++++++++++++++++--------------
 1 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index c424324..a886bfc 100644
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
+					 sizeof(event->comm));
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
 
-- 
1.7.7.3

