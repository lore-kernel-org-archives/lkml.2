Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1IELvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:51:51 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60004 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1IELpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:55 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 15/54] drbd: drbd_send_sizes(): Return 0 upon success and an error code otherwise
Date: Mon,  5 Sep 2011 13:45:06 +0200
Message-Id: <1315223145-20640-16-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_main.c     |    4 +---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index ad3e2d0..e3b54ce 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -938,7 +938,6 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	struct p_sizes p;
 	sector_t d_size, u_size;
 	int q_order_type, max_bio_size;
-	int ok;
 
 	if (get_ldev_if_state(mdev, D_NEGOTIATING)) {
 		D_ASSERT(mdev->ldev->backing_bdev);
@@ -962,8 +961,7 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	p.queue_order_type = cpu_to_be16(q_order_type);
 	p.dds_flags = cpu_to_be16(flags);
 
-	ok = !drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
-	return ok;
+	return drbd_send_cmd(mdev, &mdev->tconn->data, P_SIZES, &p.head, sizeof(p));
 }
 
 /**
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 9a9c688..b1d8f91 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -764,7 +764,7 @@ int drbd_connected(int vnr, void *p, void *data)
 		&mdev->own_state_mutex;
 
 	ok &= !drbd_send_sync_param(mdev);
-	ok &= drbd_send_sizes(mdev, 0, 0);
+	ok &= !drbd_send_sizes(mdev, 0, 0);
 	ok &= !drbd_send_uuids(mdev);
 	ok &= !drbd_send_state(mdev);
 	clear_bit(USE_DEGR_WFC_T, &mdev->flags);
-- 
1.7.4.1

