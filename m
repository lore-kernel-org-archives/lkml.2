Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0EGJaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:30:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:55769 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975Ab0EGJ36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:29:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,347,1270450800"; 
   d="scan'208";a="515915008"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v5 05/19] Add a function make external buffer owner to query capability.
Date: Fri,  7 May 2010 17:34:52 +0800
Message-Id: <1273224906-4874-6-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1273224906-4874-5-git-send-email-xiaohui.xin@intel.com>
References: <1273224906-4874-1-git-send-email-xiaohui.xin@intel.com>
 <1273224906-4874-2-git-send-email-xiaohui.xin@intel.com>
 <1273224906-4874-3-git-send-email-xiaohui.xin@intel.com>
 <1273224906-4874-4-git-send-email-xiaohui.xin@intel.com>
 <1273224906-4874-5-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

The external buffer owner can use the functions to get
the capability of the underlying NIC driver.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhaonew@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/netdevice.h |    2 +
 net/core/dev.c            |   51 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 183c786..31d9c4a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1599,6 +1599,8 @@ extern gro_result_t	napi_gro_frags(struct napi_struct *napi);
 extern int netdev_mp_port_attach(struct net_device *dev,
 				 struct mpassthru_port *port);
 extern void netdev_mp_port_detach(struct net_device *dev);
+extern int netdev_mp_port_prep(struct net_device *dev,
+			struct mpassthru_port *port);
 
 static inline void napi_free_frags(struct napi_struct *napi)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index ecbb6b1..37b389a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2497,6 +2497,57 @@ void netdev_mp_port_detach(struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_mp_port_detach);
 
+/* To support meidate passthru(zero-copy) with NIC driver,
+ * we'd better query NIC driver for the capability it can
+ * provide, especially for packet split mode, now we only
+ * query for the header size, and the payload a descriptor
+ * may carry. If a driver does not use the API to export,
+ * then we may try to use a default value, currently,
+ * we use the default value from an IGB driver. Now,
+ * it's only called by mpassthru device.
+ */
+#if defined(CONFIG_MEDIATE_PASSTHRU) || defined(CONFIG_MEDIATE_PASSTHRU_MODULE)
+int netdev_mp_port_prep(struct net_device *dev,
+			struct mpassthru_port *port)
+{
+	int rc;
+	int npages, data_len;
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	/* needed by packet split */
+
+	if (ops->ndo_mp_port_prep) {
+		rc = ops->ndo_mp_port_prep(dev, port);
+		if (rc)
+			return rc;
+	} else {
+		/* If the NIC driver did not report this,
+		 * then we try to use default value.
+		 */
+		port->hdr_len = 128;
+		port->data_len = 2048;
+		port->npages = 1;
+	}
+
+	if (port->hdr_len <= 0)
+		goto err;
+
+	npages = port->npages;
+	data_len = port->data_len;
+	if (npages <= 0 || npages > MAX_SKB_FRAGS ||
+			(data_len < PAGE_SIZE * (npages - 1) ||
+			 data_len > PAGE_SIZE * npages))
+		goto err;
+
+	return 0;
+err:
+	dev_warn(&dev->dev, "invalid page constructor parameters\n");
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(netdev_mp_port_prep);
+#endif
+
 /**
  *	netif_receive_skb - process receive buffer from network
  *	@skb: buffer to process
-- 
1.5.4.4

