Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab2ENNBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:01:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab2ENNBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:01:47 -0400
Date: Mon, 14 May 2012 06:01:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-xxw4vs5n077tf35jsvjzylhb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Introduce ->free()
  method in ins_ops
Git-Commit-ID: c46219ac34f0f365bac700ca6a10ef979c643233
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:01:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c46219ac34f0f365bac700ca6a10ef979c643233
Gitweb:     http://git.kernel.org/tip/c46219ac34f0f365bac700ca6a10ef979c643233
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 12 May 2012 13:26:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 12 May 2012 13:26:20 -0300

perf annotate: Introduce ->free() method in ins_ops

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
