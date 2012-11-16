Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2KPN7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:59:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:36657 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab2KPN7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,264,1352102400"; 
   d="scan'208";a="220649251"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/6] dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
Date: Fri, 16 Nov 2012 15:59:16 +0200
Message-Id: <1353074360-1903-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_transfer_direction is a normal enum. It means we can't usually use the
values as bit fields. Let's adjust this check and move it above the usage of
the direction parameter.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw_dmac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a4a5c80..5e2c4dc 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1336,6 +1336,9 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 
 	retval = ERR_PTR(-EINVAL);
 
+	if (unlikely(!is_slave_xfer(direction)))
+		goto out_err;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1350,8 +1353,6 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		goto out_err;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto out_err;
-	if (unlikely(!(direction & (DMA_MEM_TO_DEV | DMA_DEV_TO_MEM))))
-		goto out_err;
 
 	retval = ERR_PTR(-ENOMEM);
 
-- 
1.7.10.4

