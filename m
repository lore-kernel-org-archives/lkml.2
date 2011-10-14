Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1JNS2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 14:28:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55610 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1JNS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 14:28:02 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf annotate browser: Allow toggling the visualization of source code lines
Date: Fri, 14 Oct 2011 15:27:52 -0300
Message-Id: <1318616873-26739-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1318616873-26739-1-git-send-email-acme@infradead.org>
References: <1318616873-26739-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just press 'S' on any assembly line and the source code will be hidden
while the current line remains selected. Press 'S' again to show them
back.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-efmxm5etouebb7es0kkyqqwa@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   76 +++++++++++++++++++++++++++++--
 1 files changed, 71 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 84315c9..eb2712e 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -21,12 +21,16 @@ struct annotate_browser {
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
 	struct objdump_line *selection;
+	int		    nr_asm_entries;
+	int		    nr_entries;
+	bool		    hide_src_code;
 };
 
 struct objdump_line_rb_node {
 	struct rb_node	rb_node;
 	double		percent;
 	u32		idx;
+	int		idx_asm;
 };
 
 static inline
@@ -35,10 +39,22 @@ struct objdump_line_rb_node *objdump_line__rb(struct objdump_line *self)
 	return (struct objdump_line_rb_node *)(self + 1);
 }
 
+static bool objdump_line__filter(struct ui_browser *browser, void *entry)
+{
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
+
+	if (ab->hide_src_code) {
+		struct objdump_line *ol = list_entry(entry, struct objdump_line, node);
+		return ol->offset == -1;
+	}
+
+	return false;
+}
+
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
 	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
-	struct objdump_line *ol = rb_entry(entry, struct objdump_line, node);
+	struct objdump_line *ol = list_entry(entry, struct objdump_line, node);
 	bool current_entry = ui_browser__is_current_entry(self, row);
 	int width = self->width;
 
@@ -168,6 +184,45 @@ static void annotate_browser__calc_percent(struct annotate_browser *browser,
 	browser->curr_hot = rb_last(&browser->entries);
 }
 
+static bool annotate_browser__toggle_source(struct annotate_browser *browser)
+{
+	struct objdump_line *ol;
+	struct objdump_line_rb_node *olrb;
+	off_t offset = browser->b.index - browser->b.top_idx;
+
+	browser->b.seek(&browser->b, offset, SEEK_CUR);
+	ol = list_entry(browser->b.top, struct objdump_line, node);
+	olrb = objdump_line__rb(ol);
+
+	if (browser->hide_src_code) {
+		if (olrb->idx_asm < offset)
+			offset = olrb->idx;
+
+		browser->b.nr_entries = browser->nr_entries;
+		browser->hide_src_code = false;
+		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		browser->b.top_idx = olrb->idx - offset;
+		browser->b.index = olrb->idx;
+	} else {
+		if (olrb->idx_asm < 0) {
+			ui_helpline__puts("Only available for assembly lines.");
+			browser->b.seek(&browser->b, -offset, SEEK_CUR);
+			return false;
+		}
+
+		if (olrb->idx_asm < offset)
+			offset = olrb->idx_asm;
+
+		browser->b.nr_entries = browser->nr_asm_entries;
+		browser->hide_src_code = true;
+		browser->b.seek(&browser->b, -offset, SEEK_CUR);
+		browser->b.top_idx = olrb->idx_asm - offset;
+		browser->b.index = olrb->idx_asm;
+	}
+
+	return true;
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				 int nr_events, void(*timer)(void *arg),
 				 void *arg, int delay_secs)
@@ -175,11 +230,12 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 	struct rb_node *nd = NULL;
 	struct map_symbol *ms = self->b.priv;
 	struct symbol *sym = ms->sym;
+	const char *help = "<-, ESC: exit, TAB/shift+TAB: cycle hottest lines, "
+			   "H: Hottest, -> Line action, S -> Toggle source "
+			   "code view";
 	int key;
 
-	if (ui_browser__show(&self->b, sym->name,
-			     "<- or ESC: exit, TAB/shift+TAB: "
-			     "cycle hottest lines, H: Hottest, -> Line action") < 0)
+	if (ui_browser__show(&self->b, sym->name, help) < 0)
 		return -1;
 
 	annotate_browser__calc_percent(self, evidx);
@@ -234,6 +290,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'H':
 			nd = self->curr_hot;
 			break;
+		case 'S':
+			if (annotate_browser__toggle_source(self))
+				ui_helpline__puts(help);
+			continue;
 		case NEWT_KEY_ENTER:
 		case NEWT_KEY_RIGHT:
 			if (self->selection == NULL) {
@@ -324,6 +384,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.refresh = ui_browser__list_head_refresh,
 			.seek	 = ui_browser__list_head_seek,
 			.write	 = annotate_browser__write,
+			.filter  = objdump_line__filter,
 			.priv	 = &ms,
 		},
 	};
@@ -351,9 +412,14 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		if (browser.b.width < line_len)
 			browser.b.width = line_len;
 		rbpos = objdump_line__rb(pos);
-		rbpos->idx = browser.b.nr_entries++;
+		rbpos->idx = browser.nr_entries++;
+		if (pos->offset != -1)
+			rbpos->idx_asm = browser.nr_asm_entries++;
+		else
+			rbpos->idx_asm = -1;
 	}
 
+	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
 	ret = annotate_browser__run(&browser, evidx, nr_events,
-- 
1.6.2.5

