Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1HYPJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:07 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32914 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab1HYPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:08:59 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 003/118] drbd: Consistently use block_id == ID_SYNCER for checksum based resync and online verify
Date: Thu, 25 Aug 2011 17:06:59 +0200
Message-Id: <1314284934-17999-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

DRBD_MAGIC has nothing to do with block ids and the funny values
computed were not actually used, anyway.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c     |    4 ++--
 drivers/block/drbd/drbd_receiver.c |    4 ++++
 drivers/block/drbd/drbd_worker.c   |    4 +---
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 0358e55..0c16620 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2474,7 +2474,7 @@ int drbd_send_drequest_csum(struct drbd_conf *mdev,
 	struct p_block_req p;
 
 	p.sector   = cpu_to_be64(sector);
-	p.block_id = BE_DRBD_MAGIC + 0xbeef;
+	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
 	p.head.magic   = BE_DRBD_MAGIC;
@@ -2497,7 +2497,7 @@ int drbd_send_ov_request(struct drbd_conf *mdev, sector_t sector, int size)
 	struct p_block_req p;
 
 	p.sector   = cpu_to_be64(sector);
-	p.block_id = BE_DRBD_MAGIC + 0xbabe;
+	p.block_id = ID_SYNCER /* unused */;
 	p.blksize  = cpu_to_be32(size);
 
 	ok = drbd_send_cmd(mdev, USE_DATA_SOCKET, P_OV_REQUEST,
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index d499aa6..5ed9619 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -341,6 +341,10 @@ struct drbd_epoch_entry *drbd_alloc_ee(struct drbd_conf *mdev,
 	e->size = data_size;
 	e->flags = 0;
 	e->sector = sector;
+	/*
+	 * The block_id is opaque to the receiver.  It is not endianness
+	 * converted, and sent back to the sender unchanged.
+	 */
 	e->block_id = id;
 
 	return e;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 4d3e6f6..10438c4 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -305,8 +305,6 @@ int w_e_send_csum(struct drbd_conf *mdev, struct drbd_work *w, int cancel)
 	void *digest;
 	int ok = 1;
 
-	D_ASSERT(e->block_id == DRBD_MAGIC + 0xbeef);
-
 	if (unlikely(cancel))
 		goto out;
 
@@ -359,7 +357,7 @@ static int read_for_csum(struct drbd_conf *mdev, sector_t sector, int size)
 
 	/* GFP_TRY, because if there is no memory available right now, this may
 	 * be rescheduled for later. It is "only" background resync, after all. */
-	e = drbd_alloc_ee(mdev, DRBD_MAGIC+0xbeef, sector, size, GFP_TRY);
+	e = drbd_alloc_ee(mdev, ID_SYNCER /* unused */, sector, size, GFP_TRY);
 	if (!e)
 		goto defer;
 
-- 
1.7.4.1

