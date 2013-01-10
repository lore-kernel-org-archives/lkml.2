Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3AJQxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 11:53:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755262Ab3AJQwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:52:09 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <sameo@linux.intel.com>, <tony@atomide.com>,
        <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH 07/14] usb: ehci-omap: Instantiate PHY devices if required
Date: Thu, 10 Jan 2013 18:51:27 +0200
Message-ID: <1357836694-30788-8-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357836694-30788-1-git-send-email-rogerq@ti.com>
References: <1357836694-30788-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the OMAP's Host controller is in PHY mode then we instantiate
a platform device for the PHY (one for each port in PHY mode) and
hold a reference to it so that we can use the usb_phy API, e.g.
while suspend/resume.

The platform data for the PHY must be supplied in the newly added
.phy_config parameter in struct usbhs_omap_platform_data.

The end goal is to move the PHY's reset and power handling code
out of the ehci-omap driver and into the phy driver.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/host/ehci-omap.c           |   83 ++++++++++++++++++++++++++++++-
 include/linux/platform_data/usb-omap.h |    8 +++
 2 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
index b96a4bf..e6a2d76 100644
--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -61,6 +61,11 @@
 
 static const struct hc_driver ehci_omap_hc_driver;
 
+struct omap_ehci_hcd {
+	struct usb_hcd *hcd;
+	struct usb_phy **phy;	/* one PHY for each port */
+	int nports;
+};
 
 static inline void ehci_write(void __iomem *base, u32 reg, u32 val)
 {
@@ -179,6 +184,8 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	struct usbhs_omap_platform_data		*pdata = dev->platform_data;
 	struct resource				*res;
 	struct usb_hcd				*hcd;
+	struct omap_ehci_hcd			*omap_hcd;
+	struct usb_phy				*phy;
 	void __iomem				*regs;
 	int					ret = -ENODEV;
 	int					irq;
@@ -193,6 +200,25 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (!pdata) {
+		dev_err(dev, "Missing platform data\n");
+		return -ENODEV;
+	}
+
+	omap_hcd = devm_kzalloc(&pdev->dev, sizeof(*omap_hcd), GFP_KERNEL);
+	if (!omap_hcd) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
+	omap_hcd->nports = pdata->nports;
+	i = sizeof(struct usb_phy *) * omap_hcd->nports;
+	omap_hcd->phy = devm_kzalloc(&pdev->dev, i, GFP_KERNEL);
+	if (!omap_hcd->phy) {
+		dev_err(dev, "Memory allocation failed\n");
+		return -ENOMEM;
+	}
+
 	irq = platform_get_irq_byname(pdev, "ehci-irq");
 	if (irq < 0) {
 		dev_err(dev, "EHCI irq failed\n");
@@ -223,9 +249,15 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 	hcd->rsrc_start = res->start;
 	hcd->rsrc_len = resource_size(res);
 	hcd->regs = regs;
+	omap_hcd->hcd = hcd;
+
+	platform_set_drvdata(pdev, omap_hcd);
 
 	/* get ehci regulator and enable */
-	for (i = 0 ; i < OMAP3_HS_USB_PORTS ; i++) {
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		struct platform_device *phy_pdev;
+		struct usbhs_phy_config *phy_config;
+
 		if (pdata->port_mode[i] != OMAP_EHCI_PORT_MODE_PHY) {
 			pdata->regulator[i] = NULL;
 			continue;
@@ -239,6 +271,33 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
 		} else {
 			regulator_enable(pdata->regulator[i]);
 		}
+
+		/* instantiate PHY */
+		if (!pdata->phy_config[i]) {
+			dev_dbg(dev, "missing phy_config for port %d\n", i);
+			continue;
+		}
+
+		phy_config = pdata->phy_config[i];
+		phy_pdev = platform_device_register_data(&pdev->dev,
+				phy_config->name, i, phy_config->pdata,
+				phy_config->pdata_size);
+		if (IS_ERR(phy_pdev)) {
+			dev_dbg(dev, "error creating PHY device for port %d\n",
+					i);
+		}
+
+		phy = usb_get_phy_from_dev(&phy_pdev->dev);
+		if (IS_ERR(phy)) {
+			dev_dbg(dev, "could not get USB PHY for port %d\n", i);
+			platform_device_unregister(phy_pdev);
+			continue;
+		}
+
+		usb_phy_init(phy);
+		omap_hcd->phy[i] = phy;
+		/* bring PHY out of suspend */
+		usb_phy_set_suspend(omap_hcd->phy[i], 0);
 	}
 
 	pm_runtime_enable(dev);
@@ -269,6 +328,12 @@ err_pm_runtime:
 	disable_put_regulator(pdata);
 	pm_runtime_put_sync(dev);
 	usb_put_hcd(hcd);
+	for (i = 0 ; i < omap_hcd->nports ; i++) {
+		phy = omap_hcd->phy[i];
+		if (!phy)
+			continue;
+		platform_device_unregister(to_platform_device(phy->dev));
+	}
 
 err_io:
 	iounmap(regs);
@@ -286,14 +351,26 @@ err_io:
  */
 static int ehci_hcd_omap_remove(struct platform_device *pdev)
 {
-	struct device *dev				= &pdev->dev;
-	struct usb_hcd *hcd				= dev_get_drvdata(dev);
+	struct device *dev		= &pdev->dev;
+	struct omap_ehci_hcd *omap_hcd	= dev_get_drvdata(dev);
+	struct usb_hcd *hcd		= omap_hcd->hcd;
+	int i;
 
 	usb_remove_hcd(hcd);
 	disable_put_regulator(dev->platform_data);
 	iounmap(hcd->regs);
 	usb_put_hcd(hcd);
 
+	for (i = 0; i < omap_hcd->nports; i++) {
+		struct usb_phy *phy = omap_hcd->phy[i];
+
+		if (!phy)
+			continue;
+
+		usb_phy_shutdown(phy);
+		platform_device_unregister(to_platform_device(phy->dev));
+	}
+
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
diff --git a/include/linux/platform_data/usb-omap.h b/include/linux/platform_data/usb-omap.h
index d63eb7d..927b8a1 100644
--- a/include/linux/platform_data/usb-omap.h
+++ b/include/linux/platform_data/usb-omap.h
@@ -38,6 +38,12 @@ enum usbhs_omap_port_mode {
 	OMAP_OHCI_PORT_MODE_TLL_2PIN_DPDM
 };
 
+struct usbhs_phy_config {
+	char *name;		/* binds to device driver */
+	void *pdata;		/* platform data for the phy */
+	size_t pdata_size;
+};
+
 struct usbhs_omap_platform_data {
 	int				nports;
 	enum usbhs_omap_port_mode	port_mode[OMAP3_HS_USB_PORTS];
@@ -49,6 +55,8 @@ struct usbhs_omap_platform_data {
 	unsigned			single_ulpi_bypass:1;
 	unsigned			es2_compatibility:1;
 	unsigned			phy_reset:1;
+
+	struct usbhs_phy_config		*phy_config[OMAP3_HS_USB_PORTS];
 };
 
 /*-------------------------------------------------------------------------*/
-- 
1.7.4.1

