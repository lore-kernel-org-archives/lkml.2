Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2DEQr4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:47:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43606 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab2DEQry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:47:54 -0400
From: Akio Idehara <zbe64533@gmail.com>
To: mjg59@srcf.ucam.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        seth.forshee@canonical.com, Akio Idehara <zbe64533@gmail.com>
Subject: [PATCH v4] toshiba_acpi: Add support for transflective LCD
Date: Fri,  6 Apr 2012 01:46:43 +0900
Message-Id: <1333644403-2985-1-git-send-email-zbe64533@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some Toshiba laptops have the transflective LCD and toshset
can control its backlight state.  I brought this feature to the
mainline.  To support transflective LCD, it's implemented by
adding an extra level to the backlight and having 0 change to
transflective mode.  It was tested on a Toshiba Portege R500.

Signed-off-by: Akio Idehara <zbe64533@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c |   63 +++++++++++++++++++++++++++++++---
 1 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index ee79ce6..cc0641b 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -95,6 +95,7 @@ MODULE_LICENSE("GPL");
 
 /* registers */
 #define HCI_FAN				0x0004
+#define HCI_TR_BACKLIGHT		0x0005
 #define HCI_SYSTEM_EVENT		0x0016
 #define HCI_VIDEO_OUT			0x001c
 #define HCI_HOTKEY_EVENT		0x001e
@@ -134,6 +135,7 @@ struct toshiba_acpi_dev {
 	unsigned int system_event_supported:1;
 	unsigned int ntfy_supported:1;
 	unsigned int info_supported:1;
+	unsigned int tr_backlight_supported:1;
 
 	struct mutex mutex;
 };
@@ -478,6 +480,25 @@ static const struct rfkill_ops toshiba_rfk_ops = {
 	.poll = bt_rfkill_poll,
 };
 
+static int get_tr_backlight_status(struct toshiba_acpi_dev *dev, bool *enabled)
+{
+	u32 hci_result;
+	u32 status;
+
+	hci_read1(dev, HCI_TR_BACKLIGHT, &status, &hci_result);
+	*enabled = !status;
+	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+}
+
+static int set_tr_backlight_status(struct toshiba_acpi_dev *dev, bool enable)
+{
+	u32 hci_result;
+	u32 value = !enable;
+
+	hci_write1(dev, HCI_TR_BACKLIGHT, value, &hci_result);
+	return hci_result == HCI_SUCCESS ? 0 : -EIO;
+}
+
 static struct proc_dir_entry *toshiba_proc_dir /*= 0*/ ;
 
 static int get_lcd(struct backlight_device *bd)
@@ -485,10 +506,21 @@ static int get_lcd(struct backlight_device *bd)
 	struct toshiba_acpi_dev *dev = bl_get_data(bd);
 	u32 hci_result;
 	u32 value;
+	int brightness = 0;
+
+	if (dev->tr_backlight_supported) {
+		bool enabled;
+		int ret = get_tr_backlight_status(dev, &enabled);
+		if (ret)
+			return ret;
+		if (enabled)
+			return 0;
+		brightness++;
+	}
 
 	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
 	if (hci_result == HCI_SUCCESS)
-		return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
+		return brightness + (value >> HCI_LCD_BRIGHTNESS_SHIFT);
 
 	return -EIO;
 }
@@ -497,15 +529,16 @@ static int lcd_proc_show(struct seq_file *m, void *v)
 {
 	struct toshiba_acpi_dev *dev = m->private;
 	int value;
+	int levels;
 
 	if (!dev->backlight_dev)
 		return -ENODEV;
 
+	levels = dev->backlight_dev->props.max_brightness + 1;
 	value = get_lcd(dev->backlight_dev);
 	if (value >= 0) {
 		seq_printf(m, "brightness:              %d\n", value);
-		seq_printf(m, "brightness_levels:       %d\n",
-			     HCI_LCD_BRIGHTNESS_LEVELS);
+		seq_printf(m, "brightness_levels:       %d\n", levels);
 		return 0;
 	}
 
@@ -521,6 +554,14 @@ static int lcd_proc_open(struct inode *inode, struct file *file)
 static int set_lcd(struct toshiba_acpi_dev *dev, int value)
 {
 	u32 hci_result;
+	if (dev->tr_backlight_supported) {
+		bool enable = !value;
+		int ret = set_tr_backlight_status(dev, enable);
+		if (ret)
+			return ret;
+		if (value)
+			value--;
+	}
 
 	value = value << HCI_LCD_BRIGHTNESS_SHIFT;
 	hci_write1(dev, HCI_LCD_BRIGHTNESS, value, &hci_result);
@@ -541,6 +582,7 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	size_t len;
 	int value;
 	int ret;
+	int levels = dev->backlight_dev->props.max_brightness + 1;
 
 	len = min(count, sizeof(cmd) - 1);
 	if (copy_from_user(cmd, buf, len))
@@ -548,7 +590,7 @@ static ssize_t lcd_proc_write(struct file *file, const char __user *buf,
 	cmd[len] = '\0';
 
 	if (sscanf(cmd, " brightness : %i", &value) == 1 &&
-	    value >= 0 && value < HCI_LCD_BRIGHTNESS_LEVELS) {
+	    value >= 0 && value < levels) {
 		ret = set_lcd(dev, value);
 		if (ret == 0)
 			ret = count;
@@ -860,8 +902,9 @@ static void remove_toshiba_proc_entries(struct toshiba_acpi_dev *dev)
 }
 
 static const struct backlight_ops toshiba_backlight_data = {
-        .get_brightness = get_lcd,
-        .update_status  = set_lcd_status,
+	.options	= BL_CORE_SUSPENDRESUME,
+	.get_brightness	= get_lcd,
+	.update_status	= set_lcd_status,
 };
 
 static bool toshiba_acpi_i8042_filter(unsigned char data, unsigned char str,
@@ -1079,6 +1122,7 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 	bool bt_present;
 	int ret = 0;
 	struct backlight_properties props;
+	bool enabled;
 
 	if (toshiba_acpi)
 		return -EBUSY;
@@ -1104,8 +1148,15 @@ static int __devinit toshiba_acpi_add(struct acpi_device *acpi_dev)
 
 	mutex_init(&dev->mutex);
 
+	/* Determine whether or not BIOS supports transflective backlight */
+	ret = get_tr_backlight_status(dev, &enabled);
+	dev->tr_backlight_supported = !ret;
+
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = HCI_LCD_BRIGHTNESS_LEVELS - 1;
+	/* adding an extra level and having 0 change to transflective mode */
+	if (dev->tr_backlight_supported)
+		props.max_brightness++;
 	dev->backlight_dev = backlight_device_register("toshiba",
 						       &acpi_dev->dev,
 						       dev,
-- 
1.7.7.6

