Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2AHLrx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 06:47:53 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39167 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2AHLrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 06:47:48 -0500
Date: Sun, 8 Jan 2012 03:47:19 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-me4dyj6s5snh7jr8wb9gzt82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists: Stop using 'self'
  for struct hist_entry
Git-Commit-ID: 12c142781ec076fad617e7cd9f83c8618d909619
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 03:47:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12c142781ec076fad617e7cd9f83c8618d909619
Gitweb:     http://git.kernel.org/tip/12c142781ec076fad617e7cd9f83c8618d909619
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Jan 2012 12:27:03 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 6 Jan 2012 15:42:52 -0200

perf hists: Stop using 'self' for struct hist_entry

Stop using this python/OOP convention, doesn't really helps. Will do
more from time to time till we get it cleaned up in all of /perf.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-me4dyj6s5snh7jr8wb9gzt82@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |   89 +++++++++++++++++++++++++-----------------------
 tools/perf/util/hist.h |    7 +---
 2 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 20059d1..4df4495 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -76,21 +76,21 @@ static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 	}
 }
 
-static void hist_entry__add_cpumode_period(struct hist_entry *self,
+static void hist_entry__add_cpumode_period(struct hist_entry *he,
 					   unsigned int cpumode, u64 period)
 {
 	switch (cpumode) {
 	case PERF_RECORD_MISC_KERNEL:
-		self->period_sys += period;
+		he->period_sys += period;
 		break;
 	case PERF_RECORD_MISC_USER:
-		self->period_us += period;
+		he->period_us += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_KERNEL:
-		self->period_guest_sys += period;
+		he->period_guest_sys += period;
 		break;
 	case PERF_RECORD_MISC_GUEST_USER:
-		self->period_guest_us += period;
+		he->period_guest_us += period;
 		break;
 	default:
 		break;
@@ -165,18 +165,18 @@ void hists__decay_entries_threaded(struct hists *hists,
 static struct hist_entry *hist_entry__new(struct hist_entry *template)
 {
 	size_t callchain_size = symbol_conf.use_callchain ? sizeof(struct callchain_root) : 0;
-	struct hist_entry *self = malloc(sizeof(*self) + callchain_size);
+	struct hist_entry *he = malloc(sizeof(*he) + callchain_size);
 
-	if (self != NULL) {
-		*self = *template;
-		self->nr_events = 1;
-		if (self->ms.map)
-			self->ms.map->referenced = true;
+	if (he != NULL) {
+		*he = *template;
+		he->nr_events = 1;
+		if (he->ms.map)
+			he->ms.map->referenced = true;
 		if (symbol_conf.use_callchain)
-			callchain_init(self->callchain);
+			callchain_init(he->callchain);
 	}
 
-	return self;
+	return he;
 }
 
 static void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
@@ -677,15 +677,16 @@ static size_t callchain__fprintf_flat(FILE *fp, struct callchain_node *self,
 	return ret;
 }
 
-static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
-					    u64 total_samples, int left_margin)
+static size_t hist_entry_callchain__fprintf(struct hist_entry *he,
+					    u64 total_samples, int left_margin,
+					    FILE *fp)
 {
 	struct rb_node *rb_node;
 	struct callchain_node *chain;
 	size_t ret = 0;
 	u32 entries_printed = 0;
 
-	rb_node = rb_first(&self->sorted_chain);
+	rb_node = rb_first(&he->sorted_chain);
 	while (rb_node) {
 		double percent;
 
@@ -730,7 +731,7 @@ void hists__output_recalc_col_len(struct hists *hists, int max_rows)
 	}
 }
 
-static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
+static int hist_entry__pcnt_snprintf(struct hist_entry *he, char *s,
 				     size_t size, struct hists *pair_hists,
 				     bool show_displacement, long displacement,
 				     bool color, u64 total_period)
@@ -740,25 +741,25 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
 	const char *sep = symbol_conf.field_sep;
 	int ret;
 
-	if (symbol_conf.exclude_other && !self->parent)
+	if (symbol_conf.exclude_other && !he->parent)
 		return 0;
 
 	if (pair_hists) {
-		period = self->pair ? self->pair->period : 0;
-		nr_events = self->pair ? self->pair->nr_events : 0;
+		period = he->pair ? he->pair->period : 0;
+		nr_events = he->pair ? he->pair->nr_events : 0;
 		total = pair_hists->stats.total_period;
-		period_sys = self->pair ? self->pair->period_sys : 0;
-		period_us = self->pair ? self->pair->period_us : 0;
-		period_guest_sys = self->pair ? self->pair->period_guest_sys : 0;
-		period_guest_us = self->pair ? self->pair->period_guest_us : 0;
+		period_sys = he->pair ? he->pair->period_sys : 0;
+		period_us = he->pair ? he->pair->period_us : 0;
+		period_guest_sys = he->pair ? he->pair->period_guest_sys : 0;
+		period_guest_us = he->pair ? he->pair->period_guest_us : 0;
 	} else {
-		period = self->period;
-		nr_events = self->nr_events;
+		period = he->period;
+		nr_events = he->nr_events;
 		total = total_period;
-		period_sys = self->period_sys;
-		period_us = self->period_us;
-		period_guest_sys = self->period_guest_sys;
-		period_guest_us = self->period_guest_us;
+		period_sys = he->period_sys;
+		period_us = he->period_us;
+		period_guest_sys = he->period_guest_sys;
+		period_guest_us = he->period_guest_us;
 	}
 
 	if (total) {
@@ -813,7 +814,7 @@ static int hist_entry__pcnt_snprintf(struct hist_entry *self, char *s,
 		if (total > 0)
 			old_percent = (period * 100.0) / total;
 		if (total_period > 0)
-			new_percent = (self->period * 100.0) / total_period;
+			new_percent = (he->period * 100.0) / total_period;
 
 		diff = new_percent - old_percent;
 
@@ -862,9 +863,10 @@ int hist_entry__snprintf(struct hist_entry *he, char *s, size_t size,
 	return ret;
 }
 
-int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
-			struct hists *pair_hists, bool show_displacement,
-			long displacement, FILE *fp, u64 total_period)
+static int hist_entry__fprintf(struct hist_entry *he, size_t size,
+			       struct hists *hists, struct hists *pair_hists,
+			       bool show_displacement, long displacement,
+			       u64 total_period, FILE *fp)
 {
 	char bf[512];
 	int ret;
@@ -879,9 +881,9 @@ int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
 	return fprintf(fp, "%s\n", bf);
 }
 
-static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
-					    struct hists *hists, FILE *fp,
-					    u64 total_period)
+static size_t hist_entry__fprintf_callchain(struct hist_entry *he,
+					    struct hists *hists,
+					    u64 total_period, FILE *fp)
 {
 	int left_margin = 0;
 
@@ -889,11 +891,10 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
 							 typeof(*se), list);
 		left_margin = hists__col_len(hists, se->se_width_idx);
-		left_margin -= thread__comm_len(self->thread);
+		left_margin -= thread__comm_len(he->thread);
 	}
 
-	return hist_entry_callchain__fprintf(fp, self, total_period,
-					     left_margin);
+	return hist_entry_callchain__fprintf(he, total_period, left_margin, fp);
 }
 
 size_t hists__fprintf(struct hists *hists, struct hists *pair,
@@ -903,6 +904,7 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 	struct sort_entry *se;
 	struct rb_node *nd;
 	size_t ret = 0;
+	u64 total_period;
 	unsigned long position = 1;
 	long displacement = 0;
 	unsigned int width;
@@ -1025,6 +1027,8 @@ size_t hists__fprintf(struct hists *hists, struct hists *pair,
 		goto out;
 
 print_entries:
+	total_period = hists->stats.total_period;
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
@@ -1040,11 +1044,10 @@ print_entries:
 			++position;
 		}
 		ret += hist_entry__fprintf(h, max_cols, hists, pair, show_displacement,
-					   displacement, fp, hists->stats.total_period);
+					   displacement, total_period, fp);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, hists, fp,
-							     hists->stats.total_period);
+			ret += hist_entry__fprintf_callchain(h, hists, total_period, fp);
 		if (max_rows && ++nr_rows >= max_rows)
 			goto out;
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ff6f9d5..f55f0a8d 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -66,11 +66,8 @@ struct hists {
 struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct addr_location *al,
 				      struct symbol *parent, u64 period);
-extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *he, size_t size, struct hists *hists,
-			struct hists *pair_hists, bool show_displacement,
-			long displacement, FILE *fp, u64 session_total);
+int64_t hist_entry__cmp(struct hist_entry *left, struct hist_entry *right);
+int64_t hist_entry__collapse(struct hist_entry *left, struct hist_entry *right);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
 			 struct hists *hists);
 void hist_entry__free(struct hist_entry *);
