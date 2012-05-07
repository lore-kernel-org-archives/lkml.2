Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2EGGEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 02:04:30 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45277 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2EGGE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 02:04:28 -0400
X-AuditID: 9c930197-b7badae000000cfd-87-4fa765e8801e
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2 2/2] perf ui/gtk: Use struct perf_error_ops
Date: Mon,  7 May 2012 15:03:02 +0900
Message-Id: <1336370582-30959-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1336370582-30959-1-git-send-email-namhyung.kim@lge.com>
References: <1336370582-30959-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define and use perf_gtk_eops to provide a GTK2 message
dialog for error reporting. To do that, we need global
main_window variable for tracking UI state.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/ui/gtk/browser.c |    6 ++++--
 tools/perf/ui/gtk/gtk.h     |    4 ++++
 tools/perf/ui/gtk/setup.c   |    6 ++++++
 tools/perf/ui/gtk/util.c    |   48 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 0656c381a89c..64286437a553 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -12,7 +12,7 @@
 static void perf_gtk__signal(int sig)
 {
 	psignal(sig, "perf");
-	gtk_main_quit();
+	perf_gtk__exit(false);
 }
 
 static void perf_gtk__resize_window(GtkWidget *window)
@@ -137,7 +137,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	signal(SIGQUIT, perf_gtk__signal);
 	signal(SIGTERM, perf_gtk__signal);
 
-	window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+	main_window = window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
 
 	gtk_window_set_title(GTK_WINDOW(window), "perf report");
 
@@ -174,5 +174,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	gtk_main();
 
+	main_window = NULL;
+
 	return 0;
 }
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 75177ee04032..eb08cbea0da1 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -5,4 +5,8 @@
 #include <gtk/gtk.h>
 #pragma GCC diagnostic error "-Wstrict-prototypes"
 
+#include "../../util/debug.h"
+
+extern GtkWidget *main_window;
+
 #endif /* _PERF_GTK_H_ */
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 829529957766..efd53a1a958c 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -1,12 +1,18 @@
 #include "gtk.h"
 #include "../../util/cache.h"
+#include "../../util/debug.h"
+
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
index a727fe394e91..6f105166be02 100644
--- a/tools/perf/ui/gtk/util.c
+++ b/tools/perf/ui/gtk/util.c
@@ -2,6 +2,54 @@
 #include "../../util/debug.h"
 #include "gtk.h"
 
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+
+GtkWidget *main_window;
+
+static int message_dialog(const char *title, const char *format, va_list args)
+{
+	char *msg;
+	GtkWidget *dialog;
+	GtkMessageType message_type = GTK_MESSAGE_WARNING;
+
+	if (!main_window || vasprintf(&msg, format, args) < 0) {
+		fprintf(stderr, "%s:\n", title);
+		vfprintf(stderr, format, args);
+		fprintf(stderr, "\n");
+		return -1;
+	}
+
+	if (strcmp(title, "Error") == 0)
+		message_type = GTK_MESSAGE_ERROR;
+
+	dialog = gtk_message_dialog_new_with_markup(GTK_WINDOW(main_window),
+					GTK_DIALOG_DESTROY_WITH_PARENT,
+					message_type,
+					GTK_BUTTONS_CLOSE,
+					"<b>%s</b>\n\n%s", title, msg);
+	gtk_dialog_run(GTK_DIALOG(dialog));
+	gtk_widget_destroy(dialog);
+	free(msg);
+	return 0;
+}
+
+static int perf_gtk__error(const char *format, va_list args)
+{
+	return message_dialog("Error", format, args);
+}
+
+static int perf_gtk__warning(const char *format, va_list args)
+{
+	return message_dialog("Warning", format, args);
+}
+
+struct perf_error_ops perf_gtk_eops = {
+	.error		= perf_gtk__error,
+	.warning	= perf_gtk__warning,
+};
 
 /*
  * FIXME: Functions below should be implemented properly.
-- 
1.7.10.1

