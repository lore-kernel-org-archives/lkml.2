Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0DNKFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 06:05:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:33015 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab0DNKF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 06:05:26 -0400
Date: Wed, 14 Apr 2010 10:05:04 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tzanussi@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1270184365-8281-7-git-send-email-tzanussi@gmail.com>
References: <1270184365-8281-7-git-send-email-tzanussi@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/live] perf: Convert perf event types into event type events
Message-ID: <tip-cd19a035f3b63fee6dcbdb5371c4b22276f7dc8c@git.kernel.org>
Git-Commit-ID: cd19a035f3b63fee6dcbdb5371c4b22276f7dc8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 10:05:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd19a035f3b63fee6dcbdb5371c4b22276f7dc8c
Gitweb:     http://git.kernel.org/tip/cd19a035f3b63fee6dcbdb5371c4b22276f7dc8c
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Thu, 1 Apr 2010 23:59:20 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Apr 2010 11:56:07 +0200

perf: Convert perf event types into event type events

Bypasses the event type perf header code and replaces it with a
synthesized event and processing function that accomplishes the
same thing, used when reading/writing perf data to/from a pipe.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: rostedt@goodmis.org
Cc: k-keiichi@bx.jp.nec.com
Cc: acme@ghostprotocols.net
LKML-Reference: <1270184365-8281-7-git-send-email-tzanussi@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    7 +++++
 tools/perf/builtin-report.c |    1 +
 tools/perf/builtin-trace.c  |    1 +
 tools/perf/util/event.h     |   14 +++++++++
 tools/perf/util/header.c    |   62 ++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/header.h    |    9 ++++++
 tools/perf/util/session.c   |   12 ++++++++
 tools/perf/util/session.h   |    3 +-
 8 files changed, 101 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 289d9cf..c4c1322 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -592,6 +592,13 @@ static int __cmd_record(int argc, const char **argv)
 			pr_err("Couldn't synthesize attrs.\n");
 			return err;
 		}
+
+		err = event__synthesize_event_types(process_synthesized_event,
+						    session);
+		if (err < 0) {
+			pr_err("Couldn't synthesize event_types.\n");
+			return err;
+		}
 	}
 
 	err = event__synthesize_kernel_mmap(process_synthesized_event,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f0486ce..e59d012 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -268,6 +268,7 @@ static struct perf_event_ops event_ops = {
 	.lost	= event__process_lost,
 	.read	= process_read_event,
 	.attr	= event__process_attr,
+	.event_type = event__process_event_type,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index e30eac6..eb884a7 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -105,6 +105,7 @@ static struct perf_event_ops event_ops = {
 	.sample	= process_sample_event,
 	.comm	= event__process_comm,
 	.attr	= event__process_attr,
+	.event_type = event__process_event_type,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index b4fbf25..c720fe0 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -85,6 +85,7 @@ struct build_id_event {
 
 enum perf_header_event_type { /* above any possible kernel type */
 	PERF_RECORD_HEADER_ATTR			= 64,
+	PERF_RECORD_HEADER_EVENT_TYPE		= 65,
 	PERF_RECORD_HEADER_MAX
 };
 
@@ -94,6 +95,18 @@ struct attr_event {
 	u64 id[];
 };
 
+#define MAX_EVENT_NAME 64
+
+struct perf_trace_event_type {
+	u64	event_id;
+	char	name[MAX_EVENT_NAME];
+};
+
+struct event_type_event {
+	struct perf_event_header header;
+	struct perf_trace_event_type event_type;
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -104,6 +117,7 @@ typedef union event_union {
 	struct read_event		read;
 	struct sample_event		sample;
 	struct attr_event		attr;
+	struct event_type_event		event_type;
 } event_t;
 
 struct events_stats {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index e361739..4463799 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -99,13 +99,6 @@ int perf_header__add_attr(struct perf_header *self,
 	return 0;
 }
 
-#define MAX_EVENT_NAME 64
-
-struct perf_trace_event_type {
-	u64	event_id;
-	char	name[MAX_EVENT_NAME];
-};
-
 static int event_count;
 static struct perf_trace_event_type *events;
 
@@ -886,3 +879,58 @@ int event__process_attr(event_t *self, struct perf_session *session)
 
 	return 0;
 }
+
+int event__synthesize_event_type(u64 event_id, char *name,
+				 event__handler_t process,
+				 struct perf_session *session)
+{
+	event_t ev;
+	size_t size = 0;
+	int err = 0;
+
+	memset(&ev, 0, sizeof(ev));
+
+	ev.event_type.event_type.event_id = event_id;
+	memset(ev.event_type.event_type.name, 0, MAX_EVENT_NAME);
+	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
+
+	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
+	size = strlen(name);
+	size = ALIGN(size, sizeof(u64));
+	ev.event_type.header.size = sizeof(ev.event_type) -
+		(sizeof(ev.event_type.event_type.name) - size);
+
+	err = process(&ev, session);
+
+	return err;
+}
+
+int event__synthesize_event_types(event__handler_t process,
+				  struct perf_session *session)
+{
+	struct perf_trace_event_type *type;
+	int i, err = 0;
+
+	for (i = 0; i < event_count; i++) {
+		type = &events[i];
+
+		err = event__synthesize_event_type(type->event_id, type->name,
+						   process, session);
+		if (err) {
+			pr_debug("failed to create perf header event type\n");
+			return err;
+		}
+	}
+
+	return err;
+}
+
+int event__process_event_type(event_t *self,
+			      struct perf_session *session __unused)
+{
+	if (perf_header__push_event(self->event_type.event_type.event_id,
+				    self->event_type.event_type.name) < 0)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index e916ac5..afeb618 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -103,4 +103,13 @@ int event__synthesize_attrs(struct perf_header *self,
 			    struct perf_session *session);
 int event__process_attr(event_t *self, struct perf_session *session);
 
+int event__synthesize_event_type(u64 event_id, char *name,
+				 event__handler_t process,
+				 struct perf_session *session);
+int event__synthesize_event_types(event__handler_t process,
+				  struct perf_session *session);
+int event__process_event_type(event_t *self,
+			      struct perf_session *session);
+
+
 #endif /* __PERF_HEADER_H */
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index bc81864..96c4629 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -202,6 +202,8 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 		handler->unthrottle = process_event_stub;
 	if (handler->attr == NULL)
 		handler->attr = process_event_stub;
+	if (handler->event_type == NULL)
+		handler->event_type = process_event_stub;
 }
 
 static const char *event__name[] = {
@@ -216,6 +218,7 @@ static const char *event__name[] = {
 	[PERF_RECORD_READ]	 = "READ",
 	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
 	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
+	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
 };
 
 unsigned long event__total[PERF_RECORD_HEADER_MAX];
@@ -302,6 +305,12 @@ static void event__attr_swap(event_t *self)
 	mem_bswap_64(self->attr.id, size);
 }
 
+static void event__event_type_swap(event_t *self)
+{
+	self->event_type.event_type.event_id =
+		bswap_64(self->event_type.event_type.event_id);
+}
+
 typedef void (*event__swap_op)(event_t *self);
 
 static event__swap_op event__swap_ops[] = {
@@ -313,6 +322,7 @@ static event__swap_op event__swap_ops[] = {
 	[PERF_RECORD_READ]   = event__read_swap,
 	[PERF_RECORD_SAMPLE] = event__all64_swap,
 	[PERF_RECORD_HEADER_ATTR]   = event__attr_swap,
+	[PERF_RECORD_HEADER_EVENT_TYPE]   = event__event_type_swap,
 	[PERF_RECORD_HEADER_MAX]    = NULL,
 };
 
@@ -355,6 +365,8 @@ static int perf_session__process_event(struct perf_session *self,
 		return ops->unthrottle(event, self);
 	case PERF_RECORD_HEADER_ATTR:
 		return ops->attr(event, self);
+	case PERF_RECORD_HEADER_EVENT_TYPE:
+		return ops->event_type(event, self);
 	default:
 		self->unknown_events++;
 		return -1;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 45a1374..0dac1f4 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -45,7 +45,8 @@ struct perf_event_ops {
 		 read,
 		 throttle,
 		 unthrottle,
-		 attr;
+		 attr,
+		 event_type;
 };
 
 struct perf_session *perf_session__new(const char *filename, int mode, bool force);
