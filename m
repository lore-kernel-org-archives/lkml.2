Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2DQKH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:07:28 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:43911 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab2DQKH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:07:26 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <vinod.koul@intel.com>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@st.com>
Subject: [PATCH] dmaengine: dw_dmac: Add clk_{un}prepare() support
Date: Tue, 17 Apr 2012 15:22:10 +0530
Message-ID: <8404741a5c01dffed43f1344fcaf6ea513a47cc2.1334656295.git.viresh.kumar@st.com>
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
 drivers/dma/dw_dmac.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index 7439079..06d5bff 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1429,7 +1429,9 @@ static int __init dw_probe(struct platform_device *pdev)
 		err = PTR_ERR(dw->clk);
 		goto err_clk;
 	}
-	clk_enable(dw->clk);
+
+	if (!clk_prepare(dw->clk))
+		clk_enable(dw->clk);
 
 	/* force dma off, just in case */
 	dw_dma_off(dw);
@@ -1511,6 +1513,7 @@ static int __init dw_probe(struct platform_device *pdev)
 
 err_irq:
 	clk_disable(dw->clk);
+	clk_unprepare(dw->clk);
 	clk_put(dw->clk);
 err_clk:
 	iounmap(dw->regs);
@@ -1541,6 +1544,7 @@ static int __exit dw_remove(struct platform_device *pdev)
 	}
 
 	clk_disable(dw->clk);
+	clk_unprepare(dw->clk);
 	clk_put(dw->clk);
 
 	iounmap(dw->regs);
@@ -1560,6 +1564,7 @@ static void dw_shutdown(struct platform_device *pdev)
 
 	dw_dma_off(platform_get_drvdata(pdev));
 	clk_disable(dw->clk);
+	clk_unprepare(dw->clk);
 }
 
 static int dw_suspend_noirq(struct device *dev)
@@ -1569,6 +1574,7 @@ static int dw_suspend_noirq(struct device *dev)
 
 	dw_dma_off(platform_get_drvdata(pdev));
 	clk_disable(dw->clk);
+	clk_unprepare(dw->clk);
 
 	return 0;
 }
@@ -1578,7 +1584,9 @@ static int dw_resume_noirq(struct device *dev)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct dw_dma	*dw = platform_get_drvdata(pdev);
 
-	clk_enable(dw->clk);
+	if (!clk_prepare(dw->clk))
+		clk_enable(dw->clk);
+
 	dma_writel(dw, CFG, DW_CFG_DMA_EN);
 	return 0;
 }
-- 
1.7.9

