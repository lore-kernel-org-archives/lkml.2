Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab2FTQsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:48:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab2FTQr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:47:58 -0400
Date: Wed, 20 Jun 2012 09:47:43 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-b4418c6848dcd56cc90625dcfaef7cb019492233@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338265382-6872-6-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-6-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk:
  Add GTK statusbar widget to browser window
Git-Commit-ID: b4418c6848dcd56cc90625dcfaef7cb019492233
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:47:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b4418c6848dcd56cc90625dcfaef7cb019492233
Gitweb:     http://git.kernel.org/tip/b4418c6848dcd56cc90625dcfaef7cb019492233
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 29 May 2012 13:23:00 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:19 -0300

perf ui/gtk: Add GTK statusbar widget to browser window

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
