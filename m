Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab2EBTmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:42:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:57006 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab2EBTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 15:42:50 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/5] perf ui browser: Add method to draw up/down arrow line
Date: Wed,  2 May 2012 16:42:35 -0300
Message-Id: <1335987758-11039-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335987758-11039-1-git-send-email-acme@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

It figures out the direction and draws downwards arrows too if that is
the case.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tg329nr7q4dg9d0tl3o0wywg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browser.c |   54 +++++++++++++++++++++++++++++++++++++++++++++--
 tools/perf/ui/browser.h |    4 ++--
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index 32ac116..f4b2530 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -600,8 +600,9 @@ void ui_browser__write_graph(struct ui_browser *browser __used, int graph)
 	SLsmg_set_char_set(0);
 }
 
-void __ui_browser__line_arrow_up(struct ui_browser *browser, unsigned int column,
-				 u64 start, u64 end, int start_width)
+static void __ui_browser__line_arrow_up(struct ui_browser *browser,
+					unsigned int column,
+					u64 start, u64 end, int start_width)
 {
 	unsigned int row, end_row;
 
@@ -639,6 +640,55 @@ out:
 	SLsmg_set_char_set(0);
 }
 
+static void __ui_browser__line_arrow_down(struct ui_browser *browser,
+					  unsigned int column,
+					  u64 start, u64 end, int start_width)
+{
+	unsigned int row, end_row;
+
+	SLsmg_set_char_set(1);
+
+	if (start >= browser->top_idx) {
+		row = start - browser->top_idx;
+		ui_browser__gotorc(browser, row, column);
+		SLsmg_write_char(SLSMG_ULCORN_CHAR);
+		ui_browser__gotorc(browser, row, column + 1);
+		SLsmg_draw_hline(start_width);
+
+		if (row++ == 0)
+			goto out;
+	} else
+		row = 0;
+
+	if (end >= browser->top_idx + browser->height)
+		end_row = browser->height - 1;
+	else
+		end_row = end - browser->top_idx;;
+
+	ui_browser__gotorc(browser, row, column);
+	SLsmg_draw_vline(end_row - row + 1);
+
+	ui_browser__gotorc(browser, end_row, column);
+	if (end < browser->top_idx + browser->height) {
+		SLsmg_write_char(SLSMG_LLCORN_CHAR);
+		ui_browser__gotorc(browser, end_row, column + 1);
+		SLsmg_write_char(SLSMG_HLINE_CHAR);
+		ui_browser__gotorc(browser, end_row, column + 2);
+		SLsmg_write_char(SLSMG_RARROW_CHAR);
+	}
+out:
+	SLsmg_set_char_set(0);
+}
+
+void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
+			      u64 start, u64 end, int start_width)
+{
+	if (start > end)
+		__ui_browser__line_arrow_up(browser, column, start, end, start_width);
+	else
+		__ui_browser__line_arrow_down(browser, column, start, end, start_width);
+}
+
 void ui_browser__init(void)
 {
 	int i = 0;
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 2f226cb..059764b 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -38,8 +38,8 @@ void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
 void ui_browser__write_graph(struct ui_browser *browser, int graph);
-void __ui_browser__line_arrow_up(struct ui_browser *browser, unsigned int column,
-				 u64 start, u64 end, int start_width);
+void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
+			      u64 start, u64 end, int start_width);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
-- 
1.7.9.2.358.g22243

