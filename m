Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2E2EX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:23:26 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51251 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2E2EXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:23:23 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/7] perf ui/gtk: Introduce struct perf_gtk_context
Date: Tue, 29 May 2012 13:22:59 +0900
Message-Id: <1338265382-6872-5-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct perf_gtk_context is for tracking current state of
GTK window and/or other things. This is a preparation of next
changes.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/ui/gtk/browser.c |    8 +++++++-
 tools/perf/ui/gtk/gtk.h     |   17 +++++++++++++++++
 tools/perf/ui/gtk/util.c    |   23 +++++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 0656c381a89c..33ab1aee3472 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -11,8 +11,8 @@
 
 static void perf_gtk__signal(int sig)
 {
+	perf_gtk__exit(false);
 	psignal(sig, "perf");
-	gtk_main_quit();
 }
 
 static void perf_gtk__resize_window(GtkWidget *window)
@@ -143,6 +143,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	g_signal_connect(window, "delete_event", gtk_main_quit, NULL);
 
+	pgctx = perf_gtk__activate_context(window);
+	if (!pgctx)
+		return -1;
+
 	notebook = gtk_notebook_new();
 
 	list_for_each_entry(pos, &evlist->entries, node) {
@@ -174,5 +178,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	gtk_main();
 
+	perf_gtk__deactivate_context(&pgctx);
+
 	return 0;
 }
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 75177ee04032..34fbca6d48a2 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -1,8 +1,25 @@
 #ifndef _PERF_GTK_H_
 #define _PERF_GTK_H_ 1
 
+#include <stdbool.h>
+
 #pragma GCC diagnostic ignored "-Wstrict-prototypes"
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
+
+struct perf_gtk_context {
+	GtkWidget *main_window;
+};
+
+extern struct perf_gtk_context *pgctx;
+
+static inline bool perf_gtk__is_active_context(struct perf_gtk_context *ctx)
+{
+	return ctx && ctx->main_window;
+}
+
+struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
+int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
+
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index a727fe394e91..6fe13fdc513e 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -3,6 +3,29 @@
 #include "gtk.h"
 
 
+struct perf_gtk_context *pgctx;
+
+struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window)
+{
+	struct perf_gtk_context *ctx;
+
+	ctx = malloc(sizeof(*pgctx));
+	if (ctx)
+		ctx->main_window = window;
+
+	return ctx;
+}
+
+int perf_gtk__deactivate_context(struct perf_gtk_context **ctx)
+{
+	if (!perf_gtk__is_active_context(*ctx))
+		return -1;
+
+	free(*ctx);
+	*ctx = NULL;
+	return 0;
+}
+
 /*
  * FIXME: Functions below should be implemented properly.
  *        For now, just add stubs for NO_NEWT=1 build.
-- 
1.7.9.2

