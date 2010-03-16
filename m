Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937737Ab0CPMKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 08:10:42 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57658 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S936952Ab0CPMKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 08:10:40 -0400
Message-ID: <4B9F7543.7040107@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 20:10:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Nick Piggin <npiggin@suse.de>,
       Paul Menage <menage@google.com>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: [RESEND][PATCH 1/2] cpuset: fix the problem that cpuset_mem_spread_node()
 returns an offline node (v2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuset_mem_spread_node() returns an offline node, and causes an oops.

This patch fixes it by initializing task->mems_allowed to
node_states[N_HIGH_MEMORY], and updating task->mems_allowed when doing
memory hotplug.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 init/main.c      |    2 +-
 kernel/cpuset.c  |   20 ++++++++++++--------
 kernel/kthread.c |    2 +-
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/init/main.c b/init/main.c
index a1ab78c..cbead27 100644
--- a/init/main.c
+++ b/init/main.c
@@ -858,7 +858,7 @@ static int __init kernel_init(void * unused)
 	/*
 	 * init can allocate pages on any node
 	 */
-	set_mems_allowed(node_possible_map);
+	set_mems_allowed(node_states[N_HIGH_MEMORY]);
 	/*
 	 * init can run on any cpu.
 	 */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ba401fa..5d38bd7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -920,9 +920,6 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
  *    call to guarantee_online_mems(), as we know no one is changing
  *    our task's cpuset.
  *
- *    Hold callback_mutex around the two modifications of our tasks
- *    mems_allowed to synchronize with cpuset_mems_allowed().
- *
  *    While the mm_struct we are migrating is typically from some
  *    other task, the task_struct mems_allowed that we are hacking
  *    is for our current task, which must allocate new pages for that
@@ -1391,11 +1388,10 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
-		to = node_possible_map;
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
-		guarantee_online_mems(cs, &to);
 	}
+	guarantee_online_mems(cs, &to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
 	cpuset_attach_task(tsk, &to, cs);
@@ -2090,15 +2086,23 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
+	nodemask_t oldmems;
+
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-	case MEM_OFFLINE:
+		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		if (action == MEM_OFFLINE)
-			scan_for_empty_cpusets(&top_cpuset);
+		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
+		break;
+	case MEM_OFFLINE:
+		/*
+		 * needn't update top_cpuset.mems_allowed explicitly because
+		 * scan_for_empty_cpusets() will update it.
+		 */
+		scan_for_empty_cpusets(&top_cpuset);
 		break;
 	default:
 		break;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 82ed0ea..83911c7 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -219,7 +219,7 @@ int kthreadd(void *unused)
 	set_task_comm(tsk, "kthreadd");
 	ignore_signals(tsk);
 	set_cpus_allowed_ptr(tsk, cpu_all_mask);
-	set_mems_allowed(node_possible_map);
+	set_mems_allowed(node_states[N_HIGH_MEMORY]);
 
 	current->flags |= PF_NOFREEZE | PF_FREEZER_NOSIG;
 
-- 
1.6.5.2


