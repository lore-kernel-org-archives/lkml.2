Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab2CLPN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:13:59 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54252 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2CLPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:13:52 -0400
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, acme@redhat.com, asharma@fb.com,
        ravitillo@lbl.gov, vweaver1@eecs.utk.edu, khandual@linux.vnet.ibm.com,
        dsahern@gmail.com
Subject: [PATCH 2/2] perf report: fix annotate double quit issue in branch view mode
Date: Mon, 12 Mar 2012 16:13:30 +0100
Message-Id: <1331565210-10865-3-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1331565210-10865-1-git-send-email-eranian@google.com>
References: <1331565210-10865-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes perf report to not go back two levels when
pressing the 'q' key while annotating in branch view mode.

When pressing 'q' in annotate mode and if the branch source
and target belong to different functions, perf now brings
up the annotation popup menu again to offer the option to
annotate the other branch source or target.

As part of the code restructuring in perf_evsel__hists_browse()
we also fix a memory leak on options[] in case of error.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/ui/browsers/hists.c |   38 ++++++++++++++++++++++++++++------
 1 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 40fd424..de8ece8 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -856,6 +856,16 @@ static int hists__browser_title(struct hists *self, char *bf, size_t size,
 	return printed;
 }
 
+static inline void free_popup_options(char **options, int n)
+{
+	int i;
+
+	for (i = 0; i < n; ++i) {
+		free(options[i]);
+		options[i] = NULL;
+	}
+}
+
 static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 				    const char *helpline, const char *ev_name,
 				    bool left_exits,
@@ -866,6 +876,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	struct hist_browser *browser = hist_browser__new(self);
 	struct branch_info *bi;
 	struct pstack *fstack;
+	char *options[16];
+	int nr_options = 0;
 	int key = -1;
 
 	if (browser == NULL)
@@ -877,14 +889,17 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 
 	ui_helpline__push(helpline);
 
+	memset(options, 0, sizeof(options));
+
 	while (1) {
 		const struct thread *thread = NULL;
 		const struct dso *dso = NULL;
-		char *options[16];
-		int nr_options = 0, choice = 0, i,
+		int choice = 0,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
 		    annotate_f = -2, annotate_t = -2, browse_map = -2;
 
+		nr_options = 0;
+
 		key = hist_browser__run(browser, ev_name, timer, arg, delay_secs);
 
 		if (browser->he_selection != NULL) {
@@ -1023,17 +1038,16 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			browse_map = nr_options++;
 add_exit_option:
 		options[nr_options++] = (char *)"Exit";
-
+retry_popup_menu:
 		choice = ui__popup_menu(nr_options, options);
 
-		for (i = 0; i < nr_options - 1; ++i)
-			free(options[i]);
-
 		if (choice == nr_options - 1)
 			break;
 
-		if (choice == -1)
+		if (choice == -1) {
+			free_popup_options(options, nr_options - 1);
 			continue;
+		}
 
 		if (choice == annotate || choice == annotate_t || choice == annotate_f) {
 			struct hist_entry *he;
@@ -1064,9 +1078,18 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			err = hist_entry__tui_annotate(he, evsel->idx,
 						       timer, arg, delay_secs);
 			he->used = false;
+			/*
+			 * offer option to annotate the other branch source or target
+			 * (if they exists) when returning from annotate
+			 */
+			if ((err == 'q' || err == CTRL('c'))
+			    && annotate_t != -2 && annotate_f != -2)
+				goto retry_popup_menu;
+
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
 			if (err)
 				ui_browser__handle_resize(&browser->b);
+
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
@@ -1112,6 +1135,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	pstack__delete(fstack);
 out:
 	hist_browser__delete(browser);
+	free_popup_options(options, nr_options - 1);
 	return key;
 }
 
-- 
1.7.4.1

