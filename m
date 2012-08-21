Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396Ab2HUPQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:16:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59513 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab2HUPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:16:05 -0400
Date: Tue, 21 Aug 2012 08:15:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-54gouunatugtfw92j6gddk45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Add verbose mode hotkey
Git-Commit-ID: a7cb8863dd352f052e7b2b86a17410070d1b69af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:15:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7cb8863dd352f052e7b2b86a17410070d1b69af
Gitweb:     http://git.kernel.org/tip/a7cb8863dd352f052e7b2b86a17410070d1b69af
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 3 Aug 2012 13:53:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Aug 2012 11:56:54 -0300

perf hists browser: Add verbose mode hotkey

Right now just shows the DSO name in callchain entries, to help debug
the DWARF CFI post unwind code.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-54gouunatugtfw92j6gddk45@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |   37 ++++++++++++++++++++++++++-----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 413bd62..b809469 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -24,6 +24,7 @@ struct hist_browser {
 	struct hist_entry   *he_selection;
 	struct map_symbol   *selection;
 	int		     print_seq;
+	bool		     show_dso;
 	bool		     has_symbols;
 };
 
@@ -376,12 +377,19 @@ out:
 }
 
 static char *callchain_list__sym_name(struct callchain_list *cl,
-				      char *bf, size_t bfsize)
+				      char *bf, size_t bfsize, bool show_dso)
 {
+	int printed;
+
 	if (cl->ms.sym)
-		return cl->ms.sym->name;
+		printed = scnprintf(bf, bfsize, "%s", cl->ms.sym->name);
+	else
+		printed = scnprintf(bf, bfsize, "%#" PRIx64, cl->ip);
+
+	if (show_dso)
+		scnprintf(bf + printed, bfsize - printed, " %s",
+			  cl->ms.map ? cl->ms.map->dso->short_name : "unknown");
 
-	snprintf(bf, bfsize, "%#" PRIx64, cl->ip);
 	return bf;
 }
 
@@ -417,7 +425,7 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 		remaining -= cumul;
 
 		list_for_each_entry(chain, &child->val, list) {
-			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
+			char bf[1024], *alloc_str;
 			const char *str;
 			int color;
 			bool was_first = first;
@@ -434,7 +442,8 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *browse
 			}
 
 			alloc_str = NULL;
-			str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+			str = callchain_list__sym_name(chain, bf, sizeof(bf),
+						       browser->show_dso);
 			if (was_first) {
 				double percent = cumul * 100.0 / new_total;
 
@@ -493,7 +502,7 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 	char folded_sign = ' ';
 
 	list_for_each_entry(chain, &node->val, list) {
-		char ipstr[BITS_PER_LONG / 4 + 1], *s;
+		char bf[1024], *s;
 		int color;
 
 		folded_sign = callchain_list__folded(chain);
@@ -510,7 +519,8 @@ static int hist_browser__show_callchain_node(struct hist_browser *browser,
 			*is_current_entry = true;
 		}
 
-		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+		s = callchain_list__sym_name(chain, bf, sizeof(bf),
+					     browser->show_dso);
 		ui_browser__gotorc(&browser->b, row, 0);
 		ui_browser__set_color(&browser->b, color);
 		slsmg_write_nstring(" ", offset);
@@ -830,7 +840,7 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 		remaining -= cumul;
 
 		list_for_each_entry(chain, &child->val, list) {
-			char ipstr[BITS_PER_LONG / 4 + 1], *alloc_str;
+			char bf[1024], *alloc_str;
 			const char *str;
 			bool was_first = first;
 
@@ -842,7 +852,8 @@ static int hist_browser__fprintf_callchain_node_rb_tree(struct hist_browser *bro
 			folded_sign = callchain_list__folded(chain);
 
 			alloc_str = NULL;
-			str = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+			str = callchain_list__sym_name(chain, bf, sizeof(bf),
+						       browser->show_dso);
 			if (was_first) {
 				double percent = cumul * 100.0 / new_total;
 
@@ -880,10 +891,10 @@ static int hist_browser__fprintf_callchain_node(struct hist_browser *browser,
 	int printed = 0;
 
 	list_for_each_entry(chain, &node->val, list) {
-		char ipstr[BITS_PER_LONG / 4 + 1], *s;
+		char bf[1024], *s;
 
 		folded_sign = callchain_list__folded(chain);
-		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
+		s = callchain_list__sym_name(chain, bf, sizeof(bf), browser->show_dso);
 		printed += fprintf(fp, "%*s%c %s\n", offset, " ", folded_sign, s);
 	}
 
@@ -1133,6 +1144,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			continue;
 		case 'd':
 			goto zoom_dso;
+		case 'V':
+			browser->show_dso = !browser->show_dso;
+			continue;
 		case 't':
 			goto zoom_thread;
 		case '/':
@@ -1164,6 +1178,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"d             Zoom into current DSO\n"
 					"t             Zoom into current Thread\n"
 					"P             Print histograms to perf.hist.N\n"
+					"V             Verbose (DSO names in callchains, etc)\n"
 					"/             Filter symbol by name");
 			continue;
 		case K_ENTER:
