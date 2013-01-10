Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3AJIyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:54:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:3284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998Ab3AJIx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:53:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,443,1355126400"; 
   d="scan'208";a="244514073"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>
Subject: [PATCHv2 03/11] dma: dw_dmac: check direction properly in dw_dma_cyclic_prep
Date: Thu, 10 Jan 2013 10:52:58 +0200
Message-Id: <1357807986-4026-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1357807986-4026-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_transfer_direction is a normal enum. It means we can't usually use the
values as bit fields. Let's adjust this check and move it above the usage of
the direction parameter, due to the nature of the following usage of it.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/dma/dw_dmac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 6c9e20a..ca996bc 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1355,6 +1355,9 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 
 	retval = ERR_PTR(-EINVAL);
 
+	if (unlikely(!is_slave_direction(direction)))
+		goto out_err;
+
 	if (direction == DMA_MEM_TO_DEV)
 		reg_width = __ffs(sconfig->dst_addr_width);
 	else
@@ -1369,8 +1372,6 @@ struct dw_cyclic_desc *dw_dma_cyclic_prep(struct dma_chan *chan,
 		goto out_err;
 	if (unlikely(buf_addr & ((1 << reg_width) - 1)))
 		goto out_err;
-	if (unlikely(!(direction & (DMA_MEM_TO_DEV | DMA_DEV_TO_MEM))))
-		goto out_err;
 
 	retval = ERR_PTR(-ENOMEM);
 
-- 
1.7.10.4

