Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab1FXRzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 13:55:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:42977 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1FXRzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 13:55:11 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>,
        Jason Liu <jason.hui@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2 4/5] net/fec: add device tree support
Date: Sat, 25 Jun 2011 02:04:35 +0800
Message-Id: <1308938676-31121-5-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308938676-31121-1-git-send-email-shawn.guo@linaro.org>
References: <1308938676-31121-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It adds device tree data parsing support for fec driver.

Signed-off-by: Jason Liu <jason.hui@linaro.org>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Cc: David S. Miller <davem@davemloft.net>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt |   22 ++++++
 drivers/net/fec.c                                 |   81 +++++++++++++++++++--
 2 files changed, 98 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl-fec.txt

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
new file mode 100644
index 0000000..345ecb6
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -0,0 +1,22 @@
+* Freescale Fast Ethernet Controller (FEC)
+
+Required properties:
+- compatible : should be "fsl,<soc>-fec"
+- reg : address and length of the register set for the device
+- interrupts : should contain fec interrupt
+- phy-mode : string, operation mode of the PHY interface.
+  Supported values are: "mii", "gmii", "sgmii", "tbi", "rmii",
+  "rgmii", "rgmii-id", "rgmii-rxid", "rgmii-txid", "rtbi".
+
+Optional properties:
+- local-mac-address : 6 bytes, mac address
+
+Example:
+
+fec@83fec000 {
+	compatible = "fsl,imx51-fec", "fsl,imx27-fec";
+	reg = <0x83fec000 0x4000>;
+	interrupts = <87>;
+	phy-mode = "mii";
+	local-mac-address = [00 04 9F 01 1B B9];
+};
diff --git a/drivers/net/fec.c b/drivers/net/fec.c
index 885d8ba..16ac1dd 100644
--- a/drivers/net/fec.c
+++ b/drivers/net/fec.c
@@ -44,6 +44,8 @@
 #include <linux/platform_device.h>
 #include <linux/phy.h>
 #include <linux/fec.h>
+#include <linux/of.h>
+#include <linux/of_device.h>
 
 #include <asm/cacheflush.h>
 
@@ -78,6 +80,12 @@ static struct platform_device_id fec_devtype[] = {
 	{ }
 };
 
+static const struct of_device_id fec_dt_ids[] = {
+	{ .compatible = "fsl,imx27-fec", .data = &fec_devtype[0], },
+	{ .compatible = "fsl,imx28-fec", .data = &fec_devtype[1], },
+	{},
+};
+
 static unsigned char macaddr[ETH_ALEN];
 module_param_array(macaddr, byte, NULL, 0);
 MODULE_PARM_DESC(macaddr, "FEC Ethernet MAC address");
@@ -731,8 +739,23 @@ static void __inline__ fec_get_mac(struct net_device *ndev)
 	 */
 	iap = macaddr;
 
+#ifdef CONFIG_OF
+	/*
+	 * 2) from device tree data
+	 */
+	if (!is_valid_ether_addr(iap)) {
+		struct device_node *np = fep->pdev->dev.of_node;
+		if (np) {
+			const void *p = of_get_property(np,
+						"local-mac-address", NULL);
+			if (p)
+				iap = (unsigned char *) p;
+		}
+	}
+#endif
+
 	/*
-	 * 2) from flash or fuse (via platform data)
+	 * 3) from flash or fuse (via platform data)
 	 */
 	if (!is_valid_ether_addr(iap)) {
 #ifdef CONFIG_M5272
@@ -745,7 +768,7 @@ static void __inline__ fec_get_mac(struct net_device *ndev)
 	}
 
 	/*
-	 * 3) FEC mac registers set by bootloader
+	 * 4) FEC mac registers set by bootloader
 	 */
 	if (!is_valid_ether_addr(iap)) {
 		*((unsigned long *) &tmpaddr[0]) =
@@ -1355,6 +1378,43 @@ static int fec_enet_init(struct net_device *ndev)
 	return 0;
 }
 
+#ifdef CONFIG_OF
+static int __devinit fec_get_phy_mode_dt(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	struct device_node *np = fep->pdev->dev.of_node;
+	const char *pm, *phy_modes[] = {
+		[PHY_INTERFACE_MODE_MII]	= "mii",
+		[PHY_INTERFACE_MODE_GMII]	= "gmii",
+		[PHY_INTERFACE_MODE_SGMII]	= "sgmii",
+		[PHY_INTERFACE_MODE_TBI]	= "tbi",
+		[PHY_INTERFACE_MODE_RMII]	= "rmii",
+		[PHY_INTERFACE_MODE_RGMII]	= "rgmii",
+		[PHY_INTERFACE_MODE_RGMII_ID]	= "rgmii-id",
+		[PHY_INTERFACE_MODE_RGMII_RXID]	= "rgmii-rxid",
+		[PHY_INTERFACE_MODE_RGMII_TXID] = "rgmii-txid",
+		[PHY_INTERFACE_MODE_RTBI]	= "rtbi",
+	};
+
+	if (np) {
+		pm = of_get_property(np, "phy-mode", NULL);
+		if (pm) {
+			int i;
+			for (i = 0; i < ARRAY_SIZE(phy_modes); i++)
+				if (!strcasecmp(pm, phy_modes[i]))
+					return i;
+		}
+	}
+
+	return -ENODEV;
+}
+#else
+static int __devinit fec_get_phy_mode_dt(struct net_device *ndev)
+{
+	return -ENODEV;
+}
+#endif
+
 static int __devinit
 fec_probe(struct platform_device *pdev)
 {
@@ -1363,6 +1423,11 @@ fec_probe(struct platform_device *pdev)
 	struct net_device *ndev;
 	int i, irq, ret = 0;
 	struct resource *r;
+	const struct of_device_id *of_id;
+
+	of_id = of_match_device(fec_dt_ids, &pdev->dev);
+	if (of_id)
+		pdev->id_entry = (struct platform_device_id *) of_id->data;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
@@ -1394,9 +1459,14 @@ fec_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, ndev);
 
-	pdata = pdev->dev.platform_data;
-	if (pdata)
-		fep->phy_interface = pdata->phy;
+	fep->phy_interface = fec_get_phy_mode_dt(ndev);
+	if (fep->phy_interface == -ENODEV) {
+		pdata = pdev->dev.platform_data;
+		if (pdata)
+			fep->phy_interface = pdata->phy;
+		else
+			fep->phy_interface = PHY_INTERFACE_MODE_MII;
+	}
 
 	/* This device has up to three irqs on some platforms */
 	for (i = 0; i < 3; i++) {
@@ -1531,6 +1601,7 @@ static struct platform_driver fec_driver = {
 #ifdef CONFIG_PM
 		.pm	= &fec_pm_ops,
 #endif
+		.of_match_table = fec_dt_ids,
 	},
 	.id_table = fec_devtype,
 	.probe	= fec_probe,
-- 
1.7.4.1

