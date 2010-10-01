Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0JAHkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:40:08 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37593 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab0JAHkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:40:05 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 7/9] ideapad: rewrite the sw rfkill set
Date: Fri,  1 Oct 2010 15:39:59 +0800
Message-Id: <1285918799-13058-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Control power of rf modules by ec commands

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   37 +++++++++++-----------------------
 1 files changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 3826686..78ac02a 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -37,18 +37,19 @@
 struct ideapad_private {
 	acpi_handle handle;
 	struct rfkill *rfk[5];
-};
+} *ideapad_priv;
 
 static struct {
 	char *name;
 	int cfgbit;
+	int opcode;
 	int type;
 } ideapad_rfk_data[] = {
-	{ "ideapad_camera",	19, NUM_RFKILL_TYPES },
-	{ "ideapad_wlan",	18, RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth",	16, RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",		17, RFKILL_TYPE_WWAN },
-	{ "ideapad_killsw",	0, RFKILL_TYPE_WLAN }
+	{ "ideapad_camera",	19, 0x1E, NUM_RFKILL_TYPES },
+	{ "ideapad_wlan",	18, 0x15, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth",	16, 0x17, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",		17, 0x20, RFKILL_TYPE_WWAN },
+	{ "ideapad_killsw",	0,  0,    RFKILL_TYPE_WLAN }
 };
 
 /*
@@ -160,24 +161,6 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 }
 /* the above is ACPI helpers */
 
-static int ideapad_dev_set_state(int device, int state)
-{
-	acpi_status status;
-	union acpi_object in_params[2];
-	struct acpi_object_list input = { 2, in_params };
-
-	in_params[0].type = ACPI_TYPE_INTEGER;
-	in_params[0].integer.value = device + 1;
-	in_params[1].type = ACPI_TYPE_INTEGER;
-	in_params[1].integer.value = state;
-
-	status = acpi_evaluate_object(NULL, "\\_SB_.SECN", &input, NULL);
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_WARNING "IdeaPAD \\_SB_.SECN method failed %d\n", status);
-		return -ENODEV;
-	}
-	return 0;
-}
 static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -217,7 +200,10 @@ static int ideapad_rfk_set(void *data, bool blocked)
 
 	if (device == IDEAPAD_DEV_KILLSW)
 		return -EINVAL;
-	return ideapad_dev_set_state(device, !blocked);
+
+	return write_ec_cmd(ideapad_priv->handle,
+			    ideapad_rfk_data[device].opcode,
+			    !blocked);
 }
 
 static struct rfkill_ops ideapad_rfk_ops = {
@@ -318,6 +304,7 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 
 	priv->handle = adevice->handle;
 	dev_set_drvdata(&adevice->dev, priv);
+	ideapad_priv = priv;
 	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++) {
 		if (!devs_present[i])
 			continue;
-- 
1.7.1

