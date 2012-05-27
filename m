Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965806Ab2E0B2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:28:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43902 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934054Ab2E0BRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:17:42 -0400
Message-Id: <20120527002517.542708096@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:25:55 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Russ Dill <Russ.Dill@ti.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 49/91] USB: EHCI: OMAP: Finish ehci omap phy reset cycle before adding hcd.
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Dill <Russ.Dill@ti.com>

commit 3aa2ae74ba630ec9b98736d64aea8e4cb490861d upstream.

'ARM: OMAP3: USB: Fix the EHCI ULPI PHY reset issue' (1fcb57d0f) created a regression
with Beagleboard xM if booting the kernel after running 'usb start' under u-boot.

Finishing the reset before calling 'usb_add_hcd' fixes the regression. This is most likely due to
usb_add_hcd calling the driver's reset and init functions which expect the hardware to be
up and running.

Signed-off-by: Russ Dill <Russ.Dill@ti.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-omap.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/ehci-omap.c
+++ b/drivers/usb/host/ehci-omap.c
@@ -242,15 +242,6 @@ static int ehci_hcd_omap_probe(struct pl
 
 	ehci_reset(omap_ehci);
 
-	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
-	if (ret) {
-		dev_err(dev, "failed to add hcd with err %d\n", ret);
-		goto err_add_hcd;
-	}
-
-	/* root ports should always stay powered */
-	ehci_port_power(omap_ehci, 1);
-
 	if (pdata->phy_reset) {
 		/* Hold the PHY in RESET for enough time till
 		 * PHY is settled and ready
@@ -264,6 +255,15 @@ static int ehci_hcd_omap_probe(struct pl
 			gpio_set_value(pdata->reset_gpio_port[1], 1);
 	}
 
+	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
+	if (ret) {
+		dev_err(dev, "failed to add hcd with err %d\n", ret);
+		goto err_add_hcd;
+	}
+
+	/* root ports should always stay powered */
+	ehci_port_power(omap_ehci, 1);
+
 	return 0;
 
 err_add_hcd:


