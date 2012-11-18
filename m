Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360Ab2KROa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:30:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36537 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2KROaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:13 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/32] perf ui gtk: Implement ui_progress functions
Date: Sun, 18 Nov 2012 11:29:50 -0300
Message-Id: <1353248997-30763-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Implement progress update function for GTK2 front end.

Note that since it will be called before gtk main loop so that we should
call gtk event loop handler directly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1352813436-14173-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    1 +
 tools/perf/ui/gtk/gtk.h      |    1 +
 tools/perf/ui/gtk/progress.c |   50 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/setup.c    |    2 ++
 4 files changed, 54 insertions(+)
 create mode 100644 tools/perf/ui/gtk/progress.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index f8466b4..5a9075e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -648,6 +648,7 @@ ifndef NO_GTK2
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/progress.o
 		# Make sure that it'd be included only once.
 		ifeq ($(findstring -DNEWT_SUPPORT,$(BASIC_CFLAGS)),)
 			LIB_OBJS += $(OUTPUT)ui/setup.o
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 687af0b..856320e 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -30,6 +30,7 @@ struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
 int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
 
 void perf_gtk__init_helpline(void);
+void perf_gtk__init_progress(void);
 void perf_gtk__init_hpp(void);
 
 #ifndef HAVE_GTK_INFO_BAR
diff --git a/tools/perf/ui/gtk/progress.c b/tools/perf/ui/gtk/progress.c
new file mode 100644
index 0000000..903426f
--- /dev/null
+++ b/tools/perf/ui/gtk/progress.c
@@ -0,0 +1,50 @@
+#include <inttypes.h>
+
+#include "gtk.h"
+#include "../progress.h"
+#include "util.h"
+
+static GtkWidget *dialog;
+static GtkWidget *progress;
+
+static void gtk_progress_update(u64 curr, u64 total, const char *title)
+{
+	double fraction = total ? 1.0 * curr / total : 0.0;
+	char buf[1024];
+
+	if (dialog == NULL) {
+		GtkWidget *vbox = gtk_vbox_new(TRUE, 5);
+		GtkWidget *label = gtk_label_new(title);
+
+		dialog = gtk_window_new(GTK_WINDOW_TOPLEVEL);
+		progress = gtk_progress_bar_new();
+
+		gtk_box_pack_start(GTK_BOX(vbox), label, TRUE, FALSE, 3);
+		gtk_box_pack_start(GTK_BOX(vbox), progress, TRUE, TRUE, 3);
+
+		gtk_container_add(GTK_CONTAINER(dialog), vbox);
+
+		gtk_window_set_title(GTK_WINDOW(dialog), "perf");
+		gtk_window_resize(GTK_WINDOW(dialog), 300, 80);
+		gtk_window_set_position(GTK_WINDOW(dialog), GTK_WIN_POS_CENTER);
+
+		gtk_widget_show_all(dialog);
+	}
+
+	gtk_progress_bar_set_fraction(GTK_PROGRESS_BAR(progress), fraction);
+	snprintf(buf, sizeof(buf), "%"PRIu64" / %"PRIu64, curr, total);
+	gtk_progress_bar_set_text(GTK_PROGRESS_BAR(progress), buf);
+
+	/* we didn't call gtk_main yet, so do it manually */
+	while (gtk_events_pending())
+		gtk_main_iteration();
+}
+
+static struct ui_progress gtk_progress_fns = {
+	.update		= gtk_progress_update,
+};
+
+void perf_gtk__init_progress(void)
+{
+	progress_fns = &gtk_progress_fns;
+}
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 3c4c6ef..6c2dd2e 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -8,7 +8,9 @@ int perf_gtk__init(void)
 {
 	perf_error__register(&perf_gtk_eops);
 	perf_gtk__init_helpline();
+	perf_gtk__init_progress();
 	perf_gtk__init_hpp();
+
 	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
-- 
1.7.9.2.358.g22243

