Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1LTXPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:15:31 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:51047 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab1LTXOo (ORCPT
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
Subject: [PATCH 2/5] cgroup: remove redundant get/put of task struct
Date: Tue, 20 Dec 2011 15:14:30 -0800
Message-Id: <1324422873-31001-3-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324422873-31001-1-git-send-email-msb@chromium.org>
References: <1324422873-31001-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

threadgroup_lock() guarantees that the target threadgroup will
remain stable - no new task will be added, no new PF_EXITING
will be set and exec won't happen.

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
 kernel/cgroup.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 4166066..6649529 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2130,7 +2130,6 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 
 		/* as per above, nr_threads may decrease, but not increase. */
 		BUG_ON(i >= group_size);
-		get_task_struct(tsk);
 		/*
 		 * saying GFP_ATOMIC has no effect here because we did prealloc
 		 * earlier, but it's good form to communicate our expectations.
@@ -2152,7 +2151,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	/* methods shouldn't be called if no task is actually migrating */
 	retval = 0;
 	if (!nr_migrating_tasks)
-		goto out_put_tasks;
+		goto out_free_group_list;
 
 	/*
 	 * step 1: check that we can legitimately attach to the cgroup.
@@ -2233,12 +2232,6 @@ out_cancel_attach:
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
@@ -2287,14 +2280,12 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 			cgroup_unlock();
 			return -EACCES;
 		}
-		get_task_struct(tsk);
 		rcu_read_unlock();
 	} else {
 		if (threadgroup)
 			tsk = current->group_leader;
 		else
 			tsk = current;
-		get_task_struct(tsk);
 	}
 
 	threadgroup_lock(tsk);
@@ -2306,7 +2297,6 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 
 	threadgroup_unlock(tsk);
 
-	put_task_struct(tsk);
 	cgroup_unlock();
 	return ret;
 }
-- 
1.7.3.1

