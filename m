Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1HXWb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:31:58 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33421 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1HXWb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:31:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: JBeulich@novell.com, jeremy@goop.org, ian.campbell@citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@kernel.org
Subject: [PATCH 3/5] xen-swiotlb: Fix wrong panic.
Date: Wed, 24 Aug 2011 18:31:34 -0400
Message-Id: <1314225096-4861-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
References: <1314225096-4861-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4E557BD3.0057:SCFMA922111,ss=1,re=-4.000,fgs=0
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

