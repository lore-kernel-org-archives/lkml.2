Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab2JHRSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39941 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2JHRSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:16 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 03/12] perf evlist: add initialzation function for tracepoints
Date: Mon,  8 Oct 2012 11:17:27 -0600
Message-Id: <1349716656-48165-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handles initializations typically done as part of processing the file
header and HEADER_TRACING_DATA event.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/evlist.c |   27 +++++++++++++++++++++++++++
 tools/perf/util/evlist.h |    3 +++
 2 files changed, 30 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7fff06f..d77135b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -14,6 +14,7 @@
 #include "target.h"
 #include "evlist.h"
 #include "evsel.h"
+#include "trace-event.h"
 #include <unistd.h>
 
 #include "parse-events.h"
@@ -228,6 +229,32 @@ int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 	return 0;
 }
 
+int perf_evlist__trace_init(struct perf_evlist *evlist,
+			    struct perf_session *session)
+{
+	struct tracing_data *tdata;
+	char temp_file[] = "/tmp/perf-XXXXXXXX";
+	int fd;
+
+	fd = mkstemp(temp_file);
+	if (fd < 0) {
+		pr_err("mkstemp failed\n");
+		return -1;
+	}
+	unlink(temp_file);
+
+	tdata = tracing_data_get(&evlist->entries, fd, false);
+	if (!tdata)
+		return -1;
+
+	lseek(fd, 0, SEEK_SET);
+	(void) trace_report(fd, &session->pevent, false);
+	tracing_data_put(tdata);
+
+	return perf_evlist__prepare_tracepoint_events(evlist, session->pevent);
+}
+
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 9959954..e375a18 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -8,6 +8,7 @@
 #include "event-parse.h"
 #include "evsel.h"
 #include "util.h"
+#include "session.h"
 #include <unistd.h>
 
 struct pollfd;
@@ -60,6 +61,8 @@ int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char * const tracepoints[],
 				 size_t nr_tracepoints);
+int perf_evlist__trace_init(struct perf_evlist *evlist,
+			    struct perf_session *session);
 
 #define perf_evlist__add_default_attrs(evlist, array) \
 	__perf_evlist__add_default_attrs(evlist, array, ARRAY_SIZE(array))
-- 
1.7.10.1

