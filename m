Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1BOBSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 20:18:52 -0500
Received: from sh.osrg.net ([192.16.179.4]:49964 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1BOBSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 20:18:50 -0500
Date: Tue, 15 Feb 2011 10:17:55 +0900
To: akpm@linux-foundation.org
Cc: cebbert@redhat.com, arekm@maven.pl, hancockrwd@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH -mm] swiotlb: fix wrong panic
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110215101737P.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 15 Feb 2011 10:17:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb's map_page wrongly calls panic() when it can't find a buffer
fit for device's dma mask. It should return an error instead.

Devices with an odd dma mask (i.e. under 4G) like b44 network card hit
this bug (the system crashes):

http://marc.info/?l=linux-kernel&m=129648943830106&w=2

If swiotlb returns an error, b44 driver can use the own bouncing
mechanism.

Reported-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: stable@kernel.org
---
 lib/swiotlb.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index c47bbe1..93ca08b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -686,8 +686,10 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
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
-- 
1.7.2.3

