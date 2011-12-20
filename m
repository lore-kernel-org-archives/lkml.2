Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1LTTB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:01:27 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33149 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1LTTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:01:19 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH 1/2] cgroup: Remove unnecessary task_lock before fetching css_set on migration
Date: Tue, 20 Dec 2011 20:01:12 +0100
Message-Id: <1324407673-18975-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1324320274-18485-1-git-send-email-msb@chromium.org>
References: <1324320274-18485-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fetch the css_set of the tasks on cgroup migration, we don't need
anymore to synchronize against cgroup_exit() that could swap the old one
with init_css_set. Now that we are using threadgroup_lock() during
the migrations, we don't need to worry about it anymore.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Containers <containers@lists.linux-foundation.org>
Cc: Cgroups <cgroups@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Mandeep Singh Baines <msb@chromium.org>
---
 kernel/cgroup.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 5fdd98c..6b5f693 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1850,13 +1850,13 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 	struct css_set *newcg;
 
 	/*
-	 * get old css_set. we need to take task_lock and refcount it, because
-	 * an exiting task can change its css_set to init_css_set and drop its
-	 * old one without taking cgroup_mutex.
+	 * get old css_set. We are synchronized through threadgroup_lock()
+	 * against PF_EXITING setting such that we can't race against
+	 * cgroup_exit() changing the css_set to init_css_set and dropping the
+	 * old one.
 	 */
-	task_lock(tsk);
+	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	oldcg = tsk->cgroups;
-	task_unlock(tsk);
 
 	/* locate or allocate a new css_set for this task. */
 	if (guarantee) {
@@ -1875,9 +1875,7 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 			return -ENOMEM;
 	}
 
-	/* @tsk can't exit as its threadgroup is locked */
 	task_lock(tsk);
-	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	rcu_assign_pointer(tsk->cgroups, newcg);
 	task_unlock(tsk);
 
@@ -2177,10 +2175,13 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		/* nothing to do if this task is already in the cgroup */
 		if (tc->cgrp == cgrp)
 			continue;
-		/* get old css_set pointer */
-		task_lock(tc->task);
+		/*
+		 * get old css_set pointer. threadgroup is locked so this is
+		 * safe against concurrent cgroup_exit() changing this to
+		 * init_css_set.
+		 */
 		oldcg = tc->task->cgroups;
-		task_unlock(tc->task);
+
 		/* if we don't already have it in the list get a new one */
 		if (!css_set_fetched(cgrp, tc->task, oldcg, &newcg_list))
 			if (css_set_prefetch(cgrp, oldcg, &newcg_list))
-- 
1.7.5.4

