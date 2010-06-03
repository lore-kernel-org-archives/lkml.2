Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab0FCG0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:26:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46562 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab0FCG0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:26:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 10/12] oom: sacrifice child with highest badness score for parent
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603152518.7265.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 15:26:05 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>

When a task is chosen for oom kill, the oom killer first attempts to
sacrifice a child not sharing its parent's memory instead.
Unfortunately, this often kills in a seemingly random fashion based
on the ordering of the selected task's child list. Additionally, it
is not guaranteed at all to free a large amount of memory that we need
to prevent additional oom killing in the very near future.

Instead, we now only attempt to sacrifice the worst child not sharing
its parent's memory, if one exists.  The worst child is indicated with
the highest badness() score.  This serves two advantages: we kill a
memory-hogging task more often, and we allow the configurable
/proc/pid/oom_adj value to be considered as a factor in which child to
kill.

Reviewers may observe that the previous implementation would iterate
through the children and attempt to kill each until one was successful
and then the parent if none were found while the new code simply kills
the most memory-hogging task or the parent.  Note that the only time
__oom_kill_process() fails, however, is when a child does not have an
mm or has a /proc/pid/oom_adj of OOM_DISABLE. badness() returns 0 for both
cases, so the final __oom_kill_process() will always succeed.

Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   23 ++++++++++++++++-------
 1 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d723fb..e4c6141 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -422,26 +422,35 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 {
 	struct task_struct *c;
 	struct task_struct *t = p;
+	struct task_struct *victim = p;
+	unsigned long victim_points = 0;
+	struct timespec uptime;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem);
 
-	printk(KERN_ERR "%s: kill process %d (%s) score %li or a child\n",
-					message, task_pid_nr(p), p->comm, points);
+	pr_err("%s: Kill process %d (%s) with score %lu or sacrifice child\n",
+	       message, task_pid_nr(p), p->comm, points);
 
-	/* Try to kill a child first */
+	do_posix_clock_monotonic_gettime(&uptime);
+	/* Try to sacrifice the worst child first */
 	do {
 		list_for_each_entry(c, &t->children, sibling) {
+			unsigned long cpoints;
+
 			if (c->mm == p->mm)
 				continue;
 
-			/* Ok, Kill the child */
-			if (!__oom_kill_process(c, mem, 1))
-				return 0;
+			/* badness() returns 0 if the thread is unkillable */
+			cpoints = badness(c, uptime.tv_sec);
+			if (cpoints > victim_points) {
+				victim = c;
+				victim_points = cpoints;
+			}
 		}
 	} while_each_thread(p, t);
 
-	return __oom_kill_process(p, mem, 1);
+	return __oom_kill_process(victim, mem, 1);
 }
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR
-- 
1.6.5.2



