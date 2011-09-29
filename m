Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab1I2Pt6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756898Ab1I2Pt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:49:56 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 06/11] virtio: blk: Add freeze, restore handlers to support S4
Date: Thu, 29 Sep 2011 21:19:39 +0530
Message-Id: <e31cf1eb4e21a63ca62e572a9f9cc44472f2b475.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317311033.git.amit.shah@redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the vq on the freeze callback to prepare for hibernation.
Re-create the vq in the restore callback to resume normal function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 717664a..b01930c 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -549,6 +549,19 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	kfree(vblk);
 }
 
+#ifdef CONFIG_PM
+static int virtblk_freeze(struct virtio_device *vdev)
+{
+	vdev->config->del_vqs(vdev);
+	return 0;
+}
+
+static int virtblk_restore(struct virtio_device *vdev)
+{
+	return init_vq(vdev->priv);
+}
+#endif
+
 static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -574,6 +587,10 @@ static struct virtio_driver __refdata virtio_blk = {
 	.probe			= virtblk_probe,
 	.remove			= __devexit_p(virtblk_remove),
 	.config_changed		= virtblk_config_changed,
+#ifdef CONFIG_PM
+	.freeze			= virtblk_freeze,
+	.restore		= virtblk_restore,
+#endif
 };
 
 static int __init init(void)
-- 
1.7.6.2

