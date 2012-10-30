Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab2J3KLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 06:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758304Ab2J3KLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 06:11:15 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, davem@davemloft.net,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rusty@rustcorp.com.au, krkumar2@in.ibm.com
Cc: kvm@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: [rfc net-next v6 3/3] virtio-net: change the number of queues through ethtool
Date: Tue, 30 Oct 2012 18:03:23 +0800
Message-Id: <1351591403-23065-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
References: <1351591403-23065-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the {set|get}_channels method of ethool to allow user to
change the number of queues dymaically when the device is running. This would
let the user to tune the device for specific applications.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8cc43e5..66fc129 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1616,10 +1616,53 @@ static struct virtio_driver virtio_net_driver = {
 #endif
 };
 
+/* TODO: Eliminate OOO packets during switching */
+static int virtnet_set_channels(struct net_device *dev,
+				struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u16 queue_pairs = channels->combined_count;
+
+	/* Only two modes were support currently */
+	if (queue_pairs == 0)
+		return -EINVAL;
+	if (queue_pairs != vi->total_queue_pairs - 1 && queue_pairs != 1)
+		return -EINVAL;
+
+	vi->num_queue_pairs = queue_pairs > 1 ? queue_pairs + 1 : 1;
+	BUG_ON(virtnet_set_queues(vi));
+
+	netif_set_real_num_tx_queues(dev, vi->num_queue_pairs);
+	netif_set_real_num_rx_queues(dev, vi->num_queue_pairs);
+
+	return 0;
+}
+
+static void virtnet_get_channels(struct net_device *dev,
+				 struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	if (vi->total_queue_pairs != 1) {
+		channels->combined_count = vi->num_queue_pairs;
+		channels->max_combined = vi->total_queue_pairs - 1;
+	} else {
+		channels->combined_count = 1;
+		channels->max_combined = 1;
+	}
+
+	channels->max_other = 0;
+	channels->rx_count = 0;
+	channels->tx_count = 0;
+	channels->other_count = 0;
+}
+
 static const struct ethtool_ops virtnet_ethtool_ops = {
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
+	.set_channels = virtnet_set_channels,
+	.get_channels = virtnet_get_channels,
 };
 
 static int __init init(void)
-- 
1.7.1

