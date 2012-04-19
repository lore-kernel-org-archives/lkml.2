Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581Ab2DSUfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:35:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33517 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343Ab2DSUeU (ORCPT
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
Subject: [PATCH 03/13] perf annotate browser: Use the disasm_line instruction name and operand fields
Date: Thu, 19 Apr 2012 17:33:58 -0300
Message-Id: <1334867644-2722-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

No need to reparse it everytime.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-90ncot487p4h5rzkn8h2whou@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index bc540b1..0bc3e65 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -260,22 +260,16 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 				    void *arg, int delay_secs)
 {
 	struct map_symbol *ms = browser->b.priv;
+	struct disasm_line *dl = browser->selection;
 	struct symbol *sym = ms->sym;
 	struct annotation *notes;
 	struct symbol *target;
-	char *s = strstr(browser->selection->line, "callq ");
 	u64 ip;
 
-	if (s == NULL)
+	if (strcmp(dl->name, "callq"))
 		return false;
 
-	s = strchr(s, ' ');
-	if (s++ == NULL) {
-		ui_helpline__puts("Invallid callq instruction.");
-		return true;
-	}
-
-	ip = strtoull(s, NULL, 16);
+	ip = strtoull(dl->operands, NULL, 16);
 	ip = ms->map->map_ip(ms->map, ip);
 	target = map__find_symbol(ms->map, ip, NULL);
 	if (target == NULL) {
@@ -321,22 +315,19 @@ struct disasm_line *annotate_browser__find_offset(struct annotate_browser *brows
 
 static bool annotate_browser__jump(struct annotate_browser *browser)
 {
-	const char *jumps[] = { "je ", "jne ", "ja ", "jmpq ", "js ", "jmp ", NULL };
-	struct disasm_line *dl;
+	const char *jumps[] = { "je", "jne", "ja", "jmpq", "js", "jmp", NULL };
+	struct disasm_line *dl = browser->selection;
 	s64 idx, offset;
-	char *s = NULL;
+	char *s;
 	int i = 0;
 
-	while (jumps[i]) {
-		s = strstr(browser->selection->line, jumps[i++]);
-		if (s)
-			break;
-	}
+	while (jumps[i] && strcmp(dl->name, jumps[i]))
+		++i;
 
-	if (s == NULL)
+	if (jumps[i] == NULL)
 		return false;
 
-	s = strchr(s, '+');
+	s = strchr(dl->operands, '+');
 	if (s++ == NULL) {
 		ui_helpline__puts("Invallid jump instruction.");
 		return true;
-- 
1.7.9.2.358.g22243

