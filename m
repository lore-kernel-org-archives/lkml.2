Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1LWA60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 19:58:26 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35400 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab1LWA56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 19:57:58 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <paul@paulmenage.org>
Subject: [PATCH 2/3] cgroup: remove double-checking locking from attach_task_by_pid
Date: Thu, 22 Dec 2011 16:57:52 -0800
Message-Id: <1324601873-20773-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1324601873-20773-1-git-send-email-msb@chromium.org>
References: <1324601873-20773-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By reading group_leader after taking the threadgroup_lock, we can
avoid the double-check locking. This removes the return of
-EAGAIN so we can cleanup cgroup_procs_write at the same time.

The suggestion was made here:

https://lkml.org/lkml/2011/12/22/371

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: containers@lists.linux-foundation.org
Cc: cgroups@vger.kernel.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <paul@paulmenage.org>
---
 kernel/cgroup.c |   40 ++++++----------------------------------
 1 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 032139d..a5f7d1b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2234,9 +2234,6 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
 			ret= -ESRCH;
 			goto out_unlock_cgroup;
 		}
-		/* we check later for a group_leader race with de_thread */
-		if (threadgroup)
-			tsk = tsk->group_leader;
 		/*
 		 * even if we're attaching all tasks in the thread group, we
 		 * only need to check permissions on one of them.
@@ -2252,33 +2249,17 @@ static int attach_task_by_pid(struct cgroup *cgrp, u64 pid, bool threadgroup)
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
-	if (threadgroup) {
-		if (!thread_group_leader(tsk)) {
-			/*
-			 * a race with de_thread from another thread's exec()
-			 * may strip us of our leadership, if this happens,
-			 * there is no choice but to throw this task away and
-			 * try again (from cgroup_procs_write); this is
-			 * "double-double-toil-and-trouble-check locking".
-			 */
-			ret = -EAGAIN;
-			goto out_unlock_threadgroup;
-		}
-		ret = cgroup_attach_proc(cgrp, tsk);
-	} else
+	if (threadgroup)
+		ret = cgroup_attach_proc(cgrp, tsk->group_leader);
+	else
 		ret = cgroup_attach_task(cgrp, tsk);
-
-out_unlock_threadgroup:
 	threadgroup_unlock(tsk);
+
 	put_task_struct(tsk);
 out_unlock_cgroup:
 	cgroup_unlock();
@@ -2292,16 +2273,7 @@ static int cgroup_tasks_write(struct cgroup *cgrp, struct cftype *cft, u64 pid)
 
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

