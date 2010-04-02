Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714Ab0DBFFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:05:01 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45166 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294Ab0DBFEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 01:04:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T5+0dztrbaPypI2MoAvfaRvpuOIJE5YwLui3eIRkF0i6kJx4n53FYjnkqg/VxuwtJQ
         SKOpTTJCJr7GSV/Fh6ldaXjbkuyClSBCckk/Q2q/58MO/7td2PqQK735atq7wgYbacp3
         V2q7cj2sdZECj98BFSOn8C3EXIvSjNw3DRzDo=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 07/11] perf: convert perf tracing data into a tracing_data event
Date: Thu,  1 Apr 2010 23:59:21 -0500
Message-Id: <1270184365-8281-8-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bypasses the tracing_data perf header code and replaces it with a
synthesized event and processing function that accomplishes the same
thing, used when reading/writing perf data to/from a pipe.

The tracing data is pretty large, and this patch doesn't attempt to
break it down into component events.  The tracing_data event itself
doesn't actually contain the tracing data, rather it arranges for the
event processing code to skip over it after it's read, using the skip
return value added to the event processing loop in a previous patch.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c        |   16 ++++++
 tools/perf/builtin-report.c        |    1 +
 tools/perf/builtin-trace.c         |    1 +
 tools/perf/util/event.h            |    7 +++
 tools/perf/util/header.c           |   52 +++++++++++++++++++++
 tools/perf/util/header.h           |    6 ++
 tools/perf/util/session.c          |   13 +++++
 tools/perf/util/session.h          |    3 +-
 tools/perf/util/trace-event-info.c |   24 ++++++++++
 tools/perf/util/trace-event-read.c |   89 ++++++++++++++++++------------------
 tools/perf/util/trace-event.h      |    4 +-
 11 files changed, 170 insertions(+), 46 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c1682d1..0c6a971 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -105,6 +105,11 @@ static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
 	pc->data_tail = tail;
 }
 
+static void advance_output(size_t size)
+{
+	bytes_written += size;
+}
+
 static void write_output(void *buf, size_t size)
 {
 	while (size) {
@@ -600,6 +605,17 @@ static int __cmd_record(int argc, const char **argv)
 			pr_err("Couldn't synthesize event_types.\n");
 			return err;
 		}
+
+		err = event__synthesize_tracing_data(output, attrs,
+						     nr_counters,
+						     process_synthesized_event,
+						     session);
+		if (err <= 0) {
+			pr_err("Couldn't record tracing data.\n");
+			return err;
+		}
+
+		advance_output(err);
 	}
 
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d319f83..48a02a1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -267,6 +267,7 @@ static struct perf_event_ops event_ops = {
 	.read	= process_read_event,
 	.attr	= event__process_attr,
 	.event_type = event__process_event_type,
+	.tracing_data = event__process_tracing_data,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 2489565..1863d7c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -106,6 +106,7 @@ static struct perf_event_ops event_ops = {
 	.comm	= event__process_comm,
 	.attr	= event__process_attr,
 	.event_type = event__process_event_type,
+	.tracing_data = event__process_tracing_data,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 52cb0e9..e982e34 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -86,6 +86,7 @@ struct build_id_event {
 enum perf_header_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
+	PERF_RECORD_HEADER_TRACING_DATA		= 66,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -107,6 +108,11 @@ struct event_type_event {
 	struct perf_trace_event_type event_type;
 };
 
+struct tracing_data_event {
+	struct perf_event_header header;
+	u32 size;
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -118,6 +124,7 @@ typedef union event_union {
 	struct sample_event		sample;
 	struct attr_event		attr;
 	struct event_type_event		event_type;
+	struct tracing_data_event	tracing_data;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4463799..c6874ec 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -934,3 +934,55 @@ int event__process_event_type(event_t *self,
 
 	return 0;
 }
+
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session __unused)
+{
+	event_t ev;
+	ssize_t size = 0, aligned_size = 0, padding;
+	int err = 0;
+
+	memset(&ev, 0, sizeof(ev));
+
+	ev.tracing_data.header.type = PERF_RECORD_HEADER_TRACING_DATA;
+	size = read_tracing_data_size(fd, pattrs, nb_events);
+	if (size <= 0)
+		return size;
+	aligned_size = ALIGN(size, sizeof(u64));
+	padding = aligned_size - size;
+	ev.tracing_data.header.size = sizeof(ev.tracing_data);
+	ev.tracing_data.size = aligned_size;
+
+	process(&ev, session);
+
+	err = read_tracing_data(fd, pattrs, nb_events);
+	write_padded(fd, NULL, 0, padding);
+
+	return aligned_size;
+}
+
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session)
+{
+	ssize_t size_read, padding, size = self->tracing_data.size;
+	off_t offset = lseek(session->fd, 0, SEEK_CUR);
+	char buf[BUFSIZ];
+
+	/* setup for reading amidst mmap */
+	lseek(session->fd, offset + sizeof(struct tracing_data_event),
+	      SEEK_SET);
+
+	size_read = trace_report(session->fd);
+
+	padding = ALIGN(size_read, sizeof(u64)) - size_read;
+
+	if (read(session->fd, buf, padding) < 0)
+		die("reading input file");
+
+	if (size_read + padding != size)
+		die("tracing data size mismatch");
+
+	return size_read + padding;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index dbedaf0..be758ca 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -111,5 +111,11 @@ int event__synthesize_event_types(event__handler_t process,
 int event__process_event_type(event_t *self,
 			      struct perf_session *session);
 
+int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
+				   int nb_events,
+				   event__handler_t process,
+				   struct perf_session *session);
+int event__process_tracing_data(event_t *self,
+				struct perf_session *session);
 
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7c3b355..d5c2b3c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -214,6 +214,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->attr = process_event_stub;
 	if (handler->event_type == NULL)
 		handler->event_type = process_event_stub;
+	if (handler->tracing_data == NULL)
+		handler->tracing_data = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -229,6 +231,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
 	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -321,6 +324,11 @@ static void event__event_type_swap(event_t *self)
 		bswap_64(self->event_type.event_type.event_id);
 }
 
+static void event__tracing_data_swap(event_t *self)
+{
+	self->tracing_data.size = bswap_32(self->tracing_data.size);
+}
+
 typedef void (*event__swap_op)(event_t *self);
 
 static event__swap_op event__swap_ops[] = {
@@ -333,6 +341,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]   = event__event_type_swap,
+	[PERF_RECORD_HEADER_TRACING_DATA]   = event__tracing_data_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -377,6 +386,10 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->attr(event, self);
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return ops->event_type(event, self);
+	case PERF_RECORD_HEADER_TRACING_DATA:
+		/* setup for reading amidst mmap */
+		lseek(self->fd, offset + head, SEEK_SET);
+		return ops->tracing_data(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0f0abfd..88a2c35 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -46,7 +46,8 @@ struct perf_event_ops {
 		 throttle,
 		 unthrottle,
 		 attr,
-		 event_type;
+		 event_type,
+		 tracing_data;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 5ea8973..30cd9b5 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -154,10 +154,17 @@ static void put_tracing_file(char *file)
 	free(file);
 }
 
+static ssize_t calc_data_size;
+
 static ssize_t write_or_die(const void *buf, size_t len)
 {
 	int ret;
 
+	if (calc_data_size) {
+		calc_data_size += len;
+		return len;
+	}
+
 	ret = write(output_fd, buf, len);
 	if (ret < 0)
 		die("writing to '%s'", output_file);
@@ -526,3 +533,20 @@ int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events)
 
 	return 0;
 }
+
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events)
+{
+	ssize_t size;
+	int err = 0;
+
+	calc_data_size = 1;
+	err = read_tracing_data(fd, pattrs, nb_events);
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+
+	if (err < 0)
+		return err;
+
+	return size;
+}
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 7cd1193..44889c9 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -50,14 +50,37 @@ static int long_size;
 
 static unsigned long	page_size;
 
+static ssize_t calc_data_size;
+
+static int do_read(int fd, void *buf, int size)
+{
+	int rsize = size;
+
+	while (size) {
+		int ret = read(fd, buf, size);
+
+		if (ret <= 0)
+			return -1;
+
+		size -= ret;
+		buf += ret;
+	}
+
+	return rsize;
+}
+
 static int read_or_die(void *data, int size)
 {
 	int r;
 
-	r = read(input_fd, data, size);
-	if (r != size)
+	r = do_read(input_fd, data, size);
+	if (r <= 0)
 		die("reading input file (size expected=%d received=%d)",
 		    size, r);
+
+	if (calc_data_size)
+		calc_data_size += r;
+
 	return r;
 }
 
@@ -82,56 +105,28 @@ static char *read_string(void)
 	char buf[BUFSIZ];
 	char *str = NULL;
 	int size = 0;
-	int i;
 	off_t r;
+	char c;
 
 	for (;;) {
-		r = read(input_fd, buf, BUFSIZ);
+		r = read(input_fd, &c, 1);
 		if (r < 0)
 			die("reading input file");
 
 		if (!r)
 			die("no data");
 
-		for (i = 0; i < r; i++) {
-			if (!buf[i])
-				break;
-		}
-		if (i < r)
-			break;
+		buf[size++] = c;
 
-		if (str) {
-			size += BUFSIZ;
-			str = realloc(str, size);
-			if (!str)
-				die("malloc of size %d", size);
-			memcpy(str + (size - BUFSIZ), buf, BUFSIZ);
-		} else {
-			size = BUFSIZ;
-			str = malloc_or_die(size);
-			memcpy(str, buf, size);
-		}
+		if (!c)
+			break;
 	}
 
-	/* trailing \0: */
-	i++;
-
-	/* move the file descriptor to the end of the string */
-	r = lseek(input_fd, -(r - i), SEEK_CUR);
-	if (r == (off_t)-1)
-		die("lseek");
-
-	if (str) {
-		size += i;
-		str = realloc(str, size);
-		if (!str)
-			die("malloc of size %d", size);
-		memcpy(str + (size - i), buf, i);
-	} else {
-		size = i;
-		str = malloc_or_die(i);
-		memcpy(str, buf, i);
-	}
+	if (calc_data_size)
+		calc_data_size += size;
+
+	str = malloc_or_die(size);
+	memcpy(str, buf, size);
 
 	return str;
 }
@@ -459,7 +454,7 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report(int fd)
+ssize_t trace_report(int fd)
 {
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
@@ -467,6 +462,9 @@ void trace_report(int fd)
 	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
+	ssize_t size;
+
+	calc_data_size = 1;
 
 	input_fd = fd;
 
@@ -499,14 +497,17 @@ void trace_report(int fd)
 	read_proc_kallsyms();
 	read_ftrace_printk();
 
+	size = calc_data_size - 1;
+	calc_data_size = 0;
+
 	if (show_funcs) {
 		print_funcs();
-		return;
+		return size;
 	}
 	if (show_printk) {
 		print_printk();
-		return;
+		return size;
 	}
 
-	return;
+	return size;
 }
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index c3269b9..0cb5866 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -162,7 +162,7 @@ struct record *trace_read_data(int cpu);
 
 void parse_set_info(int nr_cpus, int long_sz);
 
-void trace_report(int fd);
+ssize_t trace_report(int fd);
 
 void *malloc_or_die(unsigned int size);
 
@@ -258,6 +258,8 @@ void *raw_field_ptr(struct event *event, const char *name, void *data);
 unsigned long long eval_flag(const char *flag);
 
 int read_tracing_data(int fd, struct perf_event_attr *pattrs, int nb_events);
+ssize_t read_tracing_data_size(int fd, struct perf_event_attr *pattrs,
+			       int nb_events);
 
 /* taken from kernel/trace/trace.h */
 enum trace_flag_type {
-- 
1.6.4.GIT

