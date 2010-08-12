Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759606Ab0HLJpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 05:45:39 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:2922 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759515Ab0HLJpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 05:45:35 -0400
X-IronPort-AV: E=Sophos;i="4.55,357,1278280800"; 
   d="scan'208";a="67527463"
From: Tomasz Buchert <tomasz.buchert@inria.fr>
To: Matt Helsley <matthltc@us.ibm.com>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Tomasz Buchert <tomasz.buchert@inria.fr>
Subject: [PATCH 3/3] cgroup_freezer: update_freezer_state does incorrect state transactions
Date: Thu, 12 Aug 2010 11:45:23 +0200
Message-Id: <1281606323-16245-4-git-send-email-tomasz.buchert@inria.fr>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1281606323-16245-3-git-send-email-tomasz.buchert@inria.fr>
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-1-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-2-git-send-email-tomasz.buchert@inria.fr>
 <1281606323-16245-3-git-send-email-tomasz.buchert@inria.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 4 state transitions possible for a freezer.
Only FREEZING -> FROZEN transaction is done lazily.
This patch allows update_freezer_state  only to perform
this transaction and renames the function to update_if_frozen.

Moreover is_task_frozen_enough function is removed and its
every occurence is replaced with frozen(). Therefore for a group
to become FROZEN every task must be frozen.

The previous version could trigger a following bug:
When cgroup is in the process of freezing (but none of its tasks
are frozen yet), update_freezer_state() (called from freezer_read
or freezer_write) would incorrectly report that a group is 'THAWED'
(because nfrozen = 0), allowing the transaction FREEZING -> THAWED
without writing anything to 'freezer.state'. This is incorrect
according to the documentation. This could result in a 'THAWED' cgroup
with frozen tasks inside.

A code to reproduce this bug is available here:
http://pentium.hopto.org/~thinred/repos/linux-misc/freezer_bug2.c

Signed-off-by: Tomasz Buchert <tomasz.buchert@inria.fr>
---
 kernel/cgroup_freezer.c |   40 +++++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index c287627..a5f7cb6 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -153,13 +153,6 @@ static void freezer_destroy(struct cgroup_subsys *ss,
 	kfree(cgroup_freezer(cgroup));
 }
 
-/* Task is frozen or will freeze immediately when next it gets woken */
-static bool is_task_frozen_enough(struct task_struct *task)
-{
-	return frozen(task) ||
-		(task_is_stopped_or_traced(task) && freezing(task));
-}
-
 /*
  * The call to cgroup_lock() in the freezer.state write method prevents
  * a write to that file racing against an attach, and hence the
@@ -236,31 +229,32 @@ static void freezer_fork(struct cgroup_subsys *ss, struct task_struct *task)
 /*
  * caller must hold freezer->lock
  */
-static void update_freezer_state(struct cgroup *cgroup,
+static void update_if_frozen(struct cgroup *cgroup,
 				 struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
 	unsigned int nfrozen = 0, ntotal = 0;
+	enum freezer_state old_state = freezer->state;
 
 	cgroup_iter_start(cgroup, &it);
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		ntotal++;
-		if (is_task_frozen_enough(task))
+		if (frozen(task))
 			nfrozen++;
 	}
 
-	/*
-	 * Transition to FROZEN when no new tasks can be added ensures
-	 * that we never exist in the FROZEN state while there are unfrozen
-	 * tasks.
-	 */
-	if (nfrozen == ntotal)
-		freezer->state = CGROUP_FROZEN;
-	else if (nfrozen > 0)
-		freezer->state = CGROUP_FREEZING;
-	else
-		freezer->state = CGROUP_THAWED;
+	if (old_state == CGROUP_THAWED) {
+		BUG_ON(nfrozen > 0);
+	}
+	else if (old_state == CGROUP_FREEZING) {
+		if (nfrozen == ntotal)
+			freezer->state = CGROUP_FROZEN;
+	}
+	else { /* old_state == CGROUP_FROZEN */
+		BUG_ON(nfrozen != ntotal);
+	}
+
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -279,7 +273,7 @@ static int freezer_read(struct cgroup *cgroup, struct cftype *cft,
 	if (state == CGROUP_FREEZING) {
 		/* We change from FREEZING to FROZEN lazily if the cgroup was
 		 * only partially frozen when we exitted write. */
-		update_freezer_state(cgroup, freezer);
+		update_if_frozen(cgroup, freezer);
 		state = freezer->state;
 	}
 	spin_unlock_irq(&freezer->lock);
@@ -301,7 +295,7 @@ static int try_to_freeze_cgroup(struct cgroup *cgroup, struct freezer *freezer)
 	while ((task = cgroup_iter_next(cgroup, &it))) {
 		if (!freeze_task(task, true))
 			continue;
-		if (is_task_frozen_enough(task))
+		if (frozen(task))
 			continue;
 		if (!freezing(task) && !freezer_should_skip(task))
 			num_cant_freeze_now++;
@@ -335,7 +329,7 @@ static int freezer_change_state(struct cgroup *cgroup,
 
 	spin_lock_irq(&freezer->lock);
 
-	update_freezer_state(cgroup, freezer);
+	update_if_frozen(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
 
-- 
1.6.3.3

