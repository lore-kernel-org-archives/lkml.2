Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1HKL0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:26:49 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37492 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab1HKL0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:26:43 -0400
X-AuditID: b753bd60-a3089ba000000655-cd-4e43bc70f483
X-AuditID: b753bd60-a3089ba000000655-cd-4e43bc70f483
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 2/9] [BUGFIX] perf probe: Fix line walker to check CU
 correctly
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 11 Aug 2011 20:02:35 +0900
Message-ID: <20110811110235.19900.20614.stgit@fedora15>
In-Reply-To: <20110811110220.19900.54963.stgit@fedora15>
References: <20110811110220.19900.54963.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix line walker to check whether a given DIE is CU or not.
Actually this function accepts CU, subprogram and
inlined_subroutine DIEs.

Without this fix, perf probe always fails to analyze lines
on inlined functions;

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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
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
 

