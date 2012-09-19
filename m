Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab2ISLcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:32:10 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34370 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab2ISLay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:30:54 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <kishon@ti.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: Moiz Sonasath <m-sonasath@ti.com>
Subject: [PATCH 3/4] usb: phy: omap-usb3: Decrease the number of transitions to recovery
Date: Wed, 19 Sep 2012 17:00:28 +0530
Message-ID: <1348054229-27362-4-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348054229-27362-1-git-send-email-kishon@ti.com>
References: <1348054229-27362-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power-cycling the PHY (partially) decreases the number of transitions to
"Recovery" state. Hence changed the power up sequence to a partial
power-up before a full power-up of the PHY.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Moiz Sonasath <m-sonasath@ti.com>
---
 drivers/usb/phy/omap-usb3.c  |   43 ++++++++++++++++++++++++++++++++++++------
 include/linux/usb/omap_usb.h |    1 +
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/phy/omap-usb3.c b/drivers/usb/phy/omap-usb3.c
index 26402d5..fb3c5e6 100644
--- a/drivers/usb/phy/omap-usb3.c
+++ b/drivers/usb/phy/omap-usb3.c
@@ -35,13 +35,15 @@ static struct usb_dpll_params omap_usb3_dpll_params[NUM_SYS_CLKS] = {
 };
 
 /**
- * omap5_usb_phy_power - power on/off the serializer using control module
+ * omap5_usb_phy_partial_powerup - power on the serializer using control module
  * @phy: struct omap_usb *
- * @on: 0 to off and 1 to on based on powering on or off the PHY
  *
- * omap_usb3 can call this API to power on or off the PHY.
+ * After the dwc3 module is disabled and enabled again the synchronization
+ * between dwc3 and phy goes bad and the device does not get enumerated
+ * in superspeed mode. After some trials it was found powering up TX and
+ * part of RX PHY helped to solve the issue.
  */
-static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
+static int omap5_usb_phy_partial_powerup(struct omap_usb *phy)
 {
 	u32 val;
 	unsigned long rate;
@@ -58,10 +60,32 @@ static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
 
 	val = readl(phy->control_dev);
 
+	val &= ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
+	val |= (USB3_PHY_PARTIAL_RX_POWERON | USB3_PHY_TX_RX_POWERON)
+		<< USB_PWRCTL_CLK_CMD_SHIFT;
+	val |= rate << USB_PWRCTL_CLK_FREQ_SHIFT;
+
+	writel(val, phy->control_dev);
+
+	return 0;
+}
+
+/**
+ * omap5_usb_phy_power - power on/off the serializer using control module
+ * @phy: struct omap_usb *
+ * @on: 0 to off and 1 to on based on powering on or off the PHY
+ *
+ * omap_usb3 can call this API to power on or off the PHY.
+ */
+static int omap5_usb_phy_power(struct omap_usb *phy, bool on)
+{
+	u32 val;
+
+	val = readl(phy->control_dev);
+
 	if (on) {
-		val &= ~(USB_PWRCTL_CLK_CMD_MASK | USB_PWRCTL_CLK_FREQ_MASK);
+		val &= ~USB_PWRCTL_CLK_CMD_MASK;
 		val |= USB3_PHY_TX_RX_POWERON << USB_PWRCTL_CLK_CMD_SHIFT;
-		val |= rate << USB_PWRCTL_CLK_FREQ_SHIFT;
 	} else {
 		val &= ~USB_PWRCTL_CLK_CMD_MASK;
 		val |= USB3_PHY_TX_RX_POWEROFF << USB_PWRCTL_CLK_CMD_SHIFT;
@@ -207,6 +231,13 @@ static int omap_usb3_init(struct usb_phy *x)
 	struct omap_usb	*phy = phy_to_omapusb(x);
 
 	omap_usb_dpll_lock(phy);
+	omap5_usb_phy_partial_powerup(phy);
+	/*
+	 * Give enough time for the PHY to partially power-up before
+	 * powering it up completely. delay value suggested by the HW
+	 * team.
+	 */
+	mdelay(100);
 	omap5_usb_phy_power(phy, 1);
 
 	return 0;
diff --git a/include/linux/usb/omap_usb.h b/include/linux/usb/omap_usb.h
index 01ed008..62b637c 100644
--- a/include/linux/usb/omap_usb.h
+++ b/include/linux/usb/omap_usb.h
@@ -92,6 +92,7 @@ struct omap_usb {
 
 #define	USB3_PHY_TX_RX_POWERON		0x3
 #define	USB3_PHY_TX_RX_POWEROFF		0x0
+#define	USB3_PHY_PARTIAL_RX_POWERON	(0x1 << 6)
 
 #define	phy_to_omapusb(x)	container_of((x), struct omap_usb, phy)
 
-- 
1.7.9.5

