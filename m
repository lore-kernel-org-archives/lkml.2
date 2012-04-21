Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab2DULuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:50:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43826 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab2DULuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:50:08 -0400
From: Viresh Kumar <viresh.linux@gmail.com>
To: akpm@linux-foundation.org
Cc: spear-devel@list.st.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, sshtylyov@mvista.com, jgarzik@redhat.com,
        Viresh Kumar <viresh.kumar@st.com>, linux-ide@vger.kernel.org
Subject: [PATCH 04/13] ata/pata_arasan: Remove conditional compilation of clk code
Date: Sat, 21 Apr 2012 17:17:31 +0530
Message-Id: <b65ce56f5c346b5f8230636a0c5da72662631bcd.1335008617.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
In-Reply-To: <cover.1335008617.git.viresh.kumar@st.com>
References: <cover.1335008617.git.viresh.kumar@st.com>
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
 drivers/ata/pata_arasan_cf.c |   39 ++++++++++++++++-----------------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index fc2db2a..b370e35 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -184,10 +184,8 @@
 struct arasan_cf_dev {
 	/* pointer to ata_host structure */
 	struct ata_host *host;
-	/* clk structure, only if HAVE_CLK is defined */
-#ifdef CONFIG_HAVE_CLK
+	/* clk structure */
 	struct clk *clk;
-#endif
 
 	/* physical base address of controller */
 	dma_addr_t pbase;
@@ -312,13 +310,13 @@ static int cf_init(struct arasan_cf_dev *acdev)
 	unsigned long flags;
 	int ret = 0;
 
-#ifdef CONFIG_HAVE_CLK
-	ret = clk_enable(acdev->clk);
-	if (ret) {
-		dev_dbg(acdev->host->dev, "clock enable failed");
-		return ret;
+	if (!IS_ERR(acdev->clk)) {
+		ret = clk_enable(acdev->clk);
+		if (ret) {
+			dev_dbg(acdev->host->dev, "clock enable failed");
+			return ret;
+		}
 	}
-#endif
 
 	spin_lock_irqsave(&acdev->host->lock, flags);
 	/* configure CF interface clock */
@@ -344,9 +342,9 @@ static void cf_exit(struct arasan_cf_dev *acdev)
 	writel(readl(acdev->vbase + OP_MODE) & ~CFHOST_ENB,
 			acdev->vbase + OP_MODE);
 	spin_unlock_irqrestore(&acdev->host->lock, flags);
-#ifdef CONFIG_HAVE_CLK
-	clk_disable(acdev->clk);
-#endif
+
+	if (!IS_ERR(acdev->clk))
+		clk_disable(acdev->clk);
 }
 
 static void dma_callback(void *dev)
@@ -828,13 +826,9 @@ static int __devinit arasan_cf_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-#ifdef CONFIG_HAVE_CLK
 	acdev->clk = clk_get(&pdev->dev, NULL);
-	if (IS_ERR(acdev->clk)) {
+	if (IS_ERR(acdev->clk))
 		dev_warn(&pdev->dev, "Clock not found\n");
-		return PTR_ERR(acdev->clk);
-	}
-#endif
 
 	/* allocate host */
 	host = ata_host_alloc(&pdev->dev, 1);
@@ -899,9 +893,8 @@ static int __devinit arasan_cf_probe(struct platform_device *pdev)
 			&arasan_cf_sht);
 
 free_clk:
-#ifdef CONFIG_HAVE_CLK
-	clk_put(acdev->clk);
-#endif
+	if (!IS_ERR(acdev->clk))
+		clk_put(acdev->clk);
 	return ret;
 }
 
@@ -912,9 +905,9 @@ static int __devexit arasan_cf_remove(struct platform_device *pdev)
 
 	ata_host_detach(host);
 	cf_exit(acdev);
-#ifdef CONFIG_HAVE_CLK
-	clk_put(acdev->clk);
-#endif
+
+	if (!IS_ERR(acdev->clk))
+		clk_put(acdev->clk);
 
 	return 0;
 }
-- 
1.7.9

