Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2FSSAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:00:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:43334 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/20] perf ui/gtk: Add GTK statusbar widget to browser window
Date: Tue, 19 Jun 2012 14:50:05 -0300
Message-Id: <1340128221-17348-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Add statusbar widget to display non-critical messages at the bottom of
the window. This can be used for showing a status change, warning or
help message.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338265382-6872-6-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/browser.c |   26 +++++++++++++++++++++++++-
 tools/perf/ui/gtk/gtk.h     |    2 ++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 33ab1ae..ece360d 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -122,13 +122,30 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
 
+static GtkWidget *perf_gtk__setup_statusbar(void)
+{
+	GtkWidget *stbar;
+	unsigned ctxid;
+
+	stbar = gtk_statusbar_new();
+
+	ctxid = gtk_statusbar_get_context_id(GTK_STATUSBAR(stbar),
+					     "perf report");
+	pgctx->statbar = stbar;
+	pgctx->statbar_ctx_id = ctxid;
+
+	return stbar;
+}
+
 int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 				  const char *help __used,
 				  void (*timer) (void *arg)__used,
 				  void *arg __used, int delay_secs __used)
 {
 	struct perf_evsel *pos;
+	GtkWidget *vbox;
 	GtkWidget *notebook;
+	GtkWidget *statbar;
 	GtkWidget *window;
 
 	signal(SIGSEGV, perf_gtk__signal);
@@ -147,6 +164,8 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	if (!pgctx)
 		return -1;
 
+	vbox = gtk_vbox_new(FALSE, 0);
+
 	notebook = gtk_notebook_new();
 
 	list_for_each_entry(pos, &evlist->entries, node) {
@@ -168,7 +187,12 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
 	}
 
-	gtk_container_add(GTK_CONTAINER(window), notebook);
+	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+	statbar = perf_gtk__setup_statusbar();
+	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+	gtk_container_add(GTK_CONTAINER(window), vbox);
 
 	gtk_widget_show_all(window);
 
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 34fbca6..2061678 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -10,6 +10,8 @@
 
 struct perf_gtk_context {
 	GtkWidget *main_window;
+	GtkWidget *statbar;
+	guint statbar_ctx_id;
 };
 
 extern struct perf_gtk_context *pgctx;
-- 
1.7.1

