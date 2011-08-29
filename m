Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab1H2VFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 17:05:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59515 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1H2VFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 17:05:05 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Azael Avalos <coproscefalo@gmail.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/5] toshiba_acpi: Fix up return codes
Date: Mon, 29 Aug 2011 16:04:52 -0500
Message-Id: <1314651895-24345-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314651895-24345-1-git-send-email-seth.forshee@canonical.com>
References: <1314651895-24345-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many routines are returning success on failure, and those that are
indicating failure frequently return incorrect error codes. Fix
these up throughout the driver.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/platform/x86/toshiba_acpi.c |   45 +++++++++++++++-------------------
 1 files changed, 20 insertions(+), 25 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 604c666..bb142e9 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -191,7 +191,7 @@ static int write_acpi_int(const char *methodName, int val)
 	in_objs[0].integer.value = val;
 
 	status = acpi_evaluate_object(NULL, (char *)methodName, &params, NULL);
-	return (status == AE_OK);
+	return (status == AE_OK) ? 0 : -EIO;
 }
 
 /* Perform a raw HCI call.  Here we don't care about input or output buffer
@@ -419,7 +419,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 
 	mutex_lock(&dev->mutex);
 	if (hci_get_radio_state(dev, &radio_state) != HCI_SUCCESS) {
-		err = -EBUSY;
+		err = -EIO;
 		goto out;
 	}
 
@@ -432,7 +432,7 @@ static int bt_rfkill_set_block(void *data, bool blocked)
 	hci_write2(dev, HCI_WIRELESS, value, HCI_WIRELESS_BT_ATTACH, &result2);
 
 	if (result1 != HCI_SUCCESS || result2 != HCI_SUCCESS)
-		err = -EBUSY;
+		err = -EIO;
 	else
 		err = 0;
  out:
@@ -478,10 +478,10 @@ static int get_lcd(struct backlight_device *bd)
 	u32 value;
 
 	hci_read1(dev, HCI_LCD_BRIGHTNESS, &value, &hci_result);
-	if (hci_result == HCI_SUCCESS) {
+	if (hci_result == HCI_SUCCESS)
 		return (value >> HCI_LCD_BRIGHTNESS_SHIFT);
-	} else
-		return -EFAULT;
+
+	return -EIO;
 }
 
 static int lcd_proc_show(struct seq_file *m, void *v)
@@ -497,11 +497,11 @@ static int lcd_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "brightness:              %d\n", value);
 		seq_printf(m, "brightness_levels:       %d\n",
 			     HCI_LCD_BRIGHTNESS_LEVELS);
-	} else {
-		pr_err("Error reading LCD brightness\n");
+		return 0;
 	}
 
-	return 0;
+	pr_err("Error reading LCD brightness\n");
+	return -EIO;
 }
 
 static int lcd_proc_open(struct inode *inode, struct file *file)
@@ -515,10 +515,7 @@ static int set_lcd(struct toshiba_acpi_dev *dev, int value)
 
 	value = value << HCI_LCD_BRIGHTNESS_SHIFT;
 	hci_write1(dev, HCI_LCD_BRIGHTNESS, value, &hci_result);
-	if (hci_result != HCI_SUCCESS)
-		return -EFAULT;
-
-	return 0;
+	return hci_result == HCI_SUCCESS ? 0 : -EIO;
 }
 
 static int set_lcd_status(struct backlight_device *bd)
@@ -575,11 +572,10 @@ static int video_proc_show(struct seq_file *m, void *v)
 		seq_printf(m, "lcd_out:                 %d\n", is_lcd);
 		seq_printf(m, "crt_out:                 %d\n", is_crt);
 		seq_printf(m, "tv_out:                  %d\n", is_tv);
-	} else {
-		pr_err("Error reading video out status\n");
+		return 0;
 	}
 
-	return 0;
+	return -EIO;
 }
 
 static int video_proc_open(struct inode *inode, struct file *file)
@@ -592,6 +588,7 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 {
 	struct toshiba_acpi_dev *dev = PDE(file->f_path.dentry->d_inode)->data;
 	char *cmd, *buffer;
+	int ret = 0;
 	int value;
 	int remain = count;
 	int lcd_out = -1;
@@ -644,12 +641,12 @@ static ssize_t video_proc_write(struct file *file, const char __user *buf,
 		/* To avoid unnecessary video disruption, only write the new
 		 * video setting if something changed. */
 		if (new_video_out != video_out)
-			write_acpi_int(METHOD_VIDEO_OUT, new_video_out);
+			ret = write_acpi_int(METHOD_VIDEO_OUT, new_video_out);
 	} else {
-		return -EFAULT;
+		ret = -EIO;
 	}
 
-	return count;
+	return ret ? ret : count;
 }
 
 static const struct file_operations video_proc_fops = {
@@ -671,11 +668,10 @@ static int fan_proc_show(struct seq_file *m, void *v)
 	if (hci_result == HCI_SUCCESS) {
 		seq_printf(m, "running:                 %d\n", (value > 0));
 		seq_printf(m, "force_on:                %d\n", dev->force_fan);
-	} else {
-		pr_err("Error reading fan status\n");
+		return 0;
 	}
 
-	return 0;
+	return -EIO;
 }
 
 static int fan_proc_open(struct inode *inode, struct file *file)
@@ -701,7 +697,7 @@ static ssize_t fan_proc_write(struct file *file, const char __user *buf,
 	    value >= 0 && value <= 1) {
 		hci_write1(dev, HCI_FAN, value, &hci_result);
 		if (hci_result != HCI_SUCCESS)
-			return -EFAULT;
+			return -EIO;
 		else
 			dev->force_fan = value;
 	} else {
@@ -741,13 +737,12 @@ static int keys_proc_show(struct seq_file *m, void *v)
 			pr_notice("Re-enabled hotkeys\n");
 		} else {
 			pr_err("Error reading hotkey status\n");
-			goto end;
+			return -EIO;
 		}
 	}
 
 	seq_printf(m, "hotkey_ready:            %d\n", dev->key_event_valid);
 	seq_printf(m, "hotkey:                  0x%04x\n", dev->last_key_event);
-end:
 	return 0;
 }
 
-- 
1.7.4.1

