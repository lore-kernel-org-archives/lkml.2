Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761238Ab2D0TRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:17:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:47673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2D0TRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:17:09 -0400
Date: Fri, 27 Apr 2012 16:17:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/4] perf/annotate loop detection V2, fixes
Message-ID: <20120427191708.GJ27997@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
 <CA+55aFy7QLXRWQSjUiYNhX5B9p-0AJ4LSWc=km8hJ55ku=ho0A@mail.gmail.com>
 <20120427164643.GG27997@infradead.org>
 <CA+55aFyZ+pMRn_Na_o5A3yWeUbXj2J_FVS8jbHgdD-UfPbOD5g@mail.gmail.com>
 <20120427180351.GH27997@infradead.org>
 <CA+55aFy2Erkros7qHpNBgbsGyP4azswTzWTFjSb2K4+KcFve2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy2Erkros7qHpNBgbsGyP4azswTzWTFjSb2K4+KcFve2A@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Apr 27, 2012 at 11:23:24AM -0700, Linus Torvalds escreveu:
> On Fri, Apr 27, 2012 at 11:03 AM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> >
> >> It seems to think that a backwards jump implies a loop. But that's not
> >> at all true.
> >
> > Yeah, the jump has to be conditional.
> 
> Not at all.
> 
> Unconditional backwards jumps can easily be parts of loops. It's a
> very valid loop that does basically
> 
>    for (;;) {
>    }
> 
> with a few exit cases in the *middle* of the loop. Sometimes that is
> the right way to write things, and sometimes gcc rewrites things that
> way for other reasons.
> 
> And conditional backwards jumps are *not* automatically loops either. Doing a
> 
>    if (error)
>       return error;
> 
> is perfectly normal - and that "return error" may well be a backwards
> jump to the "return" code that was generated earlier.
> 
> Seriously: backwards jumps are not loops. Not unconditional ones, not
> conditional ones.
> 
> The only way to find a loop is to follow the flow control and notice
> that it closes a loop.

Ok, reading it now it all seems so obvious, stoopid me, thanks for the
explanation.
 
> > I should have reworded the "loop detection" with "basic jump arrows" in
> > the first place.
> 
> .. and that is fine. But then you need to do it for *forwards* jumps
> too. There is no difference between backwards and forwards jumps
> *unless* you are looking for loops, and if you are looking for loops
> you need to actually find the cycle.

Ok, so I changed things to not try to detect loops at all, for now, and
instead just start with 'show jumps' on, hotkey 'j', that will draw
arrows from jumps to its targets, backwards or forwards, when the cursor
is on a jump instruction, take a look:

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
 
