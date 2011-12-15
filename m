Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab1LOH2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:28:14 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42535 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab1LOH2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:28:10 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/9] asus-laptop: cleanup rfkill code
Date: Thu, 15 Dec 2011 08:27:33 +0100
Message-Id: <1323934059-1221-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
References: <1323934059-1221-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  117 ++++++++++++++++--------------------
 1 files changed, 52 insertions(+), 65 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index b011be8..3c07013 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -218,7 +218,7 @@ struct asus_led {
 /*
  * Same thing for rfkill
  */
-struct asus_pega_rfkill {
+struct asus_rfkill {
 	int control_id;		/* type of control. Maps to PEGA_* values */
 	struct rfkill *rfkill;
 	struct asus_laptop *asus;
@@ -256,11 +256,10 @@ struct asus_laptop {
 	int pega_acc_y;
 	int pega_acc_z;
 
-	struct rfkill *gps_rfkill;
-
-	struct asus_pega_rfkill wlanrfk;
-	struct asus_pega_rfkill btrfk;
-	struct asus_pega_rfkill wwanrfk;
+	struct asus_rfkill wlan;
+	struct asus_rfkill bluetooth;
+	struct asus_rfkill wwan;
+	struct asus_rfkill gps;
 
 	acpi_handle handle;	/* the handle of the hotk device */
 	u32 ledd_status;	/* status of the LED display */
@@ -1228,7 +1227,7 @@ static ssize_t store_gps(struct device *dev, struct device_attribute *attr,
 	ret = asus_gps_switch(asus, !!value);
 	if (ret)
 		return ret;
-	rfkill_set_sw_state(asus->gps_rfkill, !value);
+	rfkill_set_sw_state(asus->gps.rfkill, !value);
 	return rv;
 }
 
@@ -1246,13 +1245,22 @@ static const struct rfkill_ops asus_gps_rfkill_ops = {
 	.set_block = asus_gps_rfkill_set,
 };
 
+static void asus_rfkill_terminate(struct asus_rfkill *rfk)
+{
+	if (!rfk->rfkill)
+		return ;
+
+	rfkill_unregister(rfk->rfkill);
+	rfkill_destroy(rfk->rfkill);
+	rfk->rfkill = NULL;
+}
+
 static void asus_rfkill_exit(struct asus_laptop *asus)
 {
-	if (asus->gps_rfkill) {
-		rfkill_unregister(asus->gps_rfkill);
-		rfkill_destroy(asus->gps_rfkill);
-		asus->gps_rfkill = NULL;
-	}
+	asus_rfkill_terminate(&asus->wwan);
+	asus_rfkill_terminate(&asus->bluetooth);
+	asus_rfkill_terminate(&asus->wlan);
+	asus_rfkill_terminate(&asus->gps);
 }
 
 static int asus_rfkill_init(struct asus_laptop *asus)
@@ -1264,16 +1272,16 @@ static int asus_rfkill_init(struct asus_laptop *asus)
 	    acpi_check_handle(asus->handle, METHOD_GPS_STATUS, NULL))
 		return 0;
 
-	asus->gps_rfkill = rfkill_alloc("asus-gps", &asus->platform_device->dev,
+	asus->gps.rfkill = rfkill_alloc("asus-gps", &asus->platform_device->dev,
 					RFKILL_TYPE_GPS,
 					&asus_gps_rfkill_ops, asus);
-	if (!asus->gps_rfkill)
+	if (!asus->gps.rfkill)
 		return -EINVAL;
 
-	result = rfkill_register(asus->gps_rfkill);
+	result = rfkill_register(asus->gps.rfkill);
 	if (result) {
-		rfkill_destroy(asus->gps_rfkill);
-		asus->gps_rfkill = NULL;
+		rfkill_destroy(asus->gps.rfkill);
+		asus->gps.rfkill = NULL;
 	}
 
 	return result;
@@ -1281,11 +1289,9 @@ static int asus_rfkill_init(struct asus_laptop *asus)
 
 static int pega_rfkill_set(void *data, bool blocked)
 {
-	struct asus_pega_rfkill *pega_rfk = data;
-
-	int ret = asus_pega_lucid_set(pega_rfk->asus, pega_rfk->control_id, !blocked);
-	pr_warn("Setting rfkill %d, to %d; returned %d\n", pega_rfk->control_id, !blocked, ret);
+	struct asus_rfkill *rfk = data;
 
+	int ret = asus_pega_lucid_set(rfk->asus, rfk->control_id, !blocked);
 	return ret;
 }
 
@@ -1293,40 +1299,22 @@ static const struct rfkill_ops pega_rfkill_ops = {
 	.set_block = pega_rfkill_set,
 };
 
-static void pega_rfkill_terminate(struct asus_pega_rfkill *pega_rfk)
-{
-	pr_warn("Terminating %d\n", pega_rfk->control_id);
-	if (pega_rfk->rfkill) {
-		rfkill_unregister(pega_rfk->rfkill);
-		rfkill_destroy(pega_rfk->rfkill);
-		pega_rfk->rfkill = NULL;
-	}
-}
-
-static void pega_rfkill_exit(struct asus_laptop *asus)
-{
-	pega_rfkill_terminate(&asus->wwanrfk);
-	pega_rfkill_terminate(&asus->btrfk);
-	pega_rfkill_terminate(&asus->wlanrfk);
-}
-
-static int pega_rfkill_setup(struct asus_laptop *asus, struct asus_pega_rfkill *pega_rfk,
-		const char *name, int controlid, int rfkill_type)
+static int pega_rfkill_setup(struct asus_laptop *asus, struct asus_rfkill *rfk,
+			     const char *name, int controlid, int rfkill_type)
 {
 	int result;
 
-	pr_warn("Setting up rfk %s, control %d, type %d\n", name, controlid, rfkill_type);
-	pega_rfk->control_id = controlid;
-	pega_rfk->asus = asus;
-	pega_rfk->rfkill = rfkill_alloc(name, &asus->platform_device->dev,
-					rfkill_type, &pega_rfkill_ops, pega_rfk);
-	if (!pega_rfk->rfkill)
+	rfk->control_id = controlid;
+	rfk->asus = asus;
+	rfk->rfkill = rfkill_alloc(name, &asus->platform_device->dev,
+				   rfkill_type, &pega_rfkill_ops, rfk);
+	if (!rfk->rfkill)
 		return -EINVAL;
 
-	result = rfkill_register(pega_rfk->rfkill);
+	result = rfkill_register(rfk->rfkill);
 	if (result) {
-		rfkill_destroy(pega_rfk->rfkill);
-		pega_rfk->rfkill = NULL;
+		rfkill_destroy(rfk->rfkill);
+		rfk->rfkill = NULL;
 	}
 
 	return result;
@@ -1339,22 +1327,22 @@ static int pega_rfkill_init(struct asus_laptop *asus)
 	if(!asus->is_pega_lucid)
 		return -ENODEV;
 
-	ret = pega_rfkill_setup(asus, &asus->wlanrfk, "pega-wlan", PEGA_WLAN, RFKILL_TYPE_WLAN);
+	ret = pega_rfkill_setup(asus, &asus->wlan, "pega-wlan",
+				PEGA_WLAN, RFKILL_TYPE_WLAN);
 	if(ret)
-		return ret;
-	ret = pega_rfkill_setup(asus, &asus->btrfk, "pega-bt", PEGA_BLUETOOTH, RFKILL_TYPE_BLUETOOTH);
-	if(ret)
-		goto err_btrfk;
-	ret = pega_rfkill_setup(asus, &asus->wwanrfk, "pega-wwan", PEGA_WWAN, RFKILL_TYPE_WWAN);
+		goto exit;
+
+	ret = pega_rfkill_setup(asus, &asus->bluetooth, "pega-bt",
+				PEGA_BLUETOOTH, RFKILL_TYPE_BLUETOOTH);
 	if(ret)
-		goto err_wwanrfk;
+		goto exit;
 
-	pr_warn("Pega rfkill init succeeded\n");
-	return 0;
-err_wwanrfk:
-	pega_rfkill_terminate(&asus->btrfk);
-err_btrfk:
-	pega_rfkill_terminate(&asus->wlanrfk);
+	ret = pega_rfkill_setup(asus, &asus->wwan, "pega-wwan",
+				PEGA_WWAN, RFKILL_TYPE_WWAN);
+
+exit:
+	if (ret)
+		asus_rfkill_exit(asus);
 
 	return ret;
 }
@@ -1377,7 +1365,7 @@ static int asus_input_init(struct asus_laptop *asus)
 
 	input = input_allocate_device();
 	if (!input) {
-		pr_info("Unable to allocate input device\n");
+		pr_warn("Unable to allocate input device\n");
 		return -ENOMEM;
 	}
 	input->name = "Asus Laptop extra buttons";
@@ -1392,7 +1380,7 @@ static int asus_input_init(struct asus_laptop *asus)
 	}
 	error = input_register_device(input);
 	if (error) {
-		pr_info("Unable to register input device\n");
+		pr_warn("Unable to register input device\n");
 		goto err_free_keymap;
 	}
 
@@ -1830,7 +1818,6 @@ static int asus_acpi_remove(struct acpi_device *device, int type)
 	asus_led_exit(asus);
 	asus_input_exit(asus);
 	pega_accel_exit(asus);
-	pega_rfkill_exit(asus);
 	asus_platform_exit(asus);
 
 	kfree(asus->name);
-- 
1.7.5.4

