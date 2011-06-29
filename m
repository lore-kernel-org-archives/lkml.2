Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab1F2XfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:35:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab1F2XeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:20 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [PATCH 2/6] perf tools: Make sort operations static
Date: Thu, 30 Jun 2011 01:34:04 +0200
Message-Id: <1309390448-9160-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These don't need to be globally visible.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Sam Liao <phyomh@gmail.com>
---
 tools/perf/util/sort.c |  211 ++++++++++++++++++++++-------------------------
 tools/perf/util/sort.h |    8 --
 2 files changed, 99 insertions(+), 120 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index f44fa54..f5dba56 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -15,95 +15,6 @@ char * field_sep;
 
 LIST_HEAD(hist_entry__sort_list);
 
-static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
-				     size_t size, unsigned int width);
-static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
-				       size_t size, unsigned int width);
-static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
-				    size_t size, unsigned int width);
-
-struct sort_entry sort_thread = {
-	.se_header	= "Command:  Pid",
-	.se_cmp		= sort__thread_cmp,
-	.se_snprintf	= hist_entry__thread_snprintf,
-	.se_width_idx	= HISTC_THREAD,
-};
-
-struct sort_entry sort_comm = {
-	.se_header	= "Command",
-	.se_cmp		= sort__comm_cmp,
-	.se_collapse	= sort__comm_collapse,
-	.se_snprintf	= hist_entry__comm_snprintf,
-	.se_width_idx	= HISTC_COMM,
-};
-
-struct sort_entry sort_dso = {
-	.se_header	= "Shared Object",
-	.se_cmp		= sort__dso_cmp,
-	.se_snprintf	= hist_entry__dso_snprintf,
-	.se_width_idx	= HISTC_DSO,
-};
-
-struct sort_entry sort_sym = {
-	.se_header	= "Symbol",
-	.se_cmp		= sort__sym_cmp,
-	.se_snprintf	= hist_entry__sym_snprintf,
-	.se_width_idx	= HISTC_SYMBOL,
-};
-
-struct sort_entry sort_parent = {
-	.se_header	= "Parent symbol",
-	.se_cmp		= sort__parent_cmp,
-	.se_snprintf	= hist_entry__parent_snprintf,
-	.se_width_idx	= HISTC_PARENT,
-};
- 
-struct sort_entry sort_cpu = {
-	.se_header      = "CPU",
-	.se_cmp	        = sort__cpu_cmp,
-	.se_snprintf    = hist_entry__cpu_snprintf,
-	.se_width_idx	= HISTC_CPU,
-};
-
-struct sort_dimension {
-	const char		*name;
-	struct sort_entry	*entry;
-	int			taken;
-};
-
-static struct sort_dimension sort_dimensions[] = {
-	{ .name = "pid",	.entry = &sort_thread,	},
-	{ .name = "comm",	.entry = &sort_comm,	},
-	{ .name = "dso",	.entry = &sort_dso,	},
-	{ .name = "symbol",	.entry = &sort_sym,	},
-	{ .name = "parent",	.entry = &sort_parent,	},
-	{ .name = "cpu",	.entry = &sort_cpu,	},
-};
-
-int64_t cmp_null(void *l, void *r)
-{
-	if (!l && !r)
-		return 0;
-	else if (!l)
-		return -1;
-	else
-		return 1;
-}
-
-/* --sort pid */
-
-int64_t
-sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
 static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 {
 	int n;
@@ -125,6 +36,24 @@ static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 	return n;
 }
 
+static int64_t cmp_null(void *l, void *r)
+{
+	if (!l && !r)
+		return 0;
+	else if (!l)
+		return -1;
+	else
+		return 1;
+}
+
+/* --sort pid */
+
+static int64_t
+sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
@@ -132,15 +61,50 @@ static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 			      self->thread->comm ?: "", self->thread->pid);
 }
 
+struct sort_entry sort_thread = {
+	.se_header	= "Command:  Pid",
+	.se_cmp		= sort__thread_cmp,
+	.se_snprintf	= hist_entry__thread_snprintf,
+	.se_width_idx	= HISTC_THREAD,
+};
+
+/* --sort comm */
+
+static int64_t
+sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
+{
+	return right->thread->pid - left->thread->pid;
+}
+
+static int64_t
+sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
+{
+	char *comm_l = left->thread->comm;
+	char *comm_r = right->thread->comm;
+
+	if (!comm_l || !comm_r)
+		return cmp_null(comm_l, comm_r);
+
+	return strcmp(comm_l, comm_r);
+}
+
 static int hist_entry__comm_snprintf(struct hist_entry *self, char *bf,
 				     size_t size, unsigned int width)
 {
 	return repsep_snprintf(bf, size, "%*s", width, self->thread->comm);
 }
 
+struct sort_entry sort_comm = {
+	.se_header	= "Command",
+	.se_cmp		= sort__comm_cmp,
+	.se_collapse	= sort__comm_collapse,
+	.se_snprintf	= hist_entry__comm_snprintf,
+	.se_width_idx	= HISTC_COMM,
+};
+
 /* --sort dso */
 
-int64_t
+static int64_t
 sort__dso_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	struct dso *dso_l = left->ms.map ? left->ms.map->dso : NULL;
@@ -173,9 +137,16 @@ static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
 }
 
+struct sort_entry sort_dso = {
+	.se_header	= "Shared Object",
+	.se_cmp		= sort__dso_cmp,
+	.se_snprintf	= hist_entry__dso_snprintf,
+	.se_width_idx	= HISTC_DSO,
+};
+
 /* --sort symbol */
 
-int64_t
+static int64_t
 sort__sym_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	u64 ip_l, ip_r;
@@ -211,29 +182,16 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 	return ret;
 }
 
-/* --sort comm */
-
-int64_t
-sort__comm_cmp(struct hist_entry *left, struct hist_entry *right)
-{
-	return right->thread->pid - left->thread->pid;
-}
-
-int64_t
-sort__comm_collapse(struct hist_entry *left, struct hist_entry *right)
-{
-	char *comm_l = left->thread->comm;
-	char *comm_r = right->thread->comm;
-
-	if (!comm_l || !comm_r)
-		return cmp_null(comm_l, comm_r);
-
-	return strcmp(comm_l, comm_r);
-}
+struct sort_entry sort_sym = {
+	.se_header	= "Symbol",
+	.se_cmp		= sort__sym_cmp,
+	.se_snprintf	= hist_entry__sym_snprintf,
+	.se_width_idx	= HISTC_SYMBOL,
+};
 
 /* --sort parent */
 
-int64_t
+static int64_t
 sort__parent_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	struct symbol *sym_l = left->parent;
@@ -252,9 +210,16 @@ static int hist_entry__parent_snprintf(struct hist_entry *self, char *bf,
 			      self->parent ? self->parent->name : "[other]");
 }
 
+struct sort_entry sort_parent = {
+	.se_header	= "Parent symbol",
+	.se_cmp		= sort__parent_cmp,
+	.se_snprintf	= hist_entry__parent_snprintf,
+	.se_width_idx	= HISTC_PARENT,
+};
+
 /* --sort cpu */
 
-int64_t
+static int64_t
 sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right)
 {
 	return right->cpu - left->cpu;
@@ -266,6 +231,28 @@ static int hist_entry__cpu_snprintf(struct hist_entry *self, char *bf,
 	return repsep_snprintf(bf, size, "%-*d", width, self->cpu);
 }
 
+struct sort_entry sort_cpu = {
+	.se_header      = "CPU",
+	.se_cmp	        = sort__cpu_cmp,
+	.se_snprintf    = hist_entry__cpu_snprintf,
+	.se_width_idx	= HISTC_CPU,
+};
+
+struct sort_dimension {
+	const char		*name;
+	struct sort_entry	*entry;
+	int			taken;
+};
+
+static struct sort_dimension sort_dimensions[] = {
+	{ .name = "pid",	.entry = &sort_thread,	},
+	{ .name = "comm",	.entry = &sort_comm,	},
+	{ .name = "dso",	.entry = &sort_dso,	},
+	{ .name = "symbol",	.entry = &sort_sym,	},
+	{ .name = "parent",	.entry = &sort_parent,	},
+	{ .name = "cpu",	.entry = &sort_cpu,	},
+};
+
 int sort_dimension__add(const char *tok)
 {
 	unsigned int i;
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 0b91053..4a6d309 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -108,14 +108,6 @@ extern size_t sort__thread_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__comm_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__dso_print(FILE *, struct hist_entry *, unsigned int);
 extern size_t sort__sym_print(FILE *, struct hist_entry *, unsigned int __used);
-extern int64_t cmp_null(void *, void *);
-extern int64_t sort__thread_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__comm_collapse(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__dso_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__sym_cmp(struct hist_entry *, struct hist_entry *);
-extern int64_t sort__parent_cmp(struct hist_entry *, struct hist_entry *);
-int64_t sort__cpu_cmp(struct hist_entry *left, struct hist_entry *right);
 extern size_t sort__parent_print(FILE *, struct hist_entry *, unsigned int);
 extern int sort_dimension__add(const char *);
 void sort_entry__setup_elide(struct sort_entry *self, struct strlist *list,
-- 
1.7.5.4

