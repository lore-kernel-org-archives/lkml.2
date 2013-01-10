Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3AJQya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:54:30 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:50925 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755213Ab3AJQwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:03 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 03/14] usb: xceiv: nop: Manage PHY clock
Date: Thu, 10 Jan 2013 18:51:23 +0200
Message-ID: <1357836694-30788-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the PHY has a clock associated to it then manage the clock.
We just enable the clock in .init() and disable it in .shutdown().

Add clk_rate parameter in platform data and configure the
clock rate during probe if supplied.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/otg/nop-usb-xceiv.c   |   49 +++++++++++++++++++++++++++++++++++++
 include/linux/usb/nop-usb-xceiv.h |    1 +
 2 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index a3ce24b..163f972 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -32,10 +32,12 @@
 #include <linux/usb/otg.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/slab.h>
+#include <linux/clk.h>
 
 struct nop_usb_xceiv {
 	struct usb_phy		phy;
 	struct device		*dev;
+	struct clk		*clk;
 };
 
 static struct platform_device *pd;
@@ -64,6 +66,24 @@ static int nop_set_suspend(struct usb_phy *x, int suspend)
 	return 0;
 }
 
+static int nop_init(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+
+	if (nop->clk)
+		clk_enable(nop->clk);
+
+	return 0;
+}
+
+static void nop_shutdown(struct usb_phy *phy)
+{
+	struct nop_usb_xceiv *nop = dev_get_drvdata(phy->dev);
+
+	if (nop->clk)
+		clk_disable(nop->clk);
+}
+
 static int nop_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
 	if (!otg)
@@ -113,10 +133,36 @@ static int nop_usb_xceiv_probe(struct platform_device *pdev)
 	if (pdata)
 		type = pdata->type;
 
+	nop->clk = devm_clk_get(&pdev->dev, "main_clk");
+	if (IS_ERR(nop->clk)) {
+		dev_dbg(&pdev->dev, "Can't get phy clock\n");
+		nop->clk = NULL;
+	}
+
+	if (nop->clk && pdata && pdata->clk_rate) {
+		err = clk_set_rate(nop->clk, pdata->clk_rate);
+		if (err) {
+			dev_err(&pdev->dev,
+					"Error setting clock rate\n");
+			goto exit;
+		}
+	}
+
+	if (nop->clk) {
+		err = clk_prepare(nop->clk);
+		if (err) {
+			dev_err(&pdev->dev,
+					"Error preparing clock\n");
+			goto exit;
+		}
+	}
+
 	nop->dev		= &pdev->dev;
 	nop->phy.dev		= nop->dev;
 	nop->phy.label		= "nop-xceiv";
 	nop->phy.set_suspend	= nop_set_suspend;
+	nop->phy.init		= nop_init;
+	nop->phy.shutdown	= nop_shutdown;
 	nop->phy.state		= OTG_STATE_UNDEFINED;
 
 	nop->phy.otg->phy		= &nop->phy;
@@ -145,6 +191,9 @@ static int nop_usb_xceiv_remove(struct platform_device *pdev)
 {
 	struct nop_usb_xceiv *nop = platform_get_drvdata(pdev);
 
+	if (nop->clk)
+		clk_unprepare(nop->clk);
+
 	usb_remove_phy(&nop->phy);
 
 	platform_set_drvdata(pdev, NULL);
diff --git a/include/linux/usb/nop-usb-xceiv.h b/include/linux/usb/nop-usb-xceiv.h
index 28884c7..3265b61 100644
--- a/include/linux/usb/nop-usb-xceiv.h
+++ b/include/linux/usb/nop-usb-xceiv.h
@@ -5,6 +5,7 @@
 
 struct nop_usb_xceiv_platform_data {
 	enum usb_phy_type type;
+	unsigned long clk_rate;
 };
 
 #if defined(CONFIG_NOP_USB_XCEIV) || (defined(CONFIG_NOP_USB_XCEIV_MODULE) && defined(MODULE))
-- 
1.7.4.1

