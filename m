Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab2JPW3H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:29:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2JPW3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:29:02 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] cgroup_freezer: allow moving tasks in and out of a frozen cgroup
Date: Tue, 16 Oct 2012 15:28:44 -0700
Message-Id: <1350426526-14254-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_freezer is one of the few users of cgroup_subsys->can_attach()
and uses it to prevent tasks from being migrated into or out of a
frozen cgroup.  This makes cgroup_freezer cumbersome to use especially
when co-mounted with other controllers.

->can_attach() is problematic in general as it can make co-mounting
multiple cgroups difficult - migrating tasks may fail for reasons
completely irrelevant for other controllers.  freezer_can_attach() in
particular is more problematic because it messes with cgroup internal
locking to ensure that the state verification performed at
freezer_can_attach() stays valid until migration is complete.

This patch replaces freezer_can_attach() with freezer_attach() so that
tasks are always allowed to migrate - they are nudged into the
conforming state from freezer_attach().  This means that there can be
tasks which are being migrated which don't conform to the current
cgroup_freezer state until freezer_attach() is complete.  Under the
current locking scheme, the only such place is freezer_fork() which is
updated to handle such window.

While this patch doesn't remove the use of internal cgroup locking
from freezer_read/write() paths, it removes the requirement to keep
the freezer state constant while migrating and enables such change.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup_freezer.c |   51 ++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 557f367..0b0e105 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -152,27 +152,38 @@ static void freezer_destroy(struct cgroup *cgroup)
 
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
- * a write to that file racing against an attach, and hence the
- * can_attach() result will remain valid until the attach completes.
+ * a write to that file racing against an attach, and hence we don't need
+ * to worry about racing against migration.
  */
-static int freezer_can_attach(struct cgroup *new_cgroup,
-			      struct cgroup_taskset *tset)
+static void freezer_attach(struct cgroup *new_cgrp, struct cgroup_taskset *tset)
 {
-	struct freezer *freezer;
+	struct freezer *freezer = cgroup_freezer(new_cgrp);
 	struct task_struct *task;
 
+	spin_lock_irq(&freezer->lock);
+
 	/*
-	 * Anything frozen can't move or be moved to/from.
+	 * Make the new tasks conform to the current state of @new_cgrp.
+	 * For simplicity, when migrating any task to a FROZEN cgroup, we
+	 * revert it to FREEZING and let update_if_frozen() determine the
+	 * correct state later.
+	 *
+	 * Tasks in @tset are on @new_cgrp but may not conform to its
+	 * current state before executing the following - !frozen tasks may
+	 * be visible in a FROZEN cgroup and frozen tasks in a THAWED one.
+	 * This means that, to determine whether to freeze, one should test
+	 * whether the state equals THAWED.
 	 */
-	cgroup_taskset_for_each(task, new_cgroup, tset)
-		if (cgroup_freezing(task))
-			return -EBUSY;
-
-	freezer = cgroup_freezer(new_cgroup);
-	if (freezer->state != CGROUP_THAWED)
-		return -EBUSY;
+	cgroup_taskset_for_each(task, new_cgrp, tset) {
+		if (freezer->state == CGROUP_THAWED) {
+			__thaw_task(task);
+		} else {
+			freeze_task(task);
+			freezer->state = CGROUP_FREEZING;
+		}
+	}
 
-	return 0;
+	spin_unlock_irq(&freezer->lock);
 }
 
 static void freezer_fork(struct task_struct *task)
@@ -190,12 +201,12 @@ static void freezer_fork(struct task_struct *task)
 		goto out;
 
 	spin_lock_irq(&freezer->lock);
-	BUG_ON(freezer->state == CGROUP_FROZEN);
-
-	/* Locking avoids race with FREEZING -> THAWED transitions. */
-	if (freezer->state == CGROUP_FREEZING)
+	/*
+	 * @task might have been just migrated into a FROZEN cgroup.  Test
+	 * equality with THAWED.  Read the comment in freezer_attach().
+	 */
+	if (freezer->state != CGROUP_THAWED)
 		freeze_task(task);
-
 	spin_unlock_irq(&freezer->lock);
 out:
 	rcu_read_unlock();
@@ -352,7 +363,7 @@ struct cgroup_subsys freezer_subsys = {
 	.create		= freezer_create,
 	.destroy	= freezer_destroy,
 	.subsys_id	= freezer_subsys_id,
-	.can_attach	= freezer_can_attach,
+	.attach		= freezer_attach,
 	.fork		= freezer_fork,
 	.base_cftypes	= files,
 
-- 
1.7.7.3

