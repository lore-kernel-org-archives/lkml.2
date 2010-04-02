Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab0DBFAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 01:00:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab0DBE7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 00:59:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u3urQIqHyVd4Xiew/D6JHi740P8kNhC8K/u850r+aDsVyfABo1ZhvBTxrZZBFYed5k
         OdLWd2rvOyCFikSYx4PXMrA6YA0CjedykLiIrPyMhdsjJcjf6QKsP2TAyK/wLiAbGe5N
         XHOgbHWqLMUootbByYHO1Kz2804PDPQuMnF68=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, rostedt@goodmis.org,
       k-keiichi@bx.jp.nec.com, acme@ghostprotocols.net
Subject: [RFC v2][PATCH 08/11] perf: convert perf header build_ids into build_id events
Date: Thu,  1 Apr 2010 23:59:22 -0500
Message-Id: <1270184365-8281-9-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bypasses the build_id perf header code and replaces it with a
synthesized event and processing function that accomplishes the same
thing, used when reading/writing perf data to/from a pipe.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/builtin-record.c |   15 ++++++-
 tools/perf/builtin-report.c |    1 +
 tools/perf/builtin-trace.c  |    1 +
 tools/perf/util/event.h     |    2 +
 tools/perf/util/header.c    |   90 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/header.h    |    7 +++
 tools/perf/util/session.c   |    6 +++
 tools/perf/util/session.h   |    3 +-
 8 files changed, 121 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0c6a971..9a5be5d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -427,10 +427,19 @@ static int process_buildids(void)
 
 static void atexit_header(void)
 {
-	session->header.data_size += bytes_written;
+	if (!pipe_output) {
+		session->header.data_size += bytes_written;
 
-	process_buildids();
-	perf_header__write(&session->header, output, true);
+		process_buildids();
+		perf_header__write(&session->header, output, true);
+	} else {
+		int err;
+
+		err = event__synthesize_build_ids(process_synthesized_event,
+						  session);
+		if (err < 0)
+			pr_err("Couldn't synthesize build ids.\n");
+	}
 }
 
 static int __cmd_record(int argc, const char **argv)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 48a02a1..8f71ee7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -268,6 +268,7 @@ static struct perf_event_ops event_ops = {
 	.attr	= event__process_attr,
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
+	.build_id = event__process_build_id,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 1863d7c..4a6ffb2 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -107,6 +107,7 @@ static struct perf_event_ops event_ops = {
 	.attr	= event__process_attr,
 	.event_type = event__process_event_type,
 	.tracing_data = event__process_tracing_data,
+	.build_id = event__process_build_id,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index e982e34..2dcef07 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -87,6 +87,7 @@ enum perf_header_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_ATTR			= 64,
 	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
 	PERF_RECORD_HEADER_TRACING_DATA		= 66,
+	PERF_RECORD_HEADER_BUILD_ID		= 67,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -125,6 +126,7 @@ typedef union event_union {
 	struct attr_event		attr;
 	struct event_type_event		event_type;
 	struct tracing_data_event	tracing_data;
+	struct build_id_event		build_id;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index c6874ec..628173b 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -986,3 +986,93 @@ int event__process_tracing_data(event_t *self,
 
 	return size_read + padding;
 }
+
+int event__synthesize_build_id(struct dso *pos, u16 misc,
+			       event__handler_t process,
+			       struct perf_session *session)
+{
+	event_t ev;
+	size_t len;
+	int err = 0;
+
+	if (!pos->hit)
+		return err;
+
+	memset(&ev, 0, sizeof(ev));
+
+	len = pos->long_name_len + 1;
+	len = ALIGN(len, NAME_ALIGN);
+	memcpy(&ev.build_id.build_id, pos->build_id, sizeof(pos->build_id));
+	ev.build_id.header.type = PERF_RECORD_HEADER_BUILD_ID;
+	ev.build_id.header.misc = misc;
+	ev.build_id.header.size = sizeof(ev.build_id) + len;
+	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
+
+	err = process(&ev, session);
+
+	return err;
+}
+
+static int __event_synthesize_build_ids(struct list_head *head, u16 misc,
+					event__handler_t process,
+					struct perf_session *session)
+{
+	struct dso *pos;
+
+	dsos__for_each_with_build_id(pos, head) {
+		int err;
+		if (!pos->hit)
+			continue;
+
+		err = event__synthesize_build_id(pos, misc, process, session);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+int event__synthesize_build_ids(event__handler_t process,
+				struct perf_session *session)
+{
+	int err;
+
+	if (!dsos__read_build_ids(true))
+		return 0;
+
+	err = __event_synthesize_build_ids(&dsos__kernel,
+					   PERF_RECORD_MISC_KERNEL,
+					   process, session);
+	if (err == 0)
+		err = __event_synthesize_build_ids(&dsos__user,
+						   PERF_RECORD_MISC_USER,
+						   process, session);
+
+	if (err < 0) {
+		pr_debug("failed to synthesize build ids\n");
+		return err;
+	}
+
+	dsos__cache_build_ids();
+
+	return 0;
+}
+
+int event__process_build_id(event_t *self,
+			    struct perf_session *session __unused)
+{
+	struct list_head *head = &dsos__user;
+	struct dso *dso;
+
+	if (self->build_id.header.misc & PERF_RECORD_MISC_KERNEL)
+		head = &dsos__kernel;
+
+	dso = __dsos__findnew(head, self->build_id.filename);
+	if (dso != NULL) {
+		dso__set_build_id(dso, &self->build_id.build_id);
+		if (head == &dsos__kernel && self->build_id.filename[0] == '[')
+			dso->kernel = 1;
+	}
+
+	return 0;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index be758ca..f827ef2 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -118,4 +118,11 @@ int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
 int event__process_tracing_data(event_t *self,
 				struct perf_session *session);
 
+int event__synthesize_build_id(struct dso *pos, u16 misc,
+			       event__handler_t process,
+			       struct perf_session *session);
+int event__synthesize_build_ids(event__handler_t process,
+				struct perf_session *session);
+int event__process_build_id(event_t *self, struct perf_session *session);
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index d5c2b3c..be16ea4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -216,6 +216,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->event_type = process_event_stub;
 	if (handler->tracing_data == NULL)
 		handler->tracing_data = process_event_stub;
+	if (handler->build_id == NULL)
+		handler->build_id = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -232,6 +234,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
 	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
 	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
+	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -342,6 +345,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]   = event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA]   = event__tracing_data_swap,
+	[PERF_RECORD_HEADER_BUILD_ID]   = NULL,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -390,6 +394,8 @@ static int perf_session__process_event(struct perf_session *self,
 		/* setup for reading amidst mmap */
 		lseek(self->fd, offset + head, SEEK_SET);
 		return ops->tracing_data(event, self);
+	case PERF_RECORD_HEADER_BUILD_ID:
+		return ops->build_id(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 88a2c35..4f925e6 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -47,7 +47,8 @@ struct perf_event_ops {
 		 unthrottle,
 		 attr,
 		 event_type,
-		 tracing_data;
+		 tracing_data,
+		 build_id;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
-- 
1.6.4.GIT

