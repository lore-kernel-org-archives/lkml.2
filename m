Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0FHL4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 07:56:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48236 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617Ab0FHL4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 07:56:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 03/10] oom: rename badness() to oom_badness()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100608204621.767A.A69D9226@jp.fujitsu.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com>
Message-Id: <20100608205536.7683.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Jun 2010 20:56:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

badness() is wrong name because it's too generic name.

rename it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c      |    4 +---
 include/linux/oom.h |    2 ++
 mm/oom_kill.c       |   10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 2222102..c099f03 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -427,8 +427,6 @@ static const struct file_operations proc_lstats_operations = {
 
 #endif
 
-/* The badness from the OOM killer */
-unsigned long badness(struct task_struct *p, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points = 0;
@@ -437,7 +435,7 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
-		points = badness(task, uptime.tv_sec);
+		points = oom_badness(task, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 5376623..effb223 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -14,6 +14,7 @@
 
 struct zonelist;
 struct notifier_block;
+struct task_struct;
 
 /*
  * Types of limitations to the nodes from which allocations may occur
@@ -29,6 +30,7 @@ extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask);
+extern unsigned long oom_badness(struct task_struct *p, unsigned long uptime);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 3c83fba..80492ff 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -66,7 +66,7 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
 }
 
 /**
- * badness - calculate a numeric value for how bad this task has been
+ * oom_badness - calculate a numeric value for how bad this task has been
  * @p: task struct of which task we should calculate
  * @uptime: current uptime in seconds
  *
@@ -84,7 +84,7 @@ static struct task_struct *find_lock_task_mm(struct task_struct *p)
  *    of least surprise ... (be careful when you change it)
  */
 
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long oom_badness(struct task_struct *p, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct task_struct *c;
@@ -302,7 +302,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		if (test_tsk_thread_flag(p, TIF_MEMDIE))
 			return ERR_PTR(-1UL);
 
-		points = badness(p, uptime.tv_sec);
+		points = oom_badness(p, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -438,8 +438,8 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			if (oom_unkillable(c, mem))
 				continue;
 
-			/* badness() returns 0 if the thread is unkillable */
-			cpoints = badness(c, uptime.tv_sec);
+			/* oom_badness() returns 0 if the thread is unkillable */
+			cpoints = oom_badness(c, uptime.tv_sec);
 			if (cpoints > victim_points) {
 				victim = c;
 				victim_points = cpoints;
-- 
1.6.5.2



