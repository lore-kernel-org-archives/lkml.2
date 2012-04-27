Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2D0I1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:27:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34131 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2D0I1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:27:47 -0400
Date: Fri, 27 Apr 2012 01:27:27 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-90ncot487p4h5rzkn8h2whou@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Use the disasm_line instruction name and operand fields
Git-Commit-ID: 657bcaf5097e1aff53d724358deb24ce803f43a4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:27:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  657bcaf5097e1aff53d724358deb24ce803f43a4
Gitweb:     http://git.kernel.org/tip/657bcaf5097e1aff53d724358deb24ce803f43a4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sun, 15 Apr 2012 20:12:07 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Apr 2012 12:16:39 -0300

perf annotate browser: Use the disasm_line instruction name and operand fields

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
 1 files changed, 10 insertions(+), 19 deletions(-)

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
