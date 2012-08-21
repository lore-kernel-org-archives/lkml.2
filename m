Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2HUQWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:22:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60994 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757890Ab2HUQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:22:11 -0400
Date: Tue, 21 Aug 2012 09:21:55 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-4bb1646a80db65bb45c0a1bffb2435c6690c392e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1345104894-14205-3-git-send-email-namhyung@kernel.org>
References: <1345104894-14205-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui gtk: Implement helpline_fns
Git-Commit-ID: 4bb1646a80db65bb45c0a1bffb2435c6690c392e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:22:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4bb1646a80db65bb45c0a1bffb2435c6690c392e
Gitweb:     http://git.kernel.org/tip/4bb1646a80db65bb45c0a1bffb2435c6690c392e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Thu, 16 Aug 2012 17:14:52 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Aug 2012 12:37:11 -0300

perf ui gtk: Implement helpline_fns

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
 
