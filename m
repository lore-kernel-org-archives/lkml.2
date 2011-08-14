Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab1HNPlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:41:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:60942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1HNPlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:41:06 -0400
Date: Sun, 14 Aug 2011 15:40:45 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-a128405c6b40371c59c34b00cc66ed06285b9551@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        penberg@kernel.org, masami.hiramatsu@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, masami.hiramatsu@gmail.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811110235.19900.20614.stgit@fedora15>
References: <20110811110235.19900.20614.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix line walker to check CU correctly
Git-Commit-ID: a128405c6b40371c59c34b00cc66ed06285b9551
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:40:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a128405c6b40371c59c34b00cc66ed06285b9551
Gitweb:     http://git.kernel.org/tip/a128405c6b40371c59c34b00cc66ed06285b9551
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 11 Aug 2011 20:02:35 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 09:22:46 -0300

perf probe: Fix line walker to check CU correctly

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
 
