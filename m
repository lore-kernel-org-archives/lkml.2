Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2DSUfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:35:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab2DSUeU (ORCPT
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
Subject: [PATCH 06/13] perf annotate: Introduce scnprintf ins_ops method
Date: Thu, 19 Apr 2012 17:34:01 -0300
Message-Id: <1334867644-2722-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334867644-2722-1-git-send-email-acme@infradead.org>
References: <1334867644-2722-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

And implement the jump one, where if the operands string is not passed,
a compact form that uses just the target address is used.

Right now this is toggled via the 'o' option in the annotate browser,
switching from:

    0.00 :         ffffffff811661e8:       je     ffffffff81166204 <mem_cgroup_count_vm_event+0x44>
    0.00 :         ffffffff811661ea:       cmp    $0xb,%esi
    0.00 :         ffffffff811661ed:       je     ffffffff811661f8 <mem_cgroup_count_vm_event+0x38>

To:

    0.00 :         28:       je     44
    0.00 :         2a:       cmp    $0xb,%esi
    0.00 :         2d:       je     38

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-o88q46yh4kxgpd1chk5gvjl5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |   13 +++++++++++--
 tools/perf/util/annotate.c        |   10 ++++++++++
 tools/perf/util/annotate.h        |    4 ++++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 46ef966..f7d2db3 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -83,7 +83,7 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 	else if (dl->offset == -1)
 		slsmg_write_nstring(dl->line, width - 18);
 	else {
-		char bf[64];
+		char bf[256], *line = dl->line;
 		u64 addr = dl->offset;
 		int printed, color = -1;
 
@@ -96,7 +96,16 @@ static void annotate_browser__write(struct ui_browser *self, void *entry, int ro
 		slsmg_write_nstring(bf, printed);
 		if (change_color)
 			ui_browser__set_color(self, color);
-		slsmg_write_nstring(dl->line, width - 18 - printed);
+		if (dl->ins && dl->ins->ops->scnprintf) {
+			dl->ins->ops->scnprintf(dl->ins, bf, sizeof(bf),
+						!ab->use_offset ? dl->operands : NULL,
+						dl->target);
+			line = bf;
+			slsmg_write_nstring(" ", 7);
+			printed += 7;
+		}
+
+		slsmg_write_nstring(line, width - 18 - printed);
 	}
 
 	if (current_entry)
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a4296fd..ed1f89d 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -44,8 +44,18 @@ static int jump_ops__parse_target(const char *operands, u64 *target)
 	return 0;
 }
 
+static int jump_ops__scnprintf(struct ins *ins, char *bf, size_t size,
+			       const char *operands, u64 target)
+{
+	if (operands)
+		return scnprintf(bf, size, "%-6.6s %s", ins->name, operands);
+
+	return scnprintf(bf, size, "%-6.6s %" PRIx64, ins->name, target);
+}
+
 static struct ins_ops jump_ops = {
 	.parse_target = jump_ops__parse_target,
+	.scnprintf = jump_ops__scnprintf,
 };
 
 bool ins__is_jump(const struct ins *ins)
diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index a2105f2..6314335 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -7,8 +7,12 @@
 #include <linux/list.h>
 #include <linux/rbtree.h>
 
+struct ins;
+
 struct ins_ops {
 	int (*parse_target)(const char *operands, u64 *target);
+	int (*scnprintf)(struct ins *ins, char *bf, size_t size,
+			 const char *operands, u64 target);
 };
 
 struct ins {
-- 
1.7.9.2.358.g22243

