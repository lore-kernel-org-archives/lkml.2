Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab2DXBah (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:30:37 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:48063 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756123Ab2DXBaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:30:35 -0400
X-AuditID: 9c930179-b7bfaae000006f69-11-4f9602396921
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH 12/11] parse-events: Cleanup realloc use
Date: Tue, 24 Apr 2012 10:29:44 +0900
Message-Id: <1335230984-7613-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if branch is completely unnecessary since 'realloc' can
handle NULL pointers for the first parameter.

This patch is just an adoption of Ulrich Drepper's recent
patch on perf tools.

Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 parse-events.c |    8 ++------
 parse-filter.c |   24 ++++++++----------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 3ccedd9..9779298 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -627,12 +627,8 @@ static void add_event(struct pevent *pevent, struct event_format *event)
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
 
diff --git a/parse-filter.c b/parse-filter.c
index bc62f1f..79be550 100644
--- a/parse-filter.c
+++ b/parse-filter.c
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
@@ -1481,7 +1475,7 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
 {
 	struct filter_type *filter_type;
 	int count = 0;
-	int *ids;
+	int *ids = NULL;
 	int i;
 
 	if (!filter->filters)
@@ -1505,10 +1499,8 @@ void pevent_filter_clear_trivial(struct event_filter *filter,
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
1.7.10

