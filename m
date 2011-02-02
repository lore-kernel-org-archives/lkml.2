Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab1BBLB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:01:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53065 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328Ab1BBLA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:00:56 -0500
From: pavan_savoy@ti.com
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 7/7] drivers:misc: ti-st: remove multiple gpio handling
Date: Wed,  2 Feb 2011 05:00:48 -0600
Message-Id: <1296644448-29667-8-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1296644448-29667-7-git-send-email-pavan_savoy@ti.com>
References: <1296644448-29667-1-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-2-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-3-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-4-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-5-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-6-git-send-email-pavan_savoy@ti.com>
 <1296644448-29667-7-git-send-email-pavan_savoy@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

TI shared transport driver previously intended to expose rfkill
entries for each of the protocol gpio that the chip would have.
However now in case such gpios exist, which requires to be enabled
for a specific protocol, the responsibility lay on protocol driver.
This patch removes the request/free of multiple gpios, rfkill struct
references and also removes the chip_toggle function.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_core.c |   11 ----
 drivers/misc/ti-st/st_kim.c  |  117 +++++++++---------------------------------
 include/linux/ti_wilink_st.h |   19 +------
 3 files changed, 26 insertions(+), 121 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f0d24d8..1847c47 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -515,7 +515,6 @@ long st_register(struct st_proto_s *new_proto)
 	if (test_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state)) {
 		pr_info(" ST_REG_IN_PROGRESS:%d ", new_proto->chnl_id);
 		/* fw download in progress */
-		st_kim_chip_toggle(new_proto->chnl_id, KIM_GPIO_ACTIVE);
 
 		add_channel_to_table(st_gdata, new_proto);
 		st_gdata->protos_registered++;
@@ -548,10 +547,6 @@ long st_register(struct st_proto_s *new_proto)
 			return -EINVAL;
 		}
 
-		/* the chnl_id might require other gpios to be toggled
-		 */
-		st_kim_chip_toggle(new_proto->chnl_id, KIM_GPIO_ACTIVE);
-
 		clear_bit(ST_REG_IN_PROGRESS, &st_gdata->st_state);
 		st_recv = st_int_recv;
 
@@ -622,12 +617,6 @@ long st_unregister(struct st_proto_s *proto)
 
 	st_gdata->protos_registered--;
 	remove_channel_from_table(st_gdata, proto);
-
-	/* kim ignores BT in the below function
-	 * and handles the rest, BT is toggled
-	 * only in kim_start and kim_stop
-	 */
-	st_kim_chip_toggle(proto->chnl_id, KIM_GPIO_INACTIVE);
 	spin_unlock_irqrestore(&st_gdata->lock, flags);
 
 	if ((st_gdata->protos_registered == ST_EMPTY) &&
diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 2c096cc..9ee4c78 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -390,49 +390,6 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 
 /**********************************************************************/
 /* functions called from ST core */
-/* function to toggle the GPIO
- * needs to know whether the GPIO is active high or active low
- */
-void st_kim_chip_toggle(enum proto_type type, enum kim_gpio_state state)
-{
-	struct platform_device	*kim_pdev;
-	struct kim_data_s	*kim_gdata;
-	pr_info(" %s ", __func__);
-
-	kim_pdev = st_get_plat_device(0);
-	kim_gdata = dev_get_drvdata(&kim_pdev->dev);
-
-	if (kim_gdata->gpios[type] == -1) {
-		pr_info("gpio not requested for protocol %d", type);
-		return;
-	}
-	switch (type) {
-	case ST_BT:
-		/*Do Nothing */
-		break;
-
-	case ST_FM:
-		if (state == KIM_GPIO_ACTIVE)
-			gpio_set_value(kim_gdata->gpios[ST_FM], GPIO_LOW);
-		else
-			gpio_set_value(kim_gdata->gpios[ST_FM], GPIO_HIGH);
-		break;
-
-	case ST_GPS:
-		if (state == KIM_GPIO_ACTIVE)
-			gpio_set_value(kim_gdata->gpios[ST_GPS], GPIO_HIGH);
-		else
-			gpio_set_value(kim_gdata->gpios[ST_GPS], GPIO_LOW);
-		break;
-
-	case ST_MAX_CHANNELS:
-	default:
-		break;
-	}
-
-	return;
-}
-
 /* called from ST Core, when REG_IN_PROGRESS (registration in progress)
  * can be because of
  * 1. response to read local version
@@ -482,9 +439,9 @@ long st_kim_start(void *kim_data)
 
 	do {
 		/* Configure BT nShutdown to HIGH state */
-		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+		gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
 		mdelay(5);	/* FIXME: a proper toggle */
-		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
+		gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
 		mdelay(100);
 		/* re-initialize the completion */
 		INIT_COMPLETION(kim_gdata->ldisc_installed);
@@ -552,11 +509,11 @@ long st_kim_stop(void *kim_data)
 	}
 
 	/* By default configure BT nShutdown to LOW state */
-	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
 	mdelay(1);
-	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
+	gpio_set_value(kim_gdata->nshutdown, GPIO_HIGH);
 	mdelay(1);
-	gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
+	gpio_set_value(kim_gdata->nshutdown, GPIO_LOW);
 	return err;
 }
 
@@ -685,10 +642,8 @@ struct dentry *kim_debugfs_dir;
 static int kim_probe(struct platform_device *pdev)
 {
 	long status;
-	long proto;
 	struct kim_data_s	*kim_gdata;
 	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
-	long *gpios = pdata->gpios;
 
 	if ((pdev->id != -1) && (pdev->id < MAX_ST_DEVICES)) {
 		/* multiple devices could exist */
@@ -713,40 +668,19 @@ static int kim_probe(struct platform_device *pdev)
 	/* refer to itself */
 	kim_gdata->core_data->kim_data = kim_gdata;
 
-	for (proto = 0; proto < ST_MAX_CHANNELS; proto++) {
-		kim_gdata->gpios[proto] = gpios[proto];
-		pr_info(" %ld gpio to be requested", gpios[proto]);
+	/* Claim the chip enable nShutdown gpio from the system */
+	kim_gdata->nshutdown = pdata->nshutdown_gpio;
+	status = gpio_request(kim_gdata->nshutdown, "kim");
+	if (unlikely(status)) {
+		pr_err(" gpio %ld request failed ", kim_gdata->nshutdown);
+		return status;
 	}
 
-	for (proto = 0; (proto < ST_MAX_CHANNELS)
-			&& (gpios[proto] != -1); proto++) {
-		/* Claim the Bluetooth/FM/GPIO
-		 * nShutdown gpio from the system
-		 */
-		status = gpio_request(gpios[proto], "kim");
-		if (unlikely(status)) {
-			pr_err(" gpio %ld request failed ", gpios[proto]);
-			proto -= 1;
-			while (proto >= 0) {
-				if (gpios[proto] != -1)
-					gpio_free(gpios[proto]);
-			}
-			return status;
-		}
-
-		/* Configure nShutdown GPIO as output=0 */
-		status =
-		    gpio_direction_output(gpios[proto], 0);
-		if (unlikely(status)) {
-			pr_err(" unable to configure gpio %ld",
-				   gpios[proto]);
-			proto -= 1;
-			while (proto >= 0) {
-				if (gpios[proto] != -1)
-					gpio_free(gpios[proto]);
-			}
-			return status;
-		}
+	/* Configure nShutdown GPIO as output=0 */
+	status = gpio_direction_output(kim_gdata->nshutdown, 0);
+	if (unlikely(status)) {
+		pr_err(" unable to configure gpio %ld", kim_gdata->nshutdown);
+		return status;
 	}
 	/* get reference of pdev for request_firmware
 	 */
@@ -785,23 +719,20 @@ static int kim_remove(struct platform_device *pdev)
 {
 	/* free the GPIOs requested */
 	struct ti_st_plat_data	*pdata = pdev->dev.platform_data;
-	long *gpios = pdata->gpios;
-	long proto;
 	struct kim_data_s	*kim_gdata;
 
 	kim_gdata = dev_get_drvdata(&pdev->dev);
 
-	for (proto = 0; (proto < ST_MAX_CHANNELS)
-		&& (gpios[proto] != -1); proto++) {
-		/* Claim the Bluetooth/FM/GPIO
-		 * nShutdown gpio from the system
-		 */
-		gpio_free(gpios[proto]);
-	}
-	pr_info("kim: GPIO Freed");
-	debugfs_remove_recursive(kim_debugfs_dir);
+	/* Free the Bluetooth/FM/GPIO
+	 * nShutdown gpio from the system
+	 */
+	gpio_free(pdata->nshutdown_gpio);
+	pr_info("nshutdown GPIO Freed");
 
+	debugfs_remove_recursive(kim_debugfs_dir);
 	sysfs_remove_group(&pdev->dev.kobj, &uim_attr_grp);
+	pr_info("sysfs entries removed");
+
 	kim_gdata->kim_pdev = NULL;
 	st_core_exit(kim_gdata->core_data);
 
diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
index 7885a77..7071ec5 100644
--- a/include/linux/ti_wilink_st.h
+++ b/include/linux/ti_wilink_st.h
@@ -26,15 +26,6 @@
 #define TI_WILINK_ST_H
 
 /**
- * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
- *	gpio states for their chip/core enable gpios
- */
-enum kim_gpio_state {
-	KIM_GPIO_INACTIVE,
-	KIM_GPIO_ACTIVE,
-};
-
-/**
  * enum proto-type - The protocol on WiLink chips which share a
  *	common physical interface like UART.
  */
@@ -252,14 +243,11 @@ struct chip_version {
  *	the ldisc was properly installed.
  * @resp_buffer: data buffer for the .bts fw file name.
  * @fw_entry: firmware class struct to request/release the fw.
- * @gpios: the list of core/chip enable gpios for BT, FM and GPS cores.
  * @rx_state: the rx state for kim's receive func during fw download.
  * @rx_count: the rx count for the kim's receive func during fw download.
  * @rx_skb: all of fw data might not come at once, and hence data storage for
  *	whole of the fw response, only HCI_EVENTs and hence diff from ST's
  *	response.
- * @rfkill: rfkill data for each of the cores to be registered with rfkill.
- * @rf_protos: proto types of the data registered with rfkill sub-system.
  * @core_data: ST core's data, which mainly is the tty's disc_data
  * @version: chip version available via a sysfs entry.
  *
@@ -270,12 +258,10 @@ struct kim_data_s {
 	struct completion kim_rcvd, ldisc_installed;
 	char resp_buffer[30];
 	const struct firmware *fw_entry;
-	long gpios[ST_MAX_CHANNELS];
+	long nshutdown;
 	unsigned long rx_state;
 	unsigned long rx_count;
 	struct sk_buff *rx_skb;
-	struct rfkill *rfkill[ST_MAX_CHANNELS];
-	enum proto_type rf_protos[ST_MAX_CHANNELS];
 	struct st_data_s *core_data;
 	struct chip_version version;
 	unsigned char ldisc_install;
@@ -293,7 +279,6 @@ long st_kim_start(void *);
 long st_kim_stop(void *);
 
 void st_kim_recv(void *, const unsigned char *, long count);
-void st_kim_chip_toggle(enum proto_type, enum kim_gpio_state);
 void st_kim_complete(void *);
 void kim_st_list_protocols(struct st_data_s *, void *);
 
@@ -426,7 +411,7 @@ struct gps_event_hdr {
 
 /* platform data */
 struct ti_st_plat_data {
-	long gpios[ST_MAX_CHANNELS]; /* BT, FM and GPS */
+	long nshutdown_gpio;
 	unsigned char dev_name[UART_DEV_NAME_LEN]; /* uart name */
 	unsigned char flow_cntrl; /* flow control flag */
 	unsigned long baud_rate;
-- 
1.6.3.3

