Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1IELvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:18 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59839 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1IELpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:52 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 10/54] drbd: drbd_send_state(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:01 +0200
Message-Id: <1315223145-20640-11-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_state.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7a5019a..4e53450 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -974,7 +974,7 @@ int drbd_send_state(struct drbd_conf *mdev)
 {
 	struct socket *sock;
 	struct p_state p;
-	int ok = 0;
+	int err = -EIO;
 
 	mutex_lock(&mdev->tconn->data.mutex);
 
@@ -982,11 +982,11 @@ int drbd_send_state(struct drbd_conf *mdev)
 	sock = mdev->tconn->data.socket;
 
 	if (likely(sock != NULL))
-		ok = !_drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
+		err = _drbd_send_cmd(mdev, sock, P_STATE, &p.head, sizeof(p), 0);
 
 	mutex_unlock(&mdev->tconn->data.mutex);
 
-	return ok;
+	return err;
 }
 
 int _conn_send_state_req(struct drbd_tconn *tconn, int vnr, enum drbd_packet cmd,
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d93bb3c..66772be 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -766,7 +766,7 @@ int drbd_connected(int vnr, void *p, void *data)
 	ok &= !drbd_send_sync_param(mdev);
 	ok &= drbd_send_sizes(mdev, 0, 0);
 	ok &= drbd_send_uuids(mdev);
-	ok &= drbd_send_state(mdev);
+	ok &= !drbd_send_state(mdev);
 	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
 	clear_bit(RESIZE_PENDING, &mdev->flags);
 
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index 42a94cd..f1a55d8 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1189,7 +1189,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
 				"ASSERT FAILED: disk is %s during detach\n",
 				drbd_disk_str(mdev->state.disk));
 
-		if (drbd_send_state(mdev))
+		if (!drbd_send_state(mdev))
 			dev_warn(DEV, "Notified peer that I am detaching my disk\n");
 		else
 			dev_err(DEV, "Sending state for detaching disk failed\n");
@@ -1221,7 +1221,7 @@ static void after_state_ch(struct drbd_conf *mdev, union drbd_state os,
                 mdev->rs_failed = 0;
                 atomic_set(&mdev->rs_pending_cnt, 0);
 
-		if (drbd_send_state(mdev))
+		if (!drbd_send_state(mdev))
 			dev_warn(DEV, "Notified peer that I'm now diskless.\n");
 		/* corresponding get_ldev in __drbd_set_state
 		 * this may finally trigger drbd_ldev_destroy. */
-- 
1.7.4.1

