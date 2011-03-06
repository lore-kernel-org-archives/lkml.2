Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1CFUtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:49:03 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53273 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab1CFUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 3/6] perf hists browser: Handle browsing empty hists tree
Date: Sun,  6 Mar 2011 17:48:24 -0300
Message-Id: <1299444507-26549-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1299444507-26549-1-git-send-email-acme@infradead.org>
References: <1299444507-26549-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index c27ab35..c98e6f8 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -639,6 +639,9 @@ static void ui_browser__hists_seek(struct ui_browser *self,
 	struct rb_node *nd;
 	bool first = true;
 
+	if (self->nr_entries == 0)
+		return;
+
 	switch (whence) {
 	case SEEK_SET:
 		nd = hists__filter_entries(rb_first(self->entries));
@@ -820,8 +823,8 @@ int hists__browse(struct hists *self, const char *helpline,
 	hists__browser_title(self, msg, sizeof(msg), ev_name,
 			     dso_filter, thread_filter);
 	while (1) {
-		const struct thread *thread;
-		const struct dso *dso;
+		const struct thread *thread = NULL;
+		const struct dso *dso = NULL;
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
@@ -829,8 +832,10 @@ int hists__browse(struct hists *self, const char *helpline,
 
 		key = hist_browser__run(browser, msg);
 
-		thread = hist_browser__selected_thread(browser);
-		dso = browser->selection->map ? browser->selection->map->dso : NULL;
+		if (browser->he_selection != NULL) {
+			thread = hist_browser__selected_thread(browser);
+			dso = browser->selection->map ? browser->selection->map->dso : NULL;
+		}
 
 		switch (key) {
 		case NEWT_KEY_TAB:
@@ -841,7 +846,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			 */
 			goto out_free_stack;
 		case 'a':
-			if (browser->selection->map == NULL &&
+			if (browser->selection == NULL ||
+			    browser->selection->map == NULL ||
 			    browser->selection->map->dso->annotate_warned)
 				continue;
 			goto do_annotate;
@@ -887,7 +893,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			goto out_free_stack;
 		}
 
-		if (browser->selection->sym != NULL &&
+		if (browser->selection != NULL &&
+		    browser->selection->sym != NULL &&
 		    !browser->selection->map->dso->annotate_warned &&
 		    asprintf(&options[nr_options], "Annotate %s",
 			     browser->selection->sym->name) > 0)
@@ -906,7 +913,8 @@ int hists__browse(struct hists *self, const char *helpline,
 			     (dso->kernel ? "the Kernel" : dso->short_name)) > 0)
 			zoom_dso = nr_options++;
 
-		if (browser->selection->map != NULL &&
+		if (browser->selection != NULL &&
+		    browser->selection->map != NULL &&
 		    asprintf(&options[nr_options], "Browse map details") > 0)
 			browse_map = nr_options++;
 
-- 
1.6.2.5

