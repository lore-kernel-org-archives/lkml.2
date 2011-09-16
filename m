Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab1IPRwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:52:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53304 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab1IPRwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:52:31 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v3 5/6] iommu/intel: announce supported page sizes
Date: Fri, 16 Sep 2011 20:51:45 +0300
Message-Id: <1316195506-9777-6-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316195506-9777-1-git-send-email-ohad@wizery.com>
References: <1316195506-9777-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the IOMMU core know we support arbitrary page sizes (as long as
they're an order of 4KiB).

This way the IOMMU core will retain the existing behavior we're used to;
it will let us map regions that:
- their size is an order of 4KiB
- they are naturally aligned

Note: Intel IOMMU hardware doesn't support arbitrary page sizes,
but the driver does (it splits arbitrary-sized mappings into
the pages supported by the hardware).

To make everything simpler for now, though, this patch effectively tells
the IOMMU core to keep giving this driver the same memory regions it did
before, so nothing is changed as far as it's concerned.

At this point, the page sizes announced remain static within the IOMMU
core. To correctly utilize the pgsize-splitting of the IOMMU core by
this driver, it seems that some core changes should still be done,
because Intel's IOMMU page size capabilities seem to have the potential
to be different between different DMA remapping devices.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/iommu/intel-iommu.c |   21 ++++++++++++++++++++-
 1 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c621c98..46c21a2 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -3426,6 +3426,24 @@ static struct notifier_block device_nb = {
 	.notifier_call = device_notifier,
 };
 
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
+static unsigned long intel_iommu_pgsizes = ~0xFFFUL;
+
 int __init intel_iommu_init(void)
 {
 	int ret = 0;
@@ -3486,7 +3504,8 @@ int __init intel_iommu_init(void)
 
 	init_iommu_pm_ops();
 
-	register_iommu(&intel_iommu_ops);
+	register_iommu_pgsize(&intel_iommu_ops, &intel_iommu_pgsizes,
+							BITS_PER_LONG);
 
 	bus_register_notifier(&pci_bus_type, &device_nb);
 
-- 
1.7.4.1

