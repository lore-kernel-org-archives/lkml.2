Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab2DXGLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:11:22 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:52440 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab2DXGJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:09:07 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, <spear-devel@list.st.com>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        <linux-ide@vger.kernel.org>
Subject: [PATCH V2 4/9] ata/sata_mv: Remove conditional compilation of clk code
Date: Tue, 24 Apr 2012 11:26:12 +0530
Message-ID: <5c57f2a0eb759c864a88bb5cd2e98e397f05ca61.1335246730.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335246730.git.viresh.kumar@st.com>
References: <cover.1335246730.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/sata_mv.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 7336d4a..37503b8 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -551,9 +551,7 @@ struct mv_host_priv {
 	u32			irq_mask_offset;
 	u32			unmask_all_irqs;
 
-#if defined(CONFIG_HAVE_CLK)
 	struct clk		*clk;
-#endif
 	/*
 	 * These consistent DMA memory pools give us guaranteed
 	 * alignment for hardware-accessed data structures,
@@ -4063,13 +4061,11 @@ static int mv_platform_probe(struct platform_device *pdev)
 				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
-#if defined(CONFIG_HAVE_CLK)
 	hpriv->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(hpriv->clk))
 		dev_notice(&pdev->dev, "cannot get clkdev\n");
 	else
 		clk_enable(hpriv->clk);
-#endif
 
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
@@ -4096,12 +4092,10 @@ static int mv_platform_probe(struct platform_device *pdev)
 		return 0;
 
 err:
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable(hpriv->clk);
 		clk_put(hpriv->clk);
 	}
-#endif
 
 	return rc;
 }
@@ -4117,17 +4111,13 @@ err:
 static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
-#if defined(CONFIG_HAVE_CLK)
 	struct mv_host_priv *hpriv = host->private_data;
-#endif
 	ata_host_detach(host);
 
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable(hpriv->clk);
 		clk_put(hpriv->clk);
 	}
-#endif
 	return 0;
 }
 
-- 
1.7.9

