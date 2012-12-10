Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2LJK1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:27:13 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59182 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2LJKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:16 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 09/23] mfd: omap-usb-tll: serialize access to TLL device
Date: Mon, 10 Dec 2012 12:20:19 +0200
Message-ID: <1355134833-5199-10-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the unnecessary spin_lock_irqsave/restore() as there is
no interrupt handler for this driver. Instead we serialize access
to tll_dev using a global spinlock.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   53 ++++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 38d0532..7b4afd0 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -103,14 +103,13 @@ struct usbtll_omap {
 	int					nch;	/* num. of channels */
 	struct usbtll_omap_platform_data	*pdata;
 	struct clk				**ch_clk;
-	/* secure the register updates */
-	spinlock_t				lock;
 };
 
 /*-------------------------------------------------------------------------*/
 
 static const char usbtll_driver_name[] = USBTLL_DRIVER_NAME;
 static struct device	*tll_dev;
+static DEFINE_SPINLOCK(tll_lock);	/* serialize access to tll_dev */
 
 /*-------------------------------------------------------------------------*/
 
@@ -212,7 +211,6 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 	struct resource				*res;
 	struct usbtll_omap			*tll;
 	unsigned				reg;
-	unsigned long				flags;
 	int					ret = 0;
 	int					i, ver;
 	bool needs_tll;
@@ -230,8 +228,6 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	spin_lock_init(&tll->lock);
-
 	tll->pdata = pdata;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -243,8 +239,6 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	ver =  usbtll_read(base, OMAP_USBTLL_REVISION);
 	switch (ver) {
 	case OMAP_USBTLL_REV1:
@@ -262,8 +256,6 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 		break;
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	tll->ch_clk = devm_kzalloc(dev, sizeof(struct clk * [tll->nch]),
 						GFP_KERNEL);
 	if (!tll->ch_clk) {
@@ -272,8 +264,6 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 		goto err_clk_alloc;
 	}
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	for (i = 0; i < tll->nch; i++) {
 		char clkname[] = "usb_tll_hs_usb_chx_clk";
 		struct clk *fck;
@@ -332,10 +322,11 @@ static int __devinit usbtll_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
 	pm_runtime_put_sync(dev);
 	/* only after this can omap_tll_enable/disable work */
+	spin_lock(&tll_lock);
 	tll_dev = dev;
+	spin_unlock(&tll_lock);
 
 	return 0;
 
@@ -357,7 +348,9 @@ static int __devexit usbtll_omap_remove(struct platform_device *pdev)
 	struct usbtll_omap *tll = platform_get_drvdata(pdev);
 	int i;
 
+	spin_lock(&tll_lock);
 	tll_dev = NULL;
+	spin_unlock(&tll_lock);
 
 	for (i = 0; i < tll->nch; i++)
 		clk_put(tll->ch_clk[i]);
@@ -370,13 +363,10 @@ static int usbtll_runtime_resume(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbtll_omap_platform_data	*pdata = tll->pdata;
-	unsigned long				flags;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_resume\n");
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			int r;
@@ -392,8 +382,6 @@ static int usbtll_runtime_resume(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	return 0;
 }
 
@@ -401,13 +389,10 @@ static int usbtll_runtime_suspend(struct device *dev)
 {
 	struct usbtll_omap			*tll = dev_get_drvdata(dev);
 	struct usbtll_omap_platform_data	*pdata = tll->pdata;
-	unsigned long				flags;
 	int i;
 
 	dev_dbg(dev, "usbtll_runtime_suspend\n");
 
-	spin_lock_irqsave(&tll->lock, flags);
-
 	for (i = 0; i < tll->nch; i++) {
 		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			if (tll->ch_clk[i])
@@ -415,8 +400,6 @@ static int usbtll_runtime_suspend(struct device *dev)
 		}
 	}
 
-	spin_unlock_irqrestore(&tll->lock, flags);
-
 	return 0;
 }
 
@@ -438,21 +421,39 @@ static struct platform_driver usbtll_omap_driver = {
 
 int omap_tll_enable(void)
 {
+	int ret;
+
+	spin_lock(&tll_lock);
+
 	if (!tll_dev) {
 		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
-		return  -ENODEV;
+		ret = -ENODEV;
+	} else {
+		ret = pm_runtime_get_sync(tll_dev);
 	}
-	return pm_runtime_get_sync(tll_dev);
+
+	spin_unlock(&tll_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(omap_tll_enable);
 
 int omap_tll_disable(void)
 {
+	int ret;
+
+	spin_lock(&tll_lock);
+
 	if (!tll_dev) {
 		pr_err("%s: OMAP USB TLL not initialized\n", __func__);
-		return  -ENODEV;
+		ret = -ENODEV;
+	} else {
+		ret = pm_runtime_put_sync(tll_dev);
 	}
-	return pm_runtime_put_sync(tll_dev);
+
+	spin_unlock(&tll_lock);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(omap_tll_disable);
 
-- 
1.7.4.1

