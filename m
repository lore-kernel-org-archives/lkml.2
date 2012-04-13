Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2DMSMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:12:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51572 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2DMSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:12:23 -0400
Date: Fri, 13 Apr 2012 11:11:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-rv30xj2i258n0gwkzlu0c0bc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: string search: /?n
Git-Commit-ID: d3d1f61acf62204bb7b2b4509329247bffaedd7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:11:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d3d1f61acf62204bb7b2b4509329247bffaedd7c
Gitweb:     http://git.kernel.org/tip/d3d1f61acf62204bb7b2b4509329247bffaedd7c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 7 Apr 2012 17:10:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 17:37:22 -0300

perf annotate browser: string search: /?n

Using the same keystrokes as vim:

/ = search forward
n = search next forward/backwards
? = search backwards

Still needs to continue from start/end when not found, use HOME + / or
END + ? for now.

At some point we need a keybindings file to support ones favourite mode,
erm, like EMACS, etc.

Also we now need a 'h' window with all these keybindings.

Requested-by: Andi Kleen <andi@firstfloor.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-rv30xj2i258n0gwkzlu0c0bc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/ui/browsers/annotate.c |  149 +++++++++++++++++++++++++++++++-
 1 files changed, 148 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 752d8d0..c2cfeed 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -21,6 +21,8 @@ struct annotate_browser {
 	int		    nr_entries;
 	bool		    hide_src_code;
 	bool		    use_offset;
+	bool		    searching_backwards;
+	char		    search_bf[128];
 };
 
 struct objdump_line_rb_node {
@@ -176,6 +178,7 @@ static void annotate_browser__set_top(struct annotate_browser *self,
 	}
 
 	self->b.top = pos;
+	self->b.navkeypressed = true;
 }
 
 static void annotate_browser__set_rb_top(struct annotate_browser *browser,
@@ -354,6 +357,132 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 	return true;
 }
 
+static struct objdump_line *
+	annotate_browser__find_string(struct annotate_browser *browser,
+				      char *s, s64 *idx)
+{
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
+	struct annotation *notes = symbol__annotation(sym);
+	struct objdump_line *pos = browser->selection;
+
+	*idx = browser->b.index;
+	list_for_each_entry_continue(pos, &notes->src->source, node) {
+		if (objdump_line__filter(&browser->b, &pos->node))
+			continue;
+
+		++*idx;
+
+		if (pos->line && strstr(pos->line, s) != NULL)
+			return pos;
+	}
+
+	return NULL;
+}
+
+static bool __annotate_browser__search(struct annotate_browser *browser)
+{
+	struct objdump_line *line;
+	s64 idx;
+
+	line = annotate_browser__find_string(browser, browser->search_bf, &idx);
+	if (line == NULL) {
+		ui_helpline__puts("String not found!");
+		return false;
+	}
+
+	annotate_browser__set_top(browser, line, idx);
+	browser->searching_backwards = false;
+	return true;
+}
+
+static struct objdump_line *
+	annotate_browser__find_string_reverse(struct annotate_browser *browser,
+					      char *s, s64 *idx)
+{
+	struct map_symbol *ms = browser->b.priv;
+	struct symbol *sym = ms->sym;
+	struct annotation *notes = symbol__annotation(sym);
+	struct objdump_line *pos = browser->selection;
+
+	*idx = browser->b.index;
+	list_for_each_entry_continue_reverse(pos, &notes->src->source, node) {
+		if (objdump_line__filter(&browser->b, &pos->node))
+			continue;
+
+		--*idx;
+
+		if (pos->line && strstr(pos->line, s) != NULL)
+			return pos;
+	}
+
+	return NULL;
+}
+
+static bool __annotate_browser__search_reverse(struct annotate_browser *browser)
+{
+	struct objdump_line *line;
+	s64 idx;
+
+	line = annotate_browser__find_string_reverse(browser, browser->search_bf, &idx);
+	if (line == NULL) {
+		ui_helpline__puts("String not found!");
+		return false;
+	}
+
+	annotate_browser__set_top(browser, line, idx);
+	browser->searching_backwards = true;
+	return true;
+}
+
+static bool annotate_browser__search_window(struct annotate_browser *browser,
+					    int delay_secs)
+{
+	if (ui_browser__input_window("Search", "String: ", browser->search_bf,
+				     "ENTER: OK, ESC: Cancel",
+				     delay_secs * 2) != K_ENTER ||
+	    !*browser->search_bf)
+		return false;
+
+	return true;
+}
+
+static bool annotate_browser__search(struct annotate_browser *browser, int delay_secs)
+{
+	if (annotate_browser__search_window(browser, delay_secs))
+		return __annotate_browser__search(browser);
+
+	return false;
+}
+
+static bool annotate_browser__continue_search(struct annotate_browser *browser,
+					      int delay_secs)
+{
+	if (!*browser->search_bf)
+		return annotate_browser__search(browser, delay_secs);
+
+	return __annotate_browser__search(browser);
+}
+
+static bool annotate_browser__search_reverse(struct annotate_browser *browser,
+					   int delay_secs)
+{
+	if (annotate_browser__search_window(browser, delay_secs))
+		return __annotate_browser__search_reverse(browser);
+
+	return false;
+}
+
+static
+bool annotate_browser__continue_search_reverse(struct annotate_browser *browser,
+					       int delay_secs)
+{
+	if (!*browser->search_bf)
+		return annotate_browser__search_reverse(browser, delay_secs);
+
+	return __annotate_browser__search_reverse(browser);
+}
+
 static int annotate_browser__run(struct annotate_browser *self, int evidx,
 				 void(*timer)(void *arg),
 				 void *arg, int delay_secs)
@@ -372,8 +501,10 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 
 	annotate_browser__calc_percent(self, evidx);
 
-	if (self->curr_hot)
+	if (self->curr_hot) {
 		annotate_browser__set_rb_top(self, self->curr_hot);
+		self->b.navkeypressed = false;
+	}
 
 	nd = self->curr_hot;
 
@@ -428,6 +559,22 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'o':
 			self->use_offset = !self->use_offset;
 			continue;
+		case '/':
+			if (annotate_browser__search(self, delay_secs)) {
+show_help:
+				ui_helpline__puts(help);
+			}
+			continue;
+		case 'n':
+			if (self->searching_backwards ?
+			    annotate_browser__continue_search_reverse(self, delay_secs) :
+			    annotate_browser__continue_search(self, delay_secs))
+				goto show_help;
+			continue;
+		case '?':
+			if (annotate_browser__search_reverse(self, delay_secs))
+				goto show_help;
+			continue;
 		case K_ENTER:
 		case K_RIGHT:
 			if (self->selection == NULL)
