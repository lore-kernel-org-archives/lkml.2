Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1JMKeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:34:31 -0400
Received: from mail09.linbit.com ([212.69.161.110]:58089 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab1JMKcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:32:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 04/10] drbd: Improve compatibility with drbd's older than 8.3.7
Date: Thu, 13 Oct 2011 12:32:10 +0200
Message-Id: <1318501936-11689-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
References: <1318501936-11689-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression introduced with 8.3.11 commit:
drbd: Take a more conservative approach when deciding max_bio_size

Never ever tell an older drbd, that we support more than 32KiB
in a single data request (packet).
Never believe an older drbd, that is supports more than 32KiB
in a single data request (packet)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    3 ++-
 drivers/block/drbd/drbd_main.c |    6 ++++++
 drivers/block/drbd/drbd_nl.c   |    7 +++++--
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 1d71b3a..6035784 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1284,7 +1284,8 @@ struct bm_extent {
 #endif
 #define DRBD_MAX_BIO_SIZE_SAFE (1 << 12)       /* Works always = 4k */
 
-#define DRBD_MAX_SIZE_H80_PACKET (1 << 15) /* The old header only allows packets up to 32Kib data */
+#define DRBD_MAX_SIZE_H80_PACKET (1 << 15) /* Header 80 only allows packets up to 32KiB data */
+#define DRBD_MAX_BIO_SIZE_P95    (1 << 17) /* Protocol 95 to 99 allows bios up to 128KiB */
 
 extern int  drbd_bm_init(struct drbd_conf *mdev);
 extern int  drbd_bm_resize(struct drbd_conf *mdev, sector_t sectors, int set_new_bits);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 72b1dfa..448de7b 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1075,6 +1075,12 @@ int drbd_send_sizes(struct drbd_conf *mdev, int trigger_reply, enum dds_flags fl
 	p = drbd_prepare_command(mdev, sock);
 	if (!p)
 		return -EIO;
+
+	if (mdev->tconn->agreed_pro_version <= 94)
+		max_bio_size = min_t(int, max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
+	else if (mdev->tconn->agreed_pro_version < 100)
+		max_bio_size = min_t(int, max_bio_size, DRBD_MAX_BIO_SIZE_P95);
+
 	p->d_size = cpu_to_be64(d_size);
 	p->u_size = cpu_to_be64(u_size);
 	p->c_size = cpu_to_be64(trigger_reply ? 0 : drbd_get_capacity(mdev->this_bdev));
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 3f223f3..ec4829b 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1088,10 +1088,13 @@ void drbd_reconsider_max_bio_size(struct drbd_conf *mdev)
 	   BIOs for a single peer_request */
 	if (mdev->state.conn >= C_CONNECTED) {
 		if (mdev->tconn->agreed_pro_version < 94)
-			peer = mdev->peer_max_bio_size;
+			peer = min_t(int, mdev->peer_max_bio_size, DRBD_MAX_SIZE_H80_PACKET);
+			/* Correct old drbd (up to 8.3.7) if it believes it can do more than 32KiB */
 		else if (mdev->tconn->agreed_pro_version == 94)
 			peer = DRBD_MAX_SIZE_H80_PACKET;
-		else /* drbd 8.3.8 onwards */
+		else if (mdev->tconn->agreed_pro_version < 100)
+			peer = DRBD_MAX_BIO_SIZE_P95;  /* drbd 8.3.8 onwards, before 8.4.0 */
+		else
 			peer = DRBD_MAX_BIO_SIZE;
 	}
 
-- 
1.7.4.1

