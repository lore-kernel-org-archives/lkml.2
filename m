Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2KNHYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:24:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44003 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab2KNHY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:24:29 -0500
Date: Tue, 13 Nov 2012 23:24:10 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-68d807586ba83d9cb77f12c8fb7c97ea438d34ad@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, dsahern@gmail.com,
        irina.tirdea@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, irina.tirdea@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1351835406-15208-3-git-send-email-namhyung@kernel.org>
References: <1351835406-15208-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Postpone objdump check until annotation requested
Git-Commit-ID: 68d807586ba83d9cb77f12c8fb7c97ea438d34ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:24:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68d807586ba83d9cb77f12c8fb7c97ea438d34ad
Gitweb:     http://git.kernel.org/tip/68d807586ba83d9cb77f12c8fb7c97ea438d34ad
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 2 Nov 2012 14:50:06 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:03:58 -0300

perf report: Postpone objdump check until annotation requested

David reported that current perf report refused to run on a data file
captured from a different machine because of objdump.

Since the objdump tools won't be used unless annotation was requested,
checking its presence at init time doesn't make sense.

Reported-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: David Ahern <dsahern@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351835406-15208-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c    |    9 ++-------
 tools/perf/builtin-top.c       |    3 ++-
 tools/perf/ui/browsers/hists.c |   22 ++++++++++++++++------
 tools/perf/util/hist.h         |    7 +++++--
 4 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 234f34d..fc25100 100644
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
index 102b43c..c9ff395 100644
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
index c7d32ed..ccc4bd1 100644
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
index 96664cc..a4f45dd 100644
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
