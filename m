Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0KIIlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:41:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:40024 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0KIIli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:41:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="624917735"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v15 07/17]Modify netdev_alloc_page() to get external buffer
Date: Tue,  9 Nov 2010 17:03:12 +0800
Message-Id: <81bd4b63b1b604664a33331adf5189e2ef7a4833.1289280886.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
References: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

    Currently, it can get external buffers from mp device.

    Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
    Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
    Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 net/core/skbuff.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 68e197e..a1018bd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -261,11 +261,38 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
 }
 EXPORT_SYMBOL(__netdev_alloc_skb);
 
+struct page *netdev_alloc_ext_pages(struct net_device *dev, int npages)
+{
+	struct mp_port *port;
+	struct skb_ext_page *ext_page = NULL;
+
+	port = dev->mp_port;
+	if (!port)
+		goto out;
+	ext_page = port->ctor(port, NULL, npages);
+	if (ext_page)
+		return ext_page->page;
+out:
+	return NULL;
+
+}
+EXPORT_SYMBOL(netdev_alloc_ext_pages);
+
+struct page *netdev_alloc_ext_page(struct net_device *dev)
+{
+	return netdev_alloc_ext_pages(dev, 1);
+
+}
+EXPORT_SYMBOL(netdev_alloc_ext_page);
+
 struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask)
 {
 	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
 	struct page *page;
 
+	if (dev_is_mpassthru(dev))
+		return netdev_alloc_ext_page(dev);
+
 	page = alloc_pages_node(node, gfp_mask, 0);
 	return page;
 }
-- 
1.7.3

