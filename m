Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1KQL6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:58:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757077Ab1KQL6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:23 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 06/11] virtio: blk: Add freeze, restore handlers to support S4
Date: Thu, 17 Nov 2011 17:27:37 +0530
Message-Id: <81e98fc00370152ded2eef20f0953f19fad6f0f5.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
In-Reply-To: <cover.1321530505.git.amit.shah@redhat.com>
References: <cover.1321530505.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the vq and flush any pending requests from the block queue on the
freeze callback to prepare for hibernation.

Re-create the vq in the restore callback to resume normal function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 467f218..f73fb2d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -568,6 +568,38 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	ida_simple_remove(&vd_index_ida, index);
 }
 
+#ifdef CONFIG_PM
+static int virtblk_freeze(struct virtio_device *vdev)
+{
+	struct virtio_blk *vblk = vdev->priv;
+
+	flush_work(&vblk->config_work);
+	spin_lock_irq(vblk->disk->queue->queue_lock);
+	blk_stop_queue(vblk->disk->queue);
+	spin_unlock_irq(vblk->disk->queue->queue_lock);
+	blk_sync_queue(vblk->disk->queue);
+
+	/* Stop all the virtqueues. */
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+	return 0;
+}
+
+static int virtblk_restore(struct virtio_device *vdev)
+{
+	struct virtio_blk *vblk = vdev->priv;
+	int ret;
+
+	ret = init_vq(vdev->priv);
+	if (!ret) {
+		spin_lock_irq(vblk->disk->queue->queue_lock);
+		blk_start_queue(vblk->disk->queue);
+		spin_unlock_irq(vblk->disk->queue->queue_lock);
+	}
+	return ret;
+}
+#endif
+
 static const struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_BLOCK, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -593,6 +625,10 @@ static struct virtio_driver __refdata virtio_blk = {
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
1.7.7.1

