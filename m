Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1IELrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:46 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60316 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab1IELqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 42/54] drbd: recv_resync_read(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:33 +0200
Message-Id: <1315223145-20640-43-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 6e5ffeb..87f03ca 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1518,7 +1518,7 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 
 	atomic_add(data_size >> 9, &mdev->rs_sect_ev);
 	if (drbd_submit_peer_request(mdev, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
-		return true;
+		return 0;
 
 	/* don't care for the reason here */
 	dev_err(DEV, "submit failed, triggering re-connect\n");
@@ -1529,7 +1529,7 @@ static int recv_resync_read(struct drbd_conf *mdev, sector_t sector, int data_si
 	drbd_free_ee(mdev, peer_req);
 fail:
 	put_ldev(mdev);
-	return false;
+	return -EIO;
 }
 
 static struct drbd_request *
@@ -1593,7 +1593,7 @@ static int receive_RSDataReply(struct drbd_conf *mdev, enum drbd_packet cmd,
 		/* data is submitted to disk within recv_resync_read.
 		 * corresponding put_ldev done below on error,
 		 * or in drbd_peer_request_endio. */
-		ok = recv_resync_read(mdev, sector, data_size);
+		ok = !recv_resync_read(mdev, sector, data_size);
 	} else {
 		if (__ratelimit(&drbd_ratelimit_state))
 			dev_err(DEV, "Can not write resync data to local disk.\n");
-- 
1.7.4.1

