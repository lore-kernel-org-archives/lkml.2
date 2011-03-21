Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1CUXgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:36:14 -0400
Received: from kroah.org ([198.145.64.141]:49659 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1CUXQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:16:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:17 2011
Message-Id: <20110321230717.434097447@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:07:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amir Hanania <amir.hanania@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [80/87] ixgbe: work around for DDP last buffer size
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amir Hanania <amir.hanania@intel.com>

commit c600636bd560b04973174caa5e349a72bce51637 upstream.

A HW limitation was recently discovered where the last buffer in a DDP offload
cannot be a full buffer size in length. Fix the issue with a work around by
adding another buffer with size = 1.

Signed-off-by: Amir Hanania <amir.hanania@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgbe/ixgbe_fcoe.c |   51 ++++++++++++++++++++++++++++++++++++++++-
 drivers/net/ixgbe/ixgbe_fcoe.h |    2 +
 2 files changed, 52 insertions(+), 1 deletion(-)

--- a/drivers/net/ixgbe/ixgbe_fcoe.c
+++ b/drivers/net/ixgbe/ixgbe_fcoe.c
@@ -151,7 +151,7 @@ int ixgbe_fcoe_ddp_get(struct net_device
 	struct scatterlist *sg;
 	unsigned int i, j, dmacount;
 	unsigned int len;
-	static const unsigned int bufflen = 4096;
+	static const unsigned int bufflen = IXGBE_FCBUFF_MIN;
 	unsigned int firstoff = 0;
 	unsigned int lastsize;
 	unsigned int thisoff = 0;
@@ -241,6 +241,24 @@ int ixgbe_fcoe_ddp_get(struct net_device
 	/* only the last buffer may have non-full bufflen */
 	lastsize = thisoff + thislen;
 
+	/*
+	 * lastsize can not be buffer len.
+	 * If it is then adding another buffer with lastsize = 1.
+	 */
+	if (lastsize == bufflen) {
+		if (j >= IXGBE_BUFFCNT_MAX) {
+			e_err(drv, "xid=%x:%d,%d,%d:addr=%llx "
+				"not enough user buffers. We need an extra "
+				"buffer because lastsize is bufflen.\n",
+				xid, i, j, dmacount, (u64)addr);
+			goto out_noddp_free;
+		}
+
+		ddp->udl[j] = (u64)(fcoe->extra_ddp_buffer_dma);
+		j++;
+		lastsize = 1;
+	}
+
 	fcbuff = (IXGBE_FCBUFF_4KB << IXGBE_FCBUFF_BUFFSIZE_SHIFT);
 	fcbuff |= ((j & 0xff) << IXGBE_FCBUFF_BUFFCNT_SHIFT);
 	fcbuff |= (firstoff << IXGBE_FCBUFF_OFFSET_SHIFT);
@@ -519,6 +537,24 @@ void ixgbe_configure_fcoe(struct ixgbe_a
 			e_err(drv, "failed to allocated FCoE DDP pool\n");
 
 		spin_lock_init(&fcoe->lock);
+
+		/* Extra buffer to be shared by all DDPs for HW work around */
+		fcoe->extra_ddp_buffer = kmalloc(IXGBE_FCBUFF_MIN, GFP_ATOMIC);
+		if (fcoe->extra_ddp_buffer == NULL) {
+			e_err(drv, "failed to allocated extra DDP buffer\n");
+			goto out_extra_ddp_buffer_alloc;
+		}
+
+		fcoe->extra_ddp_buffer_dma =
+			dma_map_single(&adapter->pdev->dev,
+				       fcoe->extra_ddp_buffer,
+				       IXGBE_FCBUFF_MIN,
+				       DMA_FROM_DEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev,
+				      fcoe->extra_ddp_buffer_dma)) {
+			e_err(drv, "failed to map extra DDP buffer\n");
+			goto out_extra_ddp_buffer_dma;
+		}
 	}
 
 	/* Enable L2 eth type filter for FCoE */
@@ -568,6 +604,14 @@ void ixgbe_configure_fcoe(struct ixgbe_a
 		}
 	}
 #endif
+
+	return;
+
+out_extra_ddp_buffer_dma:
+	kfree(fcoe->extra_ddp_buffer);
+out_extra_ddp_buffer_alloc:
+	pci_pool_destroy(fcoe->pool);
+	fcoe->pool = NULL;
 }
 
 /**
@@ -587,6 +631,11 @@ void ixgbe_cleanup_fcoe(struct ixgbe_ada
 	if (fcoe->pool) {
 		for (i = 0; i < IXGBE_FCOE_DDP_MAX; i++)
 			ixgbe_fcoe_ddp_put(adapter->netdev, i);
+		dma_unmap_single(&adapter->pdev->dev,
+				 fcoe->extra_ddp_buffer_dma,
+				 IXGBE_FCBUFF_MIN,
+				 DMA_FROM_DEVICE);
+		kfree(fcoe->extra_ddp_buffer);
 		pci_pool_destroy(fcoe->pool);
 		fcoe->pool = NULL;
 	}
--- a/drivers/net/ixgbe/ixgbe_fcoe.h
+++ b/drivers/net/ixgbe/ixgbe_fcoe.h
@@ -70,6 +70,8 @@ struct ixgbe_fcoe {
 	spinlock_t lock;
 	struct pci_pool *pool;
 	struct ixgbe_fcoe_ddp ddp[IXGBE_FCOE_DDP_MAX];
+	unsigned char *extra_ddp_buffer;
+	dma_addr_t extra_ddp_buffer_dma;
 };
 
 #endif /* _IXGBE_FCOE_H */


