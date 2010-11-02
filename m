Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0KBJb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 05:31:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33888 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab0KBJbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 05:31:18 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: kernel@pengutronix.de, Sergei Shtylyov <sshtylyov@mvista.com>,
        matthieu.castet@parrot.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Nguyen Dinh <R00091@freescale.com>,
        Dinh Nguyen <Dinh.Nguyen@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] USB: ehci/mxc: compile fix
Date: Tue,  2 Nov 2010 10:30:57 +0100
Message-Id: <1288690257-16801-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit
	65fd427 (USB: ehci tdi : let's tdi_reset set host mode)

broke the build using ARM's mx51_defconfig:

 	  CC      drivers/usb/host/ehci-hcd.o
 	In file included from drivers/usb/host/ehci-hcd.c:1166:
 	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
 	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)
 	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier is reported only once
 	drivers/usb/host/ehci-mxc.c:192: error: for each function it appears in.)
 	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
 	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
 	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
 	make[1]: *** [sub-make] Error 2
 	make: *** [all] Error 2

Fix it together with the warning about the unused variable and use
msleep instead of mdelay as requested by Alan Stern.

Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I currently have no hardware to test it, so I only verified it to
compile.

Dinh: I changed your Tested-by to Cc for the new patch, do you care to
retest?

Best regards
Uwe
---
 drivers/usb/host/ehci-mxc.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
index ac9c4d7..bce8505 100644
--- a/drivers/usb/host/ehci-mxc.c
+++ b/drivers/usb/host/ehci-mxc.c
@@ -36,6 +36,8 @@ struct ehci_mxc_priv {
 static int ehci_mxc_setup(struct usb_hcd *hcd)
 {
 	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
+	struct device *dev = hcd->self.controller;
+	struct mxc_usbh_platform_data *pdata = dev_get_platdata(dev);
 	int retval;
 
 	/* EHCI registers start at offset 0x100 */
@@ -63,6 +65,12 @@ static int ehci_mxc_setup(struct usb_hcd *hcd)
 
 	ehci_reset(ehci);
 
+	/* set up the PORTSCx register */
+	ehci_writel(ehci, pdata->portsc, &ehci->regs->port_status[0]);
+
+	/* is this really needed? */
+	msleep(10);
+
 	ehci_port_power(ehci, 0);
 	return 0;
 }
@@ -114,7 +122,7 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 	struct mxc_usbh_platform_data *pdata = pdev->dev.platform_data;
 	struct usb_hcd *hcd;
 	struct resource *res;
-	int irq, ret, temp;
+	int irq, ret;
 	struct ehci_mxc_priv *priv;
 	struct device *dev = &pdev->dev;
 
@@ -188,10 +196,6 @@ static int ehci_mxc_drv_probe(struct platform_device *pdev)
 		clk_enable(priv->ahbclk);
 	}
 
-	/* set up the PORTSCx register */
-	ehci_writel(ehci, pdata->portsc, &ehci->regs->port_status[0]);
-	mdelay(10);
-
 	/* setup specific usb hw */
 	ret = mxc_initialize_usb_hw(pdev->id, pdata->flags);
 	if (ret < 0)
-- 
1.7.2.3

