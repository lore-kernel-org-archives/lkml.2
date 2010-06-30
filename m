Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0F3J2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:28:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59810 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0F3J2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:28:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 03/11] oom: make oom_unkillable_task() helper function
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630182752.AA4E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:28:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have the same task check in two places. Unify it.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   33 ++++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index dc8589e..a4a5439 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -101,6 +101,26 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
 	return NULL;
 }
 
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
 /**
  * badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
@@ -295,12 +315,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
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
@@ -467,11 +482,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (child->mm == p->mm)
 				continue;
-			if (child->flags & PF_KTHREAD)
-				continue;
-			if (mem && !task_in_mem_cgroup(child, mem))
-				continue;
-			if (!has_intersects_mems_allowed(child, nodemask))
+			if (oom_unkillable_task(p, mem, nodemask))
 				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
-- 
1.6.5.2



