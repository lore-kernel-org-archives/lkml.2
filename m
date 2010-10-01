Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0JAHji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:39:38 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37192 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172Ab0JAHjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:39:36 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 4/9] ideapad: use return value of _CFG to tell if device exist or not
Date: Fri,  1 Oct 2010 15:39:29 +0800
Message-Id: <1285918769-12971-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several bits of the return value of _CFG shows if RF/Camera devices
exist or not.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   44 ++++++++---------------------------
 1 files changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 9face93..43a1c89 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -40,13 +40,14 @@ struct ideapad_private {
 
 static struct {
 	char *name;
+	int cfgbit;
 	int type;
 } ideapad_rfk_data[] = {
-	/* camera has no rfkill */
-	{ "ideapad_wlan",	RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth",	RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",		RFKILL_TYPE_WWAN },
-	{ "ideapad_killsw",	RFKILL_TYPE_WLAN }
+	{ "ideapad_camera",	19, NUM_RFKILL_TYPES },
+	{ "ideapad_wlan",	18, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth",	16, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",		17, RFKILL_TYPE_WWAN },
+	{ "ideapad_killsw",	0, RFKILL_TYPE_WLAN }
 };
 
 /*
@@ -158,32 +159,6 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 }
 /* the above is ACPI helpers */
 
-static int ideapad_dev_exists(int device)
-{
-	acpi_status status;
-	union acpi_object in_param;
-	struct acpi_object_list input = { 1, &in_param };
-	struct acpi_buffer output;
-	union acpi_object out_obj;
-
-	output.length = sizeof(out_obj);
-	output.pointer = &out_obj;
-
-	in_param.type = ACPI_TYPE_INTEGER;
-	in_param.integer.value = device + 1;
-
-	status = acpi_evaluate_object(NULL, "\\_SB_.DECN", &input, &output);
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_WARNING "IdeaPAD \\_SB_.DECN method failed %d. Is this an IdeaPAD?\n", status);
-		return -ENODEV;
-	}
-	if (out_obj.type != ACPI_TYPE_INTEGER) {
-		printk(KERN_WARNING "IdeaPAD \\_SB_.DECN method returned unexpected type\n");
-		return -ENODEV;
-	}
-	return out_obj.integer.value;
-}
-
 static int ideapad_dev_get_state(int device)
 {
 	acpi_status status;
@@ -334,9 +309,10 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 		return -ENODEV;
 
 	for (i = IDEAPAD_DEV_CAMERA; i < IDEAPAD_DEV_KILLSW; i++) {
-		devs_present[i] = ideapad_dev_exists(i);
-		if (devs_present[i] < 0)
-			return devs_present[i];
+		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
+			devs_present[i] = 1;
+		else
+			devs_present[i] = 0;
 	}
 
 	/* The hardware switch is always present */
-- 
1.7.1

