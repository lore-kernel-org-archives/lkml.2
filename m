Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab2JHRSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 13:18:17 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39227 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab2JHRSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 13:18:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 02/12] perf evlist: move tracepoint processing code to evlist.c
Date: Mon,  8 Oct 2012 11:17:26 -0600
Message-Id: <1349716656-48165-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code move only; no functional changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/util/evlist.c  |   39 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evlist.h  |    4 ++++
 tools/perf/util/header.c  |   39 ---------------------------------------
 tools/perf/util/session.c |    1 -
 4 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a409b25..7fff06f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -189,6 +189,45 @@ int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 	return perf_evlist__add_attrs(evlist, attrs, nr_attrs);
 }
 
+static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
+						struct pevent *pevent)
+{
+	struct event_format *event;
+	char bf[128];
+
+	/* already prepared */
+	if (evsel->tp_format)
+		return 0;
+
+	event = pevent_find_event(pevent, evsel->attr.config);
+	if (event == NULL)
+		return -1;
+
+	if (!evsel->name) {
+		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+		evsel->name = strdup(bf);
+		if (evsel->name == NULL)
+			return -1;
+	}
+
+	evsel->tp_format = event;
+	return 0;
+}
+
+int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+						  struct pevent *pevent)
+{
+	struct perf_evsel *pos;
+
+	list_for_each_entry(pos, &evlist->entries, node) {
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__prepare_tracepoint_event(pos, pevent))
+			return -1;
+	}
+
+	return 0;
+}
+
 static int trace_event__id(const char *evname)
 {
 	char *filename, *colon;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index be85147..9959954 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -5,6 +5,7 @@
 #include <stdio.h>
 #include "../perf.h"
 #include "event.h"
+#include "event-parse.h"
 #include "evsel.h"
 #include "util.h"
 #include <unistd.h>
@@ -53,6 +54,9 @@ void perf_evlist__add(struct perf_evlist *evlist, struct perf_evsel *entry);
 int perf_evlist__add_default(struct perf_evlist *evlist);
 int __perf_evlist__add_default_attrs(struct perf_evlist *evlist,
 				     struct perf_event_attr *attrs, size_t nr_attrs);
+int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+					   struct pevent *pevent);
+
 int perf_evlist__add_tracepoints(struct perf_evlist *evlist,
 				 const char * const tracepoints[],
 				 size_t nr_tracepoints);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..42f8ec9 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2553,45 +2553,6 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
-static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
-						struct pevent *pevent)
-{
-	struct event_format *event;
-	char bf[128];
-
-	/* already prepared */
-	if (evsel->tp_format)
-		return 0;
-
-	event = pevent_find_event(pevent, evsel->attr.config);
-	if (event == NULL)
-		return -1;
-
-	if (!evsel->name) {
-		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
-		evsel->name = strdup(bf);
-		if (evsel->name == NULL)
-			return -1;
-	}
-
-	evsel->tp_format = event;
-	return 0;
-}
-
-static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
-						  struct pevent *pevent)
-{
-	struct perf_evsel *pos;
-
-	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
-		    perf_evsel__prepare_tracepoint_event(pos, pevent))
-			return -1;
-	}
-
-	return 0;
-}
-
 int perf_session__read_header(struct perf_session *session, int fd)
 {
 	struct perf_header *header = &session->header;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 15abe40..23d2ea3 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -14,7 +14,6 @@
 #include "sort.h"
 #include "util.h"
 #include "cpumap.h"
-#include "event-parse.h"
 #include "perf_regs.h"
 #include "unwind.h"
 #include "vdso.h"
-- 
1.7.10.1

