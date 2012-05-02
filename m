Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab2EBVSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 17:18:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:58299 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab2EBVSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 17:18:02 -0400
Date: Wed, 2 May 2012 18:18:05 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [GIT PULL 0/5] perf/annotate fixes and improvements
Message-ID: <20120502211805.GH5745@infradead.org>
References: <1335987758-11039-1-git-send-email-acme@infradead.org>
 <1335988003.13683.182.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1335988003.13683.182.camel@twins>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Em Wed, May 02, 2012 at 09:46:43PM +0200, Peter Zijlstra escreveu:
> On Wed, 2012-05-02 at 16:42 -0300, Arnaldo Carvalho de Melo wrote:
> > . Changes:
> > 
> >         - Don't show the big vertical line. 
> 
> Not sure about that, loosing that separator makes it looks messy.

How about what we discussed on IRC:

avtab_search_node
       │      push   %rbp
       │      mov    %rsp,%rbp
       │    → callq  mcount
       │      movzwl 0x6(%rsi),%edx
       │      and    $0x7fff,%dx
       │      test   %rdi,%rdi
       │    ↓ jne    20
  0.64 │17:┌─→xor    %eax,%eax
       │19:│  leaveq
  0.51 │   │← retq
       │   │  nopl   0x0(%rax,%rax,1)
       │20:│  mov    (%rdi),%rax
       │   │  test   %rax,%rax
       │   └──je     17
       │      movzwl (%rsi),%ecx
       │      movzwl 0x2(%rsi),%r9d
       │      movzwl 0x4(%rsi),%r8d
       │      movzwl %cx,%esi
       │      movzwl %r9w,%r10d
       │      shl    $0x9,%esi
       │      lea    (%rsi,%r10,4),%esi
       │      lea    (%r8,%rsi,1),%esi
       │      and    0x10(%rdi),%si
       │      movzwl %si,%esi
       │      mov    (%rax,%rsi,8),%rax
  0.89 │      test   %rax,%rax
       │    ↑ je     19
       │      nopw   0x0(%rax,%rax,1)
  3.44 │60:   cmp    %cx,(%rax)
       │    ↓ jne    7e
       │      cmp    %r9w,0x2(%rax)
       │    ↓ jne    7e
       │      cmp    %r8w,0x4(%rax)
       │    ↓ jne    79
       │      test   %dx,0x6(%rax)
       │    ↑ jne    19
       │79:   cmp    %r8w,0x4(%rax)
 83.46 │7e: ↑ ja     17
  3.82 │      mov    0x10(%rax),%rax
  7.25 │      test   %rax,%rax
       │    ↑ jne    60
       │      leaveq
       │    ← retq

I.e. the fixed vertical line now has a diff color and the jump arrows are
_after_ the jump labels that then stands out as a separated columns.

In addition, as you suggested, the extra arrows on the ends of a jump->label
arrow gets swallowed by the jump->label arrow.

Also the fixed vertical line is drawn after we refresh the lines, i.e.,
it has a solid color, not influenced by each line percentages, as Linus
noticed previously.

Now a question: when I add multiple event column overheads, do you think we
should have N fixed vertical lines separating them?

I probably need to add an space before the instructions and the arrow
start/end, or not?

- Arnaldo

--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="annotate.patch"

diff --git a/tools/perf/ui/browser.c b/tools/perf/ui/browser.c
index f4b2530..562499c 100644
--- a/tools/perf/ui/browser.c
+++ b/tools/perf/ui/browser.c
@@ -602,7 +602,7 @@ void ui_browser__write_graph(struct ui_browser *browser __used, int graph)
 
 static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 					unsigned int column,
-					u64 start, u64 end, int start_width)
+					u64 start, u64 end)
 {
 	unsigned int row, end_row;
 
@@ -613,7 +613,7 @@ static void __ui_browser__line_arrow_up(struct ui_browser *browser,
 		ui_browser__gotorc(browser, row, column);
 		SLsmg_write_char(SLSMG_LLCORN_CHAR);
 		ui_browser__gotorc(browser, row, column + 1);
-		SLsmg_draw_hline(start_width);
+		SLsmg_draw_hline(2);
 
 		if (row-- == 0)
 			goto out;
@@ -642,7 +642,7 @@ out:
 
 static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 					  unsigned int column,
-					  u64 start, u64 end, int start_width)
+					  u64 start, u64 end)
 {
 	unsigned int row, end_row;
 
@@ -653,7 +653,7 @@ static void __ui_browser__line_arrow_down(struct ui_browser *browser,
 		ui_browser__gotorc(browser, row, column);
 		SLsmg_write_char(SLSMG_ULCORN_CHAR);
 		ui_browser__gotorc(browser, row, column + 1);
-		SLsmg_draw_hline(start_width);
+		SLsmg_draw_hline(2);
 
 		if (row++ == 0)
 			goto out;
@@ -681,12 +681,21 @@ out:
 }
 
 void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
-			      u64 start, u64 end, int start_width)
+			      u64 start, u64 end)
 {
 	if (start > end)
-		__ui_browser__line_arrow_up(browser, column, start, end, start_width);
+		__ui_browser__line_arrow_up(browser, column, start, end);
 	else
-		__ui_browser__line_arrow_down(browser, column, start, end, start_width);
+		__ui_browser__line_arrow_down(browser, column, start, end);
+}
+
+void __ui_browser__vline(struct ui_browser *browser, unsigned int column,
+			 u16 start, u16 end)
+{
+	SLsmg_set_char_set(1);
+	ui_browser__gotorc(browser, start, column);
+	SLsmg_draw_vline(end - start + 1);
+	SLsmg_set_char_set(0);
 }
 
 void ui_browser__init(void)
diff --git a/tools/perf/ui/browser.h b/tools/perf/ui/browser.h
index 059764b..133432d 100644
--- a/tools/perf/ui/browser.h
+++ b/tools/perf/ui/browser.h
@@ -39,7 +39,9 @@ void ui_browser__reset_index(struct ui_browser *self);
 void ui_browser__gotorc(struct ui_browser *self, int y, int x);
 void ui_browser__write_graph(struct ui_browser *browser, int graph);
 void __ui_browser__line_arrow(struct ui_browser *browser, unsigned int column,
-			      u64 start, u64 end, int start_width);
+			      u64 start, u64 end);
+void __ui_browser__vline(struct ui_browser *browser, unsigned int column,
+			 u16 start, u16 end);
 void __ui_browser__show_title(struct ui_browser *browser, const char *title);
 void ui_browser__show_title(struct ui_browser *browser, const char *title);
 int ui_browser__show(struct ui_browser *self, const char *title,
diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 44fb6a4..931db9f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -62,7 +62,8 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	bool change_color = (!ab->hide_src_code &&
 			     (!current_entry || (self->use_navkeypressed &&
 					         !self->navkeypressed)));
-	int width = self->width;
+	int width = self->width, printed;
+	char bf[256];
 
 	if (dl->offset != -1 && bdl->percent != 0.0) {
 		ui_browser__set_percent_color(self, bdl->percent, current_entry);
@@ -83,24 +84,26 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 
 	if (!*dl->line)
 		slsmg_write_nstring(" ", width - 7);
-	else if (dl->offset == -1)
-		slsmg_write_nstring(dl->line, width - 7);
-	else {
-		char bf[256];
+	else if (dl->offset == -1) {
+		printed = scnprintf(bf, sizeof(bf), "%*s ",
+				    ab->offset_width, " ");
+		slsmg_write_nstring(bf, printed);
+		slsmg_write_nstring(dl->line, width - printed - 5);
+	} else {
 		u64 addr = dl->offset;
-		int printed, color = -1;
+		int color = -1;
 
 		if (!ab->use_offset)
 			addr += ab->start;
 
 		if (!ab->use_offset) {
-			printed = scnprintf(bf, sizeof(bf), "  %" PRIx64 ":", addr);
+			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ": ", addr);
 		} else {
 			if (bdl->jump_target) {
-				printed = scnprintf(bf, sizeof(bf), "  %*" PRIx64 ":",
+				printed = scnprintf(bf, sizeof(bf), "%*" PRIx64 ": ",
 						    ab->offset_width, addr);
 			} else {
-				printed = scnprintf(bf, sizeof(bf), "  %*s ",
+				printed = scnprintf(bf, sizeof(bf), "%*s  ",
 						    ab->offset_width, " ");
 			}
 		}
@@ -137,7 +140,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			scnprintf(bf, sizeof(bf), "%-6.6s %s", dl->name, dl->ops.raw);
 		}
 
-		slsmg_write_nstring(bf, width - 9 - printed);
+		slsmg_write_nstring(bf, width - 10 - printed);
 	}
 
 	if (current_entry)
@@ -149,7 +152,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	struct disasm_line *cursor = ab->selection, *target;
 	struct browser_disasm_line *btarget, *bcursor;
-	unsigned int from, to, start_width = 2;
+	unsigned int from, to;
 
 	if (!cursor->ins || !ins__is_jump(cursor->ins) ||
 	    !disasm_line__has_offset(cursor))
@@ -171,11 +174,7 @@ static void annotate_browser__draw_current_jump(struct ui_browser *browser)
 	}
 
 	ui_browser__set_color(browser, HE_COLORSET_CODE);
-
-	if (!bcursor->jump_target)
-		start_width += ab->offset_width + 1;
-
-	__ui_browser__line_arrow(browser, 7, from, to, start_width);
+	__ui_browser__line_arrow(browser, 9 + ab->offset_width, from, to);
 }
 
 static unsigned int annotate_browser__refresh(struct ui_browser *browser)
@@ -186,6 +185,8 @@ static unsigned int annotate_browser__refresh(struct ui_browser *browser)
 	if (ab->jump_arrows)
 		annotate_browser__draw_current_jump(browser);
 
+	ui_browser__set_color(browser, HE_COLORSET_NORMAL);
+	__ui_browser__vline(browser, 7, 0, browser->height - 1);
 	return ret;
 }
 
@@ -618,6 +619,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'O':
 		case 'o':
 			self->use_offset = !self->use_offset;
+			if (self->use_offset)
+				self->offset_width = hex_width(symbol__size(sym));
+			else
+				self->offset_width = hex_width(sym->end);
 			continue;
 		case 'j':
 			self->jump_arrows = !self->jump_arrows;

--8t9RHnE3ZwKMSgU+--
