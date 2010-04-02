Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab0DBFAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:00:00 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0DBE7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:59:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=QBo9Dc3v3NhB6fDG1rR1zK0vkIJSDwGEZrTOg0jhowRu0cJnfSawygxbUkK7BP6i25
         TRU72NXF5n01LVZR9+wh5vuOSb9/MUgaWk8hqsTM7GnzDdt2tzUY2s6JQ60gZIfoR9yB
         F5aOFU4cW9lm0Mq2agsKLzazwxMqJAmSIFaX4=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 05/11] perf: convert perf header attrs into attr events
Date: Thu,  1 Apr 2010 23:59:19 -0500
Message-Id: <1270184365-8281-6-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bypasses the attr perf header code and replaces it with a synthesized
event and processing function that accomplishes the same thing, used
when reading/writing perf data to/from a pipe.

Making the attrs into events allows them to be streamed over a pipe
along with the rest of the header data (in later patches).  It also
paves the way to allowing events to be added and removed from perf
sessions dynamically.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |   10 +++++
 tools/perf/builtin-report.c |    1 +
 tools/perf/builtin-trace.c  |    1 +
 tools/perf/util/event.h     |   10 +++++-
 tools/perf/util/header.c    |   79 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |    8 ++++
 tools/perf/util/session.c   |   26 ++++++++++++++
 tools/perf/util/session.h   |    3 +-
 8 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0723fa1..1f0abe2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -585,6 +585,16 @@ static int __cmd_record(int argc, const char **argv)
 
 	post_processing_offset = lseek(output, 0, SEEK_CUR);
 
+	if (pipe_output) {
+		err = event__synthesize_attrs(&session->header,
+					      process_synthesized_event,
+					      session);
+		if (err < 0) {
+			pr_err("Couldn't synthesize attrs.\n");
+			return err;
+		}
+	}
+
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
 					    session, "_text");
 	if (err < 0) {
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a104121..0bb5d85 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -265,6 +265,7 @@ static struct perf_event_ops event_ops = {
 	.fork	= event__process_task,
 	.lost	= event__process_lost,
 	.read	= process_read_event,
+	.attr	= event__process_attr,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 718fddd..bb28973 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -104,6 +104,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 static struct perf_event_ops event_ops = {
 	.sample	= process_sample_event,
 	.comm	= event__process_comm,
+	.attr	= event__process_attr,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 03cdfd9..8a2ded3 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -84,7 +84,14 @@ struct build_id_event {
 };
 
 enum perf_header_event_type { /* above any possible kernel type */
-	PERF_RECORD_HEADER_MAX			= 64,
+	PERF_RECORD_HEADER_ATTR			= 64,
+	PERF_RECORD_HEADER_MAX
+};
+
+struct attr_event {
+	struct perf_event_header header;
+	struct perf_event_attr attr;
+	u64 id[];
 };
 
 typedef union event_union {
@@ -96,6 +103,7 @@ typedef union event_union {
 	struct lost_event		lost;
 	struct read_event		read;
 	struct sample_event		sample;
+	struct attr_event		attr;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 8d05337..e361739 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -807,3 +807,82 @@ perf_header__find_attr(u64 id, struct perf_header *header)
 
 	return NULL;
 }
+
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session)
+{
+	event_t *ev;
+	size_t size;
+	int err;
+
+	size = sizeof(struct perf_event_attr);
+	size = ALIGN(size, sizeof(u64));
+	size += sizeof(struct perf_event_header);
+	size += ids * sizeof(u64);
+
+	ev = malloc(size);
+
+	ev->attr.attr = *attr;
+	memcpy(ev->attr.id, id, ids * sizeof(u64));
+
+	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
+	ev->attr.header.size = size;
+
+	err = process(ev, session);
+
+	free(ev);
+
+	return err;
+}
+
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session)
+{
+	struct perf_header_attr	*attr;
+	int i, err = 0;
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		err = event__synthesize_attr(&attr->attr, attr->ids, attr->id,
+					     process, session);
+		if (err) {
+			pr_debug("failed to create perf header attribute\n");
+			return err;
+		}
+	}
+
+	return err;
+}
+
+int event__process_attr(event_t *self, struct perf_session *session)
+{
+	struct perf_header_attr *attr;
+	unsigned int i, ids, n_ids;
+
+	attr = perf_header_attr__new(&self->attr.attr);
+	if (attr == NULL)
+		return -ENOMEM;
+
+	ids = self->header.size;
+	ids -= (void *)&self->attr.id - (void *)self;
+	n_ids = ids / sizeof(u64);
+
+	for (i = 0; i < n_ids; i++) {
+		if (perf_header_attr__add_id(attr, self->attr.id[i]) < 0) {
+			perf_header_attr__delete(attr);
+			return -ENOMEM;
+		}
+	}
+
+	if (perf_header__add_attr(&session->header, attr) < 0) {
+		perf_header_attr__delete(attr);
+		return -ENOMEM;
+	}
+
+	perf_session__update_sample_type(session);
+
+	return 0;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0ce25cc..79ab267 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -95,4 +95,12 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
+int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+			   event__handler_t process,
+			   struct perf_session *session);
+int event__synthesize_attrs(struct perf_header *self,
+			    event__handler_t process,
+			    struct perf_session *session);
+int event__process_attr(event_t *self, struct perf_session *session);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b767e95..2d977d1 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -210,6 +210,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->throttle = process_event_stub;
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
+	if (handler->attr == NULL)
+		handler->attr = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -223,6 +225,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_FORK]	 = "FORK",
 	[PERF_RECORD_READ]	 = "READ",
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -289,6 +292,26 @@ static void event__read_swap(event_t *self)
 	self->read.id		= bswap_64(self->read.id);
 }
 
+static void event__attr_swap(event_t *self)
+{
+	size_t size;
+
+	self->attr.attr.type		= bswap_32(self->attr.attr.type);
+	self->attr.attr.size		= bswap_32(self->attr.attr.size);
+	self->attr.attr.config		= bswap_64(self->attr.attr.config);
+	self->attr.attr.sample_period	= bswap_64(self->attr.attr.sample_period);
+	self->attr.attr.sample_type	= bswap_64(self->attr.attr.sample_type);
+	self->attr.attr.read_format	= bswap_64(self->attr.attr.read_format);
+	self->attr.attr.wakeup_events	= bswap_32(self->attr.attr.wakeup_events);
+	self->attr.attr.bp_type		= bswap_32(self->attr.attr.bp_type);
+	self->attr.attr.bp_addr		= bswap_64(self->attr.attr.bp_addr);
+	self->attr.attr.bp_len		= bswap_64(self->attr.attr.bp_len);
+
+	size = self->header.size;
+	size -= (void *)&self->attr.id - (void *)self;
+	mem_bswap_64(self->attr.id, size);
+}
+
 typedef void (*event__swap_op)(event_t *self);
 
 static event__swap_op event__swap_ops[] = {
@@ -299,6 +322,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_LOST]   = event__all64_swap,
 	[PERF_RECORD_READ]   = event__read_swap,
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
+	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -339,6 +363,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->unthrottle(event, self);
+	case PERF_RECORD_HEADER_ATTR:
+		return ops->attr(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 8385fb5..07ee8f2 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -44,7 +44,8 @@ struct perf_event_ops {
 		 lost,
 		 read,
 		 throttle,
-		 unthrottle;
+		 unthrottle,
+		 attr;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
-- 
1.6.4.GIT

