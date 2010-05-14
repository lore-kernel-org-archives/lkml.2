Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0ENXJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:09:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0ENXJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:09:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/4] perf report: Report number of events, not samples
Date: Fri, 14 May 2010 20:09:36 -0300
Message-Id: <1273878577-12578-4-git-send-email-acme@infradead.org>
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

Number of samples is meaningless after we switched to auto-freq, so
report the number of events, i.e. not the sum of the different periods,
but the number PERF_RECORD_SAMPLE emitted by the kernel.

While doing this I noticed that naming "count" to the sum of all the
event periods can be confusing, so rename it to .period, just like in
struct sample.data, so that we become more consistent.

This helps with the next step, that was to record in struct hist_entry
the number of sample events for each instance, we need that because we
use it to generate the number of events when applying filters to the
tree of hist entries like it is being done in the TUI report browser.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-diff.c   |    6 +-
 tools/perf/builtin-report.c |   32 +++++++++++-----
 tools/perf/util/hist.c      |   88 +++++++++++++++++++++++--------------------
 tools/perf/util/hist.h      |    2 +-
 tools/perf/util/newt.c      |    8 ++-
 tools/perf/util/sort.h      |   11 +++--
 tools/perf/util/util.c      |   22 +++++++++++
 tools/perf/util/util.h      |    1 +
 8 files changed, 107 insertions(+), 63 deletions(-)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6dd4bda..a6e2fdc 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -23,9 +23,9 @@ static bool  force;
 static bool show_displacement;
 
 static int hists__add_entry(struct hists *self,
-			    struct addr_location *al, u64 count)
+			    struct addr_location *al, u64 period)
 {
-	if (__hists__add_entry(self, al, NULL, count) != NULL)
+	if (__hists__add_entry(self, al, NULL, period) != NULL)
 		return 0;
 	return -ENOMEM;
 }
@@ -50,7 +50,7 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 	event__parse_sample(event, session->sample_type, &data);
 
 	if (hists__add_entry(&session->hists, &al, data.period)) {
-		pr_warning("problem incrementing symbol count, skipping event\n");
+		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b8f47de..6826512 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -188,14 +188,14 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return 0;
 
 	if (perf_session__add_hist_entry(session, &al, &data)) {
-		pr_debug("problem incrementing symbol count, skipping event\n");
+		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
 	attr = perf_header__find_attr(data.id, &session->header);
 
 	if (add_event_total(session, &data, attr)) {
-		pr_debug("problem adding event count\n");
+		pr_debug("problem adding event period\n");
 		return -1;
 	}
 
@@ -269,11 +269,25 @@ static struct perf_event_ops event_ops = {
 
 extern volatile int session_done;
 
-static void sig_handler(int sig __attribute__((__unused__)))
+static void sig_handler(int sig __used)
 {
 	session_done = 1;
 }
 
+static size_t hists__fprintf_nr_sample_events(struct hists *self,
+					      const char *evname, FILE *fp)
+{
+	size_t ret;
+	char unit;
+	unsigned long nr_events = self->stats.nr_events[PERF_RECORD_SAMPLE];
+
+	nr_events = convert_unit(nr_events, &unit);
+	ret = fprintf(fp, "# Events: %lu%c", nr_events, unit);
+	if (evname != NULL)
+		ret += fprintf(fp, " %s", evname);
+	return ret + fprintf(fp, "\n#\n");
+}
+
 static int __cmd_report(void)
 {
 	int ret = -EINVAL;
@@ -319,14 +333,12 @@ static int __cmd_report(void)
 		if (use_browser)
 			hists__browse(hists, help, input_name);
 		else {
-			if (rb_first(&session->hists.entries) ==
+			const char *evname = NULL;
+			if (rb_first(&session->hists.entries) !=
 			    rb_last(&session->hists.entries))
-				fprintf(stdout, "# Samples: %Ld\n#\n",
-					hists->stats.total_period);
-			else
-				fprintf(stdout, "# Samples: %Ld %s\n#\n",
-					hists->stats.total_period,
-					__event_name(hists->type, hists->config));
+				evname = __event_name(hists->type, hists->config);
+
+			hists__fprintf_nr_sample_events(hists, evname, stdout);
 
 			hists__fprintf(hists, NULL, false, stdout);
 			fprintf(stdout, "\n\n");
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index c592245..f75c5f6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -9,21 +9,21 @@ struct callchain_param	callchain_param = {
 	.min_percent = 0.5
 };
 
-static void hist_entry__add_cpumode_count(struct hist_entry *self,
-					  unsigned int cpumode, u64 count)
+static void hist_entry__add_cpumode_period(struct hist_entry *self,
+					   unsigned int cpumode, u64 period)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		self->count_sys += count;
+		self->period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		self->count_us += count;
+		self->period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		self->count_guest_sys += count;
+		self->period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		self->count_guest_us += count;
+		self->period_guest_us += period;
 		break;
 	default:
 		break;
@@ -31,7 +31,7 @@ static void hist_entry__add_cpumode_count(struct hist_entry *self,
 }
 
 /*
- * histogram, sorted on item, collects counts
+ * histogram, sorted on item, collects periods
  */
 
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
@@ -41,6 +41,7 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 
 	if (self != NULL) {
 		*self = *template;
+		self->nr_events = 1;
 		if (symbol_conf.use_callchain)
 			callchain_init(self->callchain);
 	}
@@ -57,7 +58,7 @@ static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 count)
+				      struct symbol *sym_parent, u64 period)
 {
 	struct rb_node **p = &self->entries.rb_node;
 	struct rb_node *parent = NULL;
@@ -70,7 +71,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		},
 		.ip	= al->addr,
 		.level	= al->level,
-		.count	= count,
+		.period	= period,
 		.parent = sym_parent,
 	};
 	int cmp;
@@ -82,7 +83,8 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 		cmp = hist_entry__cmp(&entry, he);
 
 		if (!cmp) {
-			he->count += count;
+			he->period += period;
+			++he->nr_events;
 			goto out;
 		}
 
@@ -99,7 +101,7 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 	rb_insert_color(&he->rb_node, &self->entries);
 	hists__inc_nr_entries(self, he);
 out:
-	hist_entry__add_cpumode_count(he, al->cpumode, count);
+	hist_entry__add_cpumode_period(he, al->cpumode, period);
 	return he;
 }
 
@@ -160,7 +162,7 @@ static bool collapse__insert_entry(struct rb_root *root, struct hist_entry *he)
 		cmp = hist_entry__collapse(iter, he);
 
 		if (!cmp) {
-			iter->count += he->count;
+			iter->period += he->period;
 			hist_entry__free(he);
 			return false;
 		}
@@ -203,7 +205,7 @@ void hists__collapse_resort(struct hists *self)
 }
 
 /*
- * reverse the map, sort on count.
+ * reverse the map, sort on period.
  */
 
 static void __hists__insert_output_entry(struct rb_root *entries,
@@ -222,7 +224,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
 
-		if (he->count > iter->count)
+		if (he->period > iter->period)
 			p = &(*p)->rb_left;
 		else
 			p = &(*p)->rb_right;
@@ -288,7 +290,7 @@ static size_t ipchain__fprintf_graph_line(FILE *fp, int depth, int depth_mask,
 }
 
 static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
-				     int depth, int depth_mask, int count,
+				     int depth, int depth_mask, int period,
 				     u64 total_samples, int hits,
 				     int left_margin)
 {
@@ -301,7 +303,7 @@ static size_t ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain,
 			ret += fprintf(fp, "|");
 		else
 			ret += fprintf(fp, " ");
-		if (!count && i == depth - 1) {
+		if (!period && i == depth - 1) {
 			double percent;
 
 			percent = hits * 100.0 / total_samples;
@@ -516,7 +518,7 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 			 long displacement, bool color, u64 session_total)
 {
 	struct sort_entry *se;
-	u64 count, total, count_sys, count_us, count_guest_sys, count_guest_us;
+	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
 	const char *sep = symbol_conf.field_sep;
 	int ret;
 
@@ -524,57 +526,57 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		return 0;
 
 	if (pair_hists) {
-		count = self->pair ? self->pair->count : 0;
+		period = self->pair ? self->pair->period : 0;
 		total = pair_hists->stats.total_period;
-		count_sys = self->pair ? self->pair->count_sys : 0;
-		count_us = self->pair ? self->pair->count_us : 0;
-		count_guest_sys = self->pair ? self->pair->count_guest_sys : 0;
-		count_guest_us = self->pair ? self->pair->count_guest_us : 0;
+		period_sys = self->pair ? self->pair->period_sys : 0;
+		period_us = self->pair ? self->pair->period_us : 0;
+		period_guest_sys = self->pair ? self->pair->period_guest_sys : 0;
+		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
 	} else {
-		count = self->count;
+		period = self->period;
 		total = session_total;
-		count_sys = self->count_sys;
-		count_us = self->count_us;
-		count_guest_sys = self->count_guest_sys;
-		count_guest_us = self->count_guest_us;
+		period_sys = self->period_sys;
+		period_us = self->period_us;
+		period_guest_sys = self->period_guest_sys;
+		period_guest_us = self->period_guest_us;
 	}
 
 	if (total) {
 		if (color)
 			ret = percent_color_snprintf(s, size,
 						     sep ? "%.2f" : "   %6.2f%%",
-						     (count * 100.0) / total);
+						     (period * 100.0) / total);
 		else
 			ret = snprintf(s, size, sep ? "%.2f" : "   %6.2f%%",
-				       (count * 100.0) / total);
+				       (period * 100.0) / total);
 		if (symbol_conf.show_cpu_utilization) {
 			ret += percent_color_snprintf(s + ret, size - ret,
 					sep ? "%.2f" : "   %6.2f%%",
-					(count_sys * 100.0) / total);
+					(period_sys * 100.0) / total);
 			ret += percent_color_snprintf(s + ret, size - ret,
 					sep ? "%.2f" : "   %6.2f%%",
-					(count_us * 100.0) / total);
+					(period_us * 100.0) / total);
 			if (perf_guest) {
 				ret += percent_color_snprintf(s + ret,
 						size - ret,
 						sep ? "%.2f" : "   %6.2f%%",
-						(count_guest_sys * 100.0) /
+						(period_guest_sys * 100.0) /
 								total);
 				ret += percent_color_snprintf(s + ret,
 						size - ret,
 						sep ? "%.2f" : "   %6.2f%%",
-						(count_guest_us * 100.0) /
+						(period_guest_us * 100.0) /
 								total);
 			}
 		}
 	} else
-		ret = snprintf(s, size, sep ? "%lld" : "%12lld ", count);
+		ret = snprintf(s, size, sep ? "%lld" : "%12lld ", period);
 
 	if (symbol_conf.show_nr_samples) {
 		if (sep)
-			ret += snprintf(s + ret, size - ret, "%c%lld", *sep, count);
+			ret += snprintf(s + ret, size - ret, "%c%lld", *sep, period);
 		else
-			ret += snprintf(s + ret, size - ret, "%11lld", count);
+			ret += snprintf(s + ret, size - ret, "%11lld", period);
 	}
 
 	if (pair_hists) {
@@ -582,9 +584,9 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 		double old_percent = 0, new_percent = 0, diff;
 
 		if (total > 0)
-			old_percent = (count * 100.0) / total;
+			old_percent = (period * 100.0) / total;
 		if (session_total > 0)
-			new_percent = (self->count * 100.0) / session_total;
+			new_percent = (self->period * 100.0) / session_total;
 
 		diff = new_percent - old_percent;
 
@@ -796,6 +798,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 	struct rb_node *nd;
 
 	self->nr_entries = self->stats.total_period = 0;
+	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	self->max_sym_namelen = 0;
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
@@ -812,7 +815,8 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 		h->filtered &= ~(1 << HIST_FILTER__DSO);
 		if (!h->filtered) {
 			++self->nr_entries;
-			self->stats.total_period += h->count;
+			self->stats.total_period += h->period;
+			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 			if (h->ms.sym &&
 			    self->max_sym_namelen < h->ms.sym->namelen)
 				self->max_sym_namelen = h->ms.sym->namelen;
@@ -825,6 +829,7 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 	struct rb_node *nd;
 
 	self->nr_entries = self->stats.total_period = 0;
+	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	self->max_sym_namelen = 0;
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
@@ -837,7 +842,8 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 		h->filtered &= ~(1 << HIST_FILTER__THREAD);
 		if (!h->filtered) {
 			++self->nr_entries;
-			self->stats.total_period += h->count;
+			self->stats.total_period += h->period;
+			self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 			if (h->ms.sym &&
 			    self->max_sym_namelen < h->ms.sym->namelen)
 				self->max_sym_namelen = h->ms.sym->namelen;
@@ -881,7 +887,7 @@ int hist_entry__inc_addr_samples(struct hist_entry *self, u64 ip)
 	h->sum++;
 	h->ip[offset]++;
 
-	pr_debug3("%#Lx %s: count++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
+	pr_debug3("%#Lx %s: period++ [ip: %#Lx, %#Lx] => %Ld\n", self->ms.sym->start,
 		  self->ms.sym->name, ip, ip - self->ms.sym->start, h->ip[offset]);
 	return 0;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index da6b848..6f17dcd 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -69,7 +69,7 @@ struct hists {
 
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
-				      struct symbol *parent, u64 count);
+				      struct symbol *parent, u64 period);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
 int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 010bacf..3402453 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -680,16 +680,18 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 	struct ui_progress *progress;
 	struct rb_node *nd;
 	u64 curr_hist = 0;
-	char seq[] = ".";
+	char seq[] = ".", unit;
 	char str[256];
+	unsigned long nr_events = hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 	if (self->form) {
 		newtFormDestroy(self->form);
 		newtPopWindow();
 	}
 
-	snprintf(str, sizeof(str), "Samples: %Ld                            ",
-		 hists->stats.total_period);
+	nr_events = convert_unit(nr_events, &unit);
+	snprintf(str, sizeof(str), "Events: %lu%c                            ",
+		 nr_events, unit);
 	newtDrawRootText(0, 0, str);
 
 	newtGetScreenSize(NULL, &rows);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index af301ac..eab2e0b 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -43,14 +43,15 @@ extern enum sort_type sort__first_dimension;
 
 struct hist_entry {
 	struct rb_node		rb_node;
-	u64			count;
-	u64			count_sys;
-	u64			count_us;
-	u64			count_guest_sys;
-	u64			count_guest_us;
+	u64			period;
+	u64			period_sys;
+	u64			period_us;
+	u64			period_guest_sys;
+	u64			period_guest_us;
 	struct map_symbol	ms;
 	struct thread		*thread;
 	u64			ip;
+	u32			nr_events;
 	char			level;
 	u8			filtered;
 	struct symbol		*parent;
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index f9b890f..2142656 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -92,3 +92,25 @@ out_close_from:
 out:
 	return err;
 }
+
+unsigned long convert_unit(unsigned long value, char *unit)
+{
+	*unit = ' ';
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'K';
+	}
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'M';
+	}
+
+	if (value > 1000) {
+		value /= 1000;
+		*unit = 'G';
+	}
+
+	return value;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index fbf45d1..0795bf3 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -423,6 +423,7 @@ char **argv_split(const char *str, int *argcp);
 void argv_free(char **argv);
 bool strglobmatch(const char *str, const char *pat);
 bool strlazymatch(const char *str, const char *pat);
+unsigned long convert_unit(unsigned long value, char *unit);
 
 #define _STR(x) #x
 #define STR(x) _STR(x)
-- 
1.6.2.5

