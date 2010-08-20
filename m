Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab0HTMk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 08:40:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:40156 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751504Ab0HTMk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 08:40:26 -0400
Date: Fri, 20 Aug 2010 12:39:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf ui browser: Abstract some more slang operations
Message-ID: <tip-8f9bbc408b6f704e84d0ae78e6093005ad58d4fe@git.kernel.org>
Git-Commit-ID: 8f9bbc408b6f704e84d0ae78e6093005ad58d4fe
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 20 Aug 2010 12:39:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f9bbc408b6f704e84d0ae78e6093005ad58d4fe
Gitweb:     http://git.kernel.org/tip/8f9bbc408b6f704e84d0ae78e6093005ad58d4fe
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 11 Aug 2010 14:51:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Aug 2010 19:33:16 -0300

perf ui browser: Abstract some more slang operations

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
 tools/perf/util/ui/browser.c           |   47 ++++++++++++++++---------------
 tools/perf/util/ui/browser.h           |    5 +++-
 tools/perf/util/ui/browsers/annotate.c |    8 ++---
 tools/perf/util/ui/browsers/hists.c    |   12 ++++----
 tools/perf/util/ui/browsers/map.c      |    3 +-
 5 files changed, 38 insertions(+), 37 deletions(-)

diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 66f2d58..d237410 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -1,16 +1,6 @@
-#define _GNU_SOURCE
-#include <stdio.h>
-#undef _GNU_SOURCE
-/*
- * slang versions <= 2.0.6 have a "#if HAVE_LONG_LONG" that breaks
- * the build if it isn't defined. Use the equivalent one that glibc
- * has on features.h.
- */
-#include <features.h>
-#ifndef HAVE_LONG_LONG
-#define HAVE_LONG_LONG __GLIBC_HAVE_LONG_LONG
-#endif
 #include <slang.h>
+#include "libslang.h"
+#include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
 #include <stdlib.h>
@@ -19,17 +9,11 @@
 #include "helpline.h"
 #include "../color.h"
 #include "../util.h"
-
-#if SLANG_VERSION < 20104
-#define sltt_set_color(obj, name, fg, bg) \
-	SLtt_set_color(obj,(char *)name, (char *)fg, (char *)bg)
-#else
-#define sltt_set_color SLtt_set_color
-#endif
+#include <stdio.h>
 
 newtComponent newt_form__new(void);
 
-int ui_browser__percent_color(double percent, bool current)
+static int ui_browser__percent_color(double percent, bool current)
 {
 	if (current)
 		return HE_COLORSET_SELECTED;
@@ -40,6 +24,23 @@ int ui_browser__percent_color(double percent, bool current)
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
@@ -111,7 +112,7 @@ unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self)
 	nd = self->top;
 
 	while (nd != NULL) {
-		SLsmg_gotorc(self->y + row, self->x);
+		ui_browser__gotorc(self, row, 0);
 		self->write(self, nd, row);
 		if (++row == self->height)
 			break;
@@ -196,7 +197,7 @@ int ui_browser__refresh(struct ui_browser *self)
 
 	newtScrollbarSet(self->sb, self->index, self->nr_entries - 1);
 	row = self->refresh(self);
-	SLsmg_set_color(HE_COLORSET_NORMAL);
+	ui_browser__set_color(self, HE_COLORSET_NORMAL);
 	SLsmg_fill_region(self->y + row, self->x,
 			  self->height - row, self->width, ' ');
 
@@ -294,7 +295,7 @@ unsigned int ui_browser__list_head_refresh(struct ui_browser *self)
 	pos = self->top;
 
 	list_for_each_from(pos, head) {
-		SLsmg_gotorc(self->y + row, self->x);
+		ui_browser__gotorc(self, row, 0);
 		self->write(self, pos, row);
 		if (++row == self->height)
 			break;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 0b9f829..27c23c2 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -25,11 +25,14 @@ struct ui_browser {
 };
 
 
-int ui_browser__percent_color(double percent, bool current);
+void ui_browser__set_color(struct ui_browser *self, int color);
+void ui_browser__set_percent_color(struct ui_browser *self,
+				   double percent, bool current);
 bool ui_browser__is_current_entry(struct ui_browser *self, unsigned row);
 void ui_browser__refresh_dimensions(struct ui_browser *self);
 void ui_browser__reset_index(struct ui_browser *self);
 
+void ui_browser__gotorc(struct ui_browser *self, int y, int x);
 int ui_browser__show(struct ui_browser *self, const char *title,
 		     const char *helpline, ...);
 void ui_browser__hide(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index a90273e..a00d529 100644
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
index dafdf67..5723091 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -341,8 +341,8 @@ static int hist_browser__show_callchain_node_rb_tree(struct hist_browser *self,
 				*is_current_entry = true;
 			}
 
-			SLsmg_set_color(color);
-			SLsmg_gotorc(self->b.y + row, self->b.x);
+			ui_browser__set_color(&self->b, color);
+			ui_browser__gotorc(&self->b, row, 0);
 			slsmg_write_nstring(" ", offset + extra_offset);
 			slsmg_printf("%c ", folded_sign);
 			slsmg_write_nstring(str, width);
@@ -405,8 +405,8 @@ static int hist_browser__show_callchain_node(struct hist_browser *self,
 		}
 
 		s = callchain_list__sym_name(chain, ipstr, sizeof(ipstr));
-		SLsmg_gotorc(self->b.y + row, self->b.x);
-		SLsmg_set_color(color);
+		ui_browser__gotorc(&self->b, row, 0);
+		ui_browser__set_color(&self->b, color);
 		slsmg_write_nstring(" ", offset);
 		slsmg_printf("%c ", folded_sign);
 		slsmg_write_nstring(s, width - 2);
@@ -484,8 +484,8 @@ static int hist_browser__show_entry(struct hist_browser *self,
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
index 142b825..733daba 100644
--- a/tools/perf/util/ui/browsers/map.c
+++ b/tools/perf/util/ui/browsers/map.c
@@ -56,9 +56,8 @@ static void map_browser__write(struct ui_browser *self, void *nd, int row)
 	struct symbol *sym = rb_entry(nd, struct symbol, rb_node);
 	struct map_browser *mb = container_of(self, struct map_browser, b);
 	bool current_entry = ui_browser__is_current_entry(self, row);
-	int color = ui_browser__percent_color(0, current_entry);
 
-	SLsmg_set_color(color);
+	ui_browser__set_percent_color(self, 0, current_entry);
 	slsmg_printf("%*llx %*llx %c ",
 		     mb->addrlen, sym->start, mb->addrlen, sym->end,
 		     sym->binding == STB_GLOBAL ? 'g' :
