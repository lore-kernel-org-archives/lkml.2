Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab2I0FpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:45:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54267 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662Ab2I0FpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:45:16 -0400
Date: Wed, 26 Sep 2012 22:44:52 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-lge0afl47arh86om0m6a5bqr@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Carve out events format parsing routine
Git-Commit-ID: 2b29175d2b212d88f100c8819aaea097be61e062
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:44:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b29175d2b212d88f100c8819aaea097be61e062
Gitweb:     http://git.kernel.org/tip/2b29175d2b212d88f100c8819aaea097be61e062
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 18 Sep 2012 11:13:15 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:26:31 -0300

tools lib traceevent: Carve out events format parsing routine

The pevent_parse_event() routine will parse a events/sys/tp/format file
and add an event_format instance to the pevent struct.

This patch introduces a pevent_parse_format() routine with just the bits
needed to parse the event/sys/tp/format file and just return the
event_format instance, useful for when all we want is to parse the
format file, without requiring the pevent struct.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-lge0afl47arh86om0m6a5bqr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   96 +++++++++++++++++++++++++++---------
 tools/lib/traceevent/event-parse.h |    3 +
 2 files changed, 75 insertions(+), 24 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b3bc130..1fa71ca 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4794,8 +4794,7 @@ static int find_event_handle(struct pevent *pevent, struct event_format *event)
 }
 
 /**
- * pevent_parse_event - parse the event format
- * @pevent: the handle to the pevent
+ * __pevent_parse_format - parse the event format
  * @buf: the buffer storing the event format string
  * @size: the size of @buf
  * @sys: the system the event belongs to
@@ -4807,15 +4806,16 @@ static int find_event_handle(struct pevent *pevent, struct event_format *event)
  *
  * /sys/kernel/debug/tracing/events/.../.../format
  */
-enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
-				     unsigned long size, const char *sys)
+enum pevent_errno __pevent_parse_format(struct event_format **eventp,
+					struct pevent *pevent, const char *buf,
+					unsigned long size, const char *sys)
 {
 	struct event_format *event;
 	int ret;
 
 	init_input_buf(buf, size);
 
-	event = alloc_event();
+	*eventp = event = alloc_event();
 	if (!event)
 		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
 
@@ -4849,9 +4849,6 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 		goto event_alloc_failed;
 	}
 
-	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
-
 	ret = event_read_format(event);
 	if (ret < 0) {
 		ret = PEVENT_ERRNO__READ_FORMAT_FAILED;
@@ -4862,19 +4859,16 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	 * If the event has an override, don't print warnings if the event
 	 * print format fails to parse.
 	 */
-	if (find_event_handle(pevent, event))
+	if (pevent && find_event_handle(pevent, event))
 		show_warning = 0;
 
 	ret = event_read_print(event);
+	show_warning = 1;
+
 	if (ret < 0) {
-		show_warning = 1;
 		ret = PEVENT_ERRNO__READ_PRINT_FAILED;
 		goto event_parse_failed;
 	}
-	show_warning = 1;
-
-	if (add_event(pevent, event))
-		goto event_alloc_failed;
 
 	if (!ret && (event->flags & EVENT_FL_ISFTRACE)) {
 		struct format_field *field;
@@ -4898,24 +4892,78 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 		return 0;
 	}
 
-#define PRINT_ARGS 0
-	if (PRINT_ARGS && event->print_fmt.args)
-		print_args(event->print_fmt.args);
-
 	return 0;
 
  event_parse_failed:
 	event->flags |= EVENT_FL_FAILED;
-	/* still add it even if it failed */
-	if (add_event(pevent, event))
-		goto event_alloc_failed;
-
 	return ret;
 
  event_alloc_failed:
 	free(event->system);
 	free(event->name);
 	free(event);
+	*eventp = NULL;
+	return ret;
+}
+
+/**
+ * pevent_parse_format - parse the event format
+ * @buf: the buffer storing the event format string
+ * @size: the size of @buf
+ * @sys: the system the event belongs to
+ *
+ * This parses the event format and creates an event structure
+ * to quickly parse raw data for a given event.
+ *
+ * These files currently come from:
+ *
+ * /sys/kernel/debug/tracing/events/.../.../format
+ */
+enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
+				      unsigned long size, const char *sys)
+{
+	return __pevent_parse_format(eventp, NULL, buf, size, sys);
+}
+
+/**
+ * pevent_parse_event - parse the event format
+ * @pevent: the handle to the pevent
+ * @buf: the buffer storing the event format string
+ * @size: the size of @buf
+ * @sys: the system the event belongs to
+ *
+ * This parses the event format and creates an event structure
+ * to quickly parse raw data for a given event.
+ *
+ * These files currently come from:
+ *
+ * /sys/kernel/debug/tracing/events/.../.../format
+ */
+enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
+				     unsigned long size, const char *sys)
+{
+	struct event_format *event = NULL;
+	int ret = __pevent_parse_format(&event, pevent, buf, size, sys);
+
+	if (event == NULL)
+		return ret;
+
+	/* Add pevent to event so that it can be referenced */
+	event->pevent = pevent;
+
+	if (add_event(pevent, event))
+		goto event_add_failed;
+
+#define PRINT_ARGS 0
+	if (PRINT_ARGS && event->print_fmt.args)
+		print_args(event->print_fmt.args);
+
+	return 0;
+
+event_add_failed:
+	free(event->system);
+	free(event->name);
+	free(event);
 	return ret;
 }
 
@@ -5365,7 +5413,7 @@ static void free_formats(struct format *format)
 	free_format_fields(format->fields);
 }
 
-static void free_event(struct event_format *event)
+void pevent_free_format(struct event_format *event)
 {
 	free(event->name);
 	free(event->system);
@@ -5451,7 +5499,7 @@ void pevent_free(struct pevent *pevent)
 	}
 
 	for (i = 0; i < pevent->nr_events; i++)
-		free_event(pevent->events[i]);
+		pevent_free_format(pevent->events[i]);
 
 	while (pevent->handlers) {
 		handle = pevent->handlers;
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index a4bbe24..24a4bba 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -540,6 +540,9 @@ int pevent_parse_header_page(struct pevent *pevent, char *buf, unsigned long siz
 
 enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 				     unsigned long size, const char *sys);
+enum pevent_errno pevent_parse_format(struct event_format **eventp, const char *buf,
+				      unsigned long size, const char *sys);
+void pevent_free_format(struct event_format *event);
 
 void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 			   const char *name, struct pevent_record *record,
