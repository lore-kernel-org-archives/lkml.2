Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab1CXJhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:37:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33250 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab1CXJhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:37:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 18:30:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 5/5] forkbomb killer
Message-Id: <20110324183040.ce3c3b57.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A forkbomb killer implementation.

This patch implements a forkbomb killer which makes use of mm_histroy
record. This calculates badness of each tree of mm_history and kills
all alive processes in the worst tree. This function assumes that
all not-guilty task's mm_history is already removed.

Tested with several known types of forkbombs and works well.

Note:
 This doesn't have memory cgroup support because
   1. it's difficult.
   2. memory cgroup has oom_notify and oom_disable. The userland
      management daemon can do better job than kernels.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/oom_kill.c |  123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

Index: mm-work2/mm/oom_kill.c
===================================================================
--- mm-work2.orig/mm/oom_kill.c
+++ mm-work2/mm/oom_kill.c
@@ -83,6 +83,18 @@ static bool has_intersects_mems_allowed(
 }
 #endif /* CONFIG_NUMA */
 
+#ifdef CONFIG_FORKBOMB_KILLER
+static bool fork_bomb_killer(unsigned long totalpages, struct mem_cgroup *mem,
+                       const nodemask_t *nodemask);
+#else
+static bool fork_bomb_killer(unsigned long totalpages, struct mem_cgroup *mem,
+                       const nodemask_t *nodemask)
+{
+	return false;
+}
+#endif
+
+
 /*
  * If this is a system OOM (not a memcg OOM) and the task selected to be
  * killed is not already running at high (RT) priorities, speed up the
@@ -705,6 +717,10 @@ void out_of_memory(struct zonelist *zone
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
+	if (!sysctl_oom_kill_allocating_task)
+		if (fork_bomb_killer(totalpages, NULL, mpol_mask))
+			return;
+
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&
@@ -963,6 +979,113 @@ static struct mm_history *mm_history_sca
 #define for_each_mm_history_safe(pos, tmp)\
 	for_each_mm_history_safe_under((pos), &init_hist, (tmp))
 
+atomic_t forkbomb_killing;
+bool nobomb = false;
+
+void clear_forkbomb_killing(struct work_struct *w)
+{
+	atomic_set(&forkbomb_killing, 0);
+	nobomb = false;
+}
+DECLARE_DELAYED_WORK(fork_bomb_work, clear_forkbomb_killing);
+
+void reset_forkbomb_killing(void)
+{
+	schedule_delayed_work(&fork_bomb_work, 10*HZ);
+}
+
+static void get_badness_score(struct mm_history *pos, struct mem_cgroup *mem,
+	const nodemask_t *nodemask, unsigned long totalpages)
+{
+	struct task_struct *task;
+
+	if (!pos->mm)
+		return;
+	/* task struct is freed by RCU and we;re under rcu_read_lock() */
+	task = pos->mm->owner;
+	if (task && !oom_unkillable_task(task, mem, nodemask))
+		pos->score += oom_badness(task, mem, nodemask, totalpages);
+}
+
+static void propagate_oom_info(struct mm_history *pos)
+{
+	struct mm_history *ppos;
+
+	ppos = pos->parent;
+	if (ppos == &init_hist) /* deadlink by timeout */
+		return;
+	/* +1 means that the child is a burden of the parent */
+	if (pos->mm) {
+		ppos->score += pos->score + 1;
+		ppos->family += pos->family;
+	} else {
+		ppos->score += pos->score;
+		ppos->family += pos->family;
+	}
+}
+
+static bool fork_bomb_killer(unsigned long totalpages, struct mem_cgroup *mem,
+		const nodemask_t *nodemask)
+{
+	struct mm_history *pos, *bomb;
+	unsigned int max_score;
+	struct task_struct *p;
+
+	if (nobomb || !mm_tracking_enabled)
+		return false;
+
+	if (atomic_inc_return(&forkbomb_killing) != 1)
+		return true;
+	/* reset information */
+	scan_history_lock();
+	nobomb = false;
+	pr_err("forkbomb detection running....\n");
+	for_each_mm_history(pos) {
+		pos->score = 0;
+		if (pos->mm)
+			pos->family = 1;
+		pos->need_to_kill = 0;
+	}
+	max_score = 0;
+	bomb = NULL;
+	for_each_mm_history(pos) {
+		get_badness_score(pos, mem, nodemask, totalpages);
+		propagate_oom_info(pos);
+		if (pos->score > max_score) {
+			bomb = pos;
+			max_score = pos->score;
+		}
+	}
+	if (!bomb || bomb->family < 10) {
+		scan_history_unlock();
+		nobomb = true;
+		reset_forkbomb_killing();
+		pr_err("no forkbomb found \n");
+		return false;
+	}
+
+	pr_err("Possible forkbomb. Killing _all_ doubtful tasks\n");
+	for_each_mm_history_under(pos, bomb) {
+		pos->need_to_kill = 1;
+	}
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		if (!p->mm || oom_unkillable_task(p, mem, nodemask))
+			continue;
+		if (p->signal->oom_score_adj == -1000)
+			continue;
+		if (p->mm->history && p->mm->history->need_to_kill) {
+			pr_err("kill %d(%s)->%ld\n", task_pid_nr(p),
+				p->comm, p->mm->history->score);
+			force_sig(SIGKILL, p);
+		}
+	}
+	read_unlock(&tasklist_lock);
+	scan_history_unlock();
+	reset_forkbomb_killing();
+	return true;
+}
+
 static unsigned long reset_interval_jiffies = 30*HZ;
 unsigned long last_nr_procs;
 unsigned long last_pageout_run;

