Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab2FTQtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:49:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38120 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab2FTQtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:49:43 -0400
Date: Wed, 20 Jun 2012 09:49:28 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-e078ba14dff5c315ce19a978574883f417d2cfa0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338265382-6872-8-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-8-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Use struct perf_error_ops
Git-Commit-ID: e078ba14dff5c315ce19a978574883f417d2cfa0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:49:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e078ba14dff5c315ce19a978574883f417d2cfa0
Gitweb:     http://git.kernel.org/tip/e078ba14dff5c315ce19a978574883f417d2cfa0
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 29 May 2012 13:23:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:19 -0300

perf ui/gtk: Use struct perf_error_ops

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
