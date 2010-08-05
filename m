Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696Ab0HEPQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:16:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:52414 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933260Ab0HEPQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:16:09 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: gregkh@suse.de
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        akpm@linux-foundation.org
Subject: [PATCH 3/3] powerpc: Dont require a dma_ops struct to set dma mask
Date: Thu,  5 Aug 2010 10:15:47 -0500
Message-Id: <1281021347-1278-4-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1281021347-1278-3-git-send-email-galak@kernel.crashing.org>
References: <1281021347-1278-1-git-send-email-galak@kernel.crashing.org>
 <1281021347-1278-2-git-send-email-galak@kernel.crashing.org>
 <1281021347-1278-3-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only reason to require a dma_ops struct is to see if it has
implemented set_dma_mask.  If not we can fall back to setting the mask
directly.

This resolves an issue with how to sequence the setting of a DMA mask
for platform devices.  Before we had an issue in that we have no way of
setting the DMA mask before the various low level bus notifiers get
called that might check it (swiotlb).

So now we can do:

	pdev = platform_device_alloc("foobar", 0);
	dma_set_mask(&pdev->dev, DMA_BIT_MASK(37));
	platform_device_register(pdev);

And expect the right thing to happen with the bus notifiers get called
via platform_device_register.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/include/asm/dma-mapping.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
index c85ef23..952208a 100644
--- a/arch/powerpc/include/asm/dma-mapping.h
+++ b/arch/powerpc/include/asm/dma-mapping.h
@@ -131,12 +131,10 @@ static inline int dma_set_mask(struct device *dev, u64 dma_mask)
 {
 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
 
-	if (unlikely(dma_ops == NULL))
-		return -EIO;
-	if (dma_ops->set_dma_mask != NULL)
-		return dma_ops->set_dma_mask(dev, dma_mask);
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
+	if (dma_ops && (dma_ops->set_dma_mask != NULL))
+		return dma_ops->set_dma_mask(dev, dma_mask);
 	*dev->dma_mask = dma_mask;
 	return 0;
 }
-- 
1.6.0.6

