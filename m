Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab2D0IhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:37:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34347 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757875Ab2D0IhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:37:01 -0400
Date: Fri, 27 Apr 2012 01:36:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-pk4dqaum6ftiz104dvimwgtb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Group operands members
Git-Commit-ID: c7e6ead7347813b5833efb9b32908c08ff131259
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:36:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7e6ead7347813b5833efb9b32908c08ff131259
Gitweb:     http://git.kernel.org/tip/c7e6ead7347813b5833efb9b32908c08ff131259
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 20 Apr 2012 14:38:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 20 Apr 2012 14:38:46 -0300

perf annotate: Group operands members

So that the ins_ops can handle them in a single place, instead of adding
more and more functions or ins_ops parameters.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-pk4dqaum6ftiz104dvimwgtb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   17 +++++------
 tools/perf/util/annotate.c        |   56 ++++++++++++++++++------------------
 tools/perf/util/annotate.h        |   22 ++++++++------
 3 files changed, 49 insertions(+), 46 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index e760326..9c7b6d8 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -113,13 +113,12 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		if (change_color)
 			ui_browser__set_color(self, color);
 		if (dl->ins && dl->ins->ops->scnprintf) {
-			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf),
-						!ab->use_offset ? dl->operands : NULL,
-						dl->target);
+			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf), &dl->ops,
+						!ab->use_offset);
 			slsmg_write_nstring(" ", 2);
 			printed += 2;
 		} else
-			scnprintf(bf, sizeof(bf), "  %-6.6s %s", dl->name, dl->operands);
+			scnprintf(bf, sizeof(bf), "  %-6.6s %s", dl->name, dl->ops.raw);
 
 		slsmg_write_nstring(bf, width - 10 - printed);
 	}
@@ -294,7 +293,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	if (!ins__is_call(dl->ins))
 		return false;
 
-	ip = ms->map->map_ip(ms->map, dl->target);
+	ip = ms->map->map_ip(ms->map, dl->ops.target);
 	target = map__find_symbol(ms->map, ip, NULL);
 	if (target == NULL) {
 		ui_helpline__puts("The called function was not found.");
@@ -345,7 +344,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 	if (!ins__is_jump(dl->ins))
 		return false;
 
-	dl = annotate_browser__find_offset(browser, dl->target, &idx);
+	dl = annotate_browser__find_offset(browser, dl->ops.target, &idx);
 	if (dl == NULL) {
 		ui_helpline__puts("Invallid jump offset");
 		return true;
@@ -621,14 +620,14 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		if (!dl || !dl->ins || !ins__is_jump(dl->ins))
 			continue;
 
-		if (dl->target >= size) {
+		if (dl->ops.target >= size) {
 			ui__error("jump to after symbol!\n"
 				  "size: %zx, jump target: %" PRIx64,
-				  size, dl->target);
+				  size, dl->ops.target);
 			continue;
 		}
 
-		dlt = browser->offsets[dl->target];
+		dlt = browser->offsets[dl->ops.target];
 		bdlt = disasm_line__browser(dlt);
 		bdlt->jump_target = true;
 	}
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index e70cbb4..7f6c14b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,14 +18,14 @@
 
 const char 	*disassembler_style;
 
-static int call_ops__parse_target(const char *operands, u64 *target)
+static int call__parse(struct ins_operands *ops)
 {
-	*target = strtoull(operands, NULL, 16);
+	ops->target = strtoull(ops->raw, NULL, 16);
 	return 0;
 }
 
 static struct ins_ops call_ops = {
-	.parse_target = call_ops__parse_target,
+	.parse = call__parse,
 };
 
 bool ins__is_call(const struct ins *ins)
@@ -33,29 +33,29 @@ bool ins__is_call(const struct ins *ins)
 	return ins->ops == &call_ops;
 }
 
-static int jump_ops__parse_target(const char *operands, u64 *target)
+static int jump__parse(struct ins_operands *ops)
 {
-	const char *s = strchr(operands, '+');
+	const char *s = strchr(ops->raw, '+');
 
 	if (s++ == NULL)
 		return -1;
 
-	*target = strtoll(s, NULL, 16);
+	ops->target = strtoll(s, NULL, 16);
 	return 0;
 }
 
-static int jump_ops__scnprintf(struct ins *ins, char *bf, size_t size,
-			       const char *operands, u64 target)
+static int jump__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops, bool addrs)
 {
-	if (operands)
-		return scnprintf(bf, size, "%-6.6s %s", ins->name, operands);
+	if (addrs)
+		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
 
-	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, target);
+	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, ops->target);
 }
 
 static struct ins_ops jump_ops = {
-	.parse_target = jump_ops__parse_target,
-	.scnprintf = jump_ops__scnprintf,
+	.parse	   = jump__parse,
+	.scnprintf = jump__scnprintf,
 };
 
 bool ins__is_jump(const struct ins *ins)
@@ -190,8 +190,8 @@ static void disasm_line__init_ins(struct disasm_line *dl)
 	if (!dl->ins->ops)
 		return;
 
-	if (dl->ins->ops->parse_target)
-		dl->ins->ops->parse_target(dl->operands, &dl->target);
+	if (dl->ins->ops->parse)
+		dl->ins->ops->parse(&dl->ops);
 }
 
 static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
@@ -213,25 +213,25 @@ static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privs
 			if (name[0] == '\0')
 				goto out_delete;
 
-			dl->operands = name + 1;
+			dl->ops.raw = name + 1;
 
-			while (dl->operands[0] != '\0' &&
-			       !isspace(dl->operands[0]))
-				++dl->operands;
+			while (dl->ops.raw[0] != '\0' &&
+			       !isspace(dl->ops.raw[0]))
+				++dl->ops.raw;
 
-			tmp = dl->operands[0];
-			dl->operands[0] = '\0';
+			tmp = dl->ops.raw[0];
+			dl->ops.raw[0] = '\0';
 			dl->name = strdup(name);
 
 			if (dl->name == NULL)
 				goto out_free_line;
 
-			dl->operands[0] = tmp;
+			dl->ops.raw[0] = tmp;
 
-			if (dl->operands[0] != '\0') {
-				dl->operands++;
-				while (isspace(dl->operands[0]))
-					++dl->operands;
+			if (dl->ops.raw[0] != '\0') {
+				dl->ops.raw++;
+				while (isspace(dl->ops.raw[0]))
+					++dl->ops.raw;
 			}
 
 			disasm_line__init_ins(dl);
@@ -753,9 +753,9 @@ static size_t disasm_line__fprintf(struct disasm_line *dl, FILE *fp)
 
 	printed = fprintf(fp, "%#" PRIx64 " %s", dl->offset, dl->name);
 
-	if (dl->operands[0] != '\0') {
+	if (dl->ops.raw[0] != '\0') {
 		printed += fprintf(fp, "%.*s %s\n", 6 - (int)printed, " ",
-				   dl->operands);
+				   dl->ops.raw);
 	}
 
 	return printed + fprintf(fp, "\n");
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 6314335..a6f60d5 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -9,10 +9,15 @@
 
 struct ins;
 
+struct ins_operands {
+	char	*raw;
+	u64	target;
+};
+
 struct ins_ops {
-	int (*parse_target)(const char *operands, u64 *target);
+	int (*parse)(struct ins_operands *ops);
 	int (*scnprintf)(struct ins *ins, char *bf, size_t size,
-			 const char *operands, u64 target);
+			 struct ins_operands *ops, bool addrs);
 };
 
 struct ins {
@@ -24,13 +29,12 @@ bool ins__is_jump(const struct ins *ins);
 bool ins__is_call(const struct ins *ins);
 
 struct disasm_line {
-	struct list_head node;
-	s64		 offset;
-	u64		 target;
-	char		 *line;
-	char		 *name;
-	struct ins	 *ins;
-	char		 *operands;
+	struct list_head    node;
+	s64		    offset;
+	char		    *line;
+	char		    *name;
+	struct ins	    *ins;
+	struct ins_operands ops;
 };
 
 void disasm_line__free(struct disasm_line *dl);
