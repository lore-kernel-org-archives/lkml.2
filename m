Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1E1SPL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 14:15:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:33851 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754941Ab1E1SPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 14:15:05 -0400
Message-Id: <20110528181502.074464458@gulag1.americas.sgi.com>
References: <20110528181501.896092225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 28 May 2011 13:15:02 -0500
From: Mike Travis <travis@sgi.com>
To: David Woodhouse <dwmw2@infradead.org>, Chris Wright <chrisw@sous-sol.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Mike Habeck <habeck@sgi.com>, Dimitri Sivanich <sivanich@sgi.com>,
        Derek Fults <dfults@sgi.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        stable@kernel.org, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] Intel pci: Check for identity mapping candidate using system dma mask
Content-Disposition: inline; filename=check-against-reqd-mask.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	The identity mapping code appears to make the assumption that
	if the devices dma_mask is greater than 32bits the device can
	use identity mapping.  But that is not true, take the case 
	where we have a 40bit device in a 44bit architecture.  The
	device can potentially receive a physical address that it
	will truncate and cause incorrect addresses to be used.

	Instead check to see if the device's dma_mask is large enough
	to address the system's dma_mask.

From: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Cc: stable@kernel.org
---
 drivers/pci/intel-iommu.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -2187,8 +2187,19 @@ static int iommu_should_identity_map(str
 	 * Assume that they will -- if they turn out not to be, then we can 
 	 * take them out of the 1:1 domain later.
 	 */
-	if (!startup)
-		return pdev->dma_mask > DMA_BIT_MASK(32);
+	if (!startup) {
+		/*
+		 * If the device's dma_mask is less than the system's memory
+		 * size then this is not a candidate for identity mapping.
+		 */
+		u64 dma_mask = pdev->dma_mask;
+
+		if (pdev->dev.coherent_dma_mask &&
+		    pdev->dev.coherent_dma_mask < dma_mask)
+			dma_mask = pdev->dev.coherent_dma_mask;
+
+		return dma_mask >= dma_get_required_mask(&pdev->dev);
+	}
 
 	return 1;
 }

-- 
