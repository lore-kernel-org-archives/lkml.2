Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2IFCSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:18:18 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:44671 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2IFCSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:18:16 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-ac-504807e643a8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] perf header: Prepare tracepoint events regardless of name
Date: Thu,  6 Sep 2012 11:10:46 +0900
Message-Id: <1346897446-16569-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
References: <1346897446-16569-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf_evlist__set_tracepoint_names is a misnomer because it
finds and sets correspoding event_format in addition to the name.  So
skipping it when a event has set name already caused a trouble.

Rename it and set name only a event doesn't have one.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Arnaldo, I made it incremental for your convenience.  But if you want
to drop my previous one I can resend with it.  Please let me know your
preference. :)

 tools/perf/util/header.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index eb7a8da2f4f5..19be34145a18 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2500,33 +2500,39 @@ static int read_attr(int fd, struct perf_header *ph,
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
 
@@ -2614,7 +2620,8 @@ int perf_session__read_header(struct perf_session *session, int fd)
 
 	lseek(fd, header->data_offset, SEEK_SET);
 
-	if (perf_evlist__set_tracepoint_names(session->evlist, session->pevent))
+	if (perf_evlist__prepare_tracepoint_events(session->evlist,
+						   session->pevent))
 		goto out_delete_evlist;
 
 	header->frozen = 1;
@@ -2848,7 +2855,8 @@ int perf_event__process_tracing_data(union perf_event *event,
 	if (size_read + padding != size)
 		die("tracing data size mismatch");
 
-	perf_evlist__set_tracepoint_names(session->evlist, session->pevent);
+	perf_evlist__prepare_tracepoint_events(session->evlist,
+					       session->pevent);
 
 	return size_read + padding;
 }
-- 
1.7.11.4

