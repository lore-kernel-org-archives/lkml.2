Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2CMGNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:13:06 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64668 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab2CMGNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:13:04 -0400
X-AuditID: 9c93016f-b7c68ae000000b77-d7-4f5ee56c593b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] perf ui browser: Add 's' key to filter by symbol name
Date: Tue, 13 Mar 2012 15:14:53 +0900
Message-Id: <1331619294-29162-3-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
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
index bfba0490c098..8b6abcbb71c5 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -863,6 +863,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 	struct hist_browser *browser = hist_browser__new(self);
 	struct pstack *fstack;
 	int key = -1;
+	char buf[64];
 
 	if (browser == NULL)
 		return -1;
@@ -915,6 +916,16 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
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
@@ -932,7 +943,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
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

