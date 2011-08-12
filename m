Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1HLQ32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:29:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45360 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab1HLQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf probe: Fix line walker to check CU correctly
Date: Fri, 12 Aug 2011 13:28:57 -0300
Message-Id: <1313166544-6209-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix line walker to check whether a given DIE is CU or not.

Actually this function accepts CU, subprogram and inlined_subroutine
DIEs.

Without this fix, perf probe always fails to analyze lines on inlined
functions;

$ perf probe -L pre_schedule
Debuginfo analysis failed. (-2)
  Error: Failed to show lines. (-2)

This fixes that bug, as below.

$ perf probe -L pre_schedule
<pre_schedule@/home/mhiramat/ksrc/linux-2.6/kernel/sched.c:0>
      0  static inline void pre_schedule(struct rq *rq, struct task_struct *prev
         {
      2         if (prev->sched_class->pre_schedule)
      3                 prev->sched_class->pre_schedule(rq, prev);
         }

         /* rq->lock is NOT held, but preemption is disabled */

Changes from v1:
 - Update against current tip tree.(Fix dwarf-aux.c)

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110235.19900.20614.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index fddf40f..d35b454 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -439,7 +439,7 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 
 /**
  * die_walk_lines - Walk on lines inside given DIE
- * @rt_die: a root DIE (CU or subprogram)
+ * @rt_die: a root DIE (CU, subprogram or inlined_subroutine)
  * @callback: callback routine
  * @data: user data
  *
@@ -460,12 +460,12 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	size_t nlines, i;
 
 	/* Get the CU die */
-	if (dwarf_tag(rt_die) == DW_TAG_subprogram)
+	if (dwarf_tag(rt_die) != DW_TAG_compile_unit)
 		cu_die = dwarf_diecu(rt_die, &die_mem, NULL, NULL);
 	else
 		cu_die = rt_die;
 	if (!cu_die) {
-		pr_debug2("Failed to get CU from subprogram\n");
+		pr_debug2("Failed to get CU from given DIE.\n");
 		return -EINVAL;
 	}
 
-- 
1.6.2.5

