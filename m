Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1AFAaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:22 -0500
Received: from kroah.org ([198.145.64.141]:35836 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1AFAaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:20 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:04 2011
Message-Id: <20110106002304.598621821@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Jens Axboe <axboe@kernel.dk>, David Miller <davem@davemloft.net>
Subject: [083/152] xen: Provide a variant of __RING_SIZE() that is an integer constant expression
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeremy Fitzhardinge <jeremy@goop.org>

commit 667c78afaec0ac500908e191e8f236e9578d7b1f upstream.

Without this, gcc 4.5 won't compile xen-netfront and xen-blkfront, where
this is being used to specify array sizes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c    |    2 +-
 drivers/net/xen-netfront.c      |    4 ++--
 include/xen/interface/io/ring.h |   11 +++++++++--
 3 files changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -71,7 +71,7 @@ struct blk_shadow {
 
 static const struct block_device_operations xlvbd_block_fops;
 
-#define BLK_RING_SIZE __RING_SIZE((struct blkif_sring *)0, PAGE_SIZE)
+#define BLK_RING_SIZE __CONST_RING_SIZE(blkif, PAGE_SIZE)
 
 /*
  * We have one of these per vbd, whether ide, scsi or 'other'.  They
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -66,8 +66,8 @@ struct netfront_cb {
 
 #define GRANT_INVALID_REF	0
 
-#define NET_TX_RING_SIZE __RING_SIZE((struct xen_netif_tx_sring *)0, PAGE_SIZE)
-#define NET_RX_RING_SIZE __RING_SIZE((struct xen_netif_rx_sring *)0, PAGE_SIZE)
+#define NET_TX_RING_SIZE __CONST_RING_SIZE(xen_netif_tx, PAGE_SIZE)
+#define NET_RX_RING_SIZE __CONST_RING_SIZE(xen_netif_rx, PAGE_SIZE)
 #define TX_MAX_TARGET min_t(int, NET_RX_RING_SIZE, 256)
 
 struct netfront_info {
--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
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


