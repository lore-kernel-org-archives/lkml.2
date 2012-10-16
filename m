Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab2JPW3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 18:29:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59929 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab2JPW3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 18:29:03 -0400
From: Tejun Heo <tj@kernel.org>
To: rjw@sisk.pl, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/7] cgroup_freezer: prepare update_if_frozen() for locking change
Date: Tue, 16 Oct 2012 15:28:45 -0700
Message-Id: <1350426526-14254-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1350426526-14254-1-git-send-email-tj@kernel.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Locking will change such that migration can happen while
freezer_read/write() is in progress.  This means that
update_if_frozen() can no longer assume that all tasks in the cgroup
coform to the current freezer state - newly migrated tasks which
haven't finished freezer_attach() yet might be in any state.

This patch updates update_if_frozen() such that it no longer verifies
task states against freezer state.  It now simply decides whether
FREEZING stage is complete.

This removal of verification makes it meaningless to call from
freezer_change_state().  Drop it and move the fast exit test from
freezer_read() - the only left caller - to update_if_frozen().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup_freezer.c |   43 +++++++++++++++++--------------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 0b0e105..3d45503 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -213,41 +213,39 @@ out:
 }
 
 /*
- * caller must hold freezer->lock
+ * We change from FREEZING to FROZEN lazily if the cgroup was only
+ * partially frozen when we exitted write.  Caller must hold freezer->lock.
+ *
+ * Task states and freezer state might disagree while tasks are being
+ * migrated into @cgroup, so we can't verify task states against @freezer
+ * state here.  See freezer_attach() for details.
  */
-static void update_if_frozen(struct cgroup *cgroup,
-				 struct freezer *freezer)
+static void update_if_frozen(struct cgroup *cgroup, struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
-	unsigned int nfrozen = 0, ntotal = 0;
-	enum freezer_state old_state = freezer->state;
+
+	if (freezer->state != CGROUP_FREEZING)
+		return;
 
 	cgroup_iter_start(cgroup, &it);
+
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (freezing(task)) {
-			ntotal++;
 			/*
 			 * freezer_should_skip() indicates that the task
 			 * should be skipped when determining freezing
 			 * completion.  Consider it frozen in addition to
 			 * the usual frozen condition.
 			 */
-			if (frozen(task) || task_is_stopped_or_traced(task) ||
-			    freezer_should_skip(task))
-				nfrozen++;
+			if (!frozen(task) && !task_is_stopped_or_traced(task) &&
+			    !freezer_should_skip(task))
+				goto notyet;
 		}
 	}
 
-	if (old_state == CGROUP_THAWED) {
-		BUG_ON(nfrozen > 0);
-	} else if (old_state == CGROUP_FREEZING) {
-		if (nfrozen == ntotal)
-			freezer->state = CGROUP_FROZEN;
-	} else { /* old_state == CGROUP_FROZEN */
-		BUG_ON(nfrozen != ntotal);
-	}
-
+	freezer->state = CGROUP_FROZEN;
+notyet:
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -262,13 +260,8 @@ static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 
 	freezer = cgroup_freezer(cgroup);
 	spin_lock_irq(&freezer->lock);
+	update_if_frozen(cgroup, freezer);
 	state = freezer->state;
-	if (state == CGROUP_FREEZING) {
-		/* We change from FREEZING to FROZEN lazily if the cgroup was
-		 * only partially frozen when we exitted write. */
-		update_if_frozen(cgroup, freezer);
-		state = freezer->state;
-	}
 	spin_unlock_irq(&freezer->lock);
 	cgroup_unlock();
 
@@ -306,8 +299,6 @@ static void freezer_change_state(struct cgroup *cgroup,
 
 	spin_lock_irq(&freezer->lock);
 
-	update_if_frozen(cgroup, freezer);
-
 	switch (goal_state) {
 	case CGROUP_THAWED:
 		if (freezer->state != CGROUP_THAWED)
-- 
1.7.7.3

