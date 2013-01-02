Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab3ABPBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 10:01:20 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56781 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab3ABPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 10:01:10 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <keshava_mgowda@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <rogerq@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 05/22] mfd: omap-usb-tll: introduce and use mode_needs_tll()
Date: Wed, 2 Jan 2013 17:00:25 +0200
Message-ID: <1357138842-28964-6-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357138842-28964-1-git-send-email-rogerq@ti.com>
References: <1357138842-28964-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a handy macro to check if the port requires the
USB TLL module or not. Use it to Enable the TLL module and manage
the clocks.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/mfd/omap-usb-tll.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
index 238d05d..b188ee8 100644
--- a/drivers/mfd/omap-usb-tll.c
+++ b/drivers/mfd/omap-usb-tll.c
@@ -95,6 +95,10 @@
 
 #define is_ehci_tll_mode(x)	(x == OMAP_EHCI_PORT_MODE_TLL)
 
+/* only PHY and UNUSED modes don't need TLL */
+#define omap_usb_mode_needs_tll(x)	((x != OMAP_USBHS_PORT_MODE_UNUSED) &&\
+					 (x != OMAP_EHCI_PORT_MODE_PHY))
+
 struct usbtll_omap {
 	int					nch;	/* num. of channels */
 	struct usbtll_omap_platform_data	*pdata;
@@ -211,6 +215,7 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 	unsigned long				flags;
 	int					ret = 0;
 	int					i, ver;
+	bool needs_tll;
 
 	dev_dbg(dev, "starting TI HSUSB TLL Controller\n");
 
@@ -278,12 +283,11 @@ static int usbtll_omap_probe(struct platform_device *pdev)
 			tll->ch_clk[i] = fck;
 	}
 
-	if (is_ehci_tll_mode(pdata->port_mode[0]) ||
-	    is_ehci_tll_mode(pdata->port_mode[1]) ||
-	    is_ehci_tll_mode(pdata->port_mode[2]) ||
-	    is_ohci_port(pdata->port_mode[0]) ||
-	    is_ohci_port(pdata->port_mode[1]) ||
-	    is_ohci_port(pdata->port_mode[2])) {
+	needs_tll = false;
+	for (i = 0; i < tll->nch; i++)
+		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
+
+	if (needs_tll) {
 
 		/* Program Common TLL register */
 		reg = usbtll_read(base, OMAP_TLL_SHARED_CONF);
@@ -371,7 +375,7 @@ static int usbtll_runtime_resume(struct device *dev)
 	spin_lock_irqsave(&tll->lock, flags);
 
 	for (i = 0; i < tll->nch; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			int r;
 
 			if (!tll->ch_clk[i])
@@ -407,7 +411,7 @@ static int usbtll_runtime_suspend(struct device *dev)
 	spin_lock_irqsave(&tll->lock, flags);
 
 	for (i = 0; i < tll->nch; i++) {
-		if (is_ehci_tll_mode(pdata->port_mode[i])) {
+		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
 			if (tll->ch_clk[i])
 				clk_disable(tll->ch_clk[i]);
 		}
-- 
1.7.4.1

