Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2III5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:57:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46499 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2III5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:57:45 -0400
Date: Sun, 9 Sep 2012 01:57:26 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-f5951d56a2ab4181b96806a4746895aaa5a3d72e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1346640790-17197-5-git-send-email-namhyung@kernel.org>
References: <1346640790-17197-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser: Use perf_hpp__format functions
Git-Commit-ID: f5951d56a2ab4181b96806a4746895aaa5a3d72e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 01:57:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5951d56a2ab4181b96806a4746895aaa5a3d72e
Gitweb:     http://git.kernel.org/tip/f5951d56a2ab4181b96806a4746895aaa5a3d72e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Mon, 3 Sep 2012 11:53:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 13:20:13 -0300

perf hists browser: Use perf_hpp__format functions

Override hpp->color functions for TUI. Because line coloring is done
outside of the function, it just sets the percent value and pass it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1346640790-17197-5-git-send-email-namhyung@kernel.org
[ committer note: Keep previous layout by showing the overhead at column 1 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c |   96 ++++++++++++++++++++++++++++++----------
 tools/perf/ui/tui/setup.c      |    4 ++
 2 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 81bd8c2..5a5739b 100644
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
+	int width = browser->b.width - 1;
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
-		ui_browser__gotorc(&browser->b, row, 0);
-		if (symbol_conf.use_callchain) {
-			slsmg_printf("%c ", folded_sign);
-			width -= 2;
-		}
+		ui_browser__gotorc(&browser->b, row, 1);
 
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
index 4c936e0..4dc0887 100644
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
