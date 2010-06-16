Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab0FPLdX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 07:33:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33477 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757905Ab0FPLdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 07:33:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 5/9] oom: make oom_unkillable_task() helper function
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
References: <20100616201948.72D7.A69D9226@jp.fujitsu.com>
Message-Id: <20100616203247.72E3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 16 Jun 2010 20:33:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Now, we have the same task check in three places. Unify it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   39 +++++++++++++++++++++++----------------
 1 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3e48023..12204c7 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -276,6 +276,26 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
 }
 #endif
 
+/* return true if the task is not adequate as candidate victim task. */
+static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
+			   const nodemask_t *nodemask)
+{
+	if (is_global_init(p))
+		return true;
+	if (p->flags & PF_KTHREAD)
+		return true;
+
+	/* When mem_cgroup_out_of_memory() and p is not member of the group */
+	if (mem && !task_in_mem_cgroup(p, mem))
+		return true;
+
+	/* p may not have freeable memory in nodemask */
+	if (!has_intersects_mems_allowed(p, nodemask))
+		return true;
+
+	return false;
+}
+
 /*
  * Simple selection loop. We chose the process with the highest
  * number of 'points'. We expect the caller will lock the tasklist.
@@ -294,12 +314,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 	for_each_process(p) {
 		unsigned long points;
 
-		/* skip the init task and kthreads */
-		if (is_global_init(p) || (p->flags & PF_KTHREAD))
-			continue;
-		if (mem && !task_in_mem_cgroup(p, mem))
-			continue;
-		if (!has_intersects_mems_allowed(p, nodemask))
+		if (oom_unkillable_task(p, mem, nodemask))
 			continue;
 
 		/*
@@ -440,11 +455,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 * When oom_kill_allocating_task is enabled, p can be
 	 * unkillable. check it first.
 	 */
-	if (is_global_init(p) || (p->flags & PF_KTHREAD))
-		return 1;
-	if (mem && !task_in_mem_cgroup(p, mem))
-		return 1;
-	if (!has_intersects_mems_allowed(p, nodemask))
+	if (oom_unkillable_task(p, mem, nodemask))
 		return 1;
 
 	if (printk_ratelimit())
@@ -477,11 +488,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (child->mm == p->mm)
 				continue;
-			if (child->flags & PF_KTHREAD)
-				continue;
-			if (mem && !task_in_mem_cgroup(child, mem))
-				continue;
-			if (!has_intersects_mems_allowed(child, nodemask))
+			if (oom_unkillable_task(child, mem, nodemask))
 				continue;
 
 			/* oom_badness() returns 0 if the thread is unkillable */
-- 
1.6.5.2



