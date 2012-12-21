Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770Ab2LUIVL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:21:11 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45128 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab2LUIUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:20:41 -0500
X-AuditID: 9c930197-b7c5bae000000e31-ba-50d41bd742a0
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/6] perf gtk/annotate: Support multiple annotation result
Date: Fri, 21 Dec 2012 17:20:16 +0900
Message-Id: <1356078018-31905-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show multiple annotation result for each tab.  For this add reference
to main container (notebook) to the pgctx.

For the first call to annotate browser, hist_entry__find_annotations()
will setup a new browser, and next calls will add new tabs to the
browser.  But it requires final perf_gtk__show_annotations() to start
processing GUI events.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  4 +++
 tools/perf/ui/gtk/annotate.c  | 72 +++++++++++++++++++++++++++----------------
 tools/perf/ui/gtk/gtk.h       |  1 +
 tools/perf/util/annotate.h    |  4 +++
 4 files changed, 54 insertions(+), 27 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9f84bc45672c..034e9b003c62 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -227,6 +227,10 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		ui__error("The %s file has no samples!\n", session->filename);
 		goto out_delete;
 	}
+
+	if (use_browser == 2)
+		perf_gtk__show_annotations();
+
 out_delete:
 	/*
 	 * Speed up the exit process, for large files this can
diff --git a/tools/perf/ui/gtk/annotate.c b/tools/perf/ui/gtk/annotate.c
index 19d84fa327af..191ee4e30d93 100644
--- a/tools/perf/ui/gtk/annotate.c
+++ b/tools/perf/ui/gtk/annotate.c
@@ -126,31 +126,50 @@ static int perf_gtk__annotate_symbol(GtkWidget *window, struct symbol *sym,
 int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 			 struct hist_browser_timer *hbt)
 {
-	GtkWidget *vbox;
-	GtkWidget *notebook;
-	GtkWidget *infobar;
-	GtkWidget *statbar;
 	GtkWidget *window;
+	GtkWidget *notebook;
 	GtkWidget *scrolled_window;
 	GtkWidget *tab_label;
 
-	signal(SIGSEGV, perf_gtk__signal);
-	signal(SIGFPE,  perf_gtk__signal);
-	signal(SIGINT,  perf_gtk__signal);
-	signal(SIGQUIT, perf_gtk__signal);
-	signal(SIGTERM, perf_gtk__signal);
+	if (perf_gtk__is_active_context(pgctx)) {
+		window = pgctx->main_window;
+		notebook = pgctx->notebook;
+	} else {
+		GtkWidget *vbox;
+		GtkWidget *infobar;
+		GtkWidget *statbar;
 
-	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
-	gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
+		signal(SIGSEGV, perf_gtk__signal);
+		signal(SIGFPE,  perf_gtk__signal);
+		signal(SIGINT,  perf_gtk__signal);
+		signal(SIGQUIT, perf_gtk__signal);
+		signal(SIGTERM, perf_gtk__signal);
 
-	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+		window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+		gtk_window_set_title(GTK_WINDOW(window), "perf annotate");
 
-	pgctx = perf_gtk__activate_context(window);
-	if (!pgctx)
-		return -1;
+		g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
+
+		pgctx = perf_gtk__activate_context(window);
+		if (!pgctx)
+			return -1;
+
+		vbox = gtk_vbox_new(FALSE, 0);
+		notebook = gtk_notebook_new();
+		pgctx->notebook = notebook;
+
+		gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+		infobar = perf_gtk__setup_info_bar();
+		if (infobar)
+			gtk_box_pack_start(GTK_BOX(vbox), infobar, FALSE, FALSE, 0);
+
+		statbar = perf_gtk__setup_statusbar();
+		gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+		gtk_container_add(GTK_CONTAINER(window), vbox);
+	}
 
-	vbox = gtk_vbox_new(FALSE, 0);
-	notebook = gtk_notebook_new();
 	scrolled_window = gtk_scrolled_window_new(NULL, NULL);
 	tab_label = gtk_label_new(sym->name);
 
@@ -160,19 +179,19 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window,
 				 tab_label);
-	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
-
-	infobar = perf_gtk__setup_info_bar();
-	if (infobar)
-		gtk_box_pack_start(GTK_BOX(vbox), infobar, FALSE, FALSE, 0);
 
-	statbar = perf_gtk__setup_statusbar();
-	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	return 0;
+}
 
-	gtk_container_add(GTK_CONTAINER(window), vbox);
+void perf_gtk__show_annotations(void)
+{
+	GtkWidget *window;
 
-	perf_gtk__annotate_symbol(scrolled_window, sym, map, evidx, hbt);
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
 
+	window = pgctx->main_window;
 	gtk_widget_show_all(window);
 
 	perf_gtk__resize_window(window);
@@ -181,5 +200,4 @@ int symbol__gtk_annotate(struct symbol *sym, struct map *map, int evidx,
 	gtk_main();
 
 	perf_gtk__deactivate_context(&pgctx);
-	return 0;
 }
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 5d3693754828..3d96785ef155 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -10,6 +10,7 @@
 
 struct perf_gtk_context {
 	GtkWidget *main_window;
+	GtkWidget *notebook;
 
 #ifdef HAVE_GTK_INFO_BAR
 	GtkWidget *info_bar;
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a8ccbda4aeb7..c422440fe611 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -164,6 +164,8 @@ static inline int hist_entry__gtk_annotate(struct hist_entry *he, int evidx,
 {
 	return symbol__gtk_annotate(he->ms.sym, he->ms.map, evidx, hbt);
 }
+
+void perf_gtk__show_annotations(void);
 #else
 static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
 					   int evidx __maybe_unused,
@@ -172,6 +174,8 @@ static inline int hist_entry__gtk_annotate(struct hist_entry *he __maybe_unused,
 {
 	return 0;
 }
+
+static inline void perf_gtk__show_annotations(void) {}
 #endif
 
 extern const char	*disassembler_style;
-- 
1.7.11.7

