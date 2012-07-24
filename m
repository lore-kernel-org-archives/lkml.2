Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2GXJJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 05:09:35 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55075 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2GXJHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 05:07:01 -0400
X-AuditID: 9c930179-b7bdcae000003d91-06-500e65b23209
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Ulrich Drepper <drepper@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 08/12] perf ui/browser: Add support to group viewing
Date: Tue, 24 Jul 2012 18:01:29 +0900
Message-Id: <1343120493-23059-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
References: <1343120493-23059-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Show group members' overhead also when showing the leader's.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 69584d79097e..bdb1b2f9f819 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -553,6 +553,33 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
+static int hist_browser__hpp_color_overhead(struct hist_print_context *ctx,
+					    struct hist_entry *he)
+{
+	int ret;
+	double percent = 100.0 * he->stat.period / ctx->total_period;
+
+	/* the leader determines the color */
+	*(double *)ctx->ptr = percent;
+
+	ret = scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
+
+	if (symbol_conf.report_group) {
+		struct perf_evsel *evsel = hists_2_evsel(ctx->hists);
+		int i;
+
+		for (i = 0; i < evsel->nr_children; i++) {
+			u64 period = he->group_stats[i].period;
+			u64 total_period = ctx->hists->group_stats[i].total_period;
+
+			percent = 100.0 * period / total_period;
+			ret += scnprintf(ctx->s + ret, ctx->size - ret,
+					 "  %5.2f%%", percent);
+		}
+	}
+	return ret;
+}
+
 #define HPP_COLOR_FN(_name, _field)						\
 static int hist_browser__hpp_color_ ## _name(struct hist_print_context *ctx,	\
 					     struct hist_entry *he)		\
@@ -562,7 +589,6 @@ static int hist_browser__hpp_color_ ## _name(struct hist_print_context *ctx,	\
 	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);		\
 }
 
-HPP_COLOR_FN(overhead, period)
 HPP_COLOR_FN(overhead_sys, period_sys)
 HPP_COLOR_FN(overhead_us, period_us)
 HPP_COLOR_FN(overhead_guest_sys, period_guest_sys)
-- 
1.7.10.4

