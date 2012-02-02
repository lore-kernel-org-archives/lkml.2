Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084Ab2BBX5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:57:10 -0500
Received: from relay2.sgi.com ([192.48.179.30]:47559 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756025Ab2BBX4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:56:52 -0500
Message-Id: <20120202235650.736578988@gulag1.americas.sgi.com>
References: <20120202235650.563029146@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Feb 2012 17:56:51 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Mike Habeck <habeck@sgi.com>
Subject: [PATCH 1/3] x86 PCI: Fix identity mapping for sandy bridge
Content-Disposition: inline; filename=fix-iommu-identity-mapping-for-sb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With SandyBridge, Intel has changed these Socket PCI devices to have a class
type of "System Peripheral" & "Performance counter", rather than "HostBridge".
So instead of using a "special" case to detect which devices will not be
doing DMA, use the fact that a device that is not associated with an IOMMU,
will not need an identity map.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Mike Habeck <habeck@sgi.com>
---
 drivers/iommu/intel-iommu.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- linux.orig/drivers/iommu/intel-iommu.c
+++ linux/drivers/iommu/intel-iommu.c
@@ -48,8 +48,6 @@
 #define ROOT_SIZE		VTD_PAGE_SIZE
 #define CONTEXT_SIZE		VTD_PAGE_SIZE
 
-#define IS_BRIDGE_HOST_DEVICE(pdev) \
-			    ((pdev->class >> 8) == PCI_CLASS_BRIDGE_HOST)
 #define IS_GFX_DEVICE(pdev) ((pdev->class >> 16) == PCI_BASE_CLASS_DISPLAY)
 #define IS_ISA_DEVICE(pdev) ((pdev->class >> 8) == PCI_CLASS_BRIDGE_ISA)
 #define IS_AZALIA(pdev) ((pdev)->vendor == 0x8086 && (pdev)->device == 0x3a3e)
@@ -2369,18 +2367,18 @@ static int __init iommu_prepare_static_i
 		return -EFAULT;
 
 	for_each_pci_dev(pdev) {
-		/* Skip Host/PCI Bridge devices */
-		if (IS_BRIDGE_HOST_DEVICE(pdev))
-			continue;
 		if (iommu_should_identity_map(pdev, 1)) {
-			printk(KERN_INFO "IOMMU: %s identity mapping for device %s\n",
-			       hw ? "hardware" : "software", pci_name(pdev));
-
 			ret = domain_add_dev_info(si_domain, pdev,
-						     hw ? CONTEXT_TT_PASS_THROUGH :
-						     CONTEXT_TT_MULTI_LEVEL);
-			if (ret)
+					     hw ? CONTEXT_TT_PASS_THROUGH :
+						  CONTEXT_TT_MULTI_LEVEL);
+			if (ret) {
+				/* device not associated with an iommu */
+				if (ret == -ENODEV)
+					continue;
 				return ret;
+			}
+			pr_info("IOMMU: %s identity mapping for device %s\n",
+				hw ? "hardware" : "software", pci_name(pdev));
 		}
 	}
 

-- 
