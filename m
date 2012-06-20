Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab2FTQsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:48:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2FTQsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:48:51 -0400
Date: Wed, 20 Jun 2012 09:48:35 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-a6b702c117f839023814c1e03453c701d26de522@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@gmail.com, fan4326@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, fan4326@gmail.com, tglx@linutronix.de,
        namhyung@gmail.com
In-Reply-To: <1338265382-6872-7-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-7-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk:
  Add GTK info_bar widget to browser window
Git-Commit-ID: a6b702c117f839023814c1e03453c701d26de522
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:48:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6b702c117f839023814c1e03453c701d26de522
Gitweb:     http://git.kernel.org/tip/a6b702c117f839023814c1e03453c701d26de522
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 29 May 2012 13:23:01 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:19 -0300

perf ui/gtk: Add GTK info_bar widget to browser window

The GtkInfoBar is a modern UI component to display messages without
bothering the main window. It'll be used for showing a warning message.

As the GtkInfoBar requires 2.18 (or newer) version of GTK+ library, add
availability check to Makefile too.

Suggested-by: Sunjin Yang <fan4326@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338265382-6872-7-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                 |    3 +++
 tools/perf/config/feature-tests.mak |   13 +++++++++++++
 tools/perf/ui/gtk/browser.c         |   33 +++++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/gtk.h             |   12 ++++++++++++
 4 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c0ee917..d698c11 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -523,6 +523,9 @@ else
 		msg := $(warning GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev);
 		BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 	else
+		ifeq ($(call try-cc,$(SOURCE_GTK2_INFOBAR),$(FLAGS_GTK2)),y)
+			BASIC_CFLAGS += -DHAVE_GTK_INFO_BAR
+		endif
 		BASIC_CFLAGS += $(shell pkg-config --cflags gtk+-2.0)
 		EXTLIBS += $(shell pkg-config --libs gtk+-2.0)
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index d9084e0..6c18785 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -78,6 +78,19 @@ int main(int argc, char *argv[])
         return 0;
 }
 endef
+
+define SOURCE_GTK2_INFOBAR
+#pragma GCC diagnostic ignored \"-Wstrict-prototypes\"
+#include <gtk/gtk.h>
+#pragma GCC diagnostic error \"-Wstrict-prototypes\"
+
+int main(void)
+{
+	gtk_info_bar_new();
+
+	return 0;
+}
+endef
 endif
 
 ifndef NO_LIBPERL
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index ece360d..fd41e8d 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -122,6 +122,34 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists)
 	gtk_container_add(GTK_CONTAINER(window), view);
 }
 
+#ifdef HAVE_GTK_INFO_BAR
+static GtkWidget *perf_gtk__setup_info_bar(void)
+{
+	GtkWidget *info_bar;
+	GtkWidget *label;
+	GtkWidget *content_area;
+
+	info_bar = gtk_info_bar_new();
+	gtk_widget_set_no_show_all(info_bar, TRUE);
+
+	label = gtk_label_new("");
+	gtk_widget_show(label);
+
+	content_area = gtk_info_bar_get_content_area(GTK_INFO_BAR(info_bar));
+	gtk_container_add(GTK_CONTAINER(content_area), label);
+
+	gtk_info_bar_add_button(GTK_INFO_BAR(info_bar), GTK_STOCK_OK,
+				GTK_RESPONSE_OK);
+	g_signal_connect(info_bar, "response",
+			 G_CALLBACK(gtk_widget_hide), NULL);
+
+	pgctx->info_bar = info_bar;
+	pgctx->message_label = label;
+
+	return info_bar;
+}
+#endif
+
 static GtkWidget *perf_gtk__setup_statusbar(void)
 {
 	GtkWidget *stbar;
@@ -145,6 +173,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 	struct perf_evsel *pos;
 	GtkWidget *vbox;
 	GtkWidget *notebook;
+	GtkWidget *info_bar;
 	GtkWidget *statbar;
 	GtkWidget *window;
 
@@ -189,6 +218,10 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
 
+	info_bar = perf_gtk__setup_info_bar();
+	if (info_bar)
+		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
+
 	statbar = perf_gtk__setup_statusbar();
 	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
 
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index 2061678..a4d0f2b 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -10,6 +10,11 @@
 
 struct perf_gtk_context {
 	GtkWidget *main_window;
+
+#ifdef HAVE_GTK_INFO_BAR
+	GtkWidget *info_bar;
+	GtkWidget *message_label;
+#endif
 	GtkWidget *statbar;
 	guint statbar_ctx_id;
 };
@@ -24,4 +29,11 @@ static inline bool perf_gtk__is_active_context(struct perf_gtk_context *ctx)
 struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
 int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
 
+#ifndef HAVE_GTK_INFO_BAR
+static inline GtkWidget *perf_gtk__setup_info_bar(void)
+{
+	return NULL;
+}
+#endif
+
 #endif /* _PERF_GTK_H_ */
