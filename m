Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1LVL3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755341Ab1LVL3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:29:09 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v6 09/11] virtio: net: Add freeze, restore handlers to support S4
Date: Thu, 22 Dec 2011 16:58:33 +0530
Message-Id: <f84fa9fdc9f5629e711cbb89a2e7efbb289d72fa.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
In-Reply-To: <cover.1324553223.git.amit.shah@redhat.com>
References: <cover.1324553223.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the vqs, disable napi and detach from the netdev on
hibernation.

Re-create vqs after restoring from a hibernated image, re-enable napi
and re-attach the netdev.  This keeps networking working across
hibernation.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7a2a5bf..b31670f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1159,6 +1159,48 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
 	free_netdev(vi->dev);
 }
 
+#ifdef CONFIG_PM
+static int virtnet_freeze(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	virtqueue_disable_cb(vi->rvq);
+	virtqueue_disable_cb(vi->svq);
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ))
+		virtqueue_disable_cb(vi->cvq);
+
+	netif_device_detach(vi->dev);
+	cancel_delayed_work_sync(&vi->refill);
+
+	if (netif_running(vi->dev))
+		napi_disable(&vi->napi);
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
+	if (netif_running(vi->dev))
+		virtnet_napi_enable(vi);
+
+	netif_device_attach(vi->dev);
+
+	if (!try_fill_recv(vi, GFP_KERNEL))
+		schedule_delayed_work(&vi->refill, 0);
+
+	return 0;
+}
+#endif
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1183,6 +1225,10 @@ static struct virtio_driver virtio_net_driver = {
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
1.7.7.4

