Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2DXGJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 02:09:32 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:57693 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753265Ab2DXGJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 02:09:15 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, <spear-devel@list.st.com>,
        <viresh.linux@gmail.com>, Viresh Kumar <viresh.kumar@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bhupesh Sharma <bhupesh.sharma@st.com>
Subject: [PATCH V2 5/9] net/c_can: Remove conditional compilation of clk code
Date: Tue, 24 Apr 2012 11:26:13 +0530
Message-ID: <5be32f42382d05c442ea787473806ab85d598874.1335246730.git.viresh.kumar@st.com>
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
Cc: David S. Miller <davem@davemloft.net>
Cc: Bhupesh Sharma <bhupesh.sharma@st.com>
---
 drivers/net/can/c_can/c_can_platform.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 5e1a5ff..d28904d 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -73,17 +73,12 @@ static int __devinit c_can_plat_probe(struct platform_device *pdev)
 	struct c_can_priv *priv;
 	struct resource *mem;
 	int irq;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *clk;
 
 	/* get the appropriate clk */
 	clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
+	if (IS_ERR(clk))
 		dev_err(&pdev->dev, "no clock defined\n");
-		ret = -ENODEV;
-		goto exit;
-	}
-#endif
 
 	/* get the platform data */
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -118,10 +113,11 @@ static int __devinit c_can_plat_probe(struct platform_device *pdev)
 
 	dev->irq = irq;
 	priv->regs = addr;
-#ifdef CONFIG_HAVE_CLK
-	priv->can.clock.freq = clk_get_rate(clk);
-	priv->priv = clk;
-#endif
+
+	if (!IS_ERR(clk)) {
+		priv->can.clock.freq = clk_get_rate(clk);
+		priv->priv = clk;
+	}
 
 	switch (mem->flags & IORESOURCE_MEM_TYPE_MASK) {
 	case IORESOURCE_MEM_32BIT:
@@ -157,10 +153,9 @@ exit_iounmap:
 exit_release_mem:
 	release_mem_region(mem->start, resource_size(mem));
 exit_free_clk:
-#ifdef CONFIG_HAVE_CLK
-	clk_put(clk);
-exit:
-#endif
+	if (!IS_ERR(clk))
+		clk_put(clk);
+
 	dev_err(&pdev->dev, "probe failed\n");
 
 	return ret;
@@ -181,9 +176,8 @@ static int __devexit c_can_plat_remove(struct platform_device *pdev)
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(mem->start, resource_size(mem));
 
-#ifdef CONFIG_HAVE_CLK
-	clk_put(priv->priv);
-#endif
+	if (!IS_ERR(priv->priv))
+		clk_put(priv->priv);
 
 	return 0;
 }
-- 
1.7.9

