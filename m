Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab2IQRYf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:24:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:46434 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab2IQRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/18] perf report: Enable integrated annotation only if possible
Date: Mon, 17 Sep 2012 14:18:02 -0300
Message-Id: <1347902292-14536-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1347611729-16994-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 97b2e63..b6696dd 100644
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
@@ -692,12 +692,14 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	else
 		use_browser = 0;
 
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
@@ -720,8 +722,6 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (symbol__init() < 0)
 		goto error;
 
-	setup_sorting(report_usage, options);
-
 	if (parent_pattern != default_parent_pattern) {
 		if (sort_dimension__add("parent") < 0)
 			goto error;
-- 
1.7.1

