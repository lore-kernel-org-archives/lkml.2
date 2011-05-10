Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474Ab1EJIPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:15:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36335 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1EJIPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:15:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [PATCH 3/4] oom: oom-killer don't use permillage of system-ram internally
Cc: kosaki.motohiro@jp.fujitsu.com, CAI Qian <caiqian@redhat.com>,
        avagin@gmail.com, Andrey Vagin <avagin@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan.kim@gmail.com>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20110510171335.16A7.A69D9226@jp.fujitsu.com>
References: <20110509182110.167F.A69D9226@jp.fujitsu.com> <20110510171335.16A7.A69D9226@jp.fujitsu.com>
Message-Id: <20110510171724.16B3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Tue, 10 May 2011 17:15:44 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAI Qian reported his kernel did hang-up if he ran fork intensive
workload and then invoke oom-killer.

The problem is, Current oom calculation uses 0-1000 normalized value
(The unit is a permillage of system-ram). Its low precision make
a lot of same oom score. IOW, in his case, all processes have <1
oom score and internal integral calculation round it to 1. Thus
oom-killer kill ineligible process. This regression is caused by
commit a63d83f427 (oom: badness heuristic rewrite).

The solution is, the internal calculation just use number of pages
instead of permillage of system-ram. And convert it to permillage
value at displaying time.

This patch doesn't change any ABI (included  /proc/<pid>/oom_score_adj)
even though current logic has a lot of my dislike thing.

Reported-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c      |   13 ++++++----
 include/linux/oom.h |    7 +----
 mm/oom_kill.c       |   60 +++++++++++++++++++++++++++++++++-----------------
 3 files changed, 49 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dfa5327..d6b0424 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -476,14 +476,17 @@ static const struct file_operations proc_lstats_operations = {
 
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
-	unsigned long points = 0;
+	unsigned long points;
+	unsigned long ratio = 0;
+	unsigned long totalpages = totalram_pages + total_swap_pages + 1;
 
 	read_lock(&tasklist_lock);
-	if (pid_alive(task))
-		points = oom_badness(task, NULL, NULL,
-					totalram_pages + total_swap_pages);
+	if (pid_alive(task)) {
+		points = oom_badness(task, NULL, NULL, totalpages);
+		ratio = points * 1000 / totalpages;
+	}
 	read_unlock(&tasklist_lock);
-	return sprintf(buffer, "%lu\n", points);
+	return sprintf(buffer, "%lu\n", ratio);
 }
 
 struct limit_names {
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 5e3aa83..0f5b588 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -40,7 +40,8 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
-extern unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
+/* The badness from the OOM killer */
+extern unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 			const nodemask_t *nodemask, unsigned long totalpages);
 extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
@@ -62,10 +63,6 @@ static inline void oom_killer_enable(void)
 	oom_killer_disabled = false;
 }
 
-/* The badness from the OOM killer */
-extern unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
-		      const nodemask_t *nodemask, unsigned long uptime);
-
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
 /* sysctls */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0cf5091..ba95870 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -132,10 +132,12 @@ static bool oom_unkillable_task(struct task_struct *p,
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
+unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 		      const nodemask_t *nodemask, unsigned long totalpages)
 {
-	int points;
+	unsigned long points;
+	unsigned long score_adj = 0;
+
 
 	if (oom_unkillable_task(p, mem, nodemask))
 		return 0;
@@ -160,7 +162,7 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	if (p->flags & PF_OOM_ORIGIN) {
 		task_unlock(p);
-		return 1000;
+		return ULONG_MAX;
 	}
 
 	/*
@@ -176,33 +178,49 @@ unsigned int oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	 */
 	points = get_mm_rss(p->mm) + p->mm->nr_ptes;
 	points += get_mm_counter(p->mm, MM_SWAPENTS);
-
-	points *= 1000;
-	points /= totalpages;
 	task_unlock(p);
 
 	/*
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
 	 * implementation used by LSMs.
+	 *
+	 * XXX: Too large bonus. Example,if the system have tera-bytes memory...
 	 */
-	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		points -= 30;
+	if (has_capability_noaudit(p, CAP_SYS_ADMIN)) {
+		if (points >= totalpages / 32)
+			points -= totalpages / 32;
+		else
+			points = 0;
+	}
 
 	/*
 	 * /proc/pid/oom_score_adj ranges from -1000 to +1000 such that it may
 	 * either completely disable oom killing or always prefer a certain
 	 * task.
 	 */
-	points += p->signal->oom_score_adj;
+	if (p->signal->oom_score_adj >= 0) {
+		score_adj = p->signal->oom_score_adj * (totalpages / 1000);
+		if (ULONG_MAX - points >= score_adj)
+			points += score_adj;
+		else
+			points = ULONG_MAX;
+	} else {
+		score_adj = -p->signal->oom_score_adj * (totalpages / 1000);
+		if (points >= score_adj)
+			points -= score_adj;
+		else
+			points = 0;
+	}
 
 	/*
 	 * Never return 0 for an eligible task that may be killed since it's
 	 * possible that no single user task uses more than 0.1% of memory and
 	 * no single admin tasks uses more than 3.0%.
 	 */
-	if (points <= 0)
-		return 1;
-	return (points < 1000) ? points : 1000;
+	if (!points)
+		points = 1;
+
+	return points;
 }
 
 /*
@@ -274,7 +292,7 @@ static enum oom_constraint constrained_alloc(struct zonelist *zonelist,
  *
  * (not docbooked, we don't want this one cluttering up the manual)
  */
-static struct task_struct *select_bad_process(unsigned int *ppoints,
+static struct task_struct *select_bad_process(unsigned long *ppoints,
 		unsigned long totalpages, struct mem_cgroup *mem,
 		const nodemask_t *nodemask)
 {
@@ -283,7 +301,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 	*ppoints = 0;
 
 	do_each_thread_reverse(g, p) {
-		unsigned int points;
+		unsigned long points;
 
 		if (!p->mm)
 			continue;
@@ -314,7 +332,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
 			 */
 			if (p == current) {
 				chosen = p;
-				*ppoints = 1000;
+				*ppoints = ULONG_MAX;
 			} else {
 				/*
 				 * If this task is not being ptraced on exit,
@@ -444,14 +462,14 @@ static int oom_kill_task(struct task_struct *p, struct mem_cgroup *mem)
 #undef K
 
 static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
-			    unsigned int points, unsigned long totalpages,
+			    unsigned long points, unsigned long totalpages,
 			    struct mem_cgroup *mem, nodemask_t *nodemask,
 			    const char *message)
 {
 	struct task_struct *victim = p;
 	struct task_struct *child;
 	struct task_struct *t = p;
-	unsigned int victim_points = 0;
+	unsigned long victim_points = 0;
 
 	if (printk_ratelimit())
 		dump_header(p, gfp_mask, order, mem, nodemask);
@@ -466,7 +484,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	}
 
 	task_lock(p);
-	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
+	pr_err("%s: Kill process %d (%s) points %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
 	task_unlock(p);
 
@@ -478,7 +496,7 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 	 */
 	do {
 		list_for_each_entry(child, &t->children, sibling) {
-			unsigned int child_points;
+			unsigned long child_points;
 
 			if (child->mm == p->mm)
 				continue;
@@ -525,7 +543,7 @@ static void check_panic_on_oom(enum oom_constraint constraint, gfp_t gfp_mask,
 void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
 {
 	unsigned long limit;
-	unsigned int points = 0;
+	unsigned long points = 0;
 	struct task_struct *p;
 
 	/*
@@ -674,7 +692,7 @@ void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 	struct task_struct *p;
 	unsigned long totalpages;
 	unsigned long freed = 0;
-	unsigned int points;
+	unsigned long points;
 	enum oom_constraint constraint = CONSTRAINT_NONE;
 	int killed = 0;
 
-- 
1.7.3.1



