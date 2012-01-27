Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2A0VA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 16:00:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62378 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2A0U6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:58:49 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        robert.richter@amd.com, ming.m.lin@intel.com, andi@firstfloor.org,
        asharma@fb.com, ravitillo@lbl.gov, vweaver1@eecs.utk.edu,
        khandual@linux.vnet.ibm.com, dsahern@gmail.com
Subject: [PATCH v4 11/18] perf: add code to support PERF_SAMPLE_BRANCH_STACK
Date: Fri, 27 Jan 2012 21:56:11 +0100
Message-Id: <1327697778-18515-12-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1327697778-18515-1-git-send-email-eranian@google.com>
References: <1327697778-18515-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roberto Agostino Vitillo <ravitillo@lbl.gov>

This patch adds:
- ability to parse samples with PERF_SAMPLE_BRANCH_STACK
- sort on branches
- build histograms on branches

Signed-off-by: Roberto Agostino Vitillo <ravitillo@lbl.gov>
Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/perf.h          |   17 ++
 tools/perf/util/annotate.c |    2 +-
 tools/perf/util/event.h    |    1 +
 tools/perf/util/evsel.c    |   10 ++
 tools/perf/util/hist.c     |   93 +++++++++---
 tools/perf/util/hist.h     |    7 +
 tools/perf/util/session.c  |   72 +++++++++
 tools/perf/util/session.h  |    4 +
 tools/perf/util/sort.c     |  362 +++++++++++++++++++++++++++++++++-----------
 tools/perf/util/sort.h     |    5 +
 tools/perf/util/symbol.h   |   13 ++
 11 files changed, 475 insertions(+), 111 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 92af168..8b4d25d 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -180,6 +180,23 @@ struct ip_callchain {
 	u64 ips[0];
 };
 
+struct branch_flags {
+	u64 mispred:1;
+	u64 predicted:1;
+	u64 reserved:62;
+};
+
+struct branch_entry {
+	u64				from;
+	u64				to;
+	struct branch_flags flags;
+};
+
+struct branch_stack {
+	u64				nr;
+	struct branch_entry	entries[0];
+};
+
 extern bool perf_host, perf_guest;
 extern const char perf_version_string[];
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 011ed26..8248d80 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -64,7 +64,7 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 	pr_debug3("%s: addr=%#" PRIx64 "\n", __func__, map->unmap_ip(map, addr));
 
-	if (addr >= sym->end)
+	if (addr >= sym->end || addr < sym->start)
 		return 0;
 
 	offset = addr - sym->start;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index cbdeaad..1b19728 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -81,6 +81,7 @@ struct perf_sample {
 	u32 raw_size;
 	void *raw_data;
 	struct ip_callchain *callchain;
+	struct branch_stack *branch_stack;
 };
 
 #define BUILD_ID_SIZE 20
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..472fc8c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -575,6 +575,16 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		data->raw_data = (void *) pdata;
 	}
 
+	if (type & PERF_SAMPLE_BRANCH_STACK) {
+		u64 sz;
+
+		data->branch_stack = (struct branch_stack *)array;
+		array++; /* nr */
+
+		sz = data->branch_stack->nr * sizeof(struct branch_entry);
+		sz /= sizeof(uint64_t);
+		array += sz;
+	}
 	return 0;
 }
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 6f505d1..66f9936 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -54,9 +54,11 @@ static void hists__calc_col_len(struct hists *hists, struct hist_entry *h)
 {
 	u16 len;
 
-	if (h->ms.sym)
-		hists__new_col_len(hists, HISTC_SYMBOL, h->ms.sym->namelen);
-	else {
+	if (h->ms.sym) {
+		int n = (int)h->ms.sym->namelen + 4;
+		int symlen = max(n, BITS_PER_LONG / 4 + 6);
+		hists__new_col_len(hists, HISTC_SYMBOL, symlen);
+	} else {
 		const unsigned int unresolved_col_width = BITS_PER_LONG / 4;
 
 		if (hists__col_len(hists, HISTC_DSO) < unresolved_col_width &&
@@ -195,26 +197,14 @@ static u8 symbol__parent_filter(const struct symbol *parent)
 	return 0;
 }
 
-struct hist_entry *__hists__add_entry(struct hists *hists,
+static struct hist_entry *add_hist_entry(struct hists *hists,
+				      struct hist_entry *entry,
 				      struct addr_location *al,
-				      struct symbol *sym_parent, u64 period)
+				      u64 period)
 {
 	struct rb_node **p;
 	struct rb_node *parent = NULL;
 	struct hist_entry *he;
-	struct hist_entry entry = {
-		.thread	= al->thread,
-		.ms = {
-			.map	= al->map,
-			.sym	= al->sym,
-		},
-		.cpu	= al->cpu,
-		.ip	= al->addr,
-		.level	= al->level,
-		.period	= period,
-		.parent = sym_parent,
-		.filtered = symbol__parent_filter(sym_parent),
-	};
 	int cmp;
 
 	pthread_mutex_lock(&hists->lock);
@@ -225,7 +215,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		parent = *p;
 		he = rb_entry(parent, struct hist_entry, rb_node_in);
 
-		cmp = hist_entry__cmp(&entry, he);
+		cmp = hist_entry__cmp(entry, he);
 
 		if (!cmp) {
 			he->period += period;
@@ -239,7 +229,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 			p = &(*p)->rb_right;
 	}
 
-	he = hist_entry__new(&entry);
+	he = hist_entry__new(entry);
 	if (!he)
 		goto out_unlock;
 
@@ -252,6 +242,69 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 	return he;
 }
 
+struct hist_entry *__hists__add_branch_entry(struct hists *self,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct branch_info *bi,
+					     u64 period){
+	struct hist_entry entry = {
+		.thread	= al->thread,
+		.ms = {
+			.map	= bi->to.map,
+			.sym	= bi->to.sym,
+		},
+		.cpu	= al->cpu,
+		.ip	= bi->to.addr,
+		.level	= al->level,
+		.period	= period,
+		.parent = sym_parent,
+		.filtered = symbol__parent_filter(sym_parent),
+		.branch_info = bi,
+	};
+	struct hist_entry *he;
+
+	he = add_hist_entry(self, &entry, al, period);
+	if (!he)
+		return NULL;
+
+	/*
+	 * in branch mode, we do not display al->sym, al->addr
+	 * but instead what is in branch_info. The addresses and
+	 * symbols there may need wider columns, so make sure they
+	 * are taken into account.
+	 *
+	 * hists__calc_col_len() tracks the max column width, so
+	 * we need to call it for both the from and to addresses
+	 */
+	entry.ip     = bi->from.addr;
+	entry.ms.map = bi->from.map;
+	entry.ms.sym = bi->from.sym;
+	hists__calc_col_len(self, &entry);
+
+	return he;
+}
+
+struct hist_entry *__hists__add_entry(struct hists *self,
+				      struct addr_location *al,
+				      struct symbol *sym_parent, u64 period)
+{
+	struct hist_entry entry = {
+		.thread	= al->thread,
+		.ms = {
+			.map	= al->map,
+			.sym	= al->sym,
+		},
+		.cpu	= al->cpu,
+		.ip	= al->addr,
+		.level	= al->level,
+		.period	= period,
+		.parent = sym_parent,
+		.filtered = symbol__parent_filter(sym_parent),
+	};
+
+	return add_hist_entry(self, &entry, al, period);
+}
+
 int64_t
 hist_entry__cmp(struct hist_entry *left, struct hist_entry *right)
 {
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 0d48613..801a04e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -41,6 +41,7 @@ enum hist_column {
 	HISTC_COMM,
 	HISTC_PARENT,
 	HISTC_CPU,
+	HISTC_MISPREDICT,
 	HISTC_NR_COLS, /* Last entry */
 };
 
@@ -73,6 +74,12 @@ int hist_entry__snprintf(struct hist_entry *self, char *bf, size_t size,
 			 struct hists *hists);
 void hist_entry__free(struct hist_entry *);
 
+struct hist_entry *__hists__add_branch_entry(struct hists *self,
+					     struct addr_location *al,
+					     struct symbol *sym_parent,
+					     struct branch_info *bi,
+					     u64 period);
+
 void hists__output_resort(struct hists *self);
 void hists__output_resort_threaded(struct hists *hists);
 void hists__collapse_resort(struct hists *self);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b5ca255..6643224 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -229,6 +229,63 @@ static bool symbol__match_parent_regex(struct symbol *sym)
 	return 0;
 }
 
+static const u8 cpumodes[] = {
+	PERF_RECORD_MISC_USER,
+	PERF_RECORD_MISC_KERNEL,
+	PERF_RECORD_MISC_GUEST_USER,
+	PERF_RECORD_MISC_GUEST_KERNEL
+};
+#define NCPUMODES (sizeof(cpumodes)/sizeof(u8))
+
+static void ip__resolve_ams(struct machine *self, struct thread *thread,
+			    struct addr_map_symbol *ams,
+			    u64 ip)
+{
+	struct addr_location al;
+	size_t i;
+	u8 m;
+
+	memset(&al, 0, sizeof(al));
+
+	for (i = 0; i < NCPUMODES; i++) {
+		m = cpumodes[i];
+		/*
+		 * we cannot use the header.misc hint to determine whether a
+		 * branch stack address is user, kernel, guest, hypervisor.
+		 * Branches may straddle the kernel/user/hypervisor boundaries.
+		 * Thus, we have to try * consecutively until we find a match
+		 * or else, the symbol is unknown
+		 */
+		thread__find_addr_location(thread, self, m, MAP__FUNCTION,
+				ip, &al, NULL);
+		if (al.sym)
+			goto found;
+	}
+found:
+	ams->addr = ip;
+	ams->sym = al.sym;
+	ams->map = al.map;
+}
+
+struct branch_info *perf_session__resolve_bstack(struct machine *self,
+						 struct thread *thr,
+						 struct branch_stack *bs)
+{
+	struct branch_info *bi;
+	unsigned int i;
+
+	bi = calloc(bs->nr, sizeof(struct branch_info));
+	if (!bi)
+		return NULL;
+
+	for (i = 0; i < bs->nr; i++) {
+		ip__resolve_ams(self, thr, &bi[i].to, bs->entries[i].to);
+		ip__resolve_ams(self, thr, &bi[i].from, bs->entries[i].from);
+		bi[i].flags = bs->entries[i].flags;
+	}
+	return bi;
+}
+
 int machine__resolve_callchain(struct machine *self, struct perf_evsel *evsel,
 			       struct thread *thread,
 			       struct ip_callchain *chain,
@@ -697,6 +754,18 @@ static void callchain__printf(struct perf_sample *sample)
 		       i, sample->callchain->ips[i]);
 }
 
+static void branch_stack__printf(struct perf_sample *sample)
+{
+	uint64_t i;
+
+	printf("... branch stack: nr:%" PRIu64 "\n", sample->branch_stack->nr);
+
+	for (i = 0; i < sample->branch_stack->nr; i++)
+		printf("..... %2"PRIu64": %016" PRIx64 " -> %016" PRIx64 "\n",
+			i, sample->branch_stack->entries[i].from,
+			sample->branch_stack->entries[i].to);
+}
+
 static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
@@ -744,6 +813,9 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_CALLCHAIN)
 		callchain__printf(sample);
+
+	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
+		branch_stack__printf(sample);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 37bc383..f407338 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -73,6 +73,10 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 				    struct ip_callchain *chain,
 				    struct symbol **parent);
 
+struct branch_info *perf_session__resolve_bstack(struct machine *self,
+						 struct thread *thread,
+						 struct branch_stack *bs);
+
 bool perf_session__has_traces(struct perf_session *self, const char *msg);
 
 void mem_bswap_64(void *src, int byte_size);
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 16da30d..1531989 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -8,6 +8,7 @@ const char	default_sort_order[] = "comm,dso,symbol";
 const char	*sort_order = default_sort_order;
 int		sort__need_collapse = 0;
 int		sort__has_parent = 0;
+bool		sort__branch_mode;
 
 enum sort_type	sort__first_dimension;
 
@@ -94,6 +95,26 @@ static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
 }
 
+static int64_t _sort__dso_cmp(struct map *map_l, struct map *map_r)
+{
+	struct dso *dso_l = map_l ? map_l->dso : NULL;
+	struct dso *dso_r = map_r ? map_r->dso : NULL;
+	const char *dso_name_l, *dso_name_r;
+
+	if (!dso_l || !dso_r)
+		return cmp_null(dso_l, dso_r);
+
+	if (verbose) {
+		dso_name_l = dso_l->long_name;
+		dso_name_r = dso_r->long_name;
+	} else {
+		dso_name_l = dso_l->short_name;
+		dso_name_r = dso_r->short_name;
+	}
+
+	return strcmp(dso_name_l, dso_name_r);
+}
+
 struct sort_entry sort_comm = {
 	.se_header	= "Command",
 	.se_cmp		= sort__comm_cmp,
@@ -107,36 +128,74 @@ struct sort_entry sort_comm = {
 static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
-	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
-	struct dso *dso_r = right->ms.map ? right->ms.map->dso : NULL;
-	const char *dso_name_l, *dso_name_r;
+	return _sort__dso_cmp(left->ms.map, right->ms.map);
+}
 
-	if (!dso_l || !dso_r)
-		return cmp_null(dso_l, dso_r);
 
-	if (verbose) {
-		dso_name_l = dso_l->long_name;
-		dso_name_r = dso_r->long_name;
-	} else {
-		dso_name_l = dso_l->short_name;
-		dso_name_r = dso_r->short_name;
+static int64_t _sort__sym_cmp(struct symbol *sym_l, struct symbol *sym_r,
+			      u64 ip_l, u64 ip_r)
+{
+	if (!sym_l || !sym_r)
+		return cmp_null(sym_l, sym_r);
+
+	if (sym_l == sym_r)
+		return 0;
+
+	if (sym_l)
+		ip_l = sym_l->start;
+	if (sym_r)
+		ip_r = sym_r->start;
+
+	return (int64_t)(ip_r - ip_l);
+}
+
+static int _hist_entry__dso_snprintf(struct map *map, char *bf,
+				     size_t size, unsigned int width)
+{
+	if (map && map->dso) {
+		const char *dso_name = !verbose ? map->dso->short_name :
+			map->dso->long_name;
+		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
 	}
 
-	return strcmp(dso_name_l, dso_name_r);
+	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
 }
 
 static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width)
 {
-	if (self->ms.map && self->ms.map->dso) {
-		const char *dso_name = !verbose ? self->ms.map->dso->short_name :
-						  self->ms.map->dso->long_name;
-		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
+	return _hist_entry__dso_snprintf(self->ms.map, bf, size, width);
+}
+
+static int _hist_entry__sym_snprintf(struct map *map, struct symbol *sym,
+				     u64 ip, char level, char *bf, size_t size,
+				     unsigned int width __used)
+{
+	size_t ret = 0;
+
+	if (verbose) {
+		char o = map ? dso__symtab_origin(map->dso) : '!';
+		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
+				       BITS_PER_LONG / 4, ip, o);
 	}
 
-	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
+	ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", level);
+	if (sym)
+		ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+				       width - ret,
+				       sym->name);
+	else {
+		size_t len = BITS_PER_LONG / 4;
+		ret += repsep_snprintf(bf + ret, size - ret, "%-#.*llx",
+				       len, ip);
+		ret += repsep_snprintf(bf + ret, size - ret, "%-*s",
+				       width - ret, "");
+	}
+
+	return ret;
 }
 
+
 struct sort_entry sort_dso = {
 	.se_header	= "Shared Object",
 	.se_cmp		= sort__dso_cmp,
@@ -144,8 +203,14 @@ struct sort_entry sort_dso = {
 	.se_width_idx	= HISTC_DSO,
 };
 
-/* --sort symbol */
+static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width __used)
+{
+	return _hist_entry__sym_snprintf(self->ms.map, self->ms.sym, self->ip,
+					 self->level, bf, size, width);
+}
 
+/* --sort symbol */
 static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
@@ -154,40 +219,10 @@ sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 	if (!left->ms.sym && !right->ms.sym)
 		return right->level - left->level;
 
-	if (!left->ms.sym || !right->ms.sym)
-		return cmp_null(left->ms.sym, right->ms.sym);
-
-	if (left->ms.sym == right->ms.sym)
-		return 0;
-
 	ip_l = left->ms.sym->start;
 	ip_r = right->ms.sym->start;
 
-	return (int64_t)(ip_r - ip_l);
-}
-
-static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width __used)
-{
-	size_t ret = 0;
-
-	if (verbose) {
-		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
-		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
-				       BITS_PER_LONG / 4, self->ip, o);
-	}
-
-	if (!sort_dso.elide)
-		ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
-
-	if (self->ms.sym)
-		ret += repsep_snprintf(bf + ret, size - ret, "%s",
-				       self->ms.sym->name);
-	else
-		ret += repsep_snprintf(bf + ret, size - ret, "%-#*llx",
-				       BITS_PER_LONG / 4, self->ip);
-
-	return ret;
+	return _sort__sym_cmp(left->ms.sym, right->ms.sym, ip_l, ip_r);
 }
 
 struct sort_entry sort_sym = {
@@ -246,6 +281,135 @@ struct sort_entry sort_cpu = {
 	.se_width_idx	= HISTC_CPU,
 };
 
+static int64_t
+sort__dso_from_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return _sort__dso_cmp(left->branch_info->from.map,
+			      right->branch_info->from.map);
+}
+
+static int hist_entry__dso_from_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width)
+{
+	return _hist_entry__dso_snprintf(self->branch_info->from.map,
+					 bf, size, width);
+}
+
+struct sort_entry sort_dso_from = {
+	.se_header	= "Source Shared Object",
+	.se_cmp		= sort__dso_from_cmp,
+	.se_snprintf	= hist_entry__dso_from_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
+static int64_t
+sort__dso_to_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return _sort__dso_cmp(left->branch_info->to.map,
+			      right->branch_info->to.map);
+}
+
+static int hist_entry__dso_to_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return _hist_entry__dso_snprintf(self->branch_info->to.map,
+					 bf, size, width);
+}
+
+static int64_t
+sort__sym_from_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct addr_map_symbol *from_l = &left->branch_info->from;
+	struct addr_map_symbol *from_r = &right->branch_info->from;
+
+	if (!from_l->sym && !from_r->sym)
+		return right->level - left->level;
+
+	return _sort__sym_cmp(from_l->sym, from_r->sym, from_l->addr,
+			     from_r->addr);
+}
+
+static int64_t
+sort__sym_to_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	struct addr_map_symbol *to_l = &left->branch_info->to;
+	struct addr_map_symbol *to_r = &right->branch_info->to;
+
+	if (!to_l->sym && !to_r->sym)
+		return right->level - left->level;
+
+	return _sort__sym_cmp(to_l->sym, to_r->sym, to_l->addr, to_r->addr);
+}
+
+static int hist_entry__sym_from_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width __used)
+{
+	struct addr_map_symbol *from = &self->branch_info->from;
+	return _hist_entry__sym_snprintf(from->map, from->sym, from->addr,
+					 self->level, bf, size, width);
+
+}
+
+static int hist_entry__sym_to_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width __used)
+{
+	struct addr_map_symbol *to = &self->branch_info->to;
+	return _hist_entry__sym_snprintf(to->map, to->sym, to->addr,
+					 self->level, bf, size, width);
+
+}
+
+struct sort_entry sort_dso_to = {
+	.se_header	= "Target Shared Object",
+	.se_cmp		= sort__dso_to_cmp,
+	.se_snprintf	= hist_entry__dso_to_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
+struct sort_entry sort_sym_from = {
+	.se_header	= "Source Symbol",
+	.se_cmp		= sort__sym_from_cmp,
+	.se_snprintf	= hist_entry__sym_from_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
+
+struct sort_entry sort_sym_to = {
+	.se_header	= "Target Symbol",
+	.se_cmp		= sort__sym_to_cmp,
+	.se_snprintf	= hist_entry__sym_to_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
+
+static int64_t
+sort__mispredict_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	const unsigned char mp = left->branch_info->flags.mispred !=
+					right->branch_info->flags.mispred;
+	const unsigned char p = left->branch_info->flags.predicted !=
+					right->branch_info->flags.predicted;
+
+	return mp || p;
+}
+
+static int hist_entry__mispredict_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width){
+	static const char *out = "N/A";
+
+	if (self->branch_info->flags.predicted)
+		out = "N";
+	else if (self->branch_info->flags.mispred)
+		out = "Y";
+
+	return repsep_snprintf(bf, size, "%-*s", width, out);
+}
+
+struct sort_entry sort_mispredict = {
+	.se_header	= "Branch Mispredicted",
+	.se_cmp		= sort__mispredict_cmp,
+	.se_snprintf	= hist_entry__mispredict_snprintf,
+	.se_width_idx	= HISTC_MISPREDICT,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -253,14 +417,59 @@ struct sort_dimension {
 };
 
 static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "parent",	.entry = &sort_parent,	},
-	{ .name = "cpu",	.entry = &sort_cpu,	},
+	{ .name = "pid",	.entry = &sort_thread,			},
+	{ .name = "comm",	.entry = &sort_comm,			},
+	{ .name = "dso",	.entry = &sort_dso,			},
+	{ .name = "dso_from",	.entry = &sort_dso_from, .taken = true	},
+	{ .name = "dso_to",	.entry = &sort_dso_to,	 .taken = true	},
+	{ .name = "symbol",	.entry = &sort_sym,			},
+	{ .name = "symbol_from",.entry = &sort_sym_from, .taken = true	},
+	{ .name = "symbol_to",	.entry = &sort_sym_to,	 .taken = true	},
+	{ .name = "parent",	.entry = &sort_parent,			},
+	{ .name = "cpu",	.entry = &sort_cpu,			},
+	{ .name = "mispredict", .entry = &sort_mispredict, },
 };
 
+static int _sort_dimension__add(struct sort_dimension *sd)
+{
+	if (sd->entry->se_collapse)
+		sort__need_collapse = 1;
+
+	if (sd->entry == &sort_parent) {
+		int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
+		if (ret) {
+			char err[BUFSIZ];
+
+			regerror(ret, &parent_regex, err, sizeof(err));
+			pr_err("Invalid regex: %s\n%s", parent_pattern, err);
+			return -EINVAL;
+		}
+		sort__has_parent = 1;
+	}
+
+	if (list_empty(&hist_entry__sort_list)) {
+		if (!strcmp(sd->name, "pid"))
+			sort__first_dimension = SORT_PID;
+		else if (!strcmp(sd->name, "comm"))
+			sort__first_dimension = SORT_COMM;
+		else if (!strcmp(sd->name, "dso"))
+			sort__first_dimension = SORT_DSO;
+		else if (!strcmp(sd->name, "symbol"))
+			sort__first_dimension = SORT_SYM;
+		else if (!strcmp(sd->name, "parent"))
+			sort__first_dimension = SORT_PARENT;
+		else if (!strcmp(sd->name, "cpu"))
+			sort__first_dimension = SORT_CPU;
+		else if (!strcmp(sd->name, "mispredict"))
+			sort__first_dimension = SORT_MISPREDICTED;
+	}
+
+	list_add_tail(&sd->entry->list, &hist_entry__sort_list);
+	sd->taken = 1;
+
+	return 0;
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -271,48 +480,21 @@ int sort_dimension__add(const char *tok)
 		if (strncasecmp(tok, sd->name, strlen(tok)))
 			continue;
 
-		if (sd->entry == &sort_parent) {
-			int ret = regcomp(&parent_regex, parent_pattern, REG_EXTENDED);
-			if (ret) {
-				char err[BUFSIZ];
-
-				regerror(ret, &parent_regex, err, sizeof(err));
-				pr_err("Invalid regex: %s\n%s", parent_pattern, err);
-				return -EINVAL;
-			}
-			sort__has_parent = 1;
-		}
-
 		if (sd->taken)
 			return 0;
 
-		if (sd->entry->se_collapse)
-			sort__need_collapse = 1;
-
-		if (list_empty(&hist_entry__sort_list)) {
-			if (!strcmp(sd->name, "pid"))
-				sort__first_dimension = SORT_PID;
-			else if (!strcmp(sd->name, "comm"))
-				sort__first_dimension = SORT_COMM;
-			else if (!strcmp(sd->name, "dso"))
-				sort__first_dimension = SORT_DSO;
-			else if (!strcmp(sd->name, "symbol"))
-				sort__first_dimension = SORT_SYM;
-			else if (!strcmp(sd->name, "parent"))
-				sort__first_dimension = SORT_PARENT;
-			else if (!strcmp(sd->name, "cpu"))
-				sort__first_dimension = SORT_CPU;
-		}
-
-		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
-		sd->taken = 1;
 
-		return 0;
+		if (sort__branch_mode && (sd->entry == &sort_dso ||
+					sd->entry == &sort_sym)){
+			int err = _sort_dimension__add(sd + 1);
+			return err ?: _sort_dimension__add(sd + 2);
+		} else if (sd->entry == &sort_mispredict && !sort__branch_mode)
+			break;
+		else
+			return _sort_dimension__add(sd);
 	}
-
 	return -ESRCH;
 }
-
 void setup_sorting(const char * const usagestr[], const struct option *opts)
 {
 	char *tmp, *tok, *str = strdup(sort_order);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 3f67ae3..effcae1 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -31,11 +31,14 @@ extern const char *parent_pattern;
 extern const char default_sort_order[];
 extern int sort__need_collapse;
 extern int sort__has_parent;
+extern bool sort__branch_mode;
 extern char *field_sep;
 extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
 extern struct sort_entry sort_parent;
+extern struct sort_entry sort_lbr_dso;
+extern struct sort_entry sort_lbr_sym;
 extern enum sort_type sort__first_dimension;
 
 /**
@@ -72,6 +75,7 @@ struct hist_entry {
 		struct hist_entry *pair;
 		struct rb_root	  sorted_chain;
 	};
+	struct branch_info	*branch_info;
 	struct callchain_root	callchain[0];
 };
 
@@ -82,6 +86,7 @@ enum sort_type {
 	SORT_SYM,
 	SORT_PARENT,
 	SORT_CPU,
+	SORT_MISPREDICTED,
 };
 
 /*
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 123c2e1..6297e88 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -5,6 +5,7 @@
 #include <stdbool.h>
 #include <stdint.h>
 #include "map.h"
+#include "../perf.h"
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <stdio.h>
@@ -119,6 +120,18 @@ struct map_symbol {
 	bool	      has_children;
 };
 
+struct addr_map_symbol {
+	struct map    *map;
+	struct symbol *sym;
+	u64	      addr;
+};
+
+struct branch_info {
+	struct addr_map_symbol from;
+	struct addr_map_symbol to;
+	struct branch_flags flags;
+};
+
 struct addr_location {
 	struct thread *thread;
 	struct map    *map;
-- 
1.7.1

