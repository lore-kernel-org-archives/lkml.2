Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414Ab2D0Icv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:32:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34261 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab2D0Icr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:32:47 -0400
Date: Fri, 27 Apr 2012 01:32:26 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-r2vmbtgz0l8coluj8flztgrn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Hide non jump target addresses in offset mode
Git-Commit-ID: b793a40185b246c2690e06c6d86d12c35f24ab4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:32:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b793a40185b246c2690e06c6d86d12c35f24ab4c
Gitweb:     http://git.kernel.org/tip/b793a40185b246c2690e06c6d86d12c35f24ab4c
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Apr 2012 12:19:22 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Apr 2012 12:19:22 -0300

perf annotate browser: Hide non jump target addresses in offset mode

This:

    0.00 :         ffffffff8116bd00:       lock btsl $0x0,(%r12)
  100.00 :         ffffffff8116bd07:       sbb    %eax,%eax
    0.00 :         ffffffff8116bd09:       test   %eax,%eax
    0.00 :         ffffffff8116bd0b:       jne    ffffffff8116bf5f <__mem_cgroup_commit_charge+0x28f>
    0.00 :         ffffffff8116bd11:       mov    (%r12),%rax
    0.00 :         ffffffff8116bd15:       test   $0x2,%al
    0.00 :         ffffffff8116bd17:       jne    ffffffff8116bf6e <__mem_cgroup_commit_charge+0x29e>
    0.00 :         ffffffff8116bd1d:       test   %r9b,%r9b
    0.00 :         ffffffff8116bd20:       jne    ffffffff8116be30 <__mem_cgroup_commit_charge+0x160>
    0.00 :         ffffffff8116bd26:       xor    %eax,%eax
    0.00 :         ffffffff8116bd28:       mov    %r13,0x8(%r12)
    0.00 :         ffffffff8116bd2d:       lock orb $0x2,(%r12)
    0.00 :         ffffffff8116bd33:       test   %r9b,%r9b
    0.00 :         ffffffff8116bd36:       je     ffffffff8116bdf3 <__mem_cgroup_commit_charge+0x123>

Becomes:

    0.00 :         30:       lock btsl $0x0,(%r12)
  100.00 :                   sbb    %eax,%eax
    0.00 :                   test   %eax,%eax
    0.00 :                   jne    28f
    0.00 :                   mov    (%r12),%rax
    0.00 :                   test   $0x2,%al
    0.00 :                   jne    29e
    0.00 :                   test   %r9b,%r9b
    0.00 :                   jne    160
    0.00 :         56:       xor    %eax,%eax
    0.00 :         58:       mov    %r13,0x8(%r12)
    0.00 :                   lock orb $0x2,(%r12)
    0.00 :                   test   %r9b,%r9b
    0.00 :                   je     123

I.e. We trow away all those useless addresses and keep just jump labels.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-r2vmbtgz0l8coluj8flztgrn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   71 ++++++++++++++++++++++++++++++-------
 1 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 58ebfd0..a1e942b 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -11,11 +11,20 @@
 #include <pthread.h>
 #include <newt.h>
 
+struct browser_disasm_line {
+	struct rb_node	rb_node;
+	double		percent;
+	u32		idx;
+	int		idx_asm;
+	bool		jump_target;
+};
+
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
 	struct disasm_line	  *selection;
+	struct disasm_line  **offsets;
 	u64		    start;
 	int		    nr_asm_entries;
 	int		    nr_entries;
@@ -25,13 +34,6 @@ struct annotate_browser {
 	char		    search_bf[128];
 };
 
-struct browser_disasm_line {
-	struct rb_node	rb_node;
-	double		percent;
-	u32		idx;
-	int		idx_asm;
-};
-
 static inline struct browser_disasm_line *disasm_line__browser(struct disasm_line *dl)
 {
 	return (struct browser_disasm_line *)(dl + 1);
@@ -53,6 +55,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 {
 	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
 	struct disasm_line *dl = list_entry(entry, struct disasm_line, node);
+	struct browser_disasm_line *bdl = disasm_line__browser(dl);
 	bool current_entry = ui_browser__is_current_entry(self, row);
 	bool change_color = (!ab->hide_src_code &&
 			     (!current_entry || (self->use_navkeypressed &&
@@ -60,7 +63,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	int width = self->width;
 
 	if (dl->offset != -1) {
-		struct browser_disasm_line *bdl = disasm_line__browser(dl);
 		ui_browser__set_percent_color(self, bdl->percent, current_entry);
 		slsmg_printf(" %7.2f ", bdl->percent);
 	} else {
@@ -90,7 +92,11 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		if (!ab->use_offset)
 			addr += ab->start;
 
-		printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
+		if (bdl->jump_target || !ab->use_offset)
+			printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
+		else
+			printed = scnprintf(bf, sizeof(bf), "    ");
+
 		if (change_color)
 			color = ui_browser__set_color(self, HE_COLORSET_ADDR);
 		slsmg_write_nstring(bf, printed);
@@ -593,12 +599,39 @@ int hist_entry__tui_annotate(struct hist_entry *he, int evidx,
 				    timer, arg, delay_secs);
 }
 
+static void annotate_browser__mark_jump_targets(struct annotate_browser *browser,
+						size_t size)
+{
+	u64 offset;
+
+	for (offset = 0; offset < size; ++offset) {
+		struct disasm_line *dl = browser->offsets[offset], *dlt;
+		struct browser_disasm_line *bdlt;
+
+		if (!dl || !dl->ins || !ins__is_jump(dl->ins))
+			continue;
+
+		if (dl->target >= size) {
+			ui__error("jump to after symbol!\n"
+				  "size: %zx, jump target: %" PRIx64,
+				  size, dl->target);
+			continue;
+		}
+
+		dlt = browser->offsets[dl->target];
+		bdlt = disasm_line__browser(dlt);
+		bdlt->jump_target = true;
+	}
+		
+}
+
 int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			 void(*timer)(void *arg), void *arg,
 			 int delay_secs)
 {
 	struct disasm_line *pos, *n;
 	struct annotation *notes;
+	const size_t size = symbol__size(sym);
 	struct map_symbol ms = {
 		.map = map,
 		.sym = sym,
@@ -613,7 +646,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			.use_navkeypressed = true,
 		},
 	};
-	int ret;
+	int ret = -1;
 
 	if (sym == NULL)
 		return -1;
@@ -621,9 +654,15 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	if (map->dso->annotate_warned)
 		return -1;
 
+	browser.offsets = zalloc(size * sizeof(struct disasm_line *));
+	if (browser.offsets == NULL) {
+		ui__error("Not enough memory!");
+		return -1;
+	}
+
 	if (symbol__annotate(sym, map, sizeof(struct browser_disasm_line)) < 0) {
 		ui__error("%s", ui_helpline__last_msg);
-		return -1;
+		goto out_free_offsets;
 	}
 
 	ui_helpline__push("Press <- or ESC to exit");
@@ -639,12 +678,15 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 			browser.b.width = line_len;
 		bpos = disasm_line__browser(pos);
 		bpos->idx = browser.nr_entries++;
-		if (pos->offset != -1)
+		if (pos->offset != -1) {
 			bpos->idx_asm = browser.nr_asm_entries++;
-		else
+			browser.offsets[pos->offset] = pos;
+		} else
 			bpos->idx_asm = -1;
 	}
 
+	annotate_browser__mark_jump_targets(&browser, size);
+
 	browser.b.nr_entries = browser.nr_entries;
 	browser.b.entries = &notes->src->source,
 	browser.b.width += 18; /* Percentage */
@@ -653,5 +695,8 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		list_del(&pos->node);
 		disasm_line__free(pos);
 	}
+
+out_free_offsets:
+	free(browser.offsets);
 	return ret;
 }
