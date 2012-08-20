Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2HTFAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:00:01 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56341 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2HTE7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:59:11 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-28-5031c41c59a8
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/7] perf hists: Handle field separator properly
Date: Mon, 20 Aug 2012 13:52:08 +0900
Message-Id: <1345438331-20234-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
References: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When a field separator is given, the output format doesn't need to be
fancy like aligning to column length, coloring the percent value and
so on. And since there's a slight difference to normal format, fix it
not to break backward compatibility.

Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/hist.c       | 42 ++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/stdio/hist.c |  3 ++-
 2 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 8062b38f7971..29c787c93452 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -30,6 +30,10 @@ static int hpp_entry_overhead(struct hpp_context *ctx,
 			      struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
 }
 
@@ -54,6 +58,10 @@ static int hpp_entry_overhead_sys(struct hpp_context *ctx,
 				  struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_sys / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
 }
 
@@ -78,6 +86,10 @@ static int hpp_entry_overhead_us(struct hpp_context *ctx,
 				 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
 }
 
@@ -102,6 +114,10 @@ static int hpp_entry_overhead_guest_sys(struct hpp_context *ctx,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
 }
 
@@ -126,6 +142,10 @@ static int hpp_entry_overhead_guest_us(struct hpp_context *ctx,
 				       struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_us / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
 }
 
@@ -142,6 +162,9 @@ static int hpp_width_samples(struct hpp_context *ctx __used)
 static int hpp_entry_samples(struct hpp_context *ctx,
 			     struct hist_entry *he)
 {
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%" PRIu64, he->nr_events);
+
 	return scnprintf(ctx->s, ctx->size, "%11" PRIu64, he->nr_events);
 }
 
@@ -158,6 +181,9 @@ static int hpp_width_period(struct hpp_context *ctx __used)
 static int hpp_entry_period(struct hpp_context *ctx,
 			    struct hist_entry *he)
 {
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%" PRIu64, he->period);
+
 	return scnprintf(ctx->s, ctx->size, "%12" PRIu64, he->period);
 }
 
@@ -189,10 +215,16 @@ static int hpp_entry_delta(struct hpp_context *ctx,
 		new_percent = 100.0 * he->period / new_total;
 
 	diff = new_percent - old_percent;
-	if (fabs(diff) < 0.01)
+	if (fabs(diff) < 0.01) {
+		if (symbol_conf.field_sep)
+			return scnprintf(ctx->s, ctx->size, " ");
 		return scnprintf(ctx->s, ctx->size, "       ");
+	}
 
 	scnprintf(buf, sizeof(buf), "%+4.2F%%", diff);
+
+	if (symbol_conf.field_sep)
+		scnprintf(ctx->s, ctx->size, "%s", buf);
 	return scnprintf(ctx->s, ctx->size, "%7.7s", buf);
 }
 
@@ -211,10 +243,16 @@ static int hpp_entry_displ(struct hpp_context *ctx,
 {
 	char buf[32];
 
-	if (!ctx->displacement)
+	if (!ctx->displacement) {
+		if (symbol_conf.field_sep)
+			return scnprintf(ctx->s, ctx->size, " ");
 		return scnprintf(ctx->s, ctx->size, "     ");
+	}
 
 	scnprintf(buf, sizeof(buf), "%+4ld", ctx->displacement);
+
+	if (symbol_conf.field_sep)
+		scnprintf(ctx->s, ctx->size, "%s", buf);
 	return scnprintf(ctx->s, ctx->size, "%6.6s", buf);
 }
 
diff --git a/tools/perf/ui/stdio/hist.c b/tools/perf/ui/stdio/hist.c
index c040b03cc6f4..0712fb5c1bb7 100644
--- a/tools/perf/ui/stdio/hist.c
+++ b/tools/perf/ui/stdio/hist.c
@@ -319,11 +319,12 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
 		.displacement	= displacement,
 		.ptr		= pair_hists,
 	};
+	bool color = !symbol_conf.field_sep;
 
 	if (size == 0 || size > sizeof(bf))
 		size = ctx.size = sizeof(bf);
 
-	ret = hist_entry__period_snprintf(&ctx, he, true);
+	ret = hist_entry__period_snprintf(&ctx, he, color);
 	hist_entry__sort_snprintf(he, bf + ret, size - ret, hists);
 
 	ret = fprintf(fp, "%s\n", bf);
-- 
1.7.11.2

