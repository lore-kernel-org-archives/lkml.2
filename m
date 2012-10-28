Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2J1X0q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:26:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41725 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754990Ab2J1X0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:26:38 -0400
Message-Id: <20121028231537.707269968@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:15:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>
Subject: [ 002/105] samsung-laptop: dont handle backlight if handled by acpi/video
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Corentin Chary <corentincj@iksaif.net>

commit f34cd9ca9320876e9c12764f052004628a03ba2d upstream.

samsung-laptop is not at all related to ACPI, but since this interface
is not documented at all, and the driver has to use it at load to
understand how it works on the laptop, I think it's a good idea to
disable it if a better solution is available.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
[bwh: Backported to 3.2:
 - Adjust context, and change return to goto, since we do not have commit
   5dea7a2 ('samsung-laptop: move code into init/exit functions')
 - Use static variable since we do not have commit a6df489
   ('samsung-laptop: put all local variables in a single structure')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -21,6 +21,7 @@
 #include <linux/dmi.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/acpi.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
@@ -226,6 +227,7 @@ static struct backlight_device *backligh
 static struct mutex sabi_mutex;
 static struct platform_device *sdev;
 static struct rfkill *rfk;
+static bool handle_backlight;
 static bool has_stepping_quirk;
 
 static int force;
@@ -602,6 +604,15 @@ static int __init samsung_init(void)
 	int retval;
 
 	mutex_init(&sabi_mutex);
+	handle_backlight = true;
+
+#ifdef CONFIG_ACPI
+	/* Don't handle backlight here if the acpi video already handle it */
+	if (acpi_video_backlight_support()) {
+		pr_info("Backlight controlled by ACPI video driver\n");
+		handle_backlight = false;
+	}
+#endif
 
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
@@ -661,7 +672,8 @@ static int __init samsung_init(void)
 		printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
 		printk(KERN_DEBUG "sabi_iface = %p\n", sabi_iface);
 
-		test_backlight();
+		if (handle_backlight)
+			test_backlight();
 		test_wireless();
 
 		retval = sabi_get_command(sabi_config->commands.get_brightness,
@@ -680,13 +692,17 @@ static int __init samsung_init(void)
 	}
 
 	/* Check for stepping quirk */
-	check_for_stepping_quirk();
+	if (handle_backlight)
+		check_for_stepping_quirk();
 
 	/* knock up a platform device to hang stuff off of */
 	sdev = platform_device_register_simple("samsung", -1, NULL, 0);
 	if (IS_ERR(sdev))
 		goto error_no_platform;
 
+	if (!handle_backlight)
+		goto skip_backlight;
+
 	/* create a backlight device to talk to this one */
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
@@ -702,6 +718,7 @@ static int __init samsung_init(void)
 	backlight_device->props.power = FB_BLANK_UNBLANK;
 	backlight_update_status(backlight_device);
 
+skip_backlight:
 	retval = init_wireless(sdev);
 	if (retval)
 		goto error_no_rfk;


