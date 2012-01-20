Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2ATBK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 20:10:56 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:2869 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753904Ab2ATBKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 20:10:55 -0500
X-Greylist: delayed 583 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 20:10:55 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAEK7GE+4rxIp/2dsb2JhbABDrHt9gQaCIC8jT0sDIhLBFolqAgEBUQgHAwIHAQECAQEFAwEBAQECB4E5gTgBBgIDBwEEAQEBAYQNBIg7jFyOEoRW
X-IronPort-AV: E=Sophos;i="4.71,539,1320642000"; 
   d="scan'208";a="157710607"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-nvme@infradead.org, hpa@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH] NVMe: Fix compilation on architecturs without readq/writeq
Date: Thu, 19 Jan 2012 20:01:05 -0500
Message-Id: <1327021265-22184-1-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only places that uses readq/writeq are in the initialisation
path.  Since they're not performance critical, always use readl/writel.

Reported-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/block/nvme.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nvme.c b/drivers/block/nvme.c
index c1dc4d8..f27deec 100644
--- a/drivers/block/nvme.c
+++ b/drivers/block/nvme.c
@@ -972,6 +972,20 @@ static __devinit struct nvme_queue *nvme_create_queue(struct nvme_dev *dev,
 	return ERR_PTR(result);
 }
 
+static inline unsigned long long nvme_readq(const volatile void __iomem *addr)
+{
+	unsigned long long result = readl(addr);
+	result |= (unsigned long long)readl(addr + 4) << 32;
+	return result;
+}
+
+static inline void
+nvme_writeq(unsigned long long val, volatile void __iomem *addr)
+{
+	writel(val, addr);
+	writel(val >> 32, addr + 4);
+}
+
 static int __devinit nvme_configure_admin_queue(struct nvme_dev *dev)
 {
 	int result;
@@ -996,11 +1010,11 @@ static int __devinit nvme_configure_admin_queue(struct nvme_dev *dev)
 
 	writel(0, &dev->bar->cc);
 	writel(aqa, &dev->bar->aqa);
-	writeq(nvmeq->sq_dma_addr, &dev->bar->asq);
-	writeq(nvmeq->cq_dma_addr, &dev->bar->acq);
+	nvme_writeq(nvmeq->sq_dma_addr, &dev->bar->asq);
+	nvme_writeq(nvmeq->cq_dma_addr, &dev->bar->acq);
 	writel(dev->ctrl_config, &dev->bar->cc);
 
-	cap = readq(&dev->bar->cap);
+	cap = nvme_readq(&dev->bar->cap);
 	timeout = ((NVME_CAP_TIMEOUT(cap) + 1) * HZ / 2) + jiffies;
 	dev->db_stride = NVME_CAP_STRIDE(cap);
 
-- 
1.7.7.3

