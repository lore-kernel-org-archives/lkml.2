Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1CWEgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:36:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60368 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1CWEgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:36:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Mar 2011 13:30:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>, avagin@openvz.org,
        kirill@shutemov.name
Subject: [RFC][PATCH 3/3] forkbomb: forkbomb killer
Message-Id: <20110323133008.13756f48.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110323132323.f223fc6d.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110323132323.f223fc6d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A forkbomb killer.

This routine walks all mm_record from a child -> its parent direction
and calculated the score of badness of mm_record tree. And this will
select the worst mm_record tree, Send SIGKILL to all process in
mm_record tree.

mm_record of tasks are under aging system and this will not kill
tasks enough living long (in stable system).

Tested with
  # forkbomb(){ forkbomb|forkbomb & } ; forkbomb
  # make -j kernel
  and other bombs.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/oom_kill.c |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

Index: mm-work/mm/oom_kill.c
===================================================================
--- mm-work.orig/mm/oom_kill.c
+++ mm-work/mm/oom_kill.c
@@ -570,6 +570,121 @@ static struct task_struct *select_bad_pr
 	return chosen;
 }
 
+#ifdef CONFIG_FORKBOMB_KILLER
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
+static void get_badness_score(struct mm_record *pos, struct mem_cgroup *mem,
+	const nodemask_t *nodemask, unsigned long totalpages)
+{
+	struct task_struct *task;
+
+	if (!pos->mm)
+		return;
+	/* task struct is freed by RCU and we;re under rcu_read_lock() */
+	task = pos->mm->owner;
+	if (task && !oom_unkillable_task(task, mem, nodemask))
+		pos->oom_score += oom_badness(task, mem, nodemask, totalpages);
+}
+
+static void propagate_oom_info(struct mm_record *pos)
+{
+	struct mm_record *ppos;
+
+	ppos = pos->parent;
+	if (ppos == &init_rec) /* deadlink by timeout */
+		return;
+	/* +1 means that the child is a burden of the parent */
+	if (pos->mm) {
+		ppos->oom_score += pos->oom_score + 1;
+		ppos->oom_family += pos->oom_family;
+	} else {
+		ppos->oom_score += pos->oom_score;
+		ppos->oom_family += pos->oom_family;
+	}
+}
+
+static bool fork_bomb_killer(unsigned long totalpages, struct mem_cgroup *mem,
+		const nodemask_t *nodemask)
+{
+	struct mm_record *pos, *bomb;
+	unsigned int max_score;
+	struct task_struct *p;
+
+	if (nobomb)
+		return false;
+
+	if (atomic_inc_return(&forkbomb_killing) != 1)
+		return true;
+	/* reset information */
+	mm_rec_scan_lock();
+	nobomb = false;
+	pr_err("forkbomb detection running....\n");
+	for_each_mm_record(pos) {
+		pos->oom_score = 0;
+		if (pos->mm)
+			pos->oom_family = 1;
+		pos->need_to_kill = 0;
+	}
+	max_score = 0;
+	bomb = NULL;
+	for_each_mm_record(pos) {
+		get_badness_score(pos, mem, nodemask, totalpages);
+		propagate_oom_info(pos);
+		if (pos->oom_score > max_score) {
+			bomb = pos;
+			max_score = pos->oom_score;
+		}
+	}
+	if (!bomb || bomb->oom_family < 10) {
+		mm_rec_scan_unlock();
+		nobomb = true;
+		reset_forkbomb_killing();
+		pr_err("no forkbomb found \n");
+		return false;
+	}
+
+	pr_err("Possible forkbomb. Killing _all_ doubtful tasks\n");
+	for_each_mm_record_under(pos, bomb) {
+		pos->need_to_kill = 1;
+	}
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		if (!p->mm || oom_unkillable_task(p, mem, nodemask))
+			continue;
+		if (p->signal->oom_score_adj == -1000)
+			continue;
+		if (p->mm->record && p->mm->record->need_to_kill) {
+			pr_err("kill %d(%s)->%d\n", task_pid_nr(p),
+				p->comm, p->mm->record->oom_score);
+			force_sig(SIGKILL, p);
+		}
+	}
+	read_unlock(&tasklist_lock);
+	mm_rec_scan_unlock();
+	reset_forkbomb_killing();
+	return true;
+}
+#else
+static bool fork_bomb_killer(unsigned long totalpages, struct mem_cgroup *mem,
+                       nodemask_t *nodemask)
+{
+       return false;
+}
+#endif
+
 /**
  * dump_tasks - dump current memory state of all system tasks
  * @mem: current's memory controller, if constrained
@@ -767,6 +882,9 @@ void mem_cgroup_out_of_memory(struct mem
 
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, 0, NULL);
 	limit = mem_cgroup_get_limit(mem) >> PAGE_SHIFT;
+
+	if (fork_bomb_killer(limit, mem, NULL))
+		goto out;
 	read_lock(&tasklist_lock);
 retry:
 	p = select_bad_process(&points, limit, mem, NULL);
@@ -930,6 +1048,10 @@ void out_of_memory(struct zonelist *zone
 	mpol_mask = (constraint == CONSTRAINT_MEMORY_POLICY) ? nodemask : NULL;
 	check_panic_on_oom(constraint, gfp_mask, order, mpol_mask);
 
+	if (!sysctl_oom_kill_allocating_task) {
+		if (fork_bomb_killer(totalpages, NULL, mpol_mask))
+			return;
+	}
 	read_lock(&tasklist_lock);
 	if (sysctl_oom_kill_allocating_task &&
 	    !oom_unkillable_task(current, NULL, nodemask) &&

