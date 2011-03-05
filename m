Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328Ab1CEBAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:07 -0500
Received: from kroah.org ([198.145.64.141]:50183 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760272Ab1CEBAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:36 2011
Message-Id: <20110305005636.458959893@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [19/73] swiotlb: fix wrong panic
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

commit fba99fa38b023224680308a482e12a0eca87e4e1 upstream.

swiotlb's map_page wrongly calls panic() when it can't find a buffer fit
for device's dma mask.  It should return an error instead.

Devices with an odd dma mask (i.e.  under 4G) like b44 network card hit
this bug (the system crashes):

   http://marc.info/?l=linux-kernel&m=129648943830106&w=2

If swiotlb returns an error, b44 driver can use the own bouncing
mechanism.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/swiotlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct devic
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (!dma_capable(dev, dev_addr, size))
-		panic("map_single: bounce buffer is not DMA'ble");
+	if (!dma_capable(dev, dev_addr, size)) {
+		swiotlb_tbl_unmap_single(dev, map, size, dir);
+		dev_addr = swiotlb_virt_to_bus(dev, io_tlb_overflow_buffer);
+	}
 
 	return dev_addr;
 }


