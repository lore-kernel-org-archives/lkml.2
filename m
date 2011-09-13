Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab1IMTd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 15:33:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab1IMTcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 15:32:15 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 4/6] iommu/amd: announce supported page sizes
Date: Tue, 13 Sep 2011 22:31:26 +0300
Message-Id: <1315942288-17297-4-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315942288-17297-1-git-send-email-ohad@wizery.com>
References: <1315942288-17297-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support arbitrary page sizes (as long as
they're an order of 4KB).

This way the IOMMU core will retain the existing behavior we're used to;
it will let us map regions that:
- their size is an order of 4KB
- they are naturally aligned

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a14f8dc..17fa0fc 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2488,12 +2488,31 @@ static unsigned device_dma_ops_init(void)
 }
 
 /*
+ * This bitmap is used to advertise the page sizes our hardware support
+ * to the IOMMU core, which will then use this information to split
+ * physically contiguous memory regions it is mapping into page sizes
+ * that we support.
+ *
+ * Traditionally the IOMMU core just handed us the mappings directly,
+ * after making sure the size is an order of a 4KB page and that the
+ * mapping has natural alignment.
+ *
+ * To retain this behavior, we currently advertise that we support
+ * all page sizes that are an order of 4KB.
+ *
+ * If at some point we'd like to utilize the IOMMU core's new behavior,
+ * we could change this to advertise the real page sizes we support.
+ */
+static unsigned long amd_iommu_pgsizes = ~0xFFFUL;
+
+/*
  * The function which clues the AMD IOMMU driver into dma_ops.
  */
 
 void __init amd_iommu_init_api(void)
 {
-	register_iommu(&amd_iommu_ops);
+	register_iommu_pgsize(&amd_iommu_ops, &amd_iommu_pgsizes,
+						BITS_PER_LONG);
 }
 
 int __init amd_iommu_init_dma_ops(void)
-- 
1.7.4.1

