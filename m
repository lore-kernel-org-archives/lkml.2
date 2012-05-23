Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965003Ab2EWCor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:44:47 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:49362 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933513Ab2EWCjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:03 -0400
X-AuditID: 9c93016f-b7c3cae000001954-70-4fbc4dc53b13
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 03/22] lib/traceevent: Add support to show migrate disable counter
Date: Wed, 23 May 2012 11:36:40 +0900
Message-Id: <1337740619-27925-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The RT kernel added a migrate disable counter in all events. Add support
to show this in the latency format.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |   57 ++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a2f4c22c8c4f..4dc0313b4a50 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2822,7 +2822,7 @@ static int get_common_info(struct pevent *pevent,
 	event = pevent->events[0];
 	field = pevent_find_common_field(event, type);
 	if (!field)
-		die("field '%s' not found", type);
+		return -1;
 
 	*offset = field->offset;
 	*size = field->size;
@@ -2873,15 +2873,16 @@ static int parse_common_flags(struct pevent *pevent, void *data)
 
 static int parse_common_lock_depth(struct pevent *pevent, void *data)
 {
-	int ret;
-
-	ret = __parse_common(pevent, data,
-			     &pevent->ld_size, &pevent->ld_offset,
-			     "common_lock_depth");
-	if (ret < 0)
-		return -1;
+	return __parse_common(pevent, data,
+			      &pevent->ld_size, &pevent->ld_offset,
+			      "common_lock_depth");
+}
 
-	return ret;
+static int parse_common_migrate_disable(struct pevent *pevent, void *data)
+{
+	return __parse_common(pevent, data,
+			      &pevent->ld_size, &pevent->ld_offset,
+			      "common_migrate_disable");
 }
 
 static int events_id_cmp(const void *a, const void *b);
@@ -3891,10 +3892,13 @@ void pevent_data_lat_fmt(struct pevent *pevent,
 			 struct trace_seq *s, struct pevent_record *record)
 {
 	static int check_lock_depth = 1;
+	static int check_migrate_disable = 1;
 	static int lock_depth_exists;
+	static int migrate_disable_exists;
 	unsigned int lat_flags;
 	unsigned int pc;
 	int lock_depth;
+	int migrate_disable;
 	int hardirq;
 	int softirq;
 	void *data = record->data;
@@ -3902,18 +3906,26 @@ void pevent_data_lat_fmt(struct pevent *pevent,
 	lat_flags = parse_common_flags(pevent, data);
 	pc = parse_common_pc(pevent, data);
 	/* lock_depth may not always exist */
-	if (check_lock_depth) {
-		struct format_field *field;
-		struct event_format *event;
-
-		check_lock_depth = 0;
-		event = pevent->events[0];
-		field = pevent_find_common_field(event, "common_lock_depth");
-		if (field)
-			lock_depth_exists = 1;
-	}
 	if (lock_depth_exists)
 		lock_depth = parse_common_lock_depth(pevent, data);
+	else if (check_lock_depth) {
+		lock_depth = parse_common_lock_depth(pevent, data);
+		if (lock_depth < 0)
+			check_lock_depth = 0;
+		else
+			lock_depth_exists = 1;
+	}
+
+	/* migrate_disable may not always exist */
+	if (migrate_disable_exists)
+		migrate_disable = parse_common_migrate_disable(pevent, data);
+	else if (check_migrate_disable) {
+		migrate_disable = parse_common_migrate_disable(pevent, data);
+		if (migrate_disable < 0)
+			check_migrate_disable = 0;
+		else
+			migrate_disable_exists = 1;
+	}
 
 	hardirq = lat_flags & TRACE_FLAG_HARDIRQ;
 	softirq = lat_flags & TRACE_FLAG_SOFTIRQ;
@@ -3932,6 +3944,13 @@ void pevent_data_lat_fmt(struct pevent *pevent,
 	else
 		trace_seq_putc(s, '.');
 
+	if (migrate_disable_exists) {
+		if (migrate_disable < 0)
+			trace_seq_putc(s, '.');
+		else
+			trace_seq_printf(s, "%d", migrate_disable);
+	}
+
 	if (lock_depth_exists) {
 		if (lock_depth < 0)
 			trace_seq_putc(s, '.');
-- 
1.7.10.1

