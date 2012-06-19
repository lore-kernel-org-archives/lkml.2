Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2FSSDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:03:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33396 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/20] perf ui/gtk: Use struct perf_error_ops
Date: Tue, 19 Jun 2012 14:50:07 -0300
Message-Id: <1340128221-17348-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Define and use perf_gtk_eops to provide a GTK2 message dialog for error
reporting and a info_bar for warning.

As GtkInfoBar requires recent GTK+ libraries, provides a fallback
implementation using statusbar widget too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338265382-6872-8-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/setup.c |    5 +++
 tools/perf/ui/gtk/util.c  |   86 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 8295299..92879ce 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -1,12 +1,17 @@
 #include "gtk.h"
 #include "../../util/cache.h"
+#include "../../util/debug.h"
+
+extern struct perf_error_ops perf_gtk_eops;
 
 int perf_gtk__init(void)
 {
+	perf_error__register(&perf_gtk_eops);
 	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
 void perf_gtk__exit(bool wait_for_ok __used)
 {
+	perf_error__unregister(&perf_gtk_eops);
 	gtk_main_quit();
 }
diff --git a/tools/perf/ui/gtk/util.c b/tools/perf/ui/gtk/util.c
index 6fe13fd..0ead373 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -2,6 +2,8 @@
 #include "../../util/debug.h"
 #include "gtk.h"
 
+#include <string.h>
+
 
 struct perf_gtk_context *pgctx;
 
@@ -26,6 +28,90 @@ int perf_gtk__deactivate_context(struct perf_gtk_context **ctx)
 	return 0;
 }
 
+static int perf_gtk__error(const char *format, va_list args)
+{
+	char *msg;
+	GtkWidget *dialog;
+
+	if (!perf_gtk__is_active_context(pgctx) ||
+	    vasprintf(&msg, format, args) < 0) {
+		fprintf(stderr, "Error:\n");
+		vfprintf(stderr, format, args);
+		fprintf(stderr, "\n");
+		return -1;
+	}
+
+	dialog = gtk_message_dialog_new_with_markup(GTK_WINDOW(pgctx->main_window),
+					GTK_DIALOG_DESTROY_WITH_PARENT,
+					GTK_MESSAGE_ERROR,
+					GTK_BUTTONS_CLOSE,
+					"<b>Error</b>\n\n%s", msg);
+	gtk_dialog_run(GTK_DIALOG(dialog));
+
+	gtk_widget_destroy(dialog);
+	free(msg);
+	return 0;
+}
+
+#ifdef HAVE_GTK_INFO_BAR
+static int perf_gtk__warning_info_bar(const char *format, va_list args)
+{
+	char *msg;
+
+	if (!perf_gtk__is_active_context(pgctx) ||
+	    vasprintf(&msg, format, args) < 0) {
+		fprintf(stderr, "Warning:\n");
+		vfprintf(stderr, format, args);
+		fprintf(stderr, "\n");
+		return -1;
+	}
+
+	gtk_label_set_text(GTK_LABEL(pgctx->message_label), msg);
+	gtk_info_bar_set_message_type(GTK_INFO_BAR(pgctx->info_bar),
+				      GTK_MESSAGE_WARNING);
+	gtk_widget_show(pgctx->info_bar);
+
+	free(msg);
+	return 0;
+}
+#else
+static int perf_gtk__warning_statusbar(const char *format, va_list args)
+{
+	char *msg, *p;
+
+	if (!perf_gtk__is_active_context(pgctx) ||
+	    vasprintf(&msg, format, args) < 0) {
+		fprintf(stderr, "Warning:\n");
+		vfprintf(stderr, format, args);
+		fprintf(stderr, "\n");
+		return -1;
+	}
+
+	gtk_statusbar_pop(GTK_STATUSBAR(pgctx->statbar),
+			  pgctx->statbar_ctx_id);
+
+	/* Only first line can be displayed */
+	p = strchr(msg, '\n');
+	if (p)
+		*p = '\0';
+
+	gtk_statusbar_push(GTK_STATUSBAR(pgctx->statbar),
+			   pgctx->statbar_ctx_id, msg);
+
+	free(msg);
+	return 0;
+}
+#endif
+
+struct perf_error_ops perf_gtk_eops = {
+	.error		= perf_gtk__error,
+#ifdef HAVE_GTK_INFO_BAR
+	.warning	= perf_gtk__warning_info_bar,
+#else
+	.warning	= perf_gtk__warning_statusbar,
+#endif
+};
+
 /*
  * FIXME: Functions below should be implemented properly.
  *        For now, just add stubs for NO_NEWT=1 build.
-- 
1.7.1

