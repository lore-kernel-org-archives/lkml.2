Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2EHPLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:11:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57028 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526Ab2EHPL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:11:29 -0400
Date: Tue, 8 May 2012 08:11:05 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8mfairi2n1nentoa852alazv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Do raw printing in 'o'
 ffset in a single place
Git-Commit-ID: 5417072bf6b17eaa31f21f12906f381f148b5200
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:11:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5417072bf6b17eaa31f21f12906f381f148b5200
Gitweb:     http://git.kernel.org/tip/5417072bf6b17eaa31f21f12906f381f148b5200
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 7 May 2012 18:54:16 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 18:54:16 -0300

perf annotate browser: Do raw printing in 'o'ffset in a single place

Instead of doing the same in all ins scnprintf methods.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8mfairi2n1nentoa852alazv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 +-----
 tools/perf/util/annotate.c        |   33 +++++++++++++++++++++++++--------
 tools/perf/util/annotate.h        |    4 +++-
 3 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index b94da57..f171b46 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -125,9 +125,6 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			} else {
 				slsmg_write_nstring(" ", 2);
 			}
-
-			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf), &dl->ops,
-						!ab->use_offset);
 		} else {
 			if (strcmp(dl->name, "retq")) {
 				slsmg_write_nstring(" ", 2);
@@ -135,10 +132,9 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 				ui_browser__write_graph(self, SLSMG_LARROW_CHAR);
 				SLsmg_write_char(' ');
 			}
-
-			scnprintf(bf, sizeof(bf), "%-6.6s %s", dl->name, dl->ops.raw);
 		}
 
+		disasm_line__scnprintf(dl, bf, sizeof(bf), !ab->use_offset);
 		slsmg_write_nstring(bf, width - 10 - printed);
 	}
 
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 5eb3412..0905db4 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,21 @@
 
 const char 	*disassembler_style;
 
+static int ins__raw_scnprintf(struct ins *ins, char *bf, size_t size,
+			      struct ins_operands *ops)
+{
+	return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
+}
+
+int ins__scnprintf(struct ins *ins, char *bf, size_t size,
+		  struct ins_operands *ops)
+{
+	if (ins->ops->scnprintf)
+		return ins->ops->scnprintf(ins, bf, size, ops);
+
+	return ins__raw_scnprintf(ins, bf, size, ops);
+}
+
 static int call__parse(struct ins_operands *ops)
 {
 	char *endptr, *tok, *name;
@@ -50,11 +65,8 @@ indirect_call:
 }
 
 static int call__scnprintf(struct ins *ins, char *bf, size_t size,
-			   struct ins_operands *ops, bool addrs)
+			   struct ins_operands *ops)
 {
-	if (addrs)
-		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
-
 	if (ops->target.name)
 		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target.name);
 
@@ -86,11 +98,8 @@ static int jump__parse(struct ins_operands *ops)
 }
 
 static int jump__scnprintf(struct ins *ins, char *bf, size_t size,
-			   struct ins_operands *ops, bool addrs)
+			   struct ins_operands *ops)
 {
-	if (addrs)
-		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
-
 	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, ops->target.offset);
 }
 
@@ -296,6 +305,14 @@ void disasm_line__free(struct disasm_line *dl)
 	free(dl);
 }
 
+int disasm_line__scnprintf(struct disasm_line *dl, char *bf, size_t size, bool raw)
+{
+	if (raw || !dl->ins)
+		return scnprintf(bf, size, "%-6.6s %s", dl->name, dl->ops.raw);
+
+	return ins__scnprintf(dl->ins, bf, size, &dl->ops);
+}
+
 static void disasm__add(struct list_head *head, struct disasm_line *line)
 {
 	list_add_tail(&line->node, head);
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 13a21f1..bb0a9f2 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -22,7 +22,7 @@ struct ins_operands {
 struct ins_ops {
 	int (*parse)(struct ins_operands *ops);
 	int (*scnprintf)(struct ins *ins, char *bf, size_t size,
-			 struct ins_operands *ops, bool addrs);
+			 struct ins_operands *ops);
 };
 
 struct ins {
@@ -32,6 +32,7 @@ struct ins {
 
 bool ins__is_jump(const struct ins *ins);
 bool ins__is_call(const struct ins *ins);
+int ins__scnprintf(struct ins *ins, char *bf, size_t size, struct ins_operands *ops);
 
 struct disasm_line {
 	struct list_head    node;
@@ -49,6 +50,7 @@ static inline bool disasm_line__has_offset(const struct disasm_line *dl)
 
 void disasm_line__free(struct disasm_line *dl);
 struct disasm_line *disasm__get_next_ip_line(struct list_head *head, struct disasm_line *pos);
+int disasm_line__scnprintf(struct disasm_line *dl, char *bf, size_t size, bool raw);
 size_t disasm__fprintf(struct list_head *head, FILE *fp);
 
 struct sym_hist {
