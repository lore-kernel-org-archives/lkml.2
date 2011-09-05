Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab1IELwW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:52:22 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59820 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab1IELpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/54] drbd: drbd_get_data_sock(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:44:52 +0200
Message-Id: <1315223145-20640-2-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h    |   17 ++++-------------
 drivers/block/drbd/drbd_main.c   |    8 ++++----
 drivers/block/drbd/drbd_worker.c |    2 +-
 3 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index a9138ff..eaa1fd5 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1115,24 +1115,15 @@ static inline struct drbd_conf *vnr_to_mdev(struct drbd_tconn *tconn, int vnr)
 	return (struct drbd_conf *)idr_find(&tconn->volumes, vnr);
 }
 
-/* returns 1 if it was successful,
- * returns 0 if there was no data socket.
- * so wherever you are going to use the data.socket, e.g. do
- * if (!drbd_get_data_sock(mdev->tconn))
- *	return 0;
- *	CODE();
- * drbd_get_data_sock(mdev->tconn);
- */
 static inline int drbd_get_data_sock(struct drbd_tconn *tconn)
 {
 	mutex_lock(&tconn->data.mutex);
-	/* drbd_disconnect() could have called drbd_free_sock()
-	 * while we were waiting in down()... */
-	if (unlikely(tconn->data.socket == NULL)) {
+	if (!tconn->data.socket) {
+		/* Disconnected.  */
 		mutex_unlock(&tconn->data.mutex);
-		return 0;
+		return -EIO;
 	}
-	return 1;
+	return 0;
 }
 
 static inline void drbd_put_data_sock(struct drbd_tconn *tconn)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dc8ebd2..628005a 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -773,7 +773,7 @@ int conn_send_cmd2(struct drbd_tconn *tconn, enum drbd_packet cmd, char *data,
 
 	prepare_header80(&h, cmd, size);
 
-	if (!drbd_get_data_sock(tconn))
+	if (drbd_get_data_sock(tconn))
 		return 0;
 
 	ok = (sizeof(h) ==
@@ -1245,7 +1245,7 @@ int drbd_send_bitmap(struct drbd_conf *mdev)
 {
 	int err;
 
-	if (!drbd_get_data_sock(mdev->tconn))
+	if (drbd_get_data_sock(mdev->tconn))
 		return -1;
 	err = !_drbd_send_bitmap(mdev);
 	drbd_put_data_sock(mdev->tconn);
@@ -1562,7 +1562,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 	void *dgb;
 	int dgs;
 
-	if (!drbd_get_data_sock(mdev->tconn))
+	if (drbd_get_data_sock(mdev->tconn))
 		return 0;
 
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
@@ -1652,7 +1652,7 @@ int drbd_send_block(struct drbd_conf *mdev, enum drbd_packet cmd,
 	 * This one may be interrupted by DRBD_SIG and/or DRBD_SIGKILL
 	 * in response to admin command or module unload.
 	 */
-	if (!drbd_get_data_sock(mdev->tconn))
+	if (drbd_get_data_sock(mdev->tconn))
 		return 0;
 
 	ok = sizeof(p) == drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 005876b..39e4915 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1209,7 +1209,7 @@ int w_send_barrier(struct drbd_work *w, int cancel)
 	if (cancel)
 		return 1;
 
-	if (!drbd_get_data_sock(mdev->tconn))
+	if (drbd_get_data_sock(mdev->tconn))
 		return 0;
 	p->barrier = b->br_number;
 	/* inc_ap_pending was done where this was queued.
-- 
1.7.4.1

