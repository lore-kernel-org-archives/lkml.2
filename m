Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab1LOMrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:47:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1LOMrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:47:03 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v5 06/11] virtio: blk: Add freeze, restore handlers to support S4
Date: Thu, 15 Dec 2011 18:15:52 +0530
Message-Id: <a43d429430f89966048908183d424aa22094a95b.1323952934.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the vq and flush any pending requests from the block queue on the
freeze callback to prepare for hibernation.

Re-create the vq in the restore callback to resume normal function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 467f218..a9147a6 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -568,6 +568,40 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
 	ida_simple_remove(&vd_index_ida, index);
 }
 
+#ifdef CONFIG_PM
+static int virtblk_freeze(struct virtio_device *vdev)
+{
+	struct virtio_blk *vblk = vdev->priv;
+
+	/* Ensure we don't receive any more interrupts */
+	vdev->config->reset(vdev);
+
+	flush_work(&vblk->config_work);
+
+	spin_lock_irq(vblk->disk->queue->queue_lock);
+	blk_stop_queue(vblk->disk->queue);
+	spin_unlock_irq(vblk->disk->queue->queue_lock);
+	blk_sync_queue(vblk->disk->queue);
+
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
@@ -593,6 +627,10 @@ static struct virtio_driver __refdata virtio_blk = {
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
1.7.7.3

