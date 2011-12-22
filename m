Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1LVES5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 23:18:57 -0500
Received: from mail-gy0-f202.google.com ([209.85.160.202]:59565 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1LVESt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 23:18:49 -0500
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
Subject: [PATCH 2/4] cgroup: remove redundant get/put of task struct
Date: Wed, 21 Dec 2011 20:18:36 -0800
Message-Id: <1324527518-24461-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324527518-24461-1-git-send-email-msb@chromium.org>
References: <1324527518-24461-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

threadgroup_lock() guarantees that the target threadgroup will
remain stable - no new task will be added, no new PF_EXITING
will be set and exec won't happen.

Changes in V2:
* https://lkml.org/lkml/2011/12/20/369 (Tejun Heo)
  * Undo incorrect removal of get/put from attach_task_by_pid()
* Author
  * Remove a comment which is made stale by this change

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
 kernel/cgroup.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8228808..a85a700 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2116,7 +2116,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		retval = -EAGAIN;
 		goto out_free_group_list;
 	}
-	/* take a reference on each task in the group to go in the array. */
+
 	tsk = leader;
 	i = nr_migrating_tasks = 0;
 	do {
@@ -2128,7 +2128,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
-		get_task_struct(tsk);
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2150,7 +2149,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	/* methods shouldn't be called if no task is actually migrating */
 	retval = 0;
 	if (!nr_migrating_tasks)
-		goto out_put_tasks;
+		goto out_free_group_list;
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
@@ -2234,12 +2233,6 @@ out_cancel_attach:
 				ss->cancel_attach(ss, cgrp, &tset);
 		}
 	}
-out_put_tasks:
-	/* clean up the array of referenced threads in the group. */
-	for (i = 0; i < group_size; i++) {
-		tc = flex_array_get(group, i);
-		put_task_struct(tc->task);
-	}
 out_free_group_list:
 	flex_array_free(group);
 	return retval;
-- 
1.7.3.1

