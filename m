Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0EPBAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 21:00:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab0EPA7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 20:59:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/2] perf newt: Add single key shortcuts for zoom into DSO and threads
Date: Sat, 15 May 2010 21:59:42 -0300
Message-Id: <1273971582-20206-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273971582-20206-1-git-send-email-acme@infradead.org>
References: <1273971582-20206-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

'D'/'d' for zooming into the DSO in the current highlighted hist entry,
'T'/'t' for zooming into the current thread.

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/newt.c |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 139eb1a..6974431 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -752,6 +752,10 @@ static int hist_browser__populate(struct hist_browser *self, struct hists *hists
 
 	newtFormAddHotKey(self->form, 'A');
 	newtFormAddHotKey(self->form, 'a');
+	newtFormAddHotKey(self->form, 'D');
+	newtFormAddHotKey(self->form, 'd');
+	newtFormAddHotKey(self->form, 'T');
+	newtFormAddHotKey(self->form, 't');
 	newtFormAddHotKey(self->form, NEWT_KEY_RIGHT);
 	newtFormAddHotKey(self->form, NEWT_KEY_LEFT);
 	newtFormAddComponents(self->form, self->tree, NULL);
@@ -834,9 +838,20 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2;
 
 		newtFormRun(browser->form, &es);
+
+		thread = hist_browser__selected_thread(browser);
+		dso = browser->selection->map ? browser->selection->map->dso : NULL;
+
 		if (es.reason == NEWT_EXIT_HOTKEY) {
-			if (toupper(es.u.key) == 'A')
+			switch (toupper(es.u.key)) {
+			case 'A':
 				goto do_annotate;
+			case 'D':
+				goto zoom_dso;
+			case 'T':
+				goto zoom_thread;
+			default:;
+			}
 			if (toupper(es.u.key) == 'Q' ||
 			    es.u.key == CTRL('c'))
 				break;
@@ -866,7 +881,6 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 			     browser->selection->sym->name) > 0)
 			annotate = nr_options++;
 
-		thread = hist_browser__selected_thread(browser);
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
 			     (thread_filter ? "out of" : "into"),
@@ -874,7 +888,6 @@ int hists__browse(struct hists *self, const char *helpline, const char *input_na
 			     thread->pid) > 0)
 			zoom_thread = nr_options++;
 
-		dso = browser->selection->map ? browser->selection->map->dso : NULL;
 		if (dso != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s DSO",
 			     (dso_filter ? "out of" : "into"),
@@ -910,12 +923,15 @@ do_annotate:
 
 			hist_entry__annotate_browser(he);
 		} else if (choice == zoom_dso) {
+zoom_dso:
 			if (dso_filter) {
 				pstack__remove(fstack, &dso_filter);
 zoom_out_dso:
 				ui_helpline__pop();
 				dso_filter = NULL;
 			} else {
+				if (dso == NULL)
+					continue;
 				ui_helpline__fpush("To zoom out press <- or -> + \"Zoom out of %s DSO\"",
 						   dso->kernel ? "the Kernel" : dso->short_name);
 				dso_filter = dso;
@@ -927,6 +943,7 @@ zoom_out_dso:
 			if (hist_browser__populate(browser, self, msg) < 0)
 				goto out;
 		} else if (choice == zoom_thread) {
+zoom_thread:
 			if (thread_filter) {
 				pstack__remove(fstack, &thread_filter);
 zoom_out_thread:
-- 
1.6.2.5

