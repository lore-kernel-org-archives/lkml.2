Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab2LHPEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 10:04:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49696 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab2LHPEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 10:04:23 -0500
Date: Sat, 8 Dec 2012 07:04:03 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-a753579c3ec096bba9d24e1594a07dbb25aca8e4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, penberg@kernel.org,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, penberg@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1352813436-14173-3-git-send-email-namhyung@kernel.org>
References: <1352813436-14173-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui gtk: Implement ui_progress functions
Git-Commit-ID: a753579c3ec096bba9d24e1594a07dbb25aca8e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 07:04:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a753579c3ec096bba9d24e1594a07dbb25aca8e4
Gitweb:     http://git.kernel.org/tip/a753579c3ec096bba9d24e1594a07dbb25aca8e4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Tue, 13 Nov 2012 22:30:33 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:52:48 -0300

perf ui gtk: Implement ui_progress functions

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
 tools/perf/Makefile          |  1 +
 tools/perf/ui/gtk/gtk.h      |  1 +
 tools/perf/ui/gtk/progress.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/setup.c    |  2 ++
 4 files changed, 54 insertions(+)

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
 
