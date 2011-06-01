Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163045Ab1FAI0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:26:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163030Ab1FAI0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:26:34 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:08 2011
Message-Id: <20110601081207.872033989@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:39 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keshava Munegowda <keshava_mgowda@ti.com>, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [129/165] mfd: Fix omap usbhs crash when rmmoding ehci or ohci
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 2024
Lines: 63

From: Keshava Munegowda <Keshava_mgowda@ti.com>

commit 6eb6fbbf3eca6dfba73e72de5ab2eeb52ae41f7a upstream.

The disabling of clocks and freeing GPIO are changed
to fix the occurrence of the crash of rmmod of ehci and ohci
drivers. The GPIOs should be freed after the spin locks are
unlocked.

Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/omap-usb-host.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -994,22 +994,33 @@ static void usbhs_disable(struct device
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


