Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab2ELTya (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51845 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2ELTxV (ORCPT
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
Subject: [PATCH 3/8] perf annotate: Resolve symbols using objdump comment for single op ins
Date: Sat, 12 May 2012 16:53:02 -0300
Message-Id: <1336852387-16322-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336852387-16322-1-git-send-email-acme@infradead.org>
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Starting with inc, incl, dec, decl.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jvh0jspefr5jyn0l7qko12st@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 82c7f63..a6109dc 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -205,6 +205,47 @@ static struct ins_ops mov_ops = {
 	.scnprintf = mov__scnprintf,
 };
 
+static int dec__parse(struct ins_operands *ops)
+{
+	char *target, *comment, *s, prev;
+
+	target = s = ops->raw;
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
+		return -1;
+
+	comment = strchr(s, '#');
+	if (comment == NULL)
+		return 0;
+
+	while (comment[0] != '\0' && isspace(comment[0]))
+		++comment;
+
+	comment__symbol(ops->target.raw, comment, &ops->target.addr, &ops->target.name);
+
+	return 0;
+}
+
+static int dec__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops)
+{
+	return scnprintf(bf, size, "%-6.6s %s", ins->name,
+			 ops->target.name ?: ops->target.raw);
+}
+
+static struct ins_ops dec_ops = {
+	.parse	   = dec__parse,
+	.scnprintf = dec__scnprintf,
+};
+
 static int nop__scnprintf(struct ins *ins __used, char *bf, size_t size,
 			  struct ins_operands *ops __used)
 {
@@ -232,7 +273,11 @@ static struct ins instructions[] = {
 	{ .name = "cmpq",  .ops  = &mov_ops, },
 	{ .name = "cmpw",  .ops  = &mov_ops, },
 	{ .name = "cmpxch", .ops  = &mov_ops, },
+	{ .name = "dec",   .ops  = &dec_ops, },
+	{ .name = "decl",  .ops  = &dec_ops, },
 	{ .name = "imul",  .ops  = &mov_ops, },
+	{ .name = "inc",   .ops  = &dec_ops, },
+	{ .name = "incl",  .ops  = &dec_ops, },
 	{ .name = "ja",	   .ops  = &jump_ops, },
 	{ .name = "jae",   .ops  = &jump_ops, },
 	{ .name = "jb",	   .ops  = &jump_ops, },
-- 
1.7.9.2.358.g22243

