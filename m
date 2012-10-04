Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2JDMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 08:52:42 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58823 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2JDMwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 08:52:15 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 18/20] perf report: Bypass non-leader events when event group is enabled
Date: Thu,  4 Oct 2012 21:49:52 +0900
Message-Id: <1349354994-17853-19-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
References: <1349354994-17853-1-git-send-email-namhyung@kernel.org>
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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c    |    4 ++++
 tools/perf/ui/browsers/hists.c |   39 +++++++++++++++++++++++++++++++++------
 tools/perf/ui/gtk/browser.c    |    4 ++++
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b7e250d63892..ba5cfb40818d 100644
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
index df0ddeeeb860..43eb90969799 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1578,8 +1578,19 @@ out:
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
 					   void(*timer)(void *arg), void *arg,
 					   int delay_secs)
 {
@@ -1590,7 +1601,8 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			.refresh    = ui_browser__list_head_refresh,
 			.seek	    = ui_browser__list_head_seek,
 			.write	    = perf_evsel_menu__write,
-			.nr_entries = evlist->nr_entries,
+			.filter	    = filter_group_entries,
+			.nr_entries = nr_entries,
 			.priv	    = evlist,
 		},
 	};
@@ -1605,7 +1617,7 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 			menu.b.width = line_len;
 	}
 
-	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, timer,
+	return perf_evsel_menu__run(&menu, nr_entries, help, timer,
 				    arg, delay_secs);
 }
 
@@ -1613,15 +1625,30 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int delay_secs)
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
+		return perf_evsel__hists_browse(first, nr_entries, help,
 						ev_name, false, timer, arg,
 						delay_secs);
 	}
 
-	return __perf_evlist__tui_browse_hists(evlist, help,
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
 					       timer, arg, delay_secs);
 }
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index b2c8b8e69e4d..ae6b941ef3d4 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -306,6 +306,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
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

