Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0HaMNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 08:13:48 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:34397 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932223Ab0HaMNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 08:13:12 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <yuanyabin1978@sina.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 01/12] DMAENGINE: remove clock code from PL08X driver
Date: Tue, 31 Aug 2010 14:12:03 +0200
Message-ID: <1283256734-3408-2-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
References: <1283256734-3408-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of the pclk infrastructure the block clock
is handled by the AMBA PrimeCell bus core, and we can remove the
local references to any clocks.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/amba-pl08x.c |   18 ------------------
 1 files changed, 0 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index fc5aaeb..2afb4f6 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -68,7 +68,6 @@
 #include <linux/amba/bus.h>
 #include <linux/dmaengine.h>
 #include <linux/amba/pl08x.h>
-#include <linux/clk.h>
 
 #include <asm/hardware/pl080.h>
 #include <asm/dma.h>
@@ -113,7 +112,6 @@ struct lli {
  * @adev: the corresponding AMBA (PrimeCell) bus entry
  * @vd: vendor data for this PL08x variant
  * @pd: platform data passed in from the platform/machine
- * @clk: a clock to be enabled for this device to run
  * @phy_chans: array of data for the physical channels
  * @pool: a pool for the LLI descriptors
  * @pool_ctr: counter of LLIs in the pool
@@ -124,7 +122,6 @@ struct pl08x_driver_data {
 	struct amba_device *adev;
 	struct vendor_data *vd;
 	struct pl08x_platform_data *pd;
-	struct clk *clk;
 	struct pl08x_phy_chan *phy_chans;
 	struct dma_pool *pool;
 	int pool_ctr;
@@ -1826,19 +1823,6 @@ static int pl08x_probe(struct amba_device *adev, struct amba_id *id)
 	pl08x->adev = adev;
 	pl08x->vd = vd;
 
-	pl08x->clk = clk_get(&adev->dev, NULL);
-	if (IS_ERR(pl08x->clk)) {
-		ret = PTR_ERR(pl08x->clk);
-		if (ret == -ENOENT) {
-			dev_info(&adev->dev, "no clock supplied, assume always on\n");
-			pl08x->clk = NULL;
-		} else
-			goto out_no_clk;
-	}
-	/* Constantly enabled for now, we can control this dynamically */
-	if (pl08x->clk)
-		clk_enable(pl08x->clk);
-
 	/* A DMA memory pool for LLIs, align on 1-byte boundary */
 	pl08x->pool = dma_pool_create(DRIVER_NAME, &pl08x->adev->dev,
 			PL08X_LLI_TSFR_SIZE, PL08X_ALIGN, 0);
@@ -1963,8 +1947,6 @@ out_no_irq:
 out_no_ioremap:
 	dma_pool_destroy(pl08x->pool);
 out_no_lli_pool:
-	clk_put(pl08x->clk);
-out_no_clk:
 	kfree(pl08x);
 out_no_pl08x:
 	amba_release_regions(adev);
-- 
1.6.3.3

