Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3ABPBN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:01:13 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56536 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab3ABPBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:08 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 02/22] mfd: omap-usb-tll: Fix channel count detection
Date: Wed, 2 Jan 2013 17:00:22 +0200
Message-ID: <1357138842-28964-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix channel count detecion for REV2. Also, don't give up
if we don't recognize the IP Revision. We assume the default
number of channels (i.e. 3) for unrecognized IPs.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index a10dcd1..5d5595b 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -98,6 +98,7 @@
 struct usbtll_omap {
 	struct clk				*usbtll_p1_fck;
 	struct clk				*usbtll_p2_fck;
+	int					nch;	/* num. of channels */
 	struct usbtll_omap_platform_data	*pdata;
 	/* secure the register updates */
 	spinlock_t				lock;
@@ -210,7 +211,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	unsigned				reg;
 	unsigned long				flags;
 	int					ret = 0;
-	int					i, ver, count;
+	int					i, ver;
 
 	dev_dbg(dev, "starting TI HSUSB TLL Controller\n");
 
@@ -262,16 +263,18 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	ver =  usbtll_read(base, OMAP_USBTLL_REVISION);
 	switch (ver) {
 	case OMAP_USBTLL_REV1:
-	case OMAP_USBTLL_REV2:
-		count = OMAP_TLL_CHANNEL_COUNT;
+		tll->nch = OMAP_TLL_CHANNEL_COUNT;
 		break;
+	case OMAP_USBTLL_REV2:
 	case OMAP_USBTLL_REV3:
-		count = OMAP_REV2_TLL_CHANNEL_COUNT;
+		tll->nch = OMAP_REV2_TLL_CHANNEL_COUNT;
 		break;
 	default:
-		dev_err(dev, "TLL version failed\n");
-		ret = -ENODEV;
-		goto err_ioremap;
+		tll->nch = OMAP_TLL_CHANNEL_COUNT;
+		dev_dbg(dev,
+		 "USB TLL Rev : 0x%x not recognized, assuming %d channels\n",
+			ver, tll->nch);
+		break;
 	}
 
 	if (is_ehci_tll_mode(pdata->port_mode[0]) ||
@@ -291,7 +294,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		usbtll_write(base, OMAP_TLL_SHARED_CONF, reg);
 
 		/* Enable channels now */
-		for (i = 0; i < count; i++) {
+		for (i = 0; i < tll->nch; i++) {
 			reg = usbtll_read(base,	OMAP_TLL_CHANNEL_CONF(i));
 
 			if (is_ohci_port(pdata->port_mode[i])) {
@@ -319,7 +322,6 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 		}
 	}
 
-err_ioremap:
 	spin_unlock_irqrestore(&tll->lock, flags);
 	iounmap(base);
 	pm_runtime_put_sync(dev);
-- 
1.7.4.1

