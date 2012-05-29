Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2E2EXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 00:23:35 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46113 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab2E2EXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 00:23:32 -0400
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 7/7] perf ui/gtk: Use struct perf_error_ops
Date: Tue, 29 May 2012 13:23:02 +0900
Message-Id: <1338265382-6872-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and use perf_gtk_eops to provide a GTK2 message
dialog for error reporting and a info_bar for warning.

As GtkInfoBar requires recent GTK+ libraries, provides
a fallback implementation using statusbar widget too.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/ui/gtk/setup.c |    5 +++
 tools/perf/ui/gtk/util.c  |   86 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 829529957766..92879ce61e2f 100644
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
index 6fe13fdc513e..0ead373c0dfb 100644
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
1.7.9.2

