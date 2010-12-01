Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab0LAHq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:46:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:52058 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab0LAHqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:46:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="682672480"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v16 17/17]An example how to alloc user buffer based on napi_gro_frags() interface.
Date: Wed,  1 Dec 2010 16:08:28 +0800
Message-Id: <2936ba1da217272d2a8ba1f957b3e10ff167e77d.1291187695.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1291187695.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

This example is made on ixgbe driver which using napi_gro_frags().
It can get buffers from guest side directly using netdev_alloc_page()
and release guest buffers using netdev_free_page().

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
---
 drivers/net/ixgbe/ixgbe_main.c |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_main.c b/drivers/net/ixgbe/ixgbe_main.c
index cd69080..807a51e 100644
--- a/drivers/net/ixgbe/ixgbe_main.c
+++ b/drivers/net/ixgbe/ixgbe_main.c
@@ -1032,7 +1032,14 @@ static inline void ixgbe_release_rx_desc(struct ixgbe_hw *hw,
 static bool is_rx_buffer_mapped_as_page(struct ixgbe_rx_buffer *bi,
 					struct net_device *dev)
 {
-	return true;
+	return dev_is_mpassthru(dev);
+}
+
+static u32 get_page_skb_offset(struct net_device *dev)
+{
+	if (!dev_is_mpassthru(dev))
+		return 0;
+	return dev->mp_port->vnet_hlen;
 }
 
 /**
@@ -1105,7 +1112,8 @@ static void ixgbe_alloc_rx_buffers(struct ixgbe_adapter *adapter,
 				adapter->alloc_rx_page_failed++;
 				goto no_buffers;
 			}
-			bi->page_skb_offset = 0;
+			bi->page_skb_offset =
+				get_page_skb_offset(adapter->netdev);
 			bi->dma = dma_map_page(&pdev->dev, bi->page_skb,
 					bi->page_skb_offset,
 					(PAGE_SIZE / 2),
@@ -1242,8 +1250,10 @@ static bool ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			len = le16_to_cpu(rx_desc->wb.upper.length);
 		}
 
-		if (is_no_buffer(rx_buffer_info))
+		if (is_no_buffer(rx_buffer_info)) {
+			printk("no buffers\n");
 			break;
+		}
 		cleaned = true;
 
 		if (!rx_buffer_info->mapped_as_page) {
@@ -1305,6 +1315,11 @@ static bool ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 						rx_buffer_info->page_skb,
 						rx_buffer_info->page_skb_offset,
 						len);
+				if (dev_is_mpassthru(netdev) &&
+						netdev->mp_port->hash)
+					skb_shinfo(skb)->destructor_arg =
+						netdev->mp_port->hash(netdev,
+						rx_buffer_info->page_skb);
 				rx_buffer_info->page_skb = NULL;
 				skb->len += len;
 				skb->data_len += len;
@@ -1322,7 +1337,8 @@ static bool ixgbe_clean_rx_irq(struct ixgbe_q_vector *q_vector,
 			                   upper_len);
 
 			if ((rx_ring->rx_buf_len > (PAGE_SIZE / 2)) ||
-			    (page_count(rx_buffer_info->page) != 1))
+			    (page_count(rx_buffer_info->page) != 1) ||
+				dev_is_mpassthru(netdev))
 				rx_buffer_info->page = NULL;
 			else
 				get_page(rx_buffer_info->page);
@@ -6535,6 +6551,16 @@ static void ixgbe_netpoll(struct net_device *netdev)
 }
 #endif
 
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+static int ixgbe_ndo_mp_port_prep(struct net_device *dev, struct mp_port *port)
+{
+	port->hdr_len = 128;
+	port->data_len = 2048;
+	port->npages = 1;
+	return 0;
+}
+#endif
+
 static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_open 		= ixgbe_open,
 	.ndo_stop		= ixgbe_close,
@@ -6554,6 +6580,9 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_set_vf_vlan	= ixgbe_ndo_set_vf_vlan,
 	.ndo_set_vf_tx_rate	= ixgbe_ndo_set_vf_bw,
 	.ndo_get_vf_config	= ixgbe_ndo_get_vf_config,
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+	.ndo_mp_port_prep	= ixgbe_ndo_mp_port_prep,
+#endif
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= ixgbe_netpoll,
 #endif
-- 
1.7.3

