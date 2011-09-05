Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1IELuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60137 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab1IELqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:03 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 33/54] drbd: drbd_send_dblock(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:24 +0200
Message-Id: <1315223145-20640-34-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c   |   23 ++++++++++++-----------
 drivers/block/drbd/drbd_worker.c |    2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a12cd82..68baeea 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1539,14 +1539,15 @@ static u32 bio_flags_to_wire(struct drbd_conf *mdev, unsigned long bi_rw)
  */
 int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 {
-	int ok = 1;
+	int err;
 	struct p_data p;
 	unsigned int dp_flags = 0;
 	void *dgb;
 	int dgs;
 
-	if (drbd_get_data_sock(mdev->tconn))
-		return 0;
+	err = drbd_get_data_sock(mdev->tconn);
+	if (err)
+		return err;
 
 	dgs = (mdev->tconn->agreed_pro_version >= 87 && mdev->tconn->integrity_w_tfm) ?
 		crypto_hash_digestsize(mdev->tconn->integrity_w_tfm) : 0;
@@ -1564,14 +1565,14 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 
 	p.dp_flags = cpu_to_be32(dp_flags);
 	set_bit(UNPLUG_REMOTE, &mdev->flags);
-	ok = (sizeof(p) ==
-		drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), dgs ? MSG_MORE : 0));
-	if (ok && dgs) {
+	err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, &p,
+			    sizeof(p), dgs ? MSG_MORE : 0);
+	if (!err && dgs) {
 		dgb = mdev->tconn->int_dig_out;
 		drbd_csum_bio(mdev, mdev->tconn->integrity_w_tfm, req->master_bio, dgb);
-		ok = dgs == drbd_send(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
+		err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, dgb, dgs, 0);
 	}
-	if (ok) {
+	if (!err) {
 		/* For protocol A, we have to memcpy the payload into
 		 * socket buffers, as we may complete right away
 		 * as soon as we handed it over to tcp, at which point the data
@@ -1584,9 +1585,9 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 		 * receiving side, we sure have detected corruption elsewhere.
 		 */
 		if (mdev->tconn->net_conf->wire_protocol == DRBD_PROT_A || dgs)
-			ok = !_drbd_send_bio(mdev, req->master_bio);
+			err = _drbd_send_bio(mdev, req->master_bio);
 		else
-			ok = !_drbd_send_zc_bio(mdev, req->master_bio);
+			err = _drbd_send_zc_bio(mdev, req->master_bio);
 
 		/* double check digest, sometimes buffers have been modified in flight. */
 		if (dgs > 0 && dgs <= 64) {
@@ -1606,7 +1607,7 @@ int drbd_send_dblock(struct drbd_conf *mdev, struct drbd_request *req)
 
 	drbd_put_data_sock(mdev->tconn);
 
-	return ok;
+	return err;
 }
 
 /* answer packet, used to send data back for read requests:
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 2528f3d..81ddf1c 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1264,7 +1264,7 @@ int w_send_dblock(struct drbd_work *w, int cancel)
 		return 1;
 	}
 
-	ok = drbd_send_dblock(mdev, req);
+	ok = !drbd_send_dblock(mdev, req);
 	req_mod(req, ok ? HANDED_OVER_TO_NETWORK : SEND_FAILED);
 
 	return ok;
-- 
1.7.4.1

