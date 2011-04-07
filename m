Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab1DGTrK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:47:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:34083 "HELO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756565Ab1DGTrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:47:08 -0400
Message-ID: <4D9E14B9.6010505@sgi.com>
Date: Thu, 07 Apr 2011 12:47:05 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wright <chrisw@sous-sol.org>
Cc: Mike Habeck <habeck@sgi.com>, iommu@lists.linux-foundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] Intel pci: Remove Host Bridge devices from identity mapping
References: <20110329233602.272459647@gulag1.americas.sgi.com>
In-Reply-To: <20110329233602.272459647@gulag1.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    When the IOMMU is being used, each request for a DMA mapping requires
    the intel_iommu code to look for some space in the DMA mapping table.
    For most drivers this occurs for each transfer.

    When there are many outstanding DMA mappings [as seems to be the case
    with the 10GigE driver], the table grows large and the search for
    space becomes increasingly time consuming.  Performance for the
    10GigE driver drops to about 10% of it's capacity on a UV system
    when the CPU count is large.

    The workaround is to specify the iommu=pt option which sets up a 1:1
    identity map for those devices that support enough DMA address bits to
    cover the physical system memory.  This is the "pass through" option.

    But this can only be accomplished by those devices that pass their
    DMA data through the IOMMU (VTd).  But Host Bridge Devices connected
    to System Sockets do not pass their data through the VTd, thus the
    following error occurs:

    IOMMU: hardware identity mapping for device 1000:3e:00.0
    Failed to setup IOMMU pass-through
    BUG: unable to handle kernel NULL pointer dereference at 000000000000001c

    This patch fixes that problem but removing Host Bridge devices from
    being identity mapped, given that they do not generate DMA ops anyways.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
---
 drivers/pci/intel-iommu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux.orig/drivers/pci/intel-iommu.c
+++ linux/drivers/pci/intel-iommu.c
@@ -46,6 +46,7 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
+#define IS_HOSTBRIDGE_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2183,7 +2184,7 @@ static int iommu_should_identity_map(str
 	 * take them out of the 1:1 domain later.
 	 */
 	if (!startup)
-		return pdev->dma_mask > DMA_BIT_MASK(32);
+		return pdev->dma_mask == DMA_BIT_MASK(64);
 
 	return 1;
 }
@@ -2198,6 +2199,9 @@ static int __init iommu_prepare_static_i
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
+		/* Skip PCI Host Bridge devices */
+		if (IS_HOSTBRIDGE_DEVICE(pdev))
+			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
 			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
 			       hw ? "hardware" : "software", pci_name(pdev));

-- 
