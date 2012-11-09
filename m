Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2KIBKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 20:10:40 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:56025 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab2KIBKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 20:10:39 -0500
X-AuditID: 9c93016f-b7bccae000000e33-6e-509c580c7c7b
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] perf annotate: Parse --asm-raw output properly
Date: Fri,  9 Nov 2012 10:10:10 +0900
Message-Id: <1352423412-4895-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If --asm-raw option was given, objdump output will contain hex numbers
of the instruction before the symbolic name.  However current parser
code doesn't handle it properly.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/annotate.c |  2 ++
 tools/perf/util/annotate.c        | 29 +++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

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
index b14d4df9f149..83b1078260e3 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -492,6 +492,9 @@ int symbol__inc_addr_samples(struct symbol *sym, struct map *map,
 
 static void disasm_line__init_ins(struct disasm_line *dl)
 {
+	if (dl->name == NULL)
+		return;
+
 	dl->ins = ins__find(dl->name);
 
 	if (dl->ins == NULL)
@@ -514,6 +517,32 @@ static int disasm_line__parse(char *line, char **namep, char **rawp)
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
1.7.11.7

