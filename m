Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0F3JaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 05:30:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50793 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0F3JaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 05:30:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 05/11] oom: /proc/<pid>/oom_score treat kernel thread honestly
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
References: <20100630172430.AA42.A69D9226@jp.fujitsu.com>
Message-Id: <20100630182922.AA56.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 30 Jun 2010 18:30:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If kernel thread are using use_mm(), badness() return positive value.
This is not big issue because caller care it correctly. but there is
one exception, /proc/<pid>/oom_score call badness() directly and
don't care the task is regular process.

another example, /proc/1/oom_score return !0 value. but it's unkillable.
This incorrectness makes confusing to admin a bit.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 fs/proc/base.c |    5 +++--
 mm/oom_kill.c  |   13 +++++++------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 28099a1..56b8d3e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -428,7 +428,8 @@ static const struct file_operations proc_lstats_operations = {
 #endif
 
 /* The badness from the OOM killer */
-unsigned long badness(struct task_struct *p, unsigned long uptime);
+unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
+		      nodemask_t *nodemask, unsigned long uptime);
 static int proc_oom_score(struct task_struct *task, char *buffer)
 {
 	unsigned long points = 0;
@@ -437,7 +438,7 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 	do_posix_clock_monotonic_gettime(&uptime);
 	read_lock(&tasklist_lock);
 	if (pid_alive(task))
-		points = badness(task, uptime.tv_sec);
+		points = badness(task, NULL, NULL, uptime.tv_sec);
 	read_unlock(&tasklist_lock);
 	return sprintf(buffer, "%lu\n", points);
 }
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ee00817..fcbd21b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -139,8 +139,8 @@ static bool oom_unkillable_task(struct task_struct *p, struct mem_cgroup *mem,
  *    algorithm has been meticulously tuned to meet the principle
  *    of least surprise ... (be careful when you change it)
  */
-
-unsigned long badness(struct task_struct *p, unsigned long uptime)
+unsigned long badness(struct task_struct *p, struct mem_cgroup *mem,
+		      const nodemask_t *nodemask, unsigned long uptime)
 {
 	unsigned long points, cpu_time, run_time;
 	struct task_struct *child;
@@ -150,6 +150,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime)
 	unsigned long utime;
 	unsigned long stime;
 
+	if (oom_unkillable_task(p, mem, nodemask))
+		return 0;
 	if (oom_adj == OOM_DISABLE)
 		return 0;
 
@@ -351,7 +353,7 @@ static struct task_struct *select_bad_process(unsigned long *ppoints,
 		if (p->signal->oom_adj == OOM_DISABLE)
 			continue;
 
-		points = badness(p, uptime.tv_sec);
+		points = badness(p, mem, nodemask, uptime.tv_sec);
 		if (points > *ppoints || !chosen) {
 			chosen = p;
 			*ppoints = points;
@@ -482,11 +484,10 @@ static int oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 
 			if (child->mm == p->mm)
 				continue;
-			if (oom_unkillable_task(p, mem, nodemask))
-				continue;
 
 			/* badness() returns 0 if the thread is unkillable */
-			child_points = badness(child, uptime.tv_sec);
+			child_points = badness(child, mem, nodemask,
+					       uptime.tv_sec);
 			if (child_points > victim_points) {
 				victim = child;
 				victim_points = child_points;
-- 
1.6.5.2



