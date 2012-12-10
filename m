Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2LJKV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:21:29 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35376 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966Ab2LJKV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:21:26 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <paul@pwsan.com>, <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>,
        <bjorn@mork.no>, <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 12/23] mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
Date: Mon, 10 Dec 2012 12:20:22 +0200
Message-ID: <1355134833-5199-13-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355134833-5199-1-git-send-email-rogerq@ti.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ variants of kzalloc and ioremap. Also clean up error path.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-host.c |   36 +++++++++---------------------------
 1 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 8b8f1da..13a3e8c 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -468,17 +468,20 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 
 	if (!pdata) {
 		dev_err(dev, "Missing platform data\n");
-		ret = -ENOMEM;
-		goto end_probe;
+		return -ENODEV;
 	}
 
-	omap = kzalloc(sizeof(*omap), GFP_KERNEL);
+	omap = devm_kzalloc(dev, sizeof(*omap), GFP_KERNEL);
 	if (!omap) {
 		dev_err(dev, "Memory allocation failed\n");
-		ret = -ENOMEM;
-		goto end_probe;
+		return -ENOMEM;
 	}
 
+	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
+	omap->uhh_base = devm_request_and_ioremap(dev, res);
+	if (!omap->uhh_base)
+		return -EADDRNOTAVAIL;
+
 	spin_lock_init(&omap->lock);
 
 	omap->pdata = pdata;
@@ -576,20 +579,6 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 				"failed error:%d\n", ret);
 	}
 
-	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "uhh");
-	if (!res) {
-		dev_err(dev, "UHH EHCI get resource failed\n");
-		ret = -ENODEV;
-		goto err_init_60m_fclk;
-	}
-
-	omap->uhh_base = ioremap(res->start, resource_size(res));
-	if (!omap->uhh_base) {
-		dev_err(dev, "UHH ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_init_60m_fclk;
-	}
-
 	platform_set_drvdata(pdev, omap);
 
 	omap_usbhs_init(dev);
@@ -599,13 +588,10 @@ static int __devinit usbhs_omap_probe(struct platform_device *pdev)
 		goto err_alloc;
 	}
 
-	goto end_probe;
+	return 0;
 
 err_alloc:
 	omap_usbhs_deinit(&pdev->dev);
-	iounmap(omap->uhh_base);
-
-err_init_60m_fclk:
 	clk_put(omap->init_60m_fclk);
 
 err_usbhost_p2_fck:
@@ -629,9 +615,7 @@ err_utmi_p1_fck:
 err_end:
 	clk_put(omap->ehci_logic_fck);
 	pm_runtime_disable(dev);
-	kfree(omap);
 
-end_probe:
 	return ret;
 }
 
@@ -646,7 +630,6 @@ static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 	struct usbhs_hcd_omap *omap = platform_get_drvdata(pdev);
 
 	omap_usbhs_deinit(&pdev->dev);
-	iounmap(omap->uhh_base);
 	clk_put(omap->init_60m_fclk);
 	clk_put(omap->usbhost_p2_fck);
 	clk_put(omap->usbhost_p1_fck);
@@ -656,7 +639,6 @@ static int __devexit usbhs_omap_remove(struct platform_device *pdev)
 	clk_put(omap->utmi_p1_fck);
 	clk_put(omap->ehci_logic_fck);
 	pm_runtime_disable(&pdev->dev);
-	kfree(omap);
 
 	return 0;
 }
-- 
1.7.4.1

