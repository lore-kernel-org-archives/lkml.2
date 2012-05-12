Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2ELTyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35565 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2ELTxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 15:53:22 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/8] perf annotate: Resolve symbols using objdump comment
Date: Sat, 12 May 2012 16:53:01 -0300
Message-Id: <1336852387-16322-3-git-send-email-acme@infradead.org>
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

This:

     mov    0x95bbb6(%rip),%ecx        # ffffffff81ae8d04 <d_hash_shift>

Becomes:

     mov    d_hash_shift,%ecx

Ditto for many more instructions that take two operands.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-i5opbyai2x6mn9e5yjmhx9k6@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |  112 ++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/annotate.h |    8 +++-
 2 files changed, 119 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 9a020d1..82c7f63 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -122,6 +122,89 @@ bool ins__is_jump(const struct ins *ins)
 	return ins->ops == &jump_ops;
 }
 
+static int comment__symbol(char *raw, char *comment, u64 *addrp, char **namep)
+{
+	char *endptr, *name, *t;
+
+	if (strstr(raw, "(%rip)") == NULL)
+		return 0;
+
+	*addrp = strtoull(comment, &endptr, 16);
+	name = strchr(endptr, '<');
+	if (name == NULL)
+		return -1;
+
+	name++;
+
+	t = strchr(name, '>');
+	if (t == NULL)
+		return 0;
+
+	*t = '\0';
+	*namep = strdup(name);
+	*t = '>';
+
+	return 0;
+}
+
+static int mov__parse(struct ins_operands *ops)
+{
+	char *s = strchr(ops->raw, ','), *target, *comment, prev;
+
+	if (s == NULL)
+		return -1;
+
+	*s = '\0';
+	ops->source.raw = strdup(ops->raw);
+	*s = ',';
+	
+	if (ops->source.raw == NULL)
+		return -1;
+
+	target = ++s;
+
+	while (s[0] != '\0' && !isspace(s[0]))
+		++s;
+	prev = *s;
+	*s = '\0';
+
+	ops->target.raw = strdup(target);
+	*s = prev;
+
+	if (ops->target.raw == NULL)
+		goto out_free_source;
+
+	comment = strchr(s, '#');
+	if (comment == NULL)
+		return 0;
+
+	while (comment[0] != '\0' && isspace(comment[0]))
+		++comment;
+
+	comment__symbol(ops->source.raw, comment, &ops->source.addr, &ops->source.name);
+	comment__symbol(ops->target.raw, comment, &ops->target.addr, &ops->target.name);
+
+	return 0;
+
+out_free_source:
+	free(ops->source.raw);
+	ops->source.raw = NULL;
+	return -1;
+}
+
+static int mov__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops)
+{
+	return scnprintf(bf, size, "%-6.6s %s,%s", ins->name,
+			 ops->source.name ?: ops->source.raw,
+			 ops->target.name ?: ops->target.raw);
+}
+
+static struct ins_ops mov_ops = {
+	.parse	   = mov__parse,
+	.scnprintf = mov__scnprintf,
+};
+
 static int nop__scnprintf(struct ins *ins __used, char *bf, size_t size,
 			  struct ins_operands *ops __used)
 {
@@ -136,8 +219,20 @@ static struct ins_ops nop_ops = {
  * Must be sorted by name!
  */
 static struct ins instructions[] = {
+	{ .name = "add",   .ops  = &mov_ops, },
+	{ .name = "addl",  .ops  = &mov_ops, },
+	{ .name = "addq",  .ops  = &mov_ops, },
+	{ .name = "addw",  .ops  = &mov_ops, },
+	{ .name = "and",   .ops  = &mov_ops, },
 	{ .name = "call",  .ops  = &call_ops, },
 	{ .name = "callq", .ops  = &call_ops, },
+	{ .name = "cmp",   .ops  = &mov_ops, },
+	{ .name = "cmpb",  .ops  = &mov_ops, },
+	{ .name = "cmpl",  .ops  = &mov_ops, },
+	{ .name = "cmpq",  .ops  = &mov_ops, },
+	{ .name = "cmpw",  .ops  = &mov_ops, },
+	{ .name = "cmpxch", .ops  = &mov_ops, },
+	{ .name = "imul",  .ops  = &mov_ops, },
 	{ .name = "ja",	   .ops  = &jump_ops, },
 	{ .name = "jae",   .ops  = &jump_ops, },
 	{ .name = "jb",	   .ops  = &jump_ops, },
@@ -173,9 +268,23 @@ static struct ins instructions[] = {
 	{ .name = "jrcxz", .ops  = &jump_ops, },
 	{ .name = "js",	   .ops  = &jump_ops, },
 	{ .name = "jz",	   .ops  = &jump_ops, },
+	{ .name = "lea",   .ops  = &mov_ops, },
+	{ .name = "mov",   .ops  = &mov_ops, },
+	{ .name = "movb",  .ops  = &mov_ops, },
+	{ .name = "movdqa",.ops  = &mov_ops, },
+	{ .name = "movl",  .ops  = &mov_ops, },
+	{ .name = "movq",  .ops  = &mov_ops, },
+	{ .name = "movslq", .ops  = &mov_ops, },
+	{ .name = "movzbl", .ops  = &mov_ops, },
+	{ .name = "movzwl", .ops  = &mov_ops, },
 	{ .name = "nop",   .ops  = &nop_ops, },
 	{ .name = "nopl",  .ops  = &nop_ops, },
 	{ .name = "nopw",  .ops  = &nop_ops, },
+	{ .name = "or",    .ops  = &mov_ops, },
+	{ .name = "orl",   .ops  = &mov_ops, },
+	{ .name = "test",  .ops  = &mov_ops, },
+	{ .name = "testb", .ops  = &mov_ops, },
+	{ .name = "testl", .ops  = &mov_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
@@ -323,6 +432,9 @@ void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
 	free(dl->name);
+	free(dl->ops.source.raw);
+	free(dl->ops.source.name);
+	free(dl->ops.target.raw);
 	free(dl->ops.target.name);
 	free(dl);
 }
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index bb0a9f2..066d31d 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -13,10 +13,16 @@ struct ins;
 struct ins_operands {
 	char	*raw;
 	struct {
+		char	*raw;
 		char	*name;
-		u64	offset;
 		u64	addr;
+		u64	offset;
 	} target;
+	struct {
+		char	*raw;
+		char	*name;
+		u64	addr;
+	} source;
 };
 
 struct ins_ops {
-- 
1.7.9.2.358.g22243

