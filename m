Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767969Ab2KOOVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:21:02 -0500
Received: from mga02.intel.com ([134.134.136.20]:32741 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767840Ab2KOOVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:21:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,257,1352102400"; 
   d="scan'208";a="242686558"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/2] dw_dmac: check direction properly in dw_dma_cyclic_prep
Date: Thu, 15 Nov 2012 16:20:47 +0200
Message-Id: <1352989248-28913-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_transfer_direction is a normal enum. It means we can't usually use the
values as bit fields. Let's adjust this check and move it above the usage of
the direction parameter.

This patch introduces helper function is_slave_direction() that will be used
later in other places of the code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a4a5c80..771aa15 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -36,6 +36,11 @@
  * which does not support descriptor writeback.
  */
 
+static inline bool is_slave_direction(enum dma_transfer_direction direction)
+{
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+}
+
 static inline unsigned int dwc_get_dms(struct dw_dma_slave *slave)
 {
 	return slave ? slave->dst_master : 0;
@@ -1336,6 +1341,9 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 
 	retval = ERR_PTR(-EINVAL);
 
+	if (unlikely(!is_slave_direction(direction)))
+		goto out_err;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1350,8 +1358,6 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		goto out_err;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto out_err;
-	if (unlikely(!(direction & (DMA_MEM_TO_DEV | DMA_DEV_TO_MEM))))
-		goto out_err;
 
 	retval = ERR_PTR(-ENOMEM);
 
-- 
1.7.10.4

