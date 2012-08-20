Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab2HTIMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 04:12:25 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:52741 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752514Ab2HTIMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 04:12:02 -0400
From: Roland Stigge <stigge@antcom.de>
To: bigeasy@linutronix.de, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arnd@arndb.de, aletes.xgr@gmail.com, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 3/3] usb: gadget: lpc32xx_udc: Support multiple controllers
Date: Mon, 20 Aug 2012 10:11:46 +0200
Message-Id: <1345450306-4996-3-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345450306-4996-1-git-send-email-stigge@antcom.de>
References: <1345450306-4996-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lpc32xx_udc driver supported only one controller by defining a global
static struct for it. This patch enables multiple instances of the controller
by dynamic allocation of the struct at probe(). A static struct is kept as a
template on initialization since it does some complex preset, reflecting fixed
hardware endpoint structure.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
 drivers/usb/gadget/lpc32xx_udc.c |   55 ++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

--- linux-2.6.orig/drivers/usb/gadget/lpc32xx_udc.c
+++ linux-2.6/drivers/usb/gadget/lpc32xx_udc.c
@@ -2608,10 +2608,9 @@ static void nop_release(struct device *d
 	/* nothing to free */
 }
 
-static struct lpc32xx_udc controller = {
+static struct lpc32xx_udc controller_template = {
 	.gadget = {
 		.ops	= &lpc32xx_udc_ops,
-		.ep0	= &controller.ep[0].ep,
 		.name	= driver_name,
 		.dev	= {
 			.init_name = "gadget",
@@ -2623,7 +2622,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep0",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 0,
 		.hwep_num	= 0, /* Can be 0 or 1, has special handling */
@@ -2635,7 +2633,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep1-int",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 2,
 		.hwep_num	= 0, /* 2 or 3, will be set later */
@@ -2647,7 +2644,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep2-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 4,
 		.hwep_num	= 0, /* 4 or 5, will be set later */
@@ -2659,7 +2655,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep3-iso",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 1023,
 		.hwep_num_base	= 6,
 		.hwep_num	= 0, /* 6 or 7, will be set later */
@@ -2671,7 +2666,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep4-int",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 8,
 		.hwep_num	= 0, /* 8 or 9, will be set later */
@@ -2683,7 +2677,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep5-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 10,
 		.hwep_num	= 0, /* 10 or 11, will be set later */
@@ -2695,7 +2688,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep6-iso",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 1023,
 		.hwep_num_base	= 12,
 		.hwep_num	= 0, /* 12 or 13, will be set later */
@@ -2707,7 +2699,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep7-int",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 14,
 		.hwep_num	= 0,
@@ -2719,7 +2710,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep8-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 16,
 		.hwep_num	= 0,
@@ -2731,7 +2721,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep9-iso",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 1023,
 		.hwep_num_base	= 18,
 		.hwep_num	= 0,
@@ -2743,7 +2732,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep10-int",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 20,
 		.hwep_num	= 0,
@@ -2755,7 +2743,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep11-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 22,
 		.hwep_num	= 0,
@@ -2767,7 +2754,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep12-iso",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 1023,
 		.hwep_num_base	= 24,
 		.hwep_num	= 0,
@@ -2779,7 +2765,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep13-int",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 26,
 		.hwep_num	= 0,
@@ -2791,7 +2776,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep14-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 64,
 		.hwep_num_base	= 28,
 		.hwep_num	= 0,
@@ -2803,7 +2787,6 @@ static struct lpc32xx_udc controller = {
 			.name	= "ep15-bulk",
 			.ops	= &lpc32xx_ep_ops,
 		},
-		.udc		= &controller,
 		.maxpacket	= 1023,
 		.hwep_num_base	= 30,
 		.hwep_num	= 0,
@@ -3090,12 +3073,21 @@ static u64 lpc32xx_usbd_dmamask = ~(u32)
 static int __init lpc32xx_udc_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct lpc32xx_udc *udc = &controller;
+	struct lpc32xx_udc *udc;
 	int retval, i;
 	struct resource *res;
 	dma_addr_t dma_handle;
 	struct device_node *isp1301_node;
 
+	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
+	if (!udc)
+		return -ENOMEM;
+
+	memcpy(udc, &controller_template, sizeof(*udc));
+	for (i = 0; i <= 15; i++)
+		udc->ep[i].udc = udc;
+	udc->gadget.ep0 = &udc->ep[0].ep;
+
 	/* init software state */
 	udc->gadget.dev.parent = dev;
 	udc->pdev = pdev;
@@ -3110,8 +3102,10 @@ static int __init lpc32xx_udc_probe(stru
 	}
 
 	udc->isp1301_i2c_client = isp1301_get_client(isp1301_node);
-	if (!udc->isp1301_i2c_client)
-		return -EPROBE_DEFER;
+	if (!udc->isp1301_i2c_client) {
+		retval = -EPROBE_DEFER;
+		goto phy_fail;
+	}
 
 	dev_info(udc->dev, "ISP1301 I2C device at address 0x%x\n",
 		 udc->isp1301_i2c_client->addr);
@@ -3130,8 +3124,10 @@ static int __init lpc32xx_udc_probe(stru
 	 *  IORESOURCE_IRQ, USB transceiver interrupt number
 	 */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENXIO;
+	if (!res) {
+		retval = -ENXIO;
+		goto resource_fail;
+	}
 
 	spin_lock_init(&udc->lock);
 
@@ -3141,7 +3137,8 @@ static int __init lpc32xx_udc_probe(stru
 		if (udc->udp_irq[i] < 0) {
 			dev_err(udc->dev,
 				"irq resource %d not available!\n", i);
-			return udc->udp_irq[i];
+			retval = udc->udp_irq[i];
+			goto irq_fail;
 		}
 	}
 
@@ -3149,7 +3146,8 @@ static int __init lpc32xx_udc_probe(stru
 	udc->io_p_size = resource_size(res);
 	if (!request_mem_region(udc->io_p_start, udc->io_p_size, driver_name)) {
 		dev_err(udc->dev, "someone's using UDC memory\n");
-		return -EBUSY;
+		retval = -EBUSY;
+		goto request_mem_region_fail;
 	}
 
 	udc->udp_baseaddr = ioremap(udc->io_p_start, udc->io_p_size);
@@ -3346,7 +3344,11 @@ pll_get_fail:
 io_map_fail:
 	release_mem_region(udc->io_p_start, udc->io_p_size);
 	dev_err(udc->dev, "%s probe failed, %d\n", driver_name, retval);
-
+request_mem_region_fail:
+irq_fail:
+resource_fail:
+phy_fail:
+	kfree(udc);
 	return retval;
 }
 
@@ -3384,6 +3386,7 @@ static int __devexit lpc32xx_udc_remove(
 	clk_put(udc->usb_pll_clk);
 	iounmap(udc->udp_baseaddr);
 	release_mem_region(udc->io_p_start, udc->io_p_size);
+	kfree(udc);
 
 	return 0;
 }
