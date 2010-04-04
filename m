Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0DDXk7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 19:40:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0DDXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 19:40:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
Date: Mon, 5 Apr 2010 01:43:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <201003040125.30091.rjw@sisk.pl>
In-Reply-To: <201003040125.30091.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004050143.51109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

On Thursday 04 March 2010, Rafael J. Wysocki wrote:
> There is a problem with the ACPI video resume routine that it's
> executed before the GPU that may be accessed by it.  To fix this
> issue, move the ACPI video resume to a power management notifier,
> so that it's executed after resuming all devices, including the GPU.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Please replace the $subject patch with the appended one.

The problem is that the notifier is also executed while we're checking for
the presence of hibernation image during boot and in that case we'll set the
brightness to a wrong value if device->backlight->props.brightness  is not
initialized by acpi_video_device_find_cap().

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / PM: Move ACPI video resume to a PM notifier

There is a problem with the ACPI video resume routine that it's
executed before the GPU that may be accessed by it.  To fix this
issue, move the ACPI video resume to a power management notifier,
so that's executed after resuming all devices, including the GPU.

Fixes https://bugzilla.kernel.org/show_bug.cgi?id=15096, which is
a listed regression from 2.6.31.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/video.c |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/acpi/video.c
===================================================================
--- linux-2.6.orig/drivers/acpi/video.c
+++ linux-2.6/drivers/acpi/video.c
@@ -43,6 +43,7 @@
 #include <linux/dmi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
+#include <linux/suspend.h>
 
 #define PREFIX "ACPI: "
 
@@ -88,7 +89,6 @@ module_param(allow_duplicates, bool, 064
 static int register_count = 0;
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device, int type);
-static int acpi_video_resume(struct acpi_device *device);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
 
 static const struct acpi_device_id video_device_ids[] = {
@@ -104,7 +104,6 @@ static struct acpi_driver acpi_video_bus
 	.ops = {
 		.add = acpi_video_bus_add,
 		.remove = acpi_video_bus_remove,
-		.resume = acpi_video_resume,
 		.notify = acpi_video_bus_notify,
 		},
 };
@@ -159,6 +158,7 @@ struct acpi_video_bus {
 	struct proc_dir_entry *dir;
 	struct input_dev *input;
 	char phys[32];	/* for input device */
+	struct notifier_block pm_nb;
 };
 
 struct acpi_video_device_flags {
@@ -1020,6 +1020,13 @@ static void acpi_video_device_find_cap(s
 		if (IS_ERR(device->backlight))
 			return;
 
+		/*
+		 * Save current brightness level in case we have to restore it
+		 * before acpi_video_device_lcd_set_level() is called next time.
+		 */
+		device->backlight->props.brightness =
+				acpi_video_get_brightness(device->backlight);
+
 		result = sysfs_create_link(&device->backlight->dev.kobj,
 					   &device->dev->dev.kobj, "device");
 		if (result)
@@ -2235,24 +2242,31 @@ static void acpi_video_device_notify(acp
 	return;
 }
 
-static int instance;
-static int acpi_video_resume(struct acpi_device *device)
+static int acpi_video_resume(struct notifier_block *nb,
+				unsigned long val, void *ign)
 {
 	struct acpi_video_bus *video;
 	struct acpi_video_device *video_device;
 	int i;
 
-	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
+	switch (val) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
+		return NOTIFY_DONE;
+	}
 
-	video = acpi_driver_data(device);
+	video = container_of(nb, struct acpi_video_bus, pm_nb);
+
+	dev_info(&video->device->dev, "Restoring backlight state\n");
 
 	for (i = 0; i < video->attached_count; i++) {
 		video_device = video->attached_array[i].bind_info;
 		if (video_device && video_device->backlight)
 			acpi_video_set_brightness(video_device->backlight);
 	}
-	return AE_OK;
+
+	return NOTIFY_OK;
 }
 
 static acpi_status
@@ -2276,6 +2290,8 @@ acpi_video_bus_match(acpi_handle handle,
 	return AE_OK;
 }
 
+static int instance;
+
 static int acpi_video_bus_add(struct acpi_device *device)
 {
 	struct acpi_video_bus *video;
@@ -2369,6 +2385,10 @@ static int acpi_video_bus_add(struct acp
 	       video->flags.rom ? "yes" : "no",
 	       video->flags.post ? "yes" : "no");
 
+	video->pm_nb.notifier_call = acpi_video_resume;
+	video->pm_nb.priority = 0;
+	register_pm_notifier(&video->pm_nb);
+
 	return 0;
 
  err_free_input_dev:
@@ -2395,6 +2415,8 @@ static int acpi_video_bus_remove(struct 
 
 	video = acpi_driver_data(device);
 
+	unregister_pm_notifier(&video->pm_nb);
+
 	acpi_video_bus_stop_devices(video);
 	acpi_video_bus_put_devices(video);
 	acpi_video_bus_remove_fs(device);
