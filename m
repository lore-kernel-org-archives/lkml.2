Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0JOIzn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:55:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:60392 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab0JOIw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:52:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,335,1283756400"; 
   d="scan'208";a="616995413"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v13 08/16] Modify netdev_free_page() to release external buffer
Date: Fri, 15 Oct 2010 17:12:09 +0800
Message-Id: <68e965e8500ffd954f1cbf373e950809025b7634.1287132437.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
References: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Currently, it can get external buffers from mp device.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/skbuff.h |    4 +++-
 net/core/skbuff.c      |   24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 696e690..8cfde3e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1585,9 +1585,11 @@ static inline struct page *netdev_alloc_page(struct net_device *dev)
 	return __netdev_alloc_page(dev, GFP_ATOMIC);
 }
 
+extern void __netdev_free_page(struct net_device *dev, struct page *page);
+
 static inline void netdev_free_page(struct net_device *dev, struct page *page)
 {
-	__free_page(page);
+	__netdev_free_page(dev, page);
 }
 
 /**
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f39d372..02439e0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -299,6 +299,30 @@ struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(__netdev_alloc_page);
 
+void netdev_free_ext_page(struct net_device *dev, struct page *page)
+{
+	struct skb_ext_page *ext_page = NULL;
+	if (dev_is_mpassthru(dev) && dev->mp_port->hash) {
+		ext_page = dev->mp_port->hash(dev, page);
+		if (ext_page)
+			ext_page->dtor(ext_page);
+		else
+			__free_page(page);
+	}
+}
+EXPORT_SYMBOL(netdev_free_ext_page);
+
+void __netdev_free_page(struct net_device *dev, struct page *page)
+{
+	if (dev_is_mpassthru(dev)) {
+		netdev_free_ext_page(dev, page);
+		return;
+	}
+
+	__free_page(page);
+}
+EXPORT_SYMBOL(__netdev_free_page);
+
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		int size)
 {
-- 
1.7.3

