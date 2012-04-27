Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab2D0I3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:29:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34178 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2D0I30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:29:26 -0400
Date: Fri, 27 Apr 2012 01:29:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ybgss44m5ycry8mk7b1qdbre@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Parse call targets earlier
Git-Commit-ID: d86b0597c4bd41ea3edc6446a855306eed34f93b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:29:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d86b0597c4bd41ea3edc6446a855306eed34f93b
Gitweb:     http://git.kernel.org/tip/d86b0597c4bd41ea3edc6446a855306eed34f93b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 18 Apr 2012 16:07:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 18 Apr 2012 16:07:38 -0300

perf annotate: Parse call targets earlier

No need to do it everytime the user presses enter/-> on a call
instruction.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ybgss44m5ycry8mk7b1qdbre@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   10 +++++-----
 tools/perf/util/annotate.c        |   18 +++++++++++++++++-
 tools/perf/util/annotate.h        |    1 +
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index bdbb54f..46ef966 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -266,11 +266,10 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	struct symbol *target;
 	u64 ip;
 
-	if (strcmp(dl->name, "callq"))
+	if (!ins__is_call(dl->ins))
 		return false;
 
-	ip = strtoull(dl->operands, NULL, 16);
-	ip = ms->map->map_ip(ms->map, ip);
+	ip = ms->map->map_ip(ms->map, dl->target);
 	target = map__find_symbol(ms->map, ip, NULL);
 	if (target == NULL) {
 		ui_helpline__puts("The called function was not found.");
@@ -318,7 +317,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 	struct disasm_line *dl = browser->selection;
 	s64 idx;
 
-	if (!dl->ins || !ins__is_jump(dl->ins))
+	if (!ins__is_jump(dl->ins))
 		return false;
 
 	dl = annotate_browser__find_offset(browser, dl->target, &idx);
@@ -556,7 +555,8 @@ show_help:
 				ui_helpline__puts("Huh? No selection. Report to linux-kernel@vger.kernel.org");
 			else if (self->selection->offset == -1)
 				ui_helpline__puts("Actions are only available for assembly lines.");
-			else if (!(annotate_browser__jump(self) ||
+			else if (!self->selection->ins ||
+				 !(annotate_browser__jump(self) ||
 				   annotate_browser__callq(self, evidx, timer, arg, delay_secs)))
 				ui_helpline__puts("Actions are only available for the 'callq' and jump instructions.");
 			continue;
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 4ee2c07..a4296fd 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -18,6 +18,21 @@
 
 const char 	*disassembler_style;
 
+static int call_ops__parse_target(const char *operands, u64 *target)
+{
+	*target = strtoull(operands, NULL, 16);
+	return 0;
+}
+
+static struct ins_ops call_ops = {
+	.parse_target = call_ops__parse_target,
+};
+
+bool ins__is_call(const struct ins *ins)
+{
+	return ins->ops == &call_ops;
+}
+
 static int jump_ops__parse_target(const char *operands, u64 *target)
 {
 	const char *s = strchr(operands, '+');
@@ -38,11 +53,12 @@ bool ins__is_jump(const struct ins *ins)
 	return ins->ops == &jump_ops;
 }
 
-
 /*
  * Must be sorted by name!
  */
 static struct ins instructions[] = {
+	{ .name = "call",  .ops  = &call_ops, },
+	{ .name = "callq", .ops  = &call_ops, },
 	{ .name = "ja",	   .ops  = &jump_ops, },
 	{ .name = "je",	   .ops  = &jump_ops, },
 	{ .name = "jmp",   .ops  = &jump_ops, },
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 934c6fe..a2105f2 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -17,6 +17,7 @@ struct ins {
 };
 
 bool ins__is_jump(const struct ins *ins);
+bool ins__is_call(const struct ins *ins);
 
 struct disasm_line {
 	struct list_head node;
