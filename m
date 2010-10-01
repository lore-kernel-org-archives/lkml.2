Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0JAHjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:39:48 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37287 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0JAHjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:39:46 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Corentin Chary <corentincj@iksaif.net>,
        David Woodhouse <David.Woodhouse@intel.com>, Mario.Holbe@TU-Ilmenau.DE
Subject: [PATCH 5/9] ideapad: use EC command to control camera
Date: Fri,  1 Oct 2010 15:39:40 +0800
Message-Id: <1285918780-13000-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
References: <1285918660-12802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad_acpi.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/ideapad_acpi.c b/drivers/platform/x86/ideapad_acpi.c
index 43a1c89..aacf84e 100644
--- a/drivers/platform/x86/ideapad_acpi.c
+++ b/drivers/platform/x86/ideapad_acpi.c
@@ -35,6 +35,7 @@
 #define IDEAPAD_DEV_KILLSW	4
 
 struct ideapad_private {
+	acpi_handle handle;
 	struct rfkill *rfk[5];
 };
 
@@ -207,24 +208,28 @@ static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
 {
-	int state = ideapad_dev_get_state(IDEAPAD_DEV_CAMERA);
-	if (state < 0)
-		return state;
+	struct ideapad_private *priv = dev_get_drvdata(dev);
+	acpi_handle handle = priv->handle;
+	unsigned long result;
 
-	return sprintf(buf, "%d\n", state);
+	if (read_ec_data(handle, 0x1D, &result))
+		return sprintf(buf, "-1\n");
+	return sprintf(buf, "%lu\n", result);
 }
 
 static ssize_t store_ideapad_cam(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
+	struct ideapad_private *priv = dev_get_drvdata(dev);
+	acpi_handle handle = priv->handle;
 	int ret, state;
 
 	if (!count)
 		return 0;
 	if (sscanf(buf, "%i", &state) != 1)
 		return -EINVAL;
-	ret = ideapad_dev_set_state(IDEAPAD_DEV_CAMERA, !!state);
+	ret = write_ec_cmd(handle, 0x1E, state);
 	if (ret < 0)
 		return ret;
 	return count;
@@ -330,6 +335,7 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 		}
 	}
 
+	priv->handle = adevice->handle;
 	dev_set_drvdata(&adevice->dev, priv);
 	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++) {
 		if (!devs_present[i])
-- 
1.7.1

