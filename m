Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069Ab0KIIlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 03:41:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:25013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab0KIIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 03:41:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,174,1288594800"; 
   d="scan'208";a="624917693"
From: xiaohui.xin@intel.com
To: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, davem@davemloft.net,
        herbert@gondor.hengli.com.au, jdike@linux.intel.com
Cc: Xin Xiaohui <xiaohui.xin@intel.com>
Subject: [PATCH v15 02/17]Add a new struct for device to manipulate external buffer.
Date: Tue,  9 Nov 2010 17:03:07 +0800
Message-Id: <38fbf05a450b34e939aa1b0f3a5126711990f0cc.1289280885.git.xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
References: <1289293402-4791-1-git-send-email-xiaohui.xin@intel.com>
In-Reply-To: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
References: <fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1289280885.git.xiaohui.xin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

    Add a structure in structure net_device, the new field is
    named as mp_port. It's for mediate passthru (zero-copy).
    It contains the capability for the net device driver,
    a socket, and an external buffer creator, external means
    skb buffer belongs to the device may not be allocated from
    kernel space.

    Signed-off-by: Xin Xiaohui <xiaohui.xin@intel.com>
    Signed-off-by: Zhao Yu <yzhao81new@gmail.com>
    Reviewed-by: Jeff Dike <jdike@linux.intel.com>
---
 include/linux/netdevice.h |   25 ++++++++++++++++++++++++-
 1 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 46c36ff..f6b1870 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -325,6 +325,28 @@ enum netdev_state_t {
 	__LINK_STATE_DORMANT,
 };
 
+/*The structure for mediate passthru(zero-copy). */
+struct mp_port	{
+	/* the header len */
+	int		hdr_len;
+	/* the max payload len for one descriptor */
+	int		data_len;
+	/* the pages for DMA in one time */
+	int		npages;
+	/* the socket bind to */
+	struct socket	*sock;
+	/* the header len for virtio-net */
+	int		vnet_hlen;
+	/* the external buffer page creator */
+	struct skb_ext_page *(*ctor)(struct mp_port *,
+				struct sk_buff *, int);
+	/* the hash function attached to find according
+	 * backend ring descriptor info for one external
+	 * buffer page.
+	 */
+	struct skb_ext_page *(*hash)(struct net_device *,
+				struct page *);
+};
 
 /*
  * This structure holds at boot time configured netdevice settings. They
@@ -1045,7 +1067,8 @@ struct net_device {
 
 	/* GARP */
 	struct garp_port	*garp_port;
-
+	/* mpassthru */
+	struct mp_port		*mp_port;
 	/* class/net/name entry */
 	struct device		dev;
 	/* space for optional device, statistics, and wireless sysfs groups */
-- 
1.7.3

