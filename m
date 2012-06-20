Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab2FTQrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 12:47:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38078 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2FTQrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 12:47:05 -0400
Date: Wed, 20 Jun 2012 09:46:50 -0700
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-42ab68a35ffee04700648ec42c9507145a66837d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338265382-6872-5-git-send-email-namhyung@gmail.com>
References: <1338265382-6872-5-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui/gtk: Introduce struct perf_gtk_context
Git-Commit-ID: 42ab68a35ffee04700648ec42c9507145a66837d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 20 Jun 2012 09:46:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42ab68a35ffee04700648ec42c9507145a66837d
Gitweb:     http://git.kernel.org/tip/42ab68a35ffee04700648ec42c9507145a66837d
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 29 May 2012 13:22:59 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Jun 2012 13:06:18 -0300

perf ui/gtk: Introduce struct perf_gtk_context

The struct perf_gtk_context is for tracking current state of GTK window
and/or other things. This is a preparation of next changes.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338265382-6872-5-git-send-email-namhyung@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/browser.c |    8 +++++++-
 tools/perf/ui/gtk/gtk.h     |   17 +++++++++++++++++
 tools/perf/ui/gtk/util.c    |   23 +++++++++++++++++++++++
 3 files changed, 47 insertions(+), 1 deletions(-)

diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index 0656c38..33ab1ae 100644
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
index 75177ee..34fbca6 100644
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
index a727fe3..6fe13fd 100644
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
