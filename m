Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab2KCIj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:39:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36901 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab2KCIjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:39:13 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] cgroup_freezer: trivial cleanups
Date: Sat,  3 Nov 2012 01:38:30 -0700
Message-Id: <1351931915-1701-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Clean-up indentation and line-breaks.  Drop the invalid comment
  about freezer->lock.

* Make all internal functions take @freezer instead of both @cgroup
  and @freezer.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup_freezer.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index bedefd9..975b3d8 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -29,17 +29,15 @@ enum freezer_state {
 };
 
 struct freezer {
-	struct cgroup_subsys_state css;
-	enum freezer_state state;
-	spinlock_t lock; /* protects _writes_ to state */
+	struct cgroup_subsys_state	css;
+	enum freezer_state		state;
+	spinlock_t			lock;
 };
 
-static inline struct freezer *cgroup_freezer(
-		struct cgroup *cgroup)
+static inline struct freezer *cgroup_freezer(struct cgroup *cgroup)
 {
-	return container_of(
-		cgroup_subsys_state(cgroup, freezer_subsys_id),
-		struct freezer, css);
+	return container_of(cgroup_subsys_state(cgroup, freezer_subsys_id),
+			    struct freezer, css);
 }
 
 static inline struct freezer *task_freezer(struct task_struct *task)
@@ -180,8 +178,9 @@ out:
  * migrated into or out of @cgroup, so we can't verify task states against
  * @freezer state here.  See freezer_attach() for details.
  */
-static void update_if_frozen(struct cgroup *cgroup, struct freezer *freezer)
+static void update_if_frozen(struct freezer *freezer)
 {
+	struct cgroup *cgroup = freezer->css.cgroup;
 	struct cgroup_iter it;
 	struct task_struct *task;
 
@@ -211,12 +210,11 @@ notyet:
 static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 			struct seq_file *m)
 {
-	struct freezer *freezer;
+	struct freezer *freezer = cgroup_freezer(cgroup);
 	enum freezer_state state;
 
-	freezer = cgroup_freezer(cgroup);
 	spin_lock_irq(&freezer->lock);
-	update_if_frozen(cgroup, freezer);
+	update_if_frozen(freezer);
 	state = freezer->state;
 	spin_unlock_irq(&freezer->lock);
 
@@ -225,8 +223,9 @@ static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 	return 0;
 }
 
-static void freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+static void freeze_cgroup(struct freezer *freezer)
 {
+	struct cgroup *cgroup = freezer->css.cgroup;
 	struct cgroup_iter it;
 	struct task_struct *task;
 
@@ -236,8 +235,9 @@ static void freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	cgroup_iter_end(cgroup, &it);
 }
 
-static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
+static void unfreeze_cgroup(struct freezer *freezer)
 {
+	struct cgroup *cgroup = freezer->css.cgroup;
 	struct cgroup_iter it;
 	struct task_struct *task;
 
@@ -247,11 +247,9 @@ static void unfreeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	cgroup_iter_end(cgroup, &it);
 }
 
-static void freezer_change_state(struct cgroup *cgroup,
+static void freezer_change_state(struct freezer *freezer,
 				 enum freezer_state goal_state)
 {
-	struct freezer *freezer = cgroup_freezer(cgroup);
-
 	/* also synchronizes against task migration, see freezer_attach() */
 	spin_lock_irq(&freezer->lock);
 
@@ -260,13 +258,13 @@ static void freezer_change_state(struct cgroup *cgroup,
 		if (freezer->state != CGROUP_THAWED)
 			atomic_dec(&system_freezing_cnt);
 		freezer->state = CGROUP_THAWED;
-		unfreeze_cgroup(cgroup, freezer);
+		unfreeze_cgroup(freezer);
 		break;
 	case CGROUP_FROZEN:
 		if (freezer->state == CGROUP_THAWED)
 			atomic_inc(&system_freezing_cnt);
 		freezer->state = CGROUP_FREEZING;
-		freeze_cgroup(cgroup, freezer);
+		freeze_cgroup(freezer);
 		break;
 	default:
 		BUG();
@@ -275,8 +273,7 @@ static void freezer_change_state(struct cgroup *cgroup,
 	spin_unlock_irq(&freezer->lock);
 }
 
-static int freezer_write(struct cgroup *cgroup,
-			 struct cftype *cft,
+static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
 			 const char *buffer)
 {
 	enum freezer_state goal_state;
@@ -288,7 +285,7 @@ static int freezer_write(struct cgroup *cgroup,
 	else
 		return -EINVAL;
 
-	freezer_change_state(cgroup, goal_state);
+	freezer_change_state(cgroup_freezer(cgroup), goal_state);
 	return 0;
 }
 
-- 
1.7.11.7

