Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030230Ab2GEPph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60614 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030179Ab2GEPpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 03/20] tools lib traceevent: Add support to show migrate disable counter
Date: Thu,  5 Jul 2012 12:45:01 -0300
Message-Id: <1341503118-13198-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The RT kernel added a migrate disable counter in all events. Add
support to show this in the latency format.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-l6ulxyda952g7kua4pfsh73k@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   57 ++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 19 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0644c2a..872dd35 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2884,7 +2884,7 @@ static int get_common_info(struct pevent *pevent,
 	event = pevent->events[0];
 	field = pevent_find_common_field(event, type);
 	if (!field)
-		die("field '%s' not found", type);
+		return -1;
 
 	*offset = field->offset;
 	*size = field->size;
@@ -2935,15 +2935,16 @@ static int parse_common_flags(struct pevent *pevent, void *data)
 
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
@@ -3988,10 +3989,13 @@ void pevent_data_lat_fmt(struct pevent *pevent,
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
@@ -3999,18 +4003,26 @@ void pevent_data_lat_fmt(struct pevent *pevent,
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
@@ -4029,6 +4041,13 @@ void pevent_data_lat_fmt(struct pevent *pevent,
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
1.7.9.2.358.g22243

