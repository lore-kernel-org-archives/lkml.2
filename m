Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab2LQNJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 08:09:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab2LQNJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 08:09:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 3/3] perf tests: Add event parsing test for '*:*' tracepoints
Date: Mon, 17 Dec 2012 14:08:38 +0100
Message-Id: <1355749718-4355-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
References: <1355749718-4355-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding event parsing test for '*:*' tracepoints. Checking the
count matches all the tracepoints available plus current
standard tracepoint perf_event_attr check.

This test exposes warnings from traceevent lib about not being
able to parse some tracepoints' format data. Exposing these
messages in the automated test suite will probably speed up
the fix ;-)

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
 tools/perf/tests/parse-events.c | 62 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 294ffdd..e7eb708 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -3,6 +3,7 @@
 #include "evsel.h"
 #include "evlist.h"
 #include "sysfs.h"
+#include "debugfs.h"
 #include "tests.h"
 #include <linux/hw_breakpoint.h>
 
@@ -782,6 +783,63 @@ static int test__group5(struct perf_evlist *evlist __maybe_unused)
 	return 0;
 }
 
+static int count_tracepoints(void)
+{
+	char events_path[PATH_MAX];
+	struct dirent *events_ent;
+	DIR *events_dir;
+	int cnt = 0;
+
+	scnprintf(events_path, PATH_MAX, "%s/tracing/events",
+		  debugfs_find_mountpoint());
+
+	events_dir = opendir(events_path);
+
+	TEST_ASSERT_VAL("Can't open events dir", events_dir);
+
+	while ((events_ent = readdir(events_dir))) {
+		char sys_path[PATH_MAX];
+		struct dirent *sys_ent;
+		DIR *sys_dir;
+
+		if (!strcmp(events_ent->d_name, ".")
+		    || !strcmp(events_ent->d_name, "..")
+		    || !strcmp(events_ent->d_name, "enable")
+		    || !strcmp(events_ent->d_name, "header_event")
+		    || !strcmp(events_ent->d_name, "header_page"))
+			continue;
+
+		scnprintf(sys_path, PATH_MAX, "%s/%s",
+			  events_path, events_ent->d_name);
+
+		sys_dir = opendir(sys_path);
+		TEST_ASSERT_VAL("Can't open sys dir", sys_dir);
+
+		while ((sys_ent = readdir(sys_dir))) {
+			if (!strcmp(sys_ent->d_name, ".")
+			    || !strcmp(sys_ent->d_name, "..")
+			    || !strcmp(sys_ent->d_name, "enable")
+			    || !strcmp(sys_ent->d_name, "filter"))
+				continue;
+
+			cnt++;
+		}
+
+		closedir(sys_dir);
+	}
+
+	closedir(events_dir);
+	return cnt;
+}
+
+static int test__all_tracepoints(struct perf_evlist *evlist)
+{
+	TEST_ASSERT_VAL("wrong events count",
+			count_tracepoints() == evlist->nr_entries);
+
+	return test__checkevent_tracepoint_multi(evlist);
+}
+
 struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -921,6 +979,10 @@ static struct test__event_st test__events[] = {
 		.name  = "{cycles,instructions}:G,{cycles:G,instructions:G},cycles",
 		.check = test__group5,
 	},
+	[33] = {
+		.name  = "*:*",
+		.check = test__all_tracepoints,
+	},
 };
 
 static struct test__event_st test__events_pmu[] = {
-- 
1.7.11.7

