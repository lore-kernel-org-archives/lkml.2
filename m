Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2KCIla (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:41:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2KCIjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:39:22 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com, mhocko@suse.cz, rjw@sisk.pl
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] cgroup_freezer: make freezer->state mask of flags
Date: Sat,  3 Nov 2012 01:38:32 -0700
Message-Id: <1351931915-1701-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351931915-1701-1-git-send-email-tj@kernel.org>
References: <1351931915-1701-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

freezer->state was an enum value - one of THAWED, FREEZING and FROZEN.
As the scheduled full hierarchy support requires more than one
freezing condition, switch it to mask of flags.  If FREEZING is not
set, it's thawed.  FREEZING is set if freezing or frozen.  If frozen,
both FREEZING and FROZEN are set.  Now that tasks can be attached to
an already frozen cgroup, this also makes freezing condition checks
more natural.

This patch doesn't introduce any behavior change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup_freezer.c | 60 ++++++++++++++++++++++---------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 2690830..e76aa9f 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -22,15 +22,14 @@
 #include <linux/freezer.h>
 #include <linux/seq_file.h>
 
-enum freezer_state {
-	CGROUP_THAWED = 0,
-	CGROUP_FREEZING,
-	CGROUP_FROZEN,
+enum freezer_state_flags {
+	CGROUP_FREEZING		= (1 << 1), /* this freezer is freezing */
+	CGROUP_FROZEN		= (1 << 3), /* this and its descendants frozen */
 };
 
 struct freezer {
 	struct cgroup_subsys_state	css;
-	enum freezer_state		state;
+	unsigned int			state;
 	spinlock_t			lock;
 };
 
@@ -48,12 +47,10 @@ static inline struct freezer *task_freezer(struct task_struct *task)
 
 bool cgroup_freezing(struct task_struct *task)
 {
-	enum freezer_state state;
 	bool ret;
 
 	rcu_read_lock();
-	state = task_freezer(task)->state;
-	ret = state == CGROUP_FREEZING || state == CGROUP_FROZEN;
+	ret = task_freezer(task)->state & CGROUP_FREEZING;
 	rcu_read_unlock();
 
 	return ret;
@@ -63,10 +60,13 @@ bool cgroup_freezing(struct task_struct *task)
  * cgroups_write_string() limits the size of freezer state strings to
  * CGROUP_LOCAL_BUFFER_SIZE
  */
-static const char *freezer_state_strs[] = {
-	"THAWED",
-	"FREEZING",
-	"FROZEN",
+static const char *freezer_state_strs(unsigned int state)
+{
+	if (state & CGROUP_FROZEN)
+		return "FROZEN";
+	if (state & CGROUP_FREEZING)
+		return "FREEZING";
+	return "THAWED";
 };
 
 /*
@@ -91,7 +91,6 @@ static struct cgroup_subsys_state *freezer_create(struct cgroup *cgroup)
 		return ERR_PTR(-ENOMEM);
 
 	spin_lock_init(&freezer->lock);
-	freezer->state = CGROUP_THAWED;
 	return &freezer->css;
 }
 
@@ -99,7 +98,7 @@ static void freezer_destroy(struct cgroup *cgroup)
 {
 	struct freezer *freezer = cgroup_freezer(cgroup);
 
-	if (freezer->state != CGROUP_THAWED)
+	if (freezer->state & CGROUP_FREEZING)
 		atomic_dec(&system_freezing_cnt);
 	kfree(freezer);
 }
@@ -129,15 +128,13 @@ static void freezer_attach(struct cgroup *new_cgrp, struct cgroup_taskset *tset)
 	 * Tasks in @tset are on @new_cgrp but may not conform to its
 	 * current state before executing the following - !frozen tasks may
 	 * be visible in a FROZEN cgroup and frozen tasks in a THAWED one.
-	 * This means that, to determine whether to freeze, one should test
-	 * whether the state equals THAWED.
 	 */
 	cgroup_taskset_for_each(task, new_cgrp, tset) {
-		if (freezer->state == CGROUP_THAWED) {
+		if (!(freezer->state & CGROUP_FREEZING)) {
 			__thaw_task(task);
 		} else {
 			freeze_task(task);
-			freezer->state = CGROUP_FREEZING;
+			freezer->state &= ~CGROUP_FROZEN;
 		}
 	}
 
@@ -159,11 +156,7 @@ static void freezer_fork(struct task_struct *task)
 		goto out;
 
 	spin_lock_irq(&freezer->lock);
-	/*
-	 * @task might have been just migrated into a FROZEN cgroup.  Test
-	 * equality with THAWED.  Read the comment in freezer_attach().
-	 */
-	if (freezer->state != CGROUP_THAWED)
+	if (freezer->state & CGROUP_FREEZING)
 		freeze_task(task);
 	spin_unlock_irq(&freezer->lock);
 out:
@@ -184,7 +177,8 @@ static void update_if_frozen(struct freezer *freezer)
 	struct cgroup_iter it;
 	struct task_struct *task;
 
-	if (freezer->state != CGROUP_FREEZING)
+	if (!(freezer->state & CGROUP_FREEZING) ||
+	    (freezer->state & CGROUP_FROZEN))
 		return;
 
 	cgroup_iter_start(cgroup, &it);
@@ -202,7 +196,7 @@ static void update_if_frozen(struct freezer *freezer)
 		}
 	}
 
-	freezer->state = CGROUP_FROZEN;
+	freezer->state |= CGROUP_FROZEN;
 notyet:
 	cgroup_iter_end(cgroup, &it);
 }
@@ -211,14 +205,14 @@ static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 			struct seq_file *m)
 {
 	struct freezer *freezer = cgroup_freezer(cgroup);
-	enum freezer_state state;
+	unsigned int state;
 
 	spin_lock_irq(&freezer->lock);
 	update_if_frozen(freezer);
 	state = freezer->state;
 	spin_unlock_irq(&freezer->lock);
 
-	seq_puts(m, freezer_state_strs[state]);
+	seq_puts(m, freezer_state_strs(state));
 	seq_putc(m, '\n');
 	return 0;
 }
@@ -258,14 +252,14 @@ static void freezer_apply_state(struct freezer *freezer, bool freeze)
 	lockdep_assert_held(&freezer->lock);
 
 	if (freeze) {
-		if (freezer->state == CGROUP_THAWED)
+		if (!(freezer->state & CGROUP_FREEZING))
 			atomic_inc(&system_freezing_cnt);
-		freezer->state = CGROUP_FREEZING;
+		freezer->state |= CGROUP_FREEZING;
 		freeze_cgroup(freezer);
 	} else {
-		if (freezer->state != CGROUP_THAWED)
+		if (freezer->state & CGROUP_FREEZING)
 			atomic_dec(&system_freezing_cnt);
-		freezer->state = CGROUP_THAWED;
+		freezer->state &= ~(CGROUP_FREEZING | CGROUP_FROZEN);
 		unfreeze_cgroup(freezer);
 	}
 }
@@ -290,9 +284,9 @@ static int freezer_write(struct cgroup *cgroup, struct cftype *cft,
 {
 	bool freeze;
 
-	if (strcmp(buffer, freezer_state_strs[CGROUP_THAWED]) == 0)
+	if (strcmp(buffer, freezer_state_strs(0)) == 0)
 		freeze = false;
-	else if (strcmp(buffer, freezer_state_strs[CGROUP_FROZEN]) == 0)
+	else if (strcmp(buffer, freezer_state_strs(CGROUP_FROZEN)) == 0)
 		freeze = true;
 	else
 		return -EINVAL;
-- 
1.7.11.7

