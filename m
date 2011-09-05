Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1IELtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:49:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60528 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1IELqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 37/54] drbd: drbd_process_done_ee(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:28 +0200
Message-Id: <1315223145-20640-38-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9048c00e..8000637 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -409,7 +409,7 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	LIST_HEAD(work_list);
 	LIST_HEAD(reclaimed);
 	struct drbd_peer_request *peer_req, *t;
-	int ok = 1;
+	int err = 0;
 
 	spin_lock_irq(&mdev->tconn->req_lock);
 	reclaim_net_ee(mdev, &reclaimed);
@@ -424,13 +424,17 @@ static int drbd_process_done_ee(struct drbd_conf *mdev)
 	 * all ignore the last argument.
 	 */
 	list_for_each_entry_safe(peer_req, t, &work_list, w.list) {
+		int err2;
+
 		/* list_del not necessary, next/prev members not touched */
-		ok = !peer_req->w.cb(&peer_req->w, !ok) && ok;
+		err2 = peer_req->w.cb(&peer_req->w, !!err);
+		if (!err)
+			err = err2;
 		drbd_free_ee(mdev, peer_req);
 	}
 	wake_up(&mdev->ee_wait);
 
-	return ok;
+	return err;
 }
 
 void _drbd_wait_ee_list_empty(struct drbd_conf *mdev, struct list_head *head)
@@ -4709,7 +4713,7 @@ static int tconn_process_done_ee(struct drbd_tconn *tconn)
 		clear_bit(SIGNAL_ASENDER, &tconn->flags);
 		flush_signals(current);
 		idr_for_each_entry(&tconn->volumes, mdev, i) {
-			if (!drbd_process_done_ee(mdev))
+			if (drbd_process_done_ee(mdev))
 				return 1; /* error */
 		}
 		set_bit(SIGNAL_ASENDER, &tconn->flags);
-- 
1.7.4.1

