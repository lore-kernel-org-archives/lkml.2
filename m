Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab2DYMbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:31:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33746 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758636Ab2DYM2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:28:12 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 06/15] perf/events: Add flag to produce nsec output
Date: Wed, 25 Apr 2012 14:26:50 +0200
Message-Id: <1335356819-16710-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
References: <1335356819-16710-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

libtraceevent library prints out in usecs but perf wants to print out
in nsecs. Add a flag that lets the user decide to print out in usec
or nsec times.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/lib/traceevent/event-parse.c  |   15 ++++++++++++---
 tools/lib/traceevent/event-parse.h  |   12 ++++++++++++
 tools/perf/util/trace-event-parse.c |    1 +
 3 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 3ce75b5..c799c19 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3940,15 +3940,16 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	struct event_format *event;
 	unsigned long secs;
 	unsigned long usecs;
+	unsigned long nsecs;
 	const char *comm;
 	void *data = record->data;
 	int type;
 	int pid;
 	int len;
+	int p;
 
 	secs = record->ts / NSECS_PER_SEC;
-	usecs = record->ts - secs * NSECS_PER_SEC;
-	usecs = (usecs + 500) / NSECS_PER_USEC;
+	nsecs = record->ts - secs * NSECS_PER_SEC;
 
 	if (record->size < 0) {
 		do_warning("ug! negative record size %d", record->size);
@@ -3973,7 +3974,15 @@ void pevent_print_event(struct pevent *pevent, struct trace_seq *s,
 	} else
 		trace_seq_printf(s, "%16s-%-5d [%03d]", comm, pid, record->cpu);
 
-	trace_seq_printf(s, " %5lu.%06lu: %s: ", secs, usecs, event->name);
+	if (pevent->flags & PEVENT_NSEC_OUTPUT) {
+		usecs = nsecs;
+		p = 9;
+	} else {
+		usecs = (nsecs + 500) / NSECS_PER_USEC;
+		p = 6;
+	}
+
+	trace_seq_printf(s, " %5lu.%0*lu: %s: ", secs, p, usecs, event->name);
 
 	/* Space out the event names evenly. */
 	len = strlen(event->name);
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 2e0222d..8852827 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -334,6 +334,10 @@ enum pevent_func_arg_type {
 	PEVENT_FUNC_ARG_MAX_TYPES
 };
 
+enum pevent_flag {
+	PEVENT_NSEC_OUTPUT		= 1,	/* output in NSECS */
+};
+
 struct cmdline;
 struct cmdline_list;
 struct func_map;
@@ -373,6 +377,7 @@ struct pevent {
 	struct printk_list *printklist;
 	unsigned int printk_count;
 
+
 	struct event_format **events;
 	int nr_events;
 	struct event_format **sort_events;
@@ -397,6 +402,8 @@ struct pevent {
 
 	int test_filters;
 
+	int flags;
+
 	struct format_field *bprint_ip_field;
 	struct format_field *bprint_fmt_field;
 	struct format_field *bprint_buf_field;
@@ -408,6 +415,11 @@ struct pevent {
 	struct event_format *last_event;
 };
 
+static inline void pevent_set_flag(struct pevent *pevent, int flag)
+{
+	pevent->flags |= flag;
+}
+
 static inline unsigned short
 __data2host2(struct pevent *pevent, unsigned short data)
 {
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 4ec165a..39f22f8 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -45,6 +45,7 @@ int read_trace_init(int file_bigendian, int host_bigendian)
 	perf_pevent = pevent_alloc();
 	pevent = perf_pevent;
 
+	pevent_set_flag(pevent, PEVENT_NSEC_OUTPUT);
 	pevent_set_file_bigendian(pevent, file_bigendian);
 	pevent_set_host_bigendian(pevent, host_bigendian);
 
-- 
1.7.5.4

