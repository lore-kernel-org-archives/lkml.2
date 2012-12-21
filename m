Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab2LUIU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:20:58 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:45128 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235Ab2LUIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:20:40 -0500
X-AuditID: 9c930197-b7c5bae000000e31-b2-50d41bd6e288
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH 2/6] perf ui/gtk: Setup browser window early
Date: Fri, 21 Dec 2012 17:20:14 +0900
Message-Id: <1356078018-31905-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
References: <1356078018-31905-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ui__error/warning functions use gtk infobar or statusbar and
pr_* functions use statusbar too.  But after perf gtk context
created but those infobar and/or statusbar not yet set up,
calling one of those functions will get a segment fault.

Although current code has no problem, move these setting as early
as possible so that it can prevent the segfault from future change.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/hists.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 26912f86e032..c03da79d524f 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -180,6 +180,17 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	notebook = gtk_notebook_new();
 
+	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
+
+	info_bar = perf_gtk__setup_info_bar();
+	if (info_bar)
+		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
+
+	statbar = perf_gtk__setup_statusbar();
+	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
+
+	gtk_container_add(GTK_CONTAINER(window), vbox);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 		const char *evname = perf_evsel__name(pos);
@@ -199,17 +210,6 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 		gtk_notebook_append_page(GTK_NOTEBOOK(notebook), scrolled_window, tab_label);
 	}
 
-	gtk_box_pack_start(GTK_BOX(vbox), notebook, TRUE, TRUE, 0);
-
-	info_bar = perf_gtk__setup_info_bar();
-	if (info_bar)
-		gtk_box_pack_start(GTK_BOX(vbox), info_bar, FALSE, FALSE, 0);
-
-	statbar = perf_gtk__setup_statusbar();
-	gtk_box_pack_start(GTK_BOX(vbox), statbar, FALSE, FALSE, 0);
-
-	gtk_container_add(GTK_CONTAINER(window), vbox);
-
 	gtk_widget_show_all(window);
 
 	perf_gtk__resize_window(window);
-- 
1.7.11.7

