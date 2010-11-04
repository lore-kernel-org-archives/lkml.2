Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab0KDPkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:40:07 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:43025 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab0KDPkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:40:05 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 19/20] perf, trace: Export event parsing helpers
Date: Thu,  4 Nov 2010 16:36:55 +0100
Message-Id: <1288885016-18295-20-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
In-Reply-To: <1288885016-18295-1-git-send-email-bp@amd64.org>
References: <1288885016-18295-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those are needed for the RAS daemon.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 tools/lib/trace/parse-events.c     |   12 ++++++------
 tools/lib/trace/parse-events.h     |    5 +++++
 tools/lib/trace/trace-event-info.c |   10 +++++-----
 tools/lib/trace/trace-event.h      |    2 ++
 4 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/tools/lib/trace/parse-events.c b/tools/lib/trace/parse-events.c
index 1f95f87..02fc69b 100644
--- a/tools/lib/trace/parse-events.c
+++ b/tools/lib/trace/parse-events.c
@@ -45,7 +45,7 @@ static int show_warning = 1;
 			warning(fmt, ##__VA_ARGS__);	\
 	} while (0)
 
-static void init_input_buf(const char *buf, unsigned long long size)
+void init_input_buf(const char *buf, unsigned long long size)
 {
 	input_buf = buf;
 	input_buf_siz = size;
@@ -585,7 +585,7 @@ void pevent_print_printk(struct pevent *pevent)
 	}
 }
 
-static struct event_format *alloc_event(void)
+struct event_format *alloc_event(void)
 {
 	struct event_format *event;
 
@@ -1079,7 +1079,7 @@ static int read_expected_item(enum event_type expect, const char *str)
 	return __read_expected(expect, str, 0);
 }
 
-static char *event_read_name(void)
+char *event_read_name(void)
 {
 	char *token;
 
@@ -1099,7 +1099,7 @@ static char *event_read_name(void)
 	return NULL;
 }
 
-static int event_read_id(void)
+int event_read_id(void)
 {
 	char *token;
 	int id;
@@ -1394,7 +1394,7 @@ fail_expect:
 	return -1;
 }
 
-static int event_read_format(struct event_format *event)
+int event_read_format(struct event_format *event)
 {
 	char *token;
 	int ret;
@@ -4287,7 +4287,7 @@ int pevent_parse_event(struct pevent *pevent,
 		if (strcmp(event->name, "bprint") == 0)
 			event->flags |= EVENT_FL_ISBPRINT;
 	}
-		
+
 	event->id = event_read_id();
 	if (event->id < 0)
 		die("failed to read event id");
diff --git a/tools/lib/trace/parse-events.h b/tools/lib/trace/parse-events.h
index f967885..4d9400a 100644
--- a/tools/lib/trace/parse-events.h
+++ b/tools/lib/trace/parse-events.h
@@ -728,4 +728,9 @@ int pevent_update_trivial(struct event_filter *dest, struct event_filter *source
 
 int pevent_filter_compare(struct event_filter *filter1, struct event_filter *filter2);
 
+extern struct event_format *alloc_event(void);
+extern void init_input_buf(const char *buf, unsigned long long size);
+extern char *event_read_name(void);
+extern int event_read_id(void);
+extern int event_read_format(struct event_format *event);
 #endif /* _PARSE_EVENTS_H */
diff --git a/tools/lib/trace/trace-event-info.c b/tools/lib/trace/trace-event-info.c
index 98faa44..8188c59 100644
--- a/tools/lib/trace/trace-event-info.c
+++ b/tools/lib/trace/trace-event-info.c
@@ -136,7 +136,7 @@ static const char *find_tracing_dir(void)
 	return tracing;
 }
 
-static char *get_tracing_file(const char *name)
+char *get_tracing_file(const char *name)
 {
 	const char *tracing;
 	char *file;
@@ -231,7 +231,7 @@ static unsigned long get_size_fd(int fd)
 	return size;
 }
 
-static unsigned long get_size(const char *file)
+unsigned long get_filesize(const char *file)
 {
 	unsigned long long size = 0;
 	int fd;
@@ -340,7 +340,7 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 
 		if (ret >= 0) {
 			/* unfortunately, you can not stat debugfs files for size */
-			size = get_size(format);
+			size = get_filesize(format);
 			write_or_die(&size, 8);
 			check_size = copy_file(format);
 			if (size != check_size)
@@ -438,7 +438,7 @@ static void read_proc_kallsyms(void)
 		write_or_die(&size, 4);
 		return;
 	}
-	size = get_size(path);
+	size = get_filesize(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
@@ -461,7 +461,7 @@ static void read_ftrace_printk(void)
 		write_or_die(&size, 4);
 		goto out;
 	}
-	size = get_size(path);
+	size = get_filesize(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
diff --git a/tools/lib/trace/trace-event.h b/tools/lib/trace/trace-event.h
index 9c9d342..c7e8e0b 100644
--- a/tools/lib/trace/trace-event.h
+++ b/tools/lib/trace/trace-event.h
@@ -76,6 +76,8 @@ struct event_format *trace_find_event(int id);
 #endif
 struct event_format *trace_find_next_event(struct event_format *event);
 unsigned long long read_size(void *ptr, int size);
+unsigned long get_filesize(const char *file);
+char *get_tracing_file(const char *name);
 #if 0
 unsigned long long
 raw_field_value(struct event_format *event, const char *name, void *data);
-- 
1.7.3.1

