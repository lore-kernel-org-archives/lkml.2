Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab1LTXOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:14:53 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58383 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1LTXOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:14:44 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: [PATCH 3/5] cgroup: only need to check oldcgrp==newgrp once
Date: Tue, 20 Dec 2011 15:14:31 -0800
Message-Id: <1324422873-31001-4-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324422873-31001-1-git-send-email-msb@chromium.org>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cgroup_attach_proc it is now sufficient to only check that
oldcgrp==newcgrp once. Now that we are using threadgroup_lock()
during the migrations, oldcgrp will not change.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/cgroup.c |   17 ++++++-----------
 1 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6649529..4668a3f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2069,7 +2069,7 @@ static int css_set_prefetch(struct cgroup *cgrp, struct css_set *cg,
  */
 int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 {
-	int retval, i, group_size, nr_migrating_tasks;
+	int retval, i, group_size;
 	struct cgroup_subsys *ss, *failed_ss = NULL;
 	/* guaranteed to be initialized later, but the compiler needs this */
 	struct css_set *oldcg;
@@ -2120,7 +2120,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	}
 	/* take a reference on each task in the group to go in the array. */
 	tsk = leader;
-	i = nr_migrating_tasks = 0;
+	i = 0;
 	do {
 		struct task_and_cgroup ent;
 
@@ -2136,11 +2136,12 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		 */
 		ent.task = tsk;
 		ent.cgrp = task_cgroup_from_root(tsk, root);
+		/* nothing to do if this task is already in the cgroup */
+		if (ent.cgrp == cgrp)
+			continue;
 		retval = flex_array_put(group, i, &ent, GFP_ATOMIC);
 		BUG_ON(retval != 0);
 		i++;
-		if (ent.cgrp != cgrp)
-			nr_migrating_tasks++;
 	} while_each_thread(leader, tsk);
 	/* remember the number of threads in the array for later. */
 	group_size = i;
@@ -2150,7 +2151,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 
 	/* methods shouldn't be called if no task is actually migrating */
 	retval = 0;
-	if (!nr_migrating_tasks)
+	if (!group_size)
 		goto out_free_group_list;
 
 	/*
@@ -2173,9 +2174,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	INIT_LIST_HEAD(&newcg_list);
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
-		/* nothing to do if this task is already in the cgroup */
-		if (tc->cgrp == cgrp)
-			continue;
 		/* get old css_set pointer */
 		task_lock(tc->task);
 		oldcg = tc->task->cgroups;
@@ -2193,9 +2191,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	 */
 	for (i = 0; i < group_size; i++) {
 		tc = flex_array_get(group, i);
-		/* leave current thread as it is if it's already there */
-		if (tc->cgrp == cgrp)
-			continue;
 		retval = cgroup_task_migrate(cgrp, tc->cgrp, tc->task, true);
 		BUG_ON(retval);
 	}
-- 
1.7.3.1

