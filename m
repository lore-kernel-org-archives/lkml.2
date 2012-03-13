Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab2CMEvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:51:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35385 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437Ab2CMEvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:51:42 -0400
Date: Mon, 12 Mar 2012 21:51:27 -0700
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-24bff2dc0f77b1f186b7bdf30060caf3df191a68@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331565210-10865-3-git-send-email-eranian@google.com>
References: <1331565210-10865-3-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Fix annotate double quit issue in branch view mode
Git-Commit-ID: 24bff2dc0f77b1f186b7bdf30060caf3df191a68
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:51:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  24bff2dc0f77b1f186b7bdf30060caf3df191a68
Gitweb:     http://git.kernel.org/tip/24bff2dc0f77b1f186b7bdf30060caf3df191a68
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 12 Mar 2012 16:13:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:46:16 +0100

perf report: Fix annotate double quit issue in branch view mode

This patch fixes perf report to not go back two levels when
pressing the 'q' key while annotating in branch view mode.

When pressing 'q' in annotate mode and if the branch source
and target belong to different functions, perf now brings
up the annotation popup menu again to offer the option to
annotate the other branch source or target.

As part of the code restructuring in perf_evsel__hists_browse()
we also fix a memory leak on options[] in case of error.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331565210-10865-3-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
@@ -1064,9 +1078,18 @@ do_annotate:
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
@@ -1112,6 +1135,7 @@ out_free_stack:
 	pstack__delete(fstack);
 out:
 	hist_browser__delete(browser);
+	free_popup_options(options, nr_options - 1);
 	return key;
 }
 
