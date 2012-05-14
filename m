Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab2ENNBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:01:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2ENNBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:01:06 -0400
Date: Mon, 14 May 2012 06:00:38 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4913ba2dzakz5rivgumosqbh@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Augment lock instruction output
Git-Commit-ID: 7a997fe4019f556a81530d3a737d817a2b0d622f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:00:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a997fe4019f556a81530d3a737d817a2b0d622f
Gitweb:     http://git.kernel.org/tip/7a997fe4019f556a81530d3a737d817a2b0d622f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 12 May 2012 13:15:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 12 May 2012 13:15:34 -0300

perf annotate: Augment lock instruction output

It just chops off the 'lock' and uses the ins__find, etc machinery to
call instruction specific parsers/beautifiers.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4913ba2dzakz5rivgumosqbh@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |  127 ++++++++++++++++++++++++++++++++++----------
 tools/perf/util/annotate.h |   16 ++++--
 2 files changed, 109 insertions(+), 34 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a6109dc..1dce098 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,9 @@
 
 const char 	*disassembler_style;
 
+static struct ins *ins__find(const char *name);
+static int disasm_line__parse(char *line, char **namep, char **rawp);
+
 static int ins__raw_scnprintf(struct ins *ins, char *bf, size_t size,
 			      struct ins_operands *ops)
 {
@@ -147,6 +150,53 @@ static int comment__symbol(char *raw, char *comment, u64 *addrp, char **namep)
 	return 0;
 }
 
+static int lock__parse(struct ins_operands *ops)
+{
+	char *name;
+
+	ops->locked.ops = zalloc(sizeof(*ops->locked.ops));
+	if (ops->locked.ops == NULL)
+		return 0;
+
+	if (disasm_line__parse(ops->raw, &name, &ops->locked.ops->raw) < 0)
+		goto out_free_ops;
+
+        ops->locked.ins = ins__find(name);
+        if (ops->locked.ins == NULL)
+                goto out_free_ops;
+
+        if (!ops->locked.ins->ops)
+                return 0;
+
+        if (ops->locked.ins->ops->parse)
+                ops->locked.ins->ops->parse(ops->locked.ops);
+
+	return 0;
+
+out_free_ops:
+	free(ops->locked.ops);
+	ops->locked.ops = NULL;
+	return 0;
+}
+
+static int lock__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops)
+{
+	int printed;
+
+	if (ops->locked.ins == NULL)
+		return ins__raw_scnprintf(ins, bf, size, ops);
+
+	printed = scnprintf(bf, size, "%-6.6s ", ins->name);
+	return printed + ins__scnprintf(ops->locked.ins, bf + printed,
+					size - printed, ops->locked.ops);
+}
+
+static struct ins_ops lock_ops = {
+	.parse	   = lock__parse,
+	.scnprintf = lock__scnprintf,
+};
+
 static int mov__parse(struct ins_operands *ops)
 {
 	char *s = strchr(ops->raw, ','), *target, *comment, prev;
@@ -265,6 +315,7 @@ static struct ins instructions[] = {
 	{ .name = "addq",  .ops  = &mov_ops, },
 	{ .name = "addw",  .ops  = &mov_ops, },
 	{ .name = "and",   .ops  = &mov_ops, },
+	{ .name = "bts",   .ops  = &mov_ops, },
 	{ .name = "call",  .ops  = &call_ops, },
 	{ .name = "callq", .ops  = &call_ops, },
 	{ .name = "cmp",   .ops  = &mov_ops, },
@@ -314,6 +365,7 @@ static struct ins instructions[] = {
 	{ .name = "js",	   .ops  = &jump_ops, },
 	{ .name = "jz",	   .ops  = &jump_ops, },
 	{ .name = "lea",   .ops  = &mov_ops, },
+	{ .name = "lock",  .ops  = &lock_ops, },
 	{ .name = "mov",   .ops  = &mov_ops, },
 	{ .name = "movb",  .ops  = &mov_ops, },
 	{ .name = "movdqa",.ops  = &mov_ops, },
@@ -330,6 +382,7 @@ static struct ins instructions[] = {
 	{ .name = "test",  .ops  = &mov_ops, },
 	{ .name = "testb", .ops  = &mov_ops, },
 	{ .name = "testl", .ops  = &mov_ops, },
+	{ .name = "xadd",  .ops  = &mov_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
@@ -420,6 +473,44 @@ static void disasm_line__init_ins(struct disasm_line *dl)
 		dl->ins->ops->parse(&dl->ops);
 }
 
+static int disasm_line__parse(char *line, char **namep, char **rawp)
+{
+	char *name = line, tmp;
+
+	while (isspace(name[0]))
+		++name;
+
+	if (name[0] == '\0')
+		return -1;
+
+	*rawp = name + 1;
+
+	while ((*rawp)[0] != '\0' && !isspace((*rawp)[0]))
+		++*rawp;
+
+	tmp = (*rawp)[0];
+	(*rawp)[0] = '\0';
+	*namep = strdup(name);
+
+	if (*namep == NULL)
+		goto out_free_name;
+
+	(*rawp)[0] = tmp;
+
+	if ((*rawp)[0] != '\0') {
+		(*rawp)++;
+		while (isspace((*rawp)[0]))
+			++(*rawp);
+	}
+
+	return 0;
+
+out_free_name:
+	free(*namep);
+	*namep = NULL;
+	return -1;
+}
+
 static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privsize)
 {
 	struct disasm_line *dl = zalloc(sizeof(*dl) + privsize);
@@ -431,35 +522,9 @@ static struct disasm_line *disasm_line__new(s64 offset, char *line, size_t privs
 			goto out_delete;
 
 		if (offset != -1) {
-			char *name = dl->line, tmp;
-
-			while (isspace(name[0]))
-				++name;
-
-			if (name[0] == '\0')
-				goto out_delete;
-
-			dl->ops.raw = name + 1;
-
-			while (dl->ops.raw[0] != '\0' &&
-			       !isspace(dl->ops.raw[0]))
-				++dl->ops.raw;
-
-			tmp = dl->ops.raw[0];
-			dl->ops.raw[0] = '\0';
-			dl->name = strdup(name);
-
-			if (dl->name == NULL)
+			if (disasm_line__parse(dl->line, &dl->name, &dl->ops.raw) < 0)
 				goto out_free_line;
 
-			dl->ops.raw[0] = tmp;
-
-			if (dl->ops.raw[0] != '\0') {
-				dl->ops.raw++;
-				while (isspace(dl->ops.raw[0]))
-					++dl->ops.raw;
-			}
-
 			disasm_line__init_ins(dl);
 		}
 	}
@@ -477,8 +542,12 @@ void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
 	free(dl->name);
-	free(dl->ops.source.raw);
-	free(dl->ops.source.name);
+	if (dl->ins && dl->ins->ops == &lock_ops) {
+		free(dl->ops.locked.ops);
+	} else {
+		free(dl->ops.source.raw);
+		free(dl->ops.source.name);
+	}
 	free(dl->ops.target.raw);
 	free(dl->ops.target.name);
 	free(dl);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 066d31d..b79d326 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -18,11 +18,17 @@ struct ins_operands {
 		u64	addr;
 		u64	offset;
 	} target;
-	struct {
-		char	*raw;
-		char	*name;
-		u64	addr;
-	} source;
+	union {
+		struct {
+			char	*raw;
+			char	*name;
+			u64	addr;
+		} source;
+		struct {
+			struct ins *ins;
+			struct ins_operands *ops;
+		} locked;
+	};
 };
 
 struct ins_ops {
