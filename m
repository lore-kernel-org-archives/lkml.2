Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab2HTQ0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:26:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:56613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab2HTQ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/24] perf ui gtk: Ensure not to call gtk_main_quit() twice
Date: Mon, 20 Aug 2012 13:26:19 -0300
Message-Id: <1345479985-18669-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Currently the gtk_main_quit() is called twice when perf exits so the
following warning is emitted:

  [penberg@tux perf]$ ./perf report --gtk
  ^Cperf: Interrupt

  (perf:4048): Gtk-CRITICAL **: IA__gtk_main_quit: assertion `main_loops != NULL' failed

Fix it by not to call it unnecessarily.

Reported-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1345222583-3964-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/gtk/setup.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/gtk/setup.c b/tools/perf/ui/gtk/setup.c
index ad40b36..ec1ee26 100644
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
1.7.1

