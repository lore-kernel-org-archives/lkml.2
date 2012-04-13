Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2DMSKz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:10:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2DMSKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:10:54 -0400
Date: Fri, 13 Apr 2012 11:10:01 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-706qqe2xibeiocuabp39mby7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Initial support for navigating jump instructions
Git-Commit-ID: 08be4eeda40ea813fa326036fdaf8fa7667eb021
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:10:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08be4eeda40ea813fa326036fdaf8fa7667eb021
Gitweb:     http://git.kernel.org/tip/08be4eeda40ea813fa326036fdaf8fa7667eb021
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 3 Apr 2012 21:35:35 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:14:23 -0300

perf annotate browser: Initial support for navigating jump instructions

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
 1 files changed, 61 insertions(+), 2 deletions(-)

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
