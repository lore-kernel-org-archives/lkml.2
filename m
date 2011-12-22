Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1LVL3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161Ab1LVL3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:29:01 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v6 06/11] virtio: blk: Add freeze, restore handlers to support S4
Date: Thu, 22 Dec 2011 16:58:30 +0530
Message-Id: <c73aeb0b905ae444631b535f8bf877abee96ec10.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete the vq and flush any pending requests from the block queue on the
freeze callback to prepare for hibernation.

Re-create the vq in the restore callback to resume normal function.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/block/virtio_blk.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 86c9c5b..e3bd9dc 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -588,6 +588,46 @@ static void __devexit virtblk_remove(struct virtio_device *vdev)
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
+	/* Prevent config work handler from accessing the device. */
+	mutex_lock(&vblk->config_lock);
+	vblk->config_enable = false;
+	mutex_unlock(&vblk->config_lock);
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
+	vblk->config_enable = true;
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
@@ -613,6 +653,10 @@ static struct virtio_driver __refdata virtio_blk = {
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
1.7.7.4

