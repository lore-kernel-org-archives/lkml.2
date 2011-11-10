Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab1KJJdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:33:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62384 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934094Ab1KJJd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:33:27 -0500
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v4-rebased 5/7] iommu/amd: announce supported page sizes
Date: Thu, 10 Nov 2011 11:32:29 +0200
Message-Id: <1320917551-11328-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320917551-11328-1-git-send-email-ohad@wizery.com>
References: <1320917551-11328-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support arbitrary page sizes (as long as
they're an order of 4KiB).

This way the IOMMU core will retain the existing behavior we're used to;
it will let us map regions that:
- their size is an order of 4KiB
- they are naturally aligned

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Joerg Roedel <Joerg.Roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a3b7072..3415738 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -41,6 +41,24 @@
 
 #define LOOP_TIMEOUT	100000
 
+/*
+ * This bitmap is used to advertise the page sizes our hardware support
+ * to the IOMMU core, which will then use this information to split
+ * physically contiguous memory regions it is mapping into page sizes
+ * that we support.
+ *
+ * Traditionally the IOMMU core just handed us the mappings directly,
+ * after making sure the size is an order of a 4KiB page and that the
+ * mapping has natural alignment.
+ *
+ * To retain this behavior, we currently advertise that we support
+ * all page sizes that are an order of 4KiB.
+ *
+ * If at some point we'd like to utilize the IOMMU core's new behavior,
+ * we could change this to advertise the real page sizes we support.
+ */
+#define AMD_IOMMU_PGSIZES	(~0xFFFUL)
+
 static DEFINE_RWLOCK(amd_iommu_devtable_lock);
 
 /* A list of preallocated protection domains */
@@ -2779,6 +2797,7 @@ static struct iommu_ops amd_iommu_ops = {
 	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
+	.pgsize_bitmap	= AMD_IOMMU_PGSIZES,
 };
 
 /*****************************************************************************
-- 
1.7.5.4

