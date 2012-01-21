Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2AVACl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 19:02:41 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:37111 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2AVACP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 19:02:15 -0500
MBOX-Line: From nobody Sat Jan 21 16:59:36 2012
Subject: [PATCH 8/8] W1: OMAP HDQ1W: use runtime PM
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
From: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>, Evgeniy Polyakov <zbr@ioremap.net>
Date: Sat, 21 Jan 2012 16:59:36 -0700
Message-ID: <20120121235935.17619.42743.stgit@dusk>
In-Reply-To: <20120121235333.17619.56725.stgit@dusk>
References: <20120121235333.17619.56725.stgit@dusk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the OMAP HDQ driver to use runtime PM.  Compile- and boot-tested,
but not tested in actual use.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/w1/masters/omap_hdq.c |   78 +++++++----------------------------------
 1 files changed, 13 insertions(+), 65 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 5ef385b..63e3eda 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -1,7 +1,7 @@
 /*
  * drivers/w1/masters/omap_hdq.c
  *
- * Copyright (C) 2007 Texas Instruments, Inc.
+ * Copyright (C) 2007,2012 Texas Instruments, Inc.
  *
  * This file is licensed under the terms of the GNU General Public License
  * version 2. This program is licensed "as is" without any warranty of any
@@ -14,9 +14,9 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/err.h>
-#include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/sched.h>
+#include <linux/pm_runtime.h>
 
 #include <asm/irq.h>
 #include <mach/hardware.h>
@@ -61,8 +61,6 @@ struct hdq_data {
 	/* lock status update */
 	struct  mutex		hdq_mutex;
 	int			hdq_usecount;
-	struct	clk		*hdq_ick;
-	struct	clk		*hdq_fck;
 	u8			hdq_irqstatus;
 	/* device lock */
 	spinlock_t		hdq_spinlock;
@@ -419,17 +417,8 @@ static int omap_hdq_get(struct hdq_data *hdq_data)
 		hdq_data->hdq_usecount++;
 		try_module_get(THIS_MODULE);
 		if (1 == hdq_data->hdq_usecount) {
-			if (clk_enable(hdq_data->hdq_ick)) {
-				dev_dbg(hdq_data->dev, "Can not enable ick\n");
-				ret = -ENODEV;
-				goto clk_err;
-			}
-			if (clk_enable(hdq_data->hdq_fck)) {
-				dev_dbg(hdq_data->dev, "Can not enable fck\n");
-				clk_disable(hdq_data->hdq_ick);
-				ret = -ENODEV;
-				goto clk_err;
-			}
+
+			pm_runtime_get_sync(hdq_data->dev);
 
 			/* make sure HDQ is out of reset */
 			if (!(hdq_reg_in(hdq_data, OMAP_HDQ_SYSSTATUS) &
@@ -450,9 +439,6 @@ static int omap_hdq_get(struct hdq_data *hdq_data)
 		}
 	}
 
-clk_err:
-	clk_put(hdq_data->hdq_ick);
-	clk_put(hdq_data->hdq_fck);
 out:
 	mutex_unlock(&hdq_data->hdq_mutex);
 rtn:
@@ -475,10 +461,8 @@ static int omap_hdq_put(struct hdq_data *hdq_data)
 	} else {
 		hdq_data->hdq_usecount--;
 		module_put(THIS_MODULE);
-		if (0 == hdq_data->hdq_usecount) {
-			clk_disable(hdq_data->hdq_ick);
-			clk_disable(hdq_data->hdq_fck);
-		}
+		if (0 == hdq_data->hdq_usecount)
+			pm_runtime_put_sync(hdq_data->dev);
 	}
 	mutex_unlock(&hdq_data->hdq_mutex);
 
@@ -591,35 +575,11 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 		goto err_ioremap;
 	}
 
-	/* get interface & functional clock objects */
-	hdq_data->hdq_ick = clk_get(&pdev->dev, "ick");
-	if (IS_ERR(hdq_data->hdq_ick)) {
-		dev_dbg(&pdev->dev, "Can't get HDQ ick clock object\n");
-		ret = PTR_ERR(hdq_data->hdq_ick);
-		goto err_ick;
-	}
-
-	hdq_data->hdq_fck = clk_get(&pdev->dev, "fck");
-	if (IS_ERR(hdq_data->hdq_fck)) {
-		dev_dbg(&pdev->dev, "Can't get HDQ fck clock object\n");
-		ret = PTR_ERR(hdq_data->hdq_fck);
-		goto err_fck;
-	}
-
 	hdq_data->hdq_usecount = 0;
 	mutex_init(&hdq_data->hdq_mutex);
 
-	if (clk_enable(hdq_data->hdq_ick)) {
-		dev_dbg(&pdev->dev, "Can not enable ick\n");
-		ret = -ENODEV;
-		goto err_intfclk;
-	}
-
-	if (clk_enable(hdq_data->hdq_fck)) {
-		dev_dbg(&pdev->dev, "Can not enable fck\n");
-		ret = -ENODEV;
-		goto err_fnclk;
-	}
+	pm_runtime_enable(&pdev->dev);
+	pm_runtime_get_sync(&pdev->dev);
 
 	rev = hdq_reg_in(hdq_data, OMAP_HDQ_REVISION);
 	dev_info(&pdev->dev, "OMAP HDQ Hardware Rev %c.%c. Driver in %s mode\n",
@@ -641,9 +601,7 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 
 	omap_hdq_break(hdq_data);
 
-	/* don't clock the HDQ until it is needed */
-	clk_disable(hdq_data->hdq_ick);
-	clk_disable(hdq_data->hdq_fck);
+	pm_runtime_put_sync(&pdev->dev);
 
 	omap_w1_master.data = hdq_data;
 
@@ -655,20 +613,11 @@ static int __devinit omap_hdq_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_w1:
 err_irq:
-	clk_disable(hdq_data->hdq_fck);
-
-err_fnclk:
-	clk_disable(hdq_data->hdq_ick);
-
-err_intfclk:
-	clk_put(hdq_data->hdq_fck);
-
-err_fck:
-	clk_put(hdq_data->hdq_ick);
+	pm_runtime_put_sync(&pdev->dev);
+err_w1:
+	pm_runtime_disable(&pdev->dev);
 
-err_ick:
 	iounmap(hdq_data->hdq_base);
 
 err_ioremap:
@@ -696,8 +645,7 @@ static int omap_hdq_remove(struct platform_device *pdev)
 	mutex_unlock(&hdq_data->hdq_mutex);
 
 	/* remove module dependency */
-	clk_put(hdq_data->hdq_ick);
-	clk_put(hdq_data->hdq_fck);
+	pm_runtime_disable(&pdev->dev);
 	free_irq(INT_24XX_HDQ_IRQ, hdq_data);
 	platform_set_drvdata(pdev, NULL);
 	iounmap(hdq_data->hdq_base);


