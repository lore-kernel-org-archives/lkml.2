Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658Ab2CPUDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:03:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:41804 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932632Ab2CPUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/13] perf ui browser: Add 's' key to filter by symbol name
Date: Fri, 16 Mar 2012 17:02:08 -0300
Message-Id: <1331928130-16243-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now user can enter symbol name interested via ui_browser__input_window,
and perf can process it using hists__filter_by_symbol(). Giving empty
symbol (by pressing 's' followed by ENTER) will disable the filtering.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887855-874-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/hists.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index de8ece8..c4173c9 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -879,6 +879,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	char *options[16];
 	int nr_options = 0;
 	int key = -1;
+	char buf[64];
 
 	if (browser == NULL)
 		return -1;
@@ -933,6 +934,16 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto zoom_dso;
 		case 't':
 			goto zoom_thread;
+		case 's':
+			if (ui_browser__input_window("Symbol to show",
+					"Please enter the name of symbol you want to see",
+					buf, "ENTER: OK, ESC: Cancel",
+					delay_secs * 2) == K_ENTER) {
+				self->symbol_filter_str = *buf ? buf : NULL;
+				hists__filter_by_symbol(self);
+				hist_browser__reset(browser);
+			}
+			continue;
 		case K_F1:
 		case 'h':
 		case '?':
@@ -950,7 +961,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread");
+					"t             Zoom into current Thread\n"
+					"s             Filter symbol by name");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
-- 
1.7.9.2.358.g22243

