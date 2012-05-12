Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab2ELTyW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 15:54:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51847 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2ELTxV (ORCPT
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
Subject: [PATCH 5/8] perf annotate: Introduce ->free() method in ins_ops
Date: Sat, 12 May 2012 16:53:04 -0300
Message-Id: <1336852387-16322-6-git-send-email-acme@infradead.org>
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

So that we don't special case disasm_line__free, allowing each
instruction class to provide an specialized destructor, like is needed
for 'lock'.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xxw4vs5n077tf35jsvjzylhb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   28 ++++++++++++++++++++--------
 tools/perf/util/annotate.h |    1 +
 2 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 1dce098..8069dfb 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -21,6 +21,14 @@ const char 	*disassembler_style;
 static struct ins *ins__find(const char *name);
 static int disasm_line__parse(char *line, char **namep, char **rawp);
 
+static void ins__delete(struct ins_operands *ops)
+{
+	free(ops->source.raw);
+	free(ops->source.name);
+	free(ops->target.raw);
+	free(ops->target.name);
+}
+
 static int ins__raw_scnprintf(struct ins *ins, char *bf, size_t size,
 			      struct ins_operands *ops)
 {
@@ -192,7 +200,15 @@ static int lock__scnprintf(struct ins *ins, char *bf, size_t size,
 					size - printed, ops->locked.ops);
 }
 
+static void lock__delete(struct ins_operands *ops)
+{
+	free(ops->locked.ops);
+	free(ops->target.raw);
+	free(ops->target.name);
+}
+
 static struct ins_ops lock_ops = {
+	.free	   = lock__delete,
 	.parse	   = lock__parse,
 	.scnprintf = lock__scnprintf,
 };
@@ -542,14 +558,10 @@ void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
 	free(dl->name);
-	if (dl->ins && dl->ins->ops == &lock_ops) {
-		free(dl->ops.locked.ops);
-	} else {
-		free(dl->ops.source.raw);
-		free(dl->ops.source.name);
-	}
-	free(dl->ops.target.raw);
-	free(dl->ops.target.name);
+	if (dl->ins && dl->ins->ops->free)
+		dl->ins->ops->free(&dl->ops);
+	else
+		ins__delete(&dl->ops);
 	free(dl);
 }
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b79d326..78a5692 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -32,6 +32,7 @@ struct ins_operands {
 };
 
 struct ins_ops {
+	void (*free)(struct ins_operands *ops);
 	int (*parse)(struct ins_operands *ops);
 	int (*scnprintf)(struct ins *ins, char *bf, size_t size,
 			 struct ins_operands *ops);
-- 
1.7.9.2.358.g22243

