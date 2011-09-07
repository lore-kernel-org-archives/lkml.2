Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab1IGRIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 13:08:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:12781 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab1IGQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="45953793"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>,
        Lin Tony-B19295 <B19295@freescale.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCHv4 08/19] usb: otg: msm: Start using struct usb_otg
Date: Wed,  7 Sep 2011 10:16:01 +0300
Message-Id: <1315379772-8830-9-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1315379772-8830-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use struct usb_otg members with OTG specific functions instead
of usb_phy members.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 drivers/usb/otg/msm_otg.c     |  398 +++++++++++++++++++++--------------------
 include/linux/usb/msm_hsusb.h |    2 +-
 2 files changed, 206 insertions(+), 194 deletions(-)

diff --git a/drivers/usb/otg/msm_otg.c b/drivers/usb/otg/msm_otg.c
index c468db6..eb1e34c 100644
--- a/drivers/usb/otg/msm_otg.c
+++ b/drivers/usb/otg/msm_otg.c
@@ -69,9 +69,9 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 	int ret = 0;
 
 	if (init) {
-		hsusb_vddcx = regulator_get(motg->otg.dev, "HSUSB_VDDCX");
+		hsusb_vddcx = regulator_get(motg->xceiv.dev, "HSUSB_VDDCX");
 		if (IS_ERR(hsusb_vddcx)) {
-			dev_err(motg->otg.dev, "unable to get hsusb vddcx\n");
+			dev_err(motg->xceiv.dev, "unable to get hsusb vddcx\n");
 			return PTR_ERR(hsusb_vddcx);
 		}
 
@@ -79,7 +79,7 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 				USB_PHY_VDD_DIG_VOL_MIN,
 				USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret) {
-			dev_err(motg->otg.dev, "unable to set the voltage "
+			dev_err(motg->xceiv.dev, "unable to set the voltage "
 					"for hsusb vddcx\n");
 			regulator_put(hsusb_vddcx);
 			return ret;
@@ -87,18 +87,18 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
 
 		ret = regulator_enable(hsusb_vddcx);
 		if (ret) {
-			dev_err(motg->otg.dev, "unable to enable hsusb vddcx\n");
+			dev_err(motg->xceiv.dev, "unable to enable hsusb vddcx\n");
 			regulator_put(hsusb_vddcx);
 		}
 	} else {
 		ret = regulator_set_voltage(hsusb_vddcx, 0,
 			USB_PHY_VDD_DIG_VOL_MAX);
 		if (ret)
-			dev_err(motg->otg.dev, "unable to set the voltage "
+			dev_err(motg->xceiv.dev, "unable to set the voltage "
 					"for hsusb vddcx\n");
 		ret = regulator_disable(hsusb_vddcx);
 		if (ret)
-			dev_err(motg->otg.dev, "unable to disable hsusb vddcx\n");
+			dev_err(motg->xceiv.dev, "unable to disable hsusb vddcx\n");
 
 		regulator_put(hsusb_vddcx);
 	}
@@ -111,40 +111,40 @@ static int msm_hsusb_ldo_init(struct msm_otg *motg, int init)
 	int rc = 0;
 
 	if (init) {
-		hsusb_3p3 = regulator_get(motg->otg.dev, "HSUSB_3p3");
+		hsusb_3p3 = regulator_get(motg->xceiv.dev, "HSUSB_3p3");
 		if (IS_ERR(hsusb_3p3)) {
-			dev_err(motg->otg.dev, "unable to get hsusb 3p3\n");
+			dev_err(motg->xceiv.dev, "unable to get hsusb 3p3\n");
 			return PTR_ERR(hsusb_3p3);
 		}
 
 		rc = regulator_set_voltage(hsusb_3p3, USB_PHY_3P3_VOL_MIN,
 				USB_PHY_3P3_VOL_MAX);
 		if (rc) {
-			dev_err(motg->otg.dev, "unable to set voltage level "
+			dev_err(motg->xceiv.dev, "unable to set voltage level "
 					"for hsusb 3p3\n");
 			goto put_3p3;
 		}
 		rc = regulator_enable(hsusb_3p3);
 		if (rc) {
-			dev_err(motg->otg.dev, "unable to enable the hsusb 3p3\n");
+			dev_err(motg->xceiv.dev, "unable to enable the hsusb 3p3\n");
 			goto put_3p3;
 		}
-		hsusb_1p8 = regulator_get(motg->otg.dev, "HSUSB_1p8");
+		hsusb_1p8 = regulator_get(motg->xceiv.dev, "HSUSB_1p8");
 		if (IS_ERR(hsusb_1p8)) {
-			dev_err(motg->otg.dev, "unable to get hsusb 1p8\n");
+			dev_err(motg->xceiv.dev, "unable to get hsusb 1p8\n");
 			rc = PTR_ERR(hsusb_1p8);
 			goto disable_3p3;
 		}
 		rc = regulator_set_voltage(hsusb_1p8, USB_PHY_1P8_VOL_MIN,
 				USB_PHY_1P8_VOL_MAX);
 		if (rc) {
-			dev_err(motg->otg.dev, "unable to set voltage level "
+			dev_err(motg->xceiv.dev, "unable to set voltage level "
 					"for hsusb 1p8\n");
 			goto put_1p8;
 		}
 		rc = regulator_enable(hsusb_1p8);
 		if (rc) {
-			dev_err(motg->otg.dev, "unable to enable the hsusb 1p8\n");
+			dev_err(motg->xceiv.dev, "unable to enable the hsusb 1p8\n");
 			goto put_1p8;
 		}
 
@@ -235,9 +235,9 @@ static int msm_hsusb_ldo_set_mode(int on)
 	return ret < 0 ? ret : 0;
 }
 
-static int ulpi_read(struct usb_phy *otg, u32 reg)
+static int ulpi_read(struct usb_phy *xceiv, u32 reg)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 	int cnt = 0;
 
 	/* initiate read operation */
@@ -253,16 +253,16 @@ static int ulpi_read(struct usb_phy *otg, u32 reg)
 	}
 
 	if (cnt >= ULPI_IO_TIMEOUT_USEC) {
-		dev_err(otg->dev, "ulpi_read: timeout %08x\n",
+		dev_err(xceiv->dev, "ulpi_read: timeout %08x\n",
 			readl(USB_ULPI_VIEWPORT));
 		return -ETIMEDOUT;
 	}
 	return ULPI_DATA_READ(readl(USB_ULPI_VIEWPORT));
 }
 
-static int ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
+static int ulpi_write(struct usb_phy *xceiv, u32 val, u32 reg)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 	int cnt = 0;
 
 	/* initiate write operation */
@@ -279,13 +279,13 @@ static int ulpi_write(struct usb_phy *otg, u32 val, u32 reg)
 	}
 
 	if (cnt >= ULPI_IO_TIMEOUT_USEC) {
-		dev_err(otg->dev, "ulpi_write: timeout\n");
+		dev_err(xceiv->dev, "ulpi_write: timeout\n");
 		return -ETIMEDOUT;
 	}
 	return 0;
 }
 
-static struct otg_io_access_ops msm_otg_io_ops = {
+static struct usb_phy_io_ops msm_otg_io_ops = {
 	.read = ulpi_read,
 	.write = ulpi_write,
 };
@@ -299,9 +299,9 @@ static void ulpi_init(struct msm_otg *motg)
 		return;
 
 	while (seq[0] >= 0) {
-		dev_vdbg(motg->otg.dev, "ulpi: write 0x%02x to 0x%02x\n",
+		dev_vdbg(motg->xceiv.dev, "ulpi: write 0x%02x to 0x%02x\n",
 				seq[0], seq[1]);
-		ulpi_write(&motg->otg, seq[0], seq[1]);
+		ulpi_write(&motg->xceiv, seq[0], seq[1]);
 		seq += 2;
 	}
 }
@@ -313,11 +313,11 @@ static int msm_otg_link_clk_reset(struct msm_otg *motg, bool assert)
 	if (assert) {
 		ret = clk_reset(motg->clk, CLK_RESET_ASSERT);
 		if (ret)
-			dev_err(motg->otg.dev, "usb hs_clk assert failed\n");
+			dev_err(motg->xceiv.dev, "usb hs_clk assert failed\n");
 	} else {
 		ret = clk_reset(motg->clk, CLK_RESET_DEASSERT);
 		if (ret)
-			dev_err(motg->otg.dev, "usb hs_clk deassert failed\n");
+			dev_err(motg->xceiv.dev, "usb hs_clk deassert failed\n");
 	}
 	return ret;
 }
@@ -328,13 +328,13 @@ static int msm_otg_phy_clk_reset(struct msm_otg *motg)
 
 	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_ASSERT);
 	if (ret) {
-		dev_err(motg->otg.dev, "usb phy clk assert failed\n");
+		dev_err(motg->xceiv.dev, "usb phy clk assert failed\n");
 		return ret;
 	}
 	usleep_range(10000, 12000);
 	ret = clk_reset(motg->phy_reset_clk, CLK_RESET_DEASSERT);
 	if (ret)
-		dev_err(motg->otg.dev, "usb phy clk deassert failed\n");
+		dev_err(motg->xceiv.dev, "usb phy clk deassert failed\n");
 	return ret;
 }
 
@@ -358,7 +358,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 	writel(val | PORTSC_PTS_ULPI, USB_PORTSC);
 
 	for (retries = 3; retries > 0; retries--) {
-		ret = ulpi_write(&motg->otg, ULPI_FUNC_CTRL_SUSPENDM,
+		ret = ulpi_write(&motg->xceiv, ULPI_FUNC_CTRL_SUSPENDM,
 				ULPI_CLR(ULPI_FUNC_CTRL));
 		if (!ret)
 			break;
@@ -375,7 +375,7 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 		return ret;
 
 	for (retries = 3; retries > 0; retries--) {
-		ret = ulpi_read(&motg->otg, ULPI_DEBUG);
+		ret = ulpi_read(&motg->xceiv, ULPI_DEBUG);
 		if (ret != -ETIMEDOUT)
 			break;
 		ret = msm_otg_phy_clk_reset(motg);
@@ -385,14 +385,14 @@ static int msm_otg_phy_reset(struct msm_otg *motg)
 	if (!retries)
 		return -ETIMEDOUT;
 
-	dev_info(motg->otg.dev, "phy_reset: success\n");
+	dev_info(motg->xceiv.dev, "phy_reset: success\n");
 	return 0;
 }
 
 #define LINK_RESET_TIMEOUT_USEC		(250 * 1000)
-static int msm_otg_reset(struct usb_phy *otg)
+static int msm_otg_reset(struct usb_phy *xceiv)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 	struct msm_otg_platform_data *pdata = motg->pdata;
 	int cnt = 0;
 	int ret;
@@ -401,7 +401,7 @@ static int msm_otg_reset(struct usb_phy *otg)
 
 	ret = msm_otg_phy_reset(motg);
 	if (ret) {
-		dev_err(otg->dev, "phy_reset failed\n");
+		dev_err(xceiv->dev, "phy_reset failed\n");
 		return ret;
 	}
 
@@ -435,8 +435,8 @@ static int msm_otg_reset(struct usb_phy *otg)
 			val |= OTGSC_BSVIE;
 		}
 		writel(val, USB_OTGSC);
-		ulpi_write(otg, ulpi_val, ULPI_USB_INT_EN_RISE);
-		ulpi_write(otg, ulpi_val, ULPI_USB_INT_EN_FALL);
+		ulpi_write(xceiv, ulpi_val, ULPI_USB_INT_EN_RISE);
+		ulpi_write(xceiv, ulpi_val, ULPI_USB_INT_EN_FALL);
 	}
 
 	return 0;
@@ -448,8 +448,8 @@ static int msm_otg_reset(struct usb_phy *otg)
 #ifdef CONFIG_PM_SLEEP
 static int msm_otg_suspend(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
-	struct usb_bus *bus = otg->host;
+	struct usb_phy *xceiv = &motg->xceiv;
+	struct usb_bus *bus = xceiv->otg->host;
 	struct msm_otg_platform_data *pdata = motg->pdata;
 	int cnt = 0;
 
@@ -475,10 +475,10 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	 */
 
 	if (motg->pdata->phy_type == CI_45NM_INTEGRATED_PHY) {
-		ulpi_read(otg, 0x14);
+		ulpi_read(xceiv, 0x14);
 		if (pdata->otg_control == OTG_PHY_CONTROL)
-			ulpi_write(otg, 0x01, 0x30);
-		ulpi_write(otg, 0x08, 0x09);
+			ulpi_write(xceiv, 0x01, 0x30);
+		ulpi_write(xceiv, 0x08, 0x09);
 	}
 
 	/*
@@ -495,8 +495,8 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	}
 
 	if (cnt >= PHY_SUSPEND_TIMEOUT_USEC) {
-		dev_err(otg->dev, "Unable to suspend PHY\n");
-		msm_otg_reset(otg);
+		dev_err(xceiv->dev, "Unable to suspend PHY\n");
+		msm_otg_reset(xceiv);
 		enable_irq(motg->irq);
 		return -ETIMEDOUT;
 	}
@@ -528,7 +528,7 @@ static int msm_otg_suspend(struct msm_otg *motg)
 		msm_hsusb_config_vddcx(0);
 	}
 
-	if (device_may_wakeup(otg->dev))
+	if (device_may_wakeup(xceiv->dev))
 		enable_irq_wake(motg->irq);
 	if (bus)
 		clear_bit(HCD_FLAG_HW_ACCESSIBLE, &(bus_to_hcd(bus))->flags);
@@ -536,15 +536,15 @@ static int msm_otg_suspend(struct msm_otg *motg)
 	atomic_set(&motg->in_lpm, 1);
 	enable_irq(motg->irq);
 
-	dev_info(otg->dev, "USB in low power mode\n");
+	dev_info(xceiv->dev, "USB in low power mode\n");
 
 	return 0;
 }
 
 static int msm_otg_resume(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
-	struct usb_bus *bus = otg->host;
+	struct usb_phy *xceiv = &motg->xceiv;
+	struct usb_bus *bus = xceiv->otg->host;
 	int cnt = 0;
 	unsigned temp;
 
@@ -592,13 +592,13 @@ static int msm_otg_resume(struct msm_otg *motg)
 		 * PHY. USB state can not be restored. Re-insertion
 		 * of USB cable is the only way to get USB working.
 		 */
-		dev_err(otg->dev, "Unable to resume USB."
+		dev_err(xceiv->dev, "Unable to resume USB."
 				"Re-plugin the cable\n");
-		msm_otg_reset(otg);
+		msm_otg_reset(xceiv);
 	}
 
 skip_phy_resume:
-	if (device_may_wakeup(otg->dev))
+	if (device_may_wakeup(xceiv->dev))
 		disable_irq_wake(motg->irq);
 	if (bus)
 		set_bit(HCD_FLAG_HW_ACCESSIBLE, &(bus_to_hcd(bus))->flags);
@@ -607,11 +607,11 @@ skip_phy_resume:
 
 	if (motg->async_int) {
 		motg->async_int = 0;
-		pm_runtime_put(otg->dev);
+		pm_runtime_put(xceiv->dev);
 		enable_irq(motg->irq);
 	}
 
-	dev_info(otg->dev, "USB exited from low power mode\n");
+	dev_info(xceiv->dev, "USB exited from low power mode\n");
 
 	return 0;
 }
@@ -623,13 +623,13 @@ static void msm_otg_notify_charger(struct msm_otg *motg, unsigned mA)
 		return;
 
 	/* TODO: Notify PMIC about available current */
-	dev_info(motg->otg.dev, "Avail curr from USB = %u\n", mA);
+	dev_info(motg->xceiv.dev, "Avail curr from USB = %u\n", mA);
 	motg->cur_power = mA;
 }
 
-static int msm_otg_set_power(struct usb_phy *otg, unsigned mA)
+static int msm_otg_set_power(struct usb_phy *xceiv, unsigned mA)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 
 	/*
 	 * Gadget driver uses set_power method to notify about the
@@ -644,19 +644,19 @@ static int msm_otg_set_power(struct usb_phy *otg, unsigned mA)
 	return 0;
 }
 
-static void msm_otg_start_host(struct usb_phy *otg, int on)
+static void msm_otg_start_host(struct usb_phy *xceiv, int on)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 	struct msm_otg_platform_data *pdata = motg->pdata;
 	struct usb_hcd *hcd;
 
-	if (!otg->host)
+	if (!xceiv->otg->host)
 		return;
 
-	hcd = bus_to_hcd(otg->host);
+	hcd = bus_to_hcd(xceiv->otg->host);
 
 	if (on) {
-		dev_dbg(otg->dev, "host on\n");
+		dev_dbg(xceiv->dev, "host on\n");
 
 		if (pdata->vbus_power)
 			pdata->vbus_power(1);
@@ -671,7 +671,7 @@ static void msm_otg_start_host(struct usb_phy *otg, int on)
 		usb_add_hcd(hcd, hcd->irq, IRQF_SHARED);
 #endif
 	} else {
-		dev_dbg(otg->dev, "host off\n");
+		dev_dbg(xceiv->dev, "host off\n");
 
 #ifdef CONFIG_USB
 		usb_remove_hcd(hcd);
@@ -683,9 +683,9 @@ static void msm_otg_start_host(struct usb_phy *otg, int on)
 	}
 }
 
-static int msm_otg_set_host(struct usb_phy *otg, struct usb_bus *host)
+static int msm_otg_set_host(struct usb_otg *otg, struct usb_bus *host)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(otg->xceiv, struct msm_otg, xceiv);
 	struct usb_hcd *hcd;
 
 	/*
@@ -693,16 +693,16 @@ static int msm_otg_set_host(struct usb_phy *otg, struct usb_bus *host)
 	 * only peripheral configuration.
 	 */
 	if (motg->pdata->mode == USB_PERIPHERAL) {
-		dev_info(otg->dev, "Host mode is not supported\n");
+		dev_info(otg->xceiv->dev, "Host mode is not supported\n");
 		return -ENODEV;
 	}
 
 	if (!host) {
-		if (otg->state == USB_PHY_STATE_A_HOST) {
-			pm_runtime_get_sync(otg->dev);
-			msm_otg_start_host(otg, 0);
+		if (otg->xceiv->state == USB_PHY_STATE_A_HOST) {
+			pm_runtime_get_sync(otg->xceiv->dev);
+			msm_otg_start_host(otg->xceiv, 0);
 			otg->host = NULL;
-			otg->state = USB_PHY_STATE_UNDEFINED;
+			otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->host = NULL;
@@ -715,30 +715,30 @@ static int msm_otg_set_host(struct usb_phy *otg, struct usb_bus *host)
 	hcd->power_budget = motg->pdata->power_budget;
 
 	otg->host = host;
-	dev_dbg(otg->dev, "host driver registered w/ tranceiver\n");
+	dev_dbg(otg->xceiv->dev, "host driver registered w/ tranceiver\n");
 
 	/*
 	 * Kick the state machine work, if peripheral is not supported
 	 * or peripheral is already registered with us.
 	 */
 	if (motg->pdata->mode == USB_HOST || otg->gadget) {
-		pm_runtime_get_sync(otg->dev);
+		pm_runtime_get_sync(otg->xceiv->dev);
 		schedule_work(&motg->sm_work);
 	}
 
 	return 0;
 }
 
-static void msm_otg_start_peripheral(struct usb_phy *otg, int on)
+static void msm_otg_start_peripheral(struct usb_phy *xceiv, int on)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(xceiv, struct msm_otg, xceiv);
 	struct msm_otg_platform_data *pdata = motg->pdata;
 
-	if (!otg->gadget)
+	if (!xceiv->otg->gadget)
 		return;
 
 	if (on) {
-		dev_dbg(otg->dev, "gadget on\n");
+		dev_dbg(xceiv->dev, "gadget on\n");
 		/*
 		 * Some boards have a switch cotrolled by gpio
 		 * to enable/disable internal HUB. Disable internal
@@ -746,36 +746,36 @@ static void msm_otg_start_peripheral(struct usb_phy *otg, int on)
 		 */
 		if (pdata->setup_gpio)
 			pdata->setup_gpio(USB_PHY_STATE_B_PERIPHERAL);
-		usb_gadget_vbus_connect(otg->gadget);
+		usb_gadget_vbus_connect(xceiv->otg->gadget);
 	} else {
-		dev_dbg(otg->dev, "gadget off\n");
-		usb_gadget_vbus_disconnect(otg->gadget);
+		dev_dbg(xceiv->dev, "gadget off\n");
+		usb_gadget_vbus_disconnect(xceiv->otg->gadget);
 		if (pdata->setup_gpio)
 			pdata->setup_gpio(USB_PHY_STATE_UNDEFINED);
 	}
 
 }
 
-static int msm_otg_set_peripheral(struct usb_phy *otg,
-			struct usb_gadget *gadget)
+static int msm_otg_set_peripheral(struct usb_otg *otg,
+					struct usb_gadget *gadget)
 {
-	struct msm_otg *motg = container_of(otg, struct msm_otg, otg);
+	struct msm_otg *motg = container_of(otg->xceiv, struct msm_otg, xceiv);
 
 	/*
 	 * Fail peripheral registration if this board can support
 	 * only host configuration.
 	 */
 	if (motg->pdata->mode == USB_HOST) {
-		dev_info(otg->dev, "Peripheral mode is not supported\n");
+		dev_info(otg->xceiv->dev, "Peripheral mode is not supported\n");
 		return -ENODEV;
 	}
 
 	if (!gadget) {
-		if (otg->state == USB_PHY_STATE_B_PERIPHERAL) {
-			pm_runtime_get_sync(otg->dev);
-			msm_otg_start_peripheral(otg, 0);
+		if (otg->xceiv->state == USB_PHY_STATE_B_PERIPHERAL) {
+			pm_runtime_get_sync(otg->xceiv->dev);
+			msm_otg_start_peripheral(otg->xceiv, 0);
 			otg->gadget = NULL;
-			otg->state = USB_PHY_STATE_UNDEFINED;
+			otg->xceiv->state = USB_PHY_STATE_UNDEFINED;
 			schedule_work(&motg->sm_work);
 		} else {
 			otg->gadget = NULL;
@@ -784,14 +784,14 @@ static int msm_otg_set_peripheral(struct usb_phy *otg,
 		return 0;
 	}
 	otg->gadget = gadget;
-	dev_dbg(otg->dev, "peripheral driver registered w/ tranceiver\n");
+	dev_dbg(otg->xceiv->dev, "peripheral driver registered w/ tranceiver\n");
 
 	/*
 	 * Kick the state machine work, if host is not supported
 	 * or host is already registered with us.
 	 */
 	if (motg->pdata->mode == USB_PERIPHERAL || otg->host) {
-		pm_runtime_get_sync(otg->dev);
+		pm_runtime_get_sync(otg->xceiv->dev);
 		schedule_work(&motg->sm_work);
 	}
 
@@ -800,17 +800,17 @@ static int msm_otg_set_peripheral(struct usb_phy *otg,
 
 static bool msm_chg_check_secondary_det(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 	bool ret = false;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		ret = chg_det & (1 << 4);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x87);
+		chg_det = ulpi_read(xceiv, 0x87);
 		ret = chg_det & 1;
 		break;
 	default:
@@ -821,38 +821,38 @@ static bool msm_chg_check_secondary_det(struct msm_otg *motg)
 
 static void msm_chg_enable_secondary_det(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		/* Turn off charger block */
 		chg_det |= ~(1 << 1);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		udelay(20);
 		/* control chg block via ULPI */
 		chg_det &= ~(1 << 3);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		/* put it in host mode for enabling D- source */
 		chg_det &= ~(1 << 2);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		/* Turn on chg detect block */
 		chg_det &= ~(1 << 1);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		udelay(20);
 		/* enable chg detection */
 		chg_det &= ~(1 << 0);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
 		/*
 		 * Configure DM as current source, DP as current sink
 		 * and enable battery charging comparators.
 		 */
-		ulpi_write(otg, 0x8, 0x85);
-		ulpi_write(otg, 0x2, 0x85);
-		ulpi_write(otg, 0x1, 0x85);
+		ulpi_write(xceiv, 0x8, 0x85);
+		ulpi_write(xceiv, 0x2, 0x85);
+		ulpi_write(xceiv, 0x1, 0x85);
 		break;
 	default:
 		break;
@@ -861,17 +861,17 @@ static void msm_chg_enable_secondary_det(struct msm_otg *motg)
 
 static bool msm_chg_check_primary_det(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 	bool ret = false;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		ret = chg_det & (1 << 4);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x87);
+		chg_det = ulpi_read(xceiv, 0x87);
 		ret = chg_det & 1;
 		break;
 	default:
@@ -882,23 +882,23 @@ static bool msm_chg_check_primary_det(struct msm_otg *motg)
 
 static void msm_chg_enable_primary_det(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		/* enable chg detection */
 		chg_det &= ~(1 << 0);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
 		/*
 		 * Configure DP as current source, DM as current sink
 		 * and enable battery charging comparators.
 		 */
-		ulpi_write(otg, 0x2, 0x85);
-		ulpi_write(otg, 0x1, 0x85);
+		ulpi_write(xceiv, 0x2, 0x85);
+		ulpi_write(xceiv, 0x1, 0x85);
 		break;
 	default:
 		break;
@@ -907,17 +907,17 @@ static void msm_chg_enable_primary_det(struct msm_otg *motg)
 
 static bool msm_chg_check_dcd(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 line_state;
 	bool ret = false;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		line_state = ulpi_read(otg, 0x15);
+		line_state = ulpi_read(xceiv, 0x15);
 		ret = !(line_state & 1);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
-		line_state = ulpi_read(otg, 0x87);
+		line_state = ulpi_read(xceiv, 0x87);
 		ret = line_state & 2;
 		break;
 	default:
@@ -928,17 +928,17 @@ static bool msm_chg_check_dcd(struct msm_otg *motg)
 
 static void msm_chg_disable_dcd(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		chg_det &= ~(1 << 5);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
-		ulpi_write(otg, 0x10, 0x86);
+		ulpi_write(xceiv, 0x10, 0x86);
 		break;
 	default:
 		break;
@@ -947,19 +947,19 @@ static void msm_chg_disable_dcd(struct msm_otg *motg)
 
 static void msm_chg_enable_dcd(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 chg_det;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		/* Turn on D+ current source */
 		chg_det |= (1 << 5);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
 		/* Data contact detection enable */
-		ulpi_write(otg, 0x10, 0x85);
+		ulpi_write(xceiv, 0x10, 0x85);
 		break;
 	default:
 		break;
@@ -968,32 +968,32 @@ static void msm_chg_enable_dcd(struct msm_otg *motg)
 
 static void msm_chg_block_on(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 func_ctrl, chg_det;
 
 	/* put the controller in non-driving mode */
-	func_ctrl = ulpi_read(otg, ULPI_FUNC_CTRL);
+	func_ctrl = ulpi_read(xceiv, ULPI_FUNC_CTRL);
 	func_ctrl &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
 	func_ctrl |= ULPI_FUNC_CTRL_OPMODE_NONDRIVING;
-	ulpi_write(otg, func_ctrl, ULPI_FUNC_CTRL);
+	ulpi_write(xceiv, func_ctrl, ULPI_FUNC_CTRL);
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		/* control chg block via ULPI */
 		chg_det &= ~(1 << 3);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		/* Turn on chg detect block */
 		chg_det &= ~(1 << 1);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		udelay(20);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
 		/* Clear charger detecting control bits */
-		ulpi_write(otg, 0x3F, 0x86);
+		ulpi_write(xceiv, 0x3F, 0x86);
 		/* Clear alt interrupt latch and enable bits */
-		ulpi_write(otg, 0x1F, 0x92);
-		ulpi_write(otg, 0x1F, 0x95);
+		ulpi_write(xceiv, 0x1F, 0x92);
+		ulpi_write(xceiv, 0x1F, 0x95);
 		udelay(100);
 		break;
 	default:
@@ -1003,32 +1003,32 @@ static void msm_chg_block_on(struct msm_otg *motg)
 
 static void msm_chg_block_off(struct msm_otg *motg)
 {
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 func_ctrl, chg_det;
 
 	switch (motg->pdata->phy_type) {
 	case CI_45NM_INTEGRATED_PHY:
-		chg_det = ulpi_read(otg, 0x34);
+		chg_det = ulpi_read(xceiv, 0x34);
 		/* Turn off charger block */
 		chg_det |= ~(1 << 1);
-		ulpi_write(otg, chg_det, 0x34);
+		ulpi_write(xceiv, chg_det, 0x34);
 		break;
 	case SNPS_28NM_INTEGRATED_PHY:
 		/* Clear charger detecting control bits */
-		ulpi_write(otg, 0x3F, 0x86);
+		ulpi_write(xceiv, 0x3F, 0x86);
 		/* Clear alt interrupt latch and enable bits */
-		ulpi_write(otg, 0x1F, 0x92);
-		ulpi_write(otg, 0x1F, 0x95);
+		ulpi_write(xceiv, 0x1F, 0x92);
+		ulpi_write(xceiv, 0x1F, 0x95);
 		break;
 	default:
 		break;
 	}
 
 	/* put the controller in normal mode */
-	func_ctrl = ulpi_read(otg, ULPI_FUNC_CTRL);
+	func_ctrl = ulpi_read(xceiv, ULPI_FUNC_CTRL);
 	func_ctrl &= ~ULPI_FUNC_CTRL_OPMODE_MASK;
 	func_ctrl |= ULPI_FUNC_CTRL_OPMODE_NORMAL;
-	ulpi_write(otg, func_ctrl, ULPI_FUNC_CTRL);
+	ulpi_write(xceiv, func_ctrl, ULPI_FUNC_CTRL);
 }
 
 #define MSM_CHG_DCD_POLL_TIME		(100 * HZ/1000) /* 100 msec */
@@ -1038,14 +1038,14 @@ static void msm_chg_block_off(struct msm_otg *motg)
 static void msm_chg_detect_work(struct work_struct *w)
 {
 	struct msm_otg *motg = container_of(w, struct msm_otg, chg_work.work);
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	bool is_dcd, tmout, vout;
 	unsigned long delay;
 
-	dev_dbg(otg->dev, "chg detection work\n");
+	dev_dbg(xceiv->dev, "chg detection work\n");
 	switch (motg->chg_state) {
 	case USB_CHG_STATE_UNDEFINED:
-		pm_runtime_get_sync(otg->dev);
+		pm_runtime_get_sync(xceiv->dev);
 		msm_chg_block_on(motg);
 		msm_chg_enable_dcd(motg);
 		motg->chg_state = USB_CHG_STATE_WAIT_FOR_DCD;
@@ -1088,7 +1088,7 @@ static void msm_chg_detect_work(struct work_struct *w)
 		motg->chg_state = USB_CHG_STATE_DETECTED;
 	case USB_CHG_STATE_DETECTED:
 		msm_chg_block_off(motg);
-		dev_dbg(otg->dev, "charger = %d\n", motg->chg_type);
+		dev_dbg(xceiv->dev, "charger = %d\n", motg->chg_type);
 		schedule_work(&motg->sm_work);
 		return;
 	default:
@@ -1152,22 +1152,22 @@ static void msm_otg_init_sm(struct msm_otg *motg)
 static void msm_otg_sm_work(struct work_struct *w)
 {
 	struct msm_otg *motg = container_of(w, struct msm_otg, sm_work);
-	struct usb_phy *otg = &motg->otg;
+	struct usb_otg *otg = motg->xceiv.otg;
 
-	switch (otg->state) {
+	switch (otg->xceiv->state) {
 	case USB_PHY_STATE_UNDEFINED:
-		dev_dbg(otg->dev, "USB_PHY_STATE_UNDEFINED state\n");
-		msm_otg_reset(otg);
+		dev_dbg(otg->xceiv->dev, "USB_PHY_STATE_UNDEFINED state\n");
+		msm_otg_reset(otg->xceiv);
 		msm_otg_init_sm(motg);
-		otg->state = USB_PHY_STATE_B_IDLE;
+		otg->xceiv->state = USB_PHY_STATE_B_IDLE;
 		/* FALL THROUGH */
 	case USB_PHY_STATE_B_IDLE:
-		dev_dbg(otg->dev, "USB_PHY_STATE_B_IDLE state\n");
+		dev_dbg(otg->xceiv->dev, "USB_PHY_STATE_B_IDLE state\n");
 		if (!test_bit(ID, &motg->inputs) && otg->host) {
 			/* disable BSV bit */
 			writel(readl(USB_OTGSC) & ~OTGSC_BSVIE, USB_OTGSC);
-			msm_otg_start_host(otg, 1);
-			otg->state = USB_PHY_STATE_A_HOST;
+			msm_otg_start_host(otg->xceiv, 1);
+			otg->xceiv->state = USB_PHY_STATE_A_HOST;
 		} else if (test_bit(B_SESS_VLD, &motg->inputs)) {
 			switch (motg->chg_state) {
 			case USB_CHG_STATE_UNDEFINED:
@@ -1182,13 +1182,15 @@ static void msm_otg_sm_work(struct work_struct *w)
 				case USB_CDP_CHARGER:
 					msm_otg_notify_charger(motg,
 							IDEV_CHG_MAX);
-					msm_otg_start_peripheral(otg, 1);
-					otg->state = USB_PHY_STATE_B_PERIPHERAL;
+					msm_otg_start_peripheral(otg->xceiv, 1);
+					otg->xceiv->state
+						= USB_PHY_STATE_B_PERIPHERAL;
 					break;
 				case USB_SDP_CHARGER:
 					msm_otg_notify_charger(motg, IUNIT);
-					msm_otg_start_peripheral(otg, 1);
-					otg->state = USB_PHY_STATE_B_PERIPHERAL;
+					msm_otg_start_peripheral(otg->xceiv, 1);
+					otg->xceiv->state
+						= USB_PHY_STATE_B_PERIPHERAL;
 					break;
 				default:
 					break;
@@ -1204,34 +1206,34 @@ static void msm_otg_sm_work(struct work_struct *w)
 			 * is incremented in charger detection work.
 			 */
 			if (cancel_delayed_work_sync(&motg->chg_work)) {
-				pm_runtime_put_sync(otg->dev);
-				msm_otg_reset(otg);
+				pm_runtime_put_sync(otg->xceiv->dev);
+				msm_otg_reset(otg->xceiv);
 			}
 			msm_otg_notify_charger(motg, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
 			motg->chg_type = USB_INVALID_CHARGER;
 		}
-		pm_runtime_put_sync(otg->dev);
+		pm_runtime_put_sync(otg->xceiv->dev);
 		break;
 	case USB_PHY_STATE_B_PERIPHERAL:
-		dev_dbg(otg->dev, "USB_PHY_STATE_B_PERIPHERAL state\n");
+		dev_dbg(otg->xceiv->dev, "USB_PHY_STATE_B_PERIPHERAL state\n");
 		if (!test_bit(B_SESS_VLD, &motg->inputs) ||
 				!test_bit(ID, &motg->inputs)) {
 			msm_otg_notify_charger(motg, 0);
-			msm_otg_start_peripheral(otg, 0);
+			msm_otg_start_peripheral(otg->xceiv, 0);
 			motg->chg_state = USB_CHG_STATE_UNDEFINED;
 			motg->chg_type = USB_INVALID_CHARGER;
-			otg->state = USB_PHY_STATE_B_IDLE;
-			msm_otg_reset(otg);
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
+			msm_otg_reset(otg->xceiv);
 			schedule_work(w);
 		}
 		break;
 	case USB_PHY_STATE_A_HOST:
-		dev_dbg(otg->dev, "USB_PHY_STATE_A_HOST state\n");
+		dev_dbg(otg->xceiv->dev, "USB_PHY_STATE_A_HOST state\n");
 		if (test_bit(ID, &motg->inputs)) {
-			msm_otg_start_host(otg, 0);
-			otg->state = USB_PHY_STATE_B_IDLE;
-			msm_otg_reset(otg);
+			msm_otg_start_host(otg->xceiv, 0);
+			otg->xceiv->state = USB_PHY_STATE_B_IDLE;
+			msm_otg_reset(otg->xceiv);
 			schedule_work(w);
 		}
 		break;
@@ -1243,13 +1245,13 @@ static void msm_otg_sm_work(struct work_struct *w)
 static irqreturn_t msm_otg_irq(int irq, void *data)
 {
 	struct msm_otg *motg = data;
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	u32 otgsc = 0;
 
 	if (atomic_read(&motg->in_lpm)) {
 		disable_irq_nosync(irq);
 		motg->async_int = 1;
-		pm_runtime_get(otg->dev);
+		pm_runtime_get(xceiv->dev);
 		return IRQ_HANDLED;
 	}
 
@@ -1262,15 +1264,15 @@ static irqreturn_t msm_otg_irq(int irq, void *data)
 			set_bit(ID, &motg->inputs);
 		else
 			clear_bit(ID, &motg->inputs);
-		dev_dbg(otg->dev, "ID set/clear\n");
-		pm_runtime_get_noresume(otg->dev);
+		dev_dbg(xceiv->dev, "ID set/clear\n");
+		pm_runtime_get_noresume(xceiv->dev);
 	} else if ((otgsc & OTGSC_BSVIS) && (otgsc & OTGSC_BSVIE)) {
 		if (otgsc & OTGSC_BSV)
 			set_bit(B_SESS_VLD, &motg->inputs);
 		else
 			clear_bit(B_SESS_VLD, &motg->inputs);
-		dev_dbg(otg->dev, "BSV set/clear\n");
-		pm_runtime_get_noresume(otg->dev);
+		dev_dbg(xceiv->dev, "BSV set/clear\n");
+		pm_runtime_get_noresume(xceiv->dev);
 	}
 
 	writel(otgsc, USB_OTGSC);
@@ -1281,9 +1283,9 @@ static irqreturn_t msm_otg_irq(int irq, void *data)
 static int msm_otg_mode_show(struct seq_file *s, void *unused)
 {
 	struct msm_otg *motg = s->private;
-	struct usb_phy *otg = &motg->otg;
+	struct usb_otg *otg = motg->xceiv.otg;
 
-	switch (otg->state) {
+	switch (otg->xceiv->state) {
 	case USB_PHY_STATE_A_HOST:
 		seq_printf(s, "host\n");
 		break;
@@ -1309,7 +1311,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 	struct seq_file *s = file->private_data;
 	struct msm_otg *motg = s->private;
 	char buf[16];
-	struct usb_phy *otg = &motg->otg;
+	struct usb_otg *otg = motg->xceiv.otg;
 	int status = count;
 	enum usb_mode_type req_mode;
 
@@ -1333,7 +1335,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 
 	switch (req_mode) {
 	case USB_NONE:
-		switch (otg->state) {
+		switch (otg->xceiv->state) {
 		case USB_PHY_STATE_A_HOST:
 		case USB_PHY_STATE_B_PERIPHERAL:
 			set_bit(ID, &motg->inputs);
@@ -1344,7 +1346,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		}
 		break;
 	case USB_PERIPHERAL:
-		switch (otg->state) {
+		switch (otg->xceiv->state) {
 		case USB_PHY_STATE_B_IDLE:
 		case USB_PHY_STATE_A_HOST:
 			set_bit(ID, &motg->inputs);
@@ -1355,7 +1357,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		}
 		break;
 	case USB_HOST:
-		switch (otg->state) {
+		switch (otg->xceiv->state) {
 		case USB_PHY_STATE_B_IDLE:
 		case USB_PHY_STATE_B_PERIPHERAL:
 			clear_bit(ID, &motg->inputs);
@@ -1368,7 +1370,7 @@ static ssize_t msm_otg_mode_write(struct file *file, const char __user *ubuf,
 		goto out;
 	}
 
-	pm_runtime_get_sync(otg->dev);
+	pm_runtime_get_sync(otg->xceiv->dev);
 	schedule_work(&motg->sm_work);
 out:
 	return status;
@@ -1414,7 +1416,7 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct resource *res;
 	struct msm_otg *motg;
-	struct usb_phy *otg;
+	struct usb_phy *xceiv;
 
 	dev_info(&pdev->dev, "msm_otg probe\n");
 	if (!pdev->dev.platform_data) {
@@ -1428,9 +1430,15 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	motg->xceiv.otg = kzalloc(sizeof(struct usb_otg), GFP_KERNEL);
+	if (!motg->xceiv.otg) {
+		dev_err(&pdev->dev, "unable to allocate msm_otg\n");
+		return -ENOMEM;
+	}
+
 	motg->pdata = pdev->dev.platform_data;
-	otg = &motg->otg;
-	otg->dev = &pdev->dev;
+	xceiv = &motg->xceiv;
+	xceiv->dev = &pdev->dev;
 
 	motg->phy_reset_clk = clk_get(&pdev->dev, "usb_phy_clk");
 	if (IS_ERR(motg->phy_reset_clk)) {
@@ -1538,16 +1546,18 @@ static int __init msm_otg_probe(struct platform_device *pdev)
 		goto disable_clks;
 	}
 
-	otg->init = msm_otg_reset;
-	otg->set_host = msm_otg_set_host;
-	otg->set_peripheral = msm_otg_set_peripheral;
-	otg->set_power = msm_otg_set_power;
+	xceiv->init = msm_otg_reset;
+	xceiv->set_power = msm_otg_set_power;
+
+	xceiv->io_ops = &msm_otg_io_ops;
 
-	otg->io_ops = &msm_otg_io_ops;
+	xceiv->otg->xceiv = &motg->xceiv;
+	xceiv->otg->set_host = msm_otg_set_host;
+	xceiv->otg->set_peripheral = msm_otg_set_peripheral;
 
-	ret = otg_set_transceiver(&motg->otg);
+	ret = usb_set_transceiver(&motg->xceiv);
 	if (ret) {
-		dev_err(&pdev->dev, "otg_set_transceiver failed\n");
+		dev_err(&pdev->dev, "usb_set_transceiver failed\n");
 		goto free_irq;
 	}
 
@@ -1591,6 +1601,7 @@ put_clk:
 put_phy_reset_clk:
 	clk_put(motg->phy_reset_clk);
 free_motg:
+	kfree(motg->xceiv.otg);
 	kfree(motg);
 	return ret;
 }
@@ -1598,10 +1609,10 @@ free_motg:
 static int __devexit msm_otg_remove(struct platform_device *pdev)
 {
 	struct msm_otg *motg = platform_get_drvdata(pdev);
-	struct usb_phy *otg = &motg->otg;
+	struct usb_phy *xceiv = &motg->xceiv;
 	int cnt = 0;
 
-	if (otg->host || otg->gadget)
+	if (xceiv->otg->host || xceiv->otg->gadget)
 		return -EBUSY;
 
 	msm_otg_debugfs_cleanup();
@@ -1613,14 +1624,14 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 	pm_runtime_disable(&pdev->dev);
 
-	otg_set_transceiver(NULL);
+	usb_set_transceiver(NULL);
 	free_irq(motg->irq, motg);
 
 	/*
 	 * Put PHY in low power mode.
 	 */
-	ulpi_read(otg, 0x14);
-	ulpi_write(otg, 0x08, 0x09);
+	ulpi_read(xceiv, 0x14);
+	ulpi_write(xceiv, 0x08, 0x09);
 
 	writel(readl(USB_PORTSC) | PORTSC_PHCD, USB_PORTSC);
 	while (cnt < PHY_SUSPEND_TIMEOUT_USEC) {
@@ -1630,7 +1641,7 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 		cnt++;
 	}
 	if (cnt >= PHY_SUSPEND_TIMEOUT_USEC)
-		dev_err(otg->dev, "Unable to suspend PHY\n");
+		dev_err(xceiv->dev, "Unable to suspend PHY\n");
 
 	clk_disable(motg->pclk);
 	clk_disable(motg->clk);
@@ -1651,6 +1662,7 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 	if (motg->core_clk)
 		clk_put(motg->core_clk);
 
+	kfree(motg->xceiv.otg);
 	kfree(motg);
 
 	return 0;
@@ -1660,7 +1672,7 @@ static int __devexit msm_otg_remove(struct platform_device *pdev)
 static int msm_otg_runtime_idle(struct device *dev)
 {
 	struct msm_otg *motg = dev_get_drvdata(dev);
-	struct usb_phy *otg = &motg->otg;
+	struct usb_otg *otg = motg->xceiv.otg;
 
 	dev_dbg(dev, "OTG runtime idle\n");
 
@@ -1670,7 +1682,7 @@ static int msm_otg_runtime_idle(struct device *dev)
 	 * This 1 sec delay also prevents entering into LPM immediately
 	 * after asynchronous interrupt.
 	 */
-	if (otg->state != USB_PHY_STATE_UNDEFINED)
+	if (otg->xceiv->state != USB_PHY_STATE_UNDEFINED)
 		pm_schedule_suspend(dev, 1000);
 
 	return -EAGAIN;
diff --git a/include/linux/usb/msm_hsusb.h b/include/linux/usb/msm_hsusb.h
index e25ee7a..fb7f047 100644
--- a/include/linux/usb/msm_hsusb.h
+++ b/include/linux/usb/msm_hsusb.h
@@ -160,7 +160,7 @@ struct msm_otg_platform_data {
  *               detection process.
  */
 struct msm_otg {
-	struct usb_phy otg;
+	struct usb_phy xceiv;
 	struct msm_otg_platform_data *pdata;
 	int irq;
 	struct clk *clk;
-- 
1.7.4.1

