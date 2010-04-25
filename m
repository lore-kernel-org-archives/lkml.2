Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197Ab0DYJRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 05:17:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:14281 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0DYJRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 05:17:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,269,1270450800"; 
   d="scan'208";a="561295823"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
       jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [RFC][PATCH v4 06/18] Add interface to get external buffers.
Date: Sun, 25 Apr 2010 17:19:53 +0800
Message-Id: <1272187206-18534-6-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
References: <1272187206-18534-1-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-2-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-3-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-4-git-send-email-xiaohui.xin@intel.com>
 <1272187206-18534-5-git-send-email-xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

Currently, it can get external buffers from mp device.

Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
Signed-off-by: Zhao Yu <yzhao81@gmail.com>
Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/skbuff.h |   12 ++++++++++++
 net/core/skbuff.c      |   16 ++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 3104e7d..96799f5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1525,6 +1525,18 @@ static inline void netdev_free_page(struct net_device *dev, struct page *page)
 	__free_page(page);
 }
 
+extern struct skb_external_page *netdev_alloc_external_pages(
+					struct net_device *dev,
+					struct sk_buff *skb, int npages);
+
+static inline struct skb_external_page *netdev_alloc_external_page(
+		struct net_device *dev,
+		struct sk_buff *skb, unsigned int size)
+{
+	return netdev_alloc_external_pages(dev, skb,
+					   DIV_ROUND_UP(size, PAGE_SIZE));
+}
+
 /**
  *	skb_clone_writable - is the header of a clone writable
  *	@skb: buffer to check
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 93c4e06..6345acc 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -278,6 +278,22 @@ struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(__netdev_alloc_page);
 
+struct skb_external_page *netdev_alloc_external_pages(struct net_device *dev,
+			struct sk_buff *skb, int npages)
+{
+	struct mpassthru_port *port;
+	struct skb_external_page *ext_page = NULL;
+
+	port = rcu_dereference(dev->mp_port);
+	if (!port)
+		goto out;
+	BUG_ON(npages > port->npages);
+	ext_page = port->ctor(port, skb, npages);
+out:
+	return ext_page;
+}
+EXPORT_SYMBOL(netdev_alloc_external_pages);
+
 void skb_add_rx_frag(struct sk_buff *skb, int i, struct page *page, int off,
 		int size)
 {
-- 
1.5.4.4

