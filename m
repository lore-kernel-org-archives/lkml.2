Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab1FWLee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:34:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:46440 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759161Ab1FWLeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:34:09 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH v3 3/3] powerpc: Dont require a dma_ops struct to set dma mask
Date: Thu, 23 Jun 2011 06:33:59 -0500
Message-Id: <1308828839-27349-3-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1308828839-27349-2-git-send-email-galak@kernel.crashing.org>
References: <1308744176-24491-1-git-send-email-galak@kernel.crashing.org>
 <1308828839-27349-1-git-send-email-galak@kernel.crashing.org>
 <1308828839-27349-2-git-send-email-galak@kernel.crashing.org>
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
	platform_device_add(pdev);

And expect the right thing to happen with the bus notifiers get called
via platform_device_add.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
v3: Fixed commit comment to use platform_device_add()
 arch/powerpc/kernel/dma.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index d238c08..4f0959f 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -161,9 +161,7 @@ int dma_set_mask(struct device *dev, u64 dma_mask)
 
 	if (ppc_md.dma_set_mask)
 		return ppc_md.dma_set_mask(dev, dma_mask);
-	if (unlikely(dma_ops == NULL))
-		return -EIO;
-	if (dma_ops->set_dma_mask != NULL)
+	if ((dma_ops != NULL) && (dma_ops->set_dma_mask != NULL))
 		return dma_ops->set_dma_mask(dev, dma_mask);
 	if (!dev->dma_mask || !dma_supported(dev, dma_mask))
 		return -EIO;
-- 
1.7.3.4

