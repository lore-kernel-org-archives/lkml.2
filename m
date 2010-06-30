Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab0F3J1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:27:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50639 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812Ab0F3J1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:27:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 01/11] oom: don't try to kill oom_unkillable child
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630182621.AA48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:27:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, badness() doesn't care neigher CPUSET nor mempolicy. Then
if the victim child process have disjoint nodemask, OOM Killer might
kill innocent process.

This patch fixes it.

Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 26ae697..0aeacb2 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -429,7 +429,7 @@ static int oom_kill_task(struct task_struct *p)
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			    unsigned long points, struct mem_cgroup *mem,
-			    const char *message)
+			    nodemask_t *nodemask, const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
@@ -469,6 +469,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 				continue;
 			if (mem && !task_in_mem_cgroup(child, mem))
 				continue;
+			if (!has_intersects_mems_allowed(child, nodemask))
+				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
 			child_points = badness(child, uptime.tv_sec);
@@ -519,7 +521,7 @@ retry:
 	if (!p || PTR_ERR(p) == -1UL)
 		goto out;
 
-	if (oom_kill_process(p, gfp_mask, 0, points, mem,
+	if (oom_kill_process(p, gfp_mask, 0, points, mem, NULL,
 				"Memory cgroup out of memory"))
 		goto retry;
 out:
@@ -678,7 +680,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		 * non-zero, current could not be killed so we must fallback to
 		 * the tasklist scan.
 		 */
-		if (!oom_kill_process(current, gfp_mask, order, 0, NULL,
+		if (!oom_kill_process(current, gfp_mask, order, 0, NULL, nodemask,
 				"Out of memory (oom_kill_allocating_task)"))
 			return;
 	}
@@ -697,7 +699,7 @@ retry:
 		panic("Out of memory and no killable processes...\n");
 	}
 
-	if (oom_kill_process(p, gfp_mask, order, points, NULL,
+	if (oom_kill_process(p, gfp_mask, order, points, NULL, nodemask,
 			     "Out of memory"))
 		goto retry;
 	read_unlock(&tasklist_lock);
-- 
1.6.5.2



