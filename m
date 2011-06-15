Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab1FPHmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:42:02 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43203 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753940Ab1FPHAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:00:12 -0400
X-Sasl-enc: zMxydKaF2C2KceU8s1MNdBQKBQsbIaJS4/7d7ucpWQEV 1308207611
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:29 2011
Message-Id: <20110616000229.769502618@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 16:59:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Travis <travis@sgi.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [08/89] intel-iommu: Remove Host Bridge devices from identity
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 mapping

From: Mike Travis <travis@sgi.com>

commit 825507d6d059f1cbe2503e0e5a3926225b983aec upstream.

When using the 1:1 (identity) PCI DMA remapping, PCI Host Bridge devices
that do not use the IOMMU causes a kernel panic.  Fix that by not
inserting those devices into the si_domain.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Mike Habeck <habeck@sgi.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/intel-iommu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -46,6 +46,8 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
+#define IS_BRIDGE_HOST_DEVICE(pdev) \
+			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2217,6 +2219,9 @@ static int __init iommu_prepare_static_i
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
+		/* Skip Host/PCI Bridge devices */
+		if (IS_BRIDGE_HOST_DEVICE(pdev))
+			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
 			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
 			       hw ? "hardware" : "software", pci_name(pdev));


