Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1JNJJI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:09:08 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:52679 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146Ab1JNJJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:09:02 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentincj@iksaif.net>
Subject: [PATCH 8/8] asus-laptop: Add rfkill support for Pegatron Lucid tablet
Date: Fri, 14 Oct 2011 11:13:42 +0200
Message-Id: <1318583622-23518-9-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anisse Astier <anisse@astier.eu>

Add three new rfkill switches in this driver that are specific to
Pegatron Lucid tablet.
Please note that you might not need all three switches. For example if
you don't have a 3G module inside your tablet.

Also, on my device, the gpio for the wifi/bt module is connected to the
bluetooth line. Therefore to activate your wireless lan interface, you
need to use the "pega-bt" rfkill switch.

Finally, the rfkill switch only works before the wireless module is
loaded the first time. Unloading ath9k doesn't help, a reboot is
necessary.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-laptop.c |  103 ++++++++++++++++++++++++++++++++++++
 1 files changed, 103 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 0dfd162..58b69b7 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -186,6 +186,9 @@ MODULE_PARM_DESC(als_status, "Set the ALS status on boot "
 
 #define METHOD_PEGA_ENABLE	"ENPR"
 #define METHOD_PEGA_DISABLE	"DAPR"
+#define PEGA_WLAN	0x00
+#define PEGA_BLUETOOTH	0x01
+#define PEGA_WWAN	0x02
 #define PEGA_ALS	0x04
 #define PEGA_ALS_POWER	0x05
 
@@ -213,6 +216,15 @@ struct asus_led {
 };
 
 /*
+ * Same thing for rfkill
+ */
+struct asus_pega_rfkill {
+	int control_id;		/* type of control. Maps to PEGA_* values */
+	struct rfkill *rfkill;
+	struct asus_laptop *asus;
+};
+
+/*
  * This is the main structure, we can use it to store anything interesting
  * about the hotk device
  */
@@ -246,6 +258,10 @@ struct asus_laptop {
 
 	struct rfkill *gps_rfkill;
 
+	struct asus_pega_rfkill wlanrfk;
+	struct asus_pega_rfkill btrfk;
+	struct asus_pega_rfkill wwanrfk;
+
 	acpi_handle handle;	/* the handle of the hotk device */
 	u32 ledd_status;	/* status of the LED display */
 	u8 light_level;		/* light sensor level */
@@ -1263,6 +1279,86 @@ static int asus_rfkill_init(struct asus_laptop *asus)
 	return result;
 }
 
+static int pega_rfkill_set(void *data, bool blocked)
+{
+	struct asus_pega_rfkill *pega_rfk = data;
+
+	int ret = asus_pega_lucid_set(pega_rfk->asus, pega_rfk->control_id, !blocked);
+	pr_warn("Setting rfkill %d, to %d; returned %d\n", pega_rfk->control_id, !blocked, ret);
+
+	return ret;
+}
+
+static const struct rfkill_ops pega_rfkill_ops = {
+	.set_block = pega_rfkill_set,
+};
+
+static void pega_rfkill_terminate(struct asus_pega_rfkill *pega_rfk)
+{
+	pr_warn("Terminating %d\n", pega_rfk->control_id);
+	if (pega_rfk->rfkill) {
+		rfkill_unregister(pega_rfk->rfkill);
+		rfkill_destroy(pega_rfk->rfkill);
+		pega_rfk->rfkill = NULL;
+	}
+}
+
+static void pega_rfkill_exit(struct asus_laptop *asus)
+{
+	pega_rfkill_terminate(&asus->wwanrfk);
+	pega_rfkill_terminate(&asus->btrfk);
+	pega_rfkill_terminate(&asus->wlanrfk);
+}
+
+static int pega_rfkill_setup(struct asus_laptop *asus, struct asus_pega_rfkill *pega_rfk,
+		const char *name, int controlid, int rfkill_type)
+{
+	int result;
+
+	pr_warn("Setting up rfk %s, control %d, type %d\n", name, controlid, rfkill_type);
+	pega_rfk->control_id = controlid;
+	pega_rfk->asus = asus;
+	pega_rfk->rfkill = rfkill_alloc(name, &asus->platform_device->dev,
+					rfkill_type, &pega_rfkill_ops, pega_rfk);
+	if (!pega_rfk->rfkill)
+		return -EINVAL;
+
+	result = rfkill_register(pega_rfk->rfkill);
+	if (result) {
+		rfkill_destroy(pega_rfk->rfkill);
+		pega_rfk->rfkill = NULL;
+	}
+
+	return result;
+}
+
+static int pega_rfkill_init(struct asus_laptop *asus)
+{
+	int ret = 0;
+
+	if(!asus->is_pega_lucid)
+		return -ENODEV;
+
+	ret = pega_rfkill_setup(asus, &asus->wlanrfk, "pega-wlan", PEGA_WLAN, RFKILL_TYPE_WLAN);
+	if(ret)
+		return ret;
+	ret = pega_rfkill_setup(asus, &asus->btrfk, "pega-bt", PEGA_BLUETOOTH, RFKILL_TYPE_BLUETOOTH);
+	if(ret)
+		goto err_btrfk;
+	ret = pega_rfkill_setup(asus, &asus->wwanrfk, "pega-wwan", PEGA_WWAN, RFKILL_TYPE_WWAN);
+	if(ret)
+		goto err_wwanrfk;
+
+	pr_warn("Pega rfkill init succeeded\n");
+	return 0;
+err_wwanrfk:
+	pega_rfkill_terminate(&asus->btrfk);
+err_btrfk:
+	pega_rfkill_terminate(&asus->wlanrfk);
+
+	return ret;
+}
+
 /*
  * Input device (i.e. hotkeys)
  */
@@ -1697,9 +1793,15 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 	if (result && result != -ENODEV)
 		goto fail_pega_accel;
 
+	result = pega_rfkill_init(asus);
+	if (result && result != -ENODEV)
+		goto fail_pega_rfkill;
+
 	asus_device_present = true;
 	return 0;
 
+fail_pega_rfkill:
+	pega_accel_exit(asus);
 fail_pega_accel:
 	asus_rfkill_exit(asus);
 fail_rfkill:
@@ -1726,6 +1828,7 @@ static int asus_acpi_remove(struct acpi_device *device, int type)
 	asus_led_exit(asus);
 	asus_input_exit(asus);
 	pega_accel_exit(asus);
+	pega_rfkill_exit(asus);
 	asus_platform_exit(asus);
 
 	kfree(asus->name);
-- 
1.7.3.4

