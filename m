Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab0JAHkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:40:00 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37463 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab0JAHj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:39:57 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 6/9] ideapad: rewrite the hw rfkill notify
Date: Fri,  1 Oct 2010 15:39:49 +0800
Message-Id: <1285918789-13029-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Read hw rfkill status by ec command
2. Not to touch sw status of each rfkill when hw rfkill notify
3. Initial rfkill status when module loaded

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   53 +++++++++++-----------------------
 1 files changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index aacf84e..3826686 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -160,32 +160,6 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
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
@@ -253,32 +227,39 @@ static struct rfkill_ops ideapad_rfk_ops = {
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
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int ret;
+	unsigned long sw_blocked;
 
-	priv->rfk[dev] = rfkill_alloc(ideapad_rfk_data[dev-1].name, &adevice->dev,
-				      ideapad_rfk_data[dev-1].type, &ideapad_rfk_ops,
+	priv->rfk[dev] = rfkill_alloc(ideapad_rfk_data[dev].name, &adevice->dev,
+				      ideapad_rfk_data[dev].type, &ideapad_rfk_ops,
 				      (void *)(long)dev);
 	if (!priv->rfk[dev])
 		return -ENOMEM;
 
+	if (read_ec_data(ideapad_priv->handle, ideapad_rfk_data[dev].opcode-1,
+			 &sw_blocked)) {
+		rfkill_init_sw_state(priv->rfk[dev], 0);
+	} else {
+		sw_blocked = !sw_blocked;
+		rfkill_init_sw_state(priv->rfk[dev], sw_blocked);
+	}
+
 	ret = rfkill_register(priv->rfk[dev]);
 	if (ret) {
 		rfkill_destroy(priv->rfk[dev]);
-- 
1.7.1

