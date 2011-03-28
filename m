Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1C1Mqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 08:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098Ab1C1Mqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 08:46:49 -0400
From: Matthew Garrett <mjg@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jeff.chua.linux@gmail.com,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] acpi: Remove sysfs_create_link from video driver
Date: Mon, 28 Mar 2011 08:46:02 -0400
Message-Id: <1301316362-2955-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 78.105.22.187
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi video driver attempts to explicitly create a sysfs link between
the acpi device and the associated PCI device. However, we're now also
doing this from the backlight core, which means that we get a backtrace
caused by a duplicate file. Remove the code and leave it up to the
backlight core.

Reported-by: Jeff Chua <jeff.chua.linux@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 drivers/acpi/video.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index a18e497..31e9e10 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -824,11 +824,6 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 		device->backlight->props.brightness =
 				acpi_video_get_brightness(device->backlight);
 
-		result = sysfs_create_link(&device->backlight->dev.kobj,
-					   &device->dev->dev.kobj, "device");
-		if (result)
-			printk(KERN_ERR PREFIX "Create sysfs link\n");
-
 		device->cooling_dev = thermal_cooling_device_register("LCD",
 					device->dev, &video_cooling_ops);
 		if (IS_ERR(device->cooling_dev)) {
@@ -1381,7 +1376,6 @@ static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
 		       "Cant remove video notify handler\n");
 	}
 	if (device->backlight) {
-		sysfs_remove_link(&device->backlight->dev.kobj, "device");
 		backlight_device_unregister(device->backlight);
 		device->backlight = NULL;
 	}
-- 
1.7.4.1

