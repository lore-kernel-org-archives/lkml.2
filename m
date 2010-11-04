Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab0KDPLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:11:32 -0400
Received: from smtp.nokia.com ([147.243.128.24]:46114 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752169Ab0KDPLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:11:02 -0400
From: Heikki Krogerus <heikki.krogerus@nokia.com>
To: cbouatmailru@gmail.com
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, heikki.krogerus@nokia.com
Subject: [PATCH 2/4] power_supply: isp1704: Detect HUB/Host chargers
Date: Thu,  4 Nov 2010 16:31:47 +0200
Message-Id: <1288881109-18222-3-git-send-email-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
References: <1288881109-18222-1-git-send-email-heikki.krogerus@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid breaking high speed chirp handshaking with CDP
chargers, no more then 500mA should be drawn. To make sure
of this, utilizing current_max property. After the device
has enumerated, it's safe to draw the maximum 1800mA as
defined in the Battery Charging Specification. This can be
also used with normal USB connection if the controller sends
ENUMERATED notification with the milliamps as data.

>From now on the online property indicates VBUS, present
property if there is a charger and current_max the milliamps
possible to draw from VBUS.

Signed-off-by: Heikki Krogerus <heikki.krogerus@nokia.com>
---
 drivers/power/isp1704_charger.c |  180 ++++++++++++++++++++++++++++++--------
 1 files changed, 142 insertions(+), 38 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 87252e1..10c7cc5 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -59,11 +59,61 @@ struct isp1704_charger {
 	struct notifier_block	nb;
 	struct work_struct	work;
 
+	/* properties */
 	char			model[8];
 	unsigned		present:1;
+	unsigned		online:1;
+	unsigned		current_max;
+
+	/* temp storage variables */
+	unsigned long		event;
+	unsigned		max_power;
 };
 
 /*
+ * Determine is the charging port DCP (dedicated charger) or CDP (Host/HUB
+ * chargers).
+ *
+ * REVISIT: The method is defined in Battery Charging Specification and is
+ * applicable to any ULPI transceiver. Nothing isp170x specific here.
+ */
+static inline int isp1704_charger_type(struct isp1704_charger *isp)
+{
+	u8 reg;
+	u8 func_ctrl;
+	u8 otg_ctrl;
+	int type = POWER_SUPPLY_TYPE_USB_DCP;
+
+	func_ctrl = otg_io_read(isp->otg, ULPI_FUNC_CTRL);
+	otg_ctrl = otg_io_read(isp->otg, ULPI_OTG_CTRL);
+
+	/* disable pulldowns */
+	reg = ULPI_OTG_CTRL_DM_PULLDOWN | ULPI_OTG_CTRL_DP_PULLDOWN;
+	otg_io_write(isp->otg, ULPI_CLR(ULPI_OTG_CTRL), reg);
+
+	/* full speed */
+	otg_io_write(isp->otg, ULPI_CLR(ULPI_FUNC_CTRL),
+			ULPI_FUNC_CTRL_XCVRSEL_MASK);
+	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL),
+			ULPI_FUNC_CTRL_FULL_SPEED);
+
+	/* Enable strong pull-up on DP (1.5K) and reset */
+	reg = ULPI_FUNC_CTRL_TERMSELECT | ULPI_FUNC_CTRL_RESET;
+	otg_io_write(isp->otg, ULPI_SET(ULPI_FUNC_CTRL), reg);
+	usleep_range(1000, 2000);
+
+	reg = otg_io_read(isp->otg, ULPI_DEBUG);
+	if ((reg & 3) != 3)
+		type = POWER_SUPPLY_TYPE_USB_CDP;
+
+	/* recover original state */
+	otg_io_write(isp->otg, ULPI_FUNC_CTRL, func_ctrl);
+	otg_io_write(isp->otg, ULPI_OTG_CTRL, otg_ctrl);
+
+	return type;
+}
+
+/*
  * ISP1704 detects PS/2 adapters as charger. To make sure the detected charger
  * is actually a dedicated charger, the following steps need to be taken.
  */
@@ -127,16 +177,19 @@ static inline int isp1704_charger_verify(struct isp1704_charger *isp)
 static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 {
 	unsigned long	timeout;
-	u8		r;
+	u8		pwr_ctrl;
 	int		ret = 0;
 
+	pwr_ctrl = otg_io_read(isp->otg, ISP1704_PWR_CTRL);
+
 	/* set SW control bit in PWR_CTRL register */
 	otg_io_write(isp->otg, ISP1704_PWR_CTRL,
 			ISP1704_PWR_CTRL_SWCTRL);
 
 	/* enable manual charger detection */
-	r = (ISP1704_PWR_CTRL_SWCTRL | ISP1704_PWR_CTRL_DPVSRC_EN);
-	otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL), r);
+	otg_io_write(isp->otg, ULPI_SET(ISP1704_PWR_CTRL),
+			ISP1704_PWR_CTRL_SWCTRL
+			| ISP1704_PWR_CTRL_DPVSRC_EN);
 	usleep_range(1000, 2000);
 
 	timeout = jiffies + msecs_to_jiffies(300);
@@ -147,7 +200,10 @@ static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 			ret = isp1704_charger_verify(isp);
 			break;
 		}
-	} while (!time_after(jiffies, timeout));
+	} while (!time_after(jiffies, timeout) && isp->online);
+
+	/* recover original state */
+	otg_io_write(isp->otg, ISP1704_PWR_CTRL, pwr_ctrl);
 
 	return ret;
 }
@@ -155,53 +211,93 @@ static inline int isp1704_charger_detect(struct isp1704_charger *isp)
 static void isp1704_charger_work(struct work_struct *data)
 {
 	int			detect;
+	unsigned long		event;
+	unsigned		power;
 	struct isp1704_charger	*isp =
 		container_of(data, struct isp1704_charger, work);
+	static DEFINE_MUTEX(lock);
 
-	/*
-	 * FIXME Only supporting dedicated chargers even though isp1704 can
-	 * detect HUB and HOST chargers. If the device has already been
-	 * enumerated, the detection will break the connection.
-	 */
-	if (isp->otg->state != OTG_STATE_B_IDLE)
-		return;
-
-	/* disable data pullups */
-	if (isp->otg->gadget)
-		usb_gadget_disconnect(isp->otg->gadget);
-
-	/* detect charger */
-	detect = isp1704_charger_detect(isp);
-	if (detect) {
-		isp->present = detect;
-		power_supply_changed(&isp->psy);
-	}
+	event = isp->event;
+	power = isp->max_power;
 
-	/* enable data pullups */
-	if (isp->otg->gadget)
-		usb_gadget_connect(isp->otg->gadget);
-}
-
-static int isp1704_notifier_call(struct notifier_block *nb,
-		unsigned long event, void *unused)
-{
-	struct isp1704_charger *isp =
-		container_of(nb, struct isp1704_charger, nb);
+	mutex_lock(&lock);
 
 	switch (event) {
 	case USB_EVENT_VBUS:
-		schedule_work(&isp->work);
+		isp->online = true;
+
+		/* detect charger */
+		detect = isp1704_charger_detect(isp);
+
+		if (detect) {
+			isp->present = detect;
+			isp->psy.type = isp1704_charger_type(isp);
+		}
+
+		switch (isp->psy.type) {
+		case POWER_SUPPLY_TYPE_USB_DCP:
+			isp->current_max = 1800;
+			break;
+		case POWER_SUPPLY_TYPE_USB_CDP:
+			/*
+			 * Only 500mA here or high speed chirp
+			 * handshaking may break
+			 */
+			isp->current_max = 500;
+			/* FALLTHROUGH */
+		case POWER_SUPPLY_TYPE_USB:
+		default:
+			/* enable data pullups */
+			if (isp->otg->gadget)
+				usb_gadget_connect(isp->otg->gadget);
+		}
 		break;
 	case USB_EVENT_NONE:
-		if (isp->present) {
-			isp->present = 0;
-			power_supply_changed(&isp->psy);
-		}
+		isp->online = false;
+		isp->current_max = 0;
+		isp->present = 0;
+		isp->current_max = 0;
+		isp->psy.type = POWER_SUPPLY_TYPE_USB;
+
+		/*
+		 * Disable data pullups. We need to prevent the controller from
+		 * enumerating.
+		 *
+		 * FIXME: This is here to allow charger detection with Host/HUB
+		 * chargers. The pullups may be enabled elsewhere, so this can
+		 * not be the final solution.
+		 */
+		if (isp->otg->gadget)
+			usb_gadget_disconnect(isp->otg->gadget);
+		break;
+	case USB_EVENT_ENUMERATED:
+		if (isp->present)
+			isp->current_max = 1800;
+		else
+			isp->current_max = power;
 		break;
 	default:
-		return NOTIFY_DONE;
+		goto out;
 	}
 
+	power_supply_changed(&isp->psy);
+out:
+	mutex_unlock(&lock);
+}
+
+static int isp1704_notifier_call(struct notifier_block *nb,
+		unsigned long event, void *power)
+{
+	struct isp1704_charger *isp =
+		container_of(nb, struct isp1704_charger, nb);
+
+	isp->event = event;
+
+	if (power)
+		isp->max_power = *((unsigned *)power);
+
+	schedule_work(&isp->work);
+
 	return NOTIFY_OK;
 }
 
@@ -216,6 +312,12 @@ static int isp1704_charger_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = isp->present;
 		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = isp->online;
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_MAX:
+		val->intval = isp->current_max;
+		break;
 	case POWER_SUPPLY_PROP_MODEL_NAME:
 		val->strval = isp->model;
 		break;
@@ -230,6 +332,8 @@ static int isp1704_charger_get_property(struct power_supply *psy,
 
 static enum power_supply_property power_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_CURRENT_MAX,
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 };
-- 
1.7.1

