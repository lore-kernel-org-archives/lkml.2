Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2GFLKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:10:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51871 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab2GFLKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:10:13 -0400
Date: Fri, 6 Jul 2012 04:09:59 -0700
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Message-ID: <tip-l6ulxyda952g7kua4pfsh73k@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de,
        namhyung@kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Add support to show migrate disable counter
Git-Commit-ID: 0866a97eb7562409ba792f5e904841dd8e23c8b5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:10:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0866a97eb7562409ba792f5e904841dd8e23c8b5
Gitweb:     http://git.kernel.org/tip/0866a97eb7562409ba792f5e904841dd8e23c8b5
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Tue, 22 May 2012 14:52:40 +0900
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:30 +0900

tools lib traceevent: Add support to show migrate disable counter

The RT kernel added a migrate disable counter in all events. Add
support to show this in the latency format.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-l6ulxyda952g7kua4pfsh73k@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |   57 ++++++++++++++++++++++++------------
 1 files changed, 38 insertions(+), 19 deletions(-)

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
