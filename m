Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0ECUjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 16:39:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:38897 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab0ECUjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 16:39:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:x-system-of-record;
	b=azS465y1Sk3z0zK7ycYyB1dDsYH0wa/MN/Pi06yK9ivMrwLFe2hJZixA5sETsL1Y+
	h0NkN8cQJN8nWOIepc2xw==
Date: Mon, 3 May 2010 13:38:13 -0700
From: Arun Sharma <aruns@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com
Subject: [PATCH] perf: implement recording/reporting per-cpu samples
Message-ID: <20100503203813.GA17886@sharma-home.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PERF_SAMPLE_CPU by default. Implement --sort cpu.

Signed-off-by: Arun Sharma <aruns@google.com>

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 27f992a..2ac9aaa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -258,7 +258,8 @@ static void create_counter(int counter, int cpu)
 				  PERF_FORMAT_TOTAL_TIME_RUNNING |
 				  PERF_FORMAT_ID;
 
-	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
+	attr->sample_type	|= PERF_SAMPLE_IP | PERF_SAMPLE_TID |
+				   PERF_SAMPLE_CPU;
 
 	if (nr_counters > 1)
 		attr->sample_type |= PERF_SAMPLE_ID;
@@ -293,7 +294,6 @@ static void create_counter(int counter, int cpu)
 	if (raw_samples) {
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 		attr->sample_type	|= PERF_SAMPLE_RAW;
-		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
 	attr->mmap		= track;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 816edae..6014d70 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -190,6 +190,13 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		return -1;
 	}
 
+	if (session->sample_type & PERF_SAMPLE_CPU) {
+		dump_printf("... cpu: %d\n", data.cpu);
+		al.cpu = data.cpu;
+	} else {
+		al.cpu = -1;
+	}
+
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index ad6b22d..4640015 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -52,6 +52,7 @@ struct hist_entry *__perf_session__add_hist_entry(struct rb_root *hists,
 		},
 		.ip	= al->addr,
 		.level	= al->level,
+		.cpu    = al->cpu,
 		.count	= count,
 		.parent = sym_parent,
 	};
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index da30b30..ee70bb8 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -13,6 +13,7 @@ enum sort_type	sort__first_dimension;
 unsigned int dsos__col_width;
 unsigned int comms__col_width;
 unsigned int threads__col_width;
+unsigned int cpu__col_width;
 static unsigned int parent_symbol__col_width;
 char * field_sep;
 
@@ -28,6 +29,8 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 				    size_t size, unsigned int width);
 static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width);
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				    size_t size, unsigned int width);
 
 struct sort_entry sort_thread = {
 	.se_header	= "Command:  Pid",
@@ -64,6 +67,13 @@ struct sort_entry sort_parent = {
 	.se_width	= &parent_symbol__col_width,
 };
 
+struct sort_entry sort_cpu = {
+	.se_header      = "CPU",
+	.se_cmp	        = sort__cpu_cmp,
+	.se_snprintf    = hist_entry__cpu_snprintf,
+	.se_width	= &cpu__col_width,
+};
+
 struct sort_dimension {
 	const char		*name;
 	struct sort_entry	*entry;
@@ -76,6 +86,7 @@ static struct sort_dimension sort_dimensions[] = {
 	{ .name = "dso",	.entry = &sort_dso,	},
 	{ .name = "symbol",	.entry = &sort_sym,	},
 	{ .name = "parent",	.entry = &sort_parent,	},
+	{ .name = "cpu",	.entry = &sort_cpu,	},
 };
 
 int64_t cmp_null(void *l, void *r)
@@ -242,6 +253,20 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 			      self->parent ? self->parent->name : "[other]");
 }
 
+/* --sort cpu */
+
+int64_t
+sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->cpu - left->cpu;
+}
+
+static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
+				       size_t size, unsigned int width)
+{
+	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
+}
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
@@ -281,6 +306,8 @@ int sort_dimension__add(const char *tok)
 				sort__first_dimension = SORT_SYM;
 			else if (!strcmp(sd->name, "parent"))
 				sort__first_dimension = SORT_PARENT;
+			else if (!strcmp(sd->name, "cpu"))
+				sort__first_dimension = SORT_CPU;
 		}
 
 		list_add_tail(&sd->entry->list, &hist_entry__sort_list);
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index b7c54ee..82c5596 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -60,6 +60,7 @@ struct hist_entry {
 	char			level;
 	u8			filtered;
 	struct symbol		*parent;
+	s32                     cpu;
 	union {
 		unsigned long	  position;
 		struct hist_entry *pair;
@@ -73,7 +74,8 @@ enum sort_type {
 	SORT_COMM,
 	SORT_DSO,
 	SORT_SYM,
-	SORT_PARENT
+	SORT_PARENT,
+	SORT_CPU
 };
 
 /*
@@ -102,6 +104,8 @@ extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
+extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern size_t sort__cpu_print(FILE *, struct hist_entry *, unsigned int);
 extern int64_t cmp_null(void *, void *);
 extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
@@ -109,7 +113,7 @@ extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
 extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
-extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
+extern int64_t sort__cpu_cmp(struct hist_entry *, struct hist_entry *);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
 			     const char *list_name, FILE *fp);
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 478f5ab..4b3e09d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -112,6 +112,7 @@ struct addr_location {
 	char	      level;
 	bool	      filtered;
 	unsigned int  cpumode;
+	s32           cpu;
 };
 
 enum dso_kernel_type {
-- 
1.7.0.1

