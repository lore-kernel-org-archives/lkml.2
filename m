Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab1DZM0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:26:24 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57138 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773Ab1DZM0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:26:23 -0400
From: Stefan Bader <stefan.bader@canonical.com>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Eric Anholt <eric@anholt.net>, Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.32+drm33-longterm] Patch "Subject: [PATCH 01/21] drm/i915: set DIDL using the ACPI video output device _ADR method return." has been added to staging queue
Date: Tue, 26 Apr 2011 14:26:18 +0200
Message-Id: <1303820778-3391-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    Subject: [PATCH 01/21] drm/i915: set DIDL using the ACPI video output device _ADR method return.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From f1b04d7aec970cfb0b488ed2ac03da0bd01d69d7 Mon Sep 17 00:00:00 2001
From: Zhang Rui <rui.zhang@intel.com>
Date: Mon, 29 Mar 2010 15:12:16 +0800
Subject: [PATCH 01/21] drm/i915: set DIDL using the ACPI video output device _ADR method return.

commit 3143751ff51a163b77f7efd389043e038f3e008e upstream.

we used to set the DIDL in the output device detected order.
But some BIOSes requires it to be initialized in the ACPI device order.
e.g. the value of the first field in DIDL stands for the first
ACPI video output device in ACPI namespace.

Now we initialize the DIDL using the device id, i.e. _ADR return value,
of each ACPI video device, if it is not 0.
https://bugzilla.kernel.org/show_bug.cgi?id=15054

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/i915_opregion.c |   54 +++++++++++++++++++++++++++++++--
 1 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_opregion.c b/drivers/gpu/drm/i915/i915_opregion.c
index 7cc8410..8fcc75c 100644
--- a/drivers/gpu/drm/i915/i915_opregion.c
+++ b/drivers/gpu/drm/i915/i915_opregion.c
@@ -382,8 +382,57 @@ static void intel_didl_outputs(struct drm_device *dev)
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_opregion *opregion = &dev_priv->opregion;
 	struct drm_connector *connector;
+	acpi_handle handle;
+	struct acpi_device *acpi_dev, *acpi_cdev, *acpi_video_bus = NULL;
+	unsigned long long device_id;
+	acpi_status status;
 	int i = 0;

+	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
+	if (!handle || ACPI_FAILURE(acpi_bus_get_device(handle, &acpi_dev)))
+		return;
+
+	if (acpi_is_video_device(acpi_dev))
+		acpi_video_bus = acpi_dev;
+	else {
+		list_for_each_entry(acpi_cdev, &acpi_dev->children, node) {
+			if (acpi_is_video_device(acpi_cdev)) {
+				acpi_video_bus = acpi_cdev;
+				break;
+			}
+		}
+	}
+
+	if (!acpi_video_bus) {
+		printk(KERN_WARNING "No ACPI video bus found\n");
+		return;
+	}
+
+	list_for_each_entry(acpi_cdev, &acpi_video_bus->children, node) {
+		if (i >= 8) {
+			dev_printk (KERN_ERR, &dev->pdev->dev,
+				    "More than 8 outputs detected\n");
+			return;
+		}
+		status =
+			acpi_evaluate_integer(acpi_cdev->handle, "_ADR",
+						NULL, &device_id);
+		if (ACPI_SUCCESS(status)) {
+			if (!device_id)
+				goto blind_set;
+			opregion->acpi->didl[i] = (u32)(device_id & 0x0f0f);
+			i++;
+		}
+	}
+
+end:
+	/* If fewer than 8 outputs, the list must be null terminated */
+	if (i < 8)
+		opregion->acpi->didl[i] = 0;
+	return;
+
+blind_set:
+	i = 0;
 	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
 		int output_type = ACPI_OTHER_OUTPUT;
 		if (i >= 8) {
@@ -416,10 +465,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 		opregion->acpi->didl[i] |= (1<<31) | output_type | i;
 		i++;
 	}
-
-	/* If fewer than 8 outputs, the list must be null terminated */
-	if (i < 8)
-		opregion->acpi->didl[i] = 0;
+	goto end;
 }

 int intel_opregion_init(struct drm_device *dev, int resume)
--
1.7.0.4

