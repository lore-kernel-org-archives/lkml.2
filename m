Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab1FPHmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:42:46 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44796 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754777Ab1FPHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:06 -0400
X-Sasl-enc: TpNrw8/JwPpn6I8yDgGhkgOSBvHbcFpkm/KyM/tNhwFl 1308207605
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.383591685@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Travis <travis@sgi.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [04/89] intel-iommu: Check for identity mapping candidate using
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 system dma mask

From: Chris Wright <chrisw@sous-sol.org>

commit 8fcc5372fbac085199d84a880503ed67aba3fe49 upstream.

The identity mapping code appears to make the assumption that if the
devices dma_mask is greater than 32bits the device can use identity
mapping.  But that is not true: take the case where we have a 40bit
device in a 44bit architecture. The device can potentially receive a
physical address that it will truncate and cause incorrect addresses
to be used.

Instead check to see if the device's dma_mask is large enough
to address the system's dma_mask.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -2190,8 +2190,19 @@ static int iommu_should_identity_map(str
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


