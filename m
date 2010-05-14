Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0ENXJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:09:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35010 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0ENXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:09:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/4] perf hist: Clarify events_stats fields usage
Date: Fri, 14 May 2010 20:09:35 -0300
Message-Id: <1273878577-12578-3-git-send-email-acme@infradead.org>
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

The events_stats.total field is too generic, rename it to .total_period,
and also add a comment explaining that it is the sum of all the .period
fields in samples, that is needed because we use auto-freq to avoid
sampling artifacts.

Ditto for events_stats.lost, that is the sum of all lost_event.lost
fields, i.e. the number of events the kernel dropped.

Looking at the users, builtin-sched.c can make use of these fields and
stop doing it again.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |    2 +-
 tools/perf/builtin-report.c |    8 ++++----
 tools/perf/builtin-sched.c  |   17 ++++++-----------
 tools/perf/builtin-trace.c  |    2 +-
 tools/perf/util/event.c     |    2 +-
 tools/perf/util/hist.c      |   20 ++++++++++----------
 tools/perf/util/hist.h      |   16 ++++++++++++++--
 tools/perf/util/newt.c      |    6 +++---
 tools/perf/util/session.c   |    2 +-
 9 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 3a95a02..6dd4bda 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -54,7 +54,7 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 		return -1;
 	}
 
-	session->hists.stats.total += data.period;
+	session->hists.stats.total_period += data.period;
 	return 0;
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f13cda1..b8f47de 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -138,14 +138,14 @@ static int add_event_total(struct perf_session *session,
 	if (!hists)
 		return -ENOMEM;
 
-	hists->stats.total += data->period;
+	hists->stats.total_period += data->period;
 	/*
 	 * FIXME: add_event_total should be moved from here to
 	 * perf_session__process_event so that the proper hist is passed to
 	 * the event_op methods.
 	 */
 	hists__inc_nr_events(hists, PERF_RECORD_SAMPLE);
-	session->hists.stats.total += data->period;
+	session->hists.stats.total_period += data->period;
 	return 0;
 }
 
@@ -322,10 +322,10 @@ static int __cmd_report(void)
 			if (rb_first(&session->hists.entries) ==
 			    rb_last(&session->hists.entries))
 				fprintf(stdout, "# Samples: %Ld\n#\n",
-					hists->stats.total);
+					hists->stats.total_period);
 			else
 				fprintf(stdout, "# Samples: %Ld %s\n#\n",
-					hists->stats.total,
+					hists->stats.total_period,
 					__event_name(hists->type, hists->config));
 
 			hists__fprintf(hists, NULL, false, stdout);
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index aef6ed0..be7bc92 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1641,19 +1641,10 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int process_lost_event(event_t *event __used,
-			      struct perf_session *session __used)
-{
-	nr_lost_chunks++;
-	nr_lost_events += event->lost.lost;
-
-	return 0;
-}
-
 static struct perf_event_ops event_ops = {
 	.sample			= process_sample_event,
 	.comm			= event__process_comm,
-	.lost			= process_lost_event,
+	.lost			= event__process_lost,
 	.ordered_samples	= true,
 };
 
@@ -1664,8 +1655,12 @@ static int read_events(void)
 	if (session == NULL)
 		return -ENOMEM;
 
-	if (perf_session__has_traces(session, "record -R"))
+	if (perf_session__has_traces(session, "record -R")) {
 		err = perf_session__process_events(session, &event_ops);
+		nr_events      = session->hists.stats.nr_events[0];
+		nr_lost_events = session->hists.stats.total_lost;
+		nr_lost_chunks = session->hists.stats.nr_events[PERF_RECORD_LOST];
+	}
 
 	perf_session__delete(session);
 	return err;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 95fcb05..dddf3f0 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -109,7 +109,7 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 					     data.time, thread->comm);
 	}
 
-	session->hists.stats.total += data.period;
+	session->hists.stats.total_period += data.period;
 	return 0;
 }
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 3e8fec1..50771b5 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -385,7 +385,7 @@ int event__process_comm(event_t *self, struct perf_session *session)
 int event__process_lost(event_t *self, struct perf_session *session)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
-	session->hists.stats.lost += self->lost.lost;
+	session->hists.stats.total_lost += self->lost.lost;
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 1614ad7..c592245 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -239,7 +239,7 @@ void hists__output_resort(struct hists *self)
 	struct hist_entry *n;
 	u64 min_callchain_hits;
 
-	min_callchain_hits = self->stats.total * (callchain_param.min_percent / 100);
+	min_callchain_hits = self->stats.total_period * (callchain_param.min_percent / 100);
 
 	tmp = RB_ROOT;
 	next = rb_first(&self->entries);
@@ -525,7 +525,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 	if (pair_hists) {
 		count = self->pair ? self->pair->count : 0;
-		total = pair_hists->stats.total;
+		total = pair_hists->stats.total_period;
 		count_sys = self->pair ? self->pair->count_sys : 0;
 		count_us = self->pair ? self->pair->count_us : 0;
 		count_guest_sys = self->pair ? self->pair->count_guest_sys : 0;
@@ -769,10 +769,10 @@ print_entries:
 			++position;
 		}
 		ret += hist_entry__fprintf(h, pair, show_displacement,
-					   displacement, fp, self->stats.total);
+					   displacement, fp, self->stats.total_period);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total);
+			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
 
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
@@ -795,7 +795,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total = 0;
+	self->nr_entries = self->stats.total_period = 0;
 	self->max_sym_namelen = 0;
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
@@ -812,7 +812,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 		h->filtered &= ~(1 << HIST_FILTER__DSO);
 		if (!h->filtered) {
 			++self->nr_entries;
-			self->stats.total += h->count;
+			self->stats.total_period += h->count;
 			if (h->ms.sym &&
 			    self->max_sym_namelen < h->ms.sym->namelen)
 				self->max_sym_namelen = h->ms.sym->namelen;
@@ -824,7 +824,7 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 {
 	struct rb_node *nd;
 
-	self->nr_entries = self->stats.total = 0;
+	self->nr_entries = self->stats.total_period = 0;
 	self->max_sym_namelen = 0;
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
@@ -837,7 +837,7 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 		h->filtered &= ~(1 << HIST_FILTER__THREAD);
 		if (!h->filtered) {
 			++self->nr_entries;
-			self->stats.total += h->count;
+			self->stats.total_period += h->count;
 			if (h->ms.sym &&
 			    self->max_sym_namelen < h->ms.sym->namelen)
 				self->max_sym_namelen = h->ms.sym->namelen;
@@ -1031,8 +1031,8 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head)
 
 void hists__inc_nr_events(struct hists *self, u32 type)
 {
-	++self->hists.stats.nr_events[0];
-	++self->hists.stats.nr_events[type];
+	++self->stats.nr_events[0];
+	++self->stats.nr_events[type];
 }
 
 size_t hists__fprintf_nr_events(struct hists *self, FILE *fp)
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 97b8962..da6b848 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -37,9 +37,21 @@ struct sym_priv {
 	struct sym_ext	*ext;
 };
 
+/*
+ * The kernel collects the number of events it couldn't send in a stretch and
+ * when possible sends this number in a PERF_RECORD_LOST event. The number of
+ * such "chunks" of lost events is stored in .nr_events[PERF_EVENT_LOST] while
+ * total_lost tells exactly how many events the kernel in fact lost, i.e. it is
+ * the sum of all struct lost_event.lost fields reported.
+ *
+ * The total_period is needed because by default auto-freq is used, so
+ * multipling nr_events[PERF_EVENT_SAMPLE] by a frequency isn't possible to get
+ * the total number of low level events, it is necessary to to sum all struct
+ * sample_event.period and stash the result in total_period.
+ */
 struct events_stats {
-	u64 total;
-	u64 lost;
+	u64 total_period;
+	u64 total_lost;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
 	u32 nr_unknown_events;
 };
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index ba6acd0..010bacf 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -689,7 +689,7 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	}
 
 	snprintf(str, sizeof(str), "Samples: %Ld                            ",
-		 hists->stats.total);
+		 hists->stats.total_period);
 	newtDrawRootText(0, 0, str);
 
 	newtGetScreenSize(NULL, &rows);
@@ -718,12 +718,12 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 		if (h->filtered)
 			continue;
 
-		len = hist_entry__append_browser(h, self->tree, hists->stats.total);
+		len = hist_entry__append_browser(h, self->tree, hists->stats.total_period);
 		if (len > max_len)
 			max_len = len;
 		if (symbol_conf.use_callchain)
 			hist_entry__append_callchain_browser(h, self->tree,
-							     hists->stats.total, idx++);
+							     hists->stats.total_period, idx++);
 		++curr_hist;
 		if (curr_hist % 5)
 			ui_progress__update(progress, curr_hist);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 7231f6b..25bfca4 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -549,7 +549,7 @@ static int perf_session__process_event(struct perf_session *self,
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    offset + head, event->header.size,
 			    event__name[event->header.type]);
-		hists__inc_nr_events(self, event->header.type);
+		hists__inc_nr_events(&self->hists, event->header.type);
 	}
 
 	if (self->header.needs_swap && event__swap_ops[event->header.type])
-- 
1.6.2.5

