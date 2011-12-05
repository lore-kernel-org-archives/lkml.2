Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab1LEMy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:54:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198Ab1LEMy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:54:57 -0500
Date: Mon, 5 Dec 2011 04:53:52 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ug1wtjbnva4bxwknflkkrlrh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf event: perf_event_ops->attr() manipulates only an evlist
Git-Commit-ID: 10d0f086df77f3ff259b46cb501362dbaf2c7989
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:53:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10d0f086df77f3ff259b46cb501362dbaf2c7989
Gitweb:     http://git.kernel.org/tip/10d0f086df77f3ff259b46cb501362dbaf2c7989
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 Nov 2011 22:45:41 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:37:43 -0200

perf event: perf_event_ops->attr() manipulates only an evlist

Removing another case where a perf_session is required when processing
events.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ug1wtjbnva4bxwknflkkrlrh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-inject.c |    8 +++++++-
 tools/perf/util/header.c    |   19 ++++++++-----------
 tools/perf/util/header.h    |    2 +-
 tools/perf/util/session.c   |   16 ++++++++++++++--
 tools/perf/util/session.h   |    6 ++++--
 5 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8dfc12b..978751e 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -36,6 +36,12 @@ static int perf_event__repipe_synth(union perf_event *event,
 	return 0;
 }
 
+static int perf_event__repipe_attr(union perf_event *event,
+				   struct perf_evlist **pevlist __used)
+{
+	return perf_event__repipe_synth(event, NULL);
+}
+
 static int perf_event__repipe(union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session)
@@ -182,7 +188,7 @@ struct perf_event_ops inject_ops = {
 	.read		= perf_event__repipe,
 	.throttle	= perf_event__repipe,
 	.unthrottle	= perf_event__repipe,
-	.attr		= perf_event__repipe_synth,
+	.attr		= perf_event__repipe_attr,
 	.event_type 	= perf_event__repipe_synth,
 	.tracing_data 	= perf_event__repipe_synth,
 	.build_id 	= perf_event__repipe_synth,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 41424a1..1fa97dd 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2120,23 +2120,23 @@ int perf_session__synthesize_attrs(struct perf_session *session,
 }
 
 int perf_event__process_attr(union perf_event *event,
-			     struct perf_session *session)
+			     struct perf_evlist **pevlist)
 {
 	unsigned int i, ids, n_ids;
 	struct perf_evsel *evsel;
+	struct perf_evlist *evlist = *pevlist;
 
-	if (session->evlist == NULL) {
-		session->evlist = perf_evlist__new(NULL, NULL);
-		if (session->evlist == NULL)
+	if (evlist == NULL) {
+		*pevlist = evlist = perf_evlist__new(NULL, NULL);
+		if (evlist == NULL)
 			return -ENOMEM;
 	}
 
-	evsel = perf_evsel__new(&event->attr.attr,
-				session->evlist->nr_entries);
+	evsel = perf_evsel__new(&event->attr.attr, evlist->nr_entries);
 	if (evsel == NULL)
 		return -ENOMEM;
 
-	perf_evlist__add(session->evlist, evsel);
+	perf_evlist__add(evlist, evsel);
 
 	ids = event->header.size;
 	ids -= (void *)&event->attr.id - (void *)event;
@@ -2150,12 +2150,9 @@ int perf_event__process_attr(union perf_event *event,
 		return -ENOMEM;
 
 	for (i = 0; i < n_ids; i++) {
-		perf_evlist__id_add(session->evlist, evsel, 0, i,
-				    event->attr.id[i]);
+		perf_evlist__id_add(evlist, evsel, 0, i, event->attr.id[i]);
 	}
 
-	perf_session__update_sample_type(session);
-
 	return 0;
 }
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 3d5a742..0a88982 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -101,7 +101,7 @@ int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 				struct perf_session *session);
 int perf_session__synthesize_attrs(struct perf_session *session,
 				   perf_event__handler_t process);
-int perf_event__process_attr(union perf_event *event, struct perf_session *session);
+int perf_event__process_attr(union perf_event *event, struct perf_evlist **pevlist);
 
 int perf_event__synthesize_event_type(u64 event_id, char *name,
 				      perf_event__handler_t process,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 675e080..6e7d5f5 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -277,6 +277,13 @@ static int process_event_synth_stub(union perf_event *event __used,
 	return 0;
 }
 
+static int process_event_synth_attr_stub(union perf_event *event __used,
+					 struct perf_evlist **pevlist __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_event_sample_stub(union perf_event *event __used,
 				     struct perf_sample *sample __used,
 				     struct perf_evsel *evsel __used,
@@ -327,7 +334,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
 	if (handler->attr == NULL)
-		handler->attr = process_event_synth_stub;
+		handler->attr = process_event_synth_attr_stub;
 	if (handler->event_type == NULL)
 		handler->event_type = process_event_synth_stub;
 	if (handler->tracing_data == NULL)
@@ -794,12 +801,17 @@ static int perf_session__preprocess_sample(struct perf_session *session,
 static int perf_session__process_user_event(struct perf_session *session, union perf_event *event,
 					    struct perf_event_ops *ops, u64 file_offset)
 {
+	int err;
+
 	dump_event(session, event, file_offset, NULL);
 
 	/* These events are processed right away */
 	switch (event->header.type) {
 	case PERF_RECORD_HEADER_ATTR:
-		return ops->attr(event, session);
+		err = ops->attr(event, &session->evlist);
+		if (err == 0)
+			perf_session__update_sample_type(session);
+		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		return ops->event_type(event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 76d462d..13bd5e0 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -63,6 +63,8 @@ typedef int (*event_op)(union perf_event *self, struct perf_sample *sample,
 			struct perf_session *session);
 typedef int (*event_synth_op)(union perf_event *self,
 			      struct perf_session *session);
+typedef int (*event_attr_op)(union perf_event *event,
+			     struct perf_evlist **pevlist);
 typedef int (*event_op2)(union perf_event *self, struct perf_session *session,
 			 struct perf_event_ops *ops);
 
@@ -76,8 +78,8 @@ struct perf_event_ops {
 			read,
 			throttle,
 			unthrottle;
-	event_synth_op	attr,
-			event_type,
+	event_attr_op	attr;
+	event_synth_op	event_type,
 			tracing_data,
 			build_id;
 	event_op2	finished_round;
