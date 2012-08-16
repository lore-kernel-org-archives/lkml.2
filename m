Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2HPIXz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 04:23:55 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58556 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab2HPIVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 04:21:44 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-ef-502cad96f31f
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH v2 3/5] perf ui/gtk: Implement helpline_fns
Date: Thu, 16 Aug 2012 17:14:52 +0900
Message-Id: <1345104894-14205-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
References: <1345104894-14205-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpline API implementation to GTK front-end.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile          |  1 +
 tools/perf/ui/gtk/gtk.h      |  2 ++
 tools/perf/ui/gtk/helpline.c | 31 +++++++++++++++++++++++++++++++
 tools/perf/ui/gtk/setup.c    |  1 +
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
index 000000000000..9180fea920d5
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
1.7.11.2

