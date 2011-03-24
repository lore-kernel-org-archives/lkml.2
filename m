Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932460Ab1CXCso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:48:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39275 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab1CXCsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:48:42 -0400
Date: Thu, 24 Mar 2011 13:48:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mattia Dongili <malattia@linux.it>
Subject: linux-next: manual merge of the drivers-x86 tree with Linus' tree
Message-Id: <20110324134833.ab78ef3f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/sony-laptop.c between commit bb7ca747f8d6
("backlight: add backlight type") from Linus' tree and commit
8a217a64f01c ("sony-laptop: implement new backlight control method") from
the drivers-x86 tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/sony-laptop.c
index 13d8d63,b4834fd..0000000
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@@ -1245,6 -1351,208 +1351,209 @@@ out_no_enum
  	return;
  }
  
+ /* Keyboard backlight feature */
+ #define KBDBL_HANDLER	0x137
+ #define KBDBL_PRESENT	0xB00
+ #define	SET_MODE	0xC00
+ #define SET_TIMEOUT	0xE00
+ 
+ struct kbd_backlight {
+ 	int mode;
+ 	int timeout;
+ 	struct device_attribute mode_attr;
+ 	struct device_attribute timeout_attr;
+ };
+ 
+ static struct kbd_backlight *kbdbl_handle;
+ 
+ static ssize_t __sony_nc_kbd_backlight_mode_set(u8 value)
+ {
+ 	int result;
+ 
+ 	if (value > 1)
+ 		return -EINVAL;
+ 
+ 	if (sony_call_snc_handle(KBDBL_HANDLER,
+ 				(value << 0x10) | SET_MODE, &result))
+ 		return -EIO;
+ 
+ 	kbdbl_handle->mode = value;
+ 
+ 	return 0;
+ }
+ 
+ static ssize_t sony_nc_kbd_backlight_mode_store(struct device *dev,
+ 		struct device_attribute *attr,
+ 		const char *buffer, size_t count)
+ {
+ 	int ret = 0;
+ 	unsigned long value;
+ 
+ 	if (count > 31)
+ 		return -EINVAL;
+ 
+ 	if (strict_strtoul(buffer, 10, &value))
+ 		return -EINVAL;
+ 
+ 	ret = __sony_nc_kbd_backlight_mode_set(value);
+ 	if (ret < 0)
+ 		return ret;
+ 
+ 	return count;
+ }
+ 
+ static ssize_t sony_nc_kbd_backlight_mode_show(struct device *dev,
+ 		struct device_attribute *attr, char *buffer)
+ {
+ 	ssize_t count = 0;
+ 	count = snprintf(buffer, PAGE_SIZE, "%d\n", kbdbl_handle->mode);
+ 	return count;
+ }
+ 
+ static int __sony_nc_kbd_backlight_timeout_set(u8 value)
+ {
+ 	int result;
+ 
+ 	if (value > 3)
+ 		return -EINVAL;
+ 
+ 	if (sony_call_snc_handle(KBDBL_HANDLER,
+ 				(value << 0x10) | SET_TIMEOUT, &result))
+ 		return -EIO;
+ 
+ 	kbdbl_handle->timeout = value;
+ 
+ 	return 0;
+ }
+ 
+ static ssize_t sony_nc_kbd_backlight_timeout_store(struct device *dev,
+ 		struct device_attribute *attr,
+ 		const char *buffer, size_t count)
+ {
+ 	int ret = 0;
+ 	unsigned long value;
+ 
+ 	if (count > 31)
+ 		return -EINVAL;
+ 
+ 	if (strict_strtoul(buffer, 10, &value))
+ 		return -EINVAL;
+ 
+ 	ret = __sony_nc_kbd_backlight_timeout_set(value);
+ 	if (ret < 0)
+ 		return ret;
+ 
+ 	return count;
+ }
+ 
+ static ssize_t sony_nc_kbd_backlight_timeout_show(struct device *dev,
+ 		struct device_attribute *attr, char *buffer)
+ {
+ 	ssize_t count = 0;
+ 	count = snprintf(buffer, PAGE_SIZE, "%d\n", kbdbl_handle->timeout);
+ 	return count;
+ }
+ 
+ static int sony_nc_kbd_backlight_setup(struct platform_device *pd)
+ {
+ 	int result;
+ 
+ 	if (sony_call_snc_handle(0x137, KBDBL_PRESENT, &result))
+ 		return 0;
+ 	if (!(result & 0x02))
+ 		return 0;
+ 
+ 	kbdbl_handle = kzalloc(sizeof(*kbdbl_handle), GFP_KERNEL);
+ 	if (!kbdbl_handle)
+ 		return -ENOMEM;
+ 
+ 	sysfs_attr_init(&kbdbl_handle->mode_attr.attr);
+ 	kbdbl_handle->mode_attr.attr.name = "kbd_backlight";
+ 	kbdbl_handle->mode_attr.attr.mode = S_IRUGO | S_IWUSR;
+ 	kbdbl_handle->mode_attr.show = sony_nc_kbd_backlight_mode_show;
+ 	kbdbl_handle->mode_attr.store = sony_nc_kbd_backlight_mode_store;
+ 
+ 	sysfs_attr_init(&kbdbl_handle->timeout_attr.attr);
+ 	kbdbl_handle->timeout_attr.attr.name = "kbd_backlight_timeout";
+ 	kbdbl_handle->timeout_attr.attr.mode = S_IRUGO | S_IWUSR;
+ 	kbdbl_handle->timeout_attr.show = sony_nc_kbd_backlight_timeout_show;
+ 	kbdbl_handle->timeout_attr.store = sony_nc_kbd_backlight_timeout_store;
+ 
+ 	if (device_create_file(&pd->dev, &kbdbl_handle->mode_attr))
+ 		goto outkzalloc;
+ 
+ 	if (device_create_file(&pd->dev, &kbdbl_handle->timeout_attr))
+ 		goto outmode;
+ 
+ 	__sony_nc_kbd_backlight_mode_set(kbd_backlight);
+ 	__sony_nc_kbd_backlight_timeout_set(kbd_backlight_timeout);
+ 
+ 	return 0;
+ 
+ outmode:
+ 	device_remove_file(&pd->dev, &kbdbl_handle->mode_attr);
+ outkzalloc:
+ 	kfree(kbdbl_handle);
+ 	kbdbl_handle = NULL;
+ 	return -1;
+ }
+ 
+ static int sony_nc_kbd_backlight_cleanup(struct platform_device *pd)
+ {
+ 	if (kbdbl_handle) {
+ 		device_remove_file(&pd->dev, &kbdbl_handle->mode_attr);
+ 		device_remove_file(&pd->dev, &kbdbl_handle->timeout_attr);
+ 		kfree(kbdbl_handle);
+ 	}
+ 	return 0;
+ }
+ 
+ static void sony_nc_backlight_setup(void)
+ {
+ 	acpi_handle unused;
+ 	int max_brightness = 0;
+ 	const struct backlight_ops *ops = NULL;
+ 	struct backlight_properties props;
+ 
+ 	if (sony_find_snc_handle(0x12f) != -1) {
+ 		backlight_ng_handle = 0x12f;
+ 		ops = &sony_backlight_ng_ops;
+ 		max_brightness = 0xff;
+ 
+ 	} else if (sony_find_snc_handle(0x137) != -1) {
+ 		backlight_ng_handle = 0x137;
+ 		ops = &sony_backlight_ng_ops;
+ 		max_brightness = 0xff;
+ 
+ 	} else if (ACPI_SUCCESS(acpi_get_handle(sony_nc_acpi_handle, "GBRT",
+ 						&unused))) {
+ 		ops = &sony_backlight_ops;
+ 		max_brightness = SONY_MAX_BRIGHTNESS - 1;
+ 
+ 	} else
+ 		return;
+ 
+ 	memset(&props, 0, sizeof(struct backlight_properties));
++	props.type = BACKLIGHT_PLATFORM;
+ 	props.max_brightness = max_brightness;
+ 	sony_backlight_device = backlight_device_register("sony", NULL,
+ 							  &backlight_ng_handle,
+ 							  ops, &props);
+ 
+ 	if (IS_ERR(sony_backlight_device)) {
+ 		pr_warning(DRV_PFX "unable to register backlight device\n");
+ 		sony_backlight_device = NULL;
+ 	} else
+ 		sony_backlight_device->props.brightness =
+ 		    ops->get_brightness(sony_backlight_device);
+ }
+ 
+ static void sony_nc_backlight_cleanup(void)
+ {
+ 	if (sony_backlight_device)
+ 		backlight_device_unregister(sony_backlight_device);
+ }
+ 
  static int sony_nc_add(struct acpi_device *device)
  {
  	acpi_status status;
