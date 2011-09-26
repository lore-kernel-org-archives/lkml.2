Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1IZLXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:23:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:22239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1IZLWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:22:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56486110"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCHv5 14/19] arm: imx: Start using struct usb_otg
Date: Mon, 26 Sep 2011 14:21:27 +0300
Message-Id: <1317036092-3000-15-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Includes fixes from Sascha Hauer.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 arch/arm/mach-imx/mx31moboard-devboard.c |   22 ++++++++++++++--------
 arch/arm/mach-imx/mx31moboard-marxbot.c  |   22 ++++++++++++++--------
 2 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/arm/mach-imx/mx31moboard-devboard.c b/arch/arm/mach-imx/mx31moboard-devboard.c
index 9cd4a97..cc285e5 100644
--- a/arch/arm/mach-imx/mx31moboard-devboard.c
+++ b/arch/arm/mach-imx/mx31moboard-devboard.c
@@ -177,7 +177,7 @@ static int devboard_isp1105_init(struct usb_phy *otg)
 }
 
 
-static int devboard_isp1105_set_vbus(struct usb_phy *otg, bool on)
+static int devboard_isp1105_set_vbus(struct usb_otg *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -194,18 +194,24 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init devboard_usbh1_init(void)
 {
-	struct usb_phy *otg;
+	struct usb_phy *phy;
 	struct platform_device *pdev;
 
-	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
-	if (!otg)
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
+	if (!phy)
 		return -ENOMEM;
 
-	otg->label	= "ISP1105";
-	otg->init	= devboard_isp1105_init;
-	otg->set_vbus	= devboard_isp1105_set_vbus;
+	phy->otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!phy->otg) {
+		kfree(phy);
+		return -ENOMEM;
+	}
+
+	phy->label	= "ISP1105";
+	phy->init	= devboard_isp1105_init;
+	phy->otg->set_vbus	= devboard_isp1105_set_vbus;
 
-	usbh1_pdata.otg = otg;
+	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
 	if (IS_ERR(pdev))
diff --git a/arch/arm/mach-imx/mx31moboard-marxbot.c b/arch/arm/mach-imx/mx31moboard-marxbot.c
index 2be769b..135c90e 100644
--- a/arch/arm/mach-imx/mx31moboard-marxbot.c
+++ b/arch/arm/mach-imx/mx31moboard-marxbot.c
@@ -291,7 +291,7 @@ static int marxbot_isp1105_init(struct usb_phy *otg)
 }
 
 
-static int marxbot_isp1105_set_vbus(struct usb_phy *otg, bool on)
+static int marxbot_isp1105_set_vbus(struct usb_otg *otg, bool on)
 {
 	if (on)
 		gpio_set_value(USBH1_VBUSEN_B, 0);
@@ -308,18 +308,24 @@ static struct mxc_usbh_platform_data usbh1_pdata __initdata = {
 
 static int __init marxbot_usbh1_init(void)
 {
-	struct usb_phy *otg;
+	struct usb_phy *phy;
 	struct platform_device *pdev;
 
-	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
-	if (!otg)
+	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
+	if (!phy)
 		return -ENOMEM;
 
-	otg->label	= "ISP1105";
-	otg->init	= marxbot_isp1105_init;
-	otg->set_vbus	= marxbot_isp1105_set_vbus;
+	phy->otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!phy->otg) {
+		kfree(phy);
+		return -ENOMEM;
+	}
+
+	phy->label	= "ISP1105";
+	phy->init	= marxbot_isp1105_init;
+	phy->otg->set_vbus	= marxbot_isp1105_set_vbus;
 
-	usbh1_pdata.otg = otg;
+	usbh1_pdata.otg = phy;
 
 	pdev = imx31_add_mxc_ehci_hs(1, &usbh1_pdata);
 	if (IS_ERR(pdev))
-- 
1.7.4.1

