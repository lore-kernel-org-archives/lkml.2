Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab2LDLQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 06:16:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34149 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405Ab2LDLQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 06:16:20 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net
Cc: krkumar2@in.ibm.com, kvm@vger.kernel.org, bhutchings@solarflare.com,
        jwhan@filewood.snu.ac.kr, shiyer@redhat.com,
        Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next 3/3] virtio-net: change the number of queues through ethtool
Date: Tue,  4 Dec 2012 19:07:58 +0800
Message-Id: <1354619278-35702-4-git-send-email-jasowang@redhat.com>
In-Reply-To: <1354619278-35702-1-git-send-email-jasowang@redhat.com>
References: <1354619278-35702-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implement the ethtool_{set|get}_channels method of ethool to allow
user to change the number of queues dymaically when the device is running. This
would let the user to configure it on demand.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 912f5b2..b9f9887 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1589,10 +1589,54 @@ static struct virtio_driver virtio_net_driver = {
 #endif
 };
 
+/* TODO: Eliminate OOO packets during switching */
+static int virtnet_set_channels(struct net_device *dev,
+				struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+	u16 queue_pairs = channels->combined_count;
+	u16 old_queue_pairs = vi->curr_queue_pairs;
+
+	/* We don't support separate rx/tx channels.
+	 * We don't allow setting 'other' channels.
+	 */
+	if (channels->rx_count || channels->tx_count || channels->other_count)
+		return -EINVAL;
+
+	if (queue_pairs > vi->max_queue_pairs)
+		return -EINVAL;
+
+	vi->curr_queue_pairs = queue_pairs;
+	if (virtnet_set_queues(vi) == 0) {
+		netif_set_real_num_tx_queues(dev, vi->curr_queue_pairs);
+		netif_set_real_num_rx_queues(dev, vi->curr_queue_pairs);
+
+		virtnet_set_affinity(vi, true);
+	} else
+		vi->curr_queue_pairs = old_queue_pairs;
+
+	return 0;
+}
+
+static void virtnet_get_channels(struct net_device *dev,
+				 struct ethtool_channels *channels)
+{
+	struct virtnet_info *vi = netdev_priv(dev);
+
+	channels->combined_count = vi->curr_queue_pairs;
+	channels->max_combined = vi->max_queue_pairs;
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

