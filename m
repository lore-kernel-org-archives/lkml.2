Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab2HTFAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 01:00:12 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44965 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2HTE7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:59:12 -0400
X-AuditID: 9c930197-b7bb2ae0000011d9-2d-5031c41c3697
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 6/7] perf ui/browser: Use hist_period_print functions
Date: Mon, 20 Aug 2012 13:52:10 +0900
Message-Id: <1345438331-20234-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
References: <1345438331-20234-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Override hpp->color functions for TUI. Because line coloring is done
outside of the function, it just sets the percent value and pass it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 94 ++++++++++++++++++++++++++++++++----------
 tools/perf/ui/tui/setup.c      |  4 ++
 2 files changed, 76 insertions(+), 22 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 81bd8c2af730..69ce68708c0b 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -28,6 +28,8 @@ struct hist_browser {
 	bool		     has_symbols;
 };
 
+extern void hist_browser__init_hpp(void);
+
 static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 				const char *ev_name);
 
@@ -563,14 +565,47 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	return row - first_row;
 }
 
+#define HPP_COLOR_FN(_name, _field)					\
+static int hist_browser__hpp_color_ ## _name(struct hpp_context *ctx,	\
+					     struct hist_entry *he)	\
+{									\
+	double percent = 100.0 * he->_field / ctx->total_period;	\
+	*(double *)ctx->ptr = percent;					\
+	return scnprintf(ctx->s, ctx->size, "%5.2f%%", percent);	\
+}
+
+HPP_COLOR_FN(overhead, period)
+HPP_COLOR_FN(overhead_sys, period_sys)
+HPP_COLOR_FN(overhead_us, period_us)
+HPP_COLOR_FN(overhead_guest_sys, period_guest_sys)
+HPP_COLOR_FN(overhead_guest_us, period_guest_us)
+
+#undef HPP_COLOR_FN
+
+void hist_browser__init_hpp(void)
+{
+	perf_hpp__init(false, false);
+
+	hpp_functions[PERF_HPP__OVERHEAD].color =
+				hist_browser__hpp_color_overhead;
+	hpp_functions[PERF_HPP__OVERHEAD_SYS].color =
+				hist_browser__hpp_color_overhead_sys;
+	hpp_functions[PERF_HPP__OVERHEAD_US].color =
+				hist_browser__hpp_color_overhead_us;
+	hpp_functions[PERF_HPP__OVERHEAD_GUEST_SYS].color =
+				hist_browser__hpp_color_overhead_guest_sys;
+	hpp_functions[PERF_HPP__OVERHEAD_GUEST_US].color =
+				hist_browser__hpp_color_overhead_guest_us;
+}
+
 static int hist_browser__show_entry(struct hist_browser *browser,
 				    struct hist_entry *entry,
 				    unsigned short row)
 {
 	char s[256];
 	double percent;
-	int printed = 0;
-	int width = browser->b.width - 6; /* The percentage */
+	int i, printed = 0;
+	int width = browser->b.width;
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&browser->b, row);
 	off_t row_offset = entry->row_offset;
@@ -586,35 +621,50 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 	}
 
 	if (row_offset == 0) {
-		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
-		percent = (entry->period * 100.0) / browser->hists->stats.total_period;
+		struct hpp_context ctx = {
+			.s		= s,
+			.size		= sizeof(s),
+			.total_period	= browser->hists->stats.total_period,
+		};
 
-		ui_browser__set_percent_color(&browser->b, percent, current_entry);
 		ui_browser__gotorc(&browser->b, row, 0);
-		if (symbol_conf.use_callchain) {
-			slsmg_printf("%c ", folded_sign);
-			width -= 2;
-		}
 
-		slsmg_printf(" %5.2f%%", percent);
+		for (i = 0; i < PERF_HPP__MAX_INDEX; i++) {
+			if (!hpp_functions[i].cond)
+				continue;
 
-		/* The scroll bar isn't being used */
-		if (!browser->b.navkeypressed)
-			width += 1;
+			if (i) {
+				slsmg_printf("  ");
+				width -= 2;
+			}
 
-		if (!current_entry || !browser->b.navkeypressed)
-			ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
+			if (hpp_functions[i].color) {
+				ctx.ptr = &percent;
+				/* It will set percent for us. See HPP_COLOR_FN above. */
+				width -= hpp_functions[i].color(&ctx, entry);
 
-		if (symbol_conf.show_nr_samples) {
-			slsmg_printf(" %11u", entry->nr_events);
-			width -= 12;
-		}
+				ui_browser__set_percent_color(&browser->b, percent, current_entry);
+
+				if (i == 0 && symbol_conf.use_callchain) {
+					slsmg_printf("%c ", folded_sign);
+					width -= 2;
+				}
+
+				slsmg_printf("%s", s);
 
-		if (symbol_conf.show_total_period) {
-			slsmg_printf(" %12" PRIu64, entry->period);
-			width -= 13;
+				if (!current_entry || !browser->b.navkeypressed)
+					ui_browser__set_color(&browser->b, HE_COLORSET_NORMAL);
+			} else {
+				width -= hpp_functions[i].entry(&ctx, entry);
+				slsmg_printf("%s", s);
+			}
 		}
 
+		/* The scroll bar isn't being used */
+		if (!browser->b.navkeypressed)
+			width += 1;
+
+		hist_entry__sort_snprintf(entry, s, sizeof(s), browser->hists);
 		slsmg_write_nstring(s, width);
 		++row;
 		++printed;
diff --git a/tools/perf/ui/tui/setup.c b/tools/perf/ui/tui/setup.c
index 4c936e09931c..4dc0887c04f1 100644
--- a/tools/perf/ui/tui/setup.c
+++ b/tools/perf/ui/tui/setup.c
@@ -15,6 +15,8 @@ static volatile int ui__need_resize;
 
 extern struct perf_error_ops perf_tui_eops;
 
+extern void hist_browser__init_hpp(void);
+
 void ui__refresh_dimensions(bool force)
 {
 	if (force || ui__need_resize) {
@@ -124,6 +126,8 @@ int ui__init(void)
 	signal(SIGTERM, ui__signal);
 
 	perf_error__register(&perf_tui_eops);
+
+	hist_browser__init_hpp();
 out:
 	return err;
 }
-- 
1.7.11.2

