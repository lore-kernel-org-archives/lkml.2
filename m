Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab2DSUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:35:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347Ab2DSUeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:34:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/13] perf annotate: Disassembler instruction parsing
Date: Thu, 19 Apr 2012 17:33:59 -0300
Message-Id: <1334867644-2722-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that at disassembly time we parse targets, etc.

Supporting jump instructions initially, call functions are next.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-7vzlh66n5or46n27ji658cnl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   19 ++---------
 tools/perf/util/annotate.c        |   63 +++++++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h        |   13 ++++++++
 3 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 0bc3e65..bdbb54f 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -315,26 +315,13 @@ struct disasm_line *annotate_browser__find_offset(struct annotate_browser *brows
 
 static bool annotate_browser__jump(struct annotate_browser *browser)
 {
-	const char *jumps[] = { "je", "jne", "ja", "jmpq", "js", "jmp", NULL };
 	struct disasm_line *dl = browser->selection;
-	s64 idx, offset;
-	char *s;
-	int i = 0;
-
-	while (jumps[i] && strcmp(dl->name, jumps[i]))
-		++i;
+	s64 idx;
 
-	if (jumps[i] == NULL)
+	if (!dl->ins || !ins__is_jump(dl->ins))
 		return false;
 
-	s = strchr(dl->operands, '+');
-	if (s++ == NULL) {
-		ui_helpline__puts("Invallid jump instruction.");
-		return true;
-	}
-
-	offset = strtoll(s, NULL, 16);
-	dl = annotate_browser__find_offset(browser, offset, &idx);
+	dl = annotate_browser__find_offset(browser, dl->target, &idx);
 	if (dl == NULL) {
 		ui_helpline__puts("Invallid jump offset");
 		return true;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a72585a..4ee2c07 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,53 @@
 
 const char 	*disassembler_style;
 
+static int jump_ops__parse_target(const char *operands, u64 *target)
+{
+	const char *s = strchr(operands, '+');
+
+	if (s++ == NULL)
+		return -1;
+
+	*target = strtoll(s, NULL, 16);
+	return 0;
+}
+
+static struct ins_ops jump_ops = {
+	.parse_target = jump_ops__parse_target,
+};
+
+bool ins__is_jump(const struct ins *ins)
+{
+	return ins->ops == &jump_ops;
+}
+
+
+/*
+ * Must be sorted by name!
+ */
+static struct ins instructions[] = {
+	{ .name = "ja",	   .ops  = &jump_ops, },
+	{ .name = "je",	   .ops  = &jump_ops, },
+	{ .name = "jmp",   .ops  = &jump_ops, },
+	{ .name = "jmpq",  .ops  = &jump_ops, },
+	{ .name = "jne",   .ops  = &jump_ops, },
+	{ .name = "js",	   .ops  = &jump_ops, },
+};
+
+static int ins__cmp(const void *name, const void *insp)
+{
+	const struct ins *ins = insp;
+
+	return strcmp(name, ins->name);
+}
+
+static struct ins *ins__find(const char *name)
+{
+	const int nmemb = ARRAY_SIZE(instructions);
+
+	return bsearch(name, instructions, nmemb, sizeof(struct ins), ins__cmp);
+}
+
 int symbol__annotate_init(struct map *map __used, struct symbol *sym)
 {
 	struct annotation *notes = symbol__annotation(sym);
@@ -78,6 +125,20 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 	return 0;
 }
 
+static void disasm_line__init_ins(struct disasm_line *dl)
+{
+	dl->ins = ins__find(dl->name);
+
+	if (dl->ins == NULL)
+		return;
+
+	if (!dl->ins->ops)
+		return;
+
+	if (dl->ins->ops->parse_target)
+		dl->ins->ops->parse_target(dl->operands, &dl->target);
+}
+
 static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
 {
 	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
@@ -117,6 +178,8 @@ static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privs
 				while (isspace(dl->operands[0]))
 					++dl->operands;
 			}
+
+			disasm_line__init_ins(dl);
 		}
 	}
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index dd7636d..934c6fe 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,11 +7,24 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 
+struct ins_ops {
+	int (*parse_target)(const char *operands, u64 *target);
+};
+
+struct ins {
+	const char     *name;
+	struct ins_ops *ops;
+};
+
+bool ins__is_jump(const struct ins *ins);
+
 struct disasm_line {
 	struct list_head node;
 	s64		 offset;
+	u64		 target;
 	char		 *line;
 	char		 *name;
+	struct ins	 *ins;
 	char		 *operands;
 };
 
-- 
1.7.9.2.358.g22243

