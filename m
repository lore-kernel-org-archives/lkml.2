Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1IELqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:46:01 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59822 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1IELpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:45:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 02/54] drbd: Add drbd_send_all(): Send an entire buffer
Date: Mon,  5 Sep 2011 13:44:53 +0200
Message-Id: <1315223145-20640-3-git-send-email-philipp.reisner@linbit.com>
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
 drivers/block/drbd/drbd_int.h  |    3 +++
 drivers/block/drbd/drbd_main.c |   18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index eaa1fd5..32799ea 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1161,6 +1161,9 @@ extern void _tl_add_barrier(struct drbd_tconn *, struct drbd_tl_epoch *);
 extern void drbd_free_sock(struct drbd_tconn *tconn);
 extern int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 		     void *buf, size_t size, unsigned msg_flags);
+extern int drbd_send_all(struct drbd_tconn *, struct socket *, void *, size_t,
+			 unsigned);
+
 extern int drbd_send_protocol(struct drbd_tconn *tconn);
 extern int drbd_send_uuids(struct drbd_conf *mdev);
 extern int drbd_send_uuids_skip_initial_sync(struct drbd_conf *mdev);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 628005a..1381d01 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1764,6 +1764,24 @@ int drbd_send(struct drbd_tconn *tconn, struct socket *sock,
 	return sent;
 }
 
+/**
+ * drbd_send_all  -  Send an entire buffer
+ *
+ * Returns 0 upon success and a negative error value otherwise.
+ */
+int drbd_send_all(struct drbd_tconn *tconn, struct socket *sock, void *buffer,
+		  size_t size, unsigned msg_flags)
+{
+	int err;
+
+	err = drbd_send(tconn, sock, buffer, size, msg_flags);
+	if (err < 0)
+		return err;
+	if (err != size)
+		return -EIO;
+	return 0;
+}
+
 static int drbd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct drbd_conf *mdev = bdev->bd_disk->private_data;
-- 
1.7.4.1

