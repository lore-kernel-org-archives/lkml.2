Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1IELuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:50:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60338 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab1IELqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:02 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 26/54] drbd: drbd_send_drequest_csum(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:17 +0200
Message-Id: <1315223145-20640-27-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c   |   12 +++++-------
 drivers/block/drbd/drbd_worker.c |   12 ++++++------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c0f6146..1e19f2e 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1320,7 +1320,7 @@ int drbd_send_drequest(struct drbd_conf *mdev, int cmd,
 int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
 			    void *digest, int digest_size, enum drbd_packet cmd)
 {
-	int ok;
+	int err;
 	struct p_block_req p;
 
 	prepare_header(mdev, &p.head, cmd, sizeof(p) - sizeof(struct p_header) + digest_size);
@@ -1329,13 +1329,11 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev, sector_t sector, int size,
 	p.blksize  = cpu_to_be32(size);
 
 	mutex_lock(&mdev->tconn->data.mutex);
-
-	ok = (sizeof(p) == drbd_send(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), 0));
-	ok = ok && (digest_size == drbd_send(mdev->tconn, mdev->tconn->data.socket, digest, digest_size, 0));
-
+	err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, &p, sizeof(p), 0);
+	if (!err)
+		err = drbd_send_all(mdev->tconn, mdev->tconn->data.socket, digest, digest_size, 0);
 	mutex_unlock(&mdev->tconn->data.mutex);
-
-	return ok;
+	return err;
 }
 
 int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index dc07437..e4874ae 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -324,9 +324,9 @@ static int w_e_send_csum(struct drbd_work *w, int cancel)
 		drbd_free_ee(mdev, peer_req);
 		peer_req = NULL;
 		inc_rs_pending(mdev);
-		ok = drbd_send_drequest_csum(mdev, sector, size,
-					     digest, digest_size,
-					     P_CSUM_RS_REQUEST);
+		ok = !drbd_send_drequest_csum(mdev, sector, size,
+					      digest, digest_size,
+					      P_CSUM_RS_REQUEST);
 		kfree(digest);
 	} else {
 		dev_err(DEV, "kmalloc() of digest failed.\n");
@@ -1089,9 +1089,9 @@ int w_e_end_ov_req(struct drbd_work *w, int cancel)
 	drbd_free_ee(mdev, peer_req);
 	peer_req = NULL;
 	inc_rs_pending(mdev);
-	ok = drbd_send_drequest_csum(mdev, sector, size,
-				     digest, digest_size,
-				     P_OV_REPLY);
+	ok = !drbd_send_drequest_csum(mdev, sector, size,
+				      digest, digest_size,
+				      P_OV_REPLY);
 	if (!ok)
 		dec_rs_pending(mdev);
 	kfree(digest);
-- 
1.7.4.1

