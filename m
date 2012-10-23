Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab2JWHqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:46:05 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46570 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab2JWHom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:44:42 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-5c-50864ae68c35
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 09/12] perf report: Bypass non-leader events when event group is enabled
Date: Tue, 23 Oct 2012 16:44:03 +0900
Message-Id: <1350978246-3686-10-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
References: <1350978246-3686-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
 tools/perf/builtin-report.c    |  4 ++++
 tools/perf/ui/browsers/hists.c | 39 +++++++++++++++++++++++++++++++++------
 tools/perf/ui/gtk/browser.c    |  4 ++++
 3 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index bacf12a4e0b9..6c73d8625829 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -320,6 +320,10 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
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
index 0f8be070aedd..e699973c0581 100644
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
1.7.11.7

