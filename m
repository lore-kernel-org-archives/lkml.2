Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760Ab1IHMrw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:47:52 -0400
Received: from mail09.linbit.com ([212.69.161.110]:37535 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932704Ab1IHMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:45:44 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 12/16] drbd: introduce the "initialized" activity log transaction type
Date: Thu,  8 Sep 2011 14:45:33 +0200
Message-Id: <1315485937-18989-13-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
References: <1315485937-18989-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

So we can initialize a clean on disk activity log area,
without the module complaining with loud assert messages
because of checksum or magic value mismatches.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 9c9929a..643a7bd 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -31,6 +31,11 @@
 #include "drbd_int.h"
 #include "drbd_wrappers.h"
 
+
+enum al_transaction_types {
+	AL_TR_UPDATE = 0,
+	AL_TR_INITIALIZED = 0xffff
+};
 /* all fields on disc in big endian */
 struct __packed al_transaction_on_disk {
 	/* don't we all like magic */
@@ -44,7 +49,8 @@ struct __packed al_transaction_on_disk {
 	__be32	crc32c;
 
 	/* type of transaction, special transaction types like:
-	 * purge-all, set-all-idle, set-all-active, ... to-be-defined */
+	 * purge-all, set-all-idle, set-all-active, ... to-be-defined
+	 * see also enum al_transaction_types */
 	__be16	transaction_type;
 
 	/* we currently allow only a few thousand extents,
@@ -466,6 +472,7 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	int active_extents = 0;
 	int transactions = 0;
 	int found_valid = 0;
+	int found_initialized = 0;
 	int from = 0;
 	int to = 0;
 	u32 from_tnr = 0;
@@ -494,6 +501,10 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 		/* invalid data in that block */
 		if (rv == 0)
 			continue;
+		if (be16_to_cpu(b->transaction_type) == AL_TR_INITIALIZED) {
+			++found_initialized;
+			continue;
+		}
 
 		/* IO error */
 		if (rv == -1) {
@@ -525,7 +536,8 @@ int drbd_al_read_log(struct drbd_conf *mdev, struct drbd_backing_dev *bdev)
 	}
 
 	if (!found_valid) {
-		dev_warn(DEV, "No usable activity log found.\n");
+		if (found_initialized != mx)
+			dev_warn(DEV, "No usable activity log found.\n");
 		mutex_unlock(&mdev->md_io_mutex);
 		return 1;
 	}
-- 
1.7.4.1

