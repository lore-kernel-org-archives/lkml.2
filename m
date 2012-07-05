Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab2GEPuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:50:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:59111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2GEPpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 16/20] tools lib traceevent: Cleanup realloc use
Date: Thu,  5 Jul 2012 12:45:14 -0300
Message-Id: <1341503118-13198-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The if branch is completely unnecessary since 'realloc' can handle
NULL pointers for the first parameter.

This patch is just an adoption of Ulrich Drepper's recent patch on
perf tools.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1335230984-7613-1-git-send-email-namhyung.kim@lge.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c  |    8 ++------
 tools/lib/traceevent/parse-filter.c |   24 ++++++++----------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f880db4..5f34aa3 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -633,12 +633,8 @@ static void add_event(struct pevent *pevent, struct event_format *event)
 {
 	int i;
 
-	if (!pevent->events)
-		pevent->events = malloc_or_die(sizeof(event));
-	else
-		pevent->events =
-			realloc(pevent->events, sizeof(event) *
-				(pevent->nr_events + 1));
+	pevent->events = realloc(pevent->events, sizeof(event) *
+				 (pevent->nr_events + 1));
 	if (!pevent->events)
 		die("Can not allocate events");
 
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index f020ac6..ad17855 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -148,17 +148,11 @@ add_filter_type(struct event_filter *filter, int id)
 	if (filter_type)
 		return filter_type;
 
-	if (!filter->filters)
-		filter->event_filters =
-			malloc_or_die(sizeof(*filter->event_filters));
-	else {
-		filter->event_filters =
-			realloc(filter->event_filters,
-				sizeof(*filter->event_filters) *
-				(filter->filters + 1));
-		if (!filter->event_filters)
-			die("Could not allocate filter");
-	}
+	filter->event_filters =	realloc(filter->event_filters,
+					sizeof(*filter->event_filters) *
+					(filter->filters + 1));
+	if (!filter->event_filters)
+		die("Could not allocate filter");
 
 	for (i = 0; i < filter->filters; i++) {
 		if (filter->event_filters[i].event_id > id)
@@ -1480,7 +1474,7 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 {
 	struct filter_type *filter_type;
 	int count = 0;
-	int *ids;
+	int *ids = NULL;
 	int i;
 
 	if (!filter->filters)
@@ -1504,10 +1498,8 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 		default:
 			break;
 		}
-		if (count)
-			ids = realloc(ids, sizeof(*ids) * (count + 1));
-		else
-			ids = malloc(sizeof(*ids));
+
+		ids = realloc(ids, sizeof(*ids) * (count + 1));
 		if (!ids)
 			die("Can't allocate ids");
 		ids[count++] = filter_type->event_id;
-- 
1.7.9.2.358.g22243

