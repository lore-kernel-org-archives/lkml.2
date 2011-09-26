Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab1IZLW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:22:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:22239 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218Ab1IZLWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:22:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56486126"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCHv5 15/19] usb: musb: Start using struct usb_otg
Date: Mon, 26 Sep 2011 14:21:28 +0300
Message-Id: <1317036092-3000-16-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1317036092-3000-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/musb/am35x.c        |    5 +++--
 drivers/usb/musb/da8xx.c        |    5 +++--
 drivers/usb/musb/davinci.c      |    7 ++++---
 drivers/usb/musb/musb_core.c    |   11 ++++++-----
 drivers/usb/musb/musb_virthub.c |    9 ++++++---
 drivers/usb/musb/omap2430.c     |    5 +++--
 drivers/usb/musb/tusb6010.c     |   14 ++++++++------
 7 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index ee1c43e..8325ecf 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -226,6 +226,7 @@ static irqreturn_t am35x_musb_interrupt(int irq, void *hci)
 	struct device *dev = musb->controller;
 	struct musb_hdrc_platform_data *plat = dev->platform_data;
 	struct omap_musb_board_data *data = plat->board_data;
+	struct usb_otg *otg = musb->xceiv->otg;
 	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 	u32 epintr, usbintr;
@@ -289,14 +290,14 @@ static irqreturn_t am35x_musb_interrupt(int irq, void *hci)
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
-			musb->xceiv->default_a = 1;
+			otg->default_a = 1;
 			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
-			musb->xceiv->default_a = 0;
+			otg->default_a = 0;
 			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index fc982fa..61813b5 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -294,6 +294,7 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *hci)
 {
 	struct musb		*musb = hci;
 	void __iomem		*reg_base = musb->ctrl_base;
+	struct usb_otg		*otg = musb->xceiv->otg;
 	unsigned long		flags;
 	irqreturn_t		ret = IRQ_NONE;
 	u32			status;
@@ -351,14 +352,14 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *hci)
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
-			musb->xceiv->default_a = 1;
+			otg->default_a = 1;
 			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
-			musb->xceiv->default_a = 0;
+			otg->default_a = 0;
 			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index c1f4998e..b2daf1c 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -268,6 +268,7 @@ static irqreturn_t davinci_musb_interrupt(int irq, void *__hci)
 	unsigned long	flags;
 	irqreturn_t	retval = IRQ_NONE;
 	struct musb	*musb = __hci;
+	struct usb_otg	*otg = musb->xceiv->otg;
 	void __iomem	*tibase = musb->ctrl_base;
 	struct cppi	*cppi;
 	u32		tmp;
@@ -334,14 +335,14 @@ static irqreturn_t davinci_musb_interrupt(int irq, void *__hci)
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
-			musb->xceiv->default_a = 1;
+			otg->default_a = 1;
 			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
-			musb->xceiv->default_a = 0;
+			otg->default_a = 0;
 			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
@@ -467,7 +468,7 @@ static int davinci_musb_exit(struct musb *musb)
 	davinci_musb_source_power(musb, 0 /*off*/, 1);
 
 	/* delay, to avoid problems with module reload */
-	if (is_host_enabled(musb) && musb->xceiv->default_a) {
+	if (is_host_enabled(musb) && musb->xceiv->otg->default_a) {
 		int	maxdelay = 30;
 		u8	devctl, warn = 0;
 
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index e7c97e6..f9edf2c 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -415,6 +415,7 @@ void musb_hnp_stop(struct musb *musb)
 static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				u8 devctl, u8 power)
 {
+	struct usb_otg *otg = musb->xceiv->otg;
 	irqreturn_t handled = IRQ_NONE;
 
 	dev_dbg(musb->controller, "<== Power=%02x, DevCtl=%02x, int_usb=0x%x\n", power, devctl,
@@ -631,7 +632,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		case USB_PHY_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
 			musb->is_active = is_otg_enabled(musb)
-					&& musb->xceiv->gadget->b_hnp_enable;
+					&& otg->gadget->b_hnp_enable;
 			if (musb->is_active) {
 				musb->xceiv->state = USB_PHY_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
@@ -648,7 +649,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		case USB_PHY_STATE_A_HOST:
 			musb->xceiv->state = USB_PHY_STATE_A_SUSPEND;
 			musb->is_active = is_otg_enabled(musb)
-					&& musb->xceiv->host->b_hnp_enable;
+					&& otg->host->b_hnp_enable;
 			break;
 		case USB_PHY_STATE_B_HOST:
 			/* Transition to B_PERIPHERAL, see 6.8.2.6 p 44 */
@@ -1974,7 +1975,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 		if (is_otg_enabled(musb))
 			hcd->self.otg_port = 1;
-		musb->xceiv->host = &hcd->self;
+		musb->xceiv->otg->host = &hcd->self;
 		hcd->power_budget = 2 * (plat->power ? : 250);
 
 		/* program PHY to use external vBus if required */
@@ -1993,7 +1994,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 		struct usb_hcd	*hcd = musb_to_hcd(musb);
 
 		MUSB_HST_MODE(musb);
-		musb->xceiv->default_a = 1;
+		musb->xceiv->otg->default_a = 1;
 		musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 
 		status = usb_add_hcd(musb_to_hcd(musb), -1, 0);
@@ -2008,7 +2009,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 	} else /* peripheral is enabled */ {
 		MUSB_DEV_MODE(musb);
-		musb->xceiv->default_a = 0;
+		musb->xceiv->otg->default_a = 0;
 		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 
 		status = musb_gadget_setup(musb);
diff --git a/drivers/usb/musb/musb_virthub.c b/drivers/usb/musb/musb_virthub.c
index b36e704..b757395 100644
--- a/drivers/usb/musb/musb_virthub.c
+++ b/drivers/usb/musb/musb_virthub.c
@@ -47,6 +47,7 @@
 
 static void musb_port_suspend(struct musb *musb, bool do_suspend)
 {
+	struct usb_otg	*otg = musb->xceiv->otg;
 	u8		power;
 	void __iomem	*mbase = musb->mregs;
 
@@ -81,7 +82,7 @@ static void musb_port_suspend(struct musb *musb, bool do_suspend)
 		case USB_PHY_STATE_A_HOST:
 			musb->xceiv->state = USB_PHY_STATE_A_SUSPEND;
 			musb->is_active = is_otg_enabled(musb)
-					&& musb->xceiv->host->b_hnp_enable;
+					&& otg->host->b_hnp_enable;
 			if (musb->is_active)
 				mod_timer(&musb->otg_timer, jiffies
 					+ msecs_to_jiffies(
@@ -91,7 +92,7 @@ static void musb_port_suspend(struct musb *musb, bool do_suspend)
 		case USB_PHY_STATE_B_HOST:
 			musb->xceiv->state = USB_PHY_STATE_B_WAIT_ACON;
 			musb->is_active = is_otg_enabled(musb)
-					&& musb->xceiv->host->b_hnp_enable;
+					&& otg->host->b_hnp_enable;
 			musb_platform_try_idle(musb, 0);
 			break;
 		default:
@@ -179,6 +180,8 @@ static void musb_port_reset(struct musb *musb, bool do_reset)
 
 void musb_root_disconnect(struct musb *musb)
 {
+	struct usb_otg	*otg = musb->xceiv->otg;
+
 	musb->port1_status = USB_PORT_STAT_POWER
 			| (USB_PORT_STAT_C_CONNECTION << 16);
 
@@ -188,7 +191,7 @@ void musb_root_disconnect(struct musb *musb)
 	switch (musb->xceiv->state) {
 	case USB_PHY_STATE_A_SUSPEND:
 		if (is_otg_enabled(musb)
-				&& musb->xceiv->host->b_hnp_enable) {
+				&& otg->host->b_hnp_enable) {
 			musb->xceiv->state = USB_PHY_STATE_A_PERIPHERAL;
 			musb->g.is_a_peripheral = 1;
 			break;
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 2cd9408..0879a2b 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -133,6 +133,7 @@ static void omap2430_musb_try_idle(struct musb *musb, unsigned long timeout)
 
 static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 {
+	struct usb_otg	*otg = musb->xceiv->otg;
 	u8		devctl;
 	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
 	int ret = 1;
@@ -168,7 +169,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 				otg_set_vbus(musb->xceiv, 1);
 		} else {
 			musb->is_active = 1;
-			musb->xceiv->default_a = 1;
+			otg->default_a = 1;
 			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			devctl |= MUSB_DEVCTL_SESSION;
 			MUSB_HST_MODE(musb);
@@ -180,7 +181,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 		 * jumping right to B_IDLE...
 		 */
 
-		musb->xceiv->default_a = 0;
+		otg->default_a = 0;
 		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 		devctl &= ~MUSB_DEVCTL_SESSION;
 
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index d7cae3d..3c7dd53 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -292,7 +292,7 @@ static int tusb_draw_power(struct usb_phy *x, unsigned mA)
 	 * The actual current usage would be very board-specific.  For now,
 	 * it's simpler to just use an aggregate (also board-specific).
 	 */
-	if (x->default_a || mA < (musb->min_power << 1))
+	if (x->otg->default_a || mA < (musb->min_power << 1))
 		mA = 0;
 
 	reg = musb_readl(tbase, TUSB_PRCM_MNGMT);
@@ -509,6 +509,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 	void __iomem	*tbase = musb->ctrl_base;
 	u32		conf, prcm, timer;
 	u8		devctl;
+	struct usb_otg	*otg = musb->xceiv->otg;
 
 	/* HDRC controls CPEN, but beware current surges during device
 	 * connect.  They can trigger transient overcurrent conditions
@@ -521,7 +522,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 
 	if (is_on) {
 		timer = OTG_TIMER_MS(OTG_TIME_A_WAIT_VRISE);
-		musb->xceiv->default_a = 1;
+		otg->default_a = 1;
 		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		devctl |= MUSB_DEVCTL_SESSION;
 
@@ -547,11 +548,11 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 				musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 			}
 			musb->is_active = 0;
-			musb->xceiv->default_a = 1;
+			otg->default_a = 1;
 			MUSB_HST_MODE(musb);
 		} else {
 			musb->is_active = 0;
-			musb->xceiv->default_a = 0;
+			otg->default_a = 0;
 			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		}
@@ -643,6 +644,7 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 {
 	u32		otg_stat = musb_readl(tbase, TUSB_DEV_OTG_STAT);
 	unsigned long	idle_timeout = 0;
+	struct usb_otg	*otg = musb->xceiv->otg;
 
 	/* ID pin */
 	if ((int_src & TUSB_INT_SRC_ID_STATUS_CHNG)) {
@@ -653,7 +655,7 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 		else
 			default_a = is_host_enabled(musb);
 		dev_dbg(musb->controller, "Default-%c\n", default_a ? 'A' : 'B');
-		musb->xceiv->default_a = default_a;
+		otg->default_a = default_a;
 		tusb_musb_set_vbus(musb, default_a);
 
 		/* Don't allow idling immediately */
@@ -665,7 +667,7 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 	if (int_src & TUSB_INT_SRC_VBUS_SENSE_CHNG) {
 
 		/* B-dev state machine:  no vbus ~= disconnect */
-		if ((is_otg_enabled(musb) && !musb->xceiv->default_a)
+		if ((is_otg_enabled(musb) && !otg->default_a)
 				|| !is_host_enabled(musb)) {
 			/* ? musb_root_disconnect(musb); */
 			musb->port1_status &=
-- 
1.7.4.1

