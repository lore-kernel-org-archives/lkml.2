Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161476Ab2CPIwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 04:52:02 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56722 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759361Ab2CPIui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 04:50:38 -0400
X-AuditID: 9c930179-b7b27ae000000e38-cb-4f62fed99aa1
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/5] perf ui browser: Add 's' key to filter by symbol name
Date: Fri, 16 Mar 2012 17:50:53 +0900
Message-Id: <1331887855-874-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
References: <1331887855-874-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now user can enter symbol name interested via ui_browser__input_window,
and perf can process it using hists__filter_by_symbol(). Giving empty
symbol (by pressing 's' followed by ENTER) will disable the filtering.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/util/ui/browsers/hists.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index de8ece8bcce3..c4173c9733bb 100644
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
1.7.9

