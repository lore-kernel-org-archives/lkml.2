Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2DQLyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:54:37 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:36012 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab2DQLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:54:23 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH V2] dmaengine: dw_dmac: Add clk_{un}prepare() support
Date: Tue, 17 Apr 2012 17:10:07 +0530
Message-ID: <85bdff0af2dd4e4a116f638fe29b19956a16604d.1334662785.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_{un}prepare is mandatory for platforms using common clock framework. Since
this driver is used by SPEAr platform, which supports common clock framework,
add clk_{un}prepare() support for it.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
V1->V2:
- Use clk_prepare_enable and clk_disable_unprepare

 drivers/dma/dw_dmac.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7439079..300d976 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1429,7 +1429,7 @@ static int __init dw_probe(struct platform_device *pdev)
 		err = PTR_ERR(dw->clk);
 		goto err_clk;
 	}
-	clk_enable(dw->clk);
+	clk_prepare_enable(dw->clk);
 
 	/* force dma off, just in case */
 	dw_dma_off(dw);
@@ -1510,7 +1510,7 @@ static int __init dw_probe(struct platform_device *pdev)
 	return 0;
 
 err_irq:
-	clk_disable(dw->clk);
+	clk_disable_unprepare(dw->clk);
 	clk_put(dw->clk);
 err_clk:
 	iounmap(dw->regs);
@@ -1540,7 +1540,7 @@ static int __exit dw_remove(struct platform_device *pdev)
 		channel_clear_bit(dw, CH_EN, dwc->mask);
 	}
 
-	clk_disable(dw->clk);
+	clk_disable_unprepare(dw->clk);
 	clk_put(dw->clk);
 
 	iounmap(dw->regs);
@@ -1559,7 +1559,7 @@ static void dw_shutdown(struct platform_device *pdev)
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
 	dw_dma_off(platform_get_drvdata(pdev));
-	clk_disable(dw->clk);
+	clk_disable_unprepare(dw->clk);
 }
 
 static int dw_suspend_noirq(struct device *dev)
@@ -1568,7 +1568,7 @@ static int dw_suspend_noirq(struct device *dev)
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
 	dw_dma_off(platform_get_drvdata(pdev));
-	clk_disable(dw->clk);
+	clk_disable_unprepare(dw->clk);
 
 	return 0;
 }
@@ -1578,7 +1578,7 @@ static int dw_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
-	clk_enable(dw->clk);
+	clk_prepare_enable(dw->clk);
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 	return 0;
 }
-- 
1.7.9

