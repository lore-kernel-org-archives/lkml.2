Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab1KZKAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:00:40 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:41832 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1KZKAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:00:34 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/16] samsung-laptop: move code into init/exit functions
Date: Sat, 26 Nov 2011 10:59:59 +0100
Message-Id: <1322301613-8801-3-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create _init()/_exit() function for each subsystem, remove
the local struct samsung_laptop * and only keep a
struct platform_device * that can only be used in samsung_init()
and samsung_exit().

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/samsung-laptop.c |  609 +++++++++++++++++++--------------
 1 files changed, 360 insertions(+), 249 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index c502252..be96910 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -226,14 +226,14 @@ struct samsung_laptop {
 
 	struct mutex sabi_mutex;
 
-	struct platform_device *pdev;
+	struct platform_device *platform_device;
 	struct backlight_device *backlight_device;
 	struct rfkill *rfk;
 
 	bool has_stepping_quirk;
 };
 
-static struct samsung_laptop *samsung;
+
 
 static int force;
 module_param(force, bool, 0);
@@ -244,7 +244,8 @@ static int debug;
 module_param(debug, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "Debug enabled or not");
 
-static int sabi_get_command(u8 command, struct sabi_retval *sretval)
+static int sabi_get_command(struct samsung_laptop *samsung,
+			    u8 command, struct sabi_retval *sretval)
 {
 	const struct sabi_config *config = samsung->config;
 	int retval = 0;
@@ -291,7 +292,8 @@ exit:
 
 }
 
-static int sabi_set_command(u8 command, u8 data)
+static int sabi_set_command(struct samsung_laptop *samsung,
+			    u8 command, u8 data)
 {
 	const struct sabi_config *config = samsung->config;
 	int retval = 0;
@@ -326,53 +328,53 @@ static int sabi_set_command(u8 command, u8 data)
 	return retval;
 }
 
-static void test_backlight(void)
+static void test_backlight(struct samsung_laptop *samsung)
 {
 	const struct sabi_commands *commands = &samsung->config->commands;
 	struct sabi_retval sretval;
 
-	sabi_get_command(commands->get_backlight, &sretval);
+	sabi_get_command(samsung, commands->get_backlight, &sretval);
 	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
 
-	sabi_set_command(commands->set_backlight, 0);
+	sabi_set_command(samsung, commands->set_backlight, 0);
 	printk(KERN_DEBUG "backlight should be off\n");
 
-	sabi_get_command(commands->get_backlight, &sretval);
+	sabi_get_command(samsung, commands->get_backlight, &sretval);
 	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
 
 	msleep(1000);
 
-	sabi_set_command(commands->set_backlight, 1);
+	sabi_set_command(samsung, commands->set_backlight, 1);
 	printk(KERN_DEBUG "backlight should be on\n");
 
-	sabi_get_command(commands->get_backlight, &sretval);
+	sabi_get_command(samsung, commands->get_backlight, &sretval);
 	printk(KERN_DEBUG "backlight = 0x%02x\n", sretval.retval[0]);
 }
 
-static void test_wireless(void)
+static void test_wireless(struct samsung_laptop *samsung)
 {
 	const struct sabi_commands *commands = &samsung->config->commands;
 	struct sabi_retval sretval;
 
-	sabi_get_command(commands->get_wireless_button, &sretval);
+	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
 	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
 
-	sabi_set_command(commands->set_wireless_button, 0);
+	sabi_set_command(samsung, commands->set_wireless_button, 0);
 	printk(KERN_DEBUG "wireless led should be off\n");
 
-	sabi_get_command(commands->get_wireless_button, &sretval);
+	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
 	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
 
 	msleep(1000);
 
-	sabi_set_command(commands->set_wireless_button, 1);
+	sabi_set_command(samsung, commands->set_wireless_button, 1);
 	printk(KERN_DEBUG "wireless led should be on\n");
 
-	sabi_get_command(commands->get_wireless_button, &sretval);
+	sabi_get_command(samsung, commands->get_wireless_button, &sretval);
 	printk(KERN_DEBUG "wireless led = 0x%02x\n", sretval.retval[0]);
 }
 
-static u8 read_brightness(void)
+static int read_brightness(struct samsung_laptop *samsung)
 {
 	const struct sabi_config *config = samsung->config;
 	const struct sabi_commands *commands = &samsung->config->commands;
@@ -380,7 +382,7 @@ static u8 read_brightness(void)
 	int user_brightness = 0;
 	int retval;
 
-	retval = sabi_get_command(commands->get_brightness,
+	retval = sabi_get_command(samsung, commands->get_brightness,
 				  &sretval);
 	if (!retval) {
 		user_brightness = sretval.retval[0];
@@ -392,7 +394,7 @@ static u8 read_brightness(void)
 	return user_brightness;
 }
 
-static void set_brightness(u8 user_brightness)
+static void set_brightness(struct samsung_laptop *samsung, u8 user_brightness)
 {
 	const struct sabi_config *config = samsung->config;
 	const struct sabi_commands *commands = &samsung->config->commands;
@@ -403,25 +405,27 @@ static void set_brightness(u8 user_brightness)
 		 * short circuit if the specified level is what's already set
 		 * to prevent the screen from flickering needlessly
 		 */
-		if (user_brightness == read_brightness())
+		if (user_brightness == read_brightness(samsung))
 			return;
 
-		sabi_set_command(commands->set_brightness, 0);
+		sabi_set_command(samsung, commands->set_brightness, 0);
 	}
 
-	sabi_set_command(commands->set_brightness, user_level);
+	sabi_set_command(samsung, commands->set_brightness, user_level);
 }
 
 static int get_brightness(struct backlight_device *bd)
 {
-	return (int)read_brightness();
+	struct samsung_laptop *samsung = bl_get_data(bd);
+
+	return read_brightness(samsung);
 }
 
-static void check_for_stepping_quirk(void)
+static void check_for_stepping_quirk(struct samsung_laptop *samsung)
 {
-	u8 initial_level;
-	u8 check_level;
-	u8 orig_level = read_brightness();
+	int initial_level;
+	int check_level;
+	int orig_level = read_brightness(samsung);
 
 	/*
 	 * Some laptops exhibit the strange behaviour of stepping toward
@@ -431,9 +435,9 @@ static void check_for_stepping_quirk(void)
 	 */
 
 	if (orig_level == 0)
-		set_brightness(1);
+		set_brightness(samsung, 1);
 
-	initial_level = read_brightness();
+	initial_level = read_brightness(samsung);
 
 	if (initial_level <= 2)
 		check_level = initial_level + 2;
@@ -441,26 +445,28 @@ static void check_for_stepping_quirk(void)
 		check_level = initial_level - 2;
 
 	samsung->has_stepping_quirk = false;
-	set_brightness(check_level);
+	set_brightness(samsung, check_level);
 
-	if (read_brightness() != check_level) {
+	if (read_brightness(samsung) != check_level) {
 		samsung->has_stepping_quirk = true;
 		pr_info("enabled workaround for brightness stepping quirk\n");
 	}
 
-	set_brightness(orig_level);
+	set_brightness(samsung, orig_level);
 }
 
 static int update_status(struct backlight_device *bd)
 {
+	struct samsung_laptop *samsung = bl_get_data(bd);
 	const struct sabi_commands *commands = &samsung->config->commands;
 
-	set_brightness(bd->props.brightness);
+	set_brightness(samsung, bd->props.brightness);
 
 	if (bd->props.power == FB_BLANK_UNBLANK)
-		sabi_set_command(commands->set_backlight, 1);
+		sabi_set_command(samsung, commands->set_backlight, 1);
 	else
-		sabi_set_command(commands->set_backlight, 0);
+		sabi_set_command(samsung, commands->set_backlight, 0);
+
 	return 0;
 }
 
@@ -471,6 +477,7 @@ static const struct backlight_ops backlight_ops = {
 
 static int rfkill_set(void *data, bool blocked)
 {
+	struct samsung_laptop *samsung = data;
 	const struct sabi_commands *commands = &samsung->config->commands;
 
 	/* Do something with blocked...*/
@@ -479,9 +486,9 @@ static int rfkill_set(void *data, bool blocked)
 	 * blocked == true is off
 	 */
 	if (blocked)
-		sabi_set_command(commands->set_wireless_button, 0);
+		sabi_set_command(samsung, commands->set_wireless_button, 0);
 	else
-		sabi_set_command(commands->set_wireless_button, 1);
+		sabi_set_command(samsung, commands->set_wireless_button, 1);
 
 	return 0;
 }
@@ -490,40 +497,18 @@ static struct rfkill_ops rfkill_ops = {
 	.set_block = rfkill_set,
 };
 
-static int init_wireless(struct platform_device *pdev)
-{
-	int retval;
-
-	samsung->rfk = rfkill_alloc("samsung-wifi", &samsung->pdev->dev, RFKILL_TYPE_WLAN,
-				    &rfkill_ops, NULL);
-	if (!samsung->rfk)
-		return -ENOMEM;
-
-	retval = rfkill_register(samsung->rfk);
-	if (retval) {
-		rfkill_destroy(samsung->rfk);
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-static void destroy_wireless(void)
-{
-	rfkill_unregister(samsung->rfk);
-	rfkill_destroy(samsung->rfk);
-}
-
 static ssize_t get_performance_level(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
+	struct samsung_laptop *samsung = dev_get_drvdata(dev);
 	const struct sabi_config *config = samsung->config;
+	const struct sabi_commands *commands = &config->commands;
 	struct sabi_retval sretval;
 	int retval;
 	int i;
 
 	/* Read the state */
-	retval = sabi_get_command(config->commands.get_performance_level,
+	retval = sabi_get_command(samsung, commands->get_performance_level,
 				  &sretval);
 	if (retval)
 		return retval;
@@ -540,32 +525,285 @@ static ssize_t set_performance_level(struct device *dev,
 				struct device_attribute *attr, const char *buf,
 				size_t count)
 {
+	struct samsung_laptop *samsung = dev_get_drvdata(dev);
 	const struct sabi_config *config = samsung->config;
+	const struct sabi_commands *commands = &config->commands;
+	int i;
 
-	if (count >= 1) {
-		int i;
-		for (i = 0; config->performance_levels[i].name; ++i) {
-			const struct sabi_performance_level *level =
-				&config->performance_levels[i];
-			if (!strncasecmp(level->name, buf, strlen(level->name))) {
-				sabi_set_command(config->commands.set_performance_level,
-						 level->value);
-				break;
-			}
+	if (count < 1)
+		return count;
+
+	for (i = 0; config->performance_levels[i].name; ++i) {
+		const struct sabi_performance_level *level =
+			&config->performance_levels[i];
+		if (!strncasecmp(level->name, buf, strlen(level->name))) {
+			sabi_set_command(samsung,
+					 commands->set_performance_level,
+					 level->value);
+			break;
 		}
-		if (!config->performance_levels[i].name)
-			return -EINVAL;
 	}
+
+	if (!config->performance_levels[i].name)
+		return -EINVAL;
+
 	return count;
 }
+
 static DEVICE_ATTR(performance_level, S_IWUSR | S_IRUGO,
 		   get_performance_level, set_performance_level);
 
 
+static int find_signature(void __iomem *memcheck, const char *testStr)
+{
+	int i = 0;
+	int loca;
+
+	for (loca = 0; loca < 0xffff; loca++) {
+		char temp = readb(memcheck + loca);
+
+		if (temp == testStr[i]) {
+			if (i == strlen(testStr)-1)
+				break;
+			++i;
+		} else {
+			i = 0;
+		}
+	}
+	return loca;
+}
+
+static void samsung_rfkill_exit(struct samsung_laptop *samsung)
+{
+	if (samsung->rfk) {
+		rfkill_unregister(samsung->rfk);
+		rfkill_destroy(samsung->rfk);
+		samsung->rfk = NULL;
+	}
+}
+
+static int __init samsung_rfkill_init(struct samsung_laptop *samsung)
+{
+	int retval;
+
+	samsung->rfk = rfkill_alloc("samsung-wifi",
+				    &samsung->platform_device->dev,
+				    RFKILL_TYPE_WLAN,
+				    &rfkill_ops, samsung);
+	if (!samsung->rfk)
+		return -ENOMEM;
+
+	retval = rfkill_register(samsung->rfk);
+	if (retval) {
+		rfkill_destroy(samsung->rfk);
+		samsung->rfk = NULL;
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void samsung_backlight_exit(struct samsung_laptop *samsung)
+{
+	if (samsung->backlight_device) {
+		backlight_device_unregister(samsung->backlight_device);
+		samsung->backlight_device = NULL;
+	}
+}
+
+static int __init samsung_backlight_init(struct samsung_laptop *samsung)
+{
+	struct backlight_device *bd;
+	struct backlight_properties props;
+
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.type = BACKLIGHT_PLATFORM;
+	props.max_brightness = samsung->config->max_brightness -
+		samsung->config->min_brightness;
+
+	bd = backlight_device_register("samsung",
+				       &samsung->platform_device->dev,
+				       samsung, &backlight_ops,
+				       &props);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
+
+	samsung->backlight_device = bd;
+	samsung->backlight_device->props.brightness = read_brightness(samsung);
+	samsung->backlight_device->props.power = FB_BLANK_UNBLANK;
+	backlight_update_status(samsung->backlight_device);
+
+	return 0;
+}
+
+static void samsung_sysfs_exit(struct samsung_laptop *samsung)
+{
+	device_remove_file(&samsung->platform_device->dev,
+			   &dev_attr_performance_level);
+}
+
+static int __init samsung_sysfs_init(struct samsung_laptop *samsung)
+{
+	return device_create_file(&samsung->platform_device->dev,
+				  &dev_attr_performance_level);
+}
+
+static void samsung_sabi_exit(struct samsung_laptop *samsung)
+{
+	const struct sabi_config *config = samsung->config;
+
+	/* Turn off "Linux" mode in the BIOS */
+	if (config && config->commands.set_linux != 0xff)
+		sabi_set_command(samsung, config->commands.set_linux, 0x80);
+
+	if (samsung->sabi_iface) {
+		iounmap(samsung->sabi_iface);
+		samsung->sabi_iface = NULL;
+	}
+	if (samsung->f0000_segment) {
+		iounmap(samsung->f0000_segment);
+		samsung->f0000_segment = NULL;
+	}
+
+	samsung->config = NULL;
+}
+
+static __init void samsung_sabi_infos(struct samsung_laptop *samsung, int loca)
+{
+	const struct sabi_config *config = samsung->config;
+
+	printk(KERN_DEBUG "This computer supports SABI==%x\n",
+	       loca + 0xf0000 - 6);
+	printk(KERN_DEBUG "SABI header:\n");
+	printk(KERN_DEBUG " SMI Port Number = 0x%04x\n",
+	       readw(samsung->sabi + config->header_offsets.port));
+	printk(KERN_DEBUG " SMI Interface Function = 0x%02x\n",
+	       readb(samsung->sabi + config->header_offsets.iface_func));
+	printk(KERN_DEBUG " SMI enable memory buffer = 0x%02x\n",
+	       readb(samsung->sabi + config->header_offsets.en_mem));
+	printk(KERN_DEBUG " SMI restore memory buffer = 0x%02x\n",
+	       readb(samsung->sabi + config->header_offsets.re_mem));
+	printk(KERN_DEBUG " SABI data offset = 0x%04x\n",
+	       readw(samsung->sabi + config->header_offsets.data_offset));
+	printk(KERN_DEBUG " SABI data segment = 0x%04x\n",
+	       readw(samsung->sabi + config->header_offsets.data_segment));
+}
+
+static void __init samsung_sabi_selftest(struct samsung_laptop *samsung,
+					unsigned int ifaceP)
+{
+	const struct sabi_config *config = samsung->config;
+	struct sabi_retval sretval;
+
+	printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
+	printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
+
+	test_backlight(samsung);
+	test_wireless(samsung);
+
+	sabi_get_command(samsung, config->commands.get_brightness, &sretval);
+	printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.retval[0]);
+}
+
+static int __init samsung_sabi_init(struct samsung_laptop *samsung)
+{
+	const struct sabi_config *config = NULL;
+	const struct sabi_commands *commands;
+	unsigned int ifaceP;
+	int ret = 0;
+	int i;
+	int loca;
+
+	samsung->f0000_segment = ioremap_nocache(0xf0000, 0xffff);
+	if (!samsung->f0000_segment) {
+		pr_err("Can't map the segment at 0xf0000\n");
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	/* Try to find one of the signatures in memory to find the header */
+	for (i = 0; sabi_configs[i].test_string != 0; ++i) {
+		samsung->config = &sabi_configs[i];
+		loca = find_signature(samsung->f0000_segment,
+				      samsung->config->test_string);
+		if (loca != 0xffff)
+			break;
+	}
+
+	if (loca == 0xffff) {
+		pr_err("This computer does not support SABI\n");
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	config = samsung->config;
+	commands = &config->commands;
+
+	/* point to the SMI port Number */
+	loca += 1;
+	samsung->sabi = (samsung->f0000_segment + loca);
+
+	if (debug)
+		samsung_sabi_infos(samsung, loca);
+
+	/* Get a pointer to the SABI Interface */
+	ifaceP = (readw(samsung->sabi + config->header_offsets.data_segment) & 0x0ffff) << 4;
+	ifaceP += readw(samsung->sabi + config->header_offsets.data_offset) & 0x0ffff;
+	samsung->sabi_iface = ioremap_nocache(ifaceP, 16);
+	if (!samsung->sabi_iface) {
+		pr_err("Can't remap %x\n", ifaceP);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	if (debug)
+		samsung_sabi_selftest(samsung, ifaceP);
+
+	/* Turn on "Linux" mode in the BIOS */
+	if (commands->set_linux != 0xff) {
+		int retval = sabi_set_command(samsung,
+					      commands->set_linux, 0x81);
+		if (retval) {
+			pr_warn("Linux mode was not set!\n");
+			ret = -ENODEV;
+			goto exit;
+		}
+	}
+
+	/* Check for stepping quirk */
+	check_for_stepping_quirk(samsung);
+
+exit:
+	if (ret)
+		samsung_sabi_exit(samsung);
+
+	return ret;
+}
+
+static void samsung_platform_exit(struct samsung_laptop *samsung)
+{
+	if (samsung->platform_device) {
+		platform_device_unregister(samsung->platform_device);
+		samsung->platform_device = NULL;
+	}
+}
+
+static int __init samsung_platform_init(struct samsung_laptop *samsung)
+{
+	struct platform_device *pdev;
+
+	pdev = platform_device_register_simple("samsung", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	samsung->platform_device = pdev;
+	platform_set_drvdata(samsung->platform_device, samsung);
+	return 0;
+}
+
 static int __init dmi_check_cb(const struct dmi_system_id *id)
 {
-	pr_info("found laptop model '%s'\n",
-		id->ident);
+	pr_info("found laptop model '%s'\n", id->ident);
 	return 1;
 }
 
@@ -806,36 +1044,12 @@ static struct dmi_system_id __initdata samsung_dmi_table[] = {
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);
 
-static int find_signature(void __iomem *memcheck, const char *testStr)
-{
-	int i = 0;
-	int loca;
-
-	for (loca = 0; loca < 0xffff; loca++) {
-		char temp = readb(memcheck + loca);
-
-		if (temp == testStr[i]) {
-			if (i == strlen(testStr)-1)
-				break;
-			++i;
-		} else {
-			i = 0;
-		}
-	}
-	return loca;
-}
+static struct platform_device *samsung_platform_device;
 
 static int __init samsung_init(void)
 {
-	const struct sabi_config *config = NULL;
-	const struct sabi_commands *commands;
-	struct backlight_device *bd;
-	struct backlight_properties props;
-	struct sabi_retval sretval;
-	unsigned int ifaceP;
-	int i;
-	int loca;
-	int retval;
+	struct samsung_laptop *samsung;
+	int ret;
 
 	if (!force && !dmi_check_system(samsung_dmi_table))
 		return -ENODEV;
@@ -846,159 +1060,56 @@ static int __init samsung_init(void)
 
 	mutex_init(&samsung->sabi_mutex);
 
-	samsung->f0000_segment = ioremap_nocache(0xf0000, 0xffff);
-	if (!samsung->f0000_segment) {
-		pr_err("Can't map the segment at 0xf0000\n");
-		goto error_cant_map;
-	}
-
-	/* Try to find one of the signatures in memory to find the header */
-	for (i = 0; sabi_configs[i].test_string != 0; ++i) {
-		samsung->config = &sabi_configs[i];
-		loca = find_signature(samsung->f0000_segment,
-				      samsung->config->test_string);
-		if (loca != 0xffff)
-			break;
-	}
-
-	if (loca == 0xffff) {
-		pr_err("This computer does not support SABI\n");
-		goto error_no_signature;
-	}
-
-	config = samsung->config;
-	commands = &config->commands;
-
-	/* point to the SMI port Number */
-	loca += 1;
-	samsung->sabi = (samsung->f0000_segment + loca);
-
-	if (debug) {
-		printk(KERN_DEBUG "This computer supports SABI==%x\n",
-			loca + 0xf0000 - 6);
-		printk(KERN_DEBUG "SABI header:\n");
-		printk(KERN_DEBUG " SMI Port Number = 0x%04x\n",
-		       readw(samsung->sabi +
-			     config->header_offsets.port));
-		printk(KERN_DEBUG " SMI Interface Function = 0x%02x\n",
-		       readb(samsung->sabi +
-			     config->header_offsets.iface_func));
-		printk(KERN_DEBUG " SMI enable memory buffer = 0x%02x\n",
-		       readb(samsung->sabi +
-			     config->header_offsets.en_mem));
-		printk(KERN_DEBUG " SMI restore memory buffer = 0x%02x\n",
-		       readb(samsung->sabi +
-			     config->header_offsets.re_mem));
-		printk(KERN_DEBUG " SABI data offset = 0x%04x\n",
-		       readw(samsung->sabi +
-			     config->header_offsets.data_offset));
-		printk(KERN_DEBUG " SABI data segment = 0x%04x\n",
-		       readw(samsung->sabi +
-			     config->header_offsets.data_segment));
-	}
-
-	/* Get a pointer to the SABI Interface */
-	ifaceP = (readw(samsung->sabi + config->header_offsets.data_segment) & 0x0ffff) << 4;
-	ifaceP += readw(samsung->sabi + config->header_offsets.data_offset) & 0x0ffff;
-	samsung->sabi_iface = ioremap_nocache(ifaceP, 16);
-	if (!samsung->sabi_iface) {
-		pr_err("Can't remap %x\n", ifaceP);
-		goto error_no_signature;
-	}
-	if (debug) {
-		printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
-		printk(KERN_DEBUG "sabi_iface = %p\n", samsung->sabi_iface);
-
-		test_backlight();
-		test_wireless();
-
-		retval = sabi_get_command(commands->get_brightness,
-					  &sretval);
-		printk(KERN_DEBUG "brightness = 0x%02x\n", sretval.retval[0]);
-	}
-
-	/* Turn on "Linux" mode in the BIOS */
-	if (commands->set_linux != 0xff) {
-		retval = sabi_set_command(commands->set_linux,
-					  0x81);
-		if (retval) {
-			pr_warn("Linux mode was not set!\n");
-			goto error_no_platform;
-		}
-	}
-
-	/* Check for stepping quirk */
-	check_for_stepping_quirk();
-
-	/* knock up a platform device to hang stuff off of */
-	samsung->pdev = platform_device_register_simple("samsung", -1, NULL, 0);
-	if (IS_ERR(samsung->pdev))
-		goto error_no_platform;
-
-	/* create a backlight device to talk to this one */
-	memset(&props, 0, sizeof(struct backlight_properties));
-	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = config->max_brightness -
-				config->min_brightness;
-	bd = backlight_device_register("samsung", &samsung->pdev->dev,
-				       NULL, &backlight_ops,
-				       &props);
-	if (IS_ERR(bd))
-		goto error_no_backlight;
-
-	samsung->backlight_device = bd;
-	samsung->backlight_device->props.brightness = read_brightness();
-	samsung->backlight_device->props.power = FB_BLANK_UNBLANK;
-	backlight_update_status(samsung->backlight_device);
-
-	retval = init_wireless(samsung->pdev);
-	if (retval)
-		goto error_no_rfk;
-
-	retval = device_create_file(&samsung->pdev->dev,
-				    &dev_attr_performance_level);
-	if (retval)
-		goto error_file_create;
-
-	return 0;
-
-error_file_create:
-	destroy_wireless();
-
-error_no_rfk:
-	backlight_device_unregister(samsung->backlight_device);
-
-error_no_backlight:
-	platform_device_unregister(samsung->pdev);
-
-error_no_platform:
-	iounmap(samsung->sabi_iface);
-
-error_no_signature:
-	iounmap(samsung->f0000_segment);
-
-error_cant_map:
+	ret = samsung_platform_init(samsung);
+	if (ret)
+		goto error_platform;
+
+	ret = samsung_sabi_init(samsung);
+	if (ret)
+		goto error_sabi;
+
+	ret = samsung_sysfs_init(samsung);
+	if (ret)
+		goto error_sysfs;
+
+	ret = samsung_backlight_init(samsung);
+	if (ret)
+		goto error_backlight;
+
+	ret = samsung_rfkill_init(samsung);
+	if (ret)
+		goto error_rfkill;
+
+	samsung_platform_device = samsung->platform_device;
+	return ret;
+
+error_rfkill:
+	samsung_backlight_exit(samsung);
+error_backlight:
+	samsung_sysfs_exit(samsung);
+error_sysfs:
+	samsung_sabi_exit(samsung);
+error_sabi:
+	samsung_platform_exit(samsung);
+error_platform:
 	kfree(samsung);
-	samsung = NULL;
-	return -EINVAL;
+	return ret;
 }
 
 static void __exit samsung_exit(void)
 {
-	const struct sabi_commands *commands = &samsung->config->commands;
+	struct samsung_laptop *samsung;
+
+	samsung = platform_get_drvdata(samsung_platform_device);
+
+	samsung_rfkill_exit(samsung);
+	samsung_backlight_exit(samsung);
+	samsung_sysfs_exit(samsung);
+	samsung_sabi_exit(samsung);
+	samsung_platform_exit(samsung);
 
-	/* Turn off "Linux" mode in the BIOS */
-	if (commands->set_linux != 0xff)
-		sabi_set_command(commands->set_linux, 0x80);
-
-	device_remove_file(&samsung->pdev->dev, &dev_attr_performance_level);
-	backlight_device_unregister(samsung->backlight_device);
-	destroy_wireless();
-	iounmap(samsung->sabi_iface);
-	iounmap(samsung->f0000_segment);
-	platform_device_unregister(samsung->pdev);
 	kfree(samsung);
-	samsung = NULL;
+	samsung_platform_device = NULL;
 }
 
 module_init(samsung_init);
-- 
1.7.5.4

