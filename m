Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738Ab1J1Mfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:35:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:25039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932296Ab1J1Mfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013523"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 02/19] usb: otg: Rename usb_otg and usb_xceiv to usb_phy
Date: Fri, 28 Oct 2011 15:35:08 +0300
Message-Id: <1319805325-24689-3-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Renames OTG_STATE_* to USB_PHY_STATE_*,
usb_xceiv_event to usb_phy_event and
otg_state_string() to usb_phy_state_string().

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/power/pda_power.c       |    2 +-
 drivers/usb/host/ohci-omap.c    |    2 +-
 drivers/usb/musb/am35x.c        |   33 ++++---
 drivers/usb/musb/blackfin.c     |   22 ++--
 drivers/usb/musb/da8xx.c        |   33 ++++---
 drivers/usb/musb/davinci.c      |   20 ++--
 drivers/usb/musb/musb_core.c    |  151 ++++++++++++++++--------------
 drivers/usb/musb/musb_gadget.c  |   50 +++++-----
 drivers/usb/musb/musb_host.c    |    8 +-
 drivers/usb/musb/musb_virthub.c |   28 +++---
 drivers/usb/musb/omap2430.c     |   30 +++---
 drivers/usb/musb/tusb6010.c     |   60 ++++++------
 drivers/usb/otg/ab8500-usb.c    |   10 +-
 drivers/usb/otg/fsl_otg.c       |   16 ++--
 drivers/usb/otg/fsl_otg.h       |    2 +-
 drivers/usb/otg/gpio_vbus.c     |   10 +-
 drivers/usb/otg/isp1301_omap.c  |  198 ++++++++++++++++++++-------------------
 drivers/usb/otg/langwell_otg.c  |  178 +++++++++++++++++-----------------
 drivers/usb/otg/msm_otg.c       |   62 ++++++------
 drivers/usb/otg/nop-usb-xceiv.c |    4 +-
 drivers/usb/otg/otg.c           |   30 +++---
 drivers/usb/otg/otg_fsm.c       |  152 +++++++++++++++---------------
 drivers/usb/otg/twl4030-usb.c   |   10 +-
 drivers/usb/otg/twl6030-usb.c   |    8 +-
 include/linux/usb/msm_hsusb.h   |    2 +-
 include/linux/usb/otg.h         |   42 ++++----
 26 files changed, 590 insertions(+), 573 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index 8f817e6..60433b7 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -222,7 +222,7 @@ static void polling_timer_func(unsigned long unused)
 #ifdef CONFIG_USB_OTG_UTILS
 static int otg_is_usb_online(void)
 {
-	return (transceiver->state == OTG_STATE_B_PERIPHERAL);
+	return (transceiver->state == USB_PHY_STATE_B_PERIPHERAL);
 }
 #endif
 
diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
index e4b8782..96073bd 100644
--- a/drivers/usb/host/ohci-omap.c
+++ b/drivers/usb/host/ohci-omap.c
@@ -174,7 +174,7 @@ static void start_hnp(struct ohci_hcd *ohci)
 	otg_start_hnp(ohci->transceiver);
 
 	local_irq_save(flags);
-	ohci->transceiver->state = OTG_STATE_A_SUSPEND;
+	ohci->transceiver->state = USB_PHY_STATE_A_SUSPEND;
 	writel (RH_PS_PSS, &ohci->regs->roothub.portstatus [port]);
 	l = omap_readl(OTG_CTRL);
 	l &= ~OTG_A_BUSREQ;
diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 08f1d0b6..ee1c43e 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -148,29 +148,29 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl = musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "Poll devctl %02x (%s)\n", devctl,
-		otg_state_string(musb->xceiv->state));
+		usb_phy_state_string(musb->xceiv->state));
 
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		devctl &= ~MUSB_DEVCTL_SESSION;
 		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
 
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
-		musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+	case USB_PHY_STATE_A_WAIT_VFALL:
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, CORE_INTR_SRC_SET_REG,
 			    MUSB_INTR_VBUSERROR << AM35X_INTR_USB_SHIFT);
 		break;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		if (!is_peripheral_enabled(musb))
 			break;
 
@@ -178,7 +178,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -198,9 +198,10 @@ static void am35x_musb_try_idle(struct musb *musb, unsigned long timeout)
 
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || (musb->a_wait_bcon == 0 &&
-				musb->xceiv->state == OTG_STATE_A_WAIT_BCON)) {
+				musb->xceiv->state ==
+						USB_PHY_STATE_A_WAIT_BCON)) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		del_timer(&otg_workaround);
 		last_timer = jiffies;
 		return;
@@ -213,7 +214,7 @@ static void am35x_musb_try_idle(struct musb *musb, unsigned long timeout)
 	last_timer = timeout;
 
 	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&otg_workaround, timeout);
 }
@@ -283,27 +284,27 @@ static irqreturn_t am35x_musb_interrupt(int irq, void *hci)
 			 * devctl.
 			 */
 			musb->int_usb &= ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
 			musb->xceiv->default_a = 1;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
 			musb->xceiv->default_a = 0;
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
 
 		/* NOTE: this must complete power-on within 100 ms. */
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				otg_state_string(musb->xceiv->state),
+				usb_phy_state_string(musb->xceiv->state),
 				err ? " ERROR" : "",
 				devctl);
 		ret = IRQ_HANDLED;
@@ -323,7 +324,7 @@ eoi:
 	}
 
 	/* Poll for ID change */
-	if (is_otg_enabled(musb) && musb->xceiv->state == OTG_STATE_B_IDLE)
+	if (is_otg_enabled(musb) && musb->xceiv->state == USB_PHY_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index fc8e9ed..2f3e0b0 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -183,8 +183,8 @@ static irqreturn_t blackfin_interrupt(int irq, void *__hci)
 	}
 
 	/* Start sampling ID pin, when plug is removed from MUSB */
-	if ((is_otg_enabled(musb) && (musb->xceiv->state == OTG_STATE_B_IDLE
-		|| musb->xceiv->state == OTG_STATE_A_WAIT_BCON)) ||
+	if ((is_otg_enabled(musb) && (musb->xceiv->state == USB_PHY_STATE_B_IDLE
+		|| musb->xceiv->state == USB_PHY_STATE_A_WAIT_BCON)) ||
 		(musb->int_usb & MUSB_INTR_DISCONNECT && is_host_active(musb))) {
 		mod_timer(&musb_conn_timer, jiffies + TIMER_DELAY);
 		musb->a_wait_bcon = TIMER_DELAY;
@@ -204,8 +204,8 @@ static void musb_conn_timer_handler(unsigned long _musb)
 
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_IDLE:
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_IDLE:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		/* Start a new session */
 		val = musb_readw(musb->mregs, MUSB_DEVCTL);
 		val &= ~MUSB_DEVCTL_SESSION;
@@ -217,7 +217,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
 
 		if (!(val & MUSB_DEVCTL_BDEVICE)) {
 			gpio_set_value(musb->config->gpio_vrsel, 1);
-			musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		} else {
 			gpio_set_value(musb->config->gpio_vrsel, 0);
 			/* Ignore VBUSERROR and SUSPEND IRQ */
@@ -228,13 +228,13 @@ static void musb_conn_timer_handler(unsigned long _musb)
 			val = MUSB_INTR_SUSPEND | MUSB_INTR_VBUSERROR;
 			musb_writeb(musb->mregs, MUSB_INTRUSB, val);
 			if (is_otg_enabled(musb))
-				musb->xceiv->state = OTG_STATE_B_IDLE;
+				musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			else
 				musb_writeb(musb->mregs, MUSB_POWER, MUSB_POWER_HSENAB);
 		}
 		mod_timer(&musb_conn_timer, jiffies + TIMER_DELAY);
 		break;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 
 		if (!is_peripheral_enabled(musb))
 			break;
@@ -248,7 +248,7 @@ static void musb_conn_timer_handler(unsigned long _musb)
 
 		if (!(val & MUSB_DEVCTL_BDEVICE)) {
 			gpio_set_value(musb->config->gpio_vrsel, 1);
-			musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		} else {
 			gpio_set_value(musb->config->gpio_vrsel, 0);
 
@@ -283,13 +283,13 @@ static void musb_conn_timer_handler(unsigned long _musb)
 		break;
 	default:
 		dev_dbg(musb->controller, "%s state not handled\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		break;
 	}
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 	dev_dbg(musb->controller, "state is %s\n",
-		otg_state_string(musb->xceiv->state));
+		usb_phy_state_string(musb->xceiv->state));
 }
 
 static void bfin_musb_enable(struct musb *musb)
@@ -313,7 +313,7 @@ static void bfin_musb_set_vbus(struct musb *musb, int is_on)
 
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x "
 		/* otg %3x conf %08x prcm %08x */ "\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
 
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index 4da7492..fc982fa 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -196,24 +196,24 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl = musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "Poll devctl %02x (%s)\n", devctl,
-		otg_state_string(musb->xceiv->state));
+		usb_phy_state_string(musb->xceiv->state));
 
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		devctl &= ~MUSB_DEVCTL_SESSION;
 		musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
 
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		/*
 		 * Wait till VBUS falls below SessionEnd (~0.2 V); the 1.3
 		 * RTL seems to mis-handle session "start" otherwise (or in
@@ -224,11 +224,11 @@ static void otg_timer(unsigned long _musb)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			break;
 		}
-		musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, DA8XX_USB_INTR_SRC_SET_REG,
 			    MUSB_INTR_VBUSERROR << DA8XX_INTR_USB_SHIFT);
 		break;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		if (!is_peripheral_enabled(musb))
 			break;
 
@@ -249,7 +249,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -269,9 +269,10 @@ static void da8xx_musb_try_idle(struct musb *musb, unsigned long timeout)
 
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || (musb->a_wait_bcon == 0 &&
-				musb->xceiv->state == OTG_STATE_A_WAIT_BCON)) {
+				musb->xceiv->state ==
+						USB_PHY_STATE_A_WAIT_BCON)) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		del_timer(&otg_workaround);
 		last_timer = jiffies;
 		return;
@@ -284,7 +285,7 @@ static void da8xx_musb_try_idle(struct musb *musb, unsigned long timeout)
 	last_timer = timeout;
 
 	dev_dbg(musb->controller, "%s inactive, starting idle timer for %u ms\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&otg_workaround, timeout);
 }
@@ -345,26 +346,26 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *hci)
 			 * devctl.
 			 */
 			musb->int_usb &= ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
 			musb->xceiv->default_a = 1;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
 			musb->xceiv->default_a = 0;
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
 
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				otg_state_string(musb->xceiv->state),
+				usb_phy_state_string(musb->xceiv->state),
 				err ? " ERROR" : "",
 				devctl);
 		ret = IRQ_HANDLED;
@@ -379,7 +380,7 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void *hci)
 		musb_writel(reg_base, DA8XX_USB_END_OF_INTR_REG, 0);
 
 	/* Poll for ID change */
-	if (is_otg_enabled(musb) && musb->xceiv->state == OTG_STATE_B_IDLE)
+	if (is_otg_enabled(musb) && musb->xceiv->state == USB_PHY_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index f9a3f62..e80466b 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -216,11 +216,11 @@ static void otg_timer(unsigned long _musb)
 	 */
 	devctl = musb_readb(mregs, MUSB_DEVCTL);
 	dev_dbg(musb->controller, "poll devctl %02x (%s)\n", devctl,
-		otg_state_string(musb->xceiv->state));
+		usb_phy_state_string(musb->xceiv->state));
 
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		/* Wait till VBUS falls below SessionEnd (~0.2V); the 1.3 RTL
 		 * seems to mis-handle session "start" otherwise (or in our
 		 * case "recover"), in routine "VBUS was valid by the time
@@ -230,11 +230,11 @@ static void otg_timer(unsigned long _musb)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			break;
 		}
-		musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		musb_writel(musb->ctrl_base, DAVINCI_USB_INT_SET_REG,
 			MUSB_INTR_VBUSERROR << DAVINCI_USB_USBINT_SHIFT);
 		break;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		if (!is_peripheral_enabled(musb))
 			break;
 
@@ -255,7 +255,7 @@ static void otg_timer(unsigned long _musb)
 		if (devctl & MUSB_DEVCTL_BDEVICE)
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 		else
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 		break;
 	default:
 		break;
@@ -329,20 +329,20 @@ static irqreturn_t davinci_musb_interrupt(int irq, void *__hci)
 			 * to stop registering in devctl.
 			 */
 			musb->int_usb &= ~MUSB_INTR_VBUSERROR;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 			mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 			WARNING("VBUS error workaround (delay coming)\n");
 		} else if (is_host_enabled(musb) && drvvbus) {
 			MUSB_HST_MODE(musb);
 			musb->xceiv->default_a = 1;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			portstate(musb->port1_status |= USB_PORT_STAT_POWER);
 			del_timer(&otg_workaround);
 		} else {
 			musb->is_active = 0;
 			MUSB_DEV_MODE(musb);
 			musb->xceiv->default_a = 0;
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			portstate(musb->port1_status &= ~USB_PORT_STAT_POWER);
 		}
 
@@ -352,7 +352,7 @@ static irqreturn_t davinci_musb_interrupt(int irq, void *__hci)
 		davinci_musb_source_power(musb, drvvbus, 0);
 		dev_dbg(musb->controller, "VBUS %s (%s)%s, devctl %02x\n",
 				drvvbus ? "on" : "off",
-				otg_state_string(musb->xceiv->state),
+				usb_phy_state_string(musb->xceiv->state),
 				err ? " ERROR" : "",
 				devctl);
 		retval = IRQ_HANDLED;
@@ -366,7 +366,7 @@ static irqreturn_t davinci_musb_interrupt(int irq, void *__hci)
 
 	/* poll for ID change */
 	if (is_otg_enabled(musb)
-			&& musb->xceiv->state == OTG_STATE_B_IDLE)
+			&& musb->xceiv->state == USB_PHY_STATE_B_IDLE)
 		mod_timer(&otg_workaround, jiffies + POLL_SECONDS * HZ);
 
 	spin_unlock_irqrestore(&musb->lock, flags);
diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index b5beb7d..e7c97e6 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -338,22 +338,22 @@ void musb_otg_timer_func(unsigned long data)
 
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		dev_dbg(musb->controller, "HNP: b_wait_acon timeout; back to b_peripheral\n");
 		musb_g_disconnect(musb);
-		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		musb->is_active = 0;
 		break;
-	case OTG_STATE_A_SUSPEND:
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		dev_dbg(musb->controller, "HNP: %s timeout\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		musb_platform_set_vbus(musb, 0);
-		musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 		break;
 	default:
 		dev_dbg(musb->controller, "HNP: Unhandled mode %s\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 	}
 	musb->ignore_disconnect = 0;
 	spin_unlock_irqrestore(&musb->lock, flags);
@@ -368,18 +368,19 @@ void musb_hnp_stop(struct musb *musb)
 	void __iomem	*mbase = musb->mregs;
 	u8	reg;
 
-	dev_dbg(musb->controller, "HNP: stop from %s\n", otg_state_string(musb->xceiv->state));
+	dev_dbg(musb->controller, "HNP: stop from %s\n",
+			usb_phy_state_string(musb->xceiv->state));
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		musb_g_disconnect(musb);
 		dev_dbg(musb->controller, "HNP: back to %s\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		break;
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		dev_dbg(musb->controller, "HNP: Disabling HR\n");
 		hcd->self.is_b_host = 0;
-		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		MUSB_DEV_MODE(musb);
 		reg = musb_readb(mbase, MUSB_POWER);
 		reg |= MUSB_POWER_SUSPENDM;
@@ -388,7 +389,7 @@ void musb_hnp_stop(struct musb *musb)
 		break;
 	default:
 		dev_dbg(musb->controller, "HNP: Stopping in unknown state %s\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 	}
 
 	/*
@@ -425,13 +426,14 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 	 */
 	if (int_usb & MUSB_INTR_RESUME) {
 		handled = IRQ_HANDLED;
-		dev_dbg(musb->controller, "RESUME (%s)\n", otg_state_string(musb->xceiv->state));
+		dev_dbg(musb->controller, "RESUME (%s)\n",
+				usb_phy_state_string(musb->xceiv->state));
 
 		if (devctl & MUSB_DEVCTL_HM) {
 			void __iomem *mbase = musb->mregs;
 
 			switch (musb->xceiv->state) {
-			case OTG_STATE_A_SUSPEND:
+			case USB_PHY_STATE_A_SUSPEND:
 				/* remote wakeup?  later, GetPortStatus
 				 * will stop RESUME signaling
 				 */
@@ -453,29 +455,30 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				musb->rh_timer = jiffies
 						+ msecs_to_jiffies(20);
 
-				musb->xceiv->state = OTG_STATE_A_HOST;
+				musb->xceiv->state = USB_PHY_STATE_A_HOST;
 				musb->is_active = 1;
 				usb_hcd_resume_root_hub(musb_to_hcd(musb));
 				break;
-			case OTG_STATE_B_WAIT_ACON:
-				musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+			case USB_PHY_STATE_B_WAIT_ACON:
+				musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 				musb->is_active = 1;
 				MUSB_DEV_MODE(musb);
 				break;
 			default:
 				WARNING("bogus %s RESUME (%s)\n",
 					"host",
-					otg_state_string(musb->xceiv->state));
+					usb_phy_state_string(
+						musb->xceiv->state));
 			}
 		} else {
 			switch (musb->xceiv->state) {
-			case OTG_STATE_A_SUSPEND:
+			case USB_PHY_STATE_A_SUSPEND:
 				/* possibly DISCONNECT is upcoming */
-				musb->xceiv->state = OTG_STATE_A_HOST;
+				musb->xceiv->state = USB_PHY_STATE_A_HOST;
 				usb_hcd_resume_root_hub(musb_to_hcd(musb));
 				break;
-			case OTG_STATE_B_WAIT_ACON:
-			case OTG_STATE_B_PERIPHERAL:
+			case USB_PHY_STATE_B_WAIT_ACON:
+			case USB_PHY_STATE_B_PERIPHERAL:
 				/* disconnect while suspended?  we may
 				 * not get a disconnect irq...
 				 */
@@ -488,13 +491,14 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 				}
 				musb_g_resume(musb);
 				break;
-			case OTG_STATE_B_IDLE:
+			case USB_PHY_STATE_B_IDLE:
 				musb->int_usb &= ~MUSB_INTR_SUSPEND;
 				break;
 			default:
 				WARNING("bogus %s RESUME (%s)\n",
 					"peripheral",
-					otg_state_string(musb->xceiv->state));
+					usb_phy_state_string(
+						musb->xceiv->state));
 			}
 		}
 	}
@@ -510,7 +514,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		}
 
 		dev_dbg(musb->controller, "SESSION_REQUEST (%s)\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 
 		/* IRQ arrives from ID pin sense or (later, if VBUS power
 		 * is removed) SRP.  responses are time critical:
@@ -521,7 +525,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		 */
 		musb_writeb(mbase, MUSB_DEVCTL, MUSB_DEVCTL_SESSION);
 		musb->ep0_stage = MUSB_EP0_START;
-		musb->xceiv->state = OTG_STATE_A_IDLE;
+		musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 		MUSB_HST_MODE(musb);
 		musb_platform_set_vbus(musb, 1);
 
@@ -548,15 +552,15 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		 * make trouble here, keeping VBUS < 4.4V ?
 		 */
 		switch (musb->xceiv->state) {
-		case OTG_STATE_A_HOST:
+		case USB_PHY_STATE_A_HOST:
 			/* recovery is dicey once we've gotten past the
 			 * initial stages of enumeration, but if VBUS
 			 * stayed ok at the other end of the link, and
 			 * another reset is due (at least for high speed,
 			 * to redo the chirp etc), it might work OK...
 			 */
-		case OTG_STATE_A_WAIT_BCON:
-		case OTG_STATE_A_WAIT_VRISE:
+		case USB_PHY_STATE_A_WAIT_BCON:
+		case USB_PHY_STATE_A_WAIT_VRISE:
 			if (musb->vbuserr_retry) {
 				void __iomem *mbase = musb->mregs;
 
@@ -575,7 +579,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 		}
 
 		dev_dbg(musb->controller, "VBUS_ERROR in %s (%02x, %s), retry #%d, port1 %08x\n",
-				otg_state_string(musb->xceiv->state),
+				usb_phy_state_string(musb->xceiv->state),
 				devctl,
 				({ char *s;
 				switch (devctl & MUSB_DEVCTL_VBUS) {
@@ -600,11 +604,12 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 
 	if (int_usb & MUSB_INTR_SUSPEND) {
 		dev_dbg(musb->controller, "SUSPEND (%s) devctl %02x power %02x\n",
-			otg_state_string(musb->xceiv->state), devctl, power);
+			usb_phy_state_string(musb->xceiv->state), devctl,
+			power);
 		handled = IRQ_HANDLED;
 
 		switch (musb->xceiv->state) {
-		case OTG_STATE_A_PERIPHERAL:
+		case USB_PHY_STATE_A_PERIPHERAL:
 			/* We also come here if the cable is removed, since
 			 * this silicon doesn't report ID-no-longer-grounded.
 			 *
@@ -620,32 +625,32 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 						? : OTG_TIME_A_WAIT_BCON));
 
 			break;
-		case OTG_STATE_B_IDLE:
+		case USB_PHY_STATE_B_IDLE:
 			if (!musb->is_active)
 				break;
-		case OTG_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_B_PERIPHERAL:
 			musb_g_suspend(musb);
 			musb->is_active = is_otg_enabled(musb)
 					&& musb->xceiv->gadget->b_hnp_enable;
 			if (musb->is_active) {
-				musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
+				musb->xceiv->state = USB_PHY_STATE_B_WAIT_ACON;
 				dev_dbg(musb->controller, "HNP: Setting timer for b_ase0_brst\n");
 				mod_timer(&musb->otg_timer, jiffies
 					+ msecs_to_jiffies(
 							OTG_TIME_B_ASE0_BRST));
 			}
 			break;
-		case OTG_STATE_A_WAIT_BCON:
+		case USB_PHY_STATE_A_WAIT_BCON:
 			if (musb->a_wait_bcon != 0)
 				musb_platform_try_idle(musb, jiffies
 					+ msecs_to_jiffies(musb->a_wait_bcon));
 			break;
-		case OTG_STATE_A_HOST:
-			musb->xceiv->state = OTG_STATE_A_SUSPEND;
+		case USB_PHY_STATE_A_HOST:
+			musb->xceiv->state = USB_PHY_STATE_A_SUSPEND;
 			musb->is_active = is_otg_enabled(musb)
 					&& musb->xceiv->host->b_hnp_enable;
 			break;
-		case OTG_STATE_B_HOST:
+		case USB_PHY_STATE_B_HOST:
 			/* Transition to B_PERIPHERAL, see 6.8.2.6 p 44 */
 			dev_dbg(musb->controller, "REVISIT: SUSPEND as B_HOST\n");
 			break;
@@ -685,7 +690,7 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 
 		/* indicate new connection to OTG machine */
 		switch (musb->xceiv->state) {
-		case OTG_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_B_PERIPHERAL:
 			if (int_usb & MUSB_INTR_SUSPEND) {
 				dev_dbg(musb->controller, "HNP: SUSPEND+CONNECT, now b_host\n");
 				int_usb &= ~MUSB_INTR_SUSPEND;
@@ -693,10 +698,10 @@ static irqreturn_t musb_stage0_irq(struct musb *musb, u8 int_usb,
 			} else
 				dev_dbg(musb->controller, "CONNECT as b_peripheral???\n");
 			break;
-		case OTG_STATE_B_WAIT_ACON:
+		case USB_PHY_STATE_B_WAIT_ACON:
 			dev_dbg(musb->controller, "HNP: CONNECT, now b_host\n");
 b_host:
-			musb->xceiv->state = OTG_STATE_B_HOST;
+			musb->xceiv->state = USB_PHY_STATE_B_HOST;
 			hcd->self.is_b_host = 1;
 			musb->ignore_disconnect = 0;
 			del_timer(&musb->otg_timer);
@@ -704,7 +709,7 @@ b_host:
 		default:
 			if ((devctl & MUSB_DEVCTL_VBUS)
 					== (3 << MUSB_DEVCTL_VBUS_SHIFT)) {
-				musb->xceiv->state = OTG_STATE_A_HOST;
+				musb->xceiv->state = USB_PHY_STATE_A_HOST;
 				hcd->self.is_b_host = 0;
 			}
 			break;
@@ -718,25 +723,26 @@ b_host:
 			usb_hcd_resume_root_hub(hcd);
 
 		dev_dbg(musb->controller, "CONNECT (%s) devctl %02x\n",
-				otg_state_string(musb->xceiv->state), devctl);
+				usb_phy_state_string(musb->xceiv->state),
+				devctl);
 	}
 
 	if ((int_usb & MUSB_INTR_DISCONNECT) && !musb->ignore_disconnect) {
 		dev_dbg(musb->controller, "DISCONNECT (%s) as %s, devctl %02x\n",
-				otg_state_string(musb->xceiv->state),
+				usb_phy_state_string(musb->xceiv->state),
 				MUSB_MODE(musb), devctl);
 		handled = IRQ_HANDLED;
 
 		switch (musb->xceiv->state) {
-		case OTG_STATE_A_HOST:
-		case OTG_STATE_A_SUSPEND:
+		case USB_PHY_STATE_A_HOST:
+		case USB_PHY_STATE_A_SUSPEND:
 			usb_hcd_resume_root_hub(musb_to_hcd(musb));
 			musb_root_disconnect(musb);
 			if (musb->a_wait_bcon != 0 && is_otg_enabled(musb))
 				musb_platform_try_idle(musb, jiffies
 					+ msecs_to_jiffies(musb->a_wait_bcon));
 			break;
-		case OTG_STATE_B_HOST:
+		case USB_PHY_STATE_B_HOST:
 			/* REVISIT this behaves for "real disconnect"
 			 * cases; make sure the other transitions from
 			 * from B_HOST act right too.  The B_HOST code
@@ -744,23 +750,23 @@ b_host:
 			 */
 			musb_root_disconnect(musb);
 			musb_to_hcd(musb)->self.is_b_host = 0;
-			musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+			musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 			MUSB_DEV_MODE(musb);
 			musb_g_disconnect(musb);
 			break;
-		case OTG_STATE_A_PERIPHERAL:
+		case USB_PHY_STATE_A_PERIPHERAL:
 			musb_hnp_stop(musb);
 			musb_root_disconnect(musb);
 			/* FALLTHROUGH */
-		case OTG_STATE_B_WAIT_ACON:
+		case USB_PHY_STATE_B_WAIT_ACON:
 			/* FALLTHROUGH */
-		case OTG_STATE_B_PERIPHERAL:
-		case OTG_STATE_B_IDLE:
+		case USB_PHY_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_B_IDLE:
 			musb_g_disconnect(musb);
 			break;
 		default:
 			WARNING("unhandled DISCONNECT transition (%s)\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 			break;
 		}
 	}
@@ -786,9 +792,9 @@ b_host:
 			}
 		} else if (is_peripheral_capable()) {
 			dev_dbg(musb->controller, "BUS RESET as %s\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 			switch (musb->xceiv->state) {
-			case OTG_STATE_A_SUSPEND:
+			case USB_PHY_STATE_A_SUSPEND:
 				/* We need to ignore disconnect on suspend
 				 * otherwise tusb 2.0 won't reconnect after a
 				 * power cycle, which breaks otg compliance.
@@ -796,34 +802,37 @@ b_host:
 				musb->ignore_disconnect = 1;
 				musb_g_reset(musb);
 				/* FALLTHROUGH */
-			case OTG_STATE_A_WAIT_BCON:	/* OPT TD.4.7-900ms */
+			case USB_PHY_STATE_A_WAIT_BCON:	/* OPT TD.4.7-900ms */
 				/* never use invalid T(a_wait_bcon) */
 				dev_dbg(musb->controller, "HNP: in %s, %d msec timeout\n",
-					otg_state_string(musb->xceiv->state),
+					usb_phy_state_string(
+						musb->xceiv->state),
 					TA_WAIT_BCON(musb));
 				mod_timer(&musb->otg_timer, jiffies
 					+ msecs_to_jiffies(TA_WAIT_BCON(musb)));
 				break;
-			case OTG_STATE_A_PERIPHERAL:
+			case USB_PHY_STATE_A_PERIPHERAL:
 				musb->ignore_disconnect = 0;
 				del_timer(&musb->otg_timer);
 				musb_g_reset(musb);
 				break;
-			case OTG_STATE_B_WAIT_ACON:
+			case USB_PHY_STATE_B_WAIT_ACON:
 				dev_dbg(musb->controller, "HNP: RESET (%s), to b_peripheral\n",
-					otg_state_string(musb->xceiv->state));
-				musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+					usb_phy_state_string(
+						musb->xceiv->state));
+				musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 				musb_g_reset(musb);
 				break;
-			case OTG_STATE_B_IDLE:
-				musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+			case USB_PHY_STATE_B_IDLE:
+				musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 				/* FALLTHROUGH */
-			case OTG_STATE_B_PERIPHERAL:
+			case USB_PHY_STATE_B_PERIPHERAL:
 				musb_g_reset(musb);
 				break;
 			default:
 				dev_dbg(musb->controller, "Unhandled BUS RESET as %s\n",
-					otg_state_string(musb->xceiv->state));
+					usb_phy_state_string(
+						musb->xceiv->state));
 			}
 		}
 	}
@@ -1649,7 +1658,7 @@ musb_mode_show(struct device *dev, struct device_attribute *attr, char *buf)
 	int ret = -EINVAL;
 
 	spin_lock_irqsave(&musb->lock, flags);
-	ret = sprintf(buf, "%s\n", otg_state_string(musb->xceiv->state));
+	ret = sprintf(buf, "%s\n", usb_phy_state_string(musb->xceiv->state));
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 	return ret;
@@ -1694,7 +1703,7 @@ musb_vbus_store(struct device *dev, struct device_attribute *attr,
 	spin_lock_irqsave(&musb->lock, flags);
 	/* force T(a_wait_bcon) to be zero/unlimited *OR* valid */
 	musb->a_wait_bcon = val ? max_t(int, val, OTG_TIME_A_WAIT_BCON) : 0 ;
-	if (musb->xceiv->state == OTG_STATE_A_WAIT_BCON)
+	if (musb->xceiv->state == USB_PHY_STATE_A_WAIT_BCON)
 		musb->is_active = 0;
 	musb_platform_try_idle(musb, jiffies + msecs_to_jiffies(val));
 	spin_unlock_irqrestore(&musb->lock, flags);
@@ -1985,7 +1994,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 		MUSB_HST_MODE(musb);
 		musb->xceiv->default_a = 1;
-		musb->xceiv->state = OTG_STATE_A_IDLE;
+		musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 
 		status = usb_add_hcd(musb_to_hcd(musb), -1, 0);
 
@@ -2000,7 +2009,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 	} else /* peripheral is enabled */ {
 		MUSB_DEV_MODE(musb);
 		musb->xceiv->default_a = 0;
-		musb->xceiv->state = OTG_STATE_B_IDLE;
+		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 
 		status = musb_gadget_setup(musb);
 
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index ae4a20a..2b90282 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1597,7 +1597,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadget)
 	spin_lock_irqsave(&musb->lock, flags);
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		/* NOTE:  OTG state machine doesn't include B_SUSPENDED;
 		 * that's part of the standard usb 1.1 state machine, and
 		 * doesn't affect OTG transitions.
@@ -1605,7 +1605,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadget)
 		if (musb->may_wakeup && musb->is_suspended)
 			break;
 		goto done;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		/* Start SRP ... OTG not required. */
 		devctl = musb_readb(mregs, MUSB_DEVCTL);
 		dev_dbg(musb->controller, "Sending SRP: devctl: %02x\n", devctl);
@@ -1637,7 +1637,7 @@ static int musb_gadget_wakeup(struct usb_gadget *gadget)
 		goto done;
 	default:
 		dev_dbg(musb->controller, "Unhandled wake: %s\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		goto done;
 	}
 
@@ -1917,7 +1917,7 @@ static int musb_gadget_start(struct usb_gadget *g,
 	musb->is_active = 1;
 
 	otg_set_peripheral(musb->xceiv, &musb->g);
-	musb->xceiv->state = OTG_STATE_B_IDLE;
+	musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 
 	/*
 	 * FIXME this ignores the softconnect flag.  Drivers are
@@ -2032,7 +2032,7 @@ static int musb_gadget_stop(struct usb_gadget *g,
 
 	(void) musb_gadget_vbus_draw(&musb->g, 0);
 
-	musb->xceiv->state = OTG_STATE_UNDEFINED;
+	musb->xceiv->state = USB_PHY_STATE_UNDEFINED;
 	stop_activity(musb, driver);
 	otg_set_peripheral(musb->xceiv, NULL);
 
@@ -2066,10 +2066,10 @@ void musb_g_resume(struct musb *musb)
 {
 	musb->is_suspended = 0;
 	switch (musb->xceiv->state) {
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		break;
-	case OTG_STATE_B_WAIT_ACON:
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		musb->is_active = 1;
 		if (musb->gadget_driver && musb->gadget_driver->resume) {
 			spin_unlock(&musb->lock);
@@ -2079,7 +2079,7 @@ void musb_g_resume(struct musb *musb)
 		break;
 	default:
 		WARNING("unhandled RESUME transition (%s)\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 	}
 }
 
@@ -2092,11 +2092,11 @@ void musb_g_suspend(struct musb *musb)
 	dev_dbg(musb->controller, "devctl %02x\n", devctl);
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		if ((devctl & MUSB_DEVCTL_VBUS) == MUSB_DEVCTL_VBUS)
-			musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+			musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		musb->is_suspended = 1;
 		if (musb->gadget_driver && musb->gadget_driver->suspend) {
 			spin_unlock(&musb->lock);
@@ -2109,7 +2109,7 @@ void musb_g_suspend(struct musb *musb)
 		 * A_PERIPHERAL may need care too
 		 */
 		WARNING("unhandled SUSPEND transition (%s)\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 	}
 }
 
@@ -2143,21 +2143,21 @@ void musb_g_disconnect(struct musb *musb)
 	switch (musb->xceiv->state) {
 	default:
 		dev_dbg(musb->controller, "Unhandled disconnect %s, setting a_idle\n",
-			otg_state_string(musb->xceiv->state));
-		musb->xceiv->state = OTG_STATE_A_IDLE;
+			usb_phy_state_string(musb->xceiv->state));
+		musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 		MUSB_HST_MODE(musb);
 		break;
-	case OTG_STATE_A_PERIPHERAL:
-		musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+	case USB_PHY_STATE_A_PERIPHERAL:
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		MUSB_HST_MODE(musb);
 		break;
-	case OTG_STATE_B_WAIT_ACON:
-	case OTG_STATE_B_HOST:
-	case OTG_STATE_B_PERIPHERAL:
-	case OTG_STATE_B_IDLE:
-		musb->xceiv->state = OTG_STATE_B_IDLE;
+	case USB_PHY_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_HOST:
+	case USB_PHY_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_IDLE:
+		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 		break;
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		break;
 	}
 
@@ -2211,10 +2211,10 @@ __acquires(musb->lock)
 	 * or else after HNP, as A-Device
 	 */
 	if (devctl & MUSB_DEVCTL_BDEVICE) {
-		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		musb->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		musb->g.is_a_peripheral = 0;
 	} else if (is_otg_enabled(musb)) {
-		musb->xceiv->state = OTG_STATE_A_PERIPHERAL;
+		musb->xceiv->state = USB_PHY_STATE_A_PERIPHERAL;
 		musb->g.is_a_peripheral = 1;
 	} else
 		WARN_ON(1);
diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 60ddba8..a6e8cc6 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -2270,16 +2270,16 @@ static int musb_bus_suspend(struct usb_hcd *hcd)
 		return 0;
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		return 0;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		/* ID could be grounded even if there's no device
 		 * on the other end of the cable.  NOTE that the
 		 * A_WAIT_VRISE timers are messy with MUSB...
 		 */
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 		if ((devctl & MUSB_DEVCTL_VBUS) == MUSB_DEVCTL_VBUS)
-			musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		break;
 	default:
 		break;
@@ -2287,7 +2287,7 @@ static int musb_bus_suspend(struct usb_hcd *hcd)
 
 	if (musb->is_active) {
 		WARNING("trying to suspend as %s while active\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 		return -EBUSY;
 	} else
 		return 0;
diff --git a/drivers/usb/musb/musb_virthub.c b/drivers/usb/musb/musb_virthub.c
index e9f80ad..b36e704 100644
--- a/drivers/usb/musb/musb_virthub.c
+++ b/drivers/usb/musb/musb_virthub.c
@@ -78,8 +78,8 @@ static void musb_port_suspend(struct musb *musb, bool do_suspend)
 
 		musb->port1_status |= USB_PORT_STAT_SUSPEND;
 		switch (musb->xceiv->state) {
-		case OTG_STATE_A_HOST:
-			musb->xceiv->state = OTG_STATE_A_SUSPEND;
+		case USB_PHY_STATE_A_HOST:
+			musb->xceiv->state = USB_PHY_STATE_A_SUSPEND;
 			musb->is_active = is_otg_enabled(musb)
 					&& musb->xceiv->host->b_hnp_enable;
 			if (musb->is_active)
@@ -88,15 +88,15 @@ static void musb_port_suspend(struct musb *musb, bool do_suspend)
 						OTG_TIME_A_AIDL_BDIS));
 			musb_platform_try_idle(musb, 0);
 			break;
-		case OTG_STATE_B_HOST:
-			musb->xceiv->state = OTG_STATE_B_WAIT_ACON;
+		case USB_PHY_STATE_B_HOST:
+			musb->xceiv->state = USB_PHY_STATE_B_WAIT_ACON;
 			musb->is_active = is_otg_enabled(musb)
 					&& musb->xceiv->host->b_hnp_enable;
 			musb_platform_try_idle(musb, 0);
 			break;
 		default:
 			dev_dbg(musb->controller, "bogus rh suspend? %s\n",
-				otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 		}
 	} else if (power & MUSB_POWER_SUSPENDM) {
 		power &= ~MUSB_POWER_SUSPENDM;
@@ -116,7 +116,7 @@ static void musb_port_reset(struct musb *musb, bool do_reset)
 	u8		power;
 	void __iomem	*mbase = musb->mregs;
 
-	if (musb->xceiv->state == OTG_STATE_B_IDLE) {
+	if (musb->xceiv->state == USB_PHY_STATE_B_IDLE) {
 		dev_dbg(musb->controller, "HNP: Returning from HNP; no hub reset from b_idle\n");
 		musb->port1_status &= ~USB_PORT_STAT_RESET;
 		return;
@@ -186,24 +186,24 @@ void musb_root_disconnect(struct musb *musb)
 	musb->is_active = 0;
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		if (is_otg_enabled(musb)
 				&& musb->xceiv->host->b_hnp_enable) {
-			musb->xceiv->state = OTG_STATE_A_PERIPHERAL;
+			musb->xceiv->state = USB_PHY_STATE_A_PERIPHERAL;
 			musb->g.is_a_peripheral = 1;
 			break;
 		}
 		/* FALLTHROUGH */
-	case OTG_STATE_A_HOST:
-		musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+	case USB_PHY_STATE_A_HOST:
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		musb->is_active = 0;
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
-		musb->xceiv->state = OTG_STATE_B_IDLE;
+	case USB_PHY_STATE_A_WAIT_VFALL:
+		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 		break;
 	default:
 		dev_dbg(musb->controller, "host disconnect (%s)\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 	}
 }
 
@@ -339,7 +339,7 @@ int musb_hub_control(
 			musb->port1_status |= USB_PORT_STAT_C_SUSPEND << 16;
 			usb_hcd_poll_rh_status(musb_to_hcd(musb));
 			/* NOTE: it might really be A_WAIT_BCON ... */
-			musb->xceiv->state = OTG_STATE_A_HOST;
+			musb->xceiv->state = USB_PHY_STATE_A_HOST;
 		}
 
 		put_unaligned(cpu_to_le32(musb->port1_status
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index ba85f27..2cd9408 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -57,18 +57,18 @@ static void musb_do_idle(unsigned long _musb)
 	spin_lock_irqsave(&musb->lock, flags);
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		} else {
-			musb->xceiv->state = OTG_STATE_A_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		/* finish RESUME signaling? */
 		if (musb->port1_status & MUSB_PORT_STAT_RESUME) {
 			power = musb_readb(musb->mregs, MUSB_POWER);
@@ -81,15 +81,15 @@ static void musb_do_idle(unsigned long _musb)
 			musb->port1_status |= USB_PORT_STAT_C_SUSPEND << 16;
 			usb_hcd_poll_rh_status(musb_to_hcd(musb));
 			/* NOTE: it might really be A_WAIT_BCON ... */
-			musb->xceiv->state = OTG_STATE_A_HOST;
+			musb->xceiv->state = USB_PHY_STATE_A_HOST;
 		}
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 		if (devctl &  MUSB_DEVCTL_BDEVICE)
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 		else
-			musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 	default:
 		break;
 	}
@@ -107,9 +107,9 @@ static void omap2430_musb_try_idle(struct musb *musb, unsigned long timeout)
 
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || ((musb->a_wait_bcon == 0)
-			&& (musb->xceiv->state == OTG_STATE_A_WAIT_BCON))) {
+			&& (musb->xceiv->state == USB_PHY_STATE_A_WAIT_BCON))) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		del_timer(&musb_idle_timer);
 		last_timer = jiffies;
 		return;
@@ -126,7 +126,7 @@ static void omap2430_musb_try_idle(struct musb *musb, unsigned long timeout)
 	last_timer = timeout;
 
 	dev_dbg(musb->controller, "%s inactive, for idle timer for %lu ms\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		(unsigned long)jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&musb_idle_timer, timeout);
 }
@@ -144,7 +144,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 	devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
 
 	if (is_on) {
-		if (musb->xceiv->state == OTG_STATE_A_IDLE) {
+		if (musb->xceiv->state == USB_PHY_STATE_A_IDLE) {
 			/* start the session */
 			devctl |= MUSB_DEVCTL_SESSION;
 			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
@@ -169,7 +169,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 		} else {
 			musb->is_active = 1;
 			musb->xceiv->default_a = 1;
-			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+			musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			devctl |= MUSB_DEVCTL_SESSION;
 			MUSB_HST_MODE(musb);
 		}
@@ -181,7 +181,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 		 */
 
 		musb->xceiv->default_a = 0;
-		musb->xceiv->state = OTG_STATE_B_IDLE;
+		musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 		devctl &= ~MUSB_DEVCTL_SESSION;
 
 		MUSB_DEV_MODE(musb);
@@ -190,7 +190,7 @@ static void omap2430_musb_set_vbus(struct musb *musb, int is_on)
 
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x "
 		/* otg %3x conf %08x prcm %08x */ "\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL));
 }
 
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 38d5ce8..d7cae3d 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -414,15 +414,15 @@ static void musb_do_idle(unsigned long _musb)
 	spin_lock_irqsave(&musb->lock, flags);
 
 	switch (musb->xceiv->state) {
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		if ((musb->a_wait_bcon != 0)
 			&& (musb->idle_timeout == 0
 				|| time_after(jiffies, musb->idle_timeout))) {
 			dev_dbg(musb->controller, "Nothing connected %s, turning off VBUS\n",
-					otg_state_string(musb->xceiv->state));
+				usb_phy_state_string(musb->xceiv->state));
 		}
 		/* FALLTHROUGH */
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		tusb_musb_set_vbus(musb, 0);
 	default:
 		break;
@@ -473,9 +473,9 @@ static void tusb_musb_try_idle(struct musb *musb, unsigned long timeout)
 
 	/* Never idle if active, or when VBUS timeout is not set as host */
 	if (musb->is_active || ((musb->a_wait_bcon == 0)
-			&& (musb->xceiv->state == OTG_STATE_A_WAIT_BCON))) {
+			&& (musb->xceiv->state == USB_PHY_STATE_A_WAIT_BCON))) {
 		dev_dbg(musb->controller, "%s active, deleting timer\n",
-			otg_state_string(musb->xceiv->state));
+			usb_phy_state_string(musb->xceiv->state));
 		del_timer(&musb_idle_timer);
 		last_timer = jiffies;
 		return;
@@ -492,7 +492,7 @@ static void tusb_musb_try_idle(struct musb *musb, unsigned long timeout)
 	last_timer = timeout;
 
 	dev_dbg(musb->controller, "%s inactive, for idle timer for %lu ms\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		(unsigned long)jiffies_to_msecs(timeout - jiffies));
 	mod_timer(&musb_idle_timer, timeout);
 }
@@ -522,7 +522,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 	if (is_on) {
 		timer = OTG_TIMER_MS(OTG_TIME_A_WAIT_VRISE);
 		musb->xceiv->default_a = 1;
-		musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+		musb->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		devctl |= MUSB_DEVCTL_SESSION;
 
 		conf |= TUSB_DEV_CONF_USB_HOST_MODE;
@@ -536,15 +536,15 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 		otg_stat = musb_readl(tbase, TUSB_DEV_OTG_STAT);
 		if (!(otg_stat & TUSB_DEV_OTG_STAT_ID_STATUS)) {
 			switch (musb->xceiv->state) {
-			case OTG_STATE_A_WAIT_VRISE:
-			case OTG_STATE_A_WAIT_BCON:
-				musb->xceiv->state = OTG_STATE_A_WAIT_VFALL;
+			case USB_PHY_STATE_A_WAIT_VRISE:
+			case USB_PHY_STATE_A_WAIT_BCON:
+				musb->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 				break;
-			case OTG_STATE_A_WAIT_VFALL:
-				musb->xceiv->state = OTG_STATE_A_IDLE;
+			case USB_PHY_STATE_A_WAIT_VFALL:
+				musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 				break;
 			default:
-				musb->xceiv->state = OTG_STATE_A_IDLE;
+				musb->xceiv->state = USB_PHY_STATE_A_IDLE;
 			}
 			musb->is_active = 0;
 			musb->xceiv->default_a = 1;
@@ -552,7 +552,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 		} else {
 			musb->is_active = 0;
 			musb->xceiv->default_a = 0;
-			musb->xceiv->state = OTG_STATE_B_IDLE;
+			musb->xceiv->state = USB_PHY_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
 		}
 
@@ -567,7 +567,7 @@ static void tusb_musb_set_vbus(struct musb *musb, int is_on)
 	musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
 
 	dev_dbg(musb->controller, "VBUS %s, devctl %02x otg %3x conf %08x prcm %08x\n",
-		otg_state_string(musb->xceiv->state),
+		usb_phy_state_string(musb->xceiv->state),
 		musb_readb(musb->mregs, MUSB_DEVCTL),
 		musb_readl(tbase, TUSB_DEV_OTG_STAT),
 		conf, prcm);
@@ -678,24 +678,28 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 
 			if (otg_stat & TUSB_DEV_OTG_STAT_SESS_END) {
 				dev_dbg(musb->controller, "Forcing disconnect (no interrupt)\n");
-				if (musb->xceiv->state != OTG_STATE_B_IDLE) {
+				if (musb->xceiv->state !=
+						USB_PHY_STATE_B_IDLE) {
 					/* INTR_DISCONNECT can hide... */
-					musb->xceiv->state = OTG_STATE_B_IDLE;
+					musb->xceiv->state =
+						USB_PHY_STATE_B_IDLE;
 					musb->int_usb |= MUSB_INTR_DISCONNECT;
 				}
 				musb->is_active = 0;
 			}
 			dev_dbg(musb->controller, "vbus change, %s, otg %03x\n",
-				otg_state_string(musb->xceiv->state), otg_stat);
+				usb_phy_state_string(musb->xceiv->state),
+				otg_stat);
 			idle_timeout = jiffies + (1 * HZ);
 			schedule_work(&musb->irq_work);
 
 		} else /* A-dev state machine */ {
 			dev_dbg(musb->controller, "vbus change, %s, otg %03x\n",
-				otg_state_string(musb->xceiv->state), otg_stat);
+				usb_phy_state_string(musb->xceiv->state),
+				otg_stat);
 
 			switch (musb->xceiv->state) {
-			case OTG_STATE_A_IDLE:
+			case USB_PHY_STATE_A_IDLE:
 				dev_dbg(musb->controller, "Got SRP, turning on VBUS\n");
 				musb_platform_set_vbus(musb, 1);
 
@@ -712,12 +716,12 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 				idle_timeout = jiffies + (2 * HZ);
 
 				break;
-			case OTG_STATE_A_WAIT_VRISE:
+			case USB_PHY_STATE_A_WAIT_VRISE:
 				/* ignore; A-session-valid < VBUS_VALID/2,
 				 * we monitor this with the timer
 				 */
 				break;
-			case OTG_STATE_A_WAIT_VFALL:
+			case USB_PHY_STATE_A_WAIT_VFALL:
 				/* REVISIT this irq triggers during short
 				 * spikes caused by enumeration ...
 				 */
@@ -741,10 +745,10 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 		u8	devctl;
 
 		dev_dbg(musb->controller, "%s timer, %03x\n",
-			otg_state_string(musb->xceiv->state), otg_stat);
+			usb_phy_state_string(musb->xceiv->state), otg_stat);
 
 		switch (musb->xceiv->state) {
-		case OTG_STATE_A_WAIT_VRISE:
+		case USB_PHY_STATE_A_WAIT_VRISE:
 			/* VBUS has probably been valid for a while now,
 			 * but may well have bounced out of range a bit
 			 */
@@ -755,7 +759,7 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 					dev_dbg(musb->controller, "devctl %02x\n", devctl);
 					break;
 				}
-				musb->xceiv->state = OTG_STATE_A_WAIT_BCON;
+				musb->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 				musb->is_active = 0;
 				idle_timeout = jiffies
 					+ msecs_to_jiffies(musb->a_wait_bcon);
@@ -765,14 +769,14 @@ tusb_otg_ints(struct musb *musb, u32 int_src, void __iomem *tbase)
 				tusb_musb_set_vbus(musb, 0);
 			}
 			break;
-		case OTG_STATE_A_WAIT_BCON:
+		case USB_PHY_STATE_A_WAIT_BCON:
 			if (musb->a_wait_bcon != 0)
 				idle_timeout = jiffies
 					+ msecs_to_jiffies(musb->a_wait_bcon);
 			break;
-		case OTG_STATE_A_SUSPEND:
+		case USB_PHY_STATE_A_SUSPEND:
 			break;
-		case OTG_STATE_B_WAIT_ACON:
+		case USB_PHY_STATE_B_WAIT_ACON:
 			break;
 		default:
 			break;
diff --git a/drivers/usb/otg/ab8500-usb.c b/drivers/usb/otg/ab8500-usb.c
index 99a56af..366c3af 100644
--- a/drivers/usb/otg/ab8500-usb.c
+++ b/drivers/usb/otg/ab8500-usb.c
@@ -153,7 +153,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 	u8 reg;
 	enum ab8500_usb_link_status lsts;
 	void *v = NULL;
-	enum usb_xceiv_events event;
+	enum usb_phy_events event;
 
 	abx500_get_register_interruptible(ab->dev,
 			AB8500_USB,
@@ -169,7 +169,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 		/* TODO: Disable regulators. */
 		ab8500_usb_host_phy_dis(ab);
 		ab8500_usb_peri_phy_dis(ab);
-		ab->otg.state = OTG_STATE_B_IDLE;
+		ab->otg.state = USB_PHY_STATE_B_IDLE;
 		ab->otg.default_a = false;
 		ab->vbus_draw = 0;
 		event = USB_EVENT_NONE;
@@ -195,7 +195,7 @@ static int ab8500_usb_link_status_update(struct ab8500_usb *ab)
 			ab8500_usb_host_phy_en(ab);
 			v = ab->otg.host;
 		}
-		ab->otg.state = OTG_STATE_A_IDLE;
+		ab->otg.state = USB_PHY_STATE_A_IDLE;
 		ab->otg.default_a = true;
 		event = USB_EVENT_ID;
 		break;
@@ -317,7 +317,7 @@ static int ab8500_usb_set_peripheral(struct usb_phy *otg,
 		schedule_work(&ab->phy_dis_work);
 	} else {
 		ab->otg.gadget = gadget;
-		ab->otg.state = OTG_STATE_B_IDLE;
+		ab->otg.state = USB_PHY_STATE_B_IDLE;
 
 		/* Phy will not be enabled if cable is already
 		 * plugged-in. Schedule to enable phy.
@@ -492,7 +492,7 @@ static int __devinit ab8500_usb_probe(struct platform_device *pdev)
 	ab->rev			= rev;
 	ab->otg.dev		= ab->dev;
 	ab->otg.label		= "ab8500";
-	ab->otg.state		= OTG_STATE_UNDEFINED;
+	ab->otg.state		= USB_PHY_STATE_UNDEFINED;
 	ab->otg.set_host	= ab8500_usb_set_host;
 	ab->otg.set_peripheral	= ab8500_usb_set_peripheral;
 	ab->otg.set_suspend	= ab8500_usb_set_suspend;
diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 2f0678d..76125f7 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -275,7 +275,7 @@ void b_srp_end(unsigned long foo)
 	fsl_otg_dischrg_vbus(0);
 	srp_wait_done = 1;
 
-	if ((fsl_otg_dev->otg.state == OTG_STATE_B_SRP_INIT) &&
+	if ((fsl_otg_dev->otg.state == USB_PHY_STATE_B_SRP_INIT) &&
 	    fsl_otg_dev->fsm.b_sess_vld)
 		fsl_otg_dev->fsm.b_srp_done = 1;
 }
@@ -574,7 +574,7 @@ static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
 			/* Mini-A cable connected */
 			struct otg_fsm *fsm = &otg_dev->fsm;
 
-			otg_p->state = OTG_STATE_UNDEFINED;
+			otg_p->state = USB_PHY_STATE_UNDEFINED;
 			fsm->protocol = PROTO_UNDEF;
 		}
 	}
@@ -629,7 +629,7 @@ static int fsl_otg_set_power(struct usb_phy *otg_p, unsigned mA)
 {
 	if (!fsl_otg_dev)
 		return -ENODEV;
-	if (otg_p->state == OTG_STATE_B_PERIPHERAL)
+	if (otg_p->state == USB_PHY_STATE_B_PERIPHERAL)
 		pr_info("FSL OTG: Draw %d mA\n", mA);
 
 	return 0;
@@ -663,7 +663,7 @@ static int fsl_otg_start_srp(struct usb_phy *otg_p)
 	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
 
 	if (!otg_p || otg_dev != fsl_otg_dev
-	    || otg_p->state != OTG_STATE_B_IDLE)
+	    || otg_p->state != USB_PHY_STATE_B_IDLE)
 		return -ENODEV;
 
 	otg_dev->fsm.b_bus_req = 1;
@@ -826,7 +826,7 @@ int usb_otg_start(struct platform_device *pdev)
 	fsm = &p_otg->fsm;
 
 	/* Initialize the state machine structure with default values */
-	SET_OTG_STATE(otg_trans, OTG_STATE_UNDEFINED);
+	SET_OTG_STATE(otg_trans, USB_PHY_STATE_UNDEFINED);
 	fsm->transceiver = &p_otg->otg;
 
 	/* We don't require predefined MEM/IRQ resource index */
@@ -919,10 +919,10 @@ int usb_otg_start(struct platform_device *pdev)
 	 * Also: record initial state of ID pin
 	 */
 	if (fsl_readl(&p_otg->dr_mem_map->otgsc) & OTGSC_STS_USB_ID) {
-		p_otg->otg.state = OTG_STATE_UNDEFINED;
+		p_otg->otg.state = USB_PHY_STATE_UNDEFINED;
 		p_otg->fsm.id = 1;
 	} else {
-		p_otg->otg.state = OTG_STATE_A_IDLE;
+		p_otg->otg.state = USB_PHY_STATE_A_IDLE;
 		p_otg->fsm.id = 0;
 	}
 
@@ -978,7 +978,7 @@ static int show_fsl_usb2_otg_state(struct device *dev,
 	/* State */
 	t = scnprintf(next, size,
 		      "OTG state: %s\n\n",
-		      otg_state_string(fsl_otg_dev->otg.state));
+		      usb_phy_state_string(fsl_otg_dev->otg.state));
 	size -= t;
 	next += t;
 
diff --git a/drivers/usb/otg/fsl_otg.h b/drivers/usb/otg/fsl_otg.h
index caec254..33f3997 100644
--- a/drivers/usb/otg/fsl_otg.h
+++ b/drivers/usb/otg/fsl_otg.h
@@ -250,7 +250,7 @@
 /* Wait for B-Connect */
 #define TA_WAIT_BCON	(10000)  /* a_wait_bcon > 1 sec, section: 6.6.5.2
 				  * This is only used to get out of
-				  * OTG_STATE_A_WAIT_BCON state if there was
+				  * USB_PHY_STATE_A_WAIT_BCON state if there was
 				  * no connection for these many milliseconds
 				  */
 
diff --git a/drivers/usb/otg/gpio_vbus.c b/drivers/usb/otg/gpio_vbus.c
index 5e4c7a0..14f48e8 100644
--- a/drivers/usb/otg/gpio_vbus.c
+++ b/drivers/usb/otg/gpio_vbus.c
@@ -107,7 +107,7 @@ static void gpio_vbus_work(struct work_struct *work)
 	 */
 	gpio = pdata->gpio_pullup;
 	if (is_vbus_powered(pdata)) {
-		gpio_vbus->otg.state = OTG_STATE_B_PERIPHERAL;
+		gpio_vbus->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 		usb_gadget_vbus_connect(gpio_vbus->otg.gadget);
 
 		/* drawing a "unit load" is *always* OK, except for OTG */
@@ -124,7 +124,7 @@ static void gpio_vbus_work(struct work_struct *work)
 		set_vbus_draw(gpio_vbus, 0);
 
 		usb_gadget_vbus_disconnect(gpio_vbus->otg.gadget);
-		gpio_vbus->otg.state = OTG_STATE_B_IDLE;
+		gpio_vbus->otg.state = USB_PHY_STATE_B_IDLE;
 	}
 }
 
@@ -173,7 +173,7 @@ static int gpio_vbus_set_peripheral(struct usb_phy *otg,
 		set_vbus_draw(gpio_vbus, 0);
 
 		usb_gadget_vbus_disconnect(otg->gadget);
-		otg->state = OTG_STATE_UNDEFINED;
+		otg->state = USB_PHY_STATE_UNDEFINED;
 
 		otg->gadget = NULL;
 		return 0;
@@ -194,7 +194,7 @@ static int gpio_vbus_set_power(struct usb_phy *otg, unsigned mA)
 
 	gpio_vbus = container_of(otg, struct gpio_vbus_data, otg);
 
-	if (otg->state == OTG_STATE_B_PERIPHERAL)
+	if (otg->state == USB_PHY_STATE_B_PERIPHERAL)
 		set_vbus_draw(gpio_vbus, mA);
 	return 0;
 }
@@ -235,7 +235,7 @@ static int __init gpio_vbus_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, gpio_vbus);
 	gpio_vbus->dev = &pdev->dev;
 	gpio_vbus->otg.label = "gpio-vbus";
-	gpio_vbus->otg.state = OTG_STATE_UNDEFINED;
+	gpio_vbus->otg.state = USB_PHY_STATE_UNDEFINED;
 	gpio_vbus->otg.set_peripheral = gpio_vbus_set_peripheral;
 	gpio_vbus->otg.set_power = gpio_vbus_set_power;
 	gpio_vbus->otg.set_suspend = gpio_vbus_set_suspend;
diff --git a/drivers/usb/otg/isp1301_omap.c b/drivers/usb/otg/isp1301_omap.c
index 1bc2794..c9a9441 100644
--- a/drivers/usb/otg/isp1301_omap.c
+++ b/drivers/usb/otg/isp1301_omap.c
@@ -236,7 +236,7 @@ isp1301_clear_bits(struct isp1301 *isp, u8 reg, u8 bits)
 
 static inline const char *state_name(struct isp1301 *isp)
 {
-	return otg_state_string(isp->otg.state);
+	return usb_phy_state_string(isp->otg.state);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -251,7 +251,7 @@ static inline const char *state_name(struct isp1301 *isp)
 
 static void power_down(struct isp1301 *isp)
 {
-	isp->otg.state = OTG_STATE_UNDEFINED;
+	isp->otg.state = USB_PHY_STATE_UNDEFINED;
 
 	// isp1301_set_bits(isp, ISP1301_MODE_CONTROL_2, MC2_GLOBAL_PWR_DN);
 	isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_SUSPEND);
@@ -341,7 +341,7 @@ static void a_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
 
-	if (isp->otg.state == OTG_STATE_A_IDLE)
+	if (isp->otg.state == USB_PHY_STATE_A_IDLE)
 		return;
 
 	isp->otg.default_a = 1;
@@ -353,7 +353,7 @@ static void a_idle(struct isp1301 *isp, const char *tag)
 		isp->otg.gadget->is_a_peripheral = 1;
 		gadget_suspend(isp);
 	}
-	isp->otg.state = OTG_STATE_A_IDLE;
+	isp->otg.state = USB_PHY_STATE_A_IDLE;
 	l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl = l;
@@ -365,7 +365,7 @@ static void b_idle(struct isp1301 *isp, const char *tag)
 {
 	u32 l;
 
-	if (isp->otg.state == OTG_STATE_B_IDLE)
+	if (isp->otg.state == USB_PHY_STATE_B_IDLE)
 		return;
 
 	isp->otg.default_a = 0;
@@ -377,7 +377,7 @@ static void b_idle(struct isp1301 *isp, const char *tag)
 		isp->otg.gadget->is_a_peripheral = 0;
 		gadget_suspend(isp);
 	}
-	isp->otg.state = OTG_STATE_B_IDLE;
+	isp->otg.state = USB_PHY_STATE_B_IDLE;
 	l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 	omap_writel(l, OTG_CTRL);
 	isp->last_otg_ctrl = l;
@@ -415,7 +415,7 @@ dump_regs(struct isp1301 *isp, const char *label)
 
 static void check_state(struct isp1301 *isp, const char *tag)
 {
-	enum usb_otg_state	state = OTG_STATE_UNDEFINED;
+	enum usb_phy_state	state = USB_PHY_STATE_UNDEFINED;
 	u8			fsm = omap_readw(OTG_TEST) & 0x0ff;
 	unsigned		extra = 0;
 
@@ -423,16 +423,16 @@ static void check_state(struct isp1301 *isp, const char *tag)
 
 	/* default-b */
 	case 0x0:
-		state = OTG_STATE_B_IDLE;
+		state = USB_PHY_STATE_B_IDLE;
 		break;
 	case 0x3:
 	case 0x7:
 		extra = 1;
 	case 0x1:
-		state = OTG_STATE_B_PERIPHERAL;
+		state = USB_PHY_STATE_B_PERIPHERAL;
 		break;
 	case 0x11:
-		state = OTG_STATE_B_SRP_INIT;
+		state = USB_PHY_STATE_B_SRP_INIT;
 		break;
 
 	/* extra dual-role default-b states */
@@ -441,39 +441,39 @@ static void check_state(struct isp1301 *isp, const char *tag)
 	case 0x16:
 		extra = 1;
 	case 0x17:
-		state = OTG_STATE_B_WAIT_ACON;
+		state = USB_PHY_STATE_B_WAIT_ACON;
 		break;
 	case 0x34:
-		state = OTG_STATE_B_HOST;
+		state = USB_PHY_STATE_B_HOST;
 		break;
 
 	/* default-a */
 	case 0x36:
-		state = OTG_STATE_A_IDLE;
+		state = USB_PHY_STATE_A_IDLE;
 		break;
 	case 0x3c:
-		state = OTG_STATE_A_WAIT_VFALL;
+		state = USB_PHY_STATE_A_WAIT_VFALL;
 		break;
 	case 0x7d:
-		state = OTG_STATE_A_VBUS_ERR;
+		state = USB_PHY_STATE_A_VBUS_ERR;
 		break;
 	case 0x9e:
 	case 0x9f:
 		extra = 1;
 	case 0x89:
-		state = OTG_STATE_A_PERIPHERAL;
+		state = USB_PHY_STATE_A_PERIPHERAL;
 		break;
 	case 0xb7:
-		state = OTG_STATE_A_WAIT_VRISE;
+		state = USB_PHY_STATE_A_WAIT_VRISE;
 		break;
 	case 0xb8:
-		state = OTG_STATE_A_WAIT_BCON;
+		state = USB_PHY_STATE_A_WAIT_BCON;
 		break;
 	case 0xb9:
-		state = OTG_STATE_A_HOST;
+		state = USB_PHY_STATE_A_HOST;
 		break;
 	case 0xba:
-		state = OTG_STATE_A_SUSPEND;
+		state = USB_PHY_STATE_A_SUSPEND;
 		break;
 	default:
 		break;
@@ -481,7 +481,7 @@ static void check_state(struct isp1301 *isp, const char *tag)
 	if (isp->otg.state == state && !extra)
 		return;
 	pr_debug("otg: %s FSM %s/%02x, %s, %06x\n", tag,
-		otg_state_string(state), fsm, state_name(isp),
+		usb_phy_state_string(state), fsm, state_name(isp),
 		omap_readl(OTG_CTRL));
 }
 
@@ -502,22 +502,22 @@ static void update_otg1(struct isp1301 *isp, u8 int_src)
 
 	if (int_src & INTR_SESS_VLD)
 		otg_ctrl |= OTG_ASESSVLD;
-	else if (isp->otg.state == OTG_STATE_A_WAIT_VFALL) {
+	else if (isp->otg.state == USB_PHY_STATE_A_WAIT_VFALL) {
 		a_idle(isp, "vfall");
 		otg_ctrl &= ~OTG_CTRL_BITS;
 	}
 	if (int_src & INTR_VBUS_VLD)
 		otg_ctrl |= OTG_VBUSVLD;
 	if (int_src & INTR_ID_GND) {		/* default-A */
-		if (isp->otg.state == OTG_STATE_B_IDLE
-				|| isp->otg.state == OTG_STATE_UNDEFINED) {
+		if (isp->otg.state == USB_PHY_STATE_B_IDLE
+				|| isp->otg.state == USB_PHY_STATE_UNDEFINED) {
 			a_idle(isp, "init");
 			return;
 		}
 	} else {				/* default-B */
 		otg_ctrl |= OTG_ID;
-		if (isp->otg.state == OTG_STATE_A_IDLE
-				|| isp->otg.state == OTG_STATE_UNDEFINED) {
+		if (isp->otg.state == USB_PHY_STATE_A_IDLE
+				|| isp->otg.state == USB_PHY_STATE_UNDEFINED) {
 			b_idle(isp, "init");
 			return;
 		}
@@ -552,13 +552,13 @@ static void otg_update_isp(struct isp1301 *isp)
 	otg_ctrl = otg_ctrl & OTG_XCEIV_INPUTS;
 
 	switch (isp->otg.state) {
-	case OTG_STATE_B_IDLE:
-	case OTG_STATE_B_PERIPHERAL:
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_IDLE:
+	case USB_PHY_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_SRP_INIT:
 		if (!(otg_ctrl & OTG_PULLUP)) {
 			// if (otg_ctrl & OTG_B_HNPEN) {
 			if (isp->otg.gadget->b_hnp_enable) {
-				isp->otg.state = OTG_STATE_B_WAIT_ACON;
+				isp->otg.state = USB_PHY_STATE_B_WAIT_ACON;
 				pr_debug("  --> b_wait_acon\n");
 			}
 			goto pulldown;
@@ -567,12 +567,12 @@ pullup:
 		set |= OTG1_DP_PULLUP;
 		clr |= OTG1_DP_PULLDOWN;
 		break;
-	case OTG_STATE_A_SUSPEND:
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		if (otg_ctrl & OTG_PULLUP)
 			goto pullup;
 		/* FALLTHROUGH */
-	// case OTG_STATE_B_WAIT_ACON:
+	/* case USB_PHY_STATE_B_WAIT_ACON: */
 	default:
 pulldown:
 		set |= OTG1_DP_PULLDOWN;
@@ -589,7 +589,7 @@ pulldown:
 		otg_ctrl &= ~OTG_DRV_VBUS;
 
 	switch (isp->otg.state) {
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		if (otg_ctrl & OTG_DRV_VBUS) {
 			set |= OTG1_VBUS_DRV;
 			break;
@@ -598,17 +598,17 @@ pulldown:
 		notresponding(isp);
 
 		/* FALLTHROUGH */
-	case OTG_STATE_A_VBUS_ERR:
-		isp->otg.state = OTG_STATE_A_WAIT_VFALL;
+	case USB_PHY_STATE_A_VBUS_ERR:
+		isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 		pr_debug("  --> a_wait_vfall\n");
 		/* FALLTHROUGH */
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		/* FIXME usbcore thinks port power is still on ... */
 		clr |= OTG1_VBUS_DRV;
 		break;
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		if (otg_ctrl & OTG_DRV_VBUS) {
-			isp->otg.state = OTG_STATE_A_WAIT_VRISE;
+			isp->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
 			pr_debug("  --> a_wait_vrise\n");
 		}
 		/* FALLTHROUGH */
@@ -629,16 +629,16 @@ pulldown:
 		u32 l;
 
 		switch (isp->otg.state) {
-		case OTG_STATE_B_IDLE:
+		case USB_PHY_STATE_B_IDLE:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->otg.state = OTG_STATE_B_PERIPHERAL;
+			isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 			pr_debug("  --> b_peripheral\n");
 			break;
-		case OTG_STATE_A_SUSPEND:
+		case USB_PHY_STATE_A_SUSPEND:
 			if (clr & OTG1_DP_PULLUP)
 				break;
-			isp->otg.state = OTG_STATE_A_PERIPHERAL;
+			isp->otg.state = USB_PHY_STATE_A_PERIPHERAL;
 			pr_debug("  --> a_peripheral\n");
 			break;
 		default:
@@ -675,7 +675,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		 * remote wakeup (SRP, normal) using their own timer
 		 * to give "check cable and A-device" messages.
 		 */
-		if (isp->otg.state == OTG_STATE_B_SRP_INIT)
+		if (isp->otg.state == USB_PHY_STATE_B_SRP_INIT)
 			b_idle(isp, "srp_timeout");
 
 		omap_writew(B_SRP_TMROUT, OTG_IRQ_SRC);
@@ -693,7 +693,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		omap_writel(otg_ctrl, OTG_CTRL);
 
 		/* subset of b_peripheral()... */
-		isp->otg.state = OTG_STATE_B_PERIPHERAL;
+		isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 		pr_debug("  --> b_peripheral\n");
 
 		omap_writew(B_HNP_FAIL, OTG_IRQ_SRC);
@@ -706,7 +706,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 
 		isp1301_defer_work(isp, WORK_UPDATE_OTG);
 		switch (isp->otg.state) {
-		case OTG_STATE_A_IDLE:
+		case USB_PHY_STATE_A_IDLE:
 			if (!isp->otg.host)
 				break;
 			isp1301_defer_work(isp, WORK_HOST_RESUME);
@@ -736,7 +736,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |= OTG_BUSDROP;
 		otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->otg.state = OTG_STATE_A_WAIT_VFALL;
+		isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 
 		omap_writew(A_REQ_TMROUT, OTG_IRQ_SRC);
 		ret = IRQ_HANDLED;
@@ -750,7 +750,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		otg_ctrl |= OTG_BUSDROP;
 		otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK & ~OTG_XCEIV_INPUTS;
 		omap_writel(otg_ctrl, OTG_CTRL);
-		isp->otg.state = OTG_STATE_A_VBUS_ERR;
+		isp->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 
 		omap_writew(A_VBUS_ERR, OTG_IRQ_SRC);
 		ret = IRQ_HANDLED;
@@ -772,7 +772,7 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 		/* role is peripheral */
 		if (otg_ctrl & OTG_DRIVER_SEL) {
 			switch (isp->otg.state) {
-			case OTG_STATE_A_IDLE:
+			case USB_PHY_STATE_A_IDLE:
 				b_idle(isp, __func__);
 				break;
 			default:
@@ -789,17 +789,18 @@ static irqreturn_t omap_otg_irq(int irq, void *_isp)
 
 			if (isp->otg.host) {
 				switch (isp->otg.state) {
-				case OTG_STATE_B_WAIT_ACON:
-					isp->otg.state = OTG_STATE_B_HOST;
+				case USB_PHY_STATE_B_WAIT_ACON:
+					isp->otg.state = USB_PHY_STATE_B_HOST;
 					pr_debug("  --> b_host\n");
 					kick = 1;
 					break;
-				case OTG_STATE_A_WAIT_BCON:
-					isp->otg.state = OTG_STATE_A_HOST;
+				case USB_PHY_STATE_A_WAIT_BCON:
+					isp->otg.state = USB_PHY_STATE_A_HOST;
 					pr_debug("  --> a_host\n");
 					break;
-				case OTG_STATE_A_PERIPHERAL:
-					isp->otg.state = OTG_STATE_A_WAIT_BCON;
+				case USB_PHY_STATE_A_PERIPHERAL:
+					isp->otg.state =
+						USB_PHY_STATE_A_WAIT_BCON;
 					pr_debug("  --> a_wait_bcon\n");
 					break;
 				default:
@@ -940,7 +941,7 @@ static void b_peripheral(struct isp1301 *isp)
 	/* UDC driver just set OTG_BSESSVLD */
 	isp1301_set_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLUP);
 	isp1301_clear_bits(isp, ISP1301_OTG_CONTROL_1, OTG1_DP_PULLDOWN);
-	isp->otg.state = OTG_STATE_B_PERIPHERAL;
+	isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 	pr_debug("  --> b_peripheral\n");
 	dump_regs(isp, "2periph");
 #endif
@@ -949,7 +950,7 @@ static void b_peripheral(struct isp1301 *isp)
 static void isp_update_otg(struct isp1301 *isp, u8 stat)
 {
 	u8			isp_stat, isp_bstat;
-	enum usb_otg_state	state = isp->otg.state;
+	enum usb_phy_state	state = isp->otg.state;
 
 	if (stat & INTR_BDIS_ACON)
 		pr_debug("OTG:  BDIS_ACON, %s\n", state_name(isp));
@@ -959,44 +960,45 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 	if (isp_stat & INTR_ID_GND) {
 		if (isp->otg.default_a) {
 			switch (state) {
-			case OTG_STATE_B_IDLE:
+			case USB_PHY_STATE_B_IDLE:
 				a_idle(isp, "idle");
 				/* FALLTHROUGH */
-			case OTG_STATE_A_IDLE:
+			case USB_PHY_STATE_A_IDLE:
 				enable_vbus_source(isp);
 				/* FALLTHROUGH */
-			case OTG_STATE_A_WAIT_VRISE:
-				/* we skip over OTG_STATE_A_WAIT_BCON, since
+			case USB_PHY_STATE_A_WAIT_VRISE:
+				/* we skip over USB_PHY_STATE_A_WAIT_BCON, since
 				 * the HC will transition to A_HOST (or
 				 * A_SUSPEND!) without our noticing except
 				 * when HNP is used.
 				 */
 				if (isp_stat & INTR_VBUS_VLD)
-					isp->otg.state = OTG_STATE_A_HOST;
+					isp->otg.state = USB_PHY_STATE_A_HOST;
 				break;
-			case OTG_STATE_A_WAIT_VFALL:
+			case USB_PHY_STATE_A_WAIT_VFALL:
 				if (!(isp_stat & INTR_SESS_VLD))
 					a_idle(isp, "vfell");
 				break;
 			default:
 				if (!(isp_stat & INTR_VBUS_VLD))
-					isp->otg.state = OTG_STATE_A_VBUS_ERR;
+					isp->otg.state =
+						USB_PHY_STATE_A_VBUS_ERR;
 				break;
 			}
 			isp_bstat = isp1301_get_u8(isp, ISP1301_OTG_STATUS);
 		} else {
 			switch (state) {
-			case OTG_STATE_B_PERIPHERAL:
-			case OTG_STATE_B_HOST:
-			case OTG_STATE_B_WAIT_ACON:
+			case USB_PHY_STATE_B_PERIPHERAL:
+			case USB_PHY_STATE_B_HOST:
+			case USB_PHY_STATE_B_WAIT_ACON:
 				usb_gadget_vbus_disconnect(isp->otg.gadget);
 				break;
 			default:
 				break;
 			}
-			if (state != OTG_STATE_A_IDLE)
+			if (state != USB_PHY_STATE_A_IDLE)
 				a_idle(isp, "id");
-			if (isp->otg.host && state == OTG_STATE_A_IDLE)
+			if (isp->otg.host && state == USB_PHY_STATE_A_IDLE)
 				isp1301_defer_work(isp, WORK_HOST_RESUME);
 			isp_bstat = 0;
 		}
@@ -1009,34 +1011,34 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 		if (isp->otg.default_a) {
 			switch (state) {
 			default:
-				isp->otg.state = OTG_STATE_A_WAIT_VFALL;
+				isp->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 				break;
-			case OTG_STATE_A_WAIT_VFALL:
-				state = OTG_STATE_A_IDLE;
+			case USB_PHY_STATE_A_WAIT_VFALL:
+				state = USB_PHY_STATE_A_IDLE;
 				/* khubd may take a while to notice and
 				 * handle this disconnect, so don't go
 				 * to B_IDLE quite yet.
 				 */
 				break;
-			case OTG_STATE_A_IDLE:
+			case USB_PHY_STATE_A_IDLE:
 				host_suspend(isp);
 				isp1301_clear_bits(isp, ISP1301_MODE_CONTROL_1,
 						MC1_BDIS_ACON_EN);
-				isp->otg.state = OTG_STATE_B_IDLE;
+				isp->otg.state = USB_PHY_STATE_B_IDLE;
 				l = omap_readl(OTG_CTRL) & OTG_CTRL_MASK;
 				l &= ~OTG_CTRL_BITS;
 				omap_writel(l, OTG_CTRL);
 				break;
-			case OTG_STATE_B_IDLE:
+			case USB_PHY_STATE_B_IDLE:
 				break;
 			}
 		}
 		isp_bstat = isp1301_get_u8(isp, ISP1301_OTG_STATUS);
 
 		switch (isp->otg.state) {
-		case OTG_STATE_B_PERIPHERAL:
-		case OTG_STATE_B_WAIT_ACON:
-		case OTG_STATE_B_HOST:
+		case USB_PHY_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_B_WAIT_ACON:
+		case USB_PHY_STATE_B_HOST:
 			if (likely(isp_bstat & OTG_B_SESS_VLD))
 				break;
 			enable_vbus_draw(isp, 0);
@@ -1049,12 +1051,12 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 			dump_regs(isp, __func__);
 #endif
 			/* FALLTHROUGH */
-		case OTG_STATE_B_SRP_INIT:
+		case USB_PHY_STATE_B_SRP_INIT:
 			b_idle(isp, __func__);
 			l = omap_readl(OTG_CTRL) & OTG_XCEIV_OUTPUTS;
 			omap_writel(l, OTG_CTRL);
 			/* FALLTHROUGH */
-		case OTG_STATE_B_IDLE:
+		case USB_PHY_STATE_B_IDLE:
 			if (isp->otg.gadget && (isp_bstat & OTG_B_SESS_VLD)) {
 #ifdef	CONFIG_USB_OTG
 				update_otg1(isp, isp_stat);
@@ -1064,7 +1066,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 			} else if (!(isp_stat & (INTR_VBUS_VLD|INTR_SESS_VLD)))
 				isp_bstat |= OTG_B_SESS_END;
 			break;
-		case OTG_STATE_A_WAIT_VFALL:
+		case USB_PHY_STATE_A_WAIT_VFALL:
 			break;
 		default:
 			pr_debug("otg: unsupported b-device %s\n",
@@ -1075,7 +1077,7 @@ static void isp_update_otg(struct isp1301 *isp, u8 stat)
 
 	if (state != isp->otg.state)
 		pr_debug("  isp, %s -> %s\n",
-				otg_state_string(state), state_name(isp));
+				usb_phy_state_string(state), state_name(isp));
 
 #ifdef	CONFIG_USB_OTG
 	/* update the OTG controller state to match the isp1301; may
@@ -1132,9 +1134,9 @@ isp1301_work(struct work_struct *work)
 			 * skip A_WAIT_BCON; same.
 			 */
 			switch (isp->otg.state) {
-			case OTG_STATE_A_WAIT_BCON:
-			case OTG_STATE_A_WAIT_VRISE:
-				isp->otg.state = OTG_STATE_A_HOST;
+			case USB_PHY_STATE_A_WAIT_BCON:
+			case USB_PHY_STATE_A_WAIT_VRISE:
+				isp->otg.state = USB_PHY_STATE_A_HOST;
 				pr_debug("  --> a_host\n");
 				otg_ctrl = omap_readl(OTG_CTRL);
 				otg_ctrl |= OTG_A_BUSREQ;
@@ -1142,13 +1144,13 @@ isp1301_work(struct work_struct *work)
 						& OTG_CTRL_MASK;
 				omap_writel(otg_ctrl, OTG_CTRL);
 				break;
-			case OTG_STATE_B_WAIT_ACON:
-				isp->otg.state = OTG_STATE_B_HOST;
+			case USB_PHY_STATE_B_WAIT_ACON:
+				isp->otg.state = USB_PHY_STATE_B_HOST;
 				pr_debug("  --> b_host (acon)\n");
 				break;
-			case OTG_STATE_B_HOST:
-			case OTG_STATE_B_IDLE:
-			case OTG_STATE_A_IDLE:
+			case USB_PHY_STATE_B_HOST:
+			case USB_PHY_STATE_B_IDLE:
+			case USB_PHY_STATE_A_IDLE:
 				break;
 			default:
 				pr_debug("  host resume in %s\n",
@@ -1368,7 +1370,7 @@ isp1301_set_peripheral(struct usb_phy *otg, struct usb_gadget *gadget)
 	omap_writel(l, OTG_CTRL);
 
 	power_up(isp);
-	isp->otg.state = OTG_STATE_B_IDLE;
+	isp->otg.state = USB_PHY_STATE_B_IDLE;
 
 	if (machine_is_omap_h2() || machine_is_omap_h3())
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1, MC1_DAT_SE0);
@@ -1403,7 +1405,7 @@ isp1301_set_power(struct usb_phy *dev, unsigned mA)
 {
 	if (!the_transceiver)
 		return -ENODEV;
-	if (dev->state == OTG_STATE_B_PERIPHERAL)
+	if (dev->state == USB_PHY_STATE_B_PERIPHERAL)
 		enable_vbus_draw(the_transceiver, mA);
 	return 0;
 }
@@ -1415,7 +1417,7 @@ isp1301_start_srp(struct usb_phy *dev)
 	u32		otg_ctrl;
 
 	if (!dev || isp != the_transceiver
-			|| isp->otg.state != OTG_STATE_B_IDLE)
+			|| isp->otg.state != USB_PHY_STATE_B_IDLE)
 		return -ENODEV;
 
 	otg_ctrl = omap_readl(OTG_CTRL);
@@ -1425,7 +1427,7 @@ isp1301_start_srp(struct usb_phy *dev)
 	otg_ctrl |= OTG_B_BUSREQ;
 	otg_ctrl &= ~OTG_A_BUSREQ & OTG_CTRL_MASK;
 	omap_writel(otg_ctrl, OTG_CTRL);
-	isp->otg.state = OTG_STATE_B_SRP_INIT;
+	isp->otg.state = USB_PHY_STATE_B_SRP_INIT;
 
 	pr_debug("otg: SRP, %s ... %06x\n", state_name(isp),
 			omap_readl(OTG_CTRL));
@@ -1455,11 +1457,11 @@ isp1301_start_hnp(struct usb_phy *dev)
 	 * So do this part as early as possible...
 	 */
 	switch (isp->otg.state) {
-	case OTG_STATE_B_HOST:
-		isp->otg.state = OTG_STATE_B_PERIPHERAL;
+	case USB_PHY_STATE_B_HOST:
+		isp->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 		/* caller will suspend next */
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 #if 0
 		/* autoconnect mode avoids irq latency bugs */
 		isp1301_set_bits(isp, ISP1301_MODE_CONTROL_1,
@@ -1472,7 +1474,7 @@ isp1301_start_hnp(struct usb_phy *dev)
 		omap_writel(l, OTG_CTRL);
 
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		/* initiated by B-Host suspend */
 		break;
 	default:
diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
index 880cdf2..54ab373 100644
--- a/drivers/usb/otg/langwell_otg.c
+++ b/drivers/usb/otg/langwell_otg.c
@@ -683,12 +683,12 @@ static void init_hsm(void)
 		iotg->hsm.id = 1;
 		iotg->otg.default_a = 0;
 		set_client_mode();
-		iotg->otg.state = OTG_STATE_B_IDLE;
+		iotg->otg.state = USB_PHY_STATE_B_IDLE;
 	} else {
 		iotg->hsm.id = 0;
 		iotg->otg.default_a = 1;
 		set_host_mode();
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 	}
 
 	/* set session indicator */
@@ -934,11 +934,11 @@ static void langwell_otg_work(struct work_struct *work)
 	pdev = to_pci_dev(lnw->dev);
 
 	dev_dbg(lnw->dev, "%s: old state = %s\n", __func__,
-			otg_state_string(iotg->otg.state));
+			usb_phy_state_string(iotg->otg.state));
 
 	switch (iotg->otg.state) {
-	case OTG_STATE_UNDEFINED:
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_UNDEFINED:
+	case USB_PHY_STATE_B_IDLE:
 		if (!iotg->hsm.id) {
 			langwell_otg_del_timer(b_srp_init_tmr);
 			del_timer_sync(&lnw->hsm_timer);
@@ -950,7 +950,7 @@ static void langwell_otg_work(struct work_struct *work)
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
 
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.b_sess_vld) {
 			langwell_otg_del_timer(b_srp_init_tmr);
@@ -961,7 +961,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			if (lnw->iotg.start_peripheral) {
 				lnw->iotg.start_peripheral(&lnw->iotg);
-				iotg->otg.state = OTG_STATE_B_PERIPHERAL;
+				iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 			} else
 				dev_dbg(lnw->dev, "client driver not loaded\n");
 
@@ -996,7 +996,7 @@ static void langwell_otg_work(struct work_struct *work)
 			}
 		}
 		break;
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		if (!iotg->hsm.id) {
 			iotg->otg.default_a = 1;
 			iotg->hsm.a_srp_det = 0;
@@ -1006,18 +1006,18 @@ static void langwell_otg_work(struct work_struct *work)
 			langwell_otg_chrg_vbus(0);
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.b_sess_vld) {
 			langwell_otg_chrg_vbus(0);
 			if (lnw->iotg.start_peripheral) {
 				lnw->iotg.start_peripheral(&lnw->iotg);
-				iotg->otg.state = OTG_STATE_B_PERIPHERAL;
+				iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 			} else
 				dev_dbg(lnw->dev, "client driver not loaded\n");
 		}
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		if (!iotg->hsm.id) {
 			iotg->otg.default_a = 1;
 			iotg->hsm.a_srp_det = 0;
@@ -1032,7 +1032,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			iotg->hsm.b_hnp_enable = 0;
@@ -1043,7 +1043,7 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 					"client driver has been removed.\n");
 
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		} else if (iotg->hsm.b_bus_req && iotg->otg.gadget &&
 					iotg->otg.gadget->b_hnp_enable &&
 					iotg->hsm.a_bus_suspend) {
@@ -1059,7 +1059,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			if (lnw->iotg.start_host) {
 				lnw->iotg.start_host(&lnw->iotg);
-				iotg->otg.state = OTG_STATE_B_WAIT_ACON;
+				iotg->otg.state = USB_PHY_STATE_B_WAIT_ACON;
 			} else
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
@@ -1069,7 +1069,7 @@ static void langwell_otg_work(struct work_struct *work)
 		}
 		break;
 
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		if (!iotg->hsm.id) {
 			/* delete hsm timer for b_ase0_brst_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1088,7 +1088,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			/* delete hsm timer for b_ase0_brst_tmr */
@@ -1108,13 +1108,13 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		} else if (iotg->hsm.a_conn) {
 			/* delete hsm timer for b_ase0_brst_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
 			langwell_otg_HAAR(0);
-			iotg->otg.state = OTG_STATE_B_HOST;
+			iotg->otg.state = USB_PHY_STATE_B_HOST;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_resume ||
 				iotg->hsm.b_ase0_brst_tmout) {
@@ -1139,11 +1139,11 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 					"client driver not loaded.\n");
 
-			iotg->otg.state = OTG_STATE_B_PERIPHERAL;
+			iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 		}
 		break;
 
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		if (!iotg->hsm.id) {
 			iotg->otg.default_a = 1;
 			iotg->hsm.a_srp_det = 0;
@@ -1158,7 +1158,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			iotg->hsm.b_hnp_enable = 0;
@@ -1173,7 +1173,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		} else if ((!iotg->hsm.b_bus_req) ||
 				(!iotg->hsm.a_conn)) {
 			iotg->hsm.b_bus_req = 0;
@@ -1193,11 +1193,11 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"client driver not loaded.\n");
 
-			iotg->otg.state = OTG_STATE_B_PERIPHERAL;
+			iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
 		}
 		break;
 
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		iotg->otg.default_a = 1;
 		if (iotg->hsm.id) {
 			iotg->otg.default_a = 0;
@@ -1207,7 +1207,7 @@ static void langwell_otg_work(struct work_struct *work)
 			langwell_otg_chrg_vbus(0);
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_bus_drop &&
 			(iotg->hsm.a_srp_det || iotg->hsm.a_bus_req)) {
@@ -1219,7 +1219,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->hsm.vbus_srp_up = 0;
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = OTG_STATE_A_WAIT_VRISE;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_bus_drop && iotg->hsm.a_sess_vld) {
 			iotg->hsm.vbus_srp_up = 1;
@@ -1233,14 +1233,14 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->hsm.vbus_srp_up = 0;
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = OTG_STATE_A_WAIT_VRISE;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_sess_vld &&
 				!iotg->hsm.vbus_srp_up) {
 			langwell_otg_phy_low_power(1);
 		}
 		break;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		if (iotg->hsm.id) {
 			langwell_otg_del_timer(a_wait_vrise_tmr);
 			iotg->hsm.b_bus_req = 0;
@@ -1250,7 +1250,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		} else if (iotg->hsm.a_vbus_vld) {
 			langwell_otg_del_timer(a_wait_vrise_tmr);
 			iotg->hsm.b_conn = 0;
@@ -1262,7 +1262,7 @@ static void langwell_otg_work(struct work_struct *work)
 			}
 
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = OTG_STATE_A_WAIT_BCON;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
 		} else if (iotg->hsm.a_wait_vrise_tmout) {
 			iotg->hsm.b_conn = 0;
 			if (iotg->hsm.a_vbus_vld) {
@@ -1274,17 +1274,17 @@ static void langwell_otg_work(struct work_struct *work)
 					break;
 				}
 				langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-				iotg->otg.state = OTG_STATE_A_WAIT_BCON;
+				iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
 			} else {
 
 				/* Turn off VBus */
 				iotg->otg.set_vbus(&iotg->otg, false);
 				langwell_otg_phy_low_power_wait(1);
-				iotg->otg.state = OTG_STATE_A_VBUS_ERR;
+				iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 			}
 		}
 		break;
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		if (iotg->hsm.id) {
 			/* delete hsm timer for a_wait_bcon_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1302,7 +1302,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_vbus_vld) {
 			/* delete hsm timer for a_wait_bcon_tmr */
@@ -1317,7 +1317,7 @@ static void langwell_otg_work(struct work_struct *work)
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_A_VBUS_ERR;
+			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 		} else if (iotg->hsm.a_bus_drop ||
 				(iotg->hsm.a_wait_bcon_tmout &&
 				!iotg->hsm.a_bus_req)) {
@@ -1332,13 +1332,13 @@ static void langwell_otg_work(struct work_struct *work)
 
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = OTG_STATE_A_WAIT_VFALL;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (iotg->hsm.b_conn) {
 			/* delete hsm timer for a_wait_bcon_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
 			iotg->hsm.a_suspend_req = 0;
-			iotg->otg.state = OTG_STATE_A_HOST;
+			iotg->otg.state = USB_PHY_STATE_A_HOST;
 			if (iotg->hsm.a_srp_det && iotg->otg.host &&
 					!iotg->otg.host->b_hnp_enable) {
 				/* SRP capable peripheral-only device */
@@ -1369,7 +1369,7 @@ static void langwell_otg_work(struct work_struct *work)
 				/* clear PHCD to enable HW timer */
 				langwell_otg_phy_low_power(0);
 				langwell_otg_add_timer(a_aidl_bdis_tmr);
-				iotg->otg.state = OTG_STATE_A_SUSPEND;
+				iotg->otg.state = USB_PHY_STATE_A_SUSPEND;
 			} else if (!iotg->hsm.a_bus_req && iotg->otg.host &&
 				!iotg->otg.host->b_hnp_enable) {
 				if (lnw->iotg.stop_host)
@@ -1380,11 +1380,11 @@ static void langwell_otg_work(struct work_struct *work)
 
 				/* Turn off VBus */
 				iotg->otg.set_vbus(&iotg->otg, false);
-				iotg->otg.state = OTG_STATE_A_WAIT_VFALL;
+				iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 			}
 		}
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		if (iotg->hsm.id) {
 			iotg->otg.default_a = 0;
 			iotg->hsm.b_bus_req = 0;
@@ -1399,7 +1399,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_drop ||
 				(iotg->otg.host &&
@@ -1413,7 +1413,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = OTG_STATE_A_WAIT_VFALL;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (!iotg->hsm.a_vbus_vld) {
 			if (lnw->iotg.stop_host)
 				lnw->iotg.stop_host(&lnw->iotg);
@@ -1424,7 +1424,7 @@ static void langwell_otg_work(struct work_struct *work)
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_A_VBUS_ERR;
+			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 		} else if (iotg->otg.host &&
 				iotg->otg.host->b_hnp_enable &&
 				!iotg->hsm.a_bus_req) {
@@ -1449,13 +1449,13 @@ static void langwell_otg_work(struct work_struct *work)
 			/* clear PHCD to enable HW timer */
 			langwell_otg_phy_low_power(0);
 			langwell_otg_add_timer(a_aidl_bdis_tmr);
-			iotg->otg.state = OTG_STATE_A_SUSPEND;
+			iotg->otg.state = USB_PHY_STATE_A_SUSPEND;
 		} else if (!iotg->hsm.b_conn || !iotg->hsm.a_bus_req) {
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = OTG_STATE_A_WAIT_BCON;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
 		}
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		if (iotg->hsm.id) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
 			langwell_otg_HABA(0);
@@ -1473,7 +1473,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_req ||
 				iotg->hsm.b_bus_resume) {
@@ -1482,7 +1482,7 @@ static void langwell_otg_work(struct work_struct *work)
 			free_irq(pdev->irq, iotg->base);
 			iotg->hsm.a_suspend_req = 0;
 			langwell_otg_loc_sof(1);
-			iotg->otg.state = OTG_STATE_A_HOST;
+			iotg->otg.state = USB_PHY_STATE_A_HOST;
 		} else if (iotg->hsm.a_aidl_bdis_tmout ||
 				iotg->hsm.a_bus_drop) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
@@ -1496,7 +1496,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = OTG_STATE_A_WAIT_VFALL;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (!iotg->hsm.b_conn && iotg->otg.host &&
 				iotg->otg.host->b_hnp_enable) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
@@ -1520,7 +1520,7 @@ static void langwell_otg_work(struct work_struct *work)
 					"client driver not loaded.\n");
 
 			langwell_otg_add_ktimer(TB_BUS_SUSPEND_TMR);
-			iotg->otg.state = OTG_STATE_A_PERIPHERAL;
+			iotg->otg.state = USB_PHY_STATE_A_PERIPHERAL;
 			break;
 		} else if (!iotg->hsm.a_vbus_vld) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
@@ -1535,10 +1535,10 @@ static void langwell_otg_work(struct work_struct *work)
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_A_VBUS_ERR;
+			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 		}
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		if (iotg->hsm.id) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1554,7 +1554,7 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_vbus_vld) {
 			/* delete hsm timer for b_bus_suspend_tmr */
@@ -1569,7 +1569,7 @@ static void langwell_otg_work(struct work_struct *work)
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = OTG_STATE_A_VBUS_ERR;
+			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
 		} else if (iotg->hsm.a_bus_drop) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1582,7 +1582,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			/* Turn off VBus */
 			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = OTG_STATE_A_WAIT_VFALL;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (iotg->hsm.b_bus_suspend) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1599,7 +1599,7 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = OTG_STATE_A_WAIT_BCON;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
 		} else if (iotg->hsm.b_bus_suspend_tmout) {
 			u32	val;
 			val = readl(lnw->iotg.base + CI_PORTSC1);
@@ -1618,24 +1618,24 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = OTG_STATE_A_WAIT_BCON;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
 		}
 		break;
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		if (iotg->hsm.id) {
 			iotg->otg.default_a = 0;
 			iotg->hsm.a_clr_err = 0;
 			iotg->hsm.a_srp_det = 0;
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_clr_err) {
 			iotg->hsm.a_clr_err = 0;
 			iotg->hsm.a_srp_det = 0;
 			reset_otg();
 			init_hsm();
-			if (iotg->otg.state == OTG_STATE_A_IDLE)
+			if (iotg->otg.state == USB_PHY_STATE_A_IDLE)
 				langwell_update_transceiver();
 		} else {
 			/* FW will clear PHCD bit when any VBus
@@ -1643,12 +1643,12 @@ static void langwell_otg_work(struct work_struct *work)
 			langwell_otg_phy_low_power(1);
 		}
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		if (iotg->hsm.id) {
 			iotg->otg.default_a = 0;
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_B_IDLE;
+			iotg->otg.state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_req) {
 
@@ -1656,12 +1656,12 @@ static void langwell_otg_work(struct work_struct *work)
 			iotg->otg.set_vbus(&iotg->otg, true);
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = OTG_STATE_A_WAIT_VRISE;
+			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
 		} else if (!iotg->hsm.a_sess_vld) {
 			iotg->hsm.a_srp_det = 0;
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = OTG_STATE_A_IDLE;
+			iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		}
 		break;
 	default:
@@ -1669,7 +1669,7 @@ static void langwell_otg_work(struct work_struct *work)
 	}
 
 	dev_dbg(lnw->dev, "%s: new state = %s\n", __func__,
-			otg_state_string(iotg->otg.state));
+			usb_phy_state_string(iotg->otg.state));
 }
 
 static ssize_t
@@ -1755,7 +1755,7 @@ show_hsm(struct device *_dev, struct device_attribute *attr, char *buf)
 		"b_bus_req = \t%d\n"
 		"b_bus_suspend_tmout = \t%d\n"
 		"b_bus_suspend_vld = \t%d\n",
-		otg_state_string(iotg->otg.state),
+		usb_phy_state_string(iotg->otg.state),
 		iotg->hsm.a_bus_resume,
 		iotg->hsm.a_bus_suspend,
 		iotg->hsm.a_conn,
@@ -2043,7 +2043,7 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 	lnw->iotg.otg.set_power = langwell_otg_set_power;
 	lnw->iotg.otg.set_vbus = langwell_otg_set_vbus;
 	lnw->iotg.otg.start_srp = langwell_otg_start_srp;
-	lnw->iotg.otg.state = OTG_STATE_UNDEFINED;
+	lnw->iotg.otg.state = USB_PHY_STATE_UNDEFINED;
 
 	if (otg_set_transceiver(&lnw->iotg.otg)) {
 		dev_dbg(lnw->dev, "can't set transceiver\n");
@@ -2107,7 +2107,7 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 		goto err;
 	}
 
-	if (lnw->iotg.otg.state == OTG_STATE_A_IDLE)
+	if (lnw->iotg.otg.state == USB_PHY_STATE_A_IDLE)
 		langwell_update_transceiver();
 
 	return 0;
@@ -2180,23 +2180,23 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 
 	/* start actions */
 	switch (iotg->otg.state) {
-	case OTG_STATE_A_WAIT_VFALL:
-		iotg->otg.state = OTG_STATE_A_IDLE;
-	case OTG_STATE_A_IDLE:
-	case OTG_STATE_B_IDLE:
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_WAIT_VFALL:
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+	case USB_PHY_STATE_A_IDLE:
+	case USB_PHY_STATE_B_IDLE:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		langwell_otg_del_timer(a_wait_vrise_tmr);
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
 		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		del_timer_sync(&lnw->hsm_timer);
 		if (lnw->iotg.stop_host)
 			lnw->iotg.stop_host(&lnw->iotg);
@@ -2207,10 +2207,10 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 
 		/* Turn off VBus */
 		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		if (lnw->iotg.stop_host)
 			lnw->iotg.stop_host(&lnw->iotg);
 		else
@@ -2221,10 +2221,10 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		/* Turn off VBus */
 		iotg->otg.set_vbus(&iotg->otg, false);
 
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		langwell_otg_del_timer(a_aidl_bdis_tmr);
 		langwell_otg_HABA(0);
 		if (lnw->iotg.stop_host)
@@ -2235,10 +2235,10 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 
 		/* Turn off VBus */
 		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		del_timer_sync(&lnw->hsm_timer);
 
 		if (lnw->iotg.stop_peripheral)
@@ -2250,28 +2250,28 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 
 		/* Turn off VBus */
 		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = OTG_STATE_A_IDLE;
+		iotg->otg.state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		if (lnw->iotg.stop_host)
 			lnw->iotg.stop_host(&lnw->iotg);
 		else
 			dev_dbg(&pdev->dev, "host driver has been removed.\n");
 		iotg->hsm.b_bus_req = 0;
-		iotg->otg.state = OTG_STATE_B_IDLE;
+		iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		if (lnw->iotg.stop_peripheral)
 			lnw->iotg.stop_peripheral(&lnw->iotg);
 		else
 			dev_dbg(&pdev->dev,
 				"client driver has been removed.\n");
-		iotg->otg.state = OTG_STATE_B_IDLE;
+		iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		/* delete hsm timer for b_ase0_brst_tmr */
 		del_timer_sync(&lnw->hsm_timer);
 
@@ -2282,7 +2282,7 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		else
 			dev_dbg(&pdev->dev, "host driver has been removed.\n");
 		iotg->hsm.b_bus_req = 0;
-		iotg->otg.state = OTG_STATE_B_IDLE;
+		iotg->otg.state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	default:
diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index cba4737..c468db6 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -666,7 +666,7 @@ static void msm_otg_start_host(struct usb_phy *otg, int on)
 		 * HUB before kicking the host.
 		 */
 		if (pdata->setup_gpio)
-			pdata->setup_gpio(OTG_STATE_A_HOST);
+			pdata->setup_gpio(USB_PHY_STATE_A_HOST);
 #ifdef CONFIG_USB
 		usb_add_hcd(hcd, hcd->irq, IRQF_SHARED);
 #endif
@@ -677,7 +677,7 @@ static void msm_otg_start_host(struct usb_phy *otg, int on)
 		usb_remove_hcd(hcd);
 #endif
 		if (pdata->setup_gpio)
-			pdata->setup_gpio(OTG_STATE_UNDEFINED);
+			pdata->setup_gpio(USB_PHY_STATE_UNDEFINED);
 		if (pdata->vbus_power)
 			pdata->vbus_power(0);
 	}
@@ -698,11 +698,11 @@ static int msm_otg_set_host(struct usb_phy *otg, struct usb_bus *host)
 	}
 
 	if (!host) {
-		if (otg->state == OTG_STATE_A_HOST) {
+		if (otg->state == USB_PHY_STATE_A_HOST) {
 			pm_runtime_get_sync(otg->dev);
 			msm_otg_start_host(otg, 0);
 			otg->host = NULL;
-			otg->state = OTG_STATE_UNDEFINED;
+			otg->state = USB_PHY_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->host = NULL;
@@ -745,13 +745,13 @@ static void msm_otg_start_peripheral(struct usb_phy *otg, int on)
 		 * HUB before kicking the gadget.
 		 */
 		if (pdata->setup_gpio)
-			pdata->setup_gpio(OTG_STATE_B_PERIPHERAL);
+			pdata->setup_gpio(USB_PHY_STATE_B_PERIPHERAL);
 		usb_gadget_vbus_connect(otg->gadget);
 	} else {
 		dev_dbg(otg->dev, "gadget off\n");
 		usb_gadget_vbus_disconnect(otg->gadget);
 		if (pdata->setup_gpio)
-			pdata->setup_gpio(OTG_STATE_UNDEFINED);
+			pdata->setup_gpio(USB_PHY_STATE_UNDEFINED);
 	}
 
 }
@@ -771,11 +771,11 @@ static int msm_otg_set_peripheral(struct usb_phy *otg,
 	}
 
 	if (!gadget) {
-		if (otg->state == OTG_STATE_B_PERIPHERAL) {
+		if (otg->state == USB_PHY_STATE_B_PERIPHERAL) {
 			pm_runtime_get_sync(otg->dev);
 			msm_otg_start_peripheral(otg, 0);
 			otg->gadget = NULL;
-			otg->state = OTG_STATE_UNDEFINED;
+			otg->state = USB_PHY_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->gadget = NULL;
@@ -1155,19 +1155,19 @@ static void msm_otg_sm_work(struct work_struct *w)
 	struct usb_phy *otg = &motg->otg;
 
 	switch (otg->state) {
-	case OTG_STATE_UNDEFINED:
-		dev_dbg(otg->dev, "OTG_STATE_UNDEFINED state\n");
+	case USB_PHY_STATE_UNDEFINED:
+		dev_dbg(otg->dev, "USB_PHY_STATE_UNDEFINED state\n");
 		msm_otg_reset(otg);
 		msm_otg_init_sm(motg);
-		otg->state = OTG_STATE_B_IDLE;
+		otg->state = USB_PHY_STATE_B_IDLE;
 		/* FALL THROUGH */
-	case OTG_STATE_B_IDLE:
-		dev_dbg(otg->dev, "OTG_STATE_B_IDLE state\n");
+	case USB_PHY_STATE_B_IDLE:
+		dev_dbg(otg->dev, "USB_PHY_STATE_B_IDLE state\n");
 		if (!test_bit(ID, &motg->inputs) && otg->host) {
 			/* disable BSV bit */
 			writel(readl(USB_OTGSC) & ~OTGSC_BSVIE, USB_OTGSC);
 			msm_otg_start_host(otg, 1);
-			otg->state = OTG_STATE_A_HOST;
+			otg->state = USB_PHY_STATE_A_HOST;
 		} else if (test_bit(B_SESS_VLD, &motg->inputs)) {
 			switch (motg->chg_state) {
 			case USB_CHG_STATE_UNDEFINED:
@@ -1183,12 +1183,12 @@ static void msm_otg_sm_work(struct work_struct *w)
 					msm_otg_notify_charger(motg,
 							IDEV_CHG_MAX);
 					msm_otg_start_peripheral(otg, 1);
-					otg->state = OTG_STATE_B_PERIPHERAL;
+					otg->state = USB_PHY_STATE_B_PERIPHERAL;
 					break;
 				case USB_SDP_CHARGER:
 					msm_otg_notify_charger(motg, IUNIT);
 					msm_otg_start_peripheral(otg, 1);
-					otg->state = OTG_STATE_B_PERIPHERAL;
+					otg->state = USB_PHY_STATE_B_PERIPHERAL;
 					break;
 				default:
 					break;
@@ -1213,24 +1213,24 @@ static void msm_otg_sm_work(struct work_struct *w)
 		}
 		pm_runtime_put_sync(otg->dev);
 		break;
-	case OTG_STATE_B_PERIPHERAL:
-		dev_dbg(otg->dev, "OTG_STATE_B_PERIPHERAL state\n");
+	case USB_PHY_STATE_B_PERIPHERAL:
+		dev_dbg(otg->dev, "USB_PHY_STATE_B_PERIPHERAL state\n");
 		if (!test_bit(B_SESS_VLD, &motg->inputs) ||
 				!test_bit(ID, &motg->inputs)) {
 			msm_otg_notify_charger(motg, 0);
 			msm_otg_start_peripheral(otg, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
 			motg->chg_type = USB_INVALID_CHARGER;
-			otg->state = OTG_STATE_B_IDLE;
+			otg->state = USB_PHY_STATE_B_IDLE;
 			msm_otg_reset(otg);
 			schedule_work(w);
 		}
 		break;
-	case OTG_STATE_A_HOST:
-		dev_dbg(otg->dev, "OTG_STATE_A_HOST state\n");
+	case USB_PHY_STATE_A_HOST:
+		dev_dbg(otg->dev, "USB_PHY_STATE_A_HOST state\n");
 		if (test_bit(ID, &motg->inputs)) {
 			msm_otg_start_host(otg, 0);
-			otg->state = OTG_STATE_B_IDLE;
+			otg->state = USB_PHY_STATE_B_IDLE;
 			msm_otg_reset(otg);
 			schedule_work(w);
 		}
@@ -1284,10 +1284,10 @@ static int msm_otg_mode_show(struct seq_file *s, void *unused)
 	struct usb_phy *otg = &motg->otg;
 
 	switch (otg->state) {
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		seq_printf(s, "host\n");
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		seq_printf(s, "peripheral\n");
 		break;
 	default:
@@ -1334,8 +1334,8 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 	switch (req_mode) {
 	case USB_NONE:
 		switch (otg->state) {
-		case OTG_STATE_A_HOST:
-		case OTG_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_A_HOST:
+		case USB_PHY_STATE_B_PERIPHERAL:
 			set_bit(ID, &motg->inputs);
 			clear_bit(B_SESS_VLD, &motg->inputs);
 			break;
@@ -1345,8 +1345,8 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		break;
 	case USB_PERIPHERAL:
 		switch (otg->state) {
-		case OTG_STATE_B_IDLE:
-		case OTG_STATE_A_HOST:
+		case USB_PHY_STATE_B_IDLE:
+		case USB_PHY_STATE_A_HOST:
 			set_bit(ID, &motg->inputs);
 			set_bit(B_SESS_VLD, &motg->inputs);
 			break;
@@ -1356,8 +1356,8 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		break;
 	case USB_HOST:
 		switch (otg->state) {
-		case OTG_STATE_B_IDLE:
-		case OTG_STATE_B_PERIPHERAL:
+		case USB_PHY_STATE_B_IDLE:
+		case USB_PHY_STATE_B_PERIPHERAL:
 			clear_bit(ID, &motg->inputs);
 			break;
 		default:
@@ -1670,7 +1670,7 @@ static int msm_otg_runtime_idle(struct device *dev)
 	 * This 1 sec delay also prevents entering into LPM immediately
 	 * after asynchronous interrupt.
 	 */
-	if (otg->state != OTG_STATE_UNDEFINED)
+	if (otg->state != USB_PHY_STATE_UNDEFINED)
 		pm_schedule_suspend(dev, 1000);
 
 	return -EAGAIN;
diff --git a/drivers/usb/otg/nop-usb-xceiv.c b/drivers/usb/otg/nop-usb-xceiv.c
index 2ab0279..6a0c102 100644
--- a/drivers/usb/otg/nop-usb-xceiv.c
+++ b/drivers/usb/otg/nop-usb-xceiv.c
@@ -84,7 +84,7 @@ static int nop_set_peripheral(struct usb_phy *x,
 	}
 
 	nop->otg.gadget = gadget;
-	nop->otg.state = OTG_STATE_B_IDLE;
+	nop->otg.state = USB_PHY_STATE_B_IDLE;
 	return 0;
 }
 
@@ -118,7 +118,7 @@ static int __devinit nop_usb_xceiv_probe(struct platform_device *pdev)
 	nop->dev		= &pdev->dev;
 	nop->otg.dev		= nop->dev;
 	nop->otg.label		= "nop-xceiv";
-	nop->otg.state		= OTG_STATE_UNDEFINED;
+	nop->otg.state		= USB_PHY_STATE_UNDEFINED;
 	nop->otg.set_host	= nop_set_host;
 	nop->otg.set_peripheral	= nop_set_peripheral;
 	nop->otg.set_suspend	= nop_set_suspend;
diff --git a/drivers/usb/otg/otg.c b/drivers/usb/otg/otg.c
index 059c487..c6f2bed 100644
--- a/drivers/usb/otg/otg.c
+++ b/drivers/usb/otg/otg.c
@@ -65,37 +65,37 @@ int otg_set_transceiver(struct usb_phy *x)
 }
 EXPORT_SYMBOL(otg_set_transceiver);
 
-const char *otg_state_string(enum usb_otg_state state)
+const char *usb_phy_state_string(enum usb_phy_state state)
 {
 	switch (state) {
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		return "a_idle";
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		return "a_wait_vrise";
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		return "a_wait_bcon";
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		return "a_host";
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		return "a_suspend";
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		return "a_peripheral";
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		return "a_wait_vfall";
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		return "a_vbus_err";
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		return "b_idle";
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		return "b_srp_init";
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		return "b_peripheral";
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		return "b_wait_acon";
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		return "b_host";
 	default:
 		return "UNDEFINED";
 	}
 }
-EXPORT_SYMBOL(otg_state_string);
+EXPORT_SYMBOL(usb_phy_state_string);
diff --git a/drivers/usb/otg/otg_fsm.c b/drivers/usb/otg/otg_fsm.c
index 0911738..b2feb07 100644
--- a/drivers/usb/otg/otg_fsm.c
+++ b/drivers/usb/otg/otg_fsm.c
@@ -65,48 +65,48 @@ static int otg_set_protocol(struct otg_fsm *fsm, int protocol)
 static int state_changed;
 
 /* Called when leaving a state.  Do state clean up jobs here */
-void otg_leave_state(struct otg_fsm *fsm, enum usb_otg_state old_state)
+void otg_leave_state(struct otg_fsm *fsm, enum usb_phy_state old_state)
 {
 	switch (old_state) {
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		otg_del_timer(fsm, b_se0_srp_tmr);
 		fsm->b_se0_srp = 0;
 		break;
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		fsm->b_srp_done = 0;
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		break;
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		otg_del_timer(fsm, b_ase0_brst_tmr);
 		fsm->b_ase0_brst_tmout = 0;
 		break;
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		break;
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		break;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		otg_del_timer(fsm, a_wait_vrise_tmr);
 		fsm->a_wait_vrise_tmout = 0;
 		break;
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		otg_del_timer(fsm, a_wait_bcon_tmr);
 		fsm->a_wait_bcon_tmout = 0;
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		otg_del_timer(fsm, a_wait_enum_tmr);
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		otg_del_timer(fsm, a_aidl_bdis_tmr);
 		fsm->a_aidl_bdis_tmout = 0;
 		fsm->a_suspend_req = 0;
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		otg_del_timer(fsm, a_wait_vrise_tmr);
 		break;
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		break;
 	default:
 		break;
@@ -114,15 +114,15 @@ void otg_leave_state(struct otg_fsm *fsm, enum usb_otg_state old_state)
 }
 
 /* Called when entering a state */
-int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
+int otg_set_state(struct otg_fsm *fsm, enum usb_phy_state new_state)
 {
 	state_changed = 1;
 	if (fsm->transceiver->state == new_state)
 		return 0;
-	VDBG("Set state: %s\n", otg_state_string(new_state));
+	VDBG("Set state: %s\n", usb_phy_state_string(new_state));
 	otg_leave_state(fsm, fsm->transceiver->state);
 	switch (new_state) {
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		otg_drv_vbus(fsm, 0);
 		otg_chrg_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
@@ -130,19 +130,19 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 		otg_set_protocol(fsm, PROTO_UNDEF);
 		otg_add_timer(fsm, b_se0_srp_tmr);
 		break;
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		otg_start_pulse(fsm);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_UNDEF);
 		otg_add_timer(fsm, b_srp_fail_tmr);
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		otg_chrg_vbus(fsm, 0);
 		otg_loc_conn(fsm, 1);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_GADGET);
 		break;
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		otg_chrg_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
@@ -150,7 +150,7 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 		otg_add_timer(fsm, b_ase0_brst_tmr);
 		fsm->a_bus_suspend = 0;
 		break;
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		otg_chrg_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 1);
@@ -158,28 +158,28 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 		usb_bus_start_enum(fsm->transceiver->host,
 				fsm->transceiver->host->otg_port);
 		break;
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		otg_drv_vbus(fsm, 0);
 		otg_chrg_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_HOST);
 		break;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		otg_drv_vbus(fsm, 1);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_HOST);
 		otg_add_timer(fsm, a_wait_vrise_tmr);
 		break;
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		otg_drv_vbus(fsm, 1);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_HOST);
 		otg_add_timer(fsm, a_wait_bcon_tmr);
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		otg_drv_vbus(fsm, 1);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 1);
@@ -191,7 +191,7 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 		if (!fsm->a_bus_req || fsm->a_suspend_req)
 			otg_add_timer(fsm, a_wait_enum_tmr);
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		otg_drv_vbus(fsm, 1);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
@@ -199,19 +199,19 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 		otg_add_timer(fsm, a_aidl_bdis_tmr);
 
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		otg_loc_conn(fsm, 1);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_GADGET);
 		otg_drv_vbus(fsm, 1);
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		otg_drv_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
 		otg_set_protocol(fsm, PROTO_HOST);
 		break;
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		otg_drv_vbus(fsm, 0);
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 0);
@@ -228,7 +228,7 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_otg_state new_state)
 /* State change judgement */
 int otg_statemachine(struct otg_fsm *fsm)
 {
-	enum usb_otg_state state;
+	enum usb_phy_state state;
 	unsigned long flags;
 
 	spin_lock_irqsave(&fsm->lock, flags);
@@ -238,105 +238,105 @@ int otg_statemachine(struct otg_fsm *fsm)
 	/* State machine state change judgement */
 
 	switch (state) {
-	case OTG_STATE_UNDEFINED:
+	case USB_PHY_STATE_UNDEFINED:
 		VDBG("fsm->id = %d\n", fsm->id);
 		if (fsm->id)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		else
-			otg_set_state(fsm, OTG_STATE_A_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_A_IDLE);
 		break;
-	case OTG_STATE_B_IDLE:
+	case USB_PHY_STATE_B_IDLE:
 		if (!fsm->id)
-			otg_set_state(fsm, OTG_STATE_A_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_A_IDLE);
 		else if (fsm->b_sess_vld && fsm->transceiver->gadget)
-			otg_set_state(fsm, OTG_STATE_B_PERIPHERAL);
+			otg_set_state(fsm, USB_PHY_STATE_B_PERIPHERAL);
 		else if (fsm->b_bus_req && fsm->b_sess_end && fsm->b_se0_srp)
-			otg_set_state(fsm, OTG_STATE_B_SRP_INIT);
+			otg_set_state(fsm, USB_PHY_STATE_B_SRP_INIT);
 		break;
-	case OTG_STATE_B_SRP_INIT:
+	case USB_PHY_STATE_B_SRP_INIT:
 		if (!fsm->id || fsm->b_srp_done)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		break;
-	case OTG_STATE_B_PERIPHERAL:
+	case USB_PHY_STATE_B_PERIPHERAL:
 		if (!fsm->id || !fsm->b_sess_vld)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		else if (fsm->b_bus_req && fsm->transceiver->
 				gadget->b_hnp_enable && fsm->a_bus_suspend)
-			otg_set_state(fsm, OTG_STATE_B_WAIT_ACON);
+			otg_set_state(fsm, USB_PHY_STATE_B_WAIT_ACON);
 		break;
-	case OTG_STATE_B_WAIT_ACON:
+	case USB_PHY_STATE_B_WAIT_ACON:
 		if (fsm->a_conn)
-			otg_set_state(fsm, OTG_STATE_B_HOST);
+			otg_set_state(fsm, USB_PHY_STATE_B_HOST);
 		else if (!fsm->id || !fsm->b_sess_vld)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		else if (fsm->a_bus_resume || fsm->b_ase0_brst_tmout) {
 			fsm->b_ase0_brst_tmout = 0;
-			otg_set_state(fsm, OTG_STATE_B_PERIPHERAL);
+			otg_set_state(fsm, USB_PHY_STATE_B_PERIPHERAL);
 		}
 		break;
-	case OTG_STATE_B_HOST:
+	case USB_PHY_STATE_B_HOST:
 		if (!fsm->id || !fsm->b_sess_vld)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		else if (!fsm->b_bus_req || !fsm->a_conn)
-			otg_set_state(fsm, OTG_STATE_B_PERIPHERAL);
+			otg_set_state(fsm, USB_PHY_STATE_B_PERIPHERAL);
 		break;
-	case OTG_STATE_A_IDLE:
+	case USB_PHY_STATE_A_IDLE:
 		if (fsm->id)
-			otg_set_state(fsm, OTG_STATE_B_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
 		else if (!fsm->a_bus_drop && (fsm->a_bus_req || fsm->a_srp_det))
-			otg_set_state(fsm, OTG_STATE_A_WAIT_VRISE);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_VRISE);
 		break;
-	case OTG_STATE_A_WAIT_VRISE:
+	case USB_PHY_STATE_A_WAIT_VRISE:
 		if (fsm->id || fsm->a_bus_drop || fsm->a_vbus_vld ||
 				fsm->a_wait_vrise_tmout) {
-			otg_set_state(fsm, OTG_STATE_A_WAIT_BCON);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
 		}
 		break;
-	case OTG_STATE_A_WAIT_BCON:
+	case USB_PHY_STATE_A_WAIT_BCON:
 		if (!fsm->a_vbus_vld)
-			otg_set_state(fsm, OTG_STATE_A_VBUS_ERR);
+			otg_set_state(fsm, USB_PHY_STATE_A_VBUS_ERR);
 		else if (fsm->b_conn)
-			otg_set_state(fsm, OTG_STATE_A_HOST);
+			otg_set_state(fsm, USB_PHY_STATE_A_HOST);
 		else if (fsm->id | fsm->a_bus_drop | fsm->a_wait_bcon_tmout)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_VFALL);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_VFALL);
 		break;
-	case OTG_STATE_A_HOST:
+	case USB_PHY_STATE_A_HOST:
 		if ((!fsm->a_bus_req || fsm->a_suspend_req) &&
 				fsm->transceiver->host->b_hnp_enable)
-			otg_set_state(fsm, OTG_STATE_A_SUSPEND);
+			otg_set_state(fsm, USB_PHY_STATE_A_SUSPEND);
 		else if (fsm->id || !fsm->b_conn || fsm->a_bus_drop)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_BCON);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
 		else if (!fsm->a_vbus_vld)
-			otg_set_state(fsm, OTG_STATE_A_VBUS_ERR);
+			otg_set_state(fsm, USB_PHY_STATE_A_VBUS_ERR);
 		break;
-	case OTG_STATE_A_SUSPEND:
+	case USB_PHY_STATE_A_SUSPEND:
 		if (!fsm->b_conn && fsm->transceiver->host->b_hnp_enable)
-			otg_set_state(fsm, OTG_STATE_A_PERIPHERAL);
+			otg_set_state(fsm, USB_PHY_STATE_A_PERIPHERAL);
 		else if (!fsm->b_conn && !fsm->transceiver->host->b_hnp_enable)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_BCON);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
 		else if (fsm->a_bus_req || fsm->b_bus_resume)
-			otg_set_state(fsm, OTG_STATE_A_HOST);
+			otg_set_state(fsm, USB_PHY_STATE_A_HOST);
 		else if (fsm->id || fsm->a_bus_drop || fsm->a_aidl_bdis_tmout)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_VFALL);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_VFALL);
 		else if (!fsm->a_vbus_vld)
-			otg_set_state(fsm, OTG_STATE_A_VBUS_ERR);
+			otg_set_state(fsm, USB_PHY_STATE_A_VBUS_ERR);
 		break;
-	case OTG_STATE_A_PERIPHERAL:
+	case USB_PHY_STATE_A_PERIPHERAL:
 		if (fsm->id || fsm->a_bus_drop)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_VFALL);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_VFALL);
 		else if (fsm->b_bus_suspend)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_BCON);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
 		else if (!fsm->a_vbus_vld)
-			otg_set_state(fsm, OTG_STATE_A_VBUS_ERR);
+			otg_set_state(fsm, USB_PHY_STATE_A_VBUS_ERR);
 		break;
-	case OTG_STATE_A_WAIT_VFALL:
+	case USB_PHY_STATE_A_WAIT_VFALL:
 		if (fsm->id || fsm->a_bus_req || (!fsm->a_sess_vld &&
 					!fsm->b_conn))
-			otg_set_state(fsm, OTG_STATE_A_IDLE);
+			otg_set_state(fsm, USB_PHY_STATE_A_IDLE);
 		break;
-	case OTG_STATE_A_VBUS_ERR:
+	case USB_PHY_STATE_A_VBUS_ERR:
 		if (fsm->id || fsm->a_bus_drop || fsm->a_clr_err)
-			otg_set_state(fsm, OTG_STATE_A_WAIT_VFALL);
+			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_VFALL);
 		break;
 	default:
 		break;
diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index beeecc2..9eed1f3 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -246,7 +246,7 @@ twl4030_usb_clear_bits(struct twl4030_usb *twl, u8 reg, u8 bits)
 
 /*-------------------------------------------------------------------------*/
 
-static enum usb_xceiv_events twl4030_usb_linkstat(struct twl4030_usb *twl)
+static enum usb_phy_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 {
 	int	status;
 	int	linkstat = USB_EVENT_NONE;
@@ -291,10 +291,10 @@ static enum usb_xceiv_events twl4030_usb_linkstat(struct twl4030_usb *twl)
 	twl->linkstat = linkstat;
 	if (linkstat == USB_EVENT_ID) {
 		twl->otg.default_a = true;
-		twl->otg.state = OTG_STATE_A_IDLE;
+		twl->otg.state = USB_PHY_STATE_A_IDLE;
 	} else {
 		twl->otg.default_a = false;
-		twl->otg.state = OTG_STATE_B_IDLE;
+		twl->otg.state = USB_PHY_STATE_B_IDLE;
 	}
 	spin_unlock_irq(&twl->lock);
 
@@ -571,7 +571,7 @@ static int twl4030_set_peripheral(struct usb_phy *x,
 	twl = xceiv_to_twl(x);
 	twl->otg.gadget = gadget;
 	if (!gadget)
-		twl->otg.state = OTG_STATE_UNDEFINED;
+		twl->otg.state = USB_PHY_STATE_UNDEFINED;
 
 	return 0;
 }
@@ -586,7 +586,7 @@ static int twl4030_set_host(struct usb_phy *x, struct usb_bus *host)
 	twl = xceiv_to_twl(x);
 	twl->otg.host = host;
 	if (!host)
-		twl->otg.state = OTG_STATE_UNDEFINED;
+		twl->otg.state = USB_PHY_STATE_UNDEFINED;
 
 	return 0;
 }
diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
index 56c4d3d..2f5c299 100644
--- a/drivers/usb/otg/twl6030-usb.c
+++ b/drivers/usb/otg/twl6030-usb.c
@@ -269,7 +269,7 @@ static irqreturn_t twl6030_usb_irq(int irq, void *_twl)
 			twl->asleep = 1;
 			status = USB_EVENT_VBUS;
 			twl->otg.default_a = false;
-			twl->otg.state = OTG_STATE_B_IDLE;
+			twl->otg.state = USB_PHY_STATE_B_IDLE;
 			twl->linkstat = status;
 			twl->otg.last_event = status;
 			atomic_notifier_call_chain(&twl->otg.notifier,
@@ -308,7 +308,7 @@ static irqreturn_t twl6030_usbotg_irq(int irq, void *_twl)
 								0x10);
 		status = USB_EVENT_ID;
 		twl->otg.default_a = true;
-		twl->otg.state = OTG_STATE_A_IDLE;
+		twl->otg.state = USB_PHY_STATE_A_IDLE;
 		twl->linkstat = status;
 		twl->otg.last_event = status;
 		atomic_notifier_call_chain(&twl->otg.notifier, status,
@@ -335,7 +335,7 @@ static int twl6030_set_peripheral(struct usb_phy *x,
 	twl = xceiv_to_twl(x);
 	twl->otg.gadget = gadget;
 	if (!gadget)
-		twl->otg.state = OTG_STATE_UNDEFINED;
+		twl->otg.state = USB_PHY_STATE_UNDEFINED;
 
 	return 0;
 }
@@ -396,7 +396,7 @@ static int twl6030_set_host(struct usb_phy *x, struct usb_bus *host)
 	twl = xceiv_to_twl(x);
 	twl->otg.host = host;
 	if (!host)
-		twl->otg.state = OTG_STATE_UNDEFINED;
+		twl->otg.state = USB_PHY_STATE_UNDEFINED;
 	return 0;
 }
 
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index 2d3547a..e25ee7a 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -133,7 +133,7 @@ struct msm_otg_platform_data {
 	enum otg_control_type otg_control;
 	enum usb_mode_type default_mode;
 	enum msm_usb_phy_type phy_type;
-	void (*setup_gpio)(enum usb_otg_state state);
+	void (*setup_gpio)(enum usb_phy_state state);
 	char *pclk_src_name;
 };
 
diff --git a/include/linux/usb/otg.h b/include/linux/usb/otg.h
index e0bc557..926e04c 100644
--- a/include/linux/usb/otg.h
+++ b/include/linux/usb/otg.h
@@ -12,30 +12,30 @@
 #include <linux/notifier.h>
 
 /* OTG defines lots of enumeration states before device reset */
-enum usb_otg_state {
-	OTG_STATE_UNDEFINED = 0,
+enum usb_phy_state {
+	USB_PHY_STATE_UNDEFINED = 0,
 
 	/* single-role peripheral, and dual-role default-b */
-	OTG_STATE_B_IDLE,
-	OTG_STATE_B_SRP_INIT,
-	OTG_STATE_B_PERIPHERAL,
+	USB_PHY_STATE_B_IDLE,
+	USB_PHY_STATE_B_SRP_INIT,
+	USB_PHY_STATE_B_PERIPHERAL,
 
 	/* extra dual-role default-b states */
-	OTG_STATE_B_WAIT_ACON,
-	OTG_STATE_B_HOST,
+	USB_PHY_STATE_B_WAIT_ACON,
+	USB_PHY_STATE_B_HOST,
 
 	/* dual-role default-a */
-	OTG_STATE_A_IDLE,
-	OTG_STATE_A_WAIT_VRISE,
-	OTG_STATE_A_WAIT_BCON,
-	OTG_STATE_A_HOST,
-	OTG_STATE_A_SUSPEND,
-	OTG_STATE_A_PERIPHERAL,
-	OTG_STATE_A_WAIT_VFALL,
-	OTG_STATE_A_VBUS_ERR,
+	USB_PHY_STATE_A_IDLE,
+	USB_PHY_STATE_A_WAIT_VRISE,
+	USB_PHY_STATE_A_WAIT_BCON,
+	USB_PHY_STATE_A_HOST,
+	USB_PHY_STATE_A_SUSPEND,
+	USB_PHY_STATE_A_PERIPHERAL,
+	USB_PHY_STATE_A_WAIT_VFALL,
+	USB_PHY_STATE_A_VBUS_ERR,
 };
 
-enum usb_xceiv_events {
+enum usb_phy_events {
 	USB_EVENT_NONE,         /* no events or cable disconnected */
 	USB_EVENT_VBUS,         /* vbus valid event */
 	USB_EVENT_ID,           /* id was grounded */
@@ -65,8 +65,8 @@ struct usb_phy {
 	unsigned int		 flags;
 
 	u8			default_a;
-	enum usb_otg_state	state;
-	enum usb_xceiv_events	last_event;
+	enum usb_phy_state	state;
+	enum usb_phy_events	last_event;
 
 	struct usb_bus		*host;
 	struct usb_gadget	*gadget;
@@ -74,7 +74,7 @@ struct usb_phy {
 	struct otg_io_access_ops	*io_ops;
 	void __iomem			*io_priv;
 
-	/* for notification of usb_xceiv_events */
+	/* for notification of usb_phy_events */
 	struct atomic_notifier_head	notifier;
 
 	/* to pass extra port status to the root hub */
@@ -168,7 +168,7 @@ otg_shutdown(struct usb_phy *x)
 #ifdef CONFIG_USB_OTG_UTILS
 extern struct usb_phy *otg_get_transceiver(void);
 extern void otg_put_transceiver(struct usb_phy *);
-extern const char *otg_state_string(enum usb_otg_state state);
+extern const char *usb_phy_state_string(enum usb_phy_state state);
 #else
 static inline struct usb_phy *otg_get_transceiver(void)
 {
@@ -179,7 +179,7 @@ static inline void otg_put_transceiver(struct usb_phy *x)
 {
 }
 
-static inline const char *otg_state_string(enum usb_otg_state state)
+static inline const char *usb_phy_state_string(enum usb_phy_state state)
 {
 	return NULL;
 }
-- 
1.7.4.1

