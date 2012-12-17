Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab2LQNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:09:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab2LQNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:09:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/3] perf tools: Add support for wildcard in tracepoint system name
Date: Mon, 17 Dec 2012 14:08:37 +0100
Message-Id: <1355749718-4355-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
References: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support for wildcards '*?" in the tracepoint system part.

It's now possible to open all available tracepoints like:

  # perf stat -e '*:*' ls

You might need to increase limit for open files via ulimit.

If ftrace events tracepoints are configured in, the record command
fails on above event selection because of them. The stat command
disables counters that fails to open, the record command fails
completely. We probably want to be smarter here.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/util/parse-events.c | 51 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 46 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d64ff29..626c120 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -380,8 +380,8 @@ static int add_tracepoint(struct list_head **listp, int *idx,
 	return 0;
 }
 
-static int add_tracepoint_multi(struct list_head **list, int *idx,
-				char *sys_name, char *evt_name)
+static int add_tracepoint_multi_event(struct list_head **list, int *idx,
+				      char *sys_name, char *evt_name)
 {
 	char evt_path[MAXPATHLEN];
 	struct dirent *evt_ent;
@@ -412,6 +412,46 @@ static int add_tracepoint_multi(struct list_head **list, int *idx,
 	return ret;
 }
 
+static int add_tracepoint_event(struct list_head **list, int *idx,
+				char *sys_name, char *evt_name)
+{
+	return strpbrk(evt_name, "*?") ?
+	       add_tracepoint_multi_event(list, idx, sys_name, evt_name) :
+	       add_tracepoint(list, idx, sys_name, evt_name);
+}
+
+static int add_tracepoint_multi_sys(struct list_head **list, int *idx,
+				    char *sys_name, char *evt_name)
+{
+	struct dirent *events_ent;
+	DIR *events_dir;
+	int ret = 0;
+
+	events_dir = opendir(tracing_events_path);
+	if (!events_dir) {
+		perror("Can't open event dir");
+		return -1;
+	}
+
+	while (!ret && (events_ent = readdir(events_dir))) {
+		if (!strcmp(events_ent->d_name, ".")
+		    || !strcmp(events_ent->d_name, "..")
+		    || !strcmp(events_ent->d_name, "enable")
+		    || !strcmp(events_ent->d_name, "header_event")
+		    || !strcmp(events_ent->d_name, "header_page"))
+			continue;
+
+		if (!strglobmatch(events_ent->d_name, sys_name))
+			continue;
+
+		ret = add_tracepoint_event(list, idx, events_ent->d_name,
+					   evt_name);
+	}
+
+	closedir(events_dir);
+	return ret;
+}
+
 int parse_events_add_tracepoint(struct list_head **list, int *idx,
 				char *sys, char *event)
 {
@@ -421,9 +461,10 @@ int parse_events_add_tracepoint(struct list_head **list, int *idx,
 	if (ret)
 		return ret;
 
-	return strpbrk(event, "*?") ?
-	       add_tracepoint_multi(list, idx, sys, event) :
-	       add_tracepoint(list, idx, sys, event);
+	if (strpbrk(sys, "*?"))
+		return add_tracepoint_multi_sys(list, idx, sys, event);
+	else
+		return add_tracepoint_event(list, idx, sys, event);
 }
 
 static int
-- 
1.7.11.7

