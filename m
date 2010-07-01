Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0GAUvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:51:19 -0400
Received: from kroah.org ([198.145.64.141]:47495 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab0GAUuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:50:19 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:32 2010
Message-Id: <20100701173432.620398639@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:34:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [patch 069/164] x86/amd-iommu: Fall back to GART if initialization fails
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit d7f0776975334070a93370ae048fda0c31a91c38 upstream.

This patch implements a fallback to the GART IOMMU if this
is possible and the AMD IOMMU initialization failed.
Otherwise the fallback would be nommu which is very
problematic on machines with more than 4GB of memory or
swiotlb which hurts io-performance.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/amd_iommu.c      |    4 ----
 arch/x86/kernel/amd_iommu_init.c |    9 +++++++++
 2 files changed, 9 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2256,10 +2256,6 @@ int __init amd_iommu_init_dma_ops(void)
 
 	iommu_detected = 1;
 	swiotlb = 0;
-#ifdef CONFIG_GART_IOMMU
-	gart_iommu_aperture_disabled = 1;
-	gart_iommu_aperture = 0;
-#endif
 
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -1340,6 +1340,15 @@ free:
 
 	free_unity_maps();
 
+#ifdef CONFIG_GART_IOMMU
+	/*
+	 * We failed to initialize the AMD IOMMU - try fallback to GART
+	 * if possible.
+	 */
+	gart_iommu_init();
+
+#endif
+
 	goto out;
 }
 


