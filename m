Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1I2P0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932252Ab1I2P0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:49 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 07/11] virtio: net: Move out vq initialization into separate function
Date: Thu, 29 Sep 2011 20:56:03 +0530
Message-Id: <c487a6587ad2982e86112b2bbd23914f3ecaf132.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
In-Reply-To: <cover.1317309123.git.amit.shah@redhat.com>
References: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The probe and PM restore functions will share this code.

Signed-off-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/net/virtio_net.c |   47 +++++++++++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0c7321c..da4c51a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -933,15 +933,38 @@ static void virtnet_config_changed(struct virtio_device *vdev)
 	virtnet_update_status(vi);
 }
 
+static int init_vqs(struct virtnet_info *vi)
+{
+	struct virtqueue *vqs[3];
+	vq_callback_t *callbacks[] = { skb_recv_done, skb_xmit_done, NULL};
+	const char *names[] = { "input", "output", "control" };
+	int nvqs, err;
+
+	/* We expect two virtqueues, receive then send,
+	 * and optionally control. */
+	nvqs = virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ? 3 : 2;
+
+	err = vi->vdev->config->find_vqs(vi->vdev, nvqs, vqs, callbacks, names);
+	if (err)
+		return err;
+
+	vi->rvq = vqs[0];
+	vi->svq = vqs[1];
+
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)) {
+		vi->cvq = vqs[2];
+
+		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
+			vi->dev->features |= NETIF_F_HW_VLAN_FILTER;
+	}
+	return 0;
+}
+
 static int virtnet_probe(struct virtio_device *vdev)
 {
 	int err;
 	struct net_device *dev;
 	struct virtnet_info *vi;
-	struct virtqueue *vqs[3];
-	vq_callback_t *callbacks[] = { skb_recv_done, skb_xmit_done, NULL};
-	const char *names[] = { "input", "output", "control" };
-	int nvqs;
 
 	/* Allocate ourselves a network device with room for our info */
 	dev = alloc_etherdev(sizeof(struct virtnet_info));
@@ -1014,24 +1037,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
-	/* We expect two virtqueues, receive then send,
-	 * and optionally control. */
-	nvqs = virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ? 3 : 2;
-
-	err = vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names);
+	err = init_vqs(vi);
 	if (err)
 		goto free_stats;
 
-	vi->rvq = vqs[0];
-	vi->svq = vqs[1];
-
-	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ)) {
-		vi->cvq = vqs[2];
-
-		if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VLAN))
-			dev->features |= NETIF_F_HW_VLAN_FILTER;
-	}
-
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
-- 
1.7.6.2

