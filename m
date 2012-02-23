Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab2BWAtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 19:49:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:35941 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab2BWAtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 19:49:33 -0500
Message-Id: <20120223004930.991839020@gulag1.americas.sgi.com>
References: <20120223004930.817124691@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Feb 2012 18:49:31 -0600
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Daniel Rahn <drahn@suse.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jack Steiner <steiner@sgi.com>, Tony Ernst <tee@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Mike Habeck <habeck@sgi.com>
Subject: [PATCH 1/2] x86 PCI: Fix identity mapping for sandy bridge
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
