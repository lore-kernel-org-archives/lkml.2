Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab1ILXMe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:12:34 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:50296 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1ILXMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:12:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Containers <containers@lists.osdl.org>,
        Paul Menage <paul@paulmenage.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/11] cgroups: Convert task counter to use the subsys fork callback
Date: Tue, 13 Sep 2011 01:11:31 +0200
Message-Id: <1315869091-18933-12-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
References: <1315869091-18933-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using an ad hoc hook on the fork path for the task
counter, use the subsystem fork callback that we can now use
to cancel the fork.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Aditya Kali <adityakali@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Tim Hockin <thockin@hockin.org>
Cc: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h       |    9 ---------
 kernel/cgroup_task_counter.c |    4 +++-
 kernel/fork.c                |    4 ----
 3 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 62f7001..917cc39 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -665,13 +665,4 @@ static inline int cgroup_attach_task_current_cg(struct task_struct *t)
 
 #endif /* !CONFIG_CGROUPS */
 
-#ifdef CONFIG_CGROUP_TASK_COUNTER
-int cgroup_task_counter_fork(struct task_struct *child);
-#else
-static inline int cgroup_task_counter_fork(struct task_struct *child)
-{
-	return 0;
-}
-#endif /* CONFIG_CGROUP_TASK_COUNTER */
-
 #endif /* _LINUX_CGROUP_H */
diff --git a/kernel/cgroup_task_counter.c b/kernel/cgroup_task_counter.c
index 8882552..2374905 100644
--- a/kernel/cgroup_task_counter.c
+++ b/kernel/cgroup_task_counter.c
@@ -203,7 +203,8 @@ static int task_counter_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
  * Charge the task counter with the new child coming, or reject it if we
  * reached the limit.
  */
-int cgroup_task_counter_fork(struct task_struct *child)
+static int task_counter_fork(struct cgroup_subsys *ss,
+			     struct task_struct *child)
 {
 	struct cgroup_subsys_state *css;
 	struct cgroup *cgrp;
@@ -233,5 +234,6 @@ struct cgroup_subsys tasks_subsys = {
 	.can_attach_task	= task_counter_can_attach_task,
 	.cancel_attach_task	= task_counter_cancel_attach_task,
 	.attach_task		= task_counter_attach_task,
+	.fork			= task_counter_fork,
 	.populate		= task_counter_populate,
 };
diff --git a/kernel/fork.c b/kernel/fork.c
index 989c5a0..ee8abdb 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1310,10 +1310,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
 
-	retval = cgroup_task_counter_fork(p);
-	if (retval)
-		goto bad_fork_free_pid;
-
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
 	 * on the tasklist. */
-- 
1.7.5.4

