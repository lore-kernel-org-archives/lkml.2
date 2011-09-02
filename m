Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1IBS2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:28:07 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48944 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1IBS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:28:05 -0400
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, matthltc@us.ibm.com, rjw@sisk.pl, paul@paulmenage.org
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup_freezer: fix freezer->state setting bug in freezer_change_state()
Date: Sat,  3 Sep 2011 03:27:45 +0900
Message-Id: <1314988070-12244-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314988070-12244-1-git-send-email-tj@kernel.org>
References: <1314988070-12244-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d02f52811d0e "cgroup_freezer: prepare for removal of TIF_FREEZE" moved
setting of freezer->state into freezer_change_state(); unfortunately,
while doing so, when it's beginning to freeze tasks, it sets the state
to CGROUP_FROZEN instead of CGROUP_FREEZING ending up skipping the
whole freezing state.  Fix it.

-v2: Oleg pointed out that re-freezing FROZEN cgroup could increment
     system_freezing_cnt.  Fixed.

-v3: Matt pointed out that setting CGROUP_FROZEN always invoked
     try_to_freeze_cgroup() regardless of the current state.  Patch
     updated such that the actual freeze/thaw operations are always
     performed on state changes.  This shouldn't make any difference
     unless something is broken.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>
---
 kernel/cgroup_freezer.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 4e82525..56a457a 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -308,24 +308,24 @@ static int freezer_change_state(struct cgroup *cgroup,
 	spin_lock_irq(&freezer->lock);
 
 	update_if_frozen(cgroup, freezer);
-	if (goal_state == freezer->state)
-		goto out;
-
-	freezer->state = goal_state;
 
 	switch (goal_state) {
 	case CGROUP_THAWED:
-		atomic_dec(&system_freezing_cnt);
+		if (freezer->state != CGROUP_THAWED)
+			atomic_dec(&system_freezing_cnt);
+		freezer->state = CGROUP_THAWED;
 		unfreeze_cgroup(cgroup, freezer);
 		break;
 	case CGROUP_FROZEN:
-		atomic_inc(&system_freezing_cnt);
+		if (freezer->state == CGROUP_THAWED)
+			atomic_inc(&system_freezing_cnt);
+		freezer->state = CGROUP_FREEZING;
 		retval = try_to_freeze_cgroup(cgroup, freezer);
 		break;
 	default:
 		BUG();
 	}
-out:
+
 	spin_unlock_irq(&freezer->lock);
 
 	return retval;
-- 
1.7.6

