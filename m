Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933690Ab2KZRfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:35:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727Ab2KZRMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:12:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 197/270] Revert "cgroup: Drop task_lock(parent) on cgroup_fork()"
Date: Mon, 26 Nov 2012 14:58:07 -0200
Message-Id: <1353949160-26803-198-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 9bb71308b8133d643648776243e4d5599b1c193d upstream.

This reverts commit 7e381b0eb1e1a9805c37335562e8dc02e7d7848c.

The commit incorrectly assumed that fork path always performed
threadgroup_change_begin/end() and depended on that for
synchronization against task exit and cgroup migration paths instead
of explicitly grabbing task_lock().

threadgroup_change is not locked when forking a new process (as
opposed to a new thread in the same process) and even if it were it
wouldn't be effective as different processes use different threadgroup
locks.

Revert the incorrect optimization.

Signed-off-by: Tejun Heo <tj@kernel.org>
LKML-Reference: <20121008020000.GB2575@localhost>
Acked-by: Li Zefan <lizefan@huawei.com>
Bitterly-Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/cgroup.c |   23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 63c9596..75d4318 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4739,31 +4739,20 @@ static const struct file_operations proc_cgroupstats_operations = {
  *
  * A pointer to the shared css_set was automatically copied in
  * fork.c by dup_task_struct().  However, we ignore that copy, since
- * it was not made under the protection of RCU, cgroup_mutex or
- * threadgroup_change_begin(), so it might no longer be a valid
- * cgroup pointer.  cgroup_attach_task() might have already changed
- * current->cgroups, allowing the previously referenced cgroup
- * group to be removed and freed.
- *
- * Outside the pointer validity we also need to process the css_set
- * inheritance between threadgoup_change_begin() and
- * threadgoup_change_end(), this way there is no leak in any process
- * wide migration performed by cgroup_attach_proc() that could otherwise
- * miss a thread because it is too early or too late in the fork stage.
+ * it was not made under the protection of RCU or cgroup_mutex, so
+ * might no longer be a valid cgroup pointer.  cgroup_attach_task() might
+ * have already changed current->cgroups, allowing the previously
+ * referenced cgroup group to be removed and freed.
  *
  * At the point that cgroup_fork() is called, 'current' is the parent
  * task, and the passed argument 'child' points to the child task.
  */
 void cgroup_fork(struct task_struct *child)
 {
-	/*
-	 * We don't need to task_lock() current because current->cgroups
-	 * can't be changed concurrently here. The parent obviously hasn't
-	 * exited and called cgroup_exit(), and we are synchronized against
-	 * cgroup migration through threadgroup_change_begin().
-	 */
+	task_lock(current);
 	child->cgroups = current->cgroups;
 	get_css_set(child->cgroups);
+	task_unlock(current);
 	INIT_LIST_HEAD(&child->cg_list);
 }
 
-- 
1.7.9.5

