Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab1BBAoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:54182 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753633Ab1BBAor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028487"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: jeremy@goop.org, jbeulich@novell.com, jeremy.fitzhardinge@citrix.com,
        ak@linux.intel.com, axboe@kernel.dk, davem@davemloft.net,
        torvalds@linux-foundation.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [78/139] xen: Provide a variant of __RING_SIZE() that is an integer constant expression
Message-Id: <20110202004435.68FA13E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 667c78afaec0ac500908e191e8f236e9578d7b1f upstream.

Without this, gcc 4.5 won't compile xen-netfront and xen-blkfront, where
this is being used to specify array sizes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c    |    2 +-
 drivers/net/xen-netfront.c      |    4 ++--
 include/xen/interface/io/ring.h |   11 +++++++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

Index: linux-2.6.35.y/drivers/block/xen-blkfront.c
===================================================================
--- linux-2.6.35.y.orig/drivers/block/xen-blkfront.c
+++ linux-2.6.35.y/drivers/block/xen-blkfront.c
@@ -69,7 +69,7 @@ struct blk_shadow {
 
 static const struct block_device_operations xlvbd_block_fops;
 
-#define BLK_RING_SIZE __RING_SIZE((struct blkif_sring *)0, PAGE_SIZE)
+#define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
 /*
  * We have one of these per vbd, whether ide, scsi or 'other'.  They
Index: linux-2.6.35.y/drivers/net/xen-netfront.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/xen-netfront.c
+++ linux-2.6.35.y/drivers/net/xen-netfront.c
@@ -66,8 +66,8 @@ struct netfront_cb {
 
 #define GRANT_INVALID_REF	0
 
-#define NET_TX_RING_SIZE __RING_SIZE((struct xen_netif_tx_sring *)0, PAGE_SIZE)
-#define NET_RX_RING_SIZE __RING_SIZE((struct xen_netif_rx_sring *)0, PAGE_SIZE)
+#define NET_TX_RING_SIZE __CONST_RING_SIZE(xen_netif_tx, PAGE_SIZE)
+#define NET_RX_RING_SIZE __CONST_RING_SIZE(xen_netif_rx, PAGE_SIZE)
 #define TX_MAX_TARGET min_t(int, NET_RX_RING_SIZE, 256)
 
 struct netfront_info {
Index: linux-2.6.35.y/include/xen/interface/io/ring.h
===================================================================
--- linux-2.6.35.y.orig/include/xen/interface/io/ring.h
+++ linux-2.6.35.y/include/xen/interface/io/ring.h
@@ -24,8 +24,15 @@ typedef unsigned int RING_IDX;
  * A ring contains as many entries as will fit, rounded down to the nearest
  * power of two (so we can mask with (size-1) to loop around).
  */
-#define __RING_SIZE(_s, _sz) \
-    (__RD32(((_sz) - (long)&(_s)->ring + (long)(_s)) / sizeof((_s)->ring[0])))
+#define __CONST_RING_SIZE(_s, _sz)				\
+	(__RD32(((_sz) - offsetof(struct _s##_sring, ring)) /	\
+		sizeof(((struct _s##_sring *)0)->ring[0])))
+
+/*
+ * The same for passing in an actual pointer instead of a name tag.
+ */
+#define __RING_SIZE(_s, _sz)						\
+	(__RD32(((_sz) - (long)&(_s)->ring + (long)(_s)) / sizeof((_s)->ring[0])))
 
 /*
  * Macros to make the correct C datatypes for a new kind of ring.
