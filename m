Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553Ab1LWR2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:28:52 -0500
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52660 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498Ab1LWR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:28:49 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: [PATCH 1/2] cgroup: replace tasklist_lock with rcu_read_lock
Date: Fri, 23 Dec 2011 09:28:44 -0800
Message-Id: <1324661325-31968-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cgroup_attach_proc is protected by a threadgroup_lock, we
can replace the tasklist_lock in cgroup_attach_proc with an
rcu_read_lock. To keep the complexity of the double-check locking
in one place, I also moved the thread_group_leader check up into
attach_task_by_pid. This allows us to use a goto instead of
returning -EAGAIN.

While at it, also converted a couple of returns to gotos.

Changes in V3:
* https://lkml.org/lkml/2011/12/22/419 (Frederic Weisbecker)
  * Add an rcu_read_lock to protect against exit
Changes in V2:
* https://lkml.org/lkml/2011/12/22/86 (Tejun Heo)
  * Use a goto instead of returning -EAGAIN

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/cgroup.c |   74 +++++++++++++++++++-----------------------------------
 1 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1042b3c..6ee1438 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2102,21 +2102,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (retval)
 		goto out_free_group_list;
 
-	/* prevent changes to the threadgroup list while we take a snapshot. */
-	read_lock(&tasklist_lock);
-	if (!thread_group_leader(leader)) {
-		/*
-		 * a race with de_thread from another thread's exec() may strip
-		 * us of our leadership, making while_each_thread unsafe to use
-		 * on this task. if this happens, there is no choice but to
-		 * throw this task away and try again (from cgroup_procs_write);
-		 * this is "double-double-toil-and-trouble-check locking".
-		 */
-		read_unlock(&tasklist_lock);
-		retval = -EAGAIN;
-		goto out_free_group_list;
-	}
-
+	rcu_read_lock();
 	tsk = leader;
 	i = 0;
 	do {
@@ -2145,7 +2131,7 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	group_size = i;
 	tset.tc_array = group;
 	tset.tc_array_len = group_size;
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	/* methods shouldn't be called if no task is actually migrating */
 	retval = 0;
@@ -2242,22 +2228,14 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 	if (!cgroup_lock_live_group(cgrp))
 		return -ENODEV;
 
+retry_find_task:
 	if (pid) {
 		rcu_read_lock();
 		tsk = find_task_by_vpid(pid);
 		if (!tsk) {
 			rcu_read_unlock();
-			cgroup_unlock();
-			return -ESRCH;
-		}
-		if (threadgroup) {
-			/*
-			 * RCU protects this access, since tsk was found in the
-			 * tid map. a race with de_thread may cause group_leader
-			 * to stop being the leader, but cgroup_attach_proc will
-			 * detect it later.
-			 */
-			tsk = tsk->group_leader;
+			ret= -ESRCH;
+			goto out_unlock_cgroup;
 		}
 		/*
 		 * even if we're attaching all tasks in the thread group, we
@@ -2268,29 +2246,38 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 		    cred->euid != tcred->uid &&
 		    cred->euid != tcred->suid) {
 			rcu_read_unlock();
-			cgroup_unlock();
-			return -EACCES;
+			ret = -EACCES;
+			goto out_unlock_cgroup;
 		}
 		get_task_struct(tsk);
 		rcu_read_unlock();
 	} else {
-		if (threadgroup)
-			tsk = current->group_leader;
-		else
-			tsk = current;
+		tsk = current;
 		get_task_struct(tsk);
 	}
 
 	threadgroup_lock(tsk);
-
-	if (threadgroup)
-		ret = cgroup_attach_proc(cgrp, tsk);
-	else
+	if (threadgroup) {
+		struct task_struct *leader = tsk->group_leader;
+		if (!thread_group_leader(leader)) {
+			/*
+			 * a race with de_thread from another thread's exec()
+			 * may strip us of our leadership, if this happens,
+			 * there is no choice but to throw this task away and
+			 * try again; this is
+			 * "double-double-toil-and-trouble-check locking".
+			 */
+			threadgroup_unlock(tsk);
+			put_task_struct(tsk);
+			goto retry_find_task;
+		}
+		ret = cgroup_attach_proc(cgrp, leader);
+	} else
 		ret = cgroup_attach_task(cgrp, tsk);
-
 	threadgroup_unlock(tsk);
 
 	put_task_struct(tsk);
+out_unlock_cgroup:
 	cgroup_unlock();
 	return ret;
 }
@@ -2302,16 +2289,7 @@ static int cgroup_tasks_write(struct cgroup *cgrp, struct cftype *cft, u64 pid)
 
 static int cgroup_procs_write(struct cgroup *cgrp, struct cftype *cft, u64 tgid)
 {
-	int ret;
-	do {
-		/*
-		 * attach_proc fails with -EAGAIN if threadgroup leadership
-		 * changes in the middle of the operation, in which case we need
-		 * to find the task_struct for the new leader and start over.
-		 */
-		ret = attach_task_by_pid(cgrp, tgid, true);
-	} while (ret == -EAGAIN);
-	return ret;
+	return attach_task_by_pid(cgrp, tgid, true);
 }
 
 /**
-- 
1.7.3.1

