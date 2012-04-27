Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2D0Io2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:44:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34498 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759860Ab2D0IoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:44:24 -0400
Date: Fri, 27 Apr 2012 01:44:05 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-3nlcmstua75u07ao7wja1rwx@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate:
  Disambiguage offsets and addresses in operands
Git-Commit-ID: 44d1a3edfbd65f9da6725921e2425b10477772d8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 27 Apr 2012 01:44:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44d1a3edfbd65f9da6725921e2425b10477772d8
Gitweb:     http://git.kernel.org/tip/44d1a3edfbd65f9da6725921e2425b10477772d8
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 25 Apr 2012 08:00:23 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Apr 2012 08:00:23 -0300

perf annotate: Disambiguage offsets and addresses in operands

We were using ins_ops->target for callq addresses and jump offsets,
disambiguate by having ins_ops->target.addr and ins_ops->target.offset.

For jumps we'll need both to fixup lines that don't have an offset on
the <> part.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-3nlcmstua75u07ao7wja1rwx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   14 +++++++-------
 tools/perf/util/annotate.c        |   20 ++++++++++----------
 tools/perf/util/annotate.h        |    7 +++++--
 3 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 4c83fe3..73e1ef0 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -112,7 +112,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 			ui_browser__set_color(self, color);
 		if (dl->ins && dl->ins->ops->scnprintf) {
 			if (ins__is_jump(dl->ins)) {
-				bool fwd = dl->ops.target > (u64)dl->offset;
+				bool fwd = dl->ops.target.offset > (u64)dl->offset;
 
 				ui_browser__write_graph(self, fwd ? SLSMG_DARROW_CHAR :
 								    SLSMG_UARROW_CHAR);
@@ -156,7 +156,7 @@ static void annotate_browser__draw_current_loop(struct ui_browser *browser)
 		if (!pos->ins || !ins__is_jump(pos->ins))
 			continue;
 
-		target = ab->offsets[pos->ops.target];
+		target = ab->offsets[pos->ops.target.offset];
 		if (!target)
 			continue;
 
@@ -360,7 +360,7 @@ static bool annotate_browser__callq(struct annotate_browser *browser,
 	if (!ins__is_call(dl->ins))
 		return false;
 
-	ip = ms->map->map_ip(ms->map, dl->ops.target);
+	ip = ms->map->map_ip(ms->map, dl->ops.target.addr);
 	target = map__find_symbol(ms->map, ip, NULL);
 	if (target == NULL) {
 		ui_helpline__puts("The called function was not found.");
@@ -411,7 +411,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 	if (!ins__is_jump(dl->ins))
 		return false;
 
-	dl = annotate_browser__find_offset(browser, dl->ops.target, &idx);
+	dl = annotate_browser__find_offset(browser, dl->ops.target.offset, &idx);
 	if (dl == NULL) {
 		ui_helpline__puts("Invallid jump offset");
 		return true;
@@ -692,14 +692,14 @@ static void annotate_browser__mark_jump_targets(struct annotate_browser *browser
 		if (!dl || !dl->ins || !ins__is_jump(dl->ins))
 			continue;
 
-		if (dl->ops.target >= size) {
+		if (dl->ops.target.offset >= size) {
 			ui__error("jump to after symbol!\n"
 				  "size: %zx, jump target: %" PRIx64,
-				  size, dl->ops.target);
+				  size, dl->ops.target.offset);
 			continue;
 		}
 
-		dlt = browser->offsets[dl->ops.target];
+		dlt = browser->offsets[dl->ops.target.offset];
 		/*
  		 * FIXME: Oops, no jump target? Buggy disassembler? Or do we
  		 * have to adjust to the previous offset?
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index b07d7d1..e1e7d0e 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -22,7 +22,7 @@ static int call__parse(struct ins_operands *ops)
 {
 	char *endptr, *tok, *name;
 
-	ops->target = strtoull(ops->raw, &endptr, 16);
+	ops->target.addr = strtoull(ops->raw, &endptr, 16);
 
 	name = strchr(endptr, '<');
 	if (name == NULL)
@@ -35,17 +35,17 @@ static int call__parse(struct ins_operands *ops)
 		return -1;
 
 	*tok = '\0';
-	ops->target_name = strdup(name);
+	ops->target.name = strdup(name);
 	*tok = '>';
 
-	return ops->target_name == NULL ? -1 : 0;
+	return ops->target.name == NULL ? -1 : 0;
 
 indirect_call:
 	tok = strchr(endptr, '*');
 	if (tok == NULL)
 		return -1;
 
-	ops->target = strtoull(tok + 1, NULL, 16);
+	ops->target.addr = strtoull(tok + 1, NULL, 16);
 	return 0;
 }
 
@@ -55,10 +55,10 @@ static int call__scnprintf(struct ins *ins, char *bf, size_t size,
 	if (addrs)
 		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
 
-	if (ops->target_name)
-		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target_name);
+	if (ops->target.name)
+		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target.name);
 
-	return scnprintf(bf, size, "%-6.6s *%" PRIx64, ins->name, ops->target);
+	return scnprintf(bf, size, "%-6.6s *%" PRIx64, ins->name, ops->target.addr);
 }
 
 static struct ins_ops call_ops = {
@@ -78,7 +78,7 @@ static int jump__parse(struct ins_operands *ops)
 	if (s++ == NULL)
 		return -1;
 
-	ops->target = strtoll(s, NULL, 16);
+	ops->target.offset = strtoll(s, NULL, 16);
 	return 0;
 }
 
@@ -88,7 +88,7 @@ static int jump__scnprintf(struct ins *ins, char *bf, size_t size,
 	if (addrs)
 		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->raw);
 
-	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, ops->target);
+	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, ops->target.offset);
 }
 
 static struct ins_ops jump_ops = {
@@ -289,7 +289,7 @@ void disasm_line__free(struct disasm_line *dl)
 {
 	free(dl->line);
 	free(dl->name);
-	free(dl->ops.target_name);
+	free(dl->ops.target.name);
 	free(dl);
 }
 
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index 8a8af0d..2b9e3e0 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -11,8 +11,11 @@ struct ins;
 
 struct ins_operands {
 	char	*raw;
-	char	*target_name;
-	u64	target;
+	struct {
+		char	*name;
+		u64	offset;
+		u64	addr;
+	} target;
 };
 
 struct ins_ops {
