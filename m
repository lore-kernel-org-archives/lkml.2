Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1LVETd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 23:19:33 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:34980 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653Ab1LVESu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 23:18:50 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: [PATCH 1/4] cgroup: remove redundant get/put of old css_set from migrate
Date: Wed, 21 Dec 2011 20:18:35 -0800
Message-Id: <1324527518-24461-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can now assume that the css_set reference held by the task
will not go away for an exiting task. PF_EXITING state can be
trusted throughout migration by checking it after locking
threadgroup.

While at it, renamed css_set_check_fetched to css_set_fetched.
!css_set_fetched() seems to read better than
!css_set_check_fetched().

Changes in V4:
* https://lkml.org/lkml/2011/12/20/368 (Tejun Heo)
  * Fix typo in commit message
  * Undid the rename of css_set_check_fetched
* https://lkml.org/lkml/2011/12/20/427 (Li Zefan)
  * Fix comment in cgroup_task_migrate()
Changes in V3:
* https://lkml.org/lkml/2011/12/20/255 (Frederic Weisbecker)
  * Fixed to put error in retval
Changes in V2:
* https://lkml.org/lkml/2011/12/19/289 (Tejun Heo)
  * Updated commit message

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
 kernel/cgroup.c |   28 ++++++++--------------------
 1 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4936d88..8228808 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1850,14 +1850,12 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 	struct css_set *newcg;
 
 	/*
-	 * get old css_set. We are synchronized through threadgroup_lock()
-	 * against PF_EXITING setting such that we can't race against
-	 * cgroup_exit() changing the css_set to init_css_set and dropping the
-	 * old one.
+	 * We are synchronized through threadgroup_lock() against PF_EXITING
+	 * setting such that we can't race against cgroup_exit() changing the
+	 * css_set to init_css_set and dropping the old one.
 	 */
 	WARN_ON_ONCE(tsk->flags & PF_EXITING);
 	oldcg = tsk->cgroups;
-	get_css_set(oldcg);
 
 	/* locate or allocate a new css_set for this task. */
 	if (guarantee) {
@@ -1872,12 +1870,9 @@ static int cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
 		might_sleep();
 		/* find_css_set will give us newcg already referenced. */
 		newcg = find_css_set(oldcg, cgrp);
-		if (!newcg) {
-			put_css_set(oldcg);
+		if (!newcg)
 			return -ENOMEM;
-		}
 	}
-	put_css_set(oldcg);
 
 	task_lock(tsk);
 	rcu_assign_pointer(tsk->cgroups, newcg);
@@ -2186,18 +2181,11 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		 * init_css_set.
 		 */
 		oldcg = tc->task->cgroups;
-		get_css_set(oldcg);
-		/* see if the new one for us is already in the list? */
-		if (css_set_check_fetched(cgrp, tc->task, oldcg, &newcg_list)) {
-			/* was already there, nothing to do. */
-			put_css_set(oldcg);
-		} else {
-			/* we don't already have it. get new one. */
-			retval = css_set_prefetch(cgrp, oldcg, &newcg_list);
-			put_css_set(oldcg);
-			if (retval)
+
+		/* if we don't already have it in the list get a new one */
+		if (!css_set_check_fetched(cgrp, tc->task, oldcg, &newcg_list))
+			if (retval = css_set_prefetch(cgrp, oldcg, &newcg_list))
 				goto out_list_teardown;
-		}
 	}
 
 	/*
-- 
1.7.3.1

