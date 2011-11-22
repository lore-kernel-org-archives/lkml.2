Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab1KVWDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 17:03:32 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:33274 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab1KVWDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 17:03:30 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] samsung-laptop: ehance SABI support
Date: Tue, 22 Nov 2011 23:02:36 +0100
Message-Id: <1321999366-23784-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* SABI command are on 16 bits, not 8
* SABI can read/write up to 11 byte of data
* There is not real difference between "get" and "set"
  commands, so refactorise the code of both functions

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |  224 ++++++++++++++++----------------
 1 files changed, 112 insertions(+), 112 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index a21e0c3..9dcb582 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -42,9 +42,17 @@
 #define SABI_IFACE_COMPLETE		0x04
 #define SABI_IFACE_DATA			0x05
 
-/* Structure to get data back to the calling function */
-struct sabi_retval {
-	u8 retval[20];
+/* Structure get/set data using sabi */
+struct sabi_data {
+	union {
+		struct {
+			u32 d0;
+			u32 d1;
+			u16 d2;
+			u8  d3;
+		};
+		u8 data[11];
+	};
 };
 
 struct sabi_header_offsets {
@@ -61,8 +69,8 @@ struct sabi_commands {
 	 * Brightness is 0 - 8, as described above.
 	 * Value 0 is for the BIOS to use
 	 */
-	u8 get_brightness;
-	u8 set_brightness;
+	u16 get_brightness;
+	u16 set_brightness;
 
 	/*
 	 * first byte:
@@ -73,37 +81,37 @@ struct sabi_commands {
 	 * 0x03 - 3G is on
 	 * TODO, verify 3G is correct, that doesn't seem right...
 	 */
-	u8 get_wireless_button;
-	u8 set_wireless_button;
+	u16 get_wireless_button;
+	u16 set_wireless_button;
 
 	/* 0 is off, 1 is on */
-	u8 get_backlight;
-	u8 set_backlight;
+	u16 get_backlight;
+	u16 set_backlight;
 
 	/*
 	 * 0x80 or 0x00 - no action
 	 * 0x81 - recovery key pressed
 	 */
-	u8 get_recovery_mode;
-	u8 set_recovery_mode;
+	u16 get_recovery_mode;
+	u16 set_recovery_mode;
 
 	/*
 	 * on seclinux: 0 is low, 1 is high,
 	 * on swsmi: 0 is normal, 1 is silent, 2 is turbo
 	 */
-	u8 get_performance_level;
-	u8 set_performance_level;
+	u16 get_performance_level;
+	u16 set_performance_level;
 
 	/*
 	 * Tell the BIOS that Linux is running on this machine.
 	 * 81 is on, 80 is off
 	 */
-	u8 set_linux;
+	u16 set_linux;
 };
 
 struct sabi_performance_level {
 	const char *name;
-	u8 value;
+	u16 value;
 };
 
 struct sabi_config {
@@ -246,16 +254,25 @@ static int debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
-static int sabi_get_command(struct samsung_laptop *samsung,
-			    u8 command, struct sabi_retval *sretval)
+static int sabi_command(struct samsung_laptop *samsung, u16 command,
+			struct sabi_data *in,
+			struct sabi_data *out)
 {
 	const struct sabi_config *config = samsung->config;
-	int retval = 0;
+	int ret = 0;
 	u16 port = readw(samsung->sabi + config->header_offsets.port);
 	u8 complete, iface_data;
 
 	mutex_lock(&samsung->sabi_mutex);
 
+	if (debug) {
+		if (in)
+			pr_info("SABI 0x%04x {0x%08x, 0x%08x, 0x%04x, 0x%02x}",
+				command, in->d0, in->d1, in->d2, in->d3);
+		else
+			pr_info("SABI 0x%04x", command);
+	}
+
 	/* enable memory to be able to write to it */
 	outb(readb(samsung->sabi + config->header_offsets.en_mem), port);
 
@@ -263,6 +280,12 @@ static int sabi_get_command(struct samsung_laptop *samsung,
 	writew(config->main_function, samsung->sabi_iface + SABI_IFACE_MAIN);
 	writew(command, samsung->sabi_iface + SABI_IFACE_SUB);
 	writeb(0, samsung->sabi_iface + SABI_IFACE_COMPLETE);
+	if (in) {
+		writel(in->d0, samsung->sabi_iface + SABI_IFACE_DATA);
+		writel(in->d1, samsung->sabi_iface + SABI_IFACE_DATA + 4);
+		writew(in->d2, samsung->sabi_iface + SABI_IFACE_DATA + 8);
+		writeb(in->d3, samsung->sabi_iface + SABI_IFACE_DATA + 10);
+	}
 	outb(readb(samsung->sabi + config->header_offsets.iface_func), port);
 
 	/* write protect memory to make it safe */
@@ -272,127 +295,104 @@ static int sabi_get_command(struct samsung_laptop *samsung,
 	complete = readb(samsung->sabi_iface + SABI_IFACE_COMPLETE);
 	iface_data = readb(samsung->sabi_iface + SABI_IFACE_DATA);
 	if (complete != 0xaa || iface_data == 0xff) {
-		pr_warn("SABI get command 0x%02x failed with completion flag 0x%02x and data 0x%02x\n",
-		        command, complete, iface_data);
-		retval = -EINVAL;
+		pr_warn("SABI command 0x%04x failed with"
+			" completion flag 0x%02x", command, complete);
+		ret = -EINVAL;
 		goto exit;
 	}
-	/*
-	 * Save off the data into a structure so the caller use it.
-	 * Right now we only want the first 4 bytes,
-	 * There are commands that need more, but not for the ones we
-	 * currently care about.
-	 */
-	sretval->retval[0] = readb(samsung->sabi_iface + SABI_IFACE_DATA);
-	sretval->retval[1] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 1);
-	sretval->retval[2] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 2);
-	sretval->retval[3] = readb(samsung->sabi_iface + SABI_IFACE_DATA + 3);
+
+	if (out) {
+		out->d0 = readl(samsung->sabi_iface + SABI_IFACE_DATA);
+		out->d1 = readl(samsung->sabi_iface + SABI_IFACE_DATA + 4);
+		out->d2 = readw(samsung->sabi_iface + SABI_IFACE_DATA + 2);
+		out->d3 = readb(samsung->sabi_iface + SABI_IFACE_DATA + 1);
+	}
+
+	if (debug && out) {
+		pr_info("SABI {0x%08x, 0x%08x, 0x%04x, 0x%02x}",
+			out->d0, out->d1, out->d2, out->d3);
+	}
 
 exit:
 	mutex_unlock(&samsung->sabi_mutex);
-	return retval;
-
+	return ret;
 }
 
-static int sabi_set_command(struct samsung_laptop *samsung,
-			    u8 command, u8 data)
+/* simple wrappers usable with most commands */
+static int sabi_set_commandb(struct samsung_laptop *samsung,
+			     u16 command, u8 data)
 {
-	const struct sabi_config *config = samsung->config;
-	int retval = 0;
-	u16 port = readw(samsung->sabi + config->header_offsets.port);
-	u8 complete, iface_data;
+	struct sabi_data in = { .d0 = 0, .d1 = 0, .d2 = 0, .d3 = 0 };
 
-	mutex_lock(&samsung->sabi_mutex);
-
-	/* enable memory to be able to write to it */
-	outb(readb(samsung->sabi + config->header_offsets.en_mem), port);
-
-	/* write out the command */
-	writew(config->main_function, samsung->sabi_iface + SABI_IFACE_MAIN);
-	writew(command, samsung->sabi_iface + SABI_IFACE_SUB);
-	writeb(0, samsung->sabi_iface + SABI_IFACE_COMPLETE);
-	writeb(data, samsung->sabi_iface + SABI_IFACE_DATA);
-	outb(readb(samsung->sabi + config->header_offsets.iface_func), port);
-
-	/* write protect memory to make it safe */
-	outb(readb(samsung->sabi + config->header_offsets.re_mem), port);
-
-	/* see if the command actually succeeded */
-	complete = readb(samsung->sabi_iface + SABI_IFACE_COMPLETE);
-	iface_data = readb(samsung->sabi_iface + SABI_IFACE_DATA);
-	if (complete != 0xaa || iface_data == 0xff) {
-		pr_warn("SABI set command 0x%02x failed with completion flag 0x%02x and data 0x%02x\n",
-		       command, complete, iface_data);
-		retval = -EINVAL;
-	}
-
-	mutex_unlock(&samsung->sabi_mutex);
-	return retval;
+	in.data[0] = data;
+	return sabi_command(samsung, command, &in, NULL);
 }
 
 static void test_backlight(struct samsung_laptop *samsung)
 {
 	const struct sabi_commands *commands = &samsung->config->commands;
-	struct sabi_retval sretval;
+	struct sabi_data sretval;
 
-	sabi_get_command(samsung, commands->get_backlight, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
+	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
 
-	sabi_set_command(samsung, commands->set_backlight, 0);
+	sabi_set_commandb(samsung, commands->set_backlight, 0);
 	printk(KERN_DEBUG "backlight should be off\n");
 
-	sabi_get_command(samsung, commands->get_backlight, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
+	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
 
 	msleep(1000);
 
-	sabi_set_command(samsung, commands->set_backlight, 1);
+	sabi_set_commandb(samsung, commands->set_backlight, 1);
 	printk(KERN_DEBUG "backlight should be on\n");
 
-	sabi_get_command(samsung, commands->get_backlight, &sretval);
-	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_backlight, NULL, &sretval);
+	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.data[0]);
 }
 
 static void test_wireless(struct samsung_laptop *samsung)
 {
 	const struct sabi_commands *commands = &samsung->config->commands;
-	struct sabi_retval sretval;
+	struct sabi_data sretval;
 
-	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
+	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
 
-	sabi_set_command(samsung, commands->set_wireless_button, 0);
+	sabi_set_commandb(samsung, commands->set_wireless_button, 0);
 	printk(KERN_DEBUG "wireless led should be off\n");
 
-	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
+	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
 
 	msleep(1000);
 
-	sabi_set_command(samsung, commands->set_wireless_button, 1);
+	sabi_set_commandb(samsung, commands->set_wireless_button, 1);
 	printk(KERN_DEBUG "wireless led should be on\n");
 
-	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
-	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, commands->get_wireless_button, NULL, &sretval);
+	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.data[0]);
 }
 
 static int read_brightness(struct samsung_laptop *samsung)
 {
 	const struct sabi_config *config = samsung->config;
 	const struct sabi_commands *commands = &samsung->config->commands;
-	struct sabi_retval sretval;
+	struct sabi_data sretval;
 	int user_brightness = 0;
 	int retval;
 
-	retval = sabi_get_command(samsung, commands->get_brightness,
-				  &sretval);
-	if (!retval) {
-		user_brightness = sretval.retval[0];
-		if (user_brightness > config->min_brightness)
-			user_brightness -= config->min_brightness;
-		else
-			user_brightness = 0;
-	}
+	retval = sabi_command(samsung, commands->get_brightness,
+			      NULL, &sretval);
+	if (retval)
+		return retval;
+
+	user_brightness = sretval.data[0];
+	if (user_brightness > config->min_brightness)
+		user_brightness -= config->min_brightness;
+	else
+		user_brightness = 0;
+
 	return user_brightness;
 }
 
@@ -410,10 +410,10 @@ static void set_brightness(struct samsung_laptop *samsung, u8 user_brightness)
 		if (user_brightness == read_brightness(samsung))
 			return;
 
-		sabi_set_command(samsung, commands->set_brightness, 0);
+		sabi_set_commandb(samsung, commands->set_brightness, 0);
 	}
 
-	sabi_set_command(samsung, commands->set_brightness, user_level);
+	sabi_set_commandb(samsung, commands->set_brightness, user_level);
 }
 
 static int get_brightness(struct backlight_device *bd)
@@ -465,9 +465,9 @@ static int update_status(struct backlight_device *bd)
 	set_brightness(samsung, bd->props.brightness);
 
 	if (bd->props.power == FB_BLANK_UNBLANK)
-		sabi_set_command(samsung, commands->set_backlight, 1);
+		sabi_set_commandb(samsung, commands->set_backlight, 1);
 	else
-		sabi_set_command(samsung, commands->set_backlight, 0);
+		sabi_set_commandb(samsung, commands->set_backlight, 0);
 
 	return 0;
 }
@@ -488,9 +488,9 @@ static int rfkill_set(void *data, bool blocked)
 	 * blocked == true is off
 	 */
 	if (blocked)
-		sabi_set_command(samsung, commands->set_wireless_button, 0);
+		sabi_set_commandb(samsung, commands->set_wireless_button, 0);
 	else
-		sabi_set_command(samsung, commands->set_wireless_button, 1);
+		sabi_set_commandb(samsung, commands->set_wireless_button, 1);
 
 	return 0;
 }
@@ -505,19 +505,19 @@ static ssize_t get_performance_level(struct device *dev,
 	struct samsung_laptop *samsung = dev_get_drvdata(dev);
 	const struct sabi_config *config = samsung->config;
 	const struct sabi_commands *commands = &config->commands;
-	struct sabi_retval sretval;
+	struct sabi_data sretval;
 	int retval;
 	int i;
 
 	/* Read the state */
-	retval = sabi_get_command(samsung, commands->get_performance_level,
-				  &sretval);
+	retval = sabi_command(samsung, commands->get_performance_level,
+			      NULL, &sretval);
 	if (retval)
 		return retval;
 
 	/* The logic is backwards, yeah, lots of fun... */
 	for (i = 0; config->performance_levels[i].name; ++i) {
-		if (sretval.retval[0] == config->performance_levels[i].value)
+		if (sretval.data[0] == config->performance_levels[i].value)
 			return sprintf(buf, "%s\n", config->performance_levels[i].name);
 	}
 	return sprintf(buf, "%s\n", "unknown");
@@ -539,9 +539,9 @@ static ssize_t set_performance_level(struct device *dev,
 		const struct sabi_performance_level *level =
 			&config->performance_levels[i];
 		if (!strncasecmp(level->name, buf, strlen(level->name))) {
-			sabi_set_command(samsung,
-					 commands->set_performance_level,
-					 level->value);
+			sabi_set_commandb(samsung,
+					  commands->set_performance_level,
+					  level->value);
 			break;
 		}
 	}
@@ -685,7 +685,7 @@ static void samsung_sabi_exit(struct samsung_laptop *samsung)
 
 	/* Turn off "Linux" mode in the BIOS */
 	if (config && config->commands.set_linux != 0xff)
-		sabi_set_command(samsung, config->commands.set_linux, 0x80);
+		sabi_set_commandb(samsung, config->commands.set_linux, 0x80);
 
 	if (samsung->sabi_iface) {
 		iounmap(samsung->sabi_iface);
@@ -724,7 +724,7 @@ static void __init samsung_sabi_selftest(struct samsung_laptop *samsung,
 					unsigned int ifaceP)
 {
 	const struct sabi_config *config = samsung->config;
-	struct sabi_retval sretval;
+	struct sabi_data sretval;
 
 	printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
 	printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
@@ -733,8 +733,8 @@ static void __init samsung_sabi_selftest(struct samsung_laptop *samsung,
 		test_backlight(samsung);
 	test_wireless(samsung);
 
-	sabi_get_command(samsung, config->commands.get_brightness, &sretval);
-	printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.retval[0]);
+	sabi_command(samsung, config->commands.get_brightness, NULL, &sretval);
+	printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.data[0]);
 }
 
 static int __init samsung_sabi_init(struct samsung_laptop *samsung)
@@ -793,8 +793,8 @@ static int __init samsung_sabi_init(struct samsung_laptop *samsung)
 
 	/* Turn on "Linux" mode in the BIOS */
 	if (commands->set_linux != 0xff) {
-		int retval = sabi_set_command(samsung,
-					      commands->set_linux, 0x81);
+		int retval = sabi_set_commandb(samsung,
+					       commands->set_linux, 0x81);
 		if (retval) {
 			pr_warn("Linux mode was not set!\n");
 			ret = -ENODEV;
-- 
1.7.5.4

