Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab1HZSpE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 14:45:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35694 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920Ab1HZSoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 14:44:55 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        joe@perches.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH 3/6] xen-swiotlb: Fix wrong panic.
Date: Fri, 26 Aug 2011 14:44:27 -0400
Message-Id: <1314384270-19850-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
References: <1314384270-19850-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E57E99F.00E3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Propagate the baremetal git commit "swiotlb: fix wrong panic"
(fba99fa38b023224680308a482e12a0eca87e4e1) in the Xen-SWIOTLB version.
wherein swiotlb's map_page wrongly calls panic() when it can't find
a buffer fit for device's dma mask.  It should return an error instead.

Devices with an odd dma mask (i.e.  under 4G) like b44 network card hit
this bug (the system crashes):

http://marc.info/?l=linux-kernel&m=129648943830106&w=2

If xen-swiotlb returns an error, b44 driver can use the own bouncing
mechanism.

CC: stable@kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/swiotlb-xen.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index d45cbac..ea8c289 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -293,9 +293,10 @@ dma_addr_t xen_swiotlb_map_page(struct device *dev, struct page *page,
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
-- 
1.7.4.1

