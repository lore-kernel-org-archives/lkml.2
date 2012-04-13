Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab2DMSHc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:07:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51456 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948Ab2DMSHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:07:30 -0400
Date: Fri, 13 Apr 2012 11:06:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ede5zkaf7oorwvbqjezb4yg4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Allow printing objdump line addr in different color
Git-Commit-ID: 058b4cc9af574c072988a38a7a5ee93df881e5aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 13 Apr 2012 11:06:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  058b4cc9af574c072988a38a7a5ee93df881e5aa
Gitweb:     http://git.kernel.org/tip/058b4cc9af574c072988a38a7a5ee93df881e5aa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Apr 2012 12:59:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 7 Apr 2012 16:09:05 -0300

perf annotate: Allow printing objdump line addr in different color

And by default use "magenta" for it.

Both the --stdio and --tui routines follow the same semantics.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ede5zkaf7oorwvbqjezb4yg4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perfconfig.example |    1 +
 tools/perf/util/annotate.c                  |   35 ++++++++++++++++++--------
 tools/perf/util/ui/browser.c                |    6 ++++
 tools/perf/util/ui/browser.h                |    1 +
 tools/perf/util/ui/browsers/annotate.c      |   26 ++++++++++++++++----
 5 files changed, 53 insertions(+), 16 deletions(-)

diff --git a/tools/perf/Documentation/perfconfig.example b/tools/perf/Documentation/perfconfig.example
index d144866..42c6fd2 100644
--- a/tools/perf/Documentation/perfconfig.example
+++ b/tools/perf/Documentation/perfconfig.example
@@ -6,6 +6,7 @@
 	normal = black, lightgray
 	selected = lightgray, magenta
 	code = blue, lightgray
+	addr = magenta, lightgray
 
 [tui]
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 08c6d13..9fc4126 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -84,10 +84,15 @@ static struct objdump_line *objdump_line__new(s64 offset, char *line, size_t pri
 
 	if (self != NULL) {
 		self->offset = offset;
-		self->line = line;
+		self->line = strdup(line);
+		if (self->line == NULL)
+			goto out_delete;
 	}
 
 	return self;
+out_delete:
+	free(self);
+	return NULL;
 }
 
 void objdump_line__free(struct objdump_line *self)
@@ -112,7 +117,7 @@ struct objdump_line *objdump__get_next_ip_line(struct list_head *head,
 }
 
 static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
-			       int evidx, u64 len, int min_pcnt,
+			       u64 start, int evidx, u64 len, int min_pcnt,
 			       int printed, int max_lines,
 			       struct objdump_line *queue)
 {
@@ -128,6 +133,7 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 		struct source_line *src_line = notes->src->lines;
 		struct sym_hist *h = annotation__histogram(notes, evidx);
 		s64 offset = oline->offset;
+		const u64 addr = start + offset;
 		struct objdump_line *next;
 
 		next = objdump__get_next_ip_line(&notes->src->source, oline);
@@ -157,7 +163,7 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 			list_for_each_entry_from(queue, &notes->src->source, node) {
 				if (queue == oline)
 					break;
-				objdump_line__print(queue, sym, evidx, len,
+				objdump_line__print(queue, sym, start, evidx, len,
 						    0, 0, 1, NULL);
 			}
 		}
@@ -180,6 +186,7 @@ static int objdump_line__print(struct objdump_line *oline, struct symbol *sym,
 
 		color_fprintf(stdout, color, " %7.2f", percent);
 		printf(" :	");
+		color_fprintf(stdout, PERF_COLOR_MAGENTA, "  %" PRIx64 ":", addr);
 		color_fprintf(stdout, PERF_COLOR_BLUE, "%s\n", oline->line);
 	} else if (max_lines && printed >= max_lines)
 		return 1;
@@ -201,7 +208,7 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 {
 	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *objdump_line;
-	char *line = NULL, *tmp, *tmp2, *c;
+	char *line = NULL, *parsed_line, *tmp, *tmp2, *c;
 	size_t line_len;
 	s64 line_ip, offset = -1;
 
@@ -246,13 +253,17 @@ static int symbol__parse_objdump_line(struct symbol *sym, struct map *map,
 		offset = line_ip - start;
 		if (offset < 0 || (u64)line_ip > end)
 			offset = -1;
-	}
+		else
+			parsed_line = tmp2 + 1;
+	} else
+		parsed_line = line;
 
-	objdump_line = objdump_line__new(offset, line, privsize);
-	if (objdump_line == NULL) {
-		free(line);
+	objdump_line = objdump_line__new(offset, parsed_line, privsize);
+	free(line);
+
+	if (objdump_line == NULL)
 		return -1;
-	}
+
 	objdump__add_line(&notes->src->source, objdump_line);
 
 	return 0;
@@ -493,6 +504,7 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 	const char *filename = dso->long_name, *d_filename;
 	struct annotation *notes = symbol__annotation(sym);
 	struct objdump_line *pos, *queue = NULL;
+	u64 start = map__rip_2objdump(map, sym->start);
 	int printed = 2, queue_len = 0;
 	int more = 0;
 	u64 len;
@@ -516,8 +528,9 @@ int symbol__annotate_printf(struct symbol *sym, struct map *map, int evidx,
 			queue_len = 0;
 		}
 
-		switch (objdump_line__print(pos, sym, evidx, len, min_pcnt,
-					    printed, max_lines, queue)) {
+		switch (objdump_line__print(pos, sym, start, evidx, len,
+					    min_pcnt, printed, max_lines,
+					    queue)) {
 		case 0:
 			++printed;
 			if (context) {
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 076a5ff..a1b140c 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -506,6 +506,12 @@ static struct ui_browser__colorset {
 		.bg	  = "default",
 	},
 	{
+		.colorset = HE_COLORSET_ADDR,
+		.name	  = "addr",
+		.fg	  = "magenta",
+		.bg	  = "default",
+	},
+	{
 		.name = NULL,
 	}
 };
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index 65b2592..2550277 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -10,6 +10,7 @@
 #define HE_COLORSET_NORMAL	52
 #define HE_COLORSET_SELECTED	53
 #define HE_COLORSET_CODE	54
+#define HE_COLORSET_ADDR	55
 
 struct ui_browser {
 	u64	      index, top_idx;
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 57a4c6e..7ac7dd0 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -16,6 +16,7 @@ struct annotate_browser {
 	struct rb_root	  entries;
 	struct rb_node	  *curr_hot;
 	struct objdump_line *selection;
+	u64		    start;
 	int		    nr_asm_entries;
 	int		    nr_entries;
 	bool		    hide_src_code;
@@ -51,6 +52,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	struct annotate_browser *ab = container_of(self, struct annotate_browser, b);
 	struct objdump_line *ol = list_entry(entry, struct objdump_line, node);
 	bool current_entry = ui_browser__is_current_entry(self, row);
+	bool change_color = (!ab->hide_src_code &&
+			     (!current_entry || (self->use_navkeypressed &&
+					         !self->navkeypressed)));
 	int width = self->width;
 
 	if (ol->offset != -1) {
@@ -69,15 +73,26 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	if (!self->navkeypressed)
 		width += 1;
 
-	if (!ab->hide_src_code && ol->offset != -1)
-		if (!current_entry || (self->use_navkeypressed &&
-				       !self->navkeypressed))
-			ui_browser__set_color(self, HE_COLORSET_CODE);
+	if (ol->offset != -1 && change_color)
+		ui_browser__set_color(self, HE_COLORSET_CODE);
 
 	if (!*ol->line)
 		slsmg_write_nstring(" ", width - 18);
-	else
+	else if (ol->offset == -1)
 		slsmg_write_nstring(ol->line, width - 18);
+	else {
+		char bf[64];
+		u64 addr = ab->start + ol->offset;
+		int printed = scnprintf(bf, sizeof(bf), " %" PRIx64 ":", addr);
+		int color = -1;
+
+		if (change_color)
+			color = ui_browser__set_color(self, HE_COLORSET_ADDR);
+		slsmg_write_nstring(bf, printed);
+		if (change_color)
+			ui_browser__set_color(self, color);
+		slsmg_write_nstring(ol->line, width - 18 - printed);
+	}
 
 	if (current_entry)
 		ab->selection = ol;
@@ -406,6 +421,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 	ui_helpline__push("Press <- or ESC to exit");
 
 	notes = symbol__annotation(sym);
+	browser.start = map__rip_2objdump(map, sym->start);
 
 	list_for_each_entry(pos, &notes->src->source, node) {
 		struct objdump_line_rb_node *rbpos;
