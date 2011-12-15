Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab1LOMrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 07:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab1LOMrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:47:16 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Virtualization List <virtualization@lists.linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v5 09/11] virtio: net: Add freeze, restore handlers to support S4
Date: Thu, 15 Dec 2011 18:15:55 +0530
Message-Id: <a231970091c84b19445f7637cac494e9c4c6b52a.1323952934.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
In-Reply-To: <cover.1323952933.git.amit.shah@redhat.com>
References: <cover.1323952933.git.amit.shah@redhat.com>
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
 drivers/net/virtio_net.c |   36 ++++++++++++++++++++++++++++++++++++
 1 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 697a0fc..1378f3c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1151,6 +1151,38 @@ static void __devexit virtnet_remove(struct virtio_device *vdev)
 	free_netdev(vi->dev);
 }
 
+#ifdef CONFIG_PM
+static int virtnet_freeze(struct virtio_device *vdev)
+{
+	struct virtnet_info *vi = vdev->priv;
+
+	netif_device_detach(vi->dev);
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
+	try_fill_recv(vi, GFP_KERNEL);
+	if (netif_running(vi->dev))
+		virtnet_napi_enable(vi);
+
+	netif_device_attach(vi->dev);
+	return 0;
+}
+#endif
+
 static struct virtio_device_id id_table[] = {
 	{ VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID },
 	{ 0 },
@@ -1175,6 +1207,10 @@ static struct virtio_driver virtio_net_driver = {
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
1.7.7.3

