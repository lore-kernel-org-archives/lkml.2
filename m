Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1ARBLB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:11:01 -0500
Received: from canuck.infradead.org ([134.117.69.58]:59431 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab1ARBLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:11:00 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Franck Bui-Huu <vagabon.xyz@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf tools: Fix tracepoint id to string perf.data header table
Date: Mon, 17 Jan 2011 23:10:50 -0200
Message-Id: <1295313050-10353-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295313050-10353-1-git-send-email-acme@infradead.org>
References: <1295313050-10353-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It was broken by f006d25 that passed just the event name, not the complete
sys:event that it expected to open the /sys/.../sys/sys:event/id file to get
the id.

Fix it by moving it to after parse_events in cmd_record, as at that point
we can just traverse the evsel_list and use evsel->attr.config +
event_name(evsel) instead of re-opening the /id file.

Reported-by: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Han Pingtian <phan@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20110117202801.GG2085@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    2 ++
 tools/perf/util/parse-events.c |   29 -----------------------------
 2 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index df6064a..fcd29e8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -936,6 +936,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	list_for_each_entry(pos, &evsel_list, node) {
 		if (perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
 			goto out_free_fd;
+		if (perf_header__push_event(pos->attr.config, event_name(pos)))
+			goto out_free_fd;
 	}
 	event_array = malloc((sizeof(struct pollfd) * MAX_NR_CPUS *
 			      MAX_COUNTERS * threads->nr));
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 1f4cfe5..bc2732e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -490,32 +490,6 @@ parse_multiple_tracepoint_event(char *sys_name, const char *evt_exp,
 	return EVT_HANDLED_ALL;
 }
 
-static int store_event_type(const char *orgname)
-{
-	char filename[PATH_MAX], *c;
-	FILE *file;
-	int id, n;
-
-	sprintf(filename, "%s/", debugfs_path);
-	strncat(filename, orgname, strlen(orgname));
-	strcat(filename, "/id");
-
-	c = strchr(filename, ':');
-	if (c)
-		*c = '/';
-
-	file = fopen(filename, "r");
-	if (!file)
-		return 0;
-	n = fscanf(file, "%i", &id);
-	fclose(file);
-	if (n < 1) {
-		pr_err("cannot store event ID\n");
-		return -EINVAL;
-	}
-	return perf_header__push_event(id, orgname);
-}
-
 static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_event_attr *attr)
 {
@@ -559,9 +533,6 @@ static enum event_result parse_tracepoint_event(const char **strp,
 		return parse_multiple_tracepoint_event(sys_name, evt_name,
 						       flags);
 	} else {
-		if (store_event_type(evt_name) < 0)
-			return EVT_FAILED;
-
 		return parse_single_tracepoint_event(sys_name, evt_name,
 						     evt_length, attr, strp);
 	}
-- 
1.6.2.5

