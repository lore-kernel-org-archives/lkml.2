Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1EPI4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:56:18 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56887 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545Ab1EPI4R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:56:17 -0400
From: Keshava Munegowda <keshava_mgowda@ti.com>
To: <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Keshava Munegowda <keshava_mgowda@ti.com>, <balbi@ti.com>,
        <gadiyar@ti.com>, <sameo@linux.intel.com>, <parthab@india.ti.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>
Subject: [PATCH] omap: usbhs: Fixed the crash during rmmod of ehci and ohci
Date: Mon, 16 May 2011 14:22:07 +0530
Message-ID: <1305535927-19840-1-git-send-email-keshava_mgowda@ti.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keshava Munegowda <Keshava_mgowda@ti.com>

The disableing of clocks and freeing GPIO are changed
to fix the occurence of the crash of rmmod of ehci and ohci
drivers. The GPIOs should be freed after the spin locks are
unlocked.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
---
 drivers/mfd/omap-usb-host.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 3ab9ffa..55c5d47 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -994,22 +994,33 @@ static void usbhs_disable(struct device *dev)
 			dev_dbg(dev, "operation timed out\n");
 	}
 
-	if (pdata->ehci_data->phy_reset) {
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
-
-		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
-			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
+	if (is_omap_usbhs_rev2(omap)) {
+		if (is_ehci_tll_mode(pdata->port_mode[0]))
+			clk_enable(omap->usbtll_p1_fck);
+		if (is_ehci_tll_mode(pdata->port_mode[1]))
+			clk_enable(omap->usbtll_p2_fck);
+		clk_disable(omap->utmi_p2_fck);
+		clk_disable(omap->utmi_p1_fck);
 	}
 
-	clk_disable(omap->utmi_p2_fck);
-	clk_disable(omap->utmi_p1_fck);
 	clk_disable(omap->usbtll_ick);
 	clk_disable(omap->usbtll_fck);
 	clk_disable(omap->usbhost_fs_fck);
 	clk_disable(omap->usbhost_hs_fck);
 	clk_disable(omap->usbhost_ick);
 
+	/* The gpio_free migh sleep; so unlock the spinlock */
+	spin_unlock_irqrestore(&omap->lock, flags);
+
+	if (pdata->ehci_data->phy_reset) {
+		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
+			gpio_free(pdata->ehci_data->reset_gpio_port[0]);
+
+		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
+			gpio_free(pdata->ehci_data->reset_gpio_port[1]);
+	}
+	return;
+
 end_disble:
 	spin_unlock_irqrestore(&omap->lock, flags);
 }
-- 
1.6.0.4

