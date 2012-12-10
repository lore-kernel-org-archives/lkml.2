Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2LJKVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:21:39 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54326 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab2LJKVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:35 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 15/23] mfd: omap-usb-host: cleanup clock management code
Date: Mon, 10 Dec 2012 12:20:25 +0200
Message-ID: <1355134833-5199-16-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All ports have similarly named port clocks so we can
bunch them into a port data structure and use for loop
to enable/disable the clocks.

Dynamically allocate and get clocks based on number of ports
available on the platform

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |  159 ++++++++++++++++++++++---------------------
 1 files changed, 80 insertions(+), 79 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 714b2f1..6294f13 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -93,13 +93,10 @@
 
 struct usbhs_hcd_omap {
 	int				nports;
+	struct clk			**utmi_clk;
 
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
-	struct clk			*utmi_p1_fck;
-	struct clk			*usbhost_p1_fck;
-	struct clk			*utmi_p2_fck;
-	struct clk			*usbhost_p2_fck;
 	struct clk			*init_60m_fclk;
 	struct clk			*ehci_logic_fck;
 
@@ -283,6 +280,7 @@ static int usbhs_runtime_resume(struct device *dev)
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	unsigned long			flags;
 	struct usbhs_omap_platform_data *pdata = omap->pdata;
+	int i, r;
 
 	dev_dbg(dev, "usbhs_runtime_resume\n");
 
@@ -292,13 +290,18 @@ static int usbhs_runtime_resume(struct device *dev)
 	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
 		clk_enable(omap->ehci_logic_fck);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_enable(omap->usbhost_p1_fck);
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_enable(omap->usbhost_p2_fck);
-
-	clk_enable(omap->utmi_p1_fck);
-	clk_enable(omap->utmi_p2_fck);
+	for (i = 0; i < omap->nports; i++) {
+		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+			if (omap->utmi_clk[i]) {
+				r = clk_enable(omap->utmi_clk[i]);
+				if (r) {
+					dev_err(dev,
+					 "Can't enable port %d clk : %d\n",
+					 i, r);
+				}
+			}
+		}
+	}
 
 	spin_unlock_irqrestore(&omap->lock, flags);
 
@@ -310,18 +313,18 @@ static int usbhs_runtime_suspend(struct device *dev)
 	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
 	unsigned long			flags;
 	struct usbhs_omap_platform_data *pdata = omap->pdata;
+	int i;
 
 	dev_dbg(dev, "usbhs_runtime_suspend\n");
 
 	spin_lock_irqsave(&omap->lock, flags);
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]))
-		clk_disable(omap->usbhost_p1_fck);
-	if (is_ehci_tll_mode(pdata->port_mode[1]))
-		clk_disable(omap->usbhost_p2_fck);
-
-	clk_disable(omap->utmi_p2_fck);
-	clk_disable(omap->utmi_p1_fck);
+	for (i = 0; i < omap->nports; i++) {
+		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+			if (omap->utmi_clk[i])
+				clk_disable(omap->utmi_clk[i]);
+		}
+	}
 
 	if (omap->ehci_logic_fck && !IS_ERR(omap->ehci_logic_fck))
 		clk_disable(omap->ehci_logic_fck);
@@ -465,6 +468,7 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 	struct resource			*res;
 	int				ret = 0;
 	int				i;
+	bool				need_logic_fck;
 
 	if (!pdata) {
 		dev_err(dev, "Missing platform data\n");
@@ -521,76 +525,79 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-	for (i = 0; i < omap->nports; i++)
+	i = sizeof(struct clk *) * omap->nports;
+	omap->utmi_clk = devm_kzalloc(dev, i, GFP_KERNEL);
+	if (!omap->utmi_clk) {
+		dev_err(dev, "Memory allocation failed\n");
+		ret = -ENOMEM;
+		goto err_mem;
+	}
+
+	need_logic_fck = false;
+	for (i = 0; i < omap->nports; i++) {
 		if (is_ehci_phy_mode(i) || is_ehci_tll_mode(i) ||
-			is_ehci_hsic_mode(i)) {
-			omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
-			if (IS_ERR(omap->ehci_logic_fck)) {
-				ret = PTR_ERR(omap->ehci_logic_fck);
-				dev_warn(dev, "ehci_logic_fck failed:%d\n",
-					 ret);
-			}
-			break;
-		}
+			is_ehci_hsic_mode(i))
+				need_logic_fck |= true;
+	}
 
-	omap->utmi_p1_fck = clk_get(dev, "utmi_p1_gfclk");
-	if (IS_ERR(omap->utmi_p1_fck)) {
-		ret = PTR_ERR(omap->utmi_p1_fck);
-		dev_err(dev, "utmi_p1_gfclk failed error:%d\n",	ret);
-		goto err_end;
+	if (need_logic_fck) {
+		omap->ehci_logic_fck = clk_get(dev, "ehci_logic_fck");
+		if (IS_ERR(omap->ehci_logic_fck)) {
+			ret = PTR_ERR(omap->ehci_logic_fck);
+			dev_dbg(dev, "ehci_logic_fck failed:%d\n", ret);
+		}
 	}
 
 	omap->xclk60mhsp1_ck = clk_get(dev, "xclk60mhsp1_ck");
 	if (IS_ERR(omap->xclk60mhsp1_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp1_ck);
 		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
-		goto err_utmi_p1_fck;
-	}
-
-	omap->utmi_p2_fck = clk_get(dev, "utmi_p2_gfclk");
-	if (IS_ERR(omap->utmi_p2_fck)) {
-		ret = PTR_ERR(omap->utmi_p2_fck);
-		dev_err(dev, "utmi_p2_gfclk failed error:%d\n", ret);
-		goto err_xclk60mhsp1_ck;
+		goto err_xclk60mhsp1;
 	}
 
 	omap->xclk60mhsp2_ck = clk_get(dev, "xclk60mhsp2_ck");
 	if (IS_ERR(omap->xclk60mhsp2_ck)) {
 		ret = PTR_ERR(omap->xclk60mhsp2_ck);
 		dev_err(dev, "xclk60mhsp2_ck failed error:%d\n", ret);
-		goto err_utmi_p2_fck;
-	}
-
-	omap->usbhost_p1_fck = clk_get(dev, "usb_host_hs_utmi_p1_clk");
-	if (IS_ERR(omap->usbhost_p1_fck)) {
-		ret = PTR_ERR(omap->usbhost_p1_fck);
-		dev_err(dev, "usbhost_p1_fck failed error:%d\n", ret);
-		goto err_xclk60mhsp2_ck;
-	}
-
-	omap->usbhost_p2_fck = clk_get(dev, "usb_host_hs_utmi_p2_clk");
-	if (IS_ERR(omap->usbhost_p2_fck)) {
-		ret = PTR_ERR(omap->usbhost_p2_fck);
-		dev_err(dev, "usbhost_p2_fck failed error:%d\n", ret);
-		goto err_usbhost_p1_fck;
+		goto err_xclk60mhsp2;
 	}
 
 	omap->init_60m_fclk = clk_get(dev, "init_60m_fclk");
 	if (IS_ERR(omap->init_60m_fclk)) {
 		ret = PTR_ERR(omap->init_60m_fclk);
 		dev_err(dev, "init_60m_fclk failed error:%d\n", ret);
-		goto err_usbhost_p2_fck;
+		goto err_init60m;
+	}
+
+	for (i = 0; i < omap->nports; i++) {
+		struct clk *pclk;
+		char clkname[] = "usb_host_hs_utmi_px_clk";
+
+		/* clock names are indexed from 1*/
+		snprintf(clkname, sizeof(clkname),
+				"usb_host_hs_utmi_p%d_clk", i + 1);
+
+		/* If a clock is not found we won't bail out as not all
+		 * platforms have all clocks and we can function without
+		 * them
+		 */
+		pclk = clk_get(dev, clkname);
+		if (IS_ERR(pclk))
+			dev_dbg(dev, "Failed to get clock : %s : %ld\n",
+				clkname, PTR_ERR(pclk));
+		else
+			omap->utmi_clk[i] = pclk;
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[0])) {
 		/* for OMAP3 , the clk set paretn fails */
-		ret = clk_set_parent(omap->utmi_p1_fck,
+		ret = clk_set_parent(omap->utmi_clk[0],
 					omap->xclk60mhsp1_ck);
 		if (ret != 0)
 			dev_err(dev, "xclk60mhsp1_ck set parent"
 				"failed error:%d\n", ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[0])) {
-		ret = clk_set_parent(omap->utmi_p1_fck,
+		ret = clk_set_parent(omap->utmi_clk[0],
 					omap->init_60m_fclk);
 		if (ret != 0)
 			dev_err(dev, "init_60m_fclk set parent"
@@ -598,13 +605,13 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 	}
 
 	if (is_ehci_phy_mode(pdata->port_mode[1])) {
-		ret = clk_set_parent(omap->utmi_p2_fck,
+		ret = clk_set_parent(omap->utmi_clk[1],
 					omap->xclk60mhsp2_ck);
 		if (ret != 0)
 			dev_err(dev, "xclk60mhsp2_ck set parent"
 					"failed error:%d\n", ret);
 	} else if (is_ehci_tll_mode(pdata->port_mode[1])) {
-		ret = clk_set_parent(omap->utmi_p2_fck,
+		ret = clk_set_parent(omap->utmi_clk[1],
 						omap->init_60m_fclk);
 		if (ret != 0)
 			dev_err(dev, "init_60m_fclk set parent"
@@ -622,28 +629,21 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
-	clk_put(omap->init_60m_fclk);
 
-err_usbhost_p2_fck:
-	clk_put(omap->usbhost_p2_fck);
+	for (i = 0; i < omap->nports; i++)
+		clk_put(omap->utmi_clk[i]);
 
-err_usbhost_p1_fck:
-	clk_put(omap->usbhost_p1_fck);
+	clk_put(omap->init_60m_fclk);
 
-err_xclk60mhsp2_ck:
+err_init60m:
 	clk_put(omap->xclk60mhsp2_ck);
 
-err_utmi_p2_fck:
-	clk_put(omap->utmi_p2_fck);
-
-err_xclk60mhsp1_ck:
+err_xclk60mhsp2:
 	clk_put(omap->xclk60mhsp1_ck);
 
-err_utmi_p1_fck:
-	clk_put(omap->utmi_p1_fck);
-
-err_end:
+err_xclk60mhsp1:
 	clk_put(omap->ehci_logic_fck);
+err_mem:
 	pm_runtime_disable(dev);
 
 	return ret;
@@ -658,15 +658,16 @@ err_end:
 static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 {
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
+	int i;
 
 	omap_usbhs_deinit(&pdev->dev);
+
+	for (i = 0; i < omap->nports; i++)
+		clk_put(omap->utmi_clk[i]);
+
 	clk_put(omap->init_60m_fclk);
-	clk_put(omap->usbhost_p2_fck);
-	clk_put(omap->usbhost_p1_fck);
 	clk_put(omap->xclk60mhsp2_ck);
-	clk_put(omap->utmi_p2_fck);
 	clk_put(omap->xclk60mhsp1_ck);
-	clk_put(omap->utmi_p1_fck);
 	clk_put(omap->ehci_logic_fck);
 	pm_runtime_disable(&pdev->dev);
 
-- 
1.7.4.1

