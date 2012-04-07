Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab2DGUzO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 16:55:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51993 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2DGUyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 16:54:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf annotate browser: Initial support for navigating jump instructions
Date: Sat,  7 Apr 2012 17:54:07 -0300
Message-Id: <1333832049-2399-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333832049-2399-1-git-send-email-acme@infradead.org>
References: <1333832049-2399-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Now it is possible to press ENTER or -> (right arrow) on jump
instructions to navigate to the offset it points to.

More work needed to support <- to go back, i.e. a jump history.

This is done just like the callq case, i.e. parsing objdump output
lines, but should move to use Masami's disassembler at some point.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-706qqe2xibeiocuabp39mby7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |   63 +++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index c52543c..752d8d0 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -168,6 +168,9 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 	while (self->b.top_idx != 0 && back != 0) {
 		pos = list_entry(pos->node.prev, struct objdump_line, node);
 
+		if (objdump_line__filter(&self->b, &pos->node))
+			continue;
+
 		--self->b.top_idx;
 		--back;
 	}
@@ -296,6 +299,61 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	return true;
 }
 
+static struct objdump_line *
+	annotate_browser__find_offset(struct annotate_browser *browser,
+				      s64 offset, s64 *idx)
+{
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
+	struct annotation *notes = symbol__annotation(sym);
+	struct objdump_line *pos;
+
+	*idx = 0;
+	list_for_each_entry(pos, &notes->src->source, node) {
+		if (pos->offset == offset)
+			return pos;
+		if (!objdump_line__filter(&browser->b, &pos->node))
+			++*idx;
+	}
+
+	return NULL;
+}
+
+static bool annotate_browser__jump(struct annotate_browser *browser)
+{
+	const char *jumps[] = { "je ", "jne ", "ja ", "jmpq ", "js ", "jmp ", NULL };
+	struct objdump_line *line;
+	s64 idx, offset;
+	char *s = NULL;
+	int i = 0;
+
+	while (jumps[i]) {
+		s = strstr(browser->selection->line, jumps[i++]);
+		if (s)
+			break;
+	}
+
+	if (s == NULL)
+		return false;
+
+	s = strchr(s, '+');
+	if (s++ == NULL) {
+		ui_helpline__puts("Invallid jump instruction.");
+		return true;
+	}
+
+	offset = strtoll(s, NULL, 16);
+	line = annotate_browser__find_offset(browser, offset, &idx);
+	if (line == NULL) {
+		ui_helpline__puts("Invallid jump offset");
+		return true;
+	}
+
+	annotate_browser__set_top(browser, line, idx);
+	
+	return true;
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
@@ -376,8 +434,9 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
 			else if (self->selection->offset == -1)
 				ui_helpline__puts("Actions are only available for assembly lines.");
-			else if (!annotate_browser__callq(self, evidx, timer, arg, delay_secs))
-				ui_helpline__puts("Actions are only available for the 'callq' instruction.");
+			else if (!(annotate_browser__jump(self) ||
+				   annotate_browser__callq(self, evidx, timer, arg, delay_secs)))
+				ui_helpline__puts("Actions are only available for the 'callq' and jump instructions.");
 			continue;
 		case K_LEFT:
 		case K_ESC:
-- 
1.7.9.2.358.g22243

