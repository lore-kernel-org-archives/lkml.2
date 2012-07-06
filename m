Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2GFLWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:22:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52255 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2GFLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:22:07 -0400
Date: Fri, 6 Jul 2012 04:21:50 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f6ced60fb6c0ee115982157457c47e48802d6e1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        drepper@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, drepper@gmail.com, rostedt@goodmis.org,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1335230984-7613-1-git-send-email-namhyung.kim@lge.com>
References: <1335230984-7613-1-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Cleanup realloc use
Git-Commit-ID: f6ced60fb6c0ee115982157457c47e48802d6e1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:21:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6ced60fb6c0ee115982157457c47e48802d6e1d
Gitweb:     http://git.kernel.org/tip/f6ced60fb6c0ee115982157457c47e48802d6e1d
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 24 Apr 2012 10:29:44 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:31 +0900

tools lib traceevent: Cleanup realloc use

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
