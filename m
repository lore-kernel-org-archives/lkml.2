Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab1IGRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:09:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:9086 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171Ab1IGQ7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45953754"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Li Yang <leoli@freescale.com>
Subject: [PATCHv4 05/19] usb: otg: fsl: Start using struct usb_otg
Date: Wed,  7 Sep 2011 10:15:58 +0300
Message-Id: <1315379772-8830-6-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Li Yang <leoli@freescale.com>
---
 drivers/usb/otg/fsl_otg.c |  118 +++++++++++++++++++++++++-------------------
 drivers/usb/otg/fsl_otg.h |    2 +-
 drivers/usb/otg/otg_fsm.c |   22 ++++----
 drivers/usb/otg/otg_fsm.h |    2 +-
 4 files changed, 80 insertions(+), 64 deletions(-)

diff --git a/drivers/usb/otg/fsl_otg.c b/drivers/usb/otg/fsl_otg.c
index 76125f7..70bb428 100644
--- a/drivers/usb/otg/fsl_otg.c
+++ b/drivers/usb/otg/fsl_otg.c
@@ -275,7 +275,7 @@ void b_srp_end(unsigned long foo)
 	fsl_otg_dischrg_vbus(0);
 	srp_wait_done = 1;
 
-	if ((fsl_otg_dev->otg.state == USB_PHY_STATE_B_SRP_INIT) &&
+	if ((fsl_otg_dev->xceiv.state == USB_PHY_STATE_B_SRP_INIT) &&
 	    fsl_otg_dev->fsm.b_sess_vld)
 		fsl_otg_dev->fsm.b_srp_done = 1;
 }
@@ -288,7 +288,7 @@ void b_srp_end(unsigned long foo)
 void a_wait_enum(unsigned long foo)
 {
 	VDBG("a_wait_enum timeout\n");
-	if (!fsl_otg_dev->otg.host->b_hnp_enable)
+	if (!fsl_otg_dev->xceiv.otg->host->b_hnp_enable)
 		fsl_otg_add_timer(a_wait_enum_tmr);
 	else
 		otg_statemachine(&fsl_otg_dev->fsm);
@@ -452,14 +452,15 @@ void otg_reset_controller(void)
 /* Call suspend/resume routines in host driver */
 int fsl_otg_start_host(struct otg_fsm *fsm, int on)
 {
-	struct usb_phy *xceiv = fsm->transceiver;
+	struct usb_otg *otg = fsm->otg;
 	struct device *dev;
-	struct fsl_otg *otg_dev = container_of(xceiv, struct fsl_otg, otg);
+	struct fsl_otg *otg_dev = container_of(otg->xceiv, struct fsl_otg,
+						xceiv);
 	u32 retval = 0;
 
-	if (!xceiv->host)
+	if (!otg->host)
 		return -ENODEV;
-	dev = xceiv->host->controller;
+	dev = otg->host->controller;
 
 	/*
 	 * Update a_vbus_vld state as a_vbus_vld int is disabled
@@ -518,14 +519,14 @@ end:
  */
 int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
 {
-	struct usb_phy *xceiv = fsm->transceiver;
+	struct usb_otg *otg = fsm->otg;
 	struct device *dev;
 
-	if (!xceiv->gadget || !xceiv->gadget->dev.parent)
+	if (!otg->gadget || !otg->gadget->dev.parent)
 		return -ENODEV;
 
 	VDBG("gadget %s\n", on ? "on" : "off");
-	dev = xceiv->gadget->dev.parent;
+	dev = otg->gadget->dev.parent;
 
 	if (on) {
 		if (dev->driver->resume)
@@ -542,14 +543,15 @@ int fsl_otg_start_gadget(struct otg_fsm *fsm, int on)
  * Called by initialization code of host driver.  Register host controller
  * to the OTG.  Suspend host for OTG role detection.
  */
-static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
+static int fsl_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
+	struct fsl_otg *otg_dev = container_of(otg->xceiv, struct fsl_otg,
+						xceiv);
 
-	if (!otg_p || otg_dev != fsl_otg_dev)
+	if (!otg || otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
-	otg_p->host = host;
+	otg->host = host;
 
 	otg_dev->fsm.a_bus_drop = 0;
 	otg_dev->fsm.a_bus_req = 1;
@@ -557,8 +559,8 @@ static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
 	if (host) {
 		VDBG("host off......\n");
 
-		otg_p->host->otg_port = fsl_otg_initdata.otg_port;
-		otg_p->host->is_b_host = otg_dev->fsm.id;
+		otg->host->otg_port = fsl_otg_initdata.otg_port;
+		otg->host->is_b_host = otg_dev->fsm.id;
 		/*
 		 * must leave time for khubd to finish its thing
 		 * before yanking the host driver out from under it,
@@ -574,7 +576,7 @@ static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
 			/* Mini-A cable connected */
 			struct otg_fsm *fsm = &otg_dev->fsm;
 
-			otg_p->state = USB_PHY_STATE_UNDEFINED;
+			otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 			fsm->protocol = PROTO_UNDEF;
 		}
 	}
@@ -587,29 +589,30 @@ static int fsl_otg_set_host(struct usb_phy *otg_p, struct usb_bus *host)
 }
 
 /* Called by initialization code of udc.  Register udc to OTG. */
-static int fsl_otg_set_peripheral(struct usb_phy *otg_p,
-				  struct usb_gadget *gadget)
+static int fsl_otg_set_peripheral(struct usb_otg *otg,
+					struct usb_gadget *gadget)
 {
-	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
+	struct fsl_otg *otg_dev = container_of(otg->xceiv, struct fsl_otg,
+						xceiv);
 
 	VDBG("otg_dev 0x%x\n", (int)otg_dev);
 	VDBG("fsl_otg_dev 0x%x\n", (int)fsl_otg_dev);
 
-	if (!otg_p || otg_dev != fsl_otg_dev)
+	if (!otg || otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
 	if (!gadget) {
-		if (!otg_dev->otg.default_a)
-			otg_p->gadget->ops->vbus_draw(otg_p->gadget, 0);
-		usb_gadget_vbus_disconnect(otg_dev->otg.gadget);
-		otg_dev->otg.gadget = 0;
+		if (!otg->default_a)
+			otg->gadget->ops->vbus_draw(otg->gadget, 0);
+		usb_gadget_vbus_disconnect(otg->gadget);
+		otg->gadget = 0;
 		otg_dev->fsm.b_bus_req = 0;
 		otg_statemachine(&otg_dev->fsm);
 		return 0;
 	}
 
-	otg_p->gadget = gadget;
-	otg_p->gadget->is_a_peripheral = !otg_dev->fsm.id;
+	otg->gadget = gadget;
+	otg->gadget->is_a_peripheral = !otg_dev->fsm.id;
 
 	otg_dev->fsm.b_bus_req = 1;
 
@@ -625,11 +628,11 @@ static int fsl_otg_set_peripheral(struct usb_phy *otg_p,
 }
 
 /* Set OTG port power, only for B-device */
-static int fsl_otg_set_power(struct usb_phy *otg_p, unsigned mA)
+static int fsl_otg_set_power(struct usb_phy *xceiv, unsigned mA)
 {
 	if (!fsl_otg_dev)
 		return -ENODEV;
-	if (otg_p->state == USB_PHY_STATE_B_PERIPHERAL)
+	if (xceiv->state == USB_PHY_STATE_B_PERIPHERAL)
 		pr_info("FSL OTG: Draw %d mA\n", mA);
 
 	return 0;
@@ -658,12 +661,13 @@ static void fsl_otg_event(struct work_struct *work)
 }
 
 /* B-device start SRP */
-static int fsl_otg_start_srp(struct usb_phy *otg_p)
+static int fsl_otg_start_srp(struct usb_otg *otg)
 {
-	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
+	struct fsl_otg *otg_dev = container_of(otg->xceiv, struct fsl_otg,
+						xceiv);
 
-	if (!otg_p || otg_dev != fsl_otg_dev
-	    || otg_p->state != USB_PHY_STATE_B_IDLE)
+	if (!otg || otg_dev != fsl_otg_dev
+	    || otg->xceiv->state != USB_PHY_STATE_B_IDLE)
 		return -ENODEV;
 
 	otg_dev->fsm.b_bus_req = 1;
@@ -673,11 +677,12 @@ static int fsl_otg_start_srp(struct usb_phy *otg_p)
 }
 
 /* A_host suspend will call this function to start hnp */
-static int fsl_otg_start_hnp(struct usb_phy *otg_p)
+static int fsl_otg_start_hnp(struct usb_otg *otg)
 {
-	struct fsl_otg *otg_dev = container_of(otg_p, struct fsl_otg, otg);
+	struct fsl_otg *otg_dev = container_of(otg->xceiv, struct fsl_otg,
+						xceiv);
 
-	if (!otg_p || otg_dev != fsl_otg_dev)
+	if (!otg || otg_dev != fsl_otg_dev)
 		return -ENODEV;
 
 	DBG("start_hnp...n");
@@ -698,7 +703,7 @@ static int fsl_otg_start_hnp(struct usb_phy *otg_p)
 irqreturn_t fsl_otg_isr(int irq, void *dev_id)
 {
 	struct otg_fsm *fsm = &((struct fsl_otg *)dev_id)->fsm;
-	struct usb_phy *otg = &((struct fsl_otg *)dev_id)->otg;
+	struct usb_otg *otg = ((struct fsl_otg *)dev_id)->xceiv.otg;
 	u32 otg_int_src, otg_sc;
 
 	otg_sc = fsl_readl(&usb_dr_regs->otgsc);
@@ -774,6 +779,12 @@ static int fsl_otg_conf(struct platform_device *pdev)
 	if (!fsl_otg_tc)
 		return -ENOMEM;
 
+	fsl_otg_tc->xceiv.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!fsl_otg_tc->xceiv.otg) {
+		kfree(fsl_otg_tc);
+		return -ENOMEM;
+	}
+
 	INIT_DELAYED_WORK(&fsl_otg_tc->otg_event, fsl_otg_event);
 
 	INIT_LIST_HEAD(&active_timers);
@@ -788,17 +799,19 @@ static int fsl_otg_conf(struct platform_device *pdev)
 	fsl_otg_tc->fsm.ops = &fsl_otg_ops;
 
 	/* initialize the otg structure */
-	fsl_otg_tc->otg.label = DRIVER_DESC;
-	fsl_otg_tc->otg.set_host = fsl_otg_set_host;
-	fsl_otg_tc->otg.set_peripheral = fsl_otg_set_peripheral;
-	fsl_otg_tc->otg.set_power = fsl_otg_set_power;
-	fsl_otg_tc->otg.start_hnp = fsl_otg_start_hnp;
-	fsl_otg_tc->otg.start_srp = fsl_otg_start_srp;
+	fsl_otg_tc->xceiv.label = DRIVER_DESC;
+	fsl_otg_tc->xceiv.set_power = fsl_otg_set_power;
+
+	fsl_otg_tc->xceiv.otg->xceiv = &fsl_otg_tc->xceiv;
+	fsl_otg_tc->xceiv.otg->set_host = fsl_otg_set_host;
+	fsl_otg_tc->xceiv.otg->set_peripheral = fsl_otg_set_peripheral;
+	fsl_otg_tc->xceiv.otg->start_hnp = fsl_otg_start_hnp;
+	fsl_otg_tc->xceiv.otg->start_srp = fsl_otg_start_srp;
 
 	fsl_otg_dev = fsl_otg_tc;
 
 	/* Store the otg transceiver */
-	status = otg_set_transceiver(&fsl_otg_tc->otg);
+	status = usb_set_transceiver(&fsl_otg_tc->xceiv);
 	if (status) {
 		pr_warn(FSL_OTG_NAME ": unable to register OTG transceiver.\n");
 		goto err;
@@ -807,6 +820,7 @@ static int fsl_otg_conf(struct platform_device *pdev)
 	return 0;
 err:
 	fsl_otg_uninit_timers();
+	kfree(fsl_otg_tc->xceiv.otg);
 	kfree(fsl_otg_tc);
 	return status;
 }
@@ -815,19 +829,19 @@ err:
 int usb_otg_start(struct platform_device *pdev)
 {
 	struct fsl_otg *p_otg;
-	struct usb_phy *otg_trans = otg_get_transceiver();
+	struct usb_phy *otg_trans = usb_get_transceiver();
 	struct otg_fsm *fsm;
 	int status;
 	struct resource *res;
 	u32 temp;
 	struct fsl_usb2_platform_data *pdata = pdev->dev.platform_data;
 
-	p_otg = container_of(otg_trans, struct fsl_otg, otg);
+	p_otg = container_of(otg_trans, struct fsl_otg, xceiv);
 	fsm = &p_otg->fsm;
 
 	/* Initialize the state machine structure with default values */
 	SET_OTG_STATE(otg_trans, USB_PHY_STATE_UNDEFINED);
-	fsm->transceiver = &p_otg->otg;
+	fsm->otg = p_otg->xceiv.otg;
 
 	/* We don't require predefined MEM/IRQ resource index */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -857,9 +871,10 @@ int usb_otg_start(struct platform_device *pdev)
 	status = request_irq(p_otg->irq, fsl_otg_isr,
 				IRQF_SHARED, driver_name, p_otg);
 	if (status) {
-		dev_dbg(p_otg->otg.dev, "can't get IRQ %d, error %d\n",
+		dev_dbg(p_otg->xceiv.dev, "can't get IRQ %d, error %d\n",
 			p_otg->irq, status);
 		iounmap(p_otg->dr_mem_map);
+		kfree(p_otg->xceiv.otg);
 		kfree(p_otg);
 		return status;
 	}
@@ -919,10 +934,10 @@ int usb_otg_start(struct platform_device *pdev)
 	 * Also: record initial state of ID pin
 	 */
 	if (fsl_readl(&p_otg->dr_mem_map->otgsc) & OTGSC_STS_USB_ID) {
-		p_otg->otg.state = USB_PHY_STATE_UNDEFINED;
+		p_otg->xceiv.state = USB_PHY_STATE_UNDEFINED;
 		p_otg->fsm.id = 1;
 	} else {
-		p_otg->otg.state = USB_PHY_STATE_A_IDLE;
+		p_otg->xceiv.state = USB_PHY_STATE_A_IDLE;
 		p_otg->fsm.id = 0;
 	}
 
@@ -978,7 +993,7 @@ static int show_fsl_usb2_otg_state(struct device *dev,
 	/* State */
 	t = scnprintf(next, size,
 		      "OTG state: %s\n\n",
-		      usb_phy_state_string(fsl_otg_dev->otg.state));
+		      usb_phy_state_string(fsl_otg_dev->xceiv.state));
 	size -= t;
 	next += t;
 
@@ -1124,12 +1139,13 @@ static int __devexit fsl_otg_remove(struct platform_device *pdev)
 {
 	struct fsl_usb2_platform_data *pdata = pdev->dev.platform_data;
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 	free_irq(fsl_otg_dev->irq, fsl_otg_dev);
 
 	iounmap((void *)usb_dr_regs);
 
 	fsl_otg_uninit_timers();
+	kfree(fsl_otg_dev->xceiv.otg);
 	kfree(fsl_otg_dev);
 
 	device_remove_file(&pdev->dev, &dev_attr_fsl_usb2_otg_state);
diff --git a/drivers/usb/otg/fsl_otg.h b/drivers/usb/otg/fsl_otg.h
index 33f3997..a474ae2 100644
--- a/drivers/usb/otg/fsl_otg.h
+++ b/drivers/usb/otg/fsl_otg.h
@@ -369,7 +369,7 @@ inline struct fsl_otg_timer *otg_timer_initializer
 }
 
 struct fsl_otg {
-	struct usb_phy otg;
+	struct usb_phy xceiv;
 	struct otg_fsm fsm;
 	struct usb_dr_mmap *dr_mem_map;
 	struct delayed_work otg_event;
diff --git a/drivers/usb/otg/otg_fsm.c b/drivers/usb/otg/otg_fsm.c
index b2feb07..7d94871 100644
--- a/drivers/usb/otg/otg_fsm.c
+++ b/drivers/usb/otg/otg_fsm.c
@@ -117,10 +117,10 @@ void otg_leave_state(struct otg_fsm *fsm, enum usb_phy_state old_state)
 int otg_set_state(struct otg_fsm *fsm, enum usb_phy_state new_state)
 {
 	state_changed = 1;
-	if (fsm->transceiver->state == new_state)
+	if (fsm->otg->xceiv->state == new_state)
 		return 0;
 	VDBG("Set state: %s\n", usb_phy_state_string(new_state));
-	otg_leave_state(fsm, fsm->transceiver->state);
+	otg_leave_state(fsm, fsm->otg->xceiv->state);
 	switch (new_state) {
 	case USB_PHY_STATE_B_IDLE:
 		otg_drv_vbus(fsm, 0);
@@ -155,8 +155,8 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_phy_state new_state)
 		otg_loc_conn(fsm, 0);
 		otg_loc_sof(fsm, 1);
 		otg_set_protocol(fsm, PROTO_HOST);
-		usb_bus_start_enum(fsm->transceiver->host,
-				fsm->transceiver->host->otg_port);
+		usb_bus_start_enum(fsm->otg->host,
+				fsm->otg->host->otg_port);
 		break;
 	case USB_PHY_STATE_A_IDLE:
 		otg_drv_vbus(fsm, 0);
@@ -221,7 +221,7 @@ int otg_set_state(struct otg_fsm *fsm, enum usb_phy_state new_state)
 		break;
 	}
 
-	fsm->transceiver->state = new_state;
+	fsm->otg->xceiv->state = new_state;
 	return 0;
 }
 
@@ -233,7 +233,7 @@ int otg_statemachine(struct otg_fsm *fsm)
 
 	spin_lock_irqsave(&fsm->lock, flags);
 
-	state = fsm->transceiver->state;
+	state = fsm->otg->xceiv->state;
 	state_changed = 0;
 	/* State machine state change judgement */
 
@@ -248,7 +248,7 @@ int otg_statemachine(struct otg_fsm *fsm)
 	case USB_PHY_STATE_B_IDLE:
 		if (!fsm->id)
 			otg_set_state(fsm, USB_PHY_STATE_A_IDLE);
-		else if (fsm->b_sess_vld && fsm->transceiver->gadget)
+		else if (fsm->b_sess_vld && fsm->otg->gadget)
 			otg_set_state(fsm, USB_PHY_STATE_B_PERIPHERAL);
 		else if (fsm->b_bus_req && fsm->b_sess_end && fsm->b_se0_srp)
 			otg_set_state(fsm, USB_PHY_STATE_B_SRP_INIT);
@@ -260,7 +260,7 @@ int otg_statemachine(struct otg_fsm *fsm)
 	case USB_PHY_STATE_B_PERIPHERAL:
 		if (!fsm->id || !fsm->b_sess_vld)
 			otg_set_state(fsm, USB_PHY_STATE_B_IDLE);
-		else if (fsm->b_bus_req && fsm->transceiver->
+		else if (fsm->b_bus_req && fsm->otg->
 				gadget->b_hnp_enable && fsm->a_bus_suspend)
 			otg_set_state(fsm, USB_PHY_STATE_B_WAIT_ACON);
 		break;
@@ -302,7 +302,7 @@ int otg_statemachine(struct otg_fsm *fsm)
 		break;
 	case USB_PHY_STATE_A_HOST:
 		if ((!fsm->a_bus_req || fsm->a_suspend_req) &&
-				fsm->transceiver->host->b_hnp_enable)
+				fsm->otg->host->b_hnp_enable)
 			otg_set_state(fsm, USB_PHY_STATE_A_SUSPEND);
 		else if (fsm->id || !fsm->b_conn || fsm->a_bus_drop)
 			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
@@ -310,9 +310,9 @@ int otg_statemachine(struct otg_fsm *fsm)
 			otg_set_state(fsm, USB_PHY_STATE_A_VBUS_ERR);
 		break;
 	case USB_PHY_STATE_A_SUSPEND:
-		if (!fsm->b_conn && fsm->transceiver->host->b_hnp_enable)
+		if (!fsm->b_conn && fsm->otg->host->b_hnp_enable)
 			otg_set_state(fsm, USB_PHY_STATE_A_PERIPHERAL);
-		else if (!fsm->b_conn && !fsm->transceiver->host->b_hnp_enable)
+		else if (!fsm->b_conn && !fsm->otg->host->b_hnp_enable)
 			otg_set_state(fsm, USB_PHY_STATE_A_WAIT_BCON);
 		else if (fsm->a_bus_req || fsm->b_bus_resume)
 			otg_set_state(fsm, USB_PHY_STATE_A_HOST);
diff --git a/drivers/usb/otg/otg_fsm.h b/drivers/usb/otg/otg_fsm.h
index 5e589ae..c30a2e1 100644
--- a/drivers/usb/otg/otg_fsm.h
+++ b/drivers/usb/otg/otg_fsm.h
@@ -82,7 +82,7 @@ struct otg_fsm {
 	int loc_sof;
 
 	struct otg_fsm_ops *ops;
-	struct usb_phy *transceiver;
+	struct usb_otg *otg;
 
 	/* Current usb protocol used: 0:undefine; 1:host; 2:client */
 	int protocol;
-- 
1.7.4.1

