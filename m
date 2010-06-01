Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab0FAFrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:47:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43869 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab0FAFrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:47:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 1/5] oom: make oom_unkillable() helper function
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20100601144238.243A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 14:46:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series was made on top yesterday oom pile
=====================================================================

Now, sysctl_oom_kill_allocating_task case and CONSTRAINT_MEMORY_POLICY
case don't call select_bad_process(). then, oom_kill_process() need
very similar check for distinguish unkillable tasks.

This patch unify such two logic.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   62 ++++++++++++++++++++++++--------------------------------
 1 files changed, 27 insertions(+), 35 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f6aa3fc..bac4515 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -250,6 +250,21 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 }
 #endif
 
+int oom_unkillable(struct task_struct *p, struct mem_cgroup *mem)
+{
+	/* skip the init task and kthreads */
+	if (is_global_init(p) || (p->flags & PF_KTHREAD))
+		return 1;
+
+	if (mem && !task_in_mem_cgroup(p, mem))
+		return 1;
+
+	if (p->signal->oom_adj == OOM_DISABLE)
+		return 1;
+
+	return 0;
+}
+
 /*
  * Simple selection loop. We chose the process with the highest
  * number of 'points'. We expect the caller will lock the tasklist.
@@ -268,10 +283,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 	for_each_process(p) {
 		unsigned long points;
 
-		/* skip the init task and kthreads */
-		if (is_global_init(p) || (p->flags & PF_KTHREAD))
-			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
+		if (oom_unkillable(p, mem))
 			continue;
 
 		/*
@@ -304,9 +316,6 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 			*ppoints = ULONG_MAX;
 		}
 
-		if (p->signal->oom_adj == OOM_DISABLE)
-			continue;
-
 		points = badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
@@ -386,20 +395,18 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
  * flag though it's unlikely that  we select a process with CAP_SYS_RAW_IO
  * set.
  */
-static void __oom_kill_task(struct task_struct *p, int verbose)
+static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem,
+			      int verbose)
 {
-	if (is_global_init(p)) {
-		WARN_ON(1);
-		printk(KERN_WARNING "tried to kill init!\n");
-		return;
-	}
+	if (oom_unkillable(p, mem))
+		return 1;
 
 	p = find_lock_task_mm(p);
 	if (!p) {
 		WARN_ON(1);
 		printk(KERN_WARNING "tried to kill an mm-less task %d (%s)!\n",
 			task_pid_nr(p), p->comm);
-		return;
+		return 1;
 	}
 
 	if (verbose)
@@ -420,22 +427,6 @@ static void __oom_kill_task(struct task_struct *p, int verbose)
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);
-}
-
-static int oom_kill_task(struct task_struct *p)
-{
-	/* WARNING: mm may not be dereferenced since we did not obtain its
-	 * value from get_task_mm(p).  This is OK since all we need to do is
-	 * compare mm to q->mm below.
-	 *
-	 * Furthermore, even if mm contains a non-NULL value, p->mm may
-	 * change to NULL at any time since we do not hold task_lock(p).
-	 * However, this is of no concern to us.
-	 */
-	if (!p->mm || p->signal->oom_adj == OOM_DISABLE)
-		return 1;
-
-	__oom_kill_task(p, 1);
 
 	return 0;
 }
@@ -454,7 +445,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
 	 */
 	if (p->flags & PF_EXITING) {
-		__oom_kill_task(p, 0);
+		__oom_kill_process(p, mem, 0);
 		return 0;
 	}
 
@@ -465,12 +456,13 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	list_for_each_entry(c, &p->children, sibling) {
 		if (c->mm == p->mm)
 			continue;
-		if (mem && !task_in_mem_cgroup(c, mem))
-			continue;
-		if (!oom_kill_task(c))
+
+		/* Ok, Kill the child */
+		if (!__oom_kill_process(c, mem, 1))
 			return 0;
 	}
-	return oom_kill_task(p);
+
+	return __oom_kill_process(p, mem, 1);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-- 
1.6.5.2



