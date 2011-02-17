Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1BQBs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:48:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1BQBsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:48:55 -0500
Message-ID: <4D5C7ED1.2070601@cn.fujitsu.com>
Date: Thu, 17 Feb 2011 09:50:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Subject: [PATCH 3/4] cpuset: Fix unchecked calls to NODEMASK_ALLOC()
References: <4D5C7EA7.1030409@cn.fujitsu.com>
In-Reply-To: <4D5C7EA7.1030409@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:47:53,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:47:54,
	Serialize complete at 2011-02-17 09:47:54
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those functions that use NODEMASK_ALLOC() can't propogate errno
to users, but will fail silently.

Since all of them are called with cgroup_mutex held, here we use
a global nodemask_t variable.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |   45 +++++++++++++++------------------------------
 1 files changed, 15 insertions(+), 30 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 70c9ca2..cc414ac 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -79,6 +79,15 @@ int number_of_cpusets __read_mostly;
 struct cgroup_subsys cpuset_subsys;
 struct cpuset;
 
+/*
+ * In functions that can't propogate errno to users, to avoid declaring a
+ * nodemask_t variable, and avoid using NODEMASK_ALLOC that can return
+ * -ENOMEM, we use this global cpuset_mems.
+ *
+ * It should be used with cgroup_lock held.
+ */
+static nodemask_t cpuset_mems;
+
 /* See "Frequency meter" comments, below. */
 
 struct fmeter {
@@ -1015,17 +1024,11 @@ static void cpuset_change_nodemask(struct task_struct *p,
 	struct cpuset *cs;
 	int migrate;
 	const nodemask_t *oldmem = scan->data;
-	NODEMASK_ALLOC(nodemask_t, newmems, GFP_KERNEL);
-
-	if (!newmems)
-		return;
 
 	cs = cgroup_cs(scan->cg);
-	guarantee_online_mems(cs, newmems);
-
-	cpuset_change_task_nodemask(p, newmems);
+	guarantee_online_mems(cs, &cpuset_mems);
 
-	NODEMASK_FREE(newmems);
+	cpuset_change_task_nodemask(p, &cpuset_mems);
 
 	mm = get_task_mm(p);
 	if (!mm)
@@ -1096,13 +1099,10 @@ static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
 static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 			   const char *buf)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmem, GFP_KERNEL);
+	nodemask_t *oldmem = &cpuset_mems;
 	int retval;
 	struct ptr_heap heap;
 
-	if (!oldmem)
-		return -ENOMEM;
-
 	/*
 	 * top_cpuset.mems_allowed tracks node_stats[N_HIGH_MEMORY];
 	 * it's read-only
@@ -1152,7 +1152,6 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 
 	heap_free(&heap);
 done:
-	NODEMASK_FREE(oldmem);
 	return retval;
 }
 
@@ -1438,10 +1437,7 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 	struct mm_struct *mm;
 	struct cpuset *cs = cgroup_cs(cont);
 	struct cpuset *oldcs = cgroup_cs(oldcont);
-	NODEMASK_ALLOC(nodemask_t, to, GFP_KERNEL);
-
-	if (to == NULL)
-		goto alloc_fail;
+	nodemask_t *to = &cpuset_mems;
 
 	if (cs == &top_cpuset) {
 		cpumask_copy(cpus_attach, cpu_possible_mask);
@@ -1470,9 +1466,6 @@ static void cpuset_attach(struct cgroup_subsys *ss, struct cgroup *cont,
 			cpuset_migrate_mm(mm, &oldcs->mems_allowed, to);
 		mmput(mm);
 	}
-
-alloc_fail:
-	NODEMASK_FREE(to);
 }
 
 /* The various types of files and directories in a cpuset file system */
@@ -2051,10 +2044,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 	struct cpuset *cp;	/* scans cpusets being updated */
 	struct cpuset *child;	/* scans child cpusets of cp */
 	struct cgroup *cont;
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return;
+	nodemask_t *oldmems = &cpuset_mems;
 
 	list_add_tail((struct list_head *)&root->stack_list, &queue);
 
@@ -2090,7 +2080,6 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 			update_tasks_nodemask(cp, oldmems, NULL);
 		}
 	}
-	NODEMASK_FREE(oldmems);
 }
 
 /*
@@ -2132,10 +2121,7 @@ void cpuset_update_active_cpus(void)
 static int cpuset_track_online_nodes(struct notifier_block *self,
 				unsigned long action, void *arg)
 {
-	NODEMASK_ALLOC(nodemask_t, oldmems, GFP_KERNEL);
-
-	if (oldmems == NULL)
-		return NOTIFY_DONE;
+	nodemask_t *oldmems = &cpuset_mems;
 
 	cgroup_lock();
 	switch (action) {
@@ -2158,7 +2144,6 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 	}
 	cgroup_unlock();
 
-	NODEMASK_FREE(oldmems);
 	return NOTIFY_OK;
 }
 #endif
-- 
1.7.3.1
