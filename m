Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626Ab1ETIFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:05:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53156 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410Ab1ETIFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:05:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD620AE.7020308@jp.fujitsu.com>
Date: Fri, 20 May 2011 17:05:02 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: kosaki.motohiro@jp.fujitsu.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        minchan.kim@gmail.com, oleg@redhat.com
Subject: [PATCH 5/5] oom: merge oom_kill_process() with oom_kill_task()
References: <4DD61F80.1020505@jp.fujitsu.com>
In-Reply-To: <4DD61F80.1020505@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, oom_kill_process() become almost empty function. Let's
merge it with oom_kill_task().

Also, this patch replace task_pid_nr() with task_tgid_nr().
Because 1) oom killer kill a process, not thread. 2) a userland
don't care thread id.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |   53 ++++++++++++++++++++++-------------------------------
 1 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 7d280d4..ec075cc 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -458,11 +458,26 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 }

 #define K(x) ((x) << (PAGE_SHIFT-10))
-static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
+static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
+			    unsigned long points, unsigned long totalpages,
+			    struct mem_cgroup *mem, nodemask_t *nodemask,
+			    const char *message)
 {
 	struct task_struct *q;
 	struct mm_struct *mm;

+	if (printk_ratelimit())
+		dump_header(p, gfp_mask, order, mem, nodemask);
+
+	/*
+	 * If the task is already exiting, don't alarm the sysadmin or kill
+	 * its children or threads, just set TIF_MEMDIE so it can die quickly
+	 */
+	if (p->flags & PF_EXITING) {
+		set_tsk_thread_flag(p, TIF_MEMDIE);
+		return 0;
+	}
+
 	p = find_lock_task_mm(p);
 	if (!p)
 		return 1;
@@ -470,10 +485,11 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 	/* mm cannot be safely dereferenced after task_unlock(p) */
 	mm = p->mm;

-	pr_err("Killed process %d (%s) total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
-		task_pid_nr(p), p->comm, K(p->mm->total_vm),
-		K(get_mm_counter(p->mm, MM_ANONPAGES)),
-		K(get_mm_counter(p->mm, MM_FILEPAGES)));
+	pr_err("%s: Kill process %d (%s) points:%lu total-vm:%lukB, anon-rss:%lukB, file-rss:%lukB\n",
+	       message, task_tgid_nr(p), p->comm, points,
+	       K(p->mm->total_vm),
+	       K(get_mm_counter(p->mm, MM_ANONPAGES)),
+	       K(get_mm_counter(p->mm, MM_FILEPAGES)));
 	task_unlock(p);

 	/*
@@ -490,7 +506,7 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 		if (q->mm == mm && !same_thread_group(q, p)) {
 			task_lock(q);	/* Protect ->comm from prctl() */
 			pr_err("Kill process %d (%s) sharing same memory\n",
-				task_pid_nr(q), q->comm);
+				task_tgid_nr(q), q->comm);
 			task_unlock(q);
 			force_sig(SIGKILL, q);
 		}
@@ -502,31 +518,6 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 }
 #undef K

-static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			    unsigned long points, unsigned long totalpages,
-			    struct mem_cgroup *mem, nodemask_t *nodemask,
-			    const char *message)
-{
-	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, mem, nodemask);
-
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just set TIF_MEMDIE so it can die quickly
-	 */
-	if (p->flags & PF_EXITING) {
-		set_tsk_thread_flag(p, TIF_MEMDIE);
-		return 0;
-	}
-
-	task_lock(p);
-	pr_err("%s: Kill process %d (%s) points %lu\n",
-	       message, task_pid_nr(p), p->comm, points);
-	task_unlock(p);
-
-	return oom_kill_task(p, mem);
-}
-
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-- 
1.7.3.1



