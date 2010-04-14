Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0DNKFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:05:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:33007 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab0DNKFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:05:14 -0400
Date: Wed, 14 Apr 2010 10:04:47 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-6-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-6-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf: Convert perf header attrs into attr events
Message-ID: <tip-2c46dbb517a10b18d459e6ceffefde5bfb290cf6@git.kernel.org>
Git-Commit-ID: 2c46dbb517a10b18d459e6ceffefde5bfb290cf6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:04:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c46dbb517a10b18d459e6ceffefde5bfb290cf6
Gitweb:     http://git.kernel.org/tip/2c46dbb517a10b18d459e6ceffefde5bfb290cf6
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:19 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:07 +0200

perf: Convert perf header attrs into attr events

Bypasses the attr perf header code and replaces it with a
synthesized event and processing function that accomplishes the
same thing, used when reading/writing perf data to/from a pipe.

Making the attrs into events allows them to be streamed over a
pipe along with the rest of the header data (in later patches).
It also paves the way to allowing events to be added and removed
from perf sessions dynamically.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-6-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
index d4464f7..289d9cf 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -584,6 +584,16 @@ static int __cmd_record(int argc, const char **argv)
 
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
 	if (err < 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 00b358f..f0486ce 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -267,6 +267,7 @@ static struct perf_event_ops event_ops = {
 	.fork	= event__process_task,
 	.lost	= event__process_lost,
 	.read	= process_read_event,
+	.attr	= event__process_attr,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index c681e85..e30eac6 100644
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
index 5c1eba6..b4fbf25 100644
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
index 6562ece..e916ac5 100644
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
index 2c1277c..bc81864 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -200,6 +200,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->throttle = process_event_stub;
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
+	if (handler->attr == NULL)
+		handler->attr = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -213,6 +215,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_FORK]	 = "FORK",
 	[PERF_RECORD_READ]	 = "READ",
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -279,6 +282,26 @@ static void event__read_swap(event_t *self)
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
@@ -289,6 +312,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_LOST]   = event__all64_swap,
 	[PERF_RECORD_READ]   = event__read_swap,
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
+	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -329,6 +353,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->throttle(event, self);
 	case PERF_RECORD_UNTHROTTLE:
 		return ops->unthrottle(event, self);
+	case PERF_RECORD_HEADER_ATTR:
+		return ops->attr(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 5f78911..45a1374 100644
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
