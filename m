Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2BQWEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:04:35 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59011 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab2BQWEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:04:32 -0500
Message-ID: <4F3ECEED.9000206@gmail.com>
Date: Sat, 18 Feb 2012 07:04:29 +0900
From: Akio Idehara <zbe64533@gmail.com>
MIME-Version: 1.0
To: mjg@redhat.com
CC: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charles@schwieters.org
Subject: [PATCH] toshiba_acpi: Add support for transflective LCD
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Toshiba laptops have the transflective LCD and toshset
can control its backlight state.  I brought this feature to the
mainline.  It was tested on a Toshiba Portege R500.

Signed-off-by: Akio Idehara <zbe64533@gmail.com>
---
  drivers/platform/x86/toshiba_acpi.c |   43 ++++++++++++++++++++++++++++++++++-
  1 files changed, 42 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index dcdc1f4..af3979c 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -51,6 +51,7 @@
  #include <linux/input.h>
  #include <linux/input/sparse-keymap.h>
  #include <linux/leds.h>
+#include <linux/fb.h>
  #include <linux/slab.h>

  #include <asm/uaccess.h>
@@ -88,6 +89,7 @@ MODULE_LICENSE("GPL");

  /* registers */
  #define HCI_FAN				0x0004
+#define HCI_TR_BACKLIGHT		0x0005
  #define HCI_SYSTEM_EVENT		0x0016
  #define HCI_VIDEO_OUT			0x001c
  #define HCI_HOTKEY_EVENT		0x001e
@@ -122,6 +124,7 @@ struct toshiba_acpi_dev {
  	int video_supported:1;
  	int fan_supported:1;
  	int system_event_supported:1;
+	int tr_backlight_supported:1;

  	struct mutex mutex;
  };
@@ -461,6 +464,22 @@ static const struct rfkill_ops toshiba_rfk_ops = {
  	.poll = bt_rfkill_poll,
  };

+static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, u32 *status)
+{
+	u32 hci_result;
+
+	hci_read1(dev, HCI_TR_BACKLIGHT, status, &hci_result);
+	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+}
+
+static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, int value)
+{
+	u32 hci_result;
+
+	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
+	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+}
+
  static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;

  static int get_lcd(struct backlight_device *bd)
@@ -512,8 +531,19 @@ static int set_lcd(struct toshiba_acpi_dev *dev, int value)

  static int set_lcd_status(struct backlight_device *bd)
  {
+	int ret;
  	struct toshiba_acpi_dev *dev = bl_get_data(bd);
-	return set_lcd(dev, bd->props.brightness);
+
+	ret = set_lcd(dev, bd->props.brightness);
+	if (ret)
+		return ret;
+
+	if (dev->tr_backlight_supported) {
+		int value = (bd->props.power == FB_BLANK_UNBLANK) ? 1 : 0;
+		ret = set_tr_backlight_status(dev, value);
+	}
+
+	return ret;
  }

  static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
@@ -938,6 +968,7 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
  	const char *hci_method;
  	u32 hci_result;
  	u32 dummy;
+	u32 value;
  	bool bt_present;
  	int ret = 0;
  	struct backlight_properties props;
@@ -984,6 +1015,16 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
  	}
  	dev->backlight_dev->props.brightness = get_lcd(dev->backlight_dev);

+	/* Determine whether or not BIOS supports transflective backlight */
+	ret = get_tr_backlight_status(dev, &value) ? false : true;
+	dev->tr_backlight_supported = ret;
+	if (ret) {
+		int power = value ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
+		dev->backlight_dev->props.power = power;
+	} else {
+		dev->backlight_dev->props.power = FB_BLANK_UNBLANK;
+	}
+
  	/* Register rfkill switch for Bluetooth */
  	if (hci_get_bt_present(dev, &bt_present) == HCI_SUCCESS && bt_present) {
  		dev->bt_rfk = rfkill_alloc("Toshiba Bluetooth",
-- 
1.7.7.6
