Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1HYPJp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:09:45 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34508 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab1HYPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:43 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 068/118] drbd: conn_printk() a dev_printk() alike for drbd's connections
Date: Thu, 25 Aug 2011 17:08:04 +0200
Message-Id: <1314284934-17999-69-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h  |    9 +++++++++
 drivers/block/drbd/drbd_main.c |   16 +++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index df24541..1ecde6f 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -102,6 +102,15 @@ struct drbd_tconn;
 /* to shorten dev_warn(DEV, "msg"); and relatives statements */
 #define DEV (disk_to_dev(mdev->vdisk))
 
+extern void conn_printk(const char *level, struct drbd_tconn *tconn, const char *fmt, ...);
+#define conn_alert(TCONN, FMT, ARGS...)  conn_printk(KERN_ALERT, TCONN, FMT, ## ARGS)
+#define conn_crit(TCONN, FMT, ARGS...)   conn_printk(KERN_CRIT, TCONN, FMT, ## ARGS)
+#define conn_err(TCONN, FMT, ARGS...)    conn_printk(KERN_ERR, TCONN, FMT, ## ARGS)
+#define conn_warn(TCONN, FMT, ARGS...)   conn_printk(KERN_WARNING, TCONN, FMT, ## ARGS)
+#define conn_notice(TCONN, FMT, ARGS...) conn_printk(KERN_NOTICE, TCONN, FMT, ## ARGS)
+#define conn_info(TCONN, FMT, ARGS...)   conn_printk(KERN_INFO, TCONN, FMT, ## ARGS)
+#define conn_dbg(TCONN, FMT, ARGS...)    conn_printk(KERN_DEBUG, TCONN, FMT, ## ARGS)
+
 #define D_ASSERT(exp)	if (!(exp)) \
 	 dev_err(DEV, "ASSERT( " #exp " ) in %s:%d\n", __FILE__, __LINE__)
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index dbd6d72..0e2969d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -170,6 +170,18 @@ int _get_ldev_if_state(struct drbd_conf *mdev, enum drbd_disk_state mins)
 
 #endif
 
+/* printk functions for connections
+ */
+void conn_printk(const char *level, struct drbd_tconn *tconn, const char *fmt, ...)
+{
+	va_list args;
+
+	printk("%sd-con %s: ", level, tconn->name);
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	va_end(args);
+}
+
 /**
  * DOC: The transfer log
  *
@@ -2217,12 +2229,14 @@ struct drbd_conf *drbd_new_device(unsigned int minor)
 	struct drbd_conf *mdev;
 	struct gendisk *disk;
 	struct request_queue *q;
+	char conn_name[9]; /* drbd1234N */
 
 	/* GFP_KERNEL, we are outside of all write-out paths */
 	mdev = kzalloc(sizeof(struct drbd_conf), GFP_KERNEL);
 	if (!mdev)
 		return NULL;
-	mdev->tconn = drbd_new_tconn("dummy");
+	sprintf(conn_name, "drbd%d", minor);
+	mdev->tconn = drbd_new_tconn(conn_name);
 	if (!mdev->tconn)
 		goto out_no_tconn;
 
-- 
1.7.4.1

