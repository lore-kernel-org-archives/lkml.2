Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab2EWClG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:41:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933514Ab2EWCjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:15 -0400
X-AuditID: 9c93016f-b7c3cae000001954-3e-4fbc4dcfe2d8
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>
Subject: [PATCH 22/22] lib/traceevent: Cleanup realloc use
Date: Wed, 23 May 2012 11:36:59 +0900
Message-Id: <1337740619-27925-23-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The if branch is completely unnecessary since 'realloc' can
handle NULL pointers for the first parameter.

This patch is just an adoption of Ulrich Drepper's recent
patch on perf tools.

Link: http://lkml.kernel.org/r/1335230984-7613-1-git-send-email-namhyung.kim@lge.com

Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c  |    8 ++------
 tools/lib/traceevent/parse-filter.c |   24 ++++++++----------------
 2 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index f02890530425..c471075e4974 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -631,12 +631,8 @@ static void add_event(struct pevent *pevent, struct event_format *event)
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
index 05a1eeffa776..c262e069c635 100644
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
1.7.10.1

