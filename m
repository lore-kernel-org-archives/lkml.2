Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903Ab2EBTmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 15:42:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49667 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab2EBTmu (ORCPT
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
Subject: [PATCH 3/5] perf annotate browser: Show current jump, back or forward
Date: Wed,  2 May 2012 16:42:36 -0300
Message-Id: <1335987758-11039-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335987758-11039-1-git-send-email-acme@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of trying to show the current loop by naively looking for the
next backward jump, just use 'j' to toggle showing arrows connecting
jump with its target.

And do it for forward jumps as well.

Loop detection requires more code to follow the flow control, etc.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-soahcn1lz2u4wxj31ch0594j@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   50 +++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 27 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4778172..d203daf 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -30,6 +30,7 @@ struct annotate_browser {
 	int		    nr_entries;
 	bool		    hide_src_code;
 	bool		    use_offset;
+	bool		    jump_arrows;
 	bool		    searching_backwards;
 	u8		    offset_width;
 	char		    search_bf[128];
@@ -144,56 +145,47 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		ab->selection = dl;
 }
 
-static void annotate_browser__draw_current_loop(struct ui_browser *browser)
+static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 {
 	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
-	struct map_symbol *ms = browser->priv;
-	struct symbol *sym = ms->sym;
-	struct annotation *notes = symbol__annotation(sym);
-	struct disasm_line *cursor = ab->selection, *pos = cursor, *target;
-	struct browser_disasm_line *bcursor = disasm_line__browser(cursor),
-				   *btarget, *bpos;
+	struct disasm_line *cursor = ab->selection, *target;
+	struct browser_disasm_line *btarget, *bcursor;
 	unsigned int from, to, start_width = 2;
 
-	list_for_each_entry_from(pos, &notes->src->source, node) {
-		if (!pos->ins || !ins__is_jump(pos->ins) ||
-		    !disasm_line__has_offset(pos))
-			continue;
-
-		target = ab->offsets[pos->ops.target.offset];
-		if (!target)
-			continue;
+	if (!cursor->ins || !ins__is_jump(cursor->ins) ||
+	    !disasm_line__has_offset(cursor))
+		return;
 
-		btarget = disasm_line__browser(target);
-		if (btarget->idx <= bcursor->idx)
-			goto found;
-	}
+	target = ab->offsets[cursor->ops.target.offset];
+	if (!target)
+		return;
 
-	return;
+	bcursor = disasm_line__browser(cursor);
+	btarget = disasm_line__browser(target);
 
-found:
-	bpos = disasm_line__browser(pos);
 	if (ab->hide_src_code) {
-		from = bpos->idx_asm;
+		from = bcursor->idx_asm;
 		to = btarget->idx_asm;
 	} else {
-		from = (u64)bpos->idx;
+		from = (u64)bcursor->idx;
 		to = (u64)btarget->idx;
 	}
 
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
 
-	if (!bpos->jump_target)
+	if (!bcursor->jump_target)
 		start_width += ab->offset_width + 1;
 
-	__ui_browser__line_arrow_up(browser, 10, from, to, start_width);
+	__ui_browser__line_arrow(browser, 10, from, to, start_width);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 {
+	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	int ret = ui_browser__list_head_refresh(browser);
 
-	annotate_browser__draw_current_loop(browser);
+	if (ab->jump_arrows)
+		annotate_browser__draw_current_jump(browser);
 
 	return ret;
 }
@@ -628,6 +620,9 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'o':
 			self->use_offset = !self->use_offset;
 			continue;
+		case 'j':
+			self->jump_arrows = !self->jump_arrows;
+			continue;
 		case '/':
 			if (annotate_browser__search(self, delay_secs)) {
 show_help:
@@ -739,6 +734,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.use_navkeypressed = true,
 		},
 		.use_offset = true,
+		.jump_arrows = true,
 	};
 	int ret = -1;
 
-- 
1.7.9.2.358.g22243

