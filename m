Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab1JRVpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 17:45:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43286 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab1JRVoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 17:44:18 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/7] perf ui browser: Allow initial use without navigation UI elements
Date: Tue, 18 Oct 2011 19:44:03 -0200
Message-Id: <1318974247-6683-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318974247-6683-1-git-send-email-acme@infradead.org>
References: <1318974247-6683-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The selection and scroll bar are really needed only when the user starts
navigating, before that it just provide distractions.

This also brings the initial screen to look more like the stdio UI,
which more people are used to.

The new code is flexible enough that menu like browsers can opt out and
start with those UI elements.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jfgok30kkerpfw8wtcltgy6z@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |   28 +++++++++++++++++++++++-----
 tools/perf/util/ui/browser.h           |    2 ++
 tools/perf/util/ui/browsers/annotate.c |    6 ++++++
 tools/perf/util/ui/browsers/hists.c    |   20 ++++++++------------
 4 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index a54b926..dce16ee 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -14,9 +14,10 @@
 
 int newtGetKey(void);
 
-static int ui_browser__percent_color(double percent, bool current)
+static int ui_browser__percent_color(struct ui_browser *browser,
+				     double percent, bool current)
 {
-	if (current)
+	if (current && (!browser->use_navkeypressed || browser->navkeypressed))
 		return HE_COLORSET_SELECTED;
 	if (percent >= MIN_RED)
 		return HE_COLORSET_TOP;
@@ -33,7 +34,7 @@ void ui_browser__set_color(struct ui_browser *self __used, int color)
 void ui_browser__set_percent_color(struct ui_browser *self,
 				   double percent, bool current)
 {
-	 int color = ui_browser__percent_color(percent, current);
+	 int color = ui_browser__percent_color(self, percent, current);
 	 ui_browser__set_color(self, color);
 }
 
@@ -241,12 +242,18 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 static int __ui_browser__refresh(struct ui_browser *browser)
 {
 	int row;
+	int width = browser->width;
 
 	row = browser->refresh(browser);
 	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
+
+	if (!browser->use_navkeypressed || browser->navkeypressed)
+		ui_browser__scrollbar_set(browser);
+	else
+		width += 1;
+
 	SLsmg_fill_region(browser->y + row, browser->x,
-			  browser->height - row, browser->width, ' ');
-	ui_browser__scrollbar_set(browser);
+			  browser->height - row, width, ' ');
 
 	return 0;
 }
@@ -326,6 +333,17 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 			continue;
 		}
 
+		if (self->use_navkeypressed && !self->navkeypressed) {
+			if (key == NEWT_KEY_DOWN || key == NEWT_KEY_UP ||
+			    key == NEWT_KEY_PGDN || key == NEWT_KEY_PGUP ||
+			    key == NEWT_KEY_HOME || key == NEWT_KEY_END ||
+			    key == ' ') {
+				self->navkeypressed = true;
+				continue;
+			} else
+				return key;
+		}
+
 		switch (key) {
 		case NEWT_KEY_DOWN:
 			if (self->index == self->nr_entries - 1)
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 351c006..a2c707d 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -23,6 +23,8 @@ struct ui_browser {
 	void	      (*seek)(struct ui_browser *self, off_t offset, int whence);
 	bool	      (*filter)(struct ui_browser *self, void *entry);
 	u32	      nr_entries;
+	bool	      navkeypressed;
+	bool	      use_navkeypressed;
 };
 
 void ui_browser__set_color(struct ui_browser *self, int color);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index eb2712e..a2c351c 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -69,6 +69,11 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	SLsmg_write_char(':');
 	slsmg_write_nstring(" ", 8);
+
+	/* The scroll bar isn't being used */
+	if (!self->navkeypressed)
+		width += 1;
+
 	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
 	else
@@ -386,6 +391,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.write	 = annotate_browser__write,
 			.filter  = objdump_line__filter,
 			.priv	 = &ms,
+			.use_navkeypressed = true,
 		},
 	};
 	int ret;
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 873b852..2d390b9 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -547,7 +547,7 @@ static int hist_browser__show_entry(struct hist_browser *self,
 	char s[256];
 	double percent;
 	int printed = 0;
-	int color, width = self->b.width;
+	int width = self->b.width;
 	char folded_sign = ' ';
 	bool current_entry = ui_browser__is_current_entry(&self->b, row);
 	off_t row_offset = entry->row_offset;
@@ -567,22 +567,17 @@ static int hist_browser__show_entry(struct hist_browser *self,
 				     0, false, self->hists->stats.total_period);
 		percent = (entry->period * 100.0) / self->hists->stats.total_period;
 
-		color = HE_COLORSET_SELECTED;
-		if (!current_entry) {
-			if (percent >= MIN_RED)
-				color = HE_COLORSET_TOP;
-			else if (percent >= MIN_GREEN)
-				color = HE_COLORSET_MEDIUM;
-			else
-				color = HE_COLORSET_NORMAL;
-		}
-
-		ui_browser__set_color(&self->b, color);
+		ui_browser__set_percent_color(&self->b, percent, current_entry);
 		ui_browser__gotorc(&self->b, row, 0);
 		if (symbol_conf.use_callchain) {
 			slsmg_printf("%c ", folded_sign);
 			width -= 2;
 		}
+
+		/* The scroll bar isn't being used */
+		if (!self->b.navkeypressed)
+			width += 1;
+
 		slsmg_write_nstring(s, width);
 		++row;
 		++printed;
@@ -787,6 +782,7 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		self->hists = hists;
 		self->b.refresh = hist_browser__refresh;
 		self->b.seek = ui_browser__hists_seek;
+		self->b.use_navkeypressed = true,
 		self->has_symbols = sort_sym.list.next != NULL;
 	}
 
-- 
1.6.2.5

