Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2KIQqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 11:46:52 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55288 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab2KIQpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 11:45:15 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 09/12] perf report: Bypass non-leader events when event group is enabled
Date: Sat, 10 Nov 2012 01:43:31 +0900
Message-Id: <1352479414-2324-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
References: <1352479414-2324-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Since we have all necessary information in the leader events and
other members don't, bypass members.  Member events will be shown
along with the leaders if event group is enabled.

Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |    4 ++++
 tools/perf/ui/browsers/hists.c |   41 ++++++++++++++++++++++++++++++++++------
 tools/perf/ui/gtk/browser.c    |    4 ++++
 3 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 1dc9b4bd5da8..94011af2a747 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -319,6 +319,10 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = &pos->hists;
 		const char *evname = perf_evsel__name(pos);
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index ffd41cbe07df..894d9bbc81c8 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1631,8 +1631,19 @@ out:
 	return key;
 }
 
+static bool filter_group_entries(struct ui_browser *self __maybe_unused,
+				 void *entry)
+{
+	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
+
+	if (symbol_conf.event_group && !perf_evsel__is_group_leader(evsel))
+		return true;
+
+	return false;
+}
+
 static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
-					   const char *help,
+					   int nr_entries, const char *help,
 					   struct hist_browser_timer *hbt,
 					   struct perf_session_env *env)
 {
@@ -1643,7 +1654,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = perf_evsel_menu__write,
-			.nr_entries = evlist->nr_entries,
+			.filter	    = filter_group_entries,
+			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
 		.env = env,
@@ -1659,20 +1671,37 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			menu.b.width = line_len;
 	}
 
-	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, hbt);
+	return perf_evsel_menu__run(&menu, nr_entries, help, hbt);
 }
 
 int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  struct hist_browser_timer *hbt,
 				  struct perf_session_env *env)
 {
-	if (evlist->nr_entries == 1) {
+	int nr_entries = evlist->nr_entries;
+
+single_entry:
+	if (nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
 		const char *ev_name = perf_evsel__name(first);
-		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
+
+		return perf_evsel__hists_browse(first, nr_entries, help,
 						ev_name, false, hbt, env);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help, hbt, env);
+	if (symbol_conf.event_group) {
+		struct perf_evsel *pos;
+
+		nr_entries = 0;
+		list_for_each_entry(pos, &evlist->entries, node)
+			if (perf_evsel__is_group_leader(pos))
+				nr_entries++;
+
+		if (nr_entries == 1)
+			goto single_entry;
+	}
+
+	return __perf_evlist__tui_browse_hists(evlist, nr_entries, help,
+					       hbt, env);
 }
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 293eb4ac5e9c..10cb81849566 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -304,6 +304,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
 
+		if (symbol_conf.event_group &&
+		    !perf_evsel__is_group_leader(pos))
+			continue;
+
 		scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 
 		gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(scrolled_window),
-- 
1.7.9.2

