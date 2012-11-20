Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2KTRHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:07:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:57471 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab2KTRHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:07:50 -0500
Date: Tue, 20 Nov 2012 18:07:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] perf fixes for 3.7
Message-ID: <alpine.LFD.2.02.1211201806580.2701@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

* Fix to lookup the installed breakpoint(s) on the correct cpu
* Two fixes related to header printout (tools)

Thanks,

	tglx

------------------>
Michael Neuling (1):
      perf, powerpc: Fix hw breakpoints returning -ENOSPC

Namhyung Kim (2):
      perf header: Fix numa topology printing
      perf tools: Fix strbuf_addf() when the buffer needs to grow


 kernel/events/hw_breakpoint.c |   12 +++++++-----
 tools/perf/util/header.c      |    2 ++
 tools/perf/util/strbuf.c      |    8 ++++----
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9a7b487..fe8a916 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -111,14 +111,16 @@ static unsigned int max_task_bp_pinned(int cpu, enum bp_type_idx type)
  * Count the number of breakpoints of the same type and same task.
  * The given event must be not on the list.
  */
-static int task_bp_pinned(struct perf_event *bp, enum bp_type_idx type)
+static int task_bp_pinned(int cpu, struct perf_event *bp, enum bp_type_idx type)
 {
 	struct task_struct *tsk = bp->hw.bp_target;
 	struct perf_event *iter;
 	int count = 0;
 
 	list_for_each_entry(iter, &bp_task_head, hw.bp_list) {
-		if (iter->hw.bp_target == tsk && find_slot_idx(iter) == type)
+		if (iter->hw.bp_target == tsk &&
+		    find_slot_idx(iter) == type &&
+		    cpu == iter->cpu)
 			count += hw_breakpoint_weight(iter);
 	}
 
@@ -141,7 +143,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			slots->pinned += max_task_bp_pinned(cpu, type);
 		else
-			slots->pinned += task_bp_pinned(bp, type);
+			slots->pinned += task_bp_pinned(cpu, bp, type);
 		slots->flexible = per_cpu(nr_bp_flexible[type], cpu);
 
 		return;
@@ -154,7 +156,7 @@ fetch_bp_busy_slots(struct bp_busy_slots *slots, struct perf_event *bp,
 		if (!tsk)
 			nr += max_task_bp_pinned(cpu, type);
 		else
-			nr += task_bp_pinned(bp, type);
+			nr += task_bp_pinned(cpu, bp, type);
 
 		if (nr > slots->pinned)
 			slots->pinned = nr;
@@ -188,7 +190,7 @@ static void toggle_bp_task_slot(struct perf_event *bp, int cpu, bool enable,
 	int old_idx = 0;
 	int idx = 0;
 
-	old_count = task_bp_pinned(bp, type);
+	old_count = task_bp_pinned(cpu, bp, type);
 	old_idx = old_count - 1;
 	idx = old_idx + weight;
 
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 7daad23..566b84c 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1378,6 +1378,8 @@ static void print_numa_topology(struct perf_header *ph, int fd __maybe_unused,
 
 		str = tmp + 1;
 		fprintf(fp, "# node%u cpu list : %s\n", c, str);
+
+		str += strlen(str) + 1;
 	}
 	return;
 error:
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index 2eeb51b..cfa9068 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -90,17 +90,17 @@ void strbuf_addf(struct strbuf *sb, const char *fmt, ...)
 	if (!strbuf_avail(sb))
 		strbuf_grow(sb, 64);
 	va_start(ap, fmt);
-	len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+	len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 	va_end(ap);
 	if (len < 0)
-		die("your vscnprintf is broken");
+		die("your vsnprintf is broken");
 	if (len > strbuf_avail(sb)) {
 		strbuf_grow(sb, len);
 		va_start(ap, fmt);
-		len = vscnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
+		len = vsnprintf(sb->buf + sb->len, sb->alloc - sb->len, fmt, ap);
 		va_end(ap);
 		if (len > strbuf_avail(sb)) {
-			die("this should not happen, your snprintf is broken");
+			die("this should not happen, your vsnprintf is broken");
 		}
 	}
 	strbuf_setlen(sb, sb->len + len);
