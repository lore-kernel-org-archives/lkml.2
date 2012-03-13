Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab2CMGNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:13:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:64668 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346Ab2CMGNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:13:05 -0400
X-AuditID: 9c93016f-b7c68ae000000b77-dc-4f5ee56ce5c1
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf report: Treat an argument as a symbol filter
Date: Tue, 13 Mar 2012 15:14:54 +0900
Message-Id: <1331619294-29162-4-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
References: <1331619294-29162-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Ingo requested, it'd be better off treating first (and the only)
argument as a symbol filter, so that user doesn't need to input the
symbol on the dialog window.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-report.c |   19 ++++++++++++++-----
 1 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25d34d483e49..62c4a11bcf3e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -50,6 +50,7 @@ struct perf_report {
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
+	const char		*symbol_filter_str;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -315,6 +316,9 @@ static int __cmd_report(struct perf_report *rep)
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 
+		if (pos->idx == 0)
+			hists->symbol_filter_str = rep->symbol_filter_str;
+
 		hists__collapse_resort(hists);
 		hists__output_resort(hists);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
@@ -586,11 +590,16 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	} else
 		symbol_conf.exclude_other = false;
 
-	/*
-	 * Any (unrecognized) arguments left?
-	 */
-	if (argc)
-		usage_with_options(report_usage, options);
+	if (argc) {
+		/*
+		 * Special case: if there's an argument left then assume tha
+		 * it's a symbol filter:
+		 */
+		if (argc > 1)
+			usage_with_options(report_usage, options);
+
+		report.symbol_filter_str = argv[0];
+	}
 
 	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
-- 
1.7.9

