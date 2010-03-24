Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab0CXTkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:40:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab0CXTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:40:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH v2 6/6] perf report: Pass the DSO to 'perf annotate'
Date: Wed, 24 Mar 2010 16:40:19 -0300
Message-Id: <1269459619-982-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1269459619-982-1-git-send-email-acme@infradead.org>
References: <1269459619-982-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we ensure that the symbol asked for annotation really is in the
DSO we are interested in.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   49 ++++++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index f6953ca..12572b5 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -157,7 +157,7 @@ static void __callchain__append_graph_browser(struct callchain_node *self,
 				indexes[depth + 2] = NEWT_ARG_LAST;
 				++chain_idx;
 			}
-			newt_checkbox_tree__add(tree, str, chain->ms.sym, indexes);
+			newt_checkbox_tree__add(tree, str, &chain->ms, indexes);
 			free(alloc_str);
 			++printed;
 		}
@@ -193,7 +193,7 @@ static void callchain__append_graph_browser(struct callchain_node *self,
 			continue;
 
 		str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		newt_checkbox_tree__add(tree, str, chain->ms.sym, indexes);
+		newt_checkbox_tree__add(tree, str, &chain->ms, indexes);
 	}
 
 	indexes[1] = parent_idx;
@@ -287,14 +287,14 @@ static size_t hist_entry__append_browser(struct hist_entry *self,
 
 		indexes[0] = NEWT_ARG_APPEND;
 		indexes[1] = NEWT_ARG_LAST;
-		newt_checkbox_tree__add(tree, s, self->ms.sym, indexes);
+		newt_checkbox_tree__add(tree, s, &self->ms, indexes);
 	} else
-		newtListboxAppendEntry(tree, s, self->ms.sym);
+		newtListboxAppendEntry(tree, s, &self->ms);
 
 	return strlen(s);
 }
 
-static void symbol__annotate_browser(const struct symbol *self)
+static void map_symbol__annotate_browser(const struct map_symbol *self)
 {
 	FILE *fp;
 	int cols, rows;
@@ -305,10 +305,11 @@ static void symbol__annotate_browser(const struct symbol *self)
 	size_t max_usable_width;
 	char *line = NULL;
 
-	if (self == NULL)
+	if (self->sym == NULL)
 		return;
 
-	if (asprintf(&str, "perf annotate %s 2>&1 | expand", self->name) < 0)
+	if (asprintf(&str, "perf annotate -d \"%s\" %s 2>&1 | expand",
+		     self->map->dso->name, self->sym->name) < 0)
 		return;
 
 	fp = popen(str, "r");
@@ -338,7 +339,7 @@ static void symbol__annotate_browser(const struct symbol *self)
 
 	newtListboxSetWidth(tree, max_line_len);
 
-	newtCenteredWindow(max_line_len + 2, rows - 5, self->name);
+	newtCenteredWindow(max_line_len + 2, rows - 5, self->sym->name);
 	form = newt_form__new();
 	newtFormAddComponents(form, tree, NULL);
 
@@ -359,7 +360,7 @@ static const void *newt__symbol_tree_get_current(newtComponent self)
 
 static void perf_session__selection(newtComponent self, void *data)
 {
-	const struct symbol **symbol_ptr = data;
+	const struct map_symbol **symbol_ptr = data;
 	*symbol_ptr = newt__symbol_tree_get_current(self);
 }
 
@@ -376,7 +377,7 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 	char str[1024];
 	newtComponent form, tree;
 	struct newtExitStruct es;
-	const struct symbol *selection;
+	const struct map_symbol *selection;
 
 	snprintf(str, sizeof(str), "Samples: %Ld", session_total);
 	newtDrawRootText(0, 0, str);
@@ -416,11 +417,8 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 		int len = hist_entry__append_browser(h, tree, session_total);
 		if (len > max_len)
 			max_len = len;
-		if (symbol_conf.use_callchain) {
+		if (symbol_conf.use_callchain)
 			hist_entry__append_callchain_browser(h, tree, session_total, idx++);
-			if (idx > 3300)
-				break;
-		}
 	}
 
 	if (max_len > cols)
@@ -445,10 +443,8 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 
 		newtFormRun(form, &es);
 		if (es.reason == NEWT_EXIT_HOTKEY) {
-			if (toupper(es.u.key) == 'A') {
-				symbol__annotate_browser(selection);
-				continue;
-			}
+			if (toupper(es.u.key) == 'A')
+				goto do_annotate;
 			if (es.u.key == NEWT_KEY_ESCAPE ||
 			    toupper(es.u.key) == 'Q' ||
 			    es.u.key == CTRL('c')) {
@@ -459,9 +455,9 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 			}
 		}
 
-		if (selection != NULL) {
+		if (selection->sym != NULL) {
 			snprintf(annotate, sizeof(annotate),
-				 "Annotate %s", selection->name);
+				 "Annotate %s", selection->sym->name);
 			options[nr_options++] = annotate;
 		}
 
@@ -469,8 +465,17 @@ void perf_session__browse_hists(struct rb_root *hists, u64 session_total,
 		choice = popup_menu(nr_options, options);
 		if (choice == nr_options - 1)
 			break;
-		else if (selection != NULL && choice >= 0)
-			symbol__annotate_browser(selection);
+do_annotate:
+		if (selection->sym != NULL && choice >= 0) {
+			if (selection->map->dso->origin == DSO__ORIG_KERNEL) {
+				newtPopHelpLine();
+				newtPushHelpLine("No vmlinux file found, can't "
+						 "annotate with just a "
+						 "kallsyms file");
+				continue;
+			}
+			map_symbol__annotate_browser(selection);
+		}
 	}
 
 	newtFormDestroy(form);
-- 
1.6.2.5

