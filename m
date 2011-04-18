Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab1DRPXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:23:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54779 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1DRPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:23:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf hists browser: Fix seg fault when annotate null symbol
Date: Mon, 18 Apr 2011 12:23:08 -0300
Message-Id: <1303140189-5780-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1303140189-5780-1-git-send-email-acme@infradead.org>
References: <1303140189-5780-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

In hists browser, press hotkey 'a' to annotate current symbol.

Now it causes segment fault if 'a' is pressed on a null symbol.

Here are 2 small bugs:
- In perf_evsel__hists_browse, the condition check after 'a' is pressed
  is not correct, we should check ->sym instead of ->map.
- In symbol__tui_annotate we must check whether sym is NULL or not
  before getting annotation structure.

This patch fixes above 2 small bugs.

Link: http://lkml.kernel.org/r/1302244286.4106.36.camel@minggr.sh.intel.com
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |    6 ++++--
 tools/perf/util/ui/browsers/hists.c    |    2 +-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 8c17a87..15633d6 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -256,10 +256,9 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int refresh)
 {
 	struct objdump_line *pos, *n;
-	struct annotation *notes = symbol__annotation(sym);
+	struct annotation *notes;
 	struct annotate_browser browser = {
 		.b = {
-			.entries = &notes->src->source,
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
@@ -281,6 +280,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	ui_helpline__push("Press <- or ESC to exit");
 
+	notes = symbol__annotation(sym);
+
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct objdump_line_rb_node *rbpos;
 		size_t line_len = strlen(pos->line);
@@ -291,6 +292,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		rbpos->idx = browser.b.nr_entries++;
 	}
 
+	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
 	ret = annotate_browser__run(&browser, evidx, refresh);
 	list_for_each_entry_safe(pos, n, &notes->src->source, node) {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 798efdc..5d767c6 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -851,7 +851,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel,
 			goto out_free_stack;
 		case 'a':
 			if (browser->selection == NULL ||
-			    browser->selection->map == NULL ||
+			    browser->selection->sym == NULL ||
 			    browser->selection->map->dso->annotate_warned)
 				continue;
 			goto do_annotate;
-- 
1.6.2.5

