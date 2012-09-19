Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab2ISPRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:17:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2ISPRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:17:14 -0400
Date: Wed, 19 Sep 2012 08:16:53 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-034a9265c289d5298bac7bfd824d3d5b9ec892b4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1347611729-16994-2-git-send-email-namhyung@kernel.org>
References: <1347611729-16994-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report:
  Enable integrated annotation only if possible
Git-Commit-ID: 034a9265c289d5298bac7bfd824d3d5b9ec892b4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:16:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  034a9265c289d5298bac7bfd824d3d5b9ec892b4
Gitweb:     http://git.kernel.org/tip/034a9265c289d5298bac7bfd824d3d5b9ec892b4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 14 Sep 2012 17:35:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 17 Sep 2012 13:09:43 -0300

perf report: Enable integrated annotation only if possible

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
