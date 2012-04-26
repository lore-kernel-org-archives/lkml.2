Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab2DZPHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:07:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:53717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092Ab2DZPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:06:31 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf annotate: Disambiguage offsets and addresses in operands
Date: Thu, 26 Apr 2012 12:06:15 -0300
Message-Id: <1335452777-27326-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1335452777-27326-1-git-send-email-acme@infradead.org>
References: <1335452777-27326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.7.9.2.358.g22243

