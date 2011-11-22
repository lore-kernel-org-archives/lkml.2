Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab1KVWDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:03:23 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:33036 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1KVWDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:03:21 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] samsung-laptop: don't handle backlight if handled by acpi/video
Date: Tue, 22 Nov 2011 23:02:34 +0100
Message-Id: <1321999366-23784-4-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samsung-laptop is not at all related to ACPI, but since this interface
is not documented at all, and the driver has to use it at load to
understand how it works on the laptop, I think it's a good idea to
disable it if a better solution is available.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index be96910..49933d2 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -21,6 +21,7 @@
 #include <linux/dmi.h>
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
+#include <linux/acpi.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
@@ -230,6 +231,7 @@ struct samsung_laptop {
 	struct backlight_device *backlight_device;
 	struct rfkill *rfk;
 
+	bool handle_backlight;
 	bool has_stepping_quirk;
 };
 
@@ -616,6 +618,9 @@ static int __init samsung_backlight_init(struct samsung_laptop *samsung)
 	struct backlight_device *bd;
 	struct backlight_properties props;
 
+	if (!samsung->handle_backlight)
+		return 0;
+
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = samsung->config->max_brightness -
@@ -698,7 +703,8 @@ static void __init samsung_sabi_selftest(struct samsung_laptop *samsung,
 	printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
 	printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
 
-	test_backlight(samsung);
+	if (samsung->handle_backlight)
+		test_backlight(samsung);
 	test_wireless(samsung);
 
 	sabi_get_command(samsung, config->commands.get_brightness, &sretval);
@@ -771,7 +777,8 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 	}
 
 	/* Check for stepping quirk */
-	check_for_stepping_quirk(samsung);
+	if (samsung->handle_backlight)
+		check_for_stepping_quirk(samsung);
 
 exit:
 	if (ret)
@@ -1059,6 +1066,15 @@ static int __init samsung_init(void)
 		return -ENOMEM;
 
 	mutex_init(&samsung->sabi_mutex);
+	samsung->handle_backlight = true;
+
+#ifdef CONFIG_ACPI
+	/* Don't handle backlight here if the acpi video already handle it */
+	if (acpi_video_backlight_support()) {
+		pr_info("Backlight controlled by ACPI video driver\n");
+		samsung->handle_backlight = false;
+	}
+#endif
 
 	ret = samsung_platform_init(samsung);
 	if (ret)
-- 
1.7.5.4

