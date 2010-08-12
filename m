Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab0HLUpZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 16:45:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760576Ab0HLUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 16:45:24 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/3] perf ui browser: Abstract some more slang operations
Date: Thu, 12 Aug 2010 17:45:13 -0300
Message-Id: <1281645913-25403-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1281645913-25403-1-git-send-email-acme@infradead.org>
References: <1281645913-25403-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Browsers don't have to deal with absolute coordinates, just using (row,
column) and leaving the rest to ui_browser is better and removes one
more UI backend detail from the browsers.

Also shorten the percent_color setting idiom, removing some more direct
libslang calls.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browser.c           |   26 ++++++++++++++++++++++----
 tools/perf/util/ui/browser.h           |    5 ++++-
 tools/perf/util/ui/browsers/annotate.c |    8 +++-----
 tools/perf/util/ui/browsers/hists.c    |   12 ++++++------
 tools/perf/util/ui/browsers/map.c      |    3 +--
 5 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 11996d3..54dcba7 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,5 +1,6 @@
 #include <features.h>
 #include "libslang.h"
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <stdlib.h>
@@ -10,7 +11,7 @@
 #include "../util.h"
 #include <stdio.h>
 
-int ui_browser__percent_color(double percent, bool current)
+static int ui_browser__percent_color(double percent, bool current)
 {
 	if (current)
 		return HE_COLORSET_SELECTED;
@@ -21,6 +22,23 @@ int ui_browser__percent_color(double percent, bool current)
 	return HE_COLORSET_NORMAL;
 }
 
+void ui_browser__set_color(struct ui_browser *self __used, int color)
+{
+	SLsmg_set_color(color);
+}
+
+void ui_browser__set_percent_color(struct ui_browser *self,
+				   double percent, bool current)
+{
+	 int color = ui_browser__percent_color(percent, current);
+	 ui_browser__set_color(self, color);
+}
+
+void ui_browser__gotorc(struct ui_browser *self, int y, int x)
+{
+	SLsmg_gotorc(self->y + y, self->x + x);
+}
+
 void ui_browser__list_head_seek(struct ui_browser *self, off_t offset, int whence)
 {
 	struct list_head *head = self->entries;
@@ -92,7 +110,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
 	nd = self->top;
 
 	while (nd != NULL) {
-		SLsmg_gotorc(self->y + row, self->x);
+		ui_browser__gotorc(self, row, 0);
 		self->write(self, nd, row);
 		if (++row == self->height)
 			break;
@@ -189,7 +207,7 @@ int ui_browser__refresh(struct ui_browser *self)
 
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
 	row = self->refresh(self);
-	SLsmg_set_color(HE_COLORSET_NORMAL);
+	ui_browser__set_color(self, HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->y + row, self->x,
 			  self->height - row, self->width, ' ');
 
@@ -287,7 +305,7 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	pos = self->top;
 
 	list_for_each_from(pos, head) {
-		SLsmg_gotorc(self->y + row, self->x);
+		ui_browser__gotorc(self, row, 0);
 		self->write(self, pos, row);
 		if (++row == self->height)
 			break;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 8aba699..0639195 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -25,13 +25,16 @@ struct ui_browser {
 };
 
 
-int ui_browser__percent_color(double percent, bool current);
+void ui_browser__set_color(struct ui_browser *self, int color);
+void ui_browser__set_percent_color(struct ui_browser *self,
+				   double percent, bool current);
 bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
 void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
 void ui_browser__add_exit_key(struct ui_browser *self, int key);
 void ui_browser__add_exit_keys(struct ui_browser *self, int keys[]);
+void ui_browser__gotorc(struct ui_browser *self, int y, int x);
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 64023fa..82b78f9 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -40,14 +40,12 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	if (ol->offset != -1) {
 		struct objdump_line_rb_node *olrb = objdump_line__rb(ol);
-		int color = ui_browser__percent_color(olrb->percent, current_entry);
-		SLsmg_set_color(color);
+		ui_browser__set_percent_color(self, olrb->percent, current_entry);
 		slsmg_printf(" %7.2f ", olrb->percent);
 		if (!current_entry)
-			SLsmg_set_color(HE_COLORSET_CODE);
+			ui_browser__set_color(self, HE_COLORSET_CODE);
 	} else {
-		int color = ui_browser__percent_color(0, current_entry);
-		SLsmg_set_color(color);
+		ui_browser__set_percent_color(self, 0, current_entry);
 		slsmg_write_nstring(" ", 9);
 	}
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index cc4c7c7..b13b978 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -332,8 +332,8 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 				*is_current_entry = true;
 			}
 
-			SLsmg_set_color(color);
-			SLsmg_gotorc(self->b.y + row, self->b.x);
+			ui_browser__set_color(&self->b, color);
+			ui_browser__gotorc(&self->b, row, 0);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
@@ -396,8 +396,8 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 		}
 
 		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		SLsmg_gotorc(self->b.y + row, self->b.x);
-		SLsmg_set_color(color);
+		ui_browser__gotorc(&self->b, row, 0);
+		ui_browser__set_color(&self->b, color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
 		slsmg_write_nstring(s, width - 2);
@@ -475,8 +475,8 @@ static int hist_browser__show_entry(struct hist_browser *self,
 				color = HE_COLORSET_NORMAL;
 		}
 
-		SLsmg_set_color(color);
-		SLsmg_gotorc(self->b.y + row, self->b.x);
+		ui_browser__set_color(&self->b, color);
+		ui_browser__gotorc(&self->b, row, 0);
 		if (symbol_conf.use_callchain) {
 			slsmg_printf("%c ", folded_sign);
 			width -= 2;
diff --git a/tools/perf/util/ui/browsers/map.c b/tools/perf/util/ui/browsers/map.c
index 327ca6c..1bf0979 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -55,9 +55,8 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
 	struct map_browser *mb = container_of(self, struct map_browser, b);
 	bool current_entry = ui_browser__is_current_entry(self, row);
-	int color = ui_browser__percent_color(0, current_entry);
 
-	SLsmg_set_color(color);
+	ui_browser__set_percent_color(self, 0, current_entry);
 	slsmg_printf("%*llx %*llx %c ",
 		     mb->addrlen, sym->start, mb->addrlen, sym->end,
 		     sym->binding == STB_GLOBAL ? 'g' :
-- 
1.6.2.5

