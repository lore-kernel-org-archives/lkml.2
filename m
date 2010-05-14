Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759782Ab0ENXKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:10:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0ENXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:09:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/4] perf hist: Make event__totals per hists
Date: Fri, 14 May 2010 20:09:34 -0300
Message-Id: <1273878577-12578-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273878577-12578-1-git-send-email-acme@infradead.org>
References: <1273878577-12578-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This is one more thing that started global but are more useful per hist
or per session.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-report.c   |    8 +++++++-
 tools/perf/util/event.c       |   17 +++++++++++++++++
 tools/perf/util/event.h       |    2 ++
 tools/perf/util/hist.c        |   21 +++++++++++++++++++++
 tools/perf/util/hist.h        |    6 ++++++
 tools/perf/util/session.c     |   36 ++----------------------------------
 tools/perf/util/session.h     |    8 ++++++--
 8 files changed, 62 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index fd1b786..77bcc9b 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -365,7 +365,7 @@ static int __cmd_annotate(void)
 		goto out_delete;
 
 	if (dump_trace) {
-		event__print_totals();
+		perf_session__fprintf_nr_events(session, stdout);
 		goto out_delete;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 04de338..f13cda1 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -139,6 +139,12 @@ static int add_event_total(struct perf_session *session,
 		return -ENOMEM;
 
 	hists->stats.total += data->period;
+	/*
+	 * FIXME: add_event_total should be moved from here to
+	 * perf_session__process_event so that the proper hist is passed to
+	 * the event_op methods.
+	 */
+	hists__inc_nr_events(hists, PERF_RECORD_SAMPLE);
 	session->hists.stats.total += data->period;
 	return 0;
 }
@@ -293,7 +299,7 @@ static int __cmd_report(void)
 		goto out_delete;
 
 	if (dump_trace) {
-		event__print_totals();
+		perf_session__fprintf_nr_events(session, stdout);
 		goto out_delete;
 	}
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index cce006e..3e8fec1 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -7,6 +7,23 @@
 #include "strlist.h"
 #include "thread.h"
 
+const char *event__name[] = {
+	[0]			 = "TOTAL",
+	[PERF_RECORD_MMAP]	 = "MMAP",
+	[PERF_RECORD_LOST]	 = "LOST",
+	[PERF_RECORD_COMM]	 = "COMM",
+	[PERF_RECORD_EXIT]	 = "EXIT",
+	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
+	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
+	[PERF_RECORD_FORK]	 = "FORK",
+	[PERF_RECORD_READ]	 = "READ",
+	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
+	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
+	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
+	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
+	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
+};
+
 static pid_t event__synthesize_comm(pid_t pid, int full,
 				    event__handler_t process,
 				    struct perf_session *session)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 48c2cc9..8577085 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -160,4 +160,6 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     struct addr_location *al, symbol_filter_t filter);
 int event__parse_sample(event_t *event, u64 type, struct sample_data *data);
 
+extern const char *event__name[];
+
 #endif /* __PERF_RECORD_H */
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5dc4f84..1614ad7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1028,3 +1028,24 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 	pclose(file);
 	return 0;
 }
+
+void hists__inc_nr_events(struct hists *self, u32 type)
+{
+	++self->hists.stats.nr_events[0];
+	++self->hists.stats.nr_events[type];
+}
+
+size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
+{
+	int i;
+	size_t ret = 0;
+
+	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
+		if (!event__name[i])
+			continue;
+		ret += fprintf(fp, "%10s events: %10d\n",
+			       event__name[i], self->stats.nr_events[i]);
+	}
+
+	return ret;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0b4c8df..97b8962 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -40,6 +40,8 @@ struct sym_priv {
 struct events_stats {
 	u64 total;
 	u64 lost;
+	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_unknown_events;
 };
 
 struct hists {
@@ -68,6 +70,10 @@ void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *self);
 void hists__collapse_resort(struct hists *self);
+
+void hists__inc_nr_events(struct hists *self, u32 type);
+size_t hists__fprintf_nr_events(struct hists *self, FILE *fp);
+
 size_t hists__fprintf(struct hists *self, struct hists *pair,
 		      bool show_displacement, FILE *fp);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 72a7f6a..7231f6b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -94,7 +94,6 @@ struct perf_session *perf_session__new(const char *filename, int mode, bool forc
 	self->mmap_window = 32;
 	self->cwd = NULL;
 	self->cwdlen = 0;
-	self->unknown_events = 0;
 	self->machines = RB_ROOT;
 	self->repipe = repipe;
 	INIT_LIST_HEAD(&self->ordered_samples.samples_head);
@@ -241,36 +240,6 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	}
 }
 
-static const char *event__name[] = {
-	[0]			 = "TOTAL",
-	[PERF_RECORD_MMAP]	 = "MMAP",
-	[PERF_RECORD_LOST]	 = "LOST",
-	[PERF_RECORD_COMM]	 = "COMM",
-	[PERF_RECORD_EXIT]	 = "EXIT",
-	[PERF_RECORD_THROTTLE]	 = "THROTTLE",
-	[PERF_RECORD_UNTHROTTLE] = "UNTHROTTLE",
-	[PERF_RECORD_FORK]	 = "FORK",
-	[PERF_RECORD_READ]	 = "READ",
-	[PERF_RECORD_SAMPLE]	 = "SAMPLE",
-	[PERF_RECORD_HEADER_ATTR]	 = "ATTR",
-	[PERF_RECORD_HEADER_EVENT_TYPE]	 = "EVENT_TYPE",
-	[PERF_RECORD_HEADER_TRACING_DATA]	 = "TRACING_DATA",
-	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
-};
-
-unsigned long event__total[PERF_RECORD_HEADER_MAX];
-
-void event__print_totals(void)
-{
-	int i;
-	for (i = 0; i < PERF_RECORD_HEADER_MAX; ++i) {
-		if (!event__name[i])
-			continue;
-		pr_info("%10s events: %10ld\n",
-			event__name[i], event__total[i]);
-	}
-}
-
 void mem_bswap_64(void *src, int byte_size)
 {
 	u64 *m = src;
@@ -580,8 +549,7 @@ static int perf_session__process_event(struct perf_session *self,
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    offset + head, event->header.size,
 			    event__name[event->header.type]);
-		++event__total[0];
-		++event__total[event->header.type];
+		hists__inc_nr_events(self, event->header.type);
 	}
 
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
@@ -619,7 +587,7 @@ static int perf_session__process_event(struct perf_session *self,
 	case PERF_RECORD_FINISHED_ROUND:
 		return ops->finished_round(event, self, ops);
 	default:
-		self->unknown_events++;
+		++self->hists.stats.nr_unknown_events;
 		return -1;
 	}
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index ce00fa6..e7fce48 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -30,8 +30,6 @@ struct perf_session {
 	struct machine		host_machine;
 	struct rb_root		machines;
 	struct rb_root		hists_tree;
-	unsigned long		event_total[PERF_RECORD_MAX];
-	unsigned long		unknown_events;
 	/*
 	 * FIXME: should point to the first entry in hists_tree and
 	 *        be a hists instance. Right now its only 'report'
@@ -140,4 +138,10 @@ size_t perf_session__fprintf_dsos_buildid(struct perf_session *self, FILE *fp,
 {
 	return machines__fprintf_dsos_buildid(&self->machines, fp, with_hits);
 }
+
+static inline
+size_t perf_session__fprintf_nr_events(struct perf_session *self, FILE *fp)
+{
+	return hists__fprintf_nr_events(&self->hists, fp);
+}
 #endif /* __PERF_SESSION_H */
-- 
1.6.2.5

