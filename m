Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1EPJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:09:13 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57609 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285Ab1EPJJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:09:05 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [RESEND][PATCH 3/5] arm: omap: usb: device name change for the clk names of usbhs
Date: Mon, 16 May 2011 14:34:57 +0530
Message-ID: <1305536697-20147-6-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1305536697-20147-5-git-send-email-keshava_mgowda@ti.com>
References: <1305536697-20147-1-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-2-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-3-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-4-git-send-email-keshava_mgowda@ti.com>
 <1305536697-20147-5-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The global suspend and resume functions for usbhs core driver
are implemented.These routine are called when the global suspend
and resume occurs. Before calling these functions, the
bus suspend and resume of ehci and ohci drivers are called
from runtime pm.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |  103 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index bd63429..e1bc3b5 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -146,6 +146,10 @@
 #define is_ehci_hsic_mode(x)	(x == OMAP_EHCI_PORT_MODE_HSIC)
 
 
+/* USBHS state bits */
+#define OMAP_USBHS_INIT		0
+#define OMAP_USBHS_SUSPEND	4
+
 struct usbhs_hcd_omap {
 	struct clk			*xclk60mhsp1_ck;
 	struct clk			*xclk60mhsp2_ck;
@@ -165,6 +169,7 @@ struct usbhs_hcd_omap {
 	u32				usbhs_rev;
 	spinlock_t			lock;
 	int				count;
+	unsigned long			state;
 };
 /*-------------------------------------------------------------------------*/
 
@@ -807,6 +812,8 @@ static int usbhs_enable(struct device *dev)
 				(pdata->ehci_data->reset_gpio_port[1], 1);
 	}
 
+	set_bit(OMAP_USBHS_INIT, &omap->state);
+
 end_count:
 	omap->count++;
 	spin_unlock_irqrestore(&omap->lock, flags);
@@ -895,6 +902,7 @@ static void usbhs_disable(struct device *dev)
 	}
 
 	pm_runtime_put_sync(dev);
+	clear_bit(OMAP_USBHS_INIT, &omap->state);
 
 	/* The gpio_free migh sleep; so unlock the spinlock */
 	spin_unlock_irqrestore(&omap->lock, flags);
@@ -924,10 +932,105 @@ void omap_usbhs_disable(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(omap_usbhs_disable);
 
+#ifdef	CONFIG_PM
+
+static int usbhs_resume(struct device *dev)
+{
+	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
+	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	unsigned long			flags = 0;
+
+	dev_dbg(dev, "Resuming TI HSUSB Controller\n");
+
+	if (!pdata) {
+		dev_dbg(dev, "missing platform_data\n");
+		return  -ENODEV;
+	}
+
+	spin_lock_irqsave(&omap->lock, flags);
+
+	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
+		!test_bit(OMAP_USBHS_SUSPEND, &omap->state))
+			goto end_resume;
+
+	pm_runtime_get_sync(dev);
+
+	if (is_omap_usbhs_rev2(omap)) {
+		if (is_ehci_tll_mode(pdata->port_mode[0])) {
+			clk_enable(omap->usbhost_p1_fck);
+			clk_enable(omap->usbtll_p1_fck);
+		}
+		if (is_ehci_tll_mode(pdata->port_mode[1])) {
+			clk_enable(omap->usbhost_p2_fck);
+			clk_enable(omap->usbtll_p2_fck);
+		}
+		clk_enable(omap->utmi_p1_fck);
+		clk_enable(omap->utmi_p2_fck);
+	}
+	clear_bit(OMAP_USBHS_SUSPEND, &omap->state);
+
+end_resume:
+	spin_unlock_irqrestore(&omap->lock, flags);
+	return 0;
+}
+
+
+static int usbhs_suspend(struct device *dev)
+{
+	struct usbhs_hcd_omap		*omap = dev_get_drvdata(dev);
+	struct usbhs_omap_platform_data	*pdata = &omap->platdata;
+	unsigned long			flags = 0;
+
+	dev_dbg(dev, "Suspending TI HSUSB Controller\n");
+
+	if (!pdata) {
+		dev_dbg(dev, "missing platform_data\n");
+		return  -ENODEV;
+	}
+
+	spin_lock_irqsave(&omap->lock, flags);
+
+	if (!test_bit(OMAP_USBHS_INIT, &omap->state) ||
+		test_bit(OMAP_USBHS_SUSPEND, &omap->state))
+			goto end_suspend;
+
+	if (is_omap_usbhs_rev2(omap)) {
+		if (is_ehci_tll_mode(pdata->port_mode[0])) {
+			clk_disable(omap->usbhost_p1_fck);
+			clk_disable(omap->usbtll_p1_fck);
+		}
+		if (is_ehci_tll_mode(pdata->port_mode[1])) {
+			clk_disable(omap->usbhost_p2_fck);
+			clk_disable(omap->usbtll_p2_fck);
+		}
+		clk_disable(omap->utmi_p2_fck);
+		clk_disable(omap->utmi_p1_fck);
+	}
+
+	set_bit(OMAP_USBHS_SUSPEND, &omap->state);
+	pm_runtime_put_sync(dev);
+
+end_suspend:
+	spin_unlock_irqrestore(&omap->lock, flags);
+	return 0;
+}
+
+
+static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
+	.suspend	= usbhs_suspend,
+	.resume		= usbhs_resume,
+};
+
+#define USBHS_OMAP_DEV_PM_OPS (&usbhsomap_dev_pm_ops)
+#else
+#define	USBHS_OMAP_DEV_PM_OPS	NULL
+#endif
+
 static struct platform_driver usbhs_omap_driver = {
 	.driver = {
 		.name		= (char *)usbhs_driver_name,
 		.owner		= THIS_MODULE,
+		.pm		= USBHS_OMAP_DEV_PM_OPS,
 	},
 	.remove		= __exit_p(usbhs_omap_remove),
 };
-- 
1.6.0.4

