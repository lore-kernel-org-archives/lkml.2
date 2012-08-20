Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2HTQ06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:26:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/24] perf ui gtk: Implement helpline_fns
Date: Mon, 20 Aug 2012 13:26:12 -0300
Message-Id: <1345479985-18669-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Add helpline API implementation to GTK front-end.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345104894-14205-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile          |    1 +
 tools/perf/ui/gtk/gtk.h      |    2 ++
 tools/perf/ui/gtk/helpline.c |   30 ++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/setup.c    |    1 +
 4 files changed, 34 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/ui/gtk/helpline.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 483fb69..75af93d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -600,6 +600,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		# Make sure that it'd be included only once.
 		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
 			LIB_OBJS += $(OUTPUT)ui/setup.o
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index a4d0f2b..793cb61 100644
--- a/tools/perf/ui/gtk/gtk.h
+++ b/tools/perf/ui/gtk/gtk.h
@@ -29,6 +29,8 @@ static inline bool perf_gtk__is_active_context(struct perf_gtk_context *ctx)
 struct perf_gtk_context *perf_gtk__activate_context(GtkWidget *window);
 int perf_gtk__deactivate_context(struct perf_gtk_context **ctx);
 
+void perf_gtk__init_helpline(void);
+
 #ifndef HAVE_GTK_INFO_BAR
 static inline GtkWidget *perf_gtk__setup_info_bar(void)
 {
diff --git a/tools/perf/ui/gtk/helpline.c b/tools/perf/ui/gtk/helpline.c
new file mode 100644
index 0000000..2511b37
--- /dev/null
+++ b/tools/perf/ui/gtk/helpline.c
@@ -0,0 +1,30 @@
+#include "gtk.h"
+#include "../helpline.h"
+
+static void gtk_helpline_pop(void)
+{
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
+
+	gtk_statusbar_pop(GTK_STATUSBAR(pgctx->statbar),
+			  pgctx->statbar_ctx_id);
+}
+
+static void gtk_helpline_push(const char *msg)
+{
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
+
+	gtk_statusbar_push(GTK_STATUSBAR(pgctx->statbar),
+			   pgctx->statbar_ctx_id, msg);
+}
+
+static struct ui_helpline gtk_helpline_fns = {
+	.pop	= gtk_helpline_pop,
+	.push	= gtk_helpline_push,
+};
+
+void perf_gtk__init_helpline(void)
+{
+	helpline_fns = &gtk_helpline_fns;
+}
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 92879ce..ad40b36 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -7,6 +7,7 @@ extern struct perf_error_ops perf_gtk_eops;
 int perf_gtk__init(void)
 {
 	perf_error__register(&perf_gtk_eops);
+	perf_gtk__init_helpline();
 	return gtk_init_check(NULL, NULL) ? 0 : -1;
 }
 
-- 
1.7.1

