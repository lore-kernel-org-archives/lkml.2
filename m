Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2INImq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 04:42:46 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46074 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2INImg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 04:42:36 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-bd-5052edf80e8e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/3] perf report: Enable itegrated annotation only if possible
Date: Fri, 14 Sep 2012 17:35:28 +0900
Message-Id: <1347611729-16994-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
References: <1347611729-16994-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The integrated annotation feature is supported only in TUI mode.  Also
it should be enabled with 'symbol' sort key otherwise resulting hist
entry doesn't need to have same symbol as of a sample so that it can
fail on hist_entry__inc_addr_samples with -ERANGE.

You can easily see it when start perf report TUI without symbol* sort
key.  This patch fixes the problem.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-report.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 279155a47d1c..1da243dfbc3e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -93,7 +93,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 			struct annotation *notes;
 			err = -ENOMEM;
 			bx = he->branch_info;
-			if (bx->from.sym && use_browser > 0) {
+			if (bx->from.sym && use_browser == 1 && sort__has_sym) {
 				notes = symbol__annotation(bx->from.sym);
 				if (!notes->src
 				    && symbol__alloc_hist(bx->from.sym) < 0)
@@ -107,7 +107,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					goto out;
 			}
 
-			if (bx->to.sym && use_browser > 0) {
+			if (bx->to.sym && use_browser == 1 && sort__has_sym) {
 				notes = symbol__annotation(bx->to.sym);
 				if (!notes->src
 				    && symbol__alloc_hist(bx->to.sym) < 0)
@@ -162,7 +162,7 @@ static int perf_evsel__add_hist_entry(struct perf_evsel *evsel,
 	 * so we don't allocated the extra space needed because the stdio
 	 * code will not use it.
 	 */
-	if (he->ms.sym != NULL && use_browser > 0) {
+	if (he->ms.sym != NULL && use_browser == 1 && sort__has_sym) {
 		struct annotation *notes = symbol__annotation(he->ms.sym);
 
 		assert(evsel != NULL);
@@ -694,12 +694,14 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		perf_hpp__init(false, false);
 	}
 
+	setup_sorting(report_usage, options);
+
 	/*
 	 * Only in the newt browser we are doing integrated annotation,
 	 * so don't allocate extra space that won't be used in the stdio
 	 * implementation.
 	 */
-	if (use_browser > 0) {
+	if (use_browser == 1 && sort__has_sym) {
 		symbol_conf.priv_size = sizeof(struct annotation);
 		report.annotate_init  = symbol__annotate_init;
 		/*
@@ -722,8 +724,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		goto error;
 
-	setup_sorting(report_usage, options);
-
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
 			goto error;
-- 
1.7.11.4

