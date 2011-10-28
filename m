Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab1J1MgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:36:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:24307 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839Ab1J1Mf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="68013638"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv6 13/19] usb: otg: ulpi: Start using struct usb_otg
Date: Fri, 28 Oct 2011 15:35:19 +0300
Message-Id: <1319805325-24689-14-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1319805325-24689-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
---
 arch/arm/mach-pxa/pxa3xx-ulpi.c       |    6 +-
 arch/arm/plat-mxc/include/mach/ulpi.h |    2 +-
 arch/arm/plat-mxc/ulpi.c              |    2 +-
 drivers/usb/otg/ulpi.c                |  114 ++++++++++++++++++---------------
 drivers/usb/otg/ulpi_viewport.c       |    2 +-
 include/linux/usb/ulpi.h              |    4 +-
 6 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/arch/arm/mach-pxa/pxa3xx-ulpi.c b/arch/arm/mach-pxa/pxa3xx-ulpi.c
index 83e185d..a299e11 100644
--- a/arch/arm/mach-pxa/pxa3xx-ulpi.c
+++ b/arch/arm/mach-pxa/pxa3xx-ulpi.c
@@ -111,7 +111,7 @@ static int pxa310_ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 	return pxa310_ulpi_poll();
 }
 
-struct otg_io_access_ops pxa310_ulpi_access_ops = {
+struct usb_phy_io_ops pxa310_ulpi_access_ops = {
 	.read	= pxa310_ulpi_read,
 	.write	= pxa310_ulpi_write,
 };
@@ -139,7 +139,7 @@ static int pxa310_start_otg_host_transcvr(struct usb_bus *host)
 
 	pxa310_otg_transceiver_rtsm();
 
-	err = otg_init(u2d->otg);
+	err = usb_phy_init(u2d->otg);
 	if (err) {
 		pr_err("OTG transceiver init failed");
 		return err;
@@ -191,7 +191,7 @@ static void pxa310_stop_otg_hc(void)
 
 	otg_set_host(u2d->otg, NULL);
 	otg_set_vbus(u2d->otg, 0);
-	otg_shutdown(u2d->otg);
+	usb_phy_shutdown(u2d->otg);
 }
 
 static void pxa310_u2d_setup_otg_hc(void)
diff --git a/arch/arm/plat-mxc/include/mach/ulpi.h b/arch/arm/plat-mxc/include/mach/ulpi.h
index d39d94a..42bdaca 100644
--- a/arch/arm/plat-mxc/include/mach/ulpi.h
+++ b/arch/arm/plat-mxc/include/mach/ulpi.h
@@ -10,7 +10,7 @@ static inline struct usb_phy *imx_otg_ulpi_create(unsigned int flags)
 }
 #endif
 
-extern struct otg_io_access_ops mxc_ulpi_access_ops;
+extern struct usb_phy_io_ops mxc_ulpi_access_ops;
 
 #endif /* __MACH_ULPI_H */
 
diff --git a/arch/arm/plat-mxc/ulpi.c b/arch/arm/plat-mxc/ulpi.c
index 8eeeb6b..d296342 100644
--- a/arch/arm/plat-mxc/ulpi.c
+++ b/arch/arm/plat-mxc/ulpi.c
@@ -106,7 +106,7 @@ static int ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 	return ulpi_poll(view, ULPIVW_RUN);
 }
 
-struct otg_io_access_ops mxc_ulpi_access_ops = {
+struct usb_phy_io_ops mxc_ulpi_access_ops = {
 	.read	= ulpi_read,
 	.write	= ulpi_write,
 };
diff --git a/drivers/usb/otg/ulpi.c b/drivers/usb/otg/ulpi.c
index abc2339..b109258 100644
--- a/drivers/usb/otg/ulpi.c
+++ b/drivers/usb/otg/ulpi.c
@@ -48,31 +48,31 @@ static struct ulpi_info ulpi_ids[] = {
 	ULPI_INFO(ULPI_ID(0x0424, 0x0006), "SMSC USB331x"),
 };
 
-static int ulpi_set_otg_flags(struct usb_phy *otg)
+static int ulpi_set_otg_flags(struct usb_phy *xceiv)
 {
 	unsigned int flags = ULPI_OTG_CTRL_DP_PULLDOWN |
 			     ULPI_OTG_CTRL_DM_PULLDOWN;
 
-	if (otg->flags & ULPI_OTG_ID_PULLUP)
+	if (xceiv->flags & ULPI_OTG_ID_PULLUP)
 		flags |= ULPI_OTG_CTRL_ID_PULLUP;
 
 	/*
 	 * ULPI Specification rev.1.1 default
 	 * for Dp/DmPulldown is enabled.
 	 */
-	if (otg->flags & ULPI_OTG_DP_PULLDOWN_DIS)
+	if (xceiv->flags & ULPI_OTG_DP_PULLDOWN_DIS)
 		flags &= ~ULPI_OTG_CTRL_DP_PULLDOWN;
 
-	if (otg->flags & ULPI_OTG_DM_PULLDOWN_DIS)
+	if (xceiv->flags & ULPI_OTG_DM_PULLDOWN_DIS)
 		flags &= ~ULPI_OTG_CTRL_DM_PULLDOWN;
 
-	if (otg->flags & ULPI_OTG_EXTVBUSIND)
+	if (xceiv->flags & ULPI_OTG_EXTVBUSIND)
 		flags |= ULPI_OTG_CTRL_EXTVBUSIND;
 
-	return otg_io_write(otg, flags, ULPI_OTG_CTRL);
+	return usb_phy_io_write(xceiv, flags, ULPI_OTG_CTRL);
 }
 
-static int ulpi_set_fc_flags(struct usb_phy *otg)
+static int ulpi_set_fc_flags(struct usb_phy *xceiv)
 {
 	unsigned int flags = 0;
 
@@ -80,27 +80,27 @@ static int ulpi_set_fc_flags(struct usb_phy *otg)
 	 * ULPI Specification rev.1.1 default
 	 * for XcvrSelect is Full Speed.
 	 */
-	if (otg->flags & ULPI_FC_HS)
+	if (xceiv->flags & ULPI_FC_HS)
 		flags |= ULPI_FUNC_CTRL_HIGH_SPEED;
-	else if (otg->flags & ULPI_FC_LS)
+	else if (xceiv->flags & ULPI_FC_LS)
 		flags |= ULPI_FUNC_CTRL_LOW_SPEED;
-	else if (otg->flags & ULPI_FC_FS4LS)
+	else if (xceiv->flags & ULPI_FC_FS4LS)
 		flags |= ULPI_FUNC_CTRL_FS4LS;
 	else
 		flags |= ULPI_FUNC_CTRL_FULL_SPEED;
 
-	if (otg->flags & ULPI_FC_TERMSEL)
+	if (xceiv->flags & ULPI_FC_TERMSEL)
 		flags |= ULPI_FUNC_CTRL_TERMSELECT;
 
 	/*
 	 * ULPI Specification rev.1.1 default
 	 * for OpMode is Normal Operation.
 	 */
-	if (otg->flags & ULPI_FC_OP_NODRV)
+	if (xceiv->flags & ULPI_FC_OP_NODRV)
 		flags |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-	else if (otg->flags & ULPI_FC_OP_DIS_NRZI)
+	else if (xceiv->flags & ULPI_FC_OP_DIS_NRZI)
 		flags |= ULPI_FUNC_CTRL_OPMODE_DISABLE_NRZI;
-	else if (otg->flags & ULPI_FC_OP_NSYNC_NEOP)
+	else if (xceiv->flags & ULPI_FC_OP_NSYNC_NEOP)
 		flags |= ULPI_FUNC_CTRL_OPMODE_NOSYNC_NOEOP;
 	else
 		flags |= ULPI_FUNC_CTRL_OPMODE_NORMAL;
@@ -111,54 +111,54 @@ static int ulpi_set_fc_flags(struct usb_phy *otg)
 	 */
 	flags |= ULPI_FUNC_CTRL_SUSPENDM;
 
-	return otg_io_write(otg, flags, ULPI_FUNC_CTRL);
+	return usb_phy_io_write(xceiv, flags, ULPI_FUNC_CTRL);
 }
 
-static int ulpi_set_ic_flags(struct usb_phy *otg)
+static int ulpi_set_ic_flags(struct usb_phy *xceiv)
 {
 	unsigned int flags = 0;
 
-	if (otg->flags & ULPI_IC_AUTORESUME)
+	if (xceiv->flags & ULPI_IC_AUTORESUME)
 		flags |= ULPI_IFC_CTRL_AUTORESUME;
 
-	if (otg->flags & ULPI_IC_EXTVBUS_INDINV)
+	if (xceiv->flags & ULPI_IC_EXTVBUS_INDINV)
 		flags |= ULPI_IFC_CTRL_EXTERNAL_VBUS;
 
-	if (otg->flags & ULPI_IC_IND_PASSTHRU)
+	if (xceiv->flags & ULPI_IC_IND_PASSTHRU)
 		flags |= ULPI_IFC_CTRL_PASSTHRU;
 
-	if (otg->flags & ULPI_IC_PROTECT_DIS)
+	if (xceiv->flags & ULPI_IC_PROTECT_DIS)
 		flags |= ULPI_IFC_CTRL_PROTECT_IFC_DISABLE;
 
-	return otg_io_write(otg, flags, ULPI_IFC_CTRL);
+	return usb_phy_io_write(xceiv, flags, ULPI_IFC_CTRL);
 }
 
-static int ulpi_set_flags(struct usb_phy *otg)
+static int ulpi_set_flags(struct usb_phy *xceiv)
 {
 	int ret;
 
-	ret = ulpi_set_otg_flags(otg);
+	ret = ulpi_set_otg_flags(xceiv);
 	if (ret)
 		return ret;
 
-	ret = ulpi_set_ic_flags(otg);
+	ret = ulpi_set_ic_flags(xceiv);
 	if (ret)
 		return ret;
 
-	return ulpi_set_fc_flags(otg);
+	return ulpi_set_fc_flags(xceiv);
 }
 
-static int ulpi_check_integrity(struct usb_phy *otg)
+static int ulpi_check_integrity(struct usb_phy *xceiv)
 {
 	int ret, i;
 	unsigned int val = 0x55;
 
 	for (i = 0; i < 2; i++) {
-		ret = otg_io_write(otg, val, ULPI_SCRATCH);
+		ret = usb_phy_io_write(xceiv, val, ULPI_SCRATCH);
 		if (ret < 0)
 			return ret;
 
-		ret = otg_io_read(otg, ULPI_SCRATCH);
+		ret = usb_phy_io_read(xceiv, ULPI_SCRATCH);
 		if (ret < 0)
 			return ret;
 
@@ -174,13 +174,13 @@ static int ulpi_check_integrity(struct usb_phy *otg)
 	return 0;
 }
 
-static int ulpi_init(struct usb_phy *otg)
+static int ulpi_init(struct usb_phy *xceiv)
 {
 	int i, vid, pid, ret;
 	u32 ulpi_id = 0;
 
 	for (i = 0; i < 4; i++) {
-		ret = otg_io_read(otg, ULPI_PRODUCT_ID_HIGH - i);
+		ret = usb_phy_io_read(xceiv, ULPI_PRODUCT_ID_HIGH - i);
 		if (ret < 0)
 			return ret;
 		ulpi_id = (ulpi_id << 8) | ret;
@@ -198,16 +198,17 @@ static int ulpi_init(struct usb_phy *otg)
 		}
 	}
 
-	ret = ulpi_check_integrity(otg);
+	ret = ulpi_check_integrity(xceiv);
 	if (ret)
 		return ret;
 
-	return ulpi_set_flags(otg);
+	return ulpi_set_flags(xceiv);
 }
 
-static int ulpi_set_host(struct usb_phy *otg, struct usb_bus *host)
+static int ulpi_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	unsigned int flags = otg_io_read(otg, ULPI_IFC_CTRL);
+	struct usb_phy *xceiv = otg->xceiv;
+	unsigned int flags = usb_phy_io_read(xceiv, ULPI_IFC_CTRL);
 
 	if (!host) {
 		otg->host = NULL;
@@ -220,51 +221,62 @@ static int ulpi_set_host(struct usb_phy *otg, struct usb_bus *host)
 		   ULPI_IFC_CTRL_3_PIN_SERIAL_MODE |
 		   ULPI_IFC_CTRL_CARKITMODE);
 
-	if (otg->flags & ULPI_IC_6PIN_SERIAL)
+	if (xceiv->flags & ULPI_IC_6PIN_SERIAL)
 		flags |= ULPI_IFC_CTRL_6_PIN_SERIAL_MODE;
-	else if (otg->flags & ULPI_IC_3PIN_SERIAL)
+	else if (xceiv->flags & ULPI_IC_3PIN_SERIAL)
 		flags |= ULPI_IFC_CTRL_3_PIN_SERIAL_MODE;
-	else if (otg->flags & ULPI_IC_CARKIT)
+	else if (xceiv->flags & ULPI_IC_CARKIT)
 		flags |= ULPI_IFC_CTRL_CARKITMODE;
 
-	return otg_io_write(otg, flags, ULPI_IFC_CTRL);
+	return usb_phy_io_write(xceiv, flags, ULPI_IFC_CTRL);
 }
 
-static int ulpi_set_vbus(struct usb_phy *otg, bool on)
+static int ulpi_set_vbus(struct usb_otg *otg, bool on)
 {
-	unsigned int flags = otg_io_read(otg, ULPI_OTG_CTRL);
+	struct usb_phy *xceiv = otg->xceiv;
+	unsigned int flags = usb_phy_io_read(xceiv, ULPI_OTG_CTRL);
 
 	flags &= ~(ULPI_OTG_CTRL_DRVVBUS | ULPI_OTG_CTRL_DRVVBUS_EXT);
 
 	if (on) {
-		if (otg->flags & ULPI_OTG_DRVVBUS)
+		if (xceiv->flags & ULPI_OTG_DRVVBUS)
 			flags |= ULPI_OTG_CTRL_DRVVBUS;
 
-		if (otg->flags & ULPI_OTG_DRVVBUS_EXT)
+		if (xceiv->flags & ULPI_OTG_DRVVBUS_EXT)
 			flags |= ULPI_OTG_CTRL_DRVVBUS_EXT;
 	}
 
-	return otg_io_write(otg, flags, ULPI_OTG_CTRL);
+	return usb_phy_io_write(xceiv, flags, ULPI_OTG_CTRL);
 }
 
 struct usb_phy *
-otg_ulpi_create(struct otg_io_access_ops *ops,
+otg_ulpi_create(struct usb_phy_io_ops *ops,
 		unsigned int flags)
 {
-	struct usb_phy *otg;
+	struct usb_phy *xceiv;
+	struct usb_otg *otg;
+
+	xceiv = kzalloc(sizeof(*xceiv), GFP_KERNEL);
+	if (!xceiv)
+		return NULL;
 
 	otg = kzalloc(sizeof(*otg), GFP_KERNEL);
-	if (!otg)
+	if (!otg) {
+		kfree(xceiv);
 		return NULL;
+	}
+
+	xceiv->label	= "ULPI";
+	xceiv->flags	= flags;
+	xceiv->io_ops	= ops;
+	xceiv->otg	= otg;
+	xceiv->init	= ulpi_init;
 
-	otg->label	= "ULPI";
-	otg->flags	= flags;
-	otg->io_ops	= ops;
-	otg->init	= ulpi_init;
+	otg->xceiv	= xceiv;
 	otg->set_host	= ulpi_set_host;
 	otg->set_vbus	= ulpi_set_vbus;
 
-	return otg;
+	return xceiv;
 }
 EXPORT_SYMBOL_GPL(otg_ulpi_create);
 
diff --git a/drivers/usb/otg/ulpi_viewport.c b/drivers/usb/otg/ulpi_viewport.c
index e7b311b..c5ba7e5 100644
--- a/drivers/usb/otg/ulpi_viewport.c
+++ b/drivers/usb/otg/ulpi_viewport.c
@@ -74,7 +74,7 @@ static int ulpi_viewport_write(struct usb_phy *otg, u32 val, u32 reg)
 	return ulpi_viewport_wait(view, ULPI_VIEW_RUN);
 }
 
-struct otg_io_access_ops ulpi_viewport_access_ops = {
+struct usb_phy_io_ops ulpi_viewport_access_ops = {
 	.read	= ulpi_viewport_read,
 	.write	= ulpi_viewport_write,
 };
diff --git a/include/linux/usb/ulpi.h b/include/linux/usb/ulpi.h
index 51ebf72..6f033a4 100644
--- a/include/linux/usb/ulpi.h
+++ b/include/linux/usb/ulpi.h
@@ -181,12 +181,12 @@
 
 /*-------------------------------------------------------------------------*/
 
-struct usb_phy *otg_ulpi_create(struct otg_io_access_ops *ops,
+struct usb_phy *otg_ulpi_create(struct usb_phy_io_ops *ops,
 					unsigned int flags);
 
 #ifdef CONFIG_USB_ULPI_VIEWPORT
 /* access ops for controllers with a viewport register */
-extern struct otg_io_access_ops ulpi_viewport_access_ops;
+extern struct usb_phy_io_ops ulpi_viewport_access_ops;
 #endif
 
 #endif /* __LINUX_USB_ULPI_H */
-- 
1.7.4.1

