Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0FAFvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 01:51:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45789 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab0FAFvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 01:51:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: [PATCH 5/5] oom: dump_tasks() use find_lock_task_mm() too
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100601144238.243A.A69D9226@jp.fujitsu.com>
References: <20100601144238.243A.A69D9226@jp.fujitsu.com>
Message-Id: <20100601145033.2446.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  1 Jun 2010 14:51:49 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dump_task() should have the same process iteration logic as
select_bad_process().

It is needed for protecting from task exiting race.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index cbad4d4..a8af9e8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -344,35 +344,30 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
  */
 static void dump_tasks(const struct mem_cgroup *mem)
 {
-	struct task_struct *g, *p;
+	struct task_struct *p;
+	struct task_struct *task;
 
 	printk(KERN_INFO "[ pid ]   uid  tgid total_vm      rss cpu oom_adj "
 	       "name\n");
-	do_each_thread(g, p) {
+
+	for_each_process(p) {
 		struct mm_struct *mm;
 
-		if (mem && !task_in_mem_cgroup(p, mem))
+		if (is_global_init(p) || (p->flags & PF_KTHREAD))
 			continue;
-		if (!thread_group_leader(p))
+		if (mem && !task_in_mem_cgroup(p, mem))
 			continue;
 
-		task_lock(p);
-		mm = p->mm;
-		if (!mm) {
-			/*
-			 * total_vm and rss sizes do not exist for tasks with no
-			 * mm so there's no need to report them; they can't be
-			 * oom killed anyway.
-			 */
-			task_unlock(p);
+		task = find_lock_task_mm(p);
+		if (!task)
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



