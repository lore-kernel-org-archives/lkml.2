Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab2HFJFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:05:24 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51175 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2HFJDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:03:52 -0400
X-AuditID: 9c930179-b7bdcae000003d91-33-501f88753796
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Pekka Enberg <penberg@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/7] perf hists: Handle field separator properly
Date: Mon,  6 Aug 2012 17:57:39 +0900
Message-Id: <1344243462-28403-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1344243462-28403-1-git-send-email-namhyung@kernel.org>
References: <1344243462-28403-1-git-send-email-namhyung@kernel.org>
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
 tools/perf/ui/hist.c | 45 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 6817fcb0b303..01724a9905c0 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -31,6 +31,10 @@ static int hpp_entry_overhead(struct hpp_context *ctx,
 			      struct hist_entry *he)
 {
 	double percent = 100.0 * he->period / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%%", percent);
 }
 
@@ -55,6 +59,10 @@ static int hpp_entry_overhead_sys(struct hpp_context *ctx,
 				  struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_sys / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
 }
 
@@ -79,6 +87,10 @@ static int hpp_entry_overhead_us(struct hpp_context *ctx,
 				 struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_us / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);
 }
 
@@ -103,6 +115,10 @@ static int hpp_entry_overhead_guest_sys(struct hpp_context *ctx,
 					struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_sys / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
 }
 
@@ -127,6 +143,10 @@ static int hpp_entry_overhead_guest_us(struct hpp_context *ctx,
 				       struct hist_entry *he)
 {
 	double percent = 100.0 * he->period_guest_us / ctx->total_period;
+
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%.2f", percent);
+
 	return scnprintf(ctx->s, ctx->size, "  %5.2f%% ", percent);
 }
 
@@ -143,6 +163,9 @@ static int hpp_width_samples(struct hpp_context *ctx __used)
 static int hpp_entry_samples(struct hpp_context *ctx,
 			     struct hist_entry *he)
 {
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%" PRIu64, he->nr_events);
+
 	return scnprintf(ctx->s, ctx->size, "%11" PRIu64, he->nr_events);
 }
 
@@ -159,6 +182,9 @@ static int hpp_width_period(struct hpp_context *ctx __used)
 static int hpp_entry_period(struct hpp_context *ctx,
 			    struct hist_entry *he)
 {
+	if (symbol_conf.field_sep)
+		return scnprintf(ctx->s, ctx->size, "%" PRIu64, he->period);
+
 	return scnprintf(ctx->s, ctx->size, "%12" PRIu64, he->period);
 }
 
@@ -190,10 +216,16 @@ static int hpp_entry_delta(struct hpp_context *ctx,
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
 
@@ -212,10 +244,16 @@ static int hpp_entry_displ(struct hpp_context *ctx,
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
 
@@ -641,11 +679,12 @@ static int hist_entry__fprintf(struct hist_entry *he, size_t size,
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

