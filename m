Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759607Ab2IFTbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40929 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259Ab2IFTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/8] perf header: Prepare tracepoint events regardless of name
Date: Thu,  6 Sep 2012 16:31:16 -0300
Message-Id: <1346959881-22427-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf_evlist__set_tracepoint_names is a misnomer because it finds
and sets correspoding event_format in addition to the name.  So skipping
it when a event has set name already caused a trouble.

Rename it and set name only a event doesn't have one.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346897446-16569-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8b0b873..d07bc13 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2295,33 +2295,39 @@ static int read_attr(int fd, struct perf_header *ph,
 	return ret <= 0 ? -1 : 0;
 }
 
-static int perf_evsel__set_tracepoint_name(struct perf_evsel *evsel,
-					   struct pevent *pevent)
+static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
+						struct pevent *pevent)
 {
-	struct event_format *event = pevent_find_event(pevent,
-						       evsel->attr.config);
+	struct event_format *event;
 	char bf[128];
 
+	/* already prepared */
+	if (evsel->tp_format)
+		return 0;
+
+	event = pevent_find_event(pevent, evsel->attr.config);
 	if (event == NULL)
 		return -1;
 
-	snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
-	evsel->name = strdup(bf);
-	if (evsel->name == NULL)
-		return -1;
+	if (!evsel->name) {
+		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
+		evsel->name = strdup(bf);
+		if (evsel->name == NULL)
+			return -1;
+	}
 
 	evsel->tp_format = event;
 	return 0;
 }
 
-static int perf_evlist__set_tracepoint_names(struct perf_evlist *evlist,
-					     struct pevent *pevent)
+static int perf_evlist__prepare_tracepoint_events(struct perf_evlist *evlist,
+						  struct pevent *pevent)
 {
 	struct perf_evsel *pos;
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		if (pos->attr.type == PERF_TYPE_TRACEPOINT && !pos->name &&
-		    perf_evsel__set_tracepoint_name(pos, pevent))
+		if (pos->attr.type == PERF_TYPE_TRACEPOINT &&
+		    perf_evsel__prepare_tracepoint_event(pos, pevent))
 			return -1;
 	}
 
@@ -2409,7 +2415,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
-	if (perf_evlist__set_tracepoint_names(session->evlist, session->pevent))
+	if (perf_evlist__prepare_tracepoint_events(session->evlist,
+						   session->pevent))
 		goto out_delete_evlist;
 
 	header->frozen = 1;
@@ -2643,7 +2650,8 @@ int perf_event__process_tracing_data(union perf_event *event,
 	if (size_read + padding != size)
 		die("tracing data size mismatch");
 
-	perf_evlist__set_tracepoint_names(session->evlist, session->pevent);
+	perf_evlist__prepare_tracepoint_events(session->evlist,
+					       session->pevent);
 
 	return size_read + padding;
 }
-- 
1.7.9.2.358.g22243

