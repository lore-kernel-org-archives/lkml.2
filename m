Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab0HRIig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 04:38:36 -0400
Received: from adelie.canonical.com ([91.189.90.139]:51801 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0HRIid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 04:38:33 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Len Brown <len.brown@intel.com>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 6/8] ideapad: rewrite the hw rfkill notify
Date: Wed, 18 Aug 2010 16:38:25 +0800
Message-Id: <1282120705-11536-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
References: <1282120564-11324-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Read hw rfkill status by ec command
2. Not to touch sw status of each rfkill when hw rfkill notify
3. Enable RF when module initial

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   45 +++++++----------------------------
 1 files changed, 9 insertions(+), 36 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index a1fdb45..9d0e23f 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -162,32 +162,6 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 }
 /* the above is ACPI helpers */
 
-static int ideapad_dev_get_state(int device)
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
-	status = acpi_evaluate_object(NULL, "\\_SB_.GECN", &input, &output);
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_WARNING "IdeaPAD \\_SB_.GECN method failed %d\n", status);
-		return -ENODEV;
-	}
-	if (out_obj.type != ACPI_TYPE_INTEGER) {
-		printk(KERN_WARNING "IdeaPAD \\_SB_.GECN method returned unexpected type\n");
-		return -ENODEV;
-	}
-	return out_obj.integer.value;
-}
-
 static int ideapad_dev_set_state(int device, int state)
 {
 	acpi_status status;
@@ -255,19 +229,17 @@ static struct rfkill_ops ideapad_rfk_ops = {
 static void ideapad_sync_rfk_state(struct acpi_device *adevice)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
-	int hw_blocked = !ideapad_dev_get_state(IDEAPAD_DEV_KILLSW);
+	acpi_handle handle = priv->handle;
+	unsigned long hw_blocked;
 	int i;
 
-	rfkill_set_hw_state(priv->rfk[IDEAPAD_DEV_KILLSW], hw_blocked);
-	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
-		if (priv->rfk[i])
-			rfkill_set_hw_state(priv->rfk[i], hw_blocked);
-	if (hw_blocked)
+	if (read_ec_data(handle, 0x23, &hw_blocked))
 		return;
+	hw_blocked = !hw_blocked;
 
-	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
+	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++)
 		if (priv->rfk[i])
-			rfkill_set_sw_state(priv->rfk[i], !ideapad_dev_get_state(i));
+			rfkill_set_hw_state(priv->rfk[i], hw_blocked);
 }
 
 static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
@@ -275,12 +247,13 @@ static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int ret;
 
-	priv->rfk[dev] = rfkill_alloc(ideapad_rfk_data[dev-1].name, &adevice->dev,
-				      ideapad_rfk_data[dev-1].type, &ideapad_rfk_ops,
+	priv->rfk[dev] = rfkill_alloc(ideapad_rfk_data[dev].name, &adevice->dev,
+				      ideapad_rfk_data[dev].type, &ideapad_rfk_ops,
 				      (void *)(long)dev);
 	if (!priv->rfk[dev])
 		return -ENOMEM;
 
+	rfkill_init_sw_state(priv->rfk[dev], 0);
 	ret = rfkill_register(priv->rfk[dev]);
 	if (ret) {
 		rfkill_destroy(priv->rfk[dev]);
-- 
1.7.0.4

