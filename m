Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab1J1MjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:39:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab1J1Mfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013577"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 07/19] usb: otg: isp1301_omap: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:13 +0300
Message-Id: <1319805325-24689-8-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/otg/isp1301_omap.c |  236 +++++++++++++++++++++-------------------
 1 files changed, 123 insertions(+), 113 deletions(-)

diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index c9a9441..50cac78 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -52,7 +52,7 @@ MODULE_DESCRIPTION("ISP1301 USB OTG Transceiver Driver");
 MODULE_LICENSE("GPL");
 
 struct isp1301 {
-	struct usb_phy		otg;
+	struct usb_phy		xceiv;
 	struct i2c_client	*client;
 	void			(*i2c_release)(struct device *dev);
 
@@ -236,7 +236,7 @@ isp1301_clear_bits(struct isp1301 *isp, u8 reg, u8 bits)
 
 static inline const char *state_name(struct isp1301 *isp)
 {
-	return usb_phy_state_string(isp->otg.state);
+	return usb_phy_state_string(isp->xceiv.state);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -251,7 +251,7 @@ static inline const char *state_name(struct isp1301 *isp)
 
 static void power_down(struct isp1301 *isp)
 {
-	isp->otg.state = USB_PHY_STATE_UNDEFINED;
+	isp->xceiv.state = USB_PHY_STATE_UNDEFINED;
 
 	// isp1301_set_bits(isp, ISP1301_MODE_CONTROL_2, MC2_GLOBAL_PWR_DN);
 	isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_SUSPEND);
@@ -280,13 +280,13 @@ static int host_suspend(struct isp1301 *isp)
 #else
 	struct device	*dev;
 
-	if (!isp->otg.host)
+	if (!isp->xceiv.otg->host)
 		return -ENODEV;
 
 	/* Currently ASSUMES only the OTG port matters;
 	 * other ports could be active...
 	 */
-	dev = isp->otg.host->controller;
+	dev = isp->xceiv.otg->host->controller;
 	return dev->driver->suspend(dev, 3, 0);
 #endif
 }
@@ -298,20 +298,20 @@ static int host_resume(struct isp1301 *isp)
 #else
 	struct device	*dev;
 
-	if (!isp->otg.host)
+	if (!isp->xceiv.otg->host)
 		return -ENODEV;
 
-	dev = isp->otg.host->controller;
+	dev = isp->xceiv.otg->host->controller;
 	return dev->driver->resume(dev, 0);
 #endif
 }
 
 static int gadget_suspend(struct isp1301 *isp)
 {
-	isp->otg.gadget->b_hnp_enable = 0;
-	isp->otg.gadget->a_hnp_support = 0;
-	isp->otg.gadget->a_alt_hnp_support = 0;
-	return usb_gadget_vbus_disconnect(isp->otg.gadget);
+	isp->xceiv.otg->gadget->b_hnp_enable = 0;
+	isp->xceiv.otg->gadget->a_hnp_support = 0;
+	isp->xceiv.otg->gadget->a_alt_hnp_support = 0;
+	return usb_gadget_vbus_disconnect(isp->xceiv.otg->gadget);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -341,19 +341,19 @@ static void a_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
 
-	if (isp->otg.state == USB_PHY_STATE_A_IDLE)
+	if (isp->xceiv.state == USB_PHY_STATE_A_IDLE)
 		return;
 
-	isp->otg.default_a = 1;
-	if (isp->otg.host) {
-		isp->otg.host->is_b_host = 0;
+	isp->xceiv.otg->default_a = 1;
+	if (isp->xceiv.otg->host) {
+		isp->xceiv.otg->host->is_b_host = 0;
 		host_suspend(isp);
 	}
-	if (isp->otg.gadget) {
-		isp->otg.gadget->is_a_peripheral = 1;
+	if (isp->xceiv.otg->gadget) {
+		isp->xceiv.otg->gadget->is_a_peripheral = 1;
 		gadget_suspend(isp);
 	}
-	isp->otg.state = USB_PHY_STATE_A_IDLE;
+	isp->xceiv.state = USB_PHY_STATE_A_IDLE;
 	l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl = l;
@@ -365,19 +365,19 @@ static void b_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
 
-	if (isp->otg.state == USB_PHY_STATE_B_IDLE)
+	if (isp->xceiv.state == USB_PHY_STATE_B_IDLE)
 		return;
 
-	isp->otg.default_a = 0;
-	if (isp->otg.host) {
-		isp->otg.host->is_b_host = 1;
+	isp->xceiv.otg->default_a = 0;
+	if (isp->xceiv.otg->host) {
+		isp->xceiv.otg->host->is_b_host = 1;
 		host_suspend(isp);
 	}
-	if (isp->otg.gadget) {
-		isp->otg.gadget->is_a_peripheral = 0;
+	if (isp->xceiv.otg->gadget) {
+		isp->xceiv.otg->gadget->is_a_peripheral = 0;
 		gadget_suspend(isp);
 	}
-	isp->otg.state = USB_PHY_STATE_B_IDLE;
+	isp->xceiv.state = USB_PHY_STATE_B_IDLE;
 	l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl = l;
@@ -478,7 +478,7 @@ static void check_state(struct isp1301 *isp, const char *tag)
 	default:
 		break;
 	}
-	if (isp->otg.state == state && !extra)
+	if (isp->xceiv.state == state && !extra)
 		return;
 	pr_debug("otg: %s FSM %s/%02x, %s, %06x\n", tag,
 		usb_phy_state_string(state), fsm, state_name(isp),
@@ -502,22 +502,23 @@ static void update_otg1(struct isp1301 *isp, u8 int_src)
 
 	if (int_src & INTR_SESS_VLD)
 		otg_ctrl |= OTG_ASESSVLD;
-	else if (isp->otg.state == USB_PHY_STATE_A_WAIT_VFALL) {
+	else if (isp->xceiv.state == USB_PHY_STATE_A_WAIT_VFALL) {
 		a_idle(isp, "vfall");
 		otg_ctrl &= ~OTG_CTRL_BITS;
 	}
 	if (int_src & INTR_VBUS_VLD)
 		otg_ctrl |= OTG_VBUSVLD;
 	if (int_src & INTR_ID_GND) {		/* default-A */
-		if (isp->otg.state == USB_PHY_STATE_B_IDLE
-				|| isp->otg.state == USB_PHY_STATE_UNDEFINED) {
+		if (isp->xceiv.state == USB_PHY_STATE_B_IDLE
+				|| isp->xceiv.state
+					== USB_PHY_STATE_UNDEFINED) {
 			a_idle(isp, "init");
 			return;
 		}
 	} else {				/* default-B */
 		otg_ctrl |= OTG_ID;
-		if (isp->otg.state == USB_PHY_STATE_A_IDLE
-				|| isp->otg.state == USB_PHY_STATE_UNDEFINED) {
+		if (isp->xceiv.state == USB_PHY_STATE_A_IDLE
+			|| isp->xceiv.state == USB_PHY_STATE_UNDEFINED) {
 			b_idle(isp, "init");
 			return;
 		}
@@ -551,14 +552,14 @@ static void otg_update_isp(struct isp1301 *isp)
 	isp->last_otg_ctrl = otg_ctrl;
 	otg_ctrl = otg_ctrl & OTG_XCEIV_INPUTS;
 
-	switch (isp->otg.state) {
+	switch (isp->xceiv.state) {
 	case USB_PHY_STATE_B_IDLE:
 	case USB_PHY_STATE_B_PERIPHERAL:
 	case USB_PHY_STATE_B_SRP_INIT:
 		if (!(otg_ctrl & OTG_PULLUP)) {
 			// if (otg_ctrl & OTG_B_HNPEN) {
-			if (isp->otg.gadget->b_hnp_enable) {
-				isp->otg.state = USB_PHY_STATE_B_WAIT_ACON;
+			if (isp->xceiv.otg->gadget->b_hnp_enable) {
+				isp->xceiv.state = USB_PHY_STATE_B_WAIT_ACON;
 				pr_debug("  --> b_wait_acon\n");
 			}
 			goto pulldown;
@@ -585,10 +586,10 @@ pulldown:
 		else clr |= ISP; \
 		} while (0)
 
-	if (!(isp->otg.host))
+	if (!(isp->xceiv.otg->host))
 		otg_ctrl &= ~OTG_DRV_VBUS;
 
-	switch (isp->otg.state) {
+	switch (isp->xceiv.state) {
 	case USB_PHY_STATE_A_SUSPEND:
 		if (otg_ctrl & OTG_DRV_VBUS) {
 			set |= OTG1_VBUS_DRV;
@@ -599,7 +600,7 @@ pulldown:
 
 		/* FALLTHROUGH */
 	case USB_PHY_STATE_A_VBUS_ERR:
-		isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+		isp->xceiv.state = USB_PHY_STATE_A_WAIT_VFALL;
 		pr_debug("  --> a_wait_vfall\n");
 		/* FALLTHROUGH */
 	case USB_PHY_STATE_A_WAIT_VFALL:
@@ -608,7 +609,7 @@ pulldown:
 		break;
 	case USB_PHY_STATE_A_IDLE:
 		if (otg_ctrl & OTG_DRV_VBUS) {
-			isp->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
+			isp->xceiv.state = USB_PHY_STATE_A_WAIT_VRISE;
 			pr_debug("  --> a_wait_vrise\n");
 		}
 		/* FALLTHROUGH */
@@ -628,17 +629,17 @@ pulldown:
 	if (otg_change & OTG_PULLUP) {
 		u32 l;
 
-		switch (isp->otg.state) {
+		switch (isp->xceiv.state) {
 		case USB_PHY_STATE_B_IDLE:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+			isp->xceiv.state = USB_PHY_STATE_B_PERIPHERAL;
 			pr_debug("  --> b_peripheral\n");
 			break;
 		case USB_PHY_STATE_A_SUSPEND:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->otg.state = USB_PHY_STATE_A_PERIPHERAL;
+			isp->xceiv.state = USB_PHY_STATE_A_PERIPHERAL;
 			pr_debug("  --> a_peripheral\n");
 			break;
 		default:
@@ -659,6 +660,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 	u32		otg_ctrl;
 	int		ret = IRQ_NONE;
 	struct isp1301	*isp = _isp;
+	struct usb_otg	*otg = isp->xceiv.otg;
 
 	/* update ISP1301 transceiver from OTG controller */
 	if (otg_irq & OPRT_CHG) {
@@ -675,7 +677,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		 * remote wakeup (SRP, normal) using their own timer
 		 * to give "check cable and A-device" messages.
 		 */
-		if (isp->otg.state == USB_PHY_STATE_B_SRP_INIT)
+		if (isp->xceiv.state == USB_PHY_STATE_B_SRP_INIT)
 			b_idle(isp, "srp_timeout");
 
 		omap_writew(B_SRP_TMROUT, OTG_IRQ_SRC);
@@ -693,7 +695,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		omap_writel(otg_ctrl, OTG_CTRL);
 
 		/* subset of b_peripheral()... */
-		isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+		isp->xceiv.state = USB_PHY_STATE_B_PERIPHERAL;
 		pr_debug("  --> b_peripheral\n");
 
 		omap_writew(B_HNP_FAIL, OTG_IRQ_SRC);
@@ -705,9 +707,9 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 				state_name(isp), omap_readl(OTG_CTRL));
 
 		isp1301_defer_work(isp, WORK_UPDATE_OTG);
-		switch (isp->otg.state) {
+		switch (isp->xceiv.state) {
 		case USB_PHY_STATE_A_IDLE:
-			if (!isp->otg.host)
+			if (!otg->host)
 				break;
 			isp1301_defer_work(isp, WORK_HOST_RESUME);
 			otg_ctrl = omap_readl(OTG_CTRL);
@@ -736,7 +738,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |= OTG_BUSDROP;
 		otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+		isp->xceiv.state = USB_PHY_STATE_A_WAIT_VFALL;
 
 		omap_writew(A_REQ_TMROUT, OTG_IRQ_SRC);
 		ret = IRQ_HANDLED;
@@ -750,7 +752,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |= OTG_BUSDROP;
 		otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->otg.state = USB_PHY_STATE_A_VBUS_ERR;
+		isp->xceiv.state = USB_PHY_STATE_A_VBUS_ERR;
 
 		omap_writew(A_VBUS_ERR, OTG_IRQ_SRC);
 		ret = IRQ_HANDLED;
@@ -771,7 +773,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 
 		/* role is peripheral */
 		if (otg_ctrl & OTG_DRIVER_SEL) {
-			switch (isp->otg.state) {
+			switch (isp->xceiv.state) {
 			case USB_PHY_STATE_A_IDLE:
 				b_idle(isp, __func__);
 				break;
@@ -787,20 +789,20 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 				omap_writel(otg_ctrl | OTG_A_BUSREQ, OTG_CTRL);
 			}
 
-			if (isp->otg.host) {
-				switch (isp->otg.state) {
+			if (otg->host) {
+				switch (isp->xceiv.state) {
 				case USB_PHY_STATE_B_WAIT_ACON:
-					isp->otg.state = USB_PHY_STATE_B_HOST;
+					isp->xceiv.state = USB_PHY_STATE_B_HOST;
 					pr_debug("  --> b_host\n");
 					kick = 1;
 					break;
 				case USB_PHY_STATE_A_WAIT_BCON:
-					isp->otg.state = USB_PHY_STATE_A_HOST;
+					isp->xceiv.state = USB_PHY_STATE_A_HOST;
 					pr_debug("  --> a_host\n");
 					break;
 				case USB_PHY_STATE_A_PERIPHERAL:
-					isp->otg.state =
-						USB_PHY_STATE_A_WAIT_BCON;
+					isp->xceiv.state
+						= USB_PHY_STATE_A_WAIT_BCON;
 					pr_debug("  --> a_wait_bcon\n");
 					break;
 				default:
@@ -814,8 +816,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		ret = IRQ_HANDLED;
 
 		if (kick)
-			usb_bus_start_enum(isp->otg.host,
-						isp->otg.host->otg_port);
+			usb_bus_start_enum(otg->host, otg->host->otg_port);
 	}
 
 	check_state(isp, __func__);
@@ -931,7 +932,7 @@ static void b_peripheral(struct isp1301 *isp)
 	l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 
-	usb_gadget_vbus_connect(isp->otg.gadget);
+	usb_gadget_vbus_connect(isp->xceiv.otg->gadget);
 
 #ifdef	CONFIG_USB_OTG
 	enable_vbus_draw(isp, 8);
@@ -941,7 +942,7 @@ static void b_peripheral(struct isp1301 *isp)
 	/* UDC driver just set OTG_BSESSVLD */
 	isp1301_set_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLUP);
 	isp1301_clear_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLDOWN);
-	isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+	isp->xceiv.state = USB_PHY_STATE_B_PERIPHERAL;
 	pr_debug("  --> b_peripheral\n");
 	dump_regs(isp, "2periph");
 #endif
@@ -949,8 +950,9 @@ static void b_peripheral(struct isp1301 *isp)
 
 static void isp_update_otg(struct isp1301 *isp, u8 stat)
 {
+	struct usb_otg		*otg = isp->xceiv.otg;
 	u8			isp_stat, isp_bstat;
-	enum usb_phy_state	state = isp->otg.state;
+	enum usb_phy_state	state = isp->xceiv.state;
 
 	if (stat & INTR_BDIS_ACON)
 		pr_debug("OTG:  BDIS_ACON, %s\n", state_name(isp));
@@ -958,7 +960,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 	/* start certain state transitions right away */
 	isp_stat = isp1301_get_u8(isp, ISP1301_INTERRUPT_SOURCE);
 	if (isp_stat & INTR_ID_GND) {
-		if (isp->otg.default_a) {
+		if (otg->default_a) {
 			switch (state) {
 			case USB_PHY_STATE_B_IDLE:
 				a_idle(isp, "idle");
@@ -973,7 +975,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				 * when HNP is used.
 				 */
 				if (isp_stat & INTR_VBUS_VLD)
-					isp->otg.state = USB_PHY_STATE_A_HOST;
+					isp->xceiv.state = USB_PHY_STATE_A_HOST;
 				break;
 			case USB_PHY_STATE_A_WAIT_VFALL:
 				if (!(isp_stat & INTR_SESS_VLD))
@@ -981,8 +983,8 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				break;
 			default:
 				if (!(isp_stat & INTR_VBUS_VLD))
-					isp->otg.state =
-						USB_PHY_STATE_A_VBUS_ERR;
+					isp->xceiv.state
+						= USB_PHY_STATE_A_VBUS_ERR;
 				break;
 			}
 			isp_bstat = isp1301_get_u8(isp, ISP1301_OTG_STATUS);
@@ -991,14 +993,14 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 			case USB_PHY_STATE_B_PERIPHERAL:
 			case USB_PHY_STATE_B_HOST:
 			case USB_PHY_STATE_B_WAIT_ACON:
-				usb_gadget_vbus_disconnect(isp->otg.gadget);
+				usb_gadget_vbus_disconnect(otg->gadget);
 				break;
 			default:
 				break;
 			}
 			if (state != USB_PHY_STATE_A_IDLE)
 				a_idle(isp, "id");
-			if (isp->otg.host && state == USB_PHY_STATE_A_IDLE)
+			if (otg->host && state == USB_PHY_STATE_A_IDLE)
 				isp1301_defer_work(isp, WORK_HOST_RESUME);
 			isp_bstat = 0;
 		}
@@ -1008,10 +1010,10 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 		/* if user unplugged mini-A end of cable,
 		 * don't bypass A_WAIT_VFALL.
 		 */
-		if (isp->otg.default_a) {
+		if (otg->default_a) {
 			switch (state) {
 			default:
-				isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+				isp->xceiv.state = USB_PHY_STATE_A_WAIT_VFALL;
 				break;
 			case USB_PHY_STATE_A_WAIT_VFALL:
 				state = USB_PHY_STATE_A_IDLE;
@@ -1024,7 +1026,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 				host_suspend(isp);
 				isp1301_clear_bits(isp, ISP1301_MODE_CONTROL_1,
 						MC1_BDIS_ACON_EN);
-				isp->otg.state = USB_PHY_STATE_B_IDLE;
+				isp->xceiv.state = USB_PHY_STATE_B_IDLE;
 				l = omap_readl(OTG_CTRL) & OTG_CTRL_MASK;
 				l &= ~OTG_CTRL_BITS;
 				omap_writel(l, OTG_CTRL);
@@ -1035,7 +1037,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 		}
 		isp_bstat = isp1301_get_u8(isp, ISP1301_OTG_STATUS);
 
-		switch (isp->otg.state) {
+		switch (isp->xceiv.state) {
 		case USB_PHY_STATE_B_PERIPHERAL:
 		case USB_PHY_STATE_B_WAIT_ACON:
 		case USB_PHY_STATE_B_HOST:
@@ -1057,7 +1059,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 			omap_writel(l, OTG_CTRL);
 			/* FALLTHROUGH */
 		case USB_PHY_STATE_B_IDLE:
-			if (isp->otg.gadget && (isp_bstat & OTG_B_SESS_VLD)) {
+			if (otg->gadget && (isp_bstat & OTG_B_SESS_VLD)) {
 #ifdef	CONFIG_USB_OTG
 				update_otg1(isp, isp_stat);
 				update_otg2(isp, isp_bstat);
@@ -1075,7 +1077,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 		}
 	}
 
-	if (state != isp->otg.state)
+	if (state != isp->xceiv.state)
 		pr_debug("  isp, %s -> %s\n",
 				usb_phy_state_string(state), state_name(isp));
 
@@ -1133,10 +1135,10 @@ isp1301_work(struct work_struct *work)
 			 * skip A_WAIT_VRISE; hc transitions invisibly
 			 * skip A_WAIT_BCON; same.
 			 */
-			switch (isp->otg.state) {
+			switch (isp->xceiv.state) {
 			case USB_PHY_STATE_A_WAIT_BCON:
 			case USB_PHY_STATE_A_WAIT_VRISE:
-				isp->otg.state = USB_PHY_STATE_A_HOST;
+				isp->xceiv.state = USB_PHY_STATE_A_HOST;
 				pr_debug("  --> a_host\n");
 				otg_ctrl = omap_readl(OTG_CTRL);
 				otg_ctrl |= OTG_A_BUSREQ;
@@ -1145,7 +1147,7 @@ isp1301_work(struct work_struct *work)
 				omap_writel(otg_ctrl, OTG_CTRL);
 				break;
 			case USB_PHY_STATE_B_WAIT_ACON:
-				isp->otg.state = USB_PHY_STATE_B_HOST;
+				isp->xceiv.state = USB_PHY_STATE_B_HOST;
 				pr_debug("  --> b_host (acon)\n");
 				break;
 			case USB_PHY_STATE_B_HOST:
@@ -1206,6 +1208,7 @@ static void isp1301_release(struct device *dev)
 	/* ugly -- i2c hijacks our memory hook to wait_for_completion() */
 	if (isp->i2c_release)
 		isp->i2c_release(dev);
+	kfree(isp->xceiv.otg);
 	kfree (isp);
 }
 
@@ -1276,9 +1279,9 @@ static int isp1301_otg_enable(struct isp1301 *isp)
 
 /* add or disable the host device+driver */
 static int
-isp1301_set_host(struct usb_phy *otg, struct usb_bus *host)
+isp1301_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct isp1301	*isp = container_of(otg, struct isp1301, otg);
+	struct isp1301	*isp = container_of(otg->xceiv, struct isp1301, xceiv);
 
 	if (!otg || isp != the_transceiver)
 		return -ENODEV;
@@ -1286,21 +1289,21 @@ isp1301_set_host(struct usb_phy *otg, struct usb_bus *host)
 	if (!host) {
 		omap_writew(0, OTG_IRQ_EN);
 		power_down(isp);
-		isp->otg.host = NULL;
+		otg->host = NULL;
 		return 0;
 	}
 
 #ifdef	CONFIG_USB_OTG
-	isp->otg.host = host;
+	otg->host = host;
 	dev_dbg(&isp->client->dev, "registered host\n");
 	host_suspend(isp);
-	if (isp->otg.gadget)
+	if (otg->gadget)
 		return isp1301_otg_enable(isp);
 	return 0;
 
 #elif	!defined(CONFIG_USB_GADGET_OMAP)
 	// FIXME update its refcount
-	isp->otg.host = host;
+	otg->host = host;
 
 	power_up(isp);
 
@@ -1332,9 +1335,9 @@ isp1301_set_host(struct usb_phy *otg, struct usb_bus *host)
 }
 
 static int
-isp1301_set_peripheral(struct usb_phy *otg, struct usb_gadget *gadget)
+isp1301_set_peripheral(struct usb_otg *otg, struct usb_gadget *gadget)
 {
-	struct isp1301	*isp = container_of(otg, struct isp1301, otg);
+	struct isp1301	*isp = container_of(otg->xceiv, struct isp1301, xceiv);
 #ifndef	CONFIG_USB_OTG
 	u32 l;
 #endif
@@ -1344,24 +1347,24 @@ isp1301_set_peripheral(struct usb_phy *otg, struct usb_gadget *gadget)
 
 	if (!gadget) {
 		omap_writew(0, OTG_IRQ_EN);
-		if (!isp->otg.default_a)
+		if (!otg->default_a)
 			enable_vbus_draw(isp, 0);
-		usb_gadget_vbus_disconnect(isp->otg.gadget);
-		isp->otg.gadget = NULL;
+		usb_gadget_vbus_disconnect(otg->gadget);
+		otg->gadget = NULL;
 		power_down(isp);
 		return 0;
 	}
 
 #ifdef	CONFIG_USB_OTG
-	isp->otg.gadget = gadget;
+	otg->gadget = gadget;
 	dev_dbg(&isp->client->dev, "registered gadget\n");
 	/* gadget driver may be suspended until vbus_connect () */
-	if (isp->otg.host)
+	if (otg->host)
 		return isp1301_otg_enable(isp);
 	return 0;
 
 #elif	!defined(CONFIG_USB_OHCI_HCD) && !defined(CONFIG_USB_OHCI_HCD_MODULE)
-	isp->otg.gadget = gadget;
+	otg->gadget = gadget;
 	// FIXME update its refcount
 
 	l = omap_readl(OTG_CTRL) & OTG_CTRL_MASK;
@@ -1370,7 +1373,7 @@ isp1301_set_peripheral(struct usb_phy *otg, struct usb_gadget *gadget)
 	omap_writel(l, OTG_CTRL);
 
 	power_up(isp);
-	isp->otg.state = USB_PHY_STATE_B_IDLE;
+	isp->xceiv.state = USB_PHY_STATE_B_IDLE;
 
 	if (machine_is_omap_h2() || machine_is_omap_h3())
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
@@ -1411,13 +1414,13 @@ isp1301_set_power(struct usb_phy *dev, unsigned mA)
 }
 
 static int
-isp1301_start_srp(struct usb_phy *dev)
+isp1301_start_srp(struct usb_otg *otg)
 {
-	struct isp1301	*isp = container_of(dev, struct isp1301, otg);
+	struct isp1301	*isp = container_of(otg->xceiv, struct isp1301, xceiv);
 	u32		otg_ctrl;
 
-	if (!dev || isp != the_transceiver
-			|| isp->otg.state != USB_PHY_STATE_B_IDLE)
+	if (!otg || isp != the_transceiver
+			|| isp->xceiv.state != USB_PHY_STATE_B_IDLE)
 		return -ENODEV;
 
 	otg_ctrl = omap_readl(OTG_CTRL);
@@ -1427,7 +1430,7 @@ isp1301_start_srp(struct usb_phy *dev)
 	otg_ctrl |= OTG_B_BUSREQ;
 	otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK;
 	omap_writel(otg_ctrl, OTG_CTRL);
-	isp->otg.state = USB_PHY_STATE_B_SRP_INIT;
+	isp->xceiv.state = USB_PHY_STATE_B_SRP_INIT;
 
 	pr_debug("otg: SRP, %s ... %06x\n", state_name(isp),
 			omap_readl(OTG_CTRL));
@@ -1438,27 +1441,26 @@ isp1301_start_srp(struct usb_phy *dev)
 }
 
 static int
-isp1301_start_hnp(struct usb_phy *dev)
+isp1301_start_hnp(struct usb_otg *otg)
 {
 #ifdef	CONFIG_USB_OTG
-	struct isp1301	*isp = container_of(dev, struct isp1301, otg);
+	struct isp1301	*isp = container_of(otg->xceiv, struct isp1301, xceiv);
 	u32 l;
 
-	if (!dev || isp != the_transceiver)
+	if (!otg || isp != the_transceiver)
 		return -ENODEV;
-	if (isp->otg.default_a && (isp->otg.host == NULL
-			|| !isp->otg.host->b_hnp_enable))
+	if (otg->default_a && (otg->host == NULL || !otg->host->b_hnp_enable))
 		return -ENOTCONN;
-	if (!isp->otg.default_a && (isp->otg.gadget == NULL
-			|| !isp->otg.gadget->b_hnp_enable))
+	if (!otg->default_a && (otg->gadget == NULL
+			|| !otg->gadget->b_hnp_enable))
 		return -ENOTCONN;
 
 	/* We want hardware to manage most HNP protocol timings.
 	 * So do this part as early as possible...
 	 */
-	switch (isp->otg.state) {
+	switch (isp->xceiv.state) {
 	case USB_PHY_STATE_B_HOST:
-		isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+		isp->xceiv.state = USB_PHY_STATE_B_PERIPHERAL;
 		/* caller will suspend next */
 		break;
 	case USB_PHY_STATE_A_HOST:
@@ -1468,7 +1470,7 @@ isp1301_start_hnp(struct usb_phy *dev)
 				MC1_BDIS_ACON_EN);
 #endif
 		/* caller must suspend then clear A_BUSREQ */
-		usb_gadget_vbus_connect(isp->otg.gadget);
+		usb_gadget_vbus_connect(otg->gadget);
 		l = omap_readl(OTG_CTRL);
 		l |= OTG_A_SETB_HNPEN;
 		omap_writel(l, OTG_CTRL);
@@ -1505,6 +1507,12 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	if (!isp)
 		return 0;
 
+	isp->xceiv.otg = kzalloc(sizeof *isp->xceiv.otg, GFP_KERNEL);
+	if (!isp->xceiv.otg) {
+		kfree(isp);
+		return 0;
+	}
+
 	INIT_WORK(&isp->work, isp1301_work);
 	init_timer(&isp->timer);
 	isp->timer.function = isp1301_timer;
@@ -1578,14 +1586,15 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 		goto fail;
 	}
 
-	isp->otg.dev = &i2c->dev;
-	isp->otg.label = DRIVER_NAME;
+	isp->xceiv.dev = &i2c->dev;
+	isp->xceiv.label = DRIVER_NAME;
+	isp->xceiv.set_power = isp1301_set_power,
 
-	isp->otg.set_host = isp1301_set_host,
-	isp->otg.set_peripheral = isp1301_set_peripheral,
-	isp->otg.set_power = isp1301_set_power,
-	isp->otg.start_srp = isp1301_start_srp,
-	isp->otg.start_hnp = isp1301_start_hnp,
+	isp->xceiv.otg->xceiv = &isp->xceiv;
+	isp->xceiv.otg->set_host = isp1301_set_host,
+	isp->xceiv.otg->set_peripheral = isp1301_set_peripheral,
+	isp->xceiv.otg->start_srp = isp1301_start_srp,
+	isp->xceiv.otg->start_hnp = isp1301_start_hnp,
 
 	enable_vbus_draw(isp, 0);
 	power_down(isp);
@@ -1603,7 +1612,7 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	dev_dbg(&i2c->dev, "scheduled timer, %d min\n", TIMER_MINUTES);
 #endif
 
-	status = otg_set_transceiver(&isp->otg);
+	status = usb_set_transceiver(&isp->xceiv);
 	if (status < 0)
 		dev_err(&i2c->dev, "can't register transceiver, %d\n",
 			status);
@@ -1611,6 +1620,7 @@ isp1301_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	return 0;
 
 fail:
+	kfree(isp->xceiv.otg);
 	kfree(isp);
 	return -ENODEV;
 }
@@ -1641,7 +1651,7 @@ subsys_initcall(isp_init);
 static void __exit isp_exit(void)
 {
 	if (the_transceiver)
-		otg_set_transceiver(NULL);
+		usb_set_transceiver(NULL);
 	i2c_del_driver(&isp1301_driver);
 }
 module_exit(isp_exit);
-- 
1.7.4.1

