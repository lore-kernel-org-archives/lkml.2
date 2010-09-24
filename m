Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab0IXQ2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:28:24 -0400
Received: from kroah.org ([198.145.64.141]:38286 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932638Ab0IXQ2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:18 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:17 2010
Message-Id: <20100924162617.519967953@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:18 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, tiwai@suse.de,
        chris@chris-wilson.co.uk, Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [30/80] agp/intel: fix dma mask bits on sandybridge
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

[This is backport patch from upstream 877fdacf.]

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/agp/intel-agp.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -835,7 +835,7 @@ static const struct intel_driver_descrip
 static int __devinit intel_gmch_probe(struct pci_dev *pdev,
 				      struct agp_bridge_data *bridge)
 {
-	int i;
+	int i, mask;
 	bridge->driver = NULL;
 
 	for (i = 0; intel_agp_chipsets[i].name != NULL; i++) {
@@ -855,14 +855,19 @@ static int __devinit intel_gmch_probe(st
 
 	dev_info(&pdev->dev, "Intel %s Chipset\n", intel_agp_chipsets[i].name);
 
-	if (bridge->driver->mask_memory == intel_i965_mask_memory) {
-		if (pci_set_dma_mask(intel_private.pcidev, DMA_BIT_MASK(36)))
-			dev_err(&intel_private.pcidev->dev,
-				"set gfx device dma mask 36bit failed!\n");
-		else
-			pci_set_consistent_dma_mask(intel_private.pcidev,
-						    DMA_BIT_MASK(36));
-	}
+	if (bridge->driver->mask_memory == intel_gen6_mask_memory)
+		mask = 40;
+	else if (bridge->driver->mask_memory == intel_i965_mask_memory)
+		mask = 36;
+	else
+		mask = 32;
+
+	if (pci_set_dma_mask(intel_private.pcidev, DMA_BIT_MASK(mask)))
+		dev_err(&intel_private.pcidev->dev,
+			"set gfx device dma mask %d-bit failed!\n", mask);
+	else
+		pci_set_consistent_dma_mask(intel_private.pcidev,
+					    DMA_BIT_MASK(mask));
 
 	return 1;
 }


