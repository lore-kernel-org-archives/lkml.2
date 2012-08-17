Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2HQQ5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:57:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64050 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2HQQ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:57:32 -0400
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf ui/gtk: Ensure not to call gtk_main_quit() twice
Date: Sat, 18 Aug 2012 01:56:23 +0900
Message-Id: <1345222583-3964-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the gtk_main_quit() is called twice when perf exits so the
following warning is emitted:

  [penberg@tux perf]$ ./perf report --gtk
  ^Cperf: Interrupt

  (perf:4048): Gtk-CRITICAL **: IA__gtk_main_quit: assertion `main_loops != NULL' failed

Fix it by not to call it unnecessarily.

Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/gtk/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index ad40b3626fdb..ec1ee26b485a 100644
--- a/tools/perf/ui/gtk/setup.c
+++ b/tools/perf/ui/gtk/setup.c
@@ -13,6 +13,8 @@ int perf_gtk__init(void)
 
 void perf_gtk__exit(bool wait_for_ok __used)
 {
+	if (!perf_gtk__is_active_context(pgctx))
+		return;
 	perf_error__unregister(&perf_gtk_eops);
 	gtk_main_quit();
 }
-- 
1.7.9.2

