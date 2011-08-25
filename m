Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1HYPXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:23:50 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33400 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1HYPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:39 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 065/118] drbd: Do no sleep long in drbd_start_resync
Date: Thu, 25 Aug 2011 17:08:01 +0200
Message-Id: <1314284934-17999-66-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work items that sleep too long can cause requests to take as
long as the longest sleeping work item.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h    |    1 +
 drivers/block/drbd/drbd_worker.c |   58 +++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 4dfbbbc..c625f59 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -787,6 +787,7 @@ enum {
 	NEW_CUR_UUID,		/* Create new current UUID when thawing IO */
 	AL_SUSPENDED,		/* Activity logging is currently suspended. */
 	AHEAD_TO_SYNC_SOURCE,   /* Ahead -> SyncSource queued */
+	B_RS_H_DONE,		/* Before resync handler done (already executed) */
 };
 
 struct drbd_bitmap; /* opaque for drbd_conf */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 28925d3..a705979 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1487,35 +1487,49 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 		   Ahead/Behind and SyncSource/SyncTarget */
 	}
 
-	if (side == C_SYNC_TARGET) {
-		/* Since application IO was locked out during C_WF_BITMAP_T and
-		   C_WF_SYNC_UUID we are still unmodified. Before going to C_SYNC_TARGET
-		   we check that we might make the data inconsistent. */
-		r = drbd_khelper(mdev, "before-resync-target");
-		r = (r >> 8) & 0xff;
-		if (r > 0) {
-			dev_info(DEV, "before-resync-target handler returned %d, "
-			     "dropping connection.\n", r);
-			drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
-			return;
-		}
-	} else /* C_SYNC_SOURCE */ {
-		r = drbd_khelper(mdev, "before-resync-source");
-		r = (r >> 8) & 0xff;
-		if (r > 0) {
-			if (r == 3) {
-				dev_info(DEV, "before-resync-source handler returned %d, "
-					 "ignoring. Old userland tools?", r);
-			} else {
-				dev_info(DEV, "before-resync-source handler returned %d, "
+	if (!test_bit(B_RS_H_DONE, &mdev->flags)) {
+		if (side == C_SYNC_TARGET) {
+			/* Since application IO was locked out during C_WF_BITMAP_T and
+			   C_WF_SYNC_UUID we are still unmodified. Before going to C_SYNC_TARGET
+			   we check that we might make the data inconsistent. */
+			r = drbd_khelper(mdev, "before-resync-target");
+			r = (r >> 8) & 0xff;
+			if (r > 0) {
+				dev_info(DEV, "before-resync-target handler returned %d, "
 					 "dropping connection.\n", r);
 				drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
 				return;
 			}
+		} else /* C_SYNC_SOURCE */ {
+			r = drbd_khelper(mdev, "before-resync-source");
+			r = (r >> 8) & 0xff;
+			if (r > 0) {
+				if (r == 3) {
+					dev_info(DEV, "before-resync-source handler returned %d, "
+						 "ignoring. Old userland tools?", r);
+				} else {
+					dev_info(DEV, "before-resync-source handler returned %d, "
+						 "dropping connection.\n", r);
+					drbd_force_state(mdev, NS(conn, C_DISCONNECTING));
+					return;
+				}
+			}
 		}
 	}
 
-	drbd_state_lock(mdev);
+	if (current == mdev->tconn->worker.task) {
+		/* The worker should not sleep waiting for drbd_state_lock(),
+		   that can take long */
+		if (test_and_set_bit(CLUSTER_ST_CHANGE, &mdev->flags)) {
+			set_bit(B_RS_H_DONE, &mdev->flags);
+			mdev->start_resync_timer.expires = jiffies + HZ/5;
+			add_timer(&mdev->start_resync_timer);
+			return;
+		}
+	} else {
+		drbd_state_lock(mdev);
+	}
+	clear_bit(B_RS_H_DONE, &mdev->flags);
 
 	if (!get_ldev_if_state(mdev, D_NEGOTIATING)) {
 		drbd_state_unlock(mdev);
-- 
1.7.4.1

