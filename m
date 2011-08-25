Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab1HYPTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:19:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34594 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797Ab1HYPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:50 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 081/118] drbd: Converted drbd_send_handshake() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:17 +0200
Message-Id: <1314284934-17999-82-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_receiver.c |   20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 615405d..d238bb1 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -377,7 +377,7 @@ struct p_block_req {
  */
 
 struct p_handshake {
-	struct p_header head;	/* Note: You must always use a h80 here */
+	struct p_header head;   /* Note: vnr will be ignored */
 	u32 protocol_min;
 	u32 feature_flags;
 	u32 protocol_max;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 080c91b..e4aa2d6 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -3956,28 +3956,28 @@ static void drbd_disconnect(struct drbd_conf *mdev)
  *
  * for now, they are expected to be zero, but ignored.
  */
-static int drbd_send_handshake(struct drbd_conf *mdev)
+static int drbd_send_handshake(struct drbd_tconn *tconn)
 {
 	/* ASSERT current == mdev->tconn->receiver ... */
-	struct p_handshake *p = &mdev->tconn->data.sbuf.handshake;
+	struct p_handshake *p = &tconn->data.sbuf.handshake;
 	int ok;
 
-	if (mutex_lock_interruptible(&mdev->tconn->data.mutex)) {
-		dev_err(DEV, "interrupted during initial handshake\n");
+	if (mutex_lock_interruptible(&tconn->data.mutex)) {
+		conn_err(tconn, "interrupted during initial handshake\n");
 		return 0; /* interrupted. not ok. */
 	}
 
-	if (mdev->tconn->data.socket == NULL) {
-		mutex_unlock(&mdev->tconn->data.mutex);
+	if (tconn->data.socket == NULL) {
+		mutex_unlock(&tconn->data.mutex);
 		return 0;
 	}
 
 	memset(p, 0, sizeof(*p));
 	p->protocol_min = cpu_to_be32(PRO_VERSION_MIN);
 	p->protocol_max = cpu_to_be32(PRO_VERSION_MAX);
-	ok = _drbd_send_cmd(mdev, mdev->tconn->data.socket, P_HAND_SHAKE,
-			    &p->head, sizeof(*p), 0 );
-	mutex_unlock(&mdev->tconn->data.mutex);
+	ok = _conn_send_cmd(tconn, 0, tconn->data.socket, P_HAND_SHAKE,
+			    &p->head, sizeof(*p), 0);
+	mutex_unlock(&tconn->data.mutex);
 	return ok;
 }
 
@@ -3997,7 +3997,7 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	enum drbd_packet cmd;
 	int rv;
 
-	rv = drbd_send_handshake(mdev);
+	rv = drbd_send_handshake(mdev->tconn);
 	if (!rv)
 		return 0;
 
-- 
1.7.4.1

