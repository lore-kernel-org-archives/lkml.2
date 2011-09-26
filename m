Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1IZLZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:25:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab1IZLV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:21:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="56486027"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCHv5 09/19] usb: otg: langwell: Start using struct usb_otg
Date: Mon, 26 Sep 2011 14:21:22 +0300
Message-Id: <1317036092-3000-10-git-send-email-heikki.krogerus@linux.intel.com>
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
 drivers/usb/otg/langwell_otg.c    |  333 ++++++++++++++++++++-----------------
 include/linux/usb/intel_mid_otg.h |    6 +-
 2 files changed, 180 insertions(+), 159 deletions(-)

diff --git a/drivers/usb/otg/langwell_otg.c b/drivers/usb/otg/langwell_otg.c
index 54ab373..d6bd9c4 100644
--- a/drivers/usb/otg/langwell_otg.c
+++ b/drivers/usb/otg/langwell_otg.c
@@ -55,11 +55,10 @@ static void langwell_otg_remove(struct pci_dev *pdev);
 static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message);
 static int langwell_otg_resume(struct pci_dev *pdev);
 
-static int langwell_otg_set_host(struct usb_phy *otg,
-				struct usb_bus *host);
-static int langwell_otg_set_peripheral(struct usb_phy *otg,
+static int langwell_otg_set_host(struct usb_otg *otg, struct usb_bus *host);
+static int langwell_otg_set_peripheral(struct usb_otg *otg,
 				struct usb_gadget *gadget);
-static int langwell_otg_start_srp(struct usb_phy *otg);
+static int langwell_otg_start_srp(struct usb_otg *otg);
 
 static const struct pci_device_id pci_ids[] = {{
 	.class =        ((PCI_CLASS_SERIAL_USB << 8) | 0xfe),
@@ -118,15 +117,14 @@ void langwell_update_transceiver(void)
 }
 EXPORT_SYMBOL(langwell_update_transceiver);
 
-static int langwell_otg_set_host(struct usb_phy *otg,
-					struct usb_bus *host)
+static int langwell_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
 	otg->host = host;
 
 	return 0;
 }
 
-static int langwell_otg_set_peripheral(struct usb_phy *otg,
+static int langwell_otg_set_peripheral(struct usb_otg *otg,
 					struct usb_gadget *gadget)
 {
 	otg->gadget = gadget;
@@ -141,7 +139,7 @@ static int langwell_otg_set_power(struct usb_phy *otg,
 }
 
 /* A-device drives vbus, controlled through IPC commands */
-static int langwell_otg_set_vbus(struct usb_phy *otg, bool enabled)
+static int langwell_otg_set_vbus(struct usb_otg *otg, bool enabled)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	u8				sub_id;
@@ -180,7 +178,7 @@ static void langwell_otg_chrg_vbus(int on)
 }
 
 /* Start SRP */
-static int langwell_otg_start_srp(struct usb_phy *otg)
+static int langwell_otg_start_srp(struct usb_otg *otg)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
@@ -205,9 +203,9 @@ static int langwell_otg_start_srp(struct usb_phy *otg)
 	writel(val, iotg->base + CI_OTGSC);
 
 	/* Start VBus SRP, drive vbus to generate VBus pulse */
-	iotg->otg.set_vbus(&iotg->otg, true);
+	otg->set_vbus(otg, true);
 	msleep(15);
-	iotg->otg.set_vbus(&iotg->otg, false);
+	otg->set_vbus(otg, false);
 
 	/* Enable interrupt - b_sess_vld*/
 	val = readl(iotg->base + CI_OTGSC);
@@ -237,7 +235,7 @@ static void langwell_otg_loc_sof(int on)
 
 	dev_dbg(lnw->dev, "%s ---> %s\n", __func__, on ? "suspend" : "resume");
 
-	hcd = bus_to_hcd(lnw->iotg.otg.host);
+	hcd = bus_to_hcd(lnw->iotg.xceiv.otg->host);
 	if (on)
 		err = hcd->driver->bus_resume(hcd);
 	else
@@ -672,6 +670,7 @@ static void init_hsm(void)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 	u32				val32;
 
 	/* read OTGSC after reset */
@@ -681,14 +680,14 @@ static void init_hsm(void)
 	/* set init state */
 	if (val32 & OTGSC_ID) {
 		iotg->hsm.id = 1;
-		iotg->otg.default_a = 0;
+		otg->default_a = 0;
 		set_client_mode();
-		iotg->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 	} else {
 		iotg->hsm.id = 0;
-		iotg->otg.default_a = 1;
+		otg->default_a = 1;
 		set_host_mode();
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 	}
 
 	/* set session indicator */
@@ -832,6 +831,7 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = data;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 	int				flag = 0;
 
 	if (iotg == NULL)
@@ -843,7 +843,7 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 	switch (action) {
 	case MID_OTG_NOTIFY_CONNECT:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Connect Event\n");
-		if (iotg->otg.default_a == 1)
+		if (otg->default_a == 1)
 			iotg->hsm.b_conn = 1;
 		else
 			iotg->hsm.a_conn = 1;
@@ -851,7 +851,7 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 		break;
 	case MID_OTG_NOTIFY_DISCONN:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Disconnect Event\n");
-		if (iotg->otg.default_a == 1)
+		if (otg->default_a == 1)
 			iotg->hsm.b_conn = 0;
 		else
 			iotg->hsm.a_conn = 0;
@@ -859,7 +859,7 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 		break;
 	case MID_OTG_NOTIFY_HSUSPEND:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Host Bus suspend Event\n");
-		if (iotg->otg.default_a == 1)
+		if (otg->default_a == 1)
 			iotg->hsm.a_suspend_req = 1;
 		else
 			iotg->hsm.b_bus_req = 0;
@@ -867,13 +867,13 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 		break;
 	case MID_OTG_NOTIFY_HRESUME:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Host Bus resume Event\n");
-		if (iotg->otg.default_a == 1)
+		if (otg->default_a == 1)
 			iotg->hsm.b_bus_resume = 1;
 		flag = 1;
 		break;
 	case MID_OTG_NOTIFY_CSUSPEND:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Client Bus suspend Event\n");
-		if (iotg->otg.default_a == 1) {
+		if (otg->default_a == 1) {
 			if (iotg->hsm.b_bus_suspend_vld == 2) {
 				iotg->hsm.b_bus_suspend = 1;
 				iotg->hsm.b_bus_suspend_vld = 0;
@@ -891,7 +891,7 @@ static int langwell_otg_iotg_notify(struct notifier_block *nb,
 		break;
 	case MID_OTG_NOTIFY_CRESUME:
 		dev_dbg(lnw->dev, "Lnw OTG Notify Client Bus resume Event\n");
-		if (iotg->otg.default_a == 0)
+		if (otg->default_a == 0)
 			iotg->hsm.a_bus_suspend = 0;
 		flag = 0;
 		break;
@@ -926,31 +926,33 @@ static void langwell_otg_work(struct work_struct *work)
 {
 	struct langwell_otg		*lnw;
 	struct intel_mid_otg_xceiv	*iotg;
+	struct usb_otg			*otg;
 	int				retval;
 	struct pci_dev			*pdev;
 
 	lnw = container_of(work, struct langwell_otg, work);
 	iotg = &lnw->iotg;
 	pdev = to_pci_dev(lnw->dev);
+	otg = iotg->xceiv.otg;
 
 	dev_dbg(lnw->dev, "%s: old state = %s\n", __func__,
-			usb_phy_state_string(iotg->otg.state));
+			usb_phy_state_string(otg->xceiv->state));
 
-	switch (iotg->otg.state) {
+	switch (otg->xceiv->state) {
 	case USB_PHY_STATE_UNDEFINED:
 	case USB_PHY_STATE_B_IDLE:
 		if (!iotg->hsm.id) {
 			langwell_otg_del_timer(b_srp_init_tmr);
 			del_timer_sync(&lnw->hsm_timer);
 
-			iotg->otg.default_a = 1;
+			otg->default_a = 1;
 			iotg->hsm.a_srp_det = 0;
 
 			langwell_otg_chrg_vbus(0);
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
 
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.b_sess_vld) {
 			langwell_otg_del_timer(b_srp_init_tmr);
@@ -961,7 +963,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			if (lnw->iotg.start_peripheral) {
 				lnw->iotg.start_peripheral(&lnw->iotg);
-				iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+				otg->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 			} else
 				dev_dbg(lnw->dev, "client driver not loaded\n");
 
@@ -987,7 +989,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 				/* Start SRP */
 				langwell_otg_add_timer(b_srp_init_tmr);
-				iotg->otg.start_srp(&iotg->otg);
+				otg->start_srp(otg);
 				langwell_otg_del_timer(b_srp_init_tmr);
 				langwell_otg_add_ktimer(TB_SRP_FAIL_TMR);
 
@@ -998,28 +1000,28 @@ static void langwell_otg_work(struct work_struct *work)
 		break;
 	case USB_PHY_STATE_B_SRP_INIT:
 		if (!iotg->hsm.id) {
-			iotg->otg.default_a = 1;
+			otg->default_a = 1;
 			iotg->hsm.a_srp_det = 0;
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			langwell_otg_chrg_vbus(0);
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.b_sess_vld) {
 			langwell_otg_chrg_vbus(0);
 			if (lnw->iotg.start_peripheral) {
 				lnw->iotg.start_peripheral(&lnw->iotg);
-				iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+				otg->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 			} else
 				dev_dbg(lnw->dev, "client driver not loaded\n");
 		}
 		break;
 	case USB_PHY_STATE_B_PERIPHERAL:
 		if (!iotg->hsm.id) {
-			iotg->otg.default_a = 1;
+			otg->default_a = 1;
 			iotg->hsm.a_srp_det = 0;
 
 			langwell_otg_chrg_vbus(0);
@@ -1032,7 +1034,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			iotg->hsm.b_hnp_enable = 0;
@@ -1043,9 +1045,9 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 					"client driver has been removed.\n");
 
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
-		} else if (iotg->hsm.b_bus_req && iotg->otg.gadget &&
-					iotg->otg.gadget->b_hnp_enable &&
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
+		} else if (iotg->hsm.b_bus_req && otg->gadget &&
+					otg->gadget->b_hnp_enable &&
 					iotg->hsm.a_bus_suspend) {
 
 			if (lnw->iotg.stop_peripheral)
@@ -1059,7 +1061,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			if (lnw->iotg.start_host) {
 				lnw->iotg.start_host(&lnw->iotg);
-				iotg->otg.state = USB_PHY_STATE_B_WAIT_ACON;
+				otg->xceiv->state = USB_PHY_STATE_B_WAIT_ACON;
 			} else
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
@@ -1074,7 +1076,7 @@ static void langwell_otg_work(struct work_struct *work)
 			/* delete hsm timer for b_ase0_brst_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
-			iotg->otg.default_a = 1;
+			otg->default_a = 1;
 			iotg->hsm.a_srp_det = 0;
 
 			langwell_otg_chrg_vbus(0);
@@ -1088,7 +1090,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			/* delete hsm timer for b_ase0_brst_tmr */
@@ -1108,13 +1110,13 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		} else if (iotg->hsm.a_conn) {
 			/* delete hsm timer for b_ase0_brst_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
 			langwell_otg_HAAR(0);
-			iotg->otg.state = USB_PHY_STATE_B_HOST;
+			otg->xceiv->state = USB_PHY_STATE_B_HOST;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_resume ||
 				iotg->hsm.b_ase0_brst_tmout) {
@@ -1139,13 +1141,13 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 					"client driver not loaded.\n");
 
-			iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+			otg->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		}
 		break;
 
 	case USB_PHY_STATE_B_HOST:
 		if (!iotg->hsm.id) {
-			iotg->otg.default_a = 1;
+			otg->default_a = 1;
 			iotg->hsm.a_srp_det = 0;
 
 			langwell_otg_chrg_vbus(0);
@@ -1158,7 +1160,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.b_sess_vld) {
 			iotg->hsm.b_hnp_enable = 0;
@@ -1173,7 +1175,7 @@ static void langwell_otg_work(struct work_struct *work)
 
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		} else if ((!iotg->hsm.b_bus_req) ||
 				(!iotg->hsm.a_conn)) {
 			iotg->hsm.b_bus_req = 0;
@@ -1193,33 +1195,33 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"client driver not loaded.\n");
 
-			iotg->otg.state = USB_PHY_STATE_B_PERIPHERAL;
+			otg->xceiv->state = USB_PHY_STATE_B_PERIPHERAL;
 		}
 		break;
 
 	case USB_PHY_STATE_A_IDLE:
-		iotg->otg.default_a = 1;
+		otg->default_a = 1;
 		if (iotg->hsm.id) {
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.b_bus_req = 0;
 			iotg->hsm.vbus_srp_up = 0;
 
 			langwell_otg_chrg_vbus(0);
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_bus_drop &&
 			(iotg->hsm.a_srp_det || iotg->hsm.a_bus_req)) {
 			langwell_otg_phy_low_power(0);
 
 			/* Turn on VBus */
-			iotg->otg.set_vbus(&iotg->otg, true);
+			otg->set_vbus(otg, true);
 
 			iotg->hsm.vbus_srp_up = 0;
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_bus_drop && iotg->hsm.a_sess_vld) {
 			iotg->hsm.vbus_srp_up = 1;
@@ -1228,12 +1230,12 @@ static void langwell_otg_work(struct work_struct *work)
 			langwell_otg_phy_low_power(0);
 
 			/* Turn on VBus */
-			iotg->otg.set_vbus(&iotg->otg, true);
+			otg->set_vbus(otg, true);
 			iotg->hsm.a_srp_det = 1;
 			iotg->hsm.vbus_srp_up = 0;
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_sess_vld &&
 				!iotg->hsm.vbus_srp_up) {
@@ -1244,13 +1246,13 @@ static void langwell_otg_work(struct work_struct *work)
 		if (iotg->hsm.id) {
 			langwell_otg_del_timer(a_wait_vrise_tmr);
 			iotg->hsm.b_bus_req = 0;
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		} else if (iotg->hsm.a_vbus_vld) {
 			langwell_otg_del_timer(a_wait_vrise_tmr);
 			iotg->hsm.b_conn = 0;
@@ -1262,7 +1264,7 @@ static void langwell_otg_work(struct work_struct *work)
 			}
 
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		} else if (iotg->hsm.a_wait_vrise_tmout) {
 			iotg->hsm.b_conn = 0;
 			if (iotg->hsm.a_vbus_vld) {
@@ -1274,13 +1276,13 @@ static void langwell_otg_work(struct work_struct *work)
 					break;
 				}
 				langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-				iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
+				otg->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 			} else {
 
 				/* Turn off VBus */
-				iotg->otg.set_vbus(&iotg->otg, false);
+				otg->set_vbus(otg, false);
 				langwell_otg_phy_low_power_wait(1);
-				iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
+				otg->xceiv->state = USB_PHY_STATE_A_VBUS_ERR;
 			}
 		}
 		break;
@@ -1289,7 +1291,7 @@ static void langwell_otg_work(struct work_struct *work)
 			/* delete hsm timer for a_wait_bcon_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.b_bus_req = 0;
 
 			if (lnw->iotg.stop_host)
@@ -1299,10 +1301,10 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_vbus_vld) {
 			/* delete hsm timer for a_wait_bcon_tmr */
@@ -1315,9 +1317,9 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
+			otg->xceiv->state = USB_PHY_STATE_A_VBUS_ERR;
 		} else if (iotg->hsm.a_bus_drop ||
 				(iotg->hsm.a_wait_bcon_tmout &&
 				!iotg->hsm.a_bus_req)) {
@@ -1331,21 +1333,21 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+			otg->set_vbus(otg, false);
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (iotg->hsm.b_conn) {
 			/* delete hsm timer for a_wait_bcon_tmr */
 			del_timer_sync(&lnw->hsm_timer);
 
 			iotg->hsm.a_suspend_req = 0;
-			iotg->otg.state = USB_PHY_STATE_A_HOST;
-			if (iotg->hsm.a_srp_det && iotg->otg.host &&
-					!iotg->otg.host->b_hnp_enable) {
+			otg->xceiv->state = USB_PHY_STATE_A_HOST;
+			if (iotg->hsm.a_srp_det && otg->host &&
+					!otg->host->b_hnp_enable) {
 				/* SRP capable peripheral-only device */
 				iotg->hsm.a_bus_req = 1;
 				iotg->hsm.a_srp_det = 0;
-			} else if (!iotg->hsm.a_bus_req && iotg->otg.host &&
-					iotg->otg.host->b_hnp_enable) {
+			} else if (!iotg->hsm.a_bus_req && otg->host &&
+					otg->host->b_hnp_enable) {
 				/* It is not safe enough to do a fast
 				 * transition from A_WAIT_BCON to
 				 * A_SUSPEND */
@@ -1369,9 +1371,9 @@ static void langwell_otg_work(struct work_struct *work)
 				/* clear PHCD to enable HW timer */
 				langwell_otg_phy_low_power(0);
 				langwell_otg_add_timer(a_aidl_bdis_tmr);
-				iotg->otg.state = USB_PHY_STATE_A_SUSPEND;
-			} else if (!iotg->hsm.a_bus_req && iotg->otg.host &&
-				!iotg->otg.host->b_hnp_enable) {
+				otg->xceiv->state = USB_PHY_STATE_A_SUSPEND;
+			} else if (!iotg->hsm.a_bus_req && otg->host &&
+				!otg->host->b_hnp_enable) {
 				if (lnw->iotg.stop_host)
 					lnw->iotg.stop_host(&lnw->iotg);
 				else
@@ -1379,14 +1381,14 @@ static void langwell_otg_work(struct work_struct *work)
 						"host driver removed.\n");
 
 				/* Turn off VBus */
-				iotg->otg.set_vbus(&iotg->otg, false);
-				iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+				otg->set_vbus(otg, false);
+				otg->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 			}
 		}
 		break;
 	case USB_PHY_STATE_A_HOST:
 		if (iotg->hsm.id) {
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.b_bus_req = 0;
 
 			if (lnw->iotg.stop_host)
@@ -1396,14 +1398,14 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_drop ||
-				(iotg->otg.host &&
-				!iotg->otg.host->b_hnp_enable &&
+				(otg->host &&
+				!otg->host->b_hnp_enable &&
 					!iotg->hsm.a_bus_req)) {
 			if (lnw->iotg.stop_host)
 				lnw->iotg.stop_host(&lnw->iotg);
@@ -1412,8 +1414,8 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+			otg->set_vbus(otg, false);
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (!iotg->hsm.a_vbus_vld) {
 			if (lnw->iotg.stop_host)
 				lnw->iotg.stop_host(&lnw->iotg);
@@ -1422,11 +1424,11 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
-		} else if (iotg->otg.host &&
-				iotg->otg.host->b_hnp_enable &&
+			otg->xceiv->state = USB_PHY_STATE_A_VBUS_ERR;
+		} else if (otg->host &&
+				otg->host->b_hnp_enable &&
 				!iotg->hsm.a_bus_req) {
 			/* Set HABA to enable hardware assistance to signal
 			 *  A-connect after receiver B-disconnect. Hardware
@@ -1449,10 +1451,10 @@ static void langwell_otg_work(struct work_struct *work)
 			/* clear PHCD to enable HW timer */
 			langwell_otg_phy_low_power(0);
 			langwell_otg_add_timer(a_aidl_bdis_tmr);
-			iotg->otg.state = USB_PHY_STATE_A_SUSPEND;
+			otg->xceiv->state = USB_PHY_STATE_A_SUSPEND;
 		} else if (!iotg->hsm.b_conn || !iotg->hsm.a_bus_req) {
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		}
 		break;
 	case USB_PHY_STATE_A_SUSPEND:
@@ -1460,7 +1462,7 @@ static void langwell_otg_work(struct work_struct *work)
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
 			langwell_otg_HABA(0);
 			free_irq(pdev->irq, iotg->base);
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.b_bus_req = 0;
 
 			if (lnw->iotg.stop_host)
@@ -1470,10 +1472,10 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_req ||
 				iotg->hsm.b_bus_resume) {
@@ -1482,7 +1484,7 @@ static void langwell_otg_work(struct work_struct *work)
 			free_irq(pdev->irq, iotg->base);
 			iotg->hsm.a_suspend_req = 0;
 			langwell_otg_loc_sof(1);
-			iotg->otg.state = USB_PHY_STATE_A_HOST;
+			otg->xceiv->state = USB_PHY_STATE_A_HOST;
 		} else if (iotg->hsm.a_aidl_bdis_tmout ||
 				iotg->hsm.a_bus_drop) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
@@ -1495,10 +1497,10 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
-		} else if (!iotg->hsm.b_conn && iotg->otg.host &&
-				iotg->otg.host->b_hnp_enable) {
+			otg->set_vbus(otg, false);
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
+		} else if (!iotg->hsm.b_conn && otg->host &&
+				otg->host->b_hnp_enable) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
 			langwell_otg_HABA(0);
 			free_irq(pdev->irq, iotg->base);
@@ -1520,7 +1522,7 @@ static void langwell_otg_work(struct work_struct *work)
 					"client driver not loaded.\n");
 
 			langwell_otg_add_ktimer(TB_BUS_SUSPEND_TMR);
-			iotg->otg.state = USB_PHY_STATE_A_PERIPHERAL;
+			otg->xceiv->state = USB_PHY_STATE_A_PERIPHERAL;
 			break;
 		} else if (!iotg->hsm.a_vbus_vld) {
 			langwell_otg_del_timer(a_aidl_bdis_tmr);
@@ -1533,16 +1535,16 @@ static void langwell_otg_work(struct work_struct *work)
 					"host driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
+			otg->xceiv->state = USB_PHY_STATE_A_VBUS_ERR;
 		}
 		break;
 	case USB_PHY_STATE_A_PERIPHERAL:
 		if (iotg->hsm.id) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.b_bus_req = 0;
 			if (lnw->iotg.stop_peripheral)
 				lnw->iotg.stop_peripheral(&lnw->iotg);
@@ -1551,10 +1553,10 @@ static void langwell_otg_work(struct work_struct *work)
 					"client driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			set_client_mode();
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (!iotg->hsm.a_vbus_vld) {
 			/* delete hsm timer for b_bus_suspend_tmr */
@@ -1567,9 +1569,9 @@ static void langwell_otg_work(struct work_struct *work)
 					"client driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
+			otg->set_vbus(otg, false);
 			langwell_otg_phy_low_power_wait(1);
-			iotg->otg.state = USB_PHY_STATE_A_VBUS_ERR;
+			otg->xceiv->state = USB_PHY_STATE_A_VBUS_ERR;
 		} else if (iotg->hsm.a_bus_drop) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1581,8 +1583,8 @@ static void langwell_otg_work(struct work_struct *work)
 					"client driver has been removed.\n");
 
 			/* Turn off VBus */
-			iotg->otg.set_vbus(&iotg->otg, false);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VFALL;
+			otg->set_vbus(otg, false);
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VFALL;
 		} else if (iotg->hsm.b_bus_suspend) {
 			/* delete hsm timer for b_bus_suspend_tmr */
 			del_timer_sync(&lnw->hsm_timer);
@@ -1599,7 +1601,7 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		} else if (iotg->hsm.b_bus_suspend_tmout) {
 			u32	val;
 			val = readl(lnw->iotg.base + CI_PORTSC1);
@@ -1618,24 +1620,24 @@ static void langwell_otg_work(struct work_struct *work)
 				dev_dbg(lnw->dev,
 						"host driver not loaded.\n");
 			langwell_otg_add_ktimer(TA_WAIT_BCON_TMR);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_BCON;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_BCON;
 		}
 		break;
 	case USB_PHY_STATE_A_VBUS_ERR:
 		if (iotg->hsm.id) {
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			iotg->hsm.a_clr_err = 0;
 			iotg->hsm.a_srp_det = 0;
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_clr_err) {
 			iotg->hsm.a_clr_err = 0;
 			iotg->hsm.a_srp_det = 0;
 			reset_otg();
 			init_hsm();
-			if (iotg->otg.state == USB_PHY_STATE_A_IDLE)
+			if (otg->xceiv->state == USB_PHY_STATE_A_IDLE)
 				langwell_update_transceiver();
 		} else {
 			/* FW will clear PHCD bit when any VBus
@@ -1645,23 +1647,23 @@ static void langwell_otg_work(struct work_struct *work)
 		break;
 	case USB_PHY_STATE_A_WAIT_VFALL:
 		if (iotg->hsm.id) {
-			iotg->otg.default_a = 0;
+			otg->default_a = 0;
 			set_client_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_B_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 			langwell_update_transceiver();
 		} else if (iotg->hsm.a_bus_req) {
 
 			/* Turn on VBus */
-			iotg->otg.set_vbus(&iotg->otg, true);
+			otg->set_vbus(otg, true);
 			iotg->hsm.a_wait_vrise_tmout = 0;
 			langwell_otg_add_timer(a_wait_vrise_tmr);
-			iotg->otg.state = USB_PHY_STATE_A_WAIT_VRISE;
+			otg->xceiv->state = USB_PHY_STATE_A_WAIT_VRISE;
 		} else if (!iotg->hsm.a_sess_vld) {
 			iotg->hsm.a_srp_det = 0;
 			set_host_mode();
 			langwell_otg_phy_low_power(1);
-			iotg->otg.state = USB_PHY_STATE_A_IDLE;
+			otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		}
 		break;
 	default:
@@ -1669,7 +1671,7 @@ static void langwell_otg_work(struct work_struct *work)
 	}
 
 	dev_dbg(lnw->dev, "%s: new state = %s\n", __func__,
-			usb_phy_state_string(iotg->otg.state));
+			usb_phy_state_string(otg->xceiv->state));
 }
 
 static ssize_t
@@ -1713,17 +1715,18 @@ show_hsm(struct device *_dev, struct device_attribute *attr, char *buf)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 	char				*next;
 	unsigned			size, t;
 
 	next = buf;
 	size = PAGE_SIZE;
 
-	if (iotg->otg.host)
-		iotg->hsm.a_set_b_hnp_en = iotg->otg.host->b_hnp_enable;
+	if (otg->host)
+		iotg->hsm.a_set_b_hnp_en = otg->host->b_hnp_enable;
 
-	if (iotg->otg.gadget)
-		iotg->hsm.b_hnp_enable = iotg->otg.gadget->b_hnp_enable;
+	if (otg->gadget)
+		iotg->hsm.b_hnp_enable = otg->gadget->b_hnp_enable;
 
 	t = scnprintf(next, size,
 		"\n"
@@ -1755,7 +1758,7 @@ show_hsm(struct device *_dev, struct device_attribute *attr, char *buf)
 		"b_bus_req = \t%d\n"
 		"b_bus_suspend_tmout = \t%d\n"
 		"b_bus_suspend_vld = \t%d\n",
-		usb_phy_state_string(iotg->otg.state),
+		usb_phy_state_string(otg->xceiv->state),
 		iotg->hsm.a_bus_resume,
 		iotg->hsm.a_bus_suspend,
 		iotg->hsm.a_conn,
@@ -1814,8 +1817,9 @@ set_a_bus_req(struct device *dev, struct device_attribute *attr,
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 
-	if (!iotg->otg.default_a)
+	if (!otg->default_a)
 		return -1;
 	if (count > 2)
 		return -1;
@@ -1861,8 +1865,9 @@ set_a_bus_drop(struct device *dev, struct device_attribute *attr,
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 
-	if (!iotg->otg.default_a)
+	if (!otg->default_a)
 		return -1;
 	if (count > 2)
 		return -1;
@@ -1907,8 +1912,9 @@ set_b_bus_req(struct device *dev, struct device_attribute *attr,
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 
-	if (iotg->otg.default_a)
+	if (otg->default_a)
 		return -1;
 
 	if (count > 2)
@@ -1935,8 +1941,9 @@ set_a_clr_err(struct device *dev, struct device_attribute *attr,
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = iotg->xceiv.otg;
 
-	if (!iotg->otg.default_a)
+	if (!otg->default_a)
 		return -1;
 	if (count > 2)
 		return -1;
@@ -1974,6 +1981,7 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 	int			retval;
 	u32			val32;
 	struct langwell_otg	*lnw;
+	struct usb_otg		*otg;
 	char			qname[] = "langwell_otg_queue";
 
 	retval = 0;
@@ -1988,6 +1996,15 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 		retval = -ENOMEM;
 		goto done;
 	}
+
+	otg = kzalloc(sizeof *otg, GFP_KERNEL);
+	if (otg == NULL) {
+		kfree(lnw);
+		retval = -ENOMEM;
+		goto done;
+	}
+
+	lnw->iotg.xceiv.otg = otg;
 	the_transceiver = lnw;
 
 	/* control register: BAR 0 */
@@ -2036,16 +2053,18 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 
 	/* OTG common part */
 	lnw->dev = &pdev->dev;
-	lnw->iotg.otg.dev = lnw->dev;
-	lnw->iotg.otg.label = driver_name;
-	lnw->iotg.otg.set_host = langwell_otg_set_host;
-	lnw->iotg.otg.set_peripheral = langwell_otg_set_peripheral;
-	lnw->iotg.otg.set_power = langwell_otg_set_power;
-	lnw->iotg.otg.set_vbus = langwell_otg_set_vbus;
-	lnw->iotg.otg.start_srp = langwell_otg_start_srp;
-	lnw->iotg.otg.state = USB_PHY_STATE_UNDEFINED;
-
-	if (otg_set_transceiver(&lnw->iotg.otg)) {
+	lnw->iotg.xceiv.dev = lnw->dev;
+	lnw->iotg.xceiv.label = driver_name;
+	lnw->iotg.xceiv.set_power = langwell_otg_set_power;
+	lnw->iotg.xceiv.state = USB_PHY_STATE_UNDEFINED;
+
+	otg->xceiv = &lnw->iotg.xceiv;
+	otg->set_host = langwell_otg_set_host;
+	otg->set_peripheral = langwell_otg_set_peripheral;
+	otg->set_vbus = langwell_otg_set_vbus;
+	otg->start_srp = langwell_otg_start_srp;
+
+	if (usb_set_transceiver(&lnw->iotg.xceiv)) {
 		dev_dbg(lnw->dev, "can't set transceiver\n");
 		retval = -EBUSY;
 		goto err;
@@ -2107,7 +2126,7 @@ static int langwell_otg_probe(struct pci_dev *pdev,
 		goto err;
 	}
 
-	if (lnw->iotg.otg.state == USB_PHY_STATE_A_IDLE)
+	if (otg->xceiv->state == USB_PHY_STATE_A_IDLE)
 		langwell_update_transceiver();
 
 	return 0;
@@ -2145,11 +2164,12 @@ static void langwell_otg_remove(struct pci_dev *pdev)
 		release_mem_region(pci_resource_start(pdev, 0),
 				pci_resource_len(pdev, 0));
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 	pci_disable_device(pdev);
 	sysfs_remove_group(&pdev->dev.kobj, &debug_dev_attr_group);
 	device_remove_file(&pdev->dev, &dev_attr_hsm);
 	device_remove_file(&pdev->dev, &dev_attr_registers);
+	kfree(lnw->iotg.xceiv.otg);
 	kfree(lnw);
 	lnw = NULL;
 }
@@ -2165,6 +2185,7 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 {
 	struct langwell_otg		*lnw = the_transceiver;
 	struct intel_mid_otg_xceiv	*iotg = &lnw->iotg;
+	struct usb_otg			*otg = lnw->iotg.xceiv.otg;
 	int				ret = 0;
 
 	/* Disbale OTG interrupts */
@@ -2179,9 +2200,9 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 	lnw->qwork = NULL;
 
 	/* start actions */
-	switch (iotg->otg.state) {
+	switch (otg->xceiv->state) {
 	case USB_PHY_STATE_A_WAIT_VFALL:
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 	case USB_PHY_STATE_A_IDLE:
 	case USB_PHY_STATE_B_IDLE:
 	case USB_PHY_STATE_A_VBUS_ERR:
@@ -2192,8 +2213,8 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
-		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->set_vbus(otg, false);
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_A_WAIT_BCON:
@@ -2206,8 +2227,8 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
-		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->set_vbus(otg, false);
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_A_HOST:
@@ -2219,9 +2240,9 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
-		iotg->otg.set_vbus(&iotg->otg, false);
+		otg->set_vbus(otg, false);
 
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_A_SUSPEND:
@@ -2234,8 +2255,8 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
-		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->set_vbus(otg, false);
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_A_PERIPHERAL:
@@ -2249,8 +2270,8 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		iotg->hsm.a_srp_det = 0;
 
 		/* Turn off VBus */
-		iotg->otg.set_vbus(&iotg->otg, false);
-		iotg->otg.state = USB_PHY_STATE_A_IDLE;
+		otg->set_vbus(otg, false);
+		otg->xceiv->state = USB_PHY_STATE_A_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_B_HOST:
@@ -2259,7 +2280,7 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		else
 			dev_dbg(&pdev->dev, "host driver has been removed.\n");
 		iotg->hsm.b_bus_req = 0;
-		iotg->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_B_PERIPHERAL:
@@ -2268,7 +2289,7 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		else
 			dev_dbg(&pdev->dev,
 				"client driver has been removed.\n");
-		iotg->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	case USB_PHY_STATE_B_WAIT_ACON:
@@ -2282,7 +2303,7 @@ static int langwell_otg_suspend(struct pci_dev *pdev, pm_message_t message)
 		else
 			dev_dbg(&pdev->dev, "host driver has been removed.\n");
 		iotg->hsm.b_bus_req = 0;
-		iotg->otg.state = USB_PHY_STATE_B_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		transceiver_suspend(pdev);
 		break;
 	default:
diff --git a/include/linux/usb/intel_mid_otg.h b/include/linux/usb/intel_mid_otg.h
index 756cf55..08687cb 100644
--- a/include/linux/usb/intel_mid_otg.h
+++ b/include/linux/usb/intel_mid_otg.h
@@ -108,7 +108,7 @@ struct iotg_ulpi_access_ops {
  * purpose.
  */
 struct intel_mid_otg_xceiv {
-	struct usb_phy		otg;
+	struct usb_phy		xceiv;
 	struct otg_hsm		hsm;
 
 	/* base address */
@@ -147,9 +147,9 @@ struct intel_mid_otg_xceiv {
 
 };
 static inline
-struct intel_mid_otg_xceiv *otg_to_mid_xceiv(struct usb_phy *otg)
+struct intel_mid_otg_xceiv *otg_to_mid_xceiv(struct usb_phy *xceiv)
 {
-	return container_of(otg, struct intel_mid_otg_xceiv, otg);
+	return container_of(xceiv, struct intel_mid_otg_xceiv, xceiv);
 }
 
 #define MID_OTG_NOTIFY_CONNECT		0x0001
-- 
1.7.4.1

