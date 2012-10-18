Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab2JRO1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:27:46 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42204 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab2JRO1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:27:43 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        kernel@pengutronix.de, devicetree-discuss@lists.ozlabs.org
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 3/4] misc: sram: Add optional clock
Date: Thu, 18 Oct 2012 16:27:32 +0200
Message-Id: <1350570453-24546-4-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
References: <1350570453-24546-1-git-send-email-p.zabel@pengutronix.de>
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some platforms the SRAM needs a clock to be enabled explicitly.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/misc/sram.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/misc/sram.c b/drivers/misc/sram.c
index 7a363f2..0cc2e75 100644
--- a/drivers/misc/sram.c
+++ b/drivers/misc/sram.c
@@ -21,6 +21,8 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -29,6 +31,7 @@
 
 struct sram_dev {
 	struct gen_pool *pool;
+	struct clk *clk;
 };
 
 static int __devinit sram_probe(struct platform_device *pdev)
@@ -53,6 +56,10 @@ static int __devinit sram_probe(struct platform_device *pdev)
 	if (!sram)
 		return -ENOMEM;
 
+	sram->clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(sram->clk))
+		clk_prepare_enable(sram->clk);
+
 	sram->pool = gen_pool_create(PAGE_SHIFT, -1);
 	if (!sram->pool)
 		return -ENOMEM;
@@ -80,6 +87,9 @@ static int __devexit sram_remove(struct platform_device *pdev)
 
 	gen_pool_destroy(sram->pool);
 
+	if (!IS_ERR(sram->clk))
+		clk_disable_unprepare(sram->clk);
+
 	return 0;
 }
 
-- 
1.7.10.4

