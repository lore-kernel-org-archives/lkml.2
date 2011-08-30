Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1H3JIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 05:08:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38199 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1H3JFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 05:05:53 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/15] drbd: Use the IS_ALIGNED() macro in some more places
Date: Tue, 30 Aug 2011 11:05:38 +0200
Message-Id: <1314695149-387-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
References: <1314695149-387-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c   |    6 +++---
 drivers/block/drbd/drbd_receiver.c |    2 +-
 drivers/block/drbd/drbd_req.c      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 0748871..ad61863 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -767,7 +767,7 @@ void __drbd_set_in_sync(struct drbd_conf *mdev, sector_t sector, int size,
 	int wake_up = 0;
 	unsigned long flags;
 
-	if (size <= 0 || (size & 0x1ff) != 0 || size > DRBD_MAX_BIO_SIZE) {
+	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
 		dev_err(DEV, "drbd_set_in_sync: sector=%llus size=%d nonsense!\n",
 				(unsigned long long)sector, size);
 		return;
@@ -832,7 +832,7 @@ int __drbd_set_out_of_sync(struct drbd_conf *mdev, sector_t sector, int size,
 	unsigned int enr, count = 0;
 	struct lc_element *e;
 
-	if (size <= 0 || (size & 0x1ff) != 0 || size > DRBD_MAX_BIO_SIZE) {
+	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
 		dev_err(DEV, "sector: %llus, size: %d\n",
 			(unsigned long long)sector, size);
 		return 0;
@@ -1217,7 +1217,7 @@ void drbd_rs_failed_io(struct drbd_conf *mdev, sector_t sector, int size)
 	sector_t esector, nr_sectors;
 	int wake_up = 0;
 
-	if (size <= 0 || (size & 0x1ff) != 0 || size > DRBD_MAX_BIO_SIZE) {
+	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
 		dev_err(DEV, "drbd_rs_failed_io: sector=%llus size=%d nonsense!\n",
 				(unsigned long long)sector, size);
 		return;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index deae7cb..af3ee2f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2041,7 +2041,7 @@ static int receive_DataRequest(struct drbd_conf *mdev, enum drbd_packet cmd,
 	sector = be64_to_cpu(p->sector);
 	size   = be32_to_cpu(p->blksize);
 
-	if (size <= 0 || (size & 0x1ff) != 0 || size > DRBD_MAX_BIO_SIZE) {
+	if (size <= 0 || !IS_ALIGNED(size, 512) || size > DRBD_MAX_BIO_SIZE) {
 		dev_err(DEV, "%s:%d: sector: %llus, size: %u\n", __FILE__, __LINE__,
 				(unsigned long long)sector, size);
 		return false;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 157c737..48d313d 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1023,7 +1023,7 @@ int drbd_make_request(struct request_queue *q, struct bio *bio)
 	 * what we "blindly" assume:
 	 */
 	D_ASSERT(bio->bi_size > 0);
-	D_ASSERT((bio->bi_size & 0x1ff) == 0);
+	D_ASSERT(IS_ALIGNED(bio->bi_size, 512));
 	D_ASSERT(bio->bi_idx == 0);
 
 	/* to make some things easier, force alignment of requests within the
-- 
1.7.4.1

