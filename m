Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab1KJFQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 00:16:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934466Ab1KJDY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:24:57 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.103679751@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [067/262] xen-swiotlb: Fix wrong panic.
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit ab2a47bd242d6cdcf6b2b64797f271c6f0a6d338 upstream.

Propagate the baremetal git commit "swiotlb: fix wrong panic"
(fba99fa38b023224680308a482e12a0eca87e4e1) in the Xen-SWIOTLB version.
wherein swiotlb's map_page wrongly calls panic() when it can't find
a buffer fit for device's dma mask.  It should return an error instead.

Devices with an odd dma mask (i.e.  under 4G) like b44 network card hit
this bug (the system crashes):

http://marc.info/?l=linux-kernel&m=129648943830106&w=2

If xen-swiotlb returns an error, b44 driver can use the own bouncing
mechanism.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/xen/swiotlb-xen.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -278,9 +278,10 @@ dma_addr_t xen_swiotlb_map_page(struct d
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (!dma_capable(dev, dev_addr, size))
-		panic("map_single: bounce buffer is not DMA'ble");
-
+	if (!dma_capable(dev, dev_addr, size)) {
+		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		dev_addr = 0;
+	}
 	return dev_addr;
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_map_page);


