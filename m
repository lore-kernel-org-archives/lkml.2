Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2IQAvf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:51:35 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33941 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754690Ab2IQAva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:30 -0400
Message-Id: <20120917003632.215097822@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ronny Hegewald <ronny.hegewald@online.de>,
        Stefano Panella <stefano.panella@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 043/135] xen: Use correct masking in xen_swiotlb_alloc_coherent.
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ronny Hegewald <ronny.hegewald@online.de>

commit b5031ed1be0aa419250557123633453753181643 upstream.

When running 32-bit pvops-dom0 and a driver tries to allocate a coherent
DMA-memory the xen swiotlb-implementation returned memory beyond 4GB.

The underlaying reason is that if the supplied driver passes in a
DMA_BIT_MASK(64) ( hwdev->coherent_dma_mask is set to 0xffffffffffffffff)
our dma_mask will be u64 set to 0xffffffffffffffff even if we set it to
DMA_BIT_MASK(32) previously. Meaning we do not reset the upper bits.
By using the dma_alloc_coherent_mask function - it does the proper casting
and we get 0xfffffffff.

This caused not working sound on a system with 4 GB and a 64-bit
compatible sound-card with sets the DMA-mask to 64bit.

On bare-metal and the forward-ported xen-dom0 patches from OpenSuse a coherent
DMA-memory is always allocated inside the 32-bit address-range by calling
dma_alloc_coherent_mask.

This patch adds the same functionality to xen swiotlb and is a rebase of the
original patch from Ronny Hegewald which never got upstream b/c the
underlaying reason was not understood until now.

The original email with the original patch is in:
http://old-list-archives.xen.org/archives/html/xen-devel/2010-02/msg00038.html
the original thread from where the discussion started is in:
http://old-list-archives.xen.org/archives/html/xen-devel/2010-01/msg00928.html

Signed-off-by: Ronny Hegewald <ronny.hegewald@online.de>
Signed-off-by: Stefano Panella <stefano.panella@citrix.com>
Acked-By: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/swiotlb-xen.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 1afb4fb..4d51948 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -232,7 +232,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		return ret;
 
 	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = hwdev->coherent_dma_mask;
+		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
 
 	phys = virt_to_phys(ret);
 	dev_addr = xen_phys_to_bus(phys);


