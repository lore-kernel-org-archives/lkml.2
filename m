Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210Ab1JFR0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:26:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:44293 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758768Ab1JFRWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 12/15] perf hists browser: Don't offer symbol actions when symbols not on --sort
Date: Thu,  6 Oct 2011 14:22:35 -0300
Message-Id: <1317921758-4154-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Removing all the entries that only apply to symbols from the menu.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7bap0cy2fxtorlj5hgsp48m1@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index f0515cb..b790109 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -26,6 +26,7 @@ struct hist_browser {
 	struct map_symbol   *selection;
 	const struct thread *thread_filter;
 	const struct dso    *dso_filter;
+	bool		     has_symbols;
 };
 
 static int hists__browser_title(struct hists *self, char *bf, size_t size,
@@ -302,9 +303,9 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 	int key;
 	int delay_msecs = delay_secs * 1000;
 	char title[160];
-	int exit_keys[] = { 'a', '?', 'h', 'C', 'd', 'D', 'E', 't',
-			    NEWT_KEY_ENTER, NEWT_KEY_RIGHT, NEWT_KEY_LEFT,
-			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, 0, };
+	int sym_exit_keys[] = { 'a', 'h', 'C', 'd', 'E', 't', 0, };
+	int exit_keys[] = { '?', 'h', 'D', NEWT_KEY_LEFT, NEWT_KEY_RIGHT,
+			    NEWT_KEY_TAB, NEWT_KEY_UNTAB, NEWT_KEY_ENTER, 0, };
 
 	self->b.entries = &self->hists->entries;
 	self->b.nr_entries = self->hists->nr_entries;
@@ -321,6 +322,8 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		newtFormSetTimer(self->b.form, delay_msecs);
 
 	ui_browser__add_exit_keys(&self->b, exit_keys);
+	if (self->has_symbols)
+		ui_browser__add_exit_keys(&self->b, sym_exit_keys);
 
 	while (1) {
 		key = ui_browser__run(&self->b);
@@ -783,6 +786,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		self->hists = hists;
 		self->b.refresh = hist_browser__refresh;
 		self->b.seek = ui_browser__hists_seek;
+		self->has_symbols = sort_sym.list.next != NULL;
 	}
 
 	return self;
@@ -881,16 +885,17 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case NEWT_KEY_F1:
 		case 'h':
 		case '?':
-			ui__help_window("->        Zoom into DSO/Threads & Annotate current symbol\n"
+			ui__help_window("h/?/F1    Show this window\n"
+					"TAB/UNTAB Switch events\n"
+					"q/CTRL+C  Exit browser\n\n"
+					"For symbolic views (--sort has sym):\n\n"
+					"->        Zoom into DSO/Threads & Annotate current symbol\n"
 					"<-        Zoom out\n"
 					"a         Annotate current symbol\n"
-					"h/?/F1    Show this window\n"
 					"C         Collapse all callchains\n"
 					"E         Expand all callchains\n"
 					"d         Zoom into current DSO\n"
-					"t         Zoom into current Thread\n"
-					"TAB/UNTAB Switch events\n"
-					"q/CTRL+C  Exit browser");
+					"t         Zoom into current Thread\n");
 			continue;
 		case NEWT_KEY_ENTER:
 		case NEWT_KEY_RIGHT:
@@ -923,6 +928,9 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto out_free_stack;
 		}
 
+		if (!browser->has_symbols)
+			goto add_exit_option;
+
 		if (browser->selection != NULL &&
 		    browser->selection->sym != NULL &&
 		    !browser->selection->map->dso->annotate_warned &&
@@ -947,7 +955,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		    browser->selection->map != NULL &&
 		    asprintf(&options[nr_options], "Browse map details") > 0)
 			browse_map = nr_options++;
-
+add_exit_option:
 		options[nr_options++] = (char *)"Exit";
 
 		choice = ui__popup_menu(nr_options, options);
-- 
1.6.2.5

