Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2HOO6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:58:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42867 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab2HOO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:58:49 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] perf ui/gtk: Implement helpline_fns
Date: Wed, 15 Aug 2012 23:57:33 +0900
Message-Id: <1345042655-27862-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
References: <1345042655-27862-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpline API implementation to GTK front-end.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile          |    1 +
 tools/perf/ui/gtk/gtk.h      |    2 ++
 tools/perf/ui/gtk/helpline.c |   31 +++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/setup.c    |    1 +
 4 files changed, 35 insertions(+)
 create mode 100644 tools/perf/ui/gtk/helpline.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 14c0b744d98e..91f16e26fd0d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -601,6 +601,7 @@ else
 		LIB_OBJS += $(OUTPUT)ui/gtk/browser.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/setup.o
 		LIB_OBJS += $(OUTPUT)ui/gtk/util.o
+		LIB_OBJS += $(OUTPUT)ui/gtk/helpline.o
 		# Make sure that it'd be included only once.
 		ifneq ($(findstring -DNO_NEWT_SUPPORT,$(BASIC_CFLAGS)),)
 			LIB_OBJS += $(OUTPUT)ui/setup.o
diff --git a/tools/perf/ui/gtk/gtk.h b/tools/perf/ui/gtk/gtk.h
index a4d0f2b4a2dc..793cb6116ddf 100644
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
index 000000000000..c02cb4a54939
--- /dev/null
+++ b/tools/perf/ui/gtk/helpline.c
@@ -0,0 +1,31 @@
+#include "gtk.h"
+#include "../helpline.h"
+
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
+static struct perf_helpline gtk_helpline_fns = {
+	.pop	= gtk_helpline_pop,
+	.push	= gtk_helpline_push,
+};
+
+void perf_gtk__init_helpline(void)
+{
+	helpline_fns = &gtk_helpline_fns;
+}
diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index 92879ce61e2f..ad40b3626fdb 100644
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
1.7.9.2

