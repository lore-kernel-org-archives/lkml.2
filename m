Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037Ab1I2PuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757022Ab1I2Pt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:49:59 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v2 09/11] virtio: net: Add freeze, restore handlers to support S4
Date: Thu, 29 Sep 2011 21:19:40 +0530
Message-Id: <5b7834c9a30254220f9c079ba54d29abaf63db8f.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
 <7bd7bd396c19237716cf47e53d558e3691f88ce5.1317311033.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317311033.git.amit.shah@redhat.com>
References: <cover.1317311033.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the vqs on hibernation and re-create them after restoring
from a hibernated image.  This keeps networking working across
hibernation.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index dcd4b01..8b9ed43 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1131,6 +1131,30 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
 	free_netdev(vi->dev);
 }
 
+#ifdef CONFIG_PM
+static int virtnet_freeze(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	remove_vq_common(vi);
+
+	return 0;
+}
+
+static int virtnet_restore(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+	int err;
+
+	err = init_vqs(vi);
+	if (err)
+		return err;
+
+	try_fill_recv(vi, GFP_KERNEL);
+	return 0;
+}
+#endif
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1155,6 +1179,10 @@ static struct virtio_driver virtio_net_driver = {
 	.probe =	virtnet_probe,
 	.remove =	__devexit_p(virtnet_remove),
 	.config_changed = virtnet_config_changed,
+#ifdef CONFIG_PM
+	.freeze =	virtnet_freeze,
+	.restore =	virtnet_restore,
+#endif
 };
 
 static int __init init(void)
-- 
1.7.6.2

