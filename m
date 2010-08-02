Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab0HBBJU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:51005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0HBBJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/19] perf ui: New hists tree widget
Date: Sun,  1 Aug 2010 22:08:42 -0300
Message-Id: <1280711334-30000-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The stock newt checkbox tree widget we were using was not really
suitable for hist entry + callchain browsing.

The problems with it were manifold:

- We needed to traverse the whole hist_entry rb_tree to add each entry +
  callchains beforehand.

- No control over the colors used for each row

So a new tree widget, based mostly on slang, was written.

It extends the ui_browser class already used for annotate to allow the
user to fold/unfold branches in the callchains tree, using extra fields
in the map_symbol class that is embedded in hist_entry and
callchain_node instances to store the folding state and when changing
this state calculates the number of rows that are produced when showing
a particular hist_entry instance.

This greatly speeds up browsing as we don't have to upfront touch all
the entries and only calculate callchain related operations when some
callchain branch is actually unfolded.

The memory footprint is also reduced as the data structure is not
duplicated, just some extra fields for controling callchain state and to
simplify the process of seeking thru entries (nr_rows, row_offset) were
added.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c   |    3 +
 tools/perf/util/newt.c   |  972 +++++++++++++++++++++++++++++++---------------
 tools/perf/util/sort.h   |   12 +
 tools/perf/util/symbol.h |    2 +
 4 files changed, 678 insertions(+), 311 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f93095f..d0f07f7 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -885,6 +885,9 @@ static void hists__remove_entry_filter(struct hists *self, struct hist_entry *h,
 		return;
 
 	++self->nr_entries;
+	if (h->ms.unfolded)
+		self->nr_entries += h->nr_rows;
+	h->row_offset = 0;
 	self->stats.total_period += h->period;
 	self->stats.nr_events[PERF_RECORD_SAMPLE] += h->nr_events;
 
diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index cdd958e..28f74eb 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -509,38 +509,6 @@ static int ui_browser__run(struct ui_browser *self, struct newtExitStruct *es)
 	return 0;
 }
 
-/*
- * When debugging newt problems it was useful to be able to "unroll"
- * the calls to newtCheckBoxTreeAdd{Array,Item}, so that we can generate
- * a source file with the sequence of calls to these methods, to then
- * tweak the arrays to get the intended results, so I'm keeping this code
- * here, may be useful again in the future.
- */
-#undef NEWT_DEBUG
-
-static void newt_checkbox_tree__add(newtComponent tree, const char *str,
-				    void *priv, int *indexes)
-{
-#ifdef NEWT_DEBUG
-	/* Print the newtCheckboxTreeAddArray to tinker with its index arrays */
-	int i = 0, len = 40 - strlen(str);
-
-	fprintf(stderr,
-		"\tnewtCheckboxTreeAddItem(tree, %*.*s\"%s\", (void *)%p, 0, ",
-		len, len, " ", str, priv);
-	while (indexes[i] != NEWT_ARG_LAST) {
-		if (indexes[i] != NEWT_ARG_APPEND)
-			fprintf(stderr, " %d,", indexes[i]);
-		else
-			fprintf(stderr, " %s,", "NEWT_ARG_APPEND");
-		++i;
-	}
-	fprintf(stderr, " %s", " NEWT_ARG_LAST);\n");
-	fflush(stderr);
-#endif
-	newtCheckboxTreeAddArray(tree, str, priv, 0, indexes);
-}
-
 static char *callchain_list__sym_name(struct callchain_list *self,
 				      char *bf, size_t bfsize)
 {
@@ -576,147 +544,6 @@ static unsigned int hist_entry__annotate_browser_refresh(struct ui_browser *self
 	return row;
 }
 
-static void __callchain__append_graph_browser(struct callchain_node *self,
-					      newtComponent tree, u64 total,
-					      int *indexes, int depth)
-{
-	struct rb_node *node;
-	u64 new_total, remaining;
-	int idx = 0;
-
-	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->children_hit;
-	else
-		new_total = total;
-
-	remaining = new_total;
-	node = rb_first(&self->rb_root);
-	while (node) {
-		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
-		struct rb_node *next = rb_next(node);
-		u64 cumul = cumul_hits(child);
-		struct callchain_list *chain;
-		int first = true, printed = 0;
-		int chain_idx = -1;
-		remaining -= cumul;
-
-		indexes[depth] = NEWT_ARG_APPEND;
-		indexes[depth + 1] = NEWT_ARG_LAST;
-
-		list_for_each_entry(chain, &child->val, list) {
-			char ipstr[BITS_PER_LONG / 4 + 1],
-			     *alloc_str = NULL;
-			const char *str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-
-			if (first) {
-				double percent = cumul * 100.0 / new_total;
-
-				first = false;
-				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
-					str = "Not enough memory!";
-				else
-					str = alloc_str;
-			} else {
-				indexes[depth] = idx;
-				indexes[depth + 1] = NEWT_ARG_APPEND;
-				indexes[depth + 2] = NEWT_ARG_LAST;
-				++chain_idx;
-			}
-			newt_checkbox_tree__add(tree, str, &chain->ms, indexes);
-			free(alloc_str);
-			++printed;
-		}
-
-		indexes[depth] = idx;
-		if (chain_idx != -1)
-			indexes[depth + 1] = chain_idx;
-		if (printed != 0)
-			++idx;
-		__callchain__append_graph_browser(child, tree, new_total, indexes,
-						  depth + (chain_idx != -1 ? 2 : 1));
-		node = next;
-	}
-}
-
-static void callchain__append_graph_browser(struct callchain_node *self,
-					    newtComponent tree, u64 total,
-					    int *indexes, int parent_idx)
-{
-	struct callchain_list *chain;
-	int i = 0;
-
-	indexes[1] = NEWT_ARG_APPEND;
-	indexes[2] = NEWT_ARG_LAST;
-
-	list_for_each_entry(chain, &self->val, list) {
-		char ipstr[BITS_PER_LONG / 4 + 1], *str;
-
-		if (chain->ip >= PERF_CONTEXT_MAX)
-			continue;
-
-		if (!i++ && sort__first_dimension == SORT_SYM)
-			continue;
-
-		str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		newt_checkbox_tree__add(tree, str, &chain->ms, indexes);
-	}
-
-	indexes[1] = parent_idx;
-	indexes[2] = NEWT_ARG_APPEND;
-	indexes[3] = NEWT_ARG_LAST;
-	__callchain__append_graph_browser(self, tree, total, indexes, 2);
-}
-
-static void hist_entry__append_callchain_browser(struct hist_entry *self,
-						 newtComponent tree, u64 total, int parent_idx)
-{
-	struct rb_node *rb_node;
-	int indexes[1024] = { [0] = parent_idx, };
-	int idx = 0;
-	struct callchain_node *chain;
-
-	rb_node = rb_first(&self->sorted_chain);
-	while (rb_node) {
-		chain = rb_entry(rb_node, struct callchain_node, rb_node);
-		switch (callchain_param.mode) {
-		case CHAIN_FLAT:
-			break;
-		case CHAIN_GRAPH_ABS: /* falldown */
-		case CHAIN_GRAPH_REL:
-			callchain__append_graph_browser(chain, tree, total, indexes, idx++);
-			break;
-		case CHAIN_NONE:
-		default:
-			break;
-		}
-		rb_node = rb_next(rb_node);
-	}
-}
-
-static size_t hist_entry__append_browser(struct hist_entry *self,
-					 newtComponent tree,
-					 struct hists *hists)
-{
-	char s[256];
-	size_t ret;
-
-	if (symbol_conf.exclude_other && !self->parent)
-		return 0;
-
-	ret = hist_entry__snprintf(self, s, sizeof(s), hists, NULL,
-				   false, 0, false, hists->stats.total_period);
-	if (symbol_conf.use_callchain) {
-		int indexes[2];
-
-		indexes[0] = NEWT_ARG_APPEND;
-		indexes[1] = NEWT_ARG_LAST;
-		newt_checkbox_tree__add(tree, s, &self->ms, indexes);
-	} else
-		newtListboxAppendEntry(tree, s, &self->ms);
-
-	return ret;
-}
-
 int hist_entry__tui_annotate(struct hist_entry *self)
 {
 	struct ui_browser browser;
@@ -764,157 +591,48 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 	return ret;
 }
 
-static const void *newt__symbol_tree_get_current(newtComponent self)
-{
-	if (symbol_conf.use_callchain)
-		return newtCheckboxTreeGetCurrent(self);
-	return newtListboxGetCurrent(self);
-}
-
-static void hist_browser__selection(newtComponent self, void *data)
-{
-	const struct map_symbol **symbol_ptr = data;
-	*symbol_ptr = newt__symbol_tree_get_current(self);
-}
-
 struct hist_browser {
-	newtComponent		form, tree;
-	const struct map_symbol *selection;
+	struct ui_browser   b;
+	struct hists	    *hists;
+	struct hist_entry   *he_selection;
+	struct map_symbol   *selection;
 };
 
-static struct hist_browser *hist_browser__new(void)
+static void hist_browser__reset(struct hist_browser *self);
+static int hist_browser__run(struct hist_browser *self, const char *title,
+			     struct newtExitStruct *es);
+static unsigned int hist_browser__refresh_entries(struct ui_browser *self);
+static void ui_browser__hists_seek(struct ui_browser *self,
+				   off_t offset, int whence);
+
+static struct hist_browser *hist_browser__new(struct hists *hists)
 {
-	struct hist_browser *self = malloc(sizeof(*self));
+	struct hist_browser *self = zalloc(sizeof(*self));
 
-	if (self != NULL)
-		self->form = NULL;
+	if (self) {
+		self->hists = hists;
+		self->b.refresh_entries = hist_browser__refresh_entries;
+		self->b.seek = ui_browser__hists_seek;
+	}
 
 	return self;
 }
 
 static void hist_browser__delete(struct hist_browser *self)
 {
-	newtFormDestroy(self->form);
+	newtFormDestroy(self->b.form);
 	newtPopWindow();
 	free(self);
 }
 
-static int hist_browser__populate(struct hist_browser *self, struct hists *hists,
-				  const char *title)
-{
-	int max_len = 0, idx, cols, rows;
-	struct ui_progress *progress;
-	struct rb_node *nd;
-	u64 curr_hist = 0;
-	char seq[] = ".", unit;
-	char str[256];
-	unsigned long nr_events = hists->stats.nr_events[PERF_RECORD_SAMPLE];
-
-	if (self->form) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-
-	nr_events = convert_unit(nr_events, &unit);
-	snprintf(str, sizeof(str), "Events: %lu%c                            ",
-		 nr_events, unit);
-	newtDrawRootText(0, 0, str);
-
-	newtGetScreenSize(NULL, &rows);
-
-	if (symbol_conf.use_callchain)
-		self->tree = newtCheckboxTreeMulti(0, 0, rows - 5, seq,
-						   NEWT_FLAG_SCROLL);
-	else
-		self->tree = newtListbox(0, 0, rows - 5,
-					(NEWT_FLAG_SCROLL |
-					 NEWT_FLAG_RETURNEXIT));
-
-	newtComponentAddCallback(self->tree, hist_browser__selection,
-				 &self->selection);
-
-	progress = ui_progress__new("Adding entries to the browser...",
-				    hists->nr_entries);
-	if (progress == NULL)
-		return -1;
-
-	idx = 0;
-	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
-		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		int len;
-
-		if (h->filtered)
-			continue;
-
-		len = hist_entry__append_browser(h, self->tree, hists);
-		if (len > max_len)
-			max_len = len;
-		if (symbol_conf.use_callchain)
-			hist_entry__append_callchain_browser(h, self->tree,
-							     hists->stats.total_period, idx++);
-		++curr_hist;
-		if (curr_hist % 5)
-			ui_progress__update(progress, curr_hist);
-	}
-
-	ui_progress__delete(progress);
-
-	newtGetScreenSize(&cols, &rows);
-
-	if (max_len > cols)
-		max_len = cols - 3;
-
-	if (!symbol_conf.use_callchain)
-		newtListboxSetWidth(self->tree, max_len);
-
-	newtCenteredWindow(max_len + (symbol_conf.use_callchain ? 5 : 0),
-			   rows - 5, title);
-	self->form = newt_form__new();
-	if (self->form == NULL)
-		return -1;
-
-	newtFormAddHotKey(self->form, 'A');
-	newtFormAddHotKey(self->form, 'a');
-	newtFormAddHotKey(self->form, 'D');
-	newtFormAddHotKey(self->form, 'd');
-	newtFormAddHotKey(self->form, 'T');
-	newtFormAddHotKey(self->form, 't');
-	newtFormAddHotKey(self->form, '?');
-	newtFormAddHotKey(self->form, 'H');
-	newtFormAddHotKey(self->form, 'h');
-	newtFormAddHotKey(self->form, NEWT_KEY_F1);
-	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
-	newtFormAddHotKey(self->form, NEWT_KEY_TAB);
-	newtFormAddHotKey(self->form, NEWT_KEY_UNTAB);
-	newtFormAddComponents(self->form, self->tree, NULL);
-	self->selection = newt__symbol_tree_get_current(self->tree);
-
-	return 0;
-}
-
 static struct hist_entry *hist_browser__selected_entry(struct hist_browser *self)
 {
-	int *indexes;
-
-	if (!symbol_conf.use_callchain)
-		goto out;
-
-	indexes = newtCheckboxTreeFindItem(self->tree, (void *)self->selection);
-	if (indexes) {
-		bool is_hist_entry = indexes[1] == NEWT_ARG_LAST;
-		free(indexes);
-		if (is_hist_entry)
-			goto out;
-	}
-	return NULL;
-out:
-	return container_of(self->selection, struct hist_entry, ms);
+	return self->he_selection;
 }
 
 static struct thread *hist_browser__selected_thread(struct hist_browser *self)
 {
-	struct hist_entry *he = hist_browser__selected_entry(self);
-	return he ? he->thread : NULL;
+	return self->he_selection->thread;
 }
 
 static int hist_browser__title(char *bf, size_t size, const char *ev_name,
@@ -936,7 +654,7 @@ static int hist_browser__title(char *bf, size_t size, const char *ev_name,
 
 int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 {
-	struct hist_browser *browser = hist_browser__new();
+	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
 	const struct thread *thread_filter = NULL;
 	const struct dso *dso_filter = NULL;
@@ -955,8 +673,6 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 
 	hist_browser__title(msg, sizeof(msg), ev_name,
 			    dso_filter, thread_filter);
-	if (hist_browser__populate(browser, self, msg) < 0)
-		goto out_free_stack;
 
 	while (1) {
 		const struct thread *thread;
@@ -965,7 +681,8 @@ int hists__browse(struct hists *self, const char *helpline, const char *ev_name)
 		int nr_options = 0, choice = 0, i,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
 
-		newtFormRun(browser->form, &es);
+		if (hist_browser__run(browser, msg, &es))
+			break;
 
 		thread = hist_browser__selected_thread(browser);
 		dso = browser->selection->map ? browser->selection->map->dso : NULL;
@@ -1100,8 +817,7 @@ zoom_out_dso:
 			hists__filter_by_dso(self, dso_filter);
 			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
-			if (hist_browser__populate(browser, self, msg) < 0)
-				goto out;
+			hist_browser__reset(browser);
 		} else if (choice == zoom_thread) {
 zoom_thread:
 			if (thread_filter) {
@@ -1119,8 +835,7 @@ zoom_out_thread:
 			hists__filter_by_thread(self, thread_filter);
 			hist_browser__title(msg, sizeof(msg), ev_name,
 					    dso_filter, thread_filter);
-			if (hist_browser__populate(browser, self, msg) < 0)
-				goto out;
+			hist_browser__reset(browser);
 		}
 	}
 out_free_stack:
@@ -1207,3 +922,638 @@ void exit_browser(bool wait_for_ok)
 		newtFinished();
 	}
 }
+
+static void hist_browser__refresh_dimensions(struct hist_browser *self)
+{
+	/* 3 == +/- toggle symbol before actual hist_entry rendering */
+	self->b.width = 3 + (hists__sort_list_width(self->hists) +
+			     sizeof("[k]"));
+}
+
+static void hist_browser__reset(struct hist_browser *self)
+{
+	self->b.nr_entries = self->hists->nr_entries;
+	hist_browser__refresh_dimensions(self);
+	ui_browser__reset_index(&self->b);
+}
+
+static char tree__folded_sign(bool unfolded)
+{
+	return unfolded ? '-' : '+';
+}
+
+static char map_symbol__folded(const struct map_symbol *self)
+{
+	return self->has_children ? tree__folded_sign(self->unfolded) : ' ';
+}
+
+static char hist_entry__folded(const struct hist_entry *self)
+{
+	return map_symbol__folded(&self->ms);
+}
+
+static char callchain_list__folded(const struct callchain_list *self)
+{
+	return map_symbol__folded(&self->ms);
+}
+
+static bool map_symbol__toggle_fold(struct map_symbol *self)
+{
+	if (!self->has_children)
+		return false;
+
+	self->unfolded = !self->unfolded;
+	return true;
+}
+
+#define LEVEL_OFFSET_STEP 3
+
+static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
+						     struct callchain_node *chain_node,
+						     u64 total, int level,
+						     unsigned short row,
+						     off_t *row_offset,
+						     bool *is_current_entry)
+{
+	struct rb_node *node;
+	int first_row = row, width, offset = level * LEVEL_OFFSET_STEP;
+	u64 new_total, remaining;
+
+	if (callchain_param.mode == CHAIN_GRAPH_REL)
+		new_total = chain_node->children_hit;
+	else
+		new_total = total;
+
+	remaining = new_total;
+	node = rb_first(&chain_node->rb_root);
+	while (node) {
+		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
+		struct rb_node *next = rb_next(node);
+		u64 cumul = cumul_hits(child);
+		struct callchain_list *chain;
+		char folded_sign = ' ';
+		int first = true;
+		int extra_offset = 0;
+
+		remaining -= cumul;
+
+		list_for_each_entry(chain, &child->val, list) {
+			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
+			const char *str;
+			int color;
+			bool was_first = first;
+
+			if (first) {
+				first = false;
+				chain->ms.has_children = chain->list.next != &child->val ||
+							 rb_first(&child->rb_root) != NULL;
+			} else {
+				extra_offset = LEVEL_OFFSET_STEP;
+				chain->ms.has_children = chain->list.next == &child->val &&
+							 rb_first(&child->rb_root) != NULL;
+			}
+
+			folded_sign = callchain_list__folded(chain);
+			if (*row_offset != 0) {
+				--*row_offset;
+				goto do_next;
+			}
+
+			alloc_str = NULL;
+			str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+			if (was_first) {
+				double percent = cumul * 100.0 / new_total;
+
+				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
+					str = "Not enough memory!";
+				else
+					str = alloc_str;
+			}
+
+			color = HE_COLORSET_NORMAL;
+			width = self->b.width - (offset + extra_offset + 2);
+			if (ui_browser__is_current_entry(&self->b, row)) {
+				self->selection = &chain->ms;
+				color = HE_COLORSET_SELECTED;
+				*is_current_entry = true;
+			}
+
+			SLsmg_set_color(color);
+			SLsmg_gotorc(self->b.top + row, self->b.left);
+			slsmg_write_nstring(" ", offset + extra_offset);
+			slsmg_printf("%c ", folded_sign);
+			slsmg_write_nstring(str, width);
+			free(alloc_str);
+
+			if (++row == self->b.height)
+				goto out;
+do_next:
+			if (folded_sign == '+')
+				break;
+		}
+
+		if (folded_sign == '-') {
+			const int new_level = level + (extra_offset ? 2 : 1);
+			row += hist_browser__show_callchain_node_rb_tree(self, child, new_total,
+									 new_level, row, row_offset,
+									 is_current_entry);
+		}
+		if (row == self->b.height)
+			goto out;
+		node = next;
+	}
+out:
+	return row - first_row;
+}
+
+static int hist_browser__show_callchain_node(struct hist_browser *self,
+					     struct callchain_node *node,
+					     int level, unsigned short row,
+					     off_t *row_offset,
+					     bool *is_current_entry)
+{
+	struct callchain_list *chain;
+	int first_row = row,
+	     offset = level * LEVEL_OFFSET_STEP,
+	     width = self->b.width - offset;
+	char folded_sign = ' ';
+
+	list_for_each_entry(chain, &node->val, list) {
+		char ipstr[BITS_PER_LONG / 4 + 1], *s;
+		int color;
+		/*
+		 * FIXME: This should be moved to somewhere else,
+		 * probably when the callchain is created, so as not to
+		 * traverse it all over again
+		 */
+		chain->ms.has_children = rb_first(&node->rb_root) != NULL;
+		folded_sign = callchain_list__folded(chain);
+
+		if (*row_offset != 0) {
+			--*row_offset;
+			continue;
+		}
+
+		color = HE_COLORSET_NORMAL;
+		if (ui_browser__is_current_entry(&self->b, row)) {
+			self->selection = &chain->ms;
+			color = HE_COLORSET_SELECTED;
+			*is_current_entry = true;
+		}
+
+		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+		SLsmg_gotorc(self->b.top + row, self->b.left);
+		SLsmg_set_color(color);
+		slsmg_write_nstring(" ", offset);
+		slsmg_printf("%c ", folded_sign);
+		slsmg_write_nstring(s, width - 2);
+
+		if (++row == self->b.height)
+			goto out;
+	}
+
+	if (folded_sign == '-')
+		row += hist_browser__show_callchain_node_rb_tree(self, node,
+								 self->hists->stats.total_period,
+								 level + 1, row,
+								 row_offset,
+								 is_current_entry);
+out:
+	return row - first_row;
+}
+
+static int hist_browser__show_callchain(struct hist_browser *self,
+					struct rb_root *chain,
+					int level, unsigned short row,
+					off_t *row_offset,
+					bool *is_current_entry)
+{
+	struct rb_node *nd;
+	int first_row = row;
+
+	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+
+		row += hist_browser__show_callchain_node(self, node, level,
+							 row, row_offset,
+							 is_current_entry);
+		if (row == self->b.height)
+			break;
+	}
+
+	return row - first_row;
+}
+
+static int hist_browser__show_entry(struct hist_browser *self,
+				    struct hist_entry *entry,
+				    unsigned short row)
+{
+	char s[256];
+	double percent;
+	int printed = 0;
+	int color, width = self->b.width;
+	char folded_sign = ' ';
+	bool current_entry = ui_browser__is_current_entry(&self->b, row);
+	off_t row_offset = entry->row_offset;
+
+	if (current_entry) {
+		self->he_selection = entry;
+		self->selection = &entry->ms;
+	}
+
+	if (symbol_conf.use_callchain) {
+		entry->ms.has_children = !RB_EMPTY_ROOT(&entry->sorted_chain);
+		folded_sign = hist_entry__folded(entry);
+	}
+
+	if (row_offset == 0) {
+		hist_entry__snprintf(entry, s, sizeof(s), self->hists, NULL, false,
+				     0, false, self->hists->stats.total_period);
+		percent = (entry->period * 100.0) / self->hists->stats.total_period;
+
+		color = HE_COLORSET_SELECTED;
+		if (!current_entry) {
+			if (percent >= MIN_RED)
+				color = HE_COLORSET_TOP;
+			else if (percent >= MIN_GREEN)
+				color = HE_COLORSET_MEDIUM;
+			else
+				color = HE_COLORSET_NORMAL;
+		}
+
+		SLsmg_set_color(color);
+		SLsmg_gotorc(self->b.top + row, self->b.left);
+		if (symbol_conf.use_callchain) {
+			slsmg_printf("%c ", folded_sign);
+			width -= 2;
+		}
+		slsmg_write_nstring(s, width);
+		++row;
+		++printed;
+	} else
+		--row_offset;
+
+	if (folded_sign == '-' && row != self->b.height) {
+		printed += hist_browser__show_callchain(self, &entry->sorted_chain,
+							1, row, &row_offset,
+							&current_entry);
+		if (current_entry)
+			self->he_selection = entry;
+	}
+
+	return printed;
+}
+
+static unsigned int hist_browser__refresh_entries(struct ui_browser *self)
+{
+	unsigned row = 0;
+	struct rb_node *nd;
+	struct hist_browser *hb = container_of(self, struct hist_browser, b);
+
+	if (self->first_visible_entry == NULL)
+		self->first_visible_entry = rb_first(&hb->hists->entries);
+
+	for (nd = self->first_visible_entry; nd; nd = rb_next(nd)) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+
+		if (h->filtered)
+			continue;
+
+		row += hist_browser__show_entry(hb, h, row);
+		if (row == self->height)
+			break;
+	}
+
+	return row;
+}
+
+static void callchain_node__init_have_children_rb_tree(struct callchain_node *self)
+{
+	struct rb_node *nd = rb_first(&self->rb_root);
+
+	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
+		struct callchain_list *chain;
+		int first = true;
+
+		list_for_each_entry(chain, &child->val, list) {
+			if (first) {
+				first = false;
+				chain->ms.has_children = chain->list.next != &child->val ||
+							 rb_first(&child->rb_root) != NULL;
+			} else
+				chain->ms.has_children = chain->list.next == &child->val &&
+							 rb_first(&child->rb_root) != NULL;
+		}
+
+		callchain_node__init_have_children_rb_tree(child);
+	}
+}
+
+static void callchain_node__init_have_children(struct callchain_node *self)
+{
+	struct callchain_list *chain;
+
+	list_for_each_entry(chain, &self->val, list)
+		chain->ms.has_children = rb_first(&self->rb_root) != NULL;
+
+	callchain_node__init_have_children_rb_tree(self);
+}
+
+static void callchain__init_have_children(struct rb_root *self)
+{
+	struct rb_node *nd;
+
+	for (nd = rb_first(self); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		callchain_node__init_have_children(node);
+	}
+}
+
+static void hist_entry__init_have_children(struct hist_entry *self)
+{
+	if (!self->init_have_children) {
+		callchain__init_have_children(&self->sorted_chain);
+		self->init_have_children = true;
+	}
+}
+
+static struct rb_node *hists__filter_entries(struct rb_node *nd)
+{
+	while (nd != NULL) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		if (!h->filtered)
+			return nd;
+
+		nd = rb_next(nd);
+	}
+
+	return NULL;
+}
+
+static struct rb_node *hists__filter_prev_entries(struct rb_node *nd)
+{
+	while (nd != NULL) {
+		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
+		if (!h->filtered)
+			return nd;
+
+		nd = rb_prev(nd);
+	}
+
+	return NULL;
+}
+
+static void ui_browser__hists_seek(struct ui_browser *self,
+				   off_t offset, int whence)
+{
+	struct hist_entry *h;
+	struct rb_node *nd;
+	bool first = true;
+
+	switch (whence) {
+	case SEEK_SET:
+		nd = hists__filter_entries(rb_first(self->entries));
+		break;
+	case SEEK_CUR:
+		nd = self->first_visible_entry;
+		goto do_offset;
+	case SEEK_END:
+		nd = hists__filter_prev_entries(rb_last(self->entries));
+		first = false;
+		break;
+	default:
+		return;
+	}
+
+	/*
+	 * Moves not relative to the first visible entry invalidates its
+	 * row_offset:
+	 */
+	h = rb_entry(self->first_visible_entry, struct hist_entry, rb_node);
+	h->row_offset = 0;
+
+	/*
+	 * Here we have to check if nd is expanded (+), if it is we can't go
+	 * the next top level hist_entry, instead we must compute an offset of
+	 * what _not_ to show and not change the first visible entry.
+	 *
+	 * This offset increments when we are going from top to bottom and
+	 * decreases when we're going from bottom to top.
+	 *
+	 * As we don't have backpointers to the top level in the callchains
+	 * structure, we need to always print the whole hist_entry callchain,
+	 * skipping the first ones that are before the first visible entry
+	 * and stop when we printed enough lines to fill the screen.
+	 */
+do_offset:
+	if (offset > 0) {
+		do {
+			h = rb_entry(nd, struct hist_entry, rb_node);
+			if (h->ms.unfolded) {
+				u16 remaining = h->nr_rows - h->row_offset;
+				if (offset > remaining) {
+					offset -= remaining;
+					h->row_offset = 0;
+				} else {
+					h->row_offset += offset;
+					offset = 0;
+					self->first_visible_entry = nd;
+					break;
+				}
+			}
+			nd = hists__filter_entries(rb_next(nd));
+			if (nd == NULL)
+				break;
+			--offset;
+			self->first_visible_entry = nd;
+		} while (offset != 0);
+	} else if (offset < 0) {
+		while (1) {
+			h = rb_entry(nd, struct hist_entry, rb_node);
+			if (h->ms.unfolded) {
+				if (first) {
+					if (-offset > h->row_offset) {
+						offset += h->row_offset;
+						h->row_offset = 0;
+					} else {
+						h->row_offset += offset;
+						offset = 0;
+						self->first_visible_entry = nd;
+						break;
+					}
+				} else {
+					if (-offset > h->nr_rows) {
+						offset += h->nr_rows;
+						h->row_offset = 0;
+					} else {
+						h->row_offset = h->nr_rows + offset;
+						offset = 0;
+						self->first_visible_entry = nd;
+						break;
+					}
+				}
+			}
+
+			nd = hists__filter_prev_entries(rb_prev(nd));
+			if (nd == NULL)
+				break;
+			++offset;
+			self->first_visible_entry = nd;
+			if (offset == 0) {
+				/*
+				 * Last unfiltered hist_entry, check if it is
+				 * unfolded, if it is then we should have
+				 * row_offset at its last entry.
+				 */
+				h = rb_entry(nd, struct hist_entry, rb_node);
+				if (h->ms.unfolded)
+					h->row_offset = h->nr_rows;
+				break;
+			}
+			first = false;
+		}
+	} else {
+		self->first_visible_entry = nd;
+		h = rb_entry(nd, struct hist_entry, rb_node);
+		h->row_offset = 0;
+	}
+}
+
+static int callchain_node__count_rows_rb_tree(struct callchain_node *self)
+{
+	int n = 0;
+	struct rb_node *nd;
+
+	for (nd = rb_first(&self->rb_root); nd; nd = rb_next(nd)) {
+		struct callchain_node *child = rb_entry(nd, struct callchain_node, rb_node);
+		struct callchain_list *chain;
+		char folded_sign = ' '; /* No children */
+
+		list_for_each_entry(chain, &child->val, list) {
+			++n;
+			/* We need this because we may not have children */
+			folded_sign = callchain_list__folded(chain);
+			if (folded_sign == '+')
+				break;
+		}
+
+		if (folded_sign == '-') /* Have children and they're unfolded */
+			n += callchain_node__count_rows_rb_tree(child);
+	}
+
+	return n;
+}
+
+static int callchain_node__count_rows(struct callchain_node *node)
+{
+	struct callchain_list *chain;
+	bool unfolded = false;
+	int n = 0;
+
+	list_for_each_entry(chain, &node->val, list) {
+		++n;
+		unfolded = chain->ms.unfolded;
+	}
+
+	if (unfolded)
+		n += callchain_node__count_rows_rb_tree(node);
+
+	return n;
+}
+
+static int callchain__count_rows(struct rb_root *chain)
+{
+	struct rb_node *nd;
+	int n = 0;
+
+	for (nd = rb_first(chain); nd; nd = rb_next(nd)) {
+		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
+		n += callchain_node__count_rows(node);
+	}
+
+	return n;
+}
+
+static bool hist_browser__toggle_fold(struct hist_browser *self)
+{
+	if (map_symbol__toggle_fold(self->selection)) {
+		struct hist_entry *he = self->he_selection;
+
+		hist_entry__init_have_children(he);
+		self->hists->nr_entries -= he->nr_rows;
+
+		if (he->ms.unfolded)
+			he->nr_rows = callchain__count_rows(&he->sorted_chain);
+		else
+			he->nr_rows = 0;
+		self->hists->nr_entries += he->nr_rows;
+		self->b.nr_entries = self->hists->nr_entries;
+
+		return true;
+	}
+
+	/* If it doesn't have children, no toggling performed */
+	return false;
+}
+
+static int hist_browser__run(struct hist_browser *self, const char *title,
+			     struct newtExitStruct *es)
+{
+	char str[256], unit;
+	unsigned long nr_events = self->hists->stats.nr_events[PERF_RECORD_SAMPLE];
+
+	self->b.entries = &self->hists->entries;
+	self->b.nr_entries = self->hists->nr_entries;
+
+	hist_browser__refresh_dimensions(self);
+
+	nr_events = convert_unit(nr_events, &unit);
+	snprintf(str, sizeof(str), "Events: %lu%c                            ",
+		 nr_events, unit);
+	newtDrawRootText(0, 0, str);
+
+	if (ui_browser__show(&self->b, title) < 0)
+		return -1;
+
+	newtFormAddHotKey(self->b.form, 'A');
+	newtFormAddHotKey(self->b.form, 'a');
+	newtFormAddHotKey(self->b.form, '?');
+	newtFormAddHotKey(self->b.form, 'h');
+	newtFormAddHotKey(self->b.form, 'H');
+	newtFormAddHotKey(self->b.form, 'd');
+
+	newtFormAddHotKey(self->b.form, NEWT_KEY_LEFT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_RIGHT);
+	newtFormAddHotKey(self->b.form, NEWT_KEY_ENTER);
+
+	while (1) {
+		ui_browser__run(&self->b, es);
+
+		if (es->reason != NEWT_EXIT_HOTKEY)
+			break;
+		switch (es->u.key) {
+		case 'd': { /* Debug */
+			static int seq;
+			struct hist_entry *h = rb_entry(self->b.first_visible_entry,
+							struct hist_entry, rb_node);
+			ui_helpline__pop();
+			ui_helpline__fpush("%d: nr_ent=(%d,%d), height=%d, idx=%d, fve: idx=%d, row_off=%d, nrows=%d",
+					   seq++, self->b.nr_entries,
+					   self->hists->nr_entries,
+					   self->b.height,
+					   self->b.index,
+					   self->b.first_visible_entry_idx,
+					   h->row_offset, h->nr_rows);
+		}
+			continue;
+		case NEWT_KEY_ENTER:
+			if (hist_browser__toggle_fold(self))
+				break;
+			/* fall thru */
+		default:
+			return 0;
+		}
+	}
+	return 0;
+}
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 03a1722..46e531d 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -38,6 +38,12 @@ extern struct sort_entry sort_sym;
 extern struct sort_entry sort_parent;
 extern enum sort_type sort__first_dimension;
 
+/**
+ * struct hist_entry - histogram entry
+ *
+ * @row_offset - offset from the first callchain expanded to appear on screen
+ * @nr_rows - rows expanded in callchain, recalculated on folding/unfolding
+ */
 struct hist_entry {
 	struct rb_node		rb_node;
 	u64			period;
@@ -50,6 +56,12 @@ struct hist_entry {
 	u64			ip;
 	s32			cpu;
 	u32			nr_events;
+
+	/* XXX These two should move to some tree widget lib */
+	u16			row_offset;
+	u16			nr_rows;
+
+	bool			init_have_children;
 	char			level;
 	u8			filtered;
 	struct symbol		*parent;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d436ee3..bb1aab9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -102,6 +102,8 @@ struct ref_reloc_sym {
 struct map_symbol {
 	struct map    *map;
 	struct symbol *sym;
+	bool	      unfolded;
+	bool	      has_children;
 };
 
 struct addr_location {
-- 
1.6.2.5

