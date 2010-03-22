Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0CVUxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 16:53:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab0CVUxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 16:53:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 1/1] perf report: newt callgraphs
Date: Mon, 22 Mar 2010 17:52:49 -0300
Message-Id: <1269291169-29820-1-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Starts collapsed, allows annotating by pressing 'A' or 'a' on the symbol, be it
the top level one or any of the symbols in the chains.

It (ab)uses the only tree widget in newt, that is actually a checkbox tree that
we use with just one option ('.'), end result is usable but we really need to
create a custom widget tree so that we can use the data structures we have
(hist_entry rb_tree + callchain rb_tree + lists), so that we reduce the memory
footprint by not creating a mirror set of data structures in the
newtCheckboxTree widget.

Thanks to Frédéric Weisbacker for fixing the orphanage problem in
301fde2, without that we were tripping a newt bug (fix already sent to
newt's maintainer).

Cc: Avi Kivity <avi@redhat.com>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |  291 ++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 259 insertions(+), 32 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 3c2ef95..12b229b 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -28,11 +28,197 @@ static newtComponent newt_form__new(void)
 	return self;
 }
 
+/*
+ * When debugging newt problems it was useful to be able to "unroll"
+ * the calls to newtCheckBoxTreeAdd{Array,Item}, so that we can generate
+ * a source file with the sequence of calls to these methods, to then
+ * tweak the arrays to get the intended results, so I'm keeping this code
+ * here, may be useful again in the future.
+ */
+#undef NEWT_DEBUG
+
+static void newt_checkbox_tree__add(newtComponent tree, const char *str,
+				    void *priv, int *indexes)
+{
+#ifdef NEWT_DEBUG
+	/* Print the newtCheckboxTreeAddArray to tinker with its index arrays */
+	int i = 0, len = 40 - strlen(str);
+
+	fprintf(stderr,
+		"\tnewtCheckboxTreeAddItem(tree, %*.*s\"%s\", (void *)%p, 0, ",
+		len, len, " ", str, priv);
+	while (indexes[i] != NEWT_ARG_LAST) {
+		if (indexes[i] != NEWT_ARG_APPEND)
+			fprintf(stderr, " %d,", indexes[i]);
+		else
+			fprintf(stderr, " %s,", "NEWT_ARG_APPEND");
+		++i;
+	}
+	fprintf(stderr, " %s", " NEWT_ARG_LAST);\n");
+	fflush(stderr);
+#endif
+	newtCheckboxTreeAddArray(tree, str, priv, 0, indexes);
+}
+
+static char *callchain_list__sym_name(struct callchain_list *self,
+				      char *bf, size_t bfsize)
+{
+	if (self->sym)
+		return self->sym->name;
+
+	snprintf(bf, bfsize, "%#Lx", self->ip);
+	return bf;
+}
+
+static void __callchain__append_graph_browser(struct callchain_node *self,
+					      newtComponent tree, u64 total,
+					      int *indexes, int depth)
+{
+	struct rb_node *node;
+	u64 new_total, remaining;
+	int idx = 0;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = self->children_hit;
+	else
+		new_total = total;
+
+	remaining = new_total;
+	node = rb_first(&self->rb_root);
+	while (node) {
+		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
+		struct rb_node *next = rb_next(node);
+		u64 cumul = cumul_hits(child);
+		struct callchain_list *chain;
+		int first = true, printed = 0;
+		int chain_idx = -1;
+		remaining -= cumul;
+
+		indexes[depth] = NEWT_ARG_APPEND;
+		indexes[depth + 1] = NEWT_ARG_LAST;
+
+		list_for_each_entry(chain, &child->val, list) {
+			char ipstr[BITS_PER_LONG / 4 + 1],
+			     *alloc_str = NULL;
+			const char *str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+
+			if (first) {
+				double percent = cumul * 100.0 / new_total;
+
+				first = false;
+				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
+					str = "Not enough memory!";
+				else
+					str = alloc_str;
+			} else {
+				indexes[depth] = idx;
+				indexes[depth + 1] = NEWT_ARG_APPEND;
+				indexes[depth + 2] = NEWT_ARG_LAST;
+				++chain_idx;
+			}
+			newt_checkbox_tree__add(tree, str, chain->sym, indexes);
+			free(alloc_str);
+			++printed;
+		}
+
+		indexes[depth] = idx;
+		if (chain_idx != -1)
+			indexes[depth + 1] = chain_idx;
+		if (printed != 0)
+			++idx;
+		__callchain__append_graph_browser(child, tree, new_total, indexes,
+						  depth + (chain_idx != -1 ? 2 : 1));
+		node = next;
+	}
+}
+
+static void callchain__append_graph_browser(struct callchain_node *self,
+					    newtComponent tree, u64 total,
+					    int *indexes, int parent_idx)
+{
+	struct callchain_list *chain;
+	int i = 0;
+
+	indexes[1] = NEWT_ARG_APPEND;
+	indexes[2] = NEWT_ARG_LAST;
+
+	list_for_each_entry(chain, &self->val, list) {
+		char ipstr[BITS_PER_LONG / 4 + 1], *str;
+
+		if (chain->ip >= PERF_CONTEXT_MAX)
+			continue;
+
+		if (!i++ && sort__first_dimension == SORT_SYM)
+			continue;
+
+		str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+		newt_checkbox_tree__add(tree, str, chain->sym, indexes);
+	}
+
+	indexes[1] = parent_idx;
+	indexes[2] = NEWT_ARG_APPEND;
+	indexes[3] = NEWT_ARG_LAST;
+	__callchain__append_graph_browser(self, tree, total, indexes, 2);
+}
+
+static void hist_entry__append_callchain_browser(struct hist_entry *self,
+						 newtComponent tree, u64 total, int parent_idx)
+{
+	struct rb_node *rb_node;
+	int indexes[1024] = { [0] = parent_idx, };
+	int idx = 0;
+	struct callchain_node *chain;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		switch (callchain_param.mode) {
+		case CHAIN_FLAT:
+			break;
+		case CHAIN_GRAPH_ABS: /* falldown */
+		case CHAIN_GRAPH_REL:
+			callchain__append_graph_browser(chain, tree, total, indexes, idx++);
+			break;
+		case CHAIN_NONE:
+		default:
+			break;
+		}
+		rb_node = rb_next(rb_node);
+	}
+}
+
+/*
+ * FIXME: get lib/string.c linked with perf somehow
+ */
+static char *skip_spaces(const char *str)
+{
+	while (isspace(*str))
+		++str;
+	return (char *)str;
+}
+
+static char *strim(char *s)
+{
+	size_t size;
+	char *end;
+
+	s = skip_spaces(s);
+	size = strlen(s);
+	if (!size)
+		return s;
+
+	end = s + size - 1;
+	while (end >= s && isspace(*end))
+		end--;
+	*(end + 1) = '\0';
+
+	return s;
+}
+
 static size_t hist_entry__append_browser(struct hist_entry *self,
-					 newtComponent listbox, u64 total)
+					 newtComponent tree, u64 total)
 {
-	char bf[1024];
-	size_t len;
+	char bf[1024], *s;
 	FILE *fp;
 
 	if (symbol_conf.exclude_other && !self->parent)
@@ -42,28 +228,46 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 	if (fp == NULL)
 		return 0;
 
-	len = hist_entry__fprintf(self, NULL, false, 0, fp, total);
-
+	hist_entry__fprintf(self, NULL, false, 0, fp, total);
 	fclose(fp);
-	newtListboxAppendEntry(listbox, bf, self);
-	return len;
+
+	/*
+	 * FIXME: We shouldn't need to trim, as the printing routines shouldn't
+	 * add spaces it in the first place, the stdio output routines should
+	 * call a __snprintf method instead of the current __print (that
+	 * actually is a __fprintf) one, but get the raw string and _then_ add
+	 * the newline, as this is a detail of stdio printing, not needed in
+	 * other UIs, e.g. newt.
+	 */
+	s = strim(bf);
+
+	if (symbol_conf.use_callchain) {
+		int indexes[2];
+
+		indexes[0] = NEWT_ARG_APPEND;
+		indexes[1] = NEWT_ARG_LAST;
+		newt_checkbox_tree__add(tree, s, self->sym, indexes);
+	} else
+		newtListboxAppendEntry(tree, s, self->sym);
+
+	return strlen(s);
 }
 
-static void hist_entry__annotate_browser(struct hist_entry *self)
+static void symbol__annotate_browser(const struct symbol *self)
 {
 	FILE *fp;
 	int cols, rows;
-	newtComponent form, listbox;
+	newtComponent form, tree;
 	struct newtExitStruct es;
 	char *str;
 	size_t line_len, max_line_len = 0;
 	size_t max_usable_width;
 	char *line = NULL;
 
-	if (self->sym == NULL)
+	if (self == NULL)
 		return;
 
-	if (asprintf(&str, "perf annotate %s 2>&1 | expand", self->sym->name) < 0)
+	if (asprintf(&str, "perf annotate %s 2>&1 | expand", self->name) < 0)
 		return;
 
 	fp = popen(str, "r");
@@ -72,7 +276,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 
 	newtPushHelpLine("Press ESC to exit");
 	newtGetScreenSize(&cols, &rows);
-	listbox = newtListbox(0, 0, rows - 5, NEWT_FLAG_SCROLL);
+	tree = newtListbox(0, 0, rows - 5, NEWT_FLAG_SCROLL);
 
 	while (!feof(fp)) {
 		if (getline(&line, &line_len, fp) < 0 || !line_len)
@@ -82,7 +286,7 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 
 		if (line_len > max_line_len)
 			max_line_len = line_len;
-		newtListboxAppendEntry(listbox, line, NULL);
+		newtListboxAppendEntry(tree, line, NULL);
 	}
 	fclose(fp);
 	free(line);
@@ -91,11 +295,11 @@ static void hist_entry__annotate_browser(struct hist_entry *self)
 	if (max_line_len > max_usable_width)
 		max_line_len = max_usable_width;
 
-	newtListboxSetWidth(listbox, max_line_len);
+	newtListboxSetWidth(tree, max_line_len);
 
-	newtCenteredWindow(max_line_len + 2, rows - 5, self->sym->name);
+	newtCenteredWindow(max_line_len + 2, rows - 5, self->name);
 	form = newt_form__new();
-	newtFormAddComponents(form, listbox, NULL);
+	newtFormAddComponents(form, tree, NULL);
 
 	newtFormRun(form, &es);
 	newtFormDestroy(form);
@@ -110,25 +314,27 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 {
 	struct sort_entry *se;
 	struct rb_node *nd;
+	char seq[] = ".";
 	unsigned int width;
 	char *col_width = symbol_conf.col_width_list_str;
-	int rows;
-	size_t max_len = 0;
+	int rows, cols, idx;
+	int max_len = 0;
 	char str[1024];
-	newtComponent form, listbox;
+	newtComponent form, tree;
 	struct newtExitStruct es;
 
 	snprintf(str, sizeof(str), "Samples: %Ld", session_total);
 	newtDrawRootText(0, 0, str);
 	newtPushHelpLine(helpline);
 
-	newtGetScreenSize(NULL, &rows);
-
-	form = newt_form__new();
+	newtGetScreenSize(&cols, &rows);
 
-	listbox = newtListbox(1, 1, rows - 2, (NEWT_FLAG_SCROLL |
-					       NEWT_FLAG_BORDER |
-					       NEWT_FLAG_RETURNEXIT));
+	if (symbol_conf.use_callchain)
+		tree = newtCheckboxTreeMulti(0, 0, rows - 5, seq,
+						NEWT_FLAG_SCROLL);
+	else
+		tree = newtListbox(0, 0, rows - 5, (NEWT_FLAG_SCROLL |
+						       NEWT_FLAG_RETURNEXIT));
 
 	list_for_each_entry(se, &hist_entry__sort_list, list) {
 		if (se->elide)
@@ -147,27 +353,48 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 		}
 	}
 
+	idx = 0;
 	for (nd = rb_first(hists); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		size_t len = hist_entry__append_browser(h, listbox, session_total);
+		int len = hist_entry__append_browser(h, tree, session_total);
 		if (len > max_len)
 			max_len = len;
+		if (symbol_conf.use_callchain) {
+			hist_entry__append_callchain_browser(h, tree, session_total, idx++);
+			if (idx > 3300)
+				break;
+		}
 	}
 
-	newtListboxSetWidth(listbox, max_len);
-	newtFormAddComponents(form, listbox, NULL);
+	if (max_len > cols)
+		max_len = cols - 3;
+
+	if (!symbol_conf.use_callchain)
+		newtListboxSetWidth(tree, max_len);
+
+	newtCenteredWindow(max_len + (symbol_conf.use_callchain ? 5 : 0),
+			   rows - 5, "Report");
+	form = newt_form__new();
+	newtFormAddHotKey(form, 'A');
+	newtFormAddHotKey(form, 'a');
+	newtFormAddComponents(form, tree, NULL);
 
 	while (1) {
-		struct hist_entry *selection;
+		const struct symbol *selection;
 
 		newtFormRun(form, &es);
-		if (es.reason == NEWT_EXIT_HOTKEY)
+		if (es.reason == NEWT_EXIT_HOTKEY &&
+		    toupper(es.u.key) != 'A')
 			break;
-		selection = newtListboxGetCurrent(listbox);
-		hist_entry__annotate_browser(selection);
+		if (!symbol_conf.use_callchain)
+			selection = newtListboxGetCurrent(tree);
+		else
+			selection = newtCheckboxTreeGetCurrent(tree);
+		symbol__annotate_browser(selection);
 	}
 
 	newtFormDestroy(form);
+	newtPopWindow();
 }
 
 static char browser__last_msg[1024];
-- 
1.6.2.5

