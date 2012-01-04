Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2ADFTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 00:19:01 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52570 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2ADFSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 00:18:42 -0500
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
Subject: [PATCH 2/3] cgroup: replace tasklist_lock with rcu_read_lock
Date: Tue,  3 Jan 2012 21:18:31 -0800
Message-Id: <1325654312-32477-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325654312-32477-1-git-send-email-msb@chromium.org>
References: <1325654312-32477-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can replace the tasklist_lock in cgroup_attach_proc with an
rcu_read_lock.

Changes in V4:
* https://lkml.org/lkml/2011/12/23/284 (Frederic Weisbecker)
  * Minimize size of rcu_read_lock critical section
  * Add comment
* https://lkml.org/lkml/2011/12/26/136 (Li Zefan)
  * Split into two patches
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
 kernel/cgroup.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 09867eb..354c539 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2102,10 +2102,14 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 	if (retval)
 		goto out_free_group_list;
 
-	/* prevent changes to the threadgroup list while we take a snapshot. */
-	read_lock(&tasklist_lock);
 	tsk = leader;
 	i = 0;
+	/*
+	 * Prevent freeing of tasks while we take a snapshot. Tasks that are
+	 * already PF_EXITING could be freed from underneath us unless we
+	 * take an rcu_read_lock.
+	 */
+	rcu_read_lock();
 	do {
 		struct task_and_cgroup ent;
 
@@ -2128,11 +2132,11 @@ int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
 		BUG_ON(retval != 0);
 		i++;
 	} while_each_thread(leader, tsk);
+	rcu_read_unlock();
 	/* remember the number of threads in the array for later. */
 	group_size = i;
 	tset.tc_array = group;
 	tset.tc_array_len = group_size;
-	read_unlock(&tasklist_lock);
 
 	/* methods shouldn't be called if no task is actually migrating */
 	retval = 0;
-- 
1.7.3.1

