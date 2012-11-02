Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2KBFul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 01:50:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56459 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab2KBFu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 01:50:29 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-9b-50935f204a8c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: [PATCH 3/3] perf report: Postpone objdump check until annotation requested
Date: Fri,  2 Nov 2012 14:50:06 +0900
Message-Id: <1351835406-15208-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
References: <1351835406-15208-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

David reported that current perf report refused to run on a data file
captured from a different machine because of objdump.  Since the
objdump tools won't be used unless annotation was requested, checking
its presence at init time doens't make sense.

Reported-by: David Ahern <dsahern@gmail.com>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |  9 ++-------
 tools/perf/builtin-top.c       |  3 ++-
 tools/perf/ui/browsers/hists.c | 22 ++++++++++++++++------
 tools/perf/util/hist.h         |  7 +++++--
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 234f34d466e3..fc251005dd3d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -428,7 +428,8 @@ static int __cmd_report(struct perf_report *rep)
 	if (use_browser > 0) {
 		if (use_browser == 1) {
 			perf_evlist__tui_browse_hists(session->evlist, help,
-						      NULL);
+						      NULL,
+						      &session->header.env);
 		} else if (use_browser == 2) {
 			perf_evlist__gtk_browse_hists(session->evlist, help,
 						      NULL);
@@ -672,12 +673,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	has_br_stack = perf_header__has_feat(&session->header,
 					     HEADER_BRANCH_STACK);
 
-	if (!objdump_path) {
-		ret = perf_session_env__lookup_objdump(&session->header.env);
-		if (ret)
-			goto error;
-	}
-
 	if (sort__branch_mode == -1 && has_br_stack)
 		sort__branch_mode = 1;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 102b43c9905d..c9ff3950cd4b 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -598,7 +598,8 @@ static void *display_thread_tui(void *arg)
 	list_for_each_entry(pos, &top->evlist->entries, node)
 		pos->hists.uid_filter_str = top->target.uid_str;
 
-	perf_evlist__tui_browse_hists(top->evlist, help, &hbt);
+	perf_evlist__tui_browse_hists(top->evlist, help, &hbt,
+				      &top->session->header.env);
 
 	exit_browser(0);
 	exit(0);
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index c7d32edb8057..ccc4bd161420 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -11,6 +11,7 @@
 #include "../../util/pstack.h"
 #include "../../util/sort.h"
 #include "../../util/util.h"
+#include "../../arch/common.h"
 
 #include "../browser.h"
 #include "../helpline.h"
@@ -1137,7 +1138,8 @@ static inline bool is_report_browser(void *timer)
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
-				    struct hist_browser_timer *hbt)
+				    struct hist_browser_timer *hbt,
+				    struct perf_session_env *env)
 {
 	struct hists *hists = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(hists);
@@ -1367,6 +1369,9 @@ retry_popup_menu:
 			struct hist_entry *he;
 			int err;
 do_annotate:
+			if (!objdump_path && perf_session_env__lookup_objdump(env))
+				continue;
+
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
 				continue;
@@ -1470,6 +1475,7 @@ struct perf_evsel_menu {
 	struct ui_browser b;
 	struct perf_evsel *selection;
 	bool lost_events, lost_events_warned;
+	struct perf_session_env *env;
 };
 
 static void perf_evsel_menu__write(struct ui_browser *browser,
@@ -1551,7 +1557,8 @@ browse_hists:
 				hbt->timer(hbt->arg);
 			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
-						       ev_name, true, hbt);
+						       ev_name, true, hbt,
+						       menu->env);
 			ui_browser__show_title(&menu->b, title);
 			switch (key) {
 			case K_TAB:
@@ -1599,7 +1606,8 @@ out:
 
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 					   const char *help,
-					   struct hist_browser_timer *hbt)
+					   struct hist_browser_timer *hbt,
+					   struct perf_session_env *env)
 {
 	struct perf_evsel *pos;
 	struct perf_evsel_menu menu = {
@@ -1611,6 +1619,7 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.nr_entries = evlist->nr_entries,
 			.priv	    = evlist,
 		},
+		.env = env,
 	};
 
 	ui_helpline__push("Press ESC to exit");
@@ -1627,15 +1636,16 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt)
+				  struct hist_browser_timer *hbt,
+				  struct perf_session_env *env)
 {
 	if (evlist->nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = perf_evsel__name(first);
 		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
-						ev_name, false, hbt);
+						ev_name, false, hbt, env);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help, hbt);
+	return __perf_evlist__tui_browse_hists(evlist, help, hbt, env);
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 96664cce7c7b..a4f45dd04697 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <pthread.h>
 #include "callchain.h"
+#include "header.h"
 
 extern struct callchain_param callchain_param;
 
@@ -169,13 +170,15 @@ int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 			     struct hist_browser_timer *hbt);
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
-				  struct hist_browser_timer *hbt);
+				  struct hist_browser_timer *hbt,
+				  struct perf_session_env *env);
 int script_browse(const char *script_opt);
 #else
 static inline
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist __maybe_unused,
 				  const char *help __maybe_unused,
-				  struct hist_browser_timer *hbt __maybe_unused)
+				  struct hist_browser_timer *hbt __maybe_unused,
+				  struct perf_session_env *env __maybe_unused)
 {
 	return 0;
 }
-- 
1.7.11.7

