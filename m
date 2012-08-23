Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab2HWLmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 07:42:31 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:35802 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756333Ab2HWLm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 07:42:28 -0400
From: Ulf Hansson <ulf.hansson@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH] dma/ste_dma40: Fixup clock usage during probe
Date: Thu, 23 Aug 2012 13:41:58 +0200
Message-ID: <1345722118-5783-1-git-send-email-ulf.hansson@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Fixup some errorhandling for clocks during probe and make sure
to use clk_prepare as well as clk_enable.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/ste_dma40.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..826d0d5 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2920,19 +2920,23 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	struct d40_base *base = NULL;
 	int num_log_chans = 0;
 	int num_phy_chans;
+	int clk_ret = -EINVAL;
 	int i;
 	u32 pid;
 	u32 cid;
 	u8 rev;
 
 	clk = clk_get(&pdev->dev, NULL);
-
 	if (IS_ERR(clk)) {
 		d40_err(&pdev->dev, "No matching clock found\n");
 		goto failure;
 	}
 
-	clk_enable(clk);
+	clk_ret = clk_prepare_enable(clk);
+	if (clk_ret) {
+		d40_err(&pdev->dev, "Failed to prepare/enable clock\n");
+		goto failure;
+	}
 
 	/* Get IO for DMAC base address */
 	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "base");
@@ -3062,10 +3066,10 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	return base;
 
 failure:
-	if (!IS_ERR(clk)) {
-		clk_disable(clk);
+	if (!clk_ret)
+		clk_disable_unprepare(clk);
+	if (!IS_ERR(clk))
 		clk_put(clk);
-	}
 	if (virtbase)
 		iounmap(virtbase);
 	if (res)
-- 
1.7.10

