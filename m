Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab0FCGYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 02:24:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54587 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab0FCGYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 02:24:43 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 08/12] oom: dump_tasks() use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100603135106.7247.A69D9226@jp.fujitsu.com>
References: <20100603135106.7247.A69D9226@jp.fujitsu.com>
Message-Id: <20100603152350.725F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Jun 2010 15:24:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_task() should use find_lock_task_mm() too. It is necessary for
protecting task-exiting race.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 35a2ecc..6360c56 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -345,35 +345,38 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
  */
 static void dump_tasks(const struct mem_cgroup *mem)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
+	struct task_struct *task;
 
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
-	do_each_thread(g, p) {
-		struct mm_struct *mm;
 
-		if (mem && !task_in_mem_cgroup(p, mem))
+	for_each_process(p) {
+		/*
+		 * We don't have is_global_init() check here, because the old
+		 * code do that. printing init process is not big matter. But 
+		 * we don't hope to make unnecessary compatiblity breaking.
+		 */
+		if (p->flags & PF_KTHREAD)
 			continue;
-		if (!thread_group_leader(p))
+		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
-		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
+		task = find_lock_task_mm(p);
+		if (!task)
 			/*
-			 * total_vm and rss sizes do not exist for tasks with no
-			 * mm so there's no need to report them; they can't be
-			 * oom killed anyway.
+			 * Probably oom vs task-exiting race was happen and ->mm
+			 * have been detached. thus there's no need to report them;
+			 * they can't be oom killed anyway.
 			 */
-			task_unlock(p);
 			continue;
-		}
+
 		printk(KERN_INFO "[%5d] %5d %5d %8lu %8lu %3d     %3d %s\n",
-		       p->pid, __task_cred(p)->uid, p->tgid, mm->total_vm,
-		       get_mm_rss(mm), (int)task_cpu(p), p->signal->oom_adj,
+		       task->pid, __task_cred(task)->uid, task->tgid, task->mm->total_vm,
+		       get_mm_rss(task->mm), (int)task_cpu(task), task->signal->oom_adj,
 		       p->comm);
-		task_unlock(p);
-	} while_each_thread(g, p);
+		task_unlock(task);
+	}
 }
 
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
-- 
1.6.5.2



