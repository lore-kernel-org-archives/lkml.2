Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1HaKVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 06:21:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab1HaKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 06:21:16 -0400
Date: Wed, 31 Aug 2011 12:21:07 +0200
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Oleg Nesterov <oleg@redhat.com>,
        Paul Menage <paul@paulmenage.org>
Cc: containers@lists.linux-foundation.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH pm-freezer 1/4] cgroup_freezer: fix freezer->state setting
 bug in freezer_change_state()
Message-ID: <20110831102100.GA2828@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Menage <paul@paulmenage.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
---
I'm in the process of moving and can only use a quite old laptop.  I
tested compile but couldn't really do much else, so please proceed
with caution.  Oleg, can you please ack the patches if you agree with
the updated versions?

Thanks.

 kernel/cgroup_freezer.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

Index: work/kernel/cgroup_freezer.c
===================================================================
--- work.orig/kernel/cgroup_freezer.c
+++ work/kernel/cgroup_freezer.c
@@ -308,24 +308,26 @@ static int freezer_change_state(struct c
 	spin_lock_irq(&freezer->lock);
 
 	update_if_frozen(cgroup, freezer);
-	if (goal_state == freezer->state)
-		goto out;
-
-	freezer->state = goal_state;
 
 	switch (goal_state) {
 	case CGROUP_THAWED:
-		atomic_dec(&system_freezing_cnt);
-		unfreeze_cgroup(cgroup, freezer);
+		if (freezer->state != CGROUP_THAWED) {
+			freezer->state = CGROUP_THAWED;
+			atomic_dec(&system_freezing_cnt);
+			unfreeze_cgroup(cgroup, freezer);
+		}
 		break;
 	case CGROUP_FROZEN:
-		atomic_inc(&system_freezing_cnt);
-		retval = try_to_freeze_cgroup(cgroup, freezer);
+		if (freezer->state == CGROUP_THAWED) {
+			freezer->state = CGROUP_FREEZING;
+			atomic_inc(&system_freezing_cnt);
+			retval = try_to_freeze_cgroup(cgroup, freezer);
+		}
 		break;
 	default:
 		BUG();
 	}
-out:
+
 	spin_unlock_irq(&freezer->lock);
 
 	return retval;
