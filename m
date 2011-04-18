Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab1DRPwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:52:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:60331 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab1DRPwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:52:01 -0400
Date: Mon, 18 Apr 2011 15:51:51 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-db9a9cbc8142eed008e242e389938689c6feb1ba@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, ming.m.lin@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, tglx@linutronix.de
In-Reply-To: <1302244286.4106.36.camel@minggr.sh.intel.com>
References: <1302244286.4106.36.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf hists browser: Fix seg fault when annotate null symbol
Git-Commit-ID: db9a9cbc8142eed008e242e389938689c6feb1ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 18 Apr 2011 15:51:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  db9a9cbc8142eed008e242e389938689c6feb1ba
Gitweb:     http://git.kernel.org/tip/db9a9cbc8142eed008e242e389938689c6feb1ba
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 8 Apr 2011 14:31:26 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Apr 2011 12:51:49 -0300

perf hists browser: Fix seg fault when annotate null symbol

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
