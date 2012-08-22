Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031Ab2HVFzk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:55:40 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:52603 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab2HVFz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:55:29 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-32-5034744d7941
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 4/5] perf ui/browser: Use perf_hpp__format functions
Date: Wed, 22 Aug 2012 14:48:36 +0900
Message-Id: <1345614517-5753-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
References: <1345614517-5753-1-git-send-email-namhyung@kernel.org>
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
index 81bd8c2af730..144d7be2872e 100644
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
 
+#define HPP__COLOR_FN(_name, _field)					\
+static int hist_browser__hpp_color_ ## _name(struct perf_hpp *hpp,	\
+					     struct hist_entry *he)	\
+{									\
+	double percent = 100.0 * he->_field / hpp->total_period;	\
+	*(double *)hpp->ptr = percent;					\
+	return scnprintf(hpp->buf, hpp->size, "%5.2f%%", percent);	\
+}
+
+HPP__COLOR_FN(overhead, period)
+HPP__COLOR_FN(overhead_sys, period_sys)
+HPP__COLOR_FN(overhead_us, period_us)
+HPP__COLOR_FN(overhead_guest_sys, period_guest_sys)
+HPP__COLOR_FN(overhead_guest_us, period_guest_us)
+
+#undef HPP__COLOR_FN
+
+void hist_browser__init_hpp(void)
+{
+	perf_hpp__init(false, false);
+
+	perf_hpp__format[PERF_HPP__OVERHEAD].color =
+				hist_browser__hpp_color_overhead;
+	perf_hpp__format[PERF_HPP__OVERHEAD_SYS].color =
+				hist_browser__hpp_color_overhead_sys;
+	perf_hpp__format[PERF_HPP__OVERHEAD_US].color =
+				hist_browser__hpp_color_overhead_us;
+	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_SYS].color =
+				hist_browser__hpp_color_overhead_guest_sys;
+	perf_hpp__format[PERF_HPP__OVERHEAD_GUEST_US].color =
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
+		struct perf_hpp hpp = {
+			.buf		= s,
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
+			if (!perf_hpp__format[i].cond)
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
+			if (perf_hpp__format[i].color) {
+				hpp.ptr = &percent;
+				/* It will set percent for us. See HPP__COLOR_FN above. */
+				width -= perf_hpp__format[i].color(&hpp, entry);
 
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
+				width -= perf_hpp__format[i].entry(&hpp, entry);
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
1.7.11.4

