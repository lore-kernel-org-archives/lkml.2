Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab1EMKtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:49:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49428 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1EMKtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Mfd1DD59oca2SPwmek3SHOwe2JgTJkCtcWDn8LDjCEeT2Br46EaUW7sTaqk6YZ55aj
         FheI3hS9zmmIufjdQZZMAMJwaGCqmoZvJuFeR15RwPDrKGaYAEBfKPle/JfGehGUG3ng
         SziINxucYwNx0YiqGr8tNL+tVokuls+6HDpSs=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: [PATCH] platform: add support for samsung nc210/nc110
Date: Fri, 13 May 2011 20:47:07 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r5; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <20110512164402.GD26585@kroah.com> <201105132044.25928.jasonbstubbs@gmail.com>
In-Reply-To: <201105132044.25928.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105132047.07544.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Stubbs <jasonbstubbs@gmail.com>

This patch adds support for the NC210/NC110 to the samsung-laptop driver.

All SABI commands except for set_brightness work as expected. The behaviour
of set_brightness is as follows:

- Setting a new brightness will only step one level toward the new brightness
  level. For example, setting a level of 5 when the current level is 2 will
  result in a brightness level of 3.
- A spurious KEY_BRIGHTNESS_UP or KEY_BRIGHTNESS_DOWN event is also generated
  along with the change in brightness.
- Neither of the above two issues occur when changing from/to brightness level 0.

Along with adding the DMI checks for the NC210/NC110, this patch adds
detection and a non-intrusive workaround for the above issues.

Signed-off-by: Jason Stubbs <jasonbstubbs@gmail.com>
--
diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index ebf1b07..89fd703 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -226,6 +226,7 @@ static struct backlight_device *backlight_device;
 static struct mutex sabi_mutex;
 static struct platform_device *sdev;
 static struct rfkill *rfk;
+static int has_stepping_quirk;
 
 static int force;
 module_param(force, bool, 0);
@@ -382,6 +383,17 @@ static void set_brightness(u8 user_brightness)
 {
 	u8 user_level = user_brightness + sabi_config->min_brightness;
 
+	if (has_stepping_quirk && user_level != 0) {
+		/*
+		 * short circuit if the specified level is what's already set
+		 * to prevent the screen from flickering needlessly
+		 */
+		if (user_brightness == read_brightness())
+			return;
+
+		sabi_set_command(sabi_config->commands.set_brightness, 0);
+	}
+
 	sabi_set_command(sabi_config->commands.set_brightness, user_level);
 }
 
@@ -390,6 +402,34 @@ static int get_brightness(struct backlight_device *bd)
 	return (int)read_brightness();
 }
 
+static void check_for_stepping_quirk(void)
+{
+	u8 initial_level = read_brightness();
+	u8 check_level;
+
+	/*
+	 * Some laptops (nc210/nc110 at the very least) exhibit the strange
+	 * behaviour of stepping toward rather than setting the brightness
+	 * except when changing to/from brightness level 0. This behaviour
+	 * is checked for here and worked around in set_brightness.
+	 */
+
+	if (initial_level <= 2)
+		check_level = initial_level + 2;
+	else
+		check_level = initial_level - 2;
+
+	has_stepping_quirk = 0;
+	set_brightness(check_level);
+
+	if (read_brightness() != check_level) {
+		has_stepping_quirk = 1;
+		pr_info("enabled workaround for brightness stepping quirk\n");
+	}
+
+	set_brightness(initial_level);
+}
+
 static int update_status(struct backlight_device *bd)
 {
 	set_brightness(bd->props.brightness);
@@ -668,6 +708,15 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "NC210/NC110",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "NC210/NC110"),
+			DMI_MATCH(DMI_BOARD_NAME, "NC210/NC110"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
@@ -776,6 +825,9 @@ static int __init samsung_init(void)
 		}
 	}
 
+	/* Check for stepping quirk */
+	check_for_stepping_quirk();
+
 	/* knock up a platform device to hang stuff off of */
 	sdev = platform_device_register_simple("samsung", -1, NULL, 0);
 	if (IS_ERR(sdev))
