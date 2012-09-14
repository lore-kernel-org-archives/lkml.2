Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab2INImt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:42:49 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46074 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2INImh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:42:37 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-bf-5052edf9ac23
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] perf ui/browser: Fix stale output of sorted result
Date: Fri, 14 Sep 2012 17:35:29 +0900
Message-Id: <1347611729-16994-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
References: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The hist_entry__sort_snprintf() can return 0 if all of the sort keys
are elided.  In this case a buffer which used for the function would
contain old message or a garbage and printed like below:

  $ perf record -g -e cycles:u abc
  $ perf --report -s comm -c abc
  (...)
  + 100.00%100.00%

Fix it by checking return value.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index a21f40bebbac..75b3898ca651 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -664,8 +664,8 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 		if (!browser->b.navkeypressed)
 			width += 1;
 
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		slsmg_write_nstring(s, width);
+		if (hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists))
+			slsmg_write_nstring(s, width);
 		++row;
 		++printed;
 	} else
@@ -981,7 +981,6 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	if (symbol_conf.use_callchain)
 		folded_sign = hist_entry__folded(he);
 
-	hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists);
 	percent = (he->period * 100.0) / browser->hists->stats.total_period;
 
 	if (symbol_conf.use_callchain)
@@ -995,7 +994,8 @@ static int hist_browser__fprintf_entry(struct hist_browser *browser,
 	if (symbol_conf.show_total_period)
 		printed += fprintf(fp, " %12" PRIu64, he->period);
 
-	printed += fprintf(fp, "%s\n", rtrim(s));
+	if (hist_entry__sort_snprintf(he, s, sizeof(s), browser->hists))
+		printed += fprintf(fp, "%s\n", rtrim(s));
 
 	if (folded_sign == '-')
 		printed += hist_browser__fprintf_callchain(browser, &he->sorted_chain, 1, fp);
-- 
1.7.11.4

