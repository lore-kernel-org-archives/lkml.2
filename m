Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1HYPR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:17:56 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34634 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HYPJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:54 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 086/118] drbd: Converted drbd_do_handshake() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:22 +0200
Message-Id: <1314284934-17999-87-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   30 +++++++++++++++---------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4369651..7c6c385 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -60,7 +60,7 @@ enum finish_epoch {
 	FE_RECYCLED,
 };
 
-static int drbd_do_handshake(struct drbd_conf *mdev);
+static int drbd_do_handshake(struct drbd_tconn *tconn);
 static int drbd_do_auth(struct drbd_conf *mdev);
 
 static enum finish_epoch drbd_may_finish_epoch(struct drbd_conf *, struct drbd_epoch *, enum epoch_event);
@@ -883,7 +883,7 @@ retry:
 
 	D_ASSERT(mdev->tconn->asender.task == NULL);
 
-	h = drbd_do_handshake(mdev);
+	h = drbd_do_handshake(mdev->tconn);
 	if (h <= 0)
 		return h;
 
@@ -3994,39 +3994,39 @@ static int drbd_send_handshake(struct drbd_tconn *tconn)
  *  -1 peer talks different language,
  *     no point in trying again, please go standalone.
  */
-static int drbd_do_handshake(struct drbd_conf *mdev)
+static int drbd_do_handshake(struct drbd_tconn *tconn)
 {
-	/* ASSERT current == mdev->tconn->receiver ... */
-	struct p_handshake *p = &mdev->tconn->data.rbuf.handshake;
+	/* ASSERT current == tconn->receiver ... */
+	struct p_handshake *p = &tconn->data.rbuf.handshake;
 	const int expect = sizeof(struct p_handshake) - sizeof(struct p_header80);
 	struct packet_info pi;
 	int rv;
 
-	rv = drbd_send_handshake(mdev->tconn);
+	rv = drbd_send_handshake(tconn);
 	if (!rv)
 		return 0;
 
-	rv = drbd_recv_header(mdev->tconn, &pi);
+	rv = drbd_recv_header(tconn, &pi);
 	if (!rv)
 		return 0;
 
 	if (pi.cmd != P_HAND_SHAKE) {
-		dev_err(DEV, "expected HandShake packet, received: %s (0x%04x)\n",
+		conn_err(tconn, "expected HandShake packet, received: %s (0x%04x)\n",
 		     cmdname(pi.cmd), pi.cmd);
 		return -1;
 	}
 
 	if (pi.size != expect) {
-		dev_err(DEV, "expected HandShake length: %u, received: %u\n",
+		conn_err(tconn, "expected HandShake length: %u, received: %u\n",
 		     expect, pi.size);
 		return -1;
 	}
 
-	rv = drbd_recv(mdev->tconn, &p->head.payload, expect);
+	rv = drbd_recv(tconn, &p->head.payload, expect);
 
 	if (rv != expect) {
 		if (!signal_pending(current))
-			dev_warn(DEV, "short read receiving handshake packet: l=%u\n", rv);
+			conn_warn(tconn, "short read receiving handshake packet: l=%u\n", rv);
 		return 0;
 	}
 
@@ -4039,15 +4039,15 @@ static int drbd_do_handshake(struct drbd_conf *mdev)
 	    PRO_VERSION_MIN > p->protocol_max)
 		goto incompat;
 
-	mdev->tconn->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
+	tconn->agreed_pro_version = min_t(int, PRO_VERSION_MAX, p->protocol_max);
 
-	dev_info(DEV, "Handshake successful: "
-	     "Agreed network protocol version %d\n", mdev->tconn->agreed_pro_version);
+	conn_info(tconn, "Handshake successful: "
+	     "Agreed network protocol version %d\n", tconn->agreed_pro_version);
 
 	return 1;
 
  incompat:
-	dev_err(DEV, "incompatible DRBD dialects: "
+	conn_err(tconn, "incompatible DRBD dialects: "
 	    "I support %d-%d, peer supports %d-%d\n",
 	    PRO_VERSION_MIN, PRO_VERSION_MAX,
 	    p->protocol_min, p->protocol_max);
-- 
1.7.4.1

