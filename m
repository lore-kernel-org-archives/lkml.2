Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1BFM3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:29:35 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:38268 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab1BFM3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:29:33 -0500
X-Originating-IP: 217.70.178.42
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/18] eeepc-wmi: add an helper using simple return codes
Date: Sun,  6 Feb 2011 13:28:31 +0100
Message-Id: <1296995324-5462-7-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eeepc_wmi_get_devstate returns an acpi_status, so each
call need extra logic to handle the return code. This
patch add a simple getter, returning a boolean (or a
negative error code).

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   96 +++++++++++++++----------------------
 1 files changed, 39 insertions(+), 57 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index d823458..de501fb 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -257,6 +257,29 @@ static acpi_status eeepc_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
 	return status;
 }
 
+/* Helper for special devices with magic return codes */
+static int eeepc_wmi_get_devstate_simple(u32 dev_id)
+{
+	u32 retval = 0;
+	acpi_status status;
+
+	status = eeepc_wmi_get_devstate(dev_id, &retval);
+
+	if (ACPI_FAILURE(status))
+		return -EINVAL;
+
+	/* If the device is present, DSTS will always set some bits
+	 * 0x00070000 - 1110000000000000000 - device supported
+	 * 0x00060000 - 1100000000000000000 - not supported
+	 * 0x00020000 - 0100000000000000000 - device supported
+	 * 0x00010000 - 0010000000000000000 - not supported / special mode ?
+	 */
+	if (!retval || retval == 0x00060000)
+		return -ENODEV;
+
+	return retval & 0x1;
+}
+
 /*
  * LEDs
  */
@@ -290,23 +313,7 @@ static void tpd_led_set(struct led_classdev *led_cdev,
 
 static int read_tpd_state(struct eeepc_wmi *eeepc)
 {
-	u32 retval;
-	acpi_status status;
-
-	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_TPDLED, &retval);
-
-	if (ACPI_FAILURE(status))
-		return -1;
-	else if (!retval || retval == 0x00060000)
-		/*
-		 * if touchpad led is present, DSTS will set some bits,
-		 * usually 0x00020000.
-		 * 0x00060000 means that the device is not supported
-		 */
-		return -ENODEV;
-	else
-		/* Status is stored in the first bit */
-		return retval & 0x1;
+	return eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_TPDLED);
 }
 
 static enum led_brightness tpd_led_get(struct led_classdev *led_cdev)
@@ -358,15 +365,11 @@ static void eeepc_wmi_led_exit(struct eeepc_wmi *eeepc)
  */
 static bool eeepc_wlan_rfkill_blocked(struct eeepc_wmi *eeepc)
 {
-	u32 retval;
-	acpi_status status;
-
-	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_WLAN, &retval);
+	int result = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
 
-	if (ACPI_FAILURE(status))
+	if (result < 0)
 		return false;
-
-	return !(retval & 0x1);
+	return !result;
 }
 
 static void eeepc_rfkill_hotplug(struct eeepc_wmi *eeepc)
@@ -494,19 +497,12 @@ static void eeepc_unregister_rfkill_notifier(struct eeepc_wmi *eeepc,
 static int eeepc_get_adapter_status(struct hotplug_slot *hotplug_slot,
 				    u8 *value)
 {
-	u32 retval;
-	acpi_status status;
-
-	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_WLAN, &retval);
-
-	if (ACPI_FAILURE(status))
-		return -EIO;
+	int result = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_WLAN);
 
-	if (!retval || retval == 0x00060000)
-		return -ENODEV;
-	else
-		*value = (retval & 0x1);
+	if (result < 0)
+		return result;
 
+	*value = !!result;
 	return 0;
 }
 
@@ -601,15 +597,14 @@ static int eeepc_rfkill_set(void *data, bool blocked)
 static void eeepc_rfkill_query(struct rfkill *rfkill, void *data)
 {
 	int dev_id = (unsigned long)data;
-	u32 retval;
-	acpi_status status;
+	int result;
 
-	status = eeepc_wmi_get_devstate(dev_id, &retval);
+	result = eeepc_wmi_get_devstate_simple(dev_id);
 
-	if (ACPI_FAILURE(status))
+	if (result < 0)
 		return ;
 
-	rfkill_set_sw_state(rfkill, !(retval & 0x1));
+	rfkill_set_sw_state(rfkill, !result);
 }
 
 static int eeepc_rfkill_wlan_set(void *data, bool blocked)
@@ -650,23 +645,10 @@ static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
 			    const char *name,
 			    enum rfkill_type type, int dev_id)
 {
-	int result;
-	u32 retval;
-	acpi_status status;
-
-	status = eeepc_wmi_get_devstate(dev_id, &retval);
+	int result = eeepc_wmi_get_devstate_simple(dev_id);
 
-	if (ACPI_FAILURE(status))
-		return -1;
-
-	/* If the device is present, DSTS will always set some bits
-	 * 0x00070000 - 1110000000000000000 - device supported
-	 * 0x00060000 - 1100000000000000000 - not supported
-	 * 0x00020000 - 0100000000000000000 - device supported
-	 * 0x00010000 - 0010000000000000000 - not supported / special mode ?
-	 */
-	if (!retval || retval == 0x00060000)
-		return -ENODEV;
+	if (result < 0)
+		return result;
 
 	if (dev_id == EEEPC_WMI_DEVID_WLAN && eeepc->hotplug_wireless)
 		*rfkill = rfkill_alloc(name, &eeepc->platform_device->dev, type,
@@ -678,7 +660,7 @@ static int eeepc_new_rfkill(struct eeepc_wmi *eeepc,
 	if (!*rfkill)
 		return -EINVAL;
 
-	rfkill_init_sw_state(*rfkill, !(retval & 0x1));
+	rfkill_init_sw_state(*rfkill, !result);
 	result = rfkill_register(*rfkill);
 	if (result) {
 		rfkill_destroy(*rfkill);
-- 
1.7.4.rc3

