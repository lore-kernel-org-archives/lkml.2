Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2JPW3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:29:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab2JPW25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:28:57 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] cgroup_freezer: make it official that writes to freezer.state don't fail
Date: Tue, 16 Oct 2012 15:28:42 -0700
Message-Id: <1350426526-14254-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_freeze_cgroup() has condition checks which are intended to fail
the write operation to freezer.state if there are tasks which can't be
frozen.  The condition checks have been broken for quite some time
now.  freeze_task() returns %false if the target task can't be frozen,
so num_cant_freeze_now is never incremented.

In addition, strangely, cgroup freezing proceeds even after the write
is failed, which is rather broken.

This patch rips out the non-working code intended to fail the write to
freezer.state when the cgroup contains non-freezable tasks and makes
it official that writes to freezer.state succeed whether there are
non-freezable tasks in the cgroup or not.

This leaves is_task_frozen_enough() with only one user -
upste_if_frozen().  Collapse it into the caller.  Note that this
removes an extra call to freezing().

This doesn't cause any userland behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/cgroup_freezer.c |   43 +++++++++++--------------------------------
 1 files changed, 11 insertions(+), 32 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 12bfedb..05d5218 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -150,13 +150,6 @@ static void freezer_destroy(struct cgroup *cgroup)
 	kfree(freezer);
 }
 
-/* task is frozen or will freeze immediately when next it gets woken */
-static bool is_task_frozen_enough(struct task_struct *task)
-{
-	return frozen(task) ||
-		(task_is_stopped_or_traced(task) && freezing(task));
-}
-
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -222,7 +215,8 @@ static void update_if_frozen(struct cgroup *cgroup,
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (freezing(task) && is_task_frozen_enough(task))
+		if (freezing(task) && (frozen(task) ||
+				       task_is_stopped_or_traced(task)))
 			nfrozen++;
 	}
 
@@ -264,24 +258,15 @@ static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 	return 0;
 }
 
-static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+static void freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
-	unsigned int num_cant_freeze_now = 0;
 
 	cgroup_iter_start(cgroup, &it);
-	while ((task = cgroup_iter_next(cgroup, &it))) {
-		if (!freeze_task(task))
-			continue;
-		if (is_task_frozen_enough(task))
-			continue;
-		if (!freezing(task) && !freezer_should_skip(task))
-			num_cant_freeze_now++;
-	}
+	while ((task = cgroup_iter_next(cgroup, &it)))
+		freeze_task(task);
 	cgroup_iter_end(cgroup, &it);
-
-	return num_cant_freeze_now ? -EBUSY : 0;
 }
 
 static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
@@ -295,13 +280,10 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	cgroup_iter_end(cgroup, &it);
 }
 
-static int freezer_change_state(struct cgroup *cgroup,
-				enum freezer_state goal_state)
+static void freezer_change_state(struct cgroup *cgroup,
+				 enum freezer_state goal_state)
 {
-	struct freezer *freezer;
-	int retval = 0;
-
-	freezer = cgroup_freezer(cgroup);
+	struct freezer *freezer = cgroup_freezer(cgroup);
 
 	spin_lock_irq(&freezer->lock);
 
@@ -318,22 +300,19 @@ static int freezer_change_state(struct cgroup *cgroup,
 		if (freezer->state == CGROUP_THAWED)
 			atomic_inc(&system_freezing_cnt);
 		freezer->state = CGROUP_FREEZING;
-		retval = try_to_freeze_cgroup(cgroup, freezer);
+		freeze_cgroup(cgroup, freezer);
 		break;
 	default:
 		BUG();
 	}
 
 	spin_unlock_irq(&freezer->lock);
-
-	return retval;
 }
 
 static int freezer_write(struct cgroup *cgroup,
 			 struct cftype *cft,
 			 const char *buffer)
 {
-	int retval;
 	enum freezer_state goal_state;
 
 	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
@@ -345,9 +324,9 @@ static int freezer_write(struct cgroup *cgroup,
 
 	if (!cgroup_lock_live_group(cgroup))
 		return -ENODEV;
-	retval = freezer_change_state(cgroup, goal_state);
+	freezer_change_state(cgroup, goal_state);
 	cgroup_unlock();
-	return retval;
+	return 0;
 }
 
 static struct cftype files[] = {
-- 
1.7.7.3

