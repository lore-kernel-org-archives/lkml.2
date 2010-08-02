Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab0HBBLv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:11:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:50979 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab0HBBJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:09 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/19] perf sort: Make column width code per hists instance
Date: Sun,  1 Aug 2010 22:08:37 -0300
Message-Id: <1280711334-30000-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

They were globals, and since we support multiple hists and sessions
at the same time, it doesn't make sense to calculate those values
considering all symbols in all sessions.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/event.c  |   34 ++++++-------
 tools/perf/util/hist.c   |  115 +++++++++++++++++++++++++++++++--------------
 tools/perf/util/hist.h   |   27 ++++++++--
 tools/perf/util/newt.c   |    9 ++--
 tools/perf/util/sort.c   |   17 +++----
 tools/perf/util/sort.h   |    6 +--
 tools/perf/util/symbol.c |    9 ++++
 tools/perf/util/symbol.h |    2 +
 8 files changed, 140 insertions(+), 79 deletions(-)

diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d7f21d7..121339f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -340,30 +340,29 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	return process(&ev, session);
 }
 
-static void thread__comm_adjust(struct thread *self)
+static void thread__comm_adjust(struct thread *self, struct hists *hists)
 {
 	char *comm = self->comm;
 
 	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 	    (!symbol_conf.comm_list ||
 	     strlist__has_entry(symbol_conf.comm_list, comm))) {
-		unsigned int slen = strlen(comm);
+		u16 slen = strlen(comm);
 
-		if (slen > comms__col_width) {
-			comms__col_width = slen;
-			threads__col_width = slen + 6;
-		}
+		if (hists__new_col_len(hists, HISTC_COMM, slen))
+			hists__set_col_len(hists, HISTC_THREAD, slen + 6);
 	}
 }
 
-static int thread__set_comm_adjust(struct thread *self, const char *comm)
+static int thread__set_comm_adjust(struct thread *self, const char *comm,
+				   struct hists *hists)
 {
 	int ret = thread__set_comm(self, comm);
 
 	if (ret)
 		return ret;
 
-	thread__comm_adjust(self);
+	thread__comm_adjust(self, hists);
 
 	return 0;
 }
@@ -374,7 +373,8 @@ int event__process_comm(event_t *self, struct perf_session *session)
 
 	dump_printf(": %s:%d\n", self->comm.comm, self->comm.tid);
 
-	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm)) {
+	if (thread == NULL || thread__set_comm_adjust(thread, self->comm.comm,
+						      &session->hists)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
@@ -641,16 +641,13 @@ void thread__find_addr_location(struct thread *self,
 		al->sym = NULL;
 }
 
-static void dso__calc_col_width(struct dso *self)
+static void dso__calc_col_width(struct dso *self, struct hists *hists)
 {
 	if (!symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 	    (!symbol_conf.dso_list ||
 	     strlist__has_entry(symbol_conf.dso_list, self->name))) {
-		u16 slen = self->short_name_len;
-		if (verbose)
-			slen = self->long_name_len;
-		if (dsos__col_width < slen)
-			dsos__col_width = slen;
+		u16 slen = dso__name_len(self);
+		hists__new_col_len(hists, HISTC_DSO, slen);
 	}
 
 	self->slen_calculated = 1;
@@ -729,16 +726,17 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 		 * sampled.
 		 */
 		if (!sort_dso.elide && !al->map->dso->slen_calculated)
-			dso__calc_col_width(al->map->dso);
+			dso__calc_col_width(al->map->dso, &session->hists);
 
 		al->sym = map__find_symbol(al->map, al->addr, filter);
 	} else {
 		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
 
-		if (dsos__col_width < unresolved_col_width &&
+		if (hists__col_len(&session->hists, HISTC_DSO) < unresolved_col_width &&
 		    !symbol_conf.col_width_list_str && !symbol_conf.field_sep &&
 		    !symbol_conf.dso_list)
-			dsos__col_width = unresolved_col_width;
+			hists__set_col_len(&session->hists, HISTC_DSO,
+					   unresolved_col_width);
 	}
 
 	if (symbol_conf.sym_list && al->sym &&
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index d998d1d..0bc6790 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -16,6 +16,50 @@ struct callchain_param	callchain_param = {
 	.min_percent = 0.5
 };
 
+u16 hists__col_len(struct hists *self, enum hist_column col)
+{
+	return self->col_len[col];
+}
+
+void hists__set_col_len(struct hists *self, enum hist_column col, u16 len)
+{
+	self->col_len[col] = len;
+}
+
+bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len)
+{
+	if (len > hists__col_len(self, col)) {
+		hists__set_col_len(self, col, len);
+		return true;
+	}
+	return false;
+}
+
+static void hists__reset_col_len(struct hists *self)
+{
+	enum hist_column col;
+
+	for (col = 0; col < HISTC_NR_COLS; ++col)
+		hists__set_col_len(self, col, 0);
+}
+
+static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
+{
+	u16 len;
+
+	if (h->ms.sym)
+		hists__new_col_len(self, HISTC_SYMBOL, h->ms.sym->namelen);
+
+	len = thread__comm_len(h->thread);
+	if (hists__new_col_len(self, HISTC_COMM, len))
+		hists__set_col_len(self, HISTC_THREAD, len + 6);
+
+	if (h->ms.map) {
+		len = dso__name_len(h->ms.map->dso);
+		hists__new_col_len(self, HISTC_DSO, len);
+	}
+}
+
 static void hist_entry__add_cpumode_period(struct hist_entry *self,
 					   unsigned int cpumode, u64 period)
 {
@@ -56,13 +100,12 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return self;
 }
 
-static void hists__inc_nr_entries(struct hists *self, struct hist_entry *entry)
+static void hists__inc_nr_entries(struct hists *self, struct hist_entry *h)
 {
-	if (entry->filtered)
-		return;
-	if (entry->ms.sym && self->max_sym_namelen < entry->ms.sym->namelen)
-		self->max_sym_namelen = entry->ms.sym->namelen;
-	++self->nr_entries;
+	if (!h->filtered) {
+		hists__calc_col_len(self, h);
+		++self->nr_entries;
+	}
 }
 
 static u8 symbol__parent_filter(const struct symbol *parent)
@@ -208,7 +251,7 @@ void hists__collapse_resort(struct hists *self)
 	tmp = RB_ROOT;
 	next = rb_first(&self->entries);
 	self->nr_entries = 0;
-	self->max_sym_namelen = 0;
+	hists__reset_col_len(self);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
@@ -265,7 +308,7 @@ void hists__output_resort(struct hists *self)
 	next = rb_first(&self->entries);
 
 	self->nr_entries = 0;
-	self->max_sym_namelen = 0;
+	hists__reset_col_len(self);
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node);
@@ -532,8 +575,9 @@ static size_t hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
 }
 
 int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
-			 struct hists *pair_hists, bool show_displacement,
-			 long displacement, bool color, u64 session_total)
+			 struct hists *hists, struct hists *pair_hists,
+			 bool show_displacement, long displacement,
+			 bool color, u64 session_total)
 {
 	struct sort_entry *se;
 	u64 period, total, period_sys, period_us, period_guest_sys, period_guest_us;
@@ -637,24 +681,25 @@ int hist_entry__snprintf(struct hist_entry *self, char *s, size_t size,
 
 		ret += snprintf(s + ret, size - ret, "%s", sep ?: "  ");
 		ret += se->se_snprintf(self, s + ret, size - ret,
-				       se->se_width ? *se->se_width : 0);
+				       hists__col_len(hists, se->se_width_idx));
 	}
 
 	return ret;
 }
 
-int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
-			bool show_displacement, long displacement, FILE *fp,
-			u64 session_total)
+int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+			struct hists *pair_hists, bool show_displacement,
+			long displacement, FILE *fp, u64 session_total)
 {
 	char bf[512];
-	hist_entry__snprintf(self, bf, sizeof(bf), pair_hists,
+	hist_entry__snprintf(self, bf, sizeof(bf), hists, pair_hists,
 			     show_displacement, displacement,
 			     true, session_total);
 	return fprintf(fp, "%s\n", bf);
 }
 
-static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
+static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
+					    struct hists *hists, FILE *fp,
 					    u64 session_total)
 {
 	int left_margin = 0;
@@ -662,7 +707,7 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self, FILE *fp,
 	if (sort__first_dimension == SORT_COMM) {
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
 							 typeof(*se), list);
-		left_margin = se->se_width ? *se->se_width : 0;
+		left_margin = hists__col_len(hists, se->se_width_idx);
 		left_margin -= thread__comm_len(self->thread);
 	}
 
@@ -733,17 +778,17 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 			continue;
 		}
 		width = strlen(se->se_header);
-		if (se->se_width) {
-			if (symbol_conf.col_width_list_str) {
-				if (col_width) {
-					*se->se_width = atoi(col_width);
-					col_width = strchr(col_width, ',');
-					if (col_width)
-						++col_width;
-				}
+		if (symbol_conf.col_width_list_str) {
+			if (col_width) {
+				hists__set_col_len(self, se->se_width_idx,
+						   atoi(col_width));
+				col_width = strchr(col_width, ',');
+				if (col_width)
+					++col_width;
 			}
-			width = *se->se_width = max(*se->se_width, width);
 		}
+		if (!hists__new_col_len(self, se->se_width_idx, width))
+			width = hists__col_len(self, se->se_width_idx);
 		fprintf(fp, "  %*s", width, se->se_header);
 	}
 	fprintf(fp, "\n");
@@ -766,9 +811,8 @@ size_t hists__fprintf(struct hists *self, struct hists *pair,
 			continue;
 
 		fprintf(fp, "  ");
-		if (se->se_width)
-			width = *se->se_width;
-		else
+		width = hists__col_len(self, se->se_width_idx);
+		if (width == 0)
 			width = strlen(se->se_header);
 		for (i = 0; i < width; i++)
 			fprintf(fp, ".");
@@ -788,12 +832,12 @@ print_entries:
 				displacement = 0;
 			++position;
 		}
-		ret += hist_entry__fprintf(h, pair, show_displacement,
+		ret += hist_entry__fprintf(h, self, pair, show_displacement,
 					   displacement, fp, self->stats.total_period);
 
 		if (symbol_conf.use_callchain)
-			ret += hist_entry__fprintf_callchain(h, fp, self->stats.total_period);
-
+			ret += hist_entry__fprintf_callchain(h, self, fp,
+							     self->stats.total_period);
 		if (h->ms.map == NULL && verbose > 1) {
 			__map_groups__fprintf_maps(&h->thread->mg,
 						   MAP__FUNCTION, verbose, fp);
@@ -817,8 +861,7 @@ static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
 	self->stats.total_period += h->period;
 	self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 
-	if (h->ms.sym && self->max_sym_namelen < h->ms.sym->namelen)
-		self->max_sym_namelen = h->ms.sym->namelen;
+	hists__calc_col_len(self, h);
 }
 
 void hists__filter_by_dso(struct hists *self, const struct dso *dso)
@@ -827,7 +870,7 @@ void hists__filter_by_dso(struct hists *self, const struct dso *dso)
 
 	self->nr_entries = self->stats.total_period = 0;
 	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	self->max_sym_namelen = 0;
+	hists__reset_col_len(self);
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
@@ -850,7 +893,7 @@ void hists__filter_by_thread(struct hists *self, const struct thread *thread)
 
 	self->nr_entries = self->stats.total_period = 0;
 	self->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
-	self->max_sym_namelen = 0;
+	hists__reset_col_len(self);
 
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 83fa33a..92962b2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -56,6 +56,16 @@ struct events_stats {
 	u32 nr_unknown_events;
 };
 
+enum hist_column {
+	HISTC_SYMBOL,
+	HISTC_DSO,
+	HISTC_THREAD,
+	HISTC_COMM,
+	HISTC_PARENT,
+	HISTC_CPU,
+	HISTC_NR_COLS, /* Last entry */
+};
+
 struct hists {
 	struct rb_node		rb_node;
 	struct rb_root		entries;
@@ -64,7 +74,7 @@ struct hists {
 	u64			config;
 	u64			event_stream;
 	u32			type;
-	u32			max_sym_namelen;
+	u16			col_len[HISTC_NR_COLS];
 };
 
 struct hist_entry *__hists__add_entry(struct hists *self,
@@ -72,12 +82,13 @@ struct hist_entry *__hists__add_entry(struct hists *self,
 				      struct symbol *parent, u64 period);
 extern int64_t hist_entry__cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t hist_entry__collapse(struct hist_entry *, struct hist_entry *);
-int hist_entry__fprintf(struct hist_entry *self, struct hists *pair_hists,
-			bool show_displacement, long displacement, FILE *fp,
-			u64 total);
+int hist_entry__fprintf(struct hist_entry *self, struct hists *hists,
+			struct hists *pair_hists, bool show_displacement,
+			long displacement, FILE *fp, u64 total);
 int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
-			 struct hists *pair_hists, bool show_displacement,
-			 long displacement, bool color, u64 total);
+			 struct hists *hists, struct hists *pair_hists,
+			 bool show_displacement, long displacement,
+			 bool color, u64 total);
 void hist_entry__free(struct hist_entry *);
 
 void hists__output_resort(struct hists *self);
@@ -95,6 +106,10 @@ int hist_entry__annotate(struct hist_entry *self, struct list_head *head);
 void hists__filter_by_dso(struct hists *self, const struct dso *dso);
 void hists__filter_by_thread(struct hists *self, const struct thread *thread);
 
+u16 hists__col_len(struct hists *self, enum hist_column col);
+void hists__set_col_len(struct hists *self, enum hist_column col, u16 len);
+bool hists__new_col_len(struct hists *self, enum hist_column col, u16 len);
+
 #ifdef NO_NEWT_SUPPORT
 static inline int hists__browse(struct hists *self __used,
 				const char *helpline __used,
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 7979003..ab6eb36 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -692,7 +692,8 @@ static void hist_entry__append_callchain_browser(struct hist_entry *self,
 }
 
 static size_t hist_entry__append_browser(struct hist_entry *self,
-					 newtComponent tree, u64 total)
+					 newtComponent tree,
+					 struct hists *hists)
 {
 	char s[256];
 	size_t ret;
@@ -700,8 +701,8 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 	if (symbol_conf.exclude_other && !self->parent)
 		return 0;
 
-	ret = hist_entry__snprintf(self, s, sizeof(s), NULL,
-				   false, 0, false, total);
+	ret = hist_entry__snprintf(self, s, sizeof(s), hists, NULL,
+				   false, 0, false, hists->stats.total_period);
 	if (symbol_conf.use_callchain) {
 		int indexes[2];
 
@@ -842,7 +843,7 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 		if (h->filtered)
 			continue;
 
-		len = hist_entry__append_browser(h, self->tree, hists->stats.total_period);
+		len = hist_entry__append_browser(h, self->tree, hists);
 		if (len > max_len)
 			max_len = len;
 		if (symbol_conf.use_callchain)
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index c27b4b0..1c61a4f 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -1,4 +1,5 @@
 #include "sort.h"
+#include "hist.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -10,11 +11,6 @@ int		sort__has_parent = 0;
 
 enum sort_type	sort__first_dimension;
 
-unsigned int dsos__col_width;
-unsigned int comms__col_width;
-unsigned int threads__col_width;
-unsigned int cpus__col_width;
-static unsigned int parent_symbol__col_width;
 char * field_sep;
 
 LIST_HEAD(hist_entry__sort_list);
@@ -36,7 +32,7 @@ struct sort_entry sort_thread = {
 	.se_header	= "Command:  Pid",
 	.se_cmp		= sort__thread_cmp,
 	.se_snprintf	= hist_entry__thread_snprintf,
-	.se_width	= &threads__col_width,
+	.se_width_idx	= HISTC_THREAD,
 };
 
 struct sort_entry sort_comm = {
@@ -44,34 +40,35 @@ struct sort_entry sort_comm = {
 	.se_cmp		= sort__comm_cmp,
 	.se_collapse	= sort__comm_collapse,
 	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width	= &comms__col_width,
+	.se_width_idx	= HISTC_COMM,
 };
 
 struct sort_entry sort_dso = {
 	.se_header	= "Shared Object",
 	.se_cmp		= sort__dso_cmp,
 	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width	= &dsos__col_width,
+	.se_width_idx	= HISTC_DSO,
 };
 
 struct sort_entry sort_sym = {
 	.se_header	= "Symbol",
 	.se_cmp		= sort__sym_cmp,
 	.se_snprintf	= hist_entry__sym_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
 };
 
 struct sort_entry sort_parent = {
 	.se_header	= "Parent symbol",
 	.se_cmp		= sort__parent_cmp,
 	.se_snprintf	= hist_entry__parent_snprintf,
-	.se_width	= &parent_symbol__col_width,
+	.se_width_idx	= HISTC_PARENT,
 };
  
 struct sort_entry sort_cpu = {
 	.se_header      = "CPU",
 	.se_cmp	        = sort__cpu_cmp,
 	.se_snprintf    = hist_entry__cpu_snprintf,
-	.se_width	= &cpus__col_width,
+	.se_width_idx	= HISTC_CPU,
 };
 
 struct sort_dimension {
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 560c855..03a1722 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -36,10 +36,6 @@ extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
 extern struct sort_entry sort_parent;
-extern unsigned int dsos__col_width;
-extern unsigned int comms__col_width;
-extern unsigned int threads__col_width;
-extern unsigned int cpus__col_width;
 extern enum sort_type sort__first_dimension;
 
 struct hist_entry {
@@ -87,7 +83,7 @@ struct sort_entry {
 	int64_t (*se_collapse)(struct hist_entry *, struct hist_entry *);
 	int	(*se_snprintf)(struct hist_entry *self, char *bf, size_t size,
 			       unsigned int width);
-	unsigned int *se_width;
+	u8	se_width_idx;
 	bool	elide;
 };
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 971d0a0..bc6e7e8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -12,6 +12,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include "build-id.h"
+#include "debug.h"
 #include "symbol.h"
 #include "strlist.h"
 
@@ -40,6 +41,14 @@ struct symbol_conf symbol_conf = {
 	.try_vmlinux_path = true,
 };
 
+int dso__name_len(const struct dso *self)
+{
+	if (verbose)
+		return self->long_name_len;
+
+	return self->short_name_len;
+}
+
 bool dso__loaded(const struct dso *self, enum map_type type)
 {
 	return self->loaded & (1 << type);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 80e569b..d436ee3 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -146,6 +146,8 @@ struct dso *dso__new(const char *name);
 struct dso *dso__new_kernel(const char *name);
 void dso__delete(struct dso *self);
 
+int dso__name_len(const struct dso *self);
+
 bool dso__loaded(const struct dso *self, enum map_type type);
 bool dso__sorted_by_name(const struct dso *self, enum map_type type);
 
-- 
1.6.2.5

