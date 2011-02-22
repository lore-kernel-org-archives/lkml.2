Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1BVCOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:14:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56389 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab1BVCOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:14:17 -0500
Message-ID: <4D631C54.1080703@cn.fujitsu.com>
Date: Tue, 22 Feb 2011 10:15:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        miaox@cn.fujitsu.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7ED1.2070601@cn.fujitsu.com> <alpine.DEB.2.00.1102191745180.27722@chino.kir.corp.google.com> <4D61DA04.4060007@cn.fujitsu.com> <alpine.DEB.2.00.1102211617510.23557@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1102211617510.23557@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 10:13:14,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-22 10:13:14,
	Serialize complete at 2011-02-22 10:13:14
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Mon, 21 Feb 2011, Li Zefan wrote:
> 
>> Unfortunately, as I looked into the code again I found cpuset_change_nodemask()
>> is called by other functions that use the global cpuset_mems, so I
>> think we'd better check the refcnt of cpuset_mems.
>>
>> How about this:
>>
>> [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
>>
>> Those functions that use NODEMASK_ALLOC() can't propogate errno
>> to users, so might fail silently.
>>
>> Based on the fact that all of them are called with cgroup_mutex
>> held, we fix this by using a global nodemask.
>>
> 
> If all of the functions that require a nodemask are protected by 
> cgroup_mutex, then I think it would be much better to just statically 
> allocate them within the function and avoid any nodemask in file scope.  
> cpuset_mems cannot be shared so introducing it with a refcount would 
> probably just be confusing.
> 

I'll repost the patchset after you ack this patch.

[PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()

Those functions that use NODEMASK_ALLOC() can't propogate errno
to users, so might fail silently.

Fix it by using one static nodemask_t variable for each function, and
those variables are protected by cgroup_mutex.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   50 ++++++++++++++++----------------------------------
 1 files changed, 16 insertions(+), 34 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 8fef8c6..073ce91 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1015,17 +1015,12 @@ static void cpuset_change_nodemask(struct task_struct *p,
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
-
-	if (!newmems)
-		return;
+	static nodemask_t newmems;	/* protected by cgroup_mutex */
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, newmems);
-
-	cpuset_change_task_nodemask(p, newmems);
+	guarantee_online_mems(cs, &newmems);
 
-	NODEMASK_FREE(newmems);
+	cpuset_change_task_nodemask(p, &newmems);
 
 	mm = get_task_mm(p);
 	if (!mm)
@@ -1438,41 +1433,35 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
-
-	if (to == NULL)
-		goto alloc_fail;
+	static nodemask_t to;		/* protected by cgroup_mutex */
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
 	} else {
 		guarantee_online_cpus(cs, cpus_attach);
 	}
-	guarantee_online_mems(cs, to);
+	guarantee_online_mems(cs, &to);
 
 	/* do per-task migration stuff possibly for each in the threadgroup */
-	cpuset_attach_task(tsk, to, cs);
+	cpuset_attach_task(tsk, &to, cs);
 	if (threadgroup) {
 		struct task_struct *c;
 		rcu_read_lock();
 		list_for_each_entry_rcu(c, &tsk->thread_group, thread_group) {
-			cpuset_attach_task(c, to, cs);
+			cpuset_attach_task(c, &to, cs);
 		}
 		rcu_read_unlock();
 	}
 
 	/* change mm; only needs to be done once even if threadgroup */
-	*to = cs->mems_allowed;
+	to = cs->mems_allowed;
 	mm = get_task_mm(tsk);
 	if (mm) {
-		mpol_rebind_mm(mm, to);
+		mpol_rebind_mm(mm, &to);
 		if (is_memory_migrate(cs))
-			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
+			cpuset_migrate_mm(mm, &oldcs->mems_allowed, &to);
 		mmput(mm);
 	}
-
-alloc_fail:
-	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -2051,10 +2040,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return;
+	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2071,7 +2057,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
-		*oldmems = cp->mems_allowed;
+		oldmems = cp->mems_allowed;
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
@@ -2087,10 +2073,9 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 			remove_tasks_in_empty_cpuset(cp);
 		else {
 			update_tasks_cpumask(cp, NULL);
-			update_tasks_nodemask(cp, oldmems, NULL);
+			update_tasks_nodemask(cp, &oldmems, NULL);
 		}
 	}
-	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2132,19 +2117,16 @@ void cpuset_update_active_cpus(void)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return NOTIFY_DONE;
+	static nodemask_t oldmems;	/* protected by cgroup_mutex */
 
 	cgroup_lock();
 	switch (action) {
 	case MEM_ONLINE:
-		*oldmems = top_cpuset.mems_allowed;
+		oldmems = top_cpuset.mems_allowed;
 		mutex_lock(&callback_mutex);
 		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 		mutex_unlock(&callback_mutex);
-		update_tasks_nodemask(&top_cpuset, oldmems, NULL);
+		update_tasks_nodemask(&top_cpuset, &oldmems, NULL);
 		break;
 	case MEM_OFFLINE:
 		/*
-- 
1.7.3.1
