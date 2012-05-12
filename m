Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab2ELTy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:35564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab2ELTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:53:21 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf annotate browser: Show 'jumpy' functions
Date: Sat, 12 May 2012 16:53:06 -0300
Message-Id: <1336852387-16322-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336852387-16322-1-git-send-email-acme@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just press 'J' and see how many places jump to jump targets.

The hottest jump target appears in red, targets with more than one
source have a different color than single source jump targets.

Suggested-by: Arjan van de Ven <arjan@infradead.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7452y0dmc02a20ooins7rn79@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   65 ++++++++++++++++++++++++++++++++++---
 1 file changed, 60 insertions(+), 5 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4463626..547bd35 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -28,11 +28,16 @@ struct annotate_browser {
 	u64		    start;
 	int		    nr_asm_entries;
 	int		    nr_entries;
+	int		    max_jump_sources;
+	int		    nr_jumps;
 	bool		    hide_src_code;
 	bool		    use_offset;
 	bool		    jump_arrows;
+	bool		    show_nr_jumps;
 	bool		    searching_backwards;
 	u8		    addr_width;
+	u8		    jumps_width;
+	u8		    target_width;
 	u8		    min_addr_width;
 	u8		    max_addr_width;
 	char		    search_bf[128];
@@ -55,6 +60,25 @@ static bool disasm_line__filter(struct ui_browser *browser, void *entry)
 	return false;
 }
 
+static int annotate_browser__jumps_percent_color(struct annotate_browser *browser,
+						 int nr, bool current)
+{
+	if (current && (!browser->b.use_navkeypressed || browser->b.navkeypressed))
+		return HE_COLORSET_SELECTED;
+	if (nr == browser->max_jump_sources)
+		return HE_COLORSET_TOP;
+	if (nr > 1)
+		return HE_COLORSET_MEDIUM;
+	return HE_COLORSET_NORMAL;
+}
+
+static int annotate_browser__set_jumps_percent_color(struct annotate_browser *browser,
+						     int nr, bool current)
+{
+	 int color = annotate_browser__jumps_percent_color(browser, nr, current);
+	 return ui_browser__set_color(&browser->b, color);
+}
+
 static void annotate_browser__write(struct ui_browser *self, void *entry, int row)
 {
 	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
@@ -99,8 +123,19 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			printed = scnprintf(bf, sizeof(bf), "%" PRIx64 ": ", addr);
 		} else {
 			if (bdl->jump_sources) {
+				if (ab->show_nr_jumps) {
+					int prev;
+					printed = scnprintf(bf, sizeof(bf), "%*d ",
+							    ab->jumps_width,
+							    bdl->jump_sources);
+					prev = annotate_browser__set_jumps_percent_color(ab, bdl->jump_sources,
+											 current_entry);
+					slsmg_write_nstring(bf, printed);
+					ui_browser__set_color(self, prev);
+				}
+
 				printed = scnprintf(bf, sizeof(bf), "%*" PRIx64 ": ",
-						    ab->addr_width, addr);
+						    ab->target_width, addr);
 			} else {
 				printed = scnprintf(bf, sizeof(bf), "%*s  ",
 						    ab->addr_width, " ");
@@ -615,13 +650,20 @@ static int annotate_browser__run(struct annotate_browser *self, int evidx,
 		case 'o':
 			self->use_offset = !self->use_offset;
 			if (self->use_offset)
-				self->addr_width = self->min_addr_width;
+				self->target_width = self->min_addr_width;
 			else
-				self->addr_width = self->max_addr_width;
+				self->target_width = self->max_addr_width;
+update_addr_width:
+			self->addr_width = self->target_width;
+			if (self->show_nr_jumps)
+				self->addr_width += self->jumps_width + 1;
 			continue;
 		case 'j':
 			self->jump_arrows = !self->jump_arrows;
 			continue;
+		case 'J':
+			self->show_nr_jumps = !self->show_nr_jumps;
+			goto update_addr_width;
 		case '/':
 			if (annotate_browser__search(self, delay_secs)) {
 show_help:
@@ -707,11 +749,23 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 			continue;
 
 		bdlt = disasm_line__browser(dlt);
-		++bdlt->jump_sources;
+		if (++bdlt->jump_sources > browser->max_jump_sources)
+			browser->max_jump_sources = bdlt->jump_sources;
+
+		++browser->nr_jumps;
 	}
 		
 }
 
+static inline int width_jumps(int n)
+{
+	if (n >= 100)
+		return 5;
+	if (n / 10)
+		return 2;
+	return 1;
+}
+
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 void(*timer)(void *arg), void *arg,
 			 int delay_secs)
@@ -784,8 +838,9 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 
 	annotate_browser__mark_jump_targets(&browser, size);
 
-	browser.addr_width = browser.min_addr_width = hex_width(size);
+	browser.addr_width = browser.target_width = browser.min_addr_width = hex_width(size);
 	browser.max_addr_width = hex_width(sym->end);
+	browser.jumps_width = width_jumps(browser.max_jump_sources);
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
-- 
1.7.9.2.358.g22243

