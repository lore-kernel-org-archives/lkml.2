Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab2KIR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:28:42 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2KIR2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:28:39 -0500
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 01/13] perf annotate: Parse --asm-raw output properly
Date: Sat, 10 Nov 2012 02:27:12 +0900
Message-Id: <1352482044-3443-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
References: <1352482044-3443-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If --asm-raw option was given, objdump output will contain hex numbers
of the instruction before the symbolic name.  However current parser
code doesn't handle it properly.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c |    2 ++
 tools/perf/util/annotate.c        |   36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 3eff17f703f3..aec11f34d394 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -117,6 +117,8 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 				    ab->addr_width, " ");
 		slsmg_write_nstring(bf, printed);
 		slsmg_write_nstring(dl->line, width - printed - 6);
+	} else if (!dl->name) {
+		slsmg_write_nstring(" ", width - 7);
 	} else {
 		u64 addr = dl->offset;
 		int color = -1;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index b14d4df9f149..0565558b6184 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -162,7 +162,7 @@ static int comment__symbol(char *raw, char *comment, u64 *addrp, char **namep)
 
 static int lock__parse(struct ins_operands *ops)
 {
-	char *name;
+	char *name = NULL;
 
 	ops->locked.ops = zalloc(sizeof(*ops->locked.ops));
 	if (ops->locked.ops == NULL)
@@ -171,7 +171,10 @@ static int lock__parse(struct ins_operands *ops)
 	if (disasm_line__parse(ops->raw, &name, &ops->locked.ops->raw) < 0)
 		goto out_free_ops;
 
-        ops->locked.ins = ins__find(name);
+	if (name == NULL)
+		goto out_free_ops;
+
+	ops->locked.ins = ins__find(name);
         if (ops->locked.ins == NULL)
                 goto out_free_ops;
 
@@ -492,6 +495,9 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 static void disasm_line__init_ins(struct disasm_line *dl)
 {
+	if (dl->name == NULL)
+		return;
+
 	dl->ins = ins__find(dl->name);
 
 	if (dl->ins == NULL)
@@ -514,6 +520,32 @@ static int disasm_line__parse(char *line, char **namep, char **rawp)
 	if (name[0] == '\0')
 		return -1;
 
+	if (symbol_conf.annotate_asm_raw) {
+		/*
+		 * If --asm-raw option was given, objdump output will contain
+		 * hex numbers of the instructions before the symbolic name.
+		 * They are separated by at least two space characters:
+		 *
+		 *   400540:     48 c7 45 f8 00 00 00    movq   $0x0,-0x8(%rbp)
+		 *   400547:     00
+		 *
+		 * It sometimes was broken to multiple lines due to a limited
+		 * width.  In this case following condition will be met:
+		 *
+		 *   dl->offset != -1 && dl->name == NULL.
+		 */
+		name = strstr(name, "  ");
+		if (name == NULL)
+			return 0;
+
+		while (isspace(name[0]))
+			++name;
+
+		if (name[0] == '\0')
+			return -1;
+
+	}
+
 	*rawp = name + 1;
 
 	while ((*rawp)[0] != '\0' && !isspace((*rawp)[0]))
-- 
1.7.9.2

