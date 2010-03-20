Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab0CTQPU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 12:15:20 -0400
Received: from legolas.restena.lu ([158.64.1.34]:42981 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0CTQPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 12:15:11 -0400
Date: Sat, 20 Mar 2010 17:11:19 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>, Oliver Neukum <oliver@neukum.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
Subject: [PATCH v2 6/6] hid: add experimental access to PicoLCD device's
 EEPROM and FLASH
Message-ID: <20100320171119.193c5615@neptune.home>
In-Reply-To: <20100320170014.440959a8@neptune.home>
References: <20100320170014.440959a8@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PicoLCD device has a small amount of EEPROM and also provides
access to its FLASH where firmware and splash image are saved.
In flasher mode FLASH access is the only active feature.

Give read/write access to both via debugfs files.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/hid/Kconfig       |    2 +-
 drivers/hid/hid-picolcd.c |  428 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 412 insertions(+), 18 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 90caaf3..2eec702 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -246,9 +246,9 @@ config HID_PICOLCD
 	  - Backlight control         (needs CONFIG_BACKLIGHT_CLASS_DEVICE)
 	  - Contrast control          (needs CONFIG_LCD_CLASS_DEVICE)
 	  - General purpose outputs   (needs CONFIG_LEDS_CLASS)
+	  - EEProm / Flash access     (via debugfs)
 	  Features that are not (yet) supported:
 	  - IR
-	  - EEProm / Flash access
 
 config HID_SAMSUNG
 	tristate "Samsung" if EMBEDDED
diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index f3d057c..3b9c7f4 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -169,6 +169,9 @@ struct picolcd_pending {
 struct picolcd_data {
 	struct hid_device *hdev;
 #ifdef CONFIG_DEBUG_FS
+	struct dentry *debug_reset;
+	struct dentry *debug_eeprom;
+	struct dentry *debug_flash;
 	int addr_sz;
 #endif
 	u8 version[2];
@@ -1219,6 +1222,337 @@ static DEVICE_ATTR(operation_mode, 0644, picolcd_operation_mode_show,
 
 #ifdef CONFIG_DEBUG_FS
 /*
+ * The "reset" file
+ */
+static int picolcd_debug_reset_show(struct seq_file *f, void *p)
+{
+	if (picolcd_fbinfo((struct picolcd_data *)f->private))
+		seq_printf(f, "all fb\n");
+	else
+		seq_printf(f, "all\n");
+	return 0;
+}
+
+static ssize_t picolcd_debug_reset_open(struct inode *inode, struct file *f)
+{
+	return single_open(f, picolcd_debug_reset_show, inode->i_private);
+}
+
+static ssize_t picolcd_debug_reset_write(struct file *f, const char __user *user_buf,
+		size_t count, loff_t *ppos)
+{
+	struct picolcd_data *data = ((struct seq_file *)f->private_data)->private;
+	char buf[32];
+	size_t cnt = min(count, sizeof(buf)-1);
+	if (copy_from_user(buf, user_buf, cnt))
+		return -EFAULT;
+
+	while (cnt > 0 && (buf[cnt-1] == ' ' || buf[cnt-1] == '\n'))
+		cnt--;
+	buf[cnt] = '\0';
+	if (strcmp(buf, "all") == 0) {
+		picolcd_reset(data->hdev);
+		picolcd_fb_reset(data, 1);
+	} else if (strcmp(buf, "fb") == 0) {
+		picolcd_fb_reset(data, 1);
+	} else {
+		return -EINVAL;
+	}
+	return count;
+}
+
+static const struct file_operations picolcd_debug_reset_fops = {
+	.owner    = THIS_MODULE,
+	.open     = picolcd_debug_reset_open,
+	.read     = seq_read,
+	.llseek   = seq_lseek,
+	.write    = picolcd_debug_reset_write,
+	.release  = single_release,
+};
+
+/*
+ * The "eeprom" file
+ */
+static int picolcd_debug_eeprom_open(struct inode *i, struct file *f)
+{
+	f->private_data = i->i_private;
+	return 0;
+}
+
+static ssize_t picolcd_debug_eeprom_read(struct file *f, char __user *u,
+		size_t s, loff_t *off)
+{
+	struct picolcd_data *data = f->private_data;
+	struct picolcd_pending *resp;
+	u8 raw_data[3];
+	ssize_t ret = -EIO;
+
+	if (s == 0)
+		return -EINVAL;
+	if (*off > 0x0ff)
+		return 0;
+
+	/* prepare buffer with info about what we want to read (addr & len) */
+	raw_data[0] = *off & 0xff;
+	raw_data[1] = (*off >> 8) && 0xff;
+	raw_data[2] = s < 20 ? s : 20;
+	if (*off + raw_data[2] > 0xff)
+		raw_data[2] = 0x100 - *off;
+	resp = picolcd_send_and_wait(data->hdev, REPORT_EE_READ, raw_data,
+			sizeof(raw_data));
+	if (!resp)
+		return -EIO;
+
+	if (resp->in_report && resp->in_report->id == REPORT_EE_DATA) {
+		/* successful read :) */
+		ret = resp->raw_data[2];
+		if (ret > s)
+			ret = s;
+		if (copy_to_user(u, resp->raw_data+3, ret))
+			ret = -EFAULT;
+		else
+			*off += ret;
+	} /* anything else is some kind of IO error */
+
+	kfree(resp);
+	return ret;
+}
+
+static ssize_t picolcd_debug_eeprom_write(struct file *f, const char __user *u,
+		size_t s, loff_t *off)
+{
+	struct picolcd_data *data = f->private_data;
+	struct picolcd_pending *resp;
+	ssize_t ret = -EIO;
+	u8 raw_data[23];
+
+	if (s == 0)
+		return -EINVAL;
+	if (*off > 0x0ff)
+		return -ENOSPC;
+
+	memset(raw_data, 0, sizeof(raw_data));
+	raw_data[0] = *off & 0xff;
+	raw_data[1] = (*off >> 8) && 0xff;
+	raw_data[2] = s < 20 ? s : 20;
+	if (*off + raw_data[2] > 0xff)
+		raw_data[2] = 0x100 - *off;
+
+	if (copy_from_user(raw_data+3, u, raw_data[2]))
+		return -EFAULT;
+	resp = picolcd_send_and_wait(data->hdev, REPORT_EE_WRITE, raw_data,
+			sizeof(raw_data));
+
+	if (!resp)
+		return -EIO;
+
+	if (resp->in_report && resp->in_report->id == REPORT_EE_DATA) {
+		/* check if written data matches */
+		if (memcmp(raw_data, resp->raw_data, 3+raw_data[2]) == 0) {
+			*off += raw_data[2];
+			ret = raw_data[2];
+		}
+	}
+	kfree(resp);
+	return ret;
+}
+
+static const struct file_operations picolcd_debug_eeprom_fops = {
+	.owner    = THIS_MODULE,
+	.open     = picolcd_debug_eeprom_open,
+	.read     = picolcd_debug_eeprom_read,
+	.write    = picolcd_debug_eeprom_write,
+	.llseek   = generic_file_llseek,
+};
+
+/*
+ * The "flash" file
+ */
+static int picolcd_debug_flash_open(struct inode *i, struct file *f)
+{
+	f->private_data = i->i_private;
+	return 0;
+}
+
+/* record a flash address to buf (bounds check to be done by caller) */
+static int _picolcd_flash_setaddr(struct picolcd_data *data, u8 *buf, long off)
+{
+	buf[0] = off & 0xff;
+	buf[1] = (off >> 8) & 0xff;
+	if (data->addr_sz == 3)
+		buf[2] = (off >> 16) & 0xff;
+	return data->addr_sz == 2 ? 2 : 3;
+}
+
+/* read a given size of data (bounds check to be done by caller) */
+static ssize_t _picolcd_flash_read(struct picolcd_data *data, int report_id,
+		char __user *u, size_t s, loff_t *off)
+{
+	struct picolcd_pending *resp;
+	u8 raw_data[4];
+	ssize_t ret = 0;
+	int len_off, err = -EIO;
+
+	while (s > 0) {
+		err = -EIO;
+		len_off = _picolcd_flash_setaddr(data, raw_data, *off);
+		raw_data[len_off] = s > 32 ? 32 : s;
+		resp = picolcd_send_and_wait(data->hdev, report_id, raw_data, len_off+1);
+		if (!resp || !resp->in_report)
+			goto skip;
+		if (resp->in_report->id == REPORT_MEMORY ||
+			resp->in_report->id == REPORT_BL_READ_MEMORY) {
+			if (memcmp(raw_data, resp->raw_data, len_off+1) != 0)
+				goto skip;
+			if (copy_to_user(u+ret, resp->raw_data+len_off+1, raw_data[len_off])) {
+				err = -EFAULT;
+				goto skip;
+			}
+			*off += raw_data[len_off];
+			s    -= raw_data[len_off];
+			ret  += raw_data[len_off];
+			err   = 0;
+		}
+skip:
+		kfree(resp);
+		if (err)
+			return ret > 0 ? ret : err;
+	}
+	return ret;
+}
+
+static ssize_t picolcd_debug_flash_read(struct file *f, char __user *u,
+		size_t s, loff_t *off)
+{
+	struct picolcd_data *data = f->private_data;
+
+	if (s == 0)
+		return -EINVAL;
+	if (*off > 0x05fff)
+		return 0;
+	if (*off + s > 0x05fff)
+		s = 0x06000 - *off;
+
+	if (data->status & PICOLCD_BOOTLOADER)
+		return _picolcd_flash_read(data, REPORT_BL_READ_MEMORY, u, s, off);
+	else
+		return _picolcd_flash_read(data, REPORT_READ_MEMORY, u, s, off);
+}
+
+/* erase block aligned to 64bytes boundary */
+static ssize_t _picolcd_flash_erase64(struct picolcd_data *data, int report_id,
+		loff_t *off)
+{
+	struct picolcd_pending *resp;
+	u8 raw_data[3];
+	int len_off;
+	ssize_t ret = -EIO;
+
+	if (*off & 0x3f)
+		return -EINVAL;
+
+	len_off = _picolcd_flash_setaddr(data, raw_data, *off);
+	resp = picolcd_send_and_wait(data->hdev, report_id, raw_data, len_off);
+	if (!resp || !resp->in_report)
+		goto skip;
+	if (resp->in_report->id == REPORT_MEMORY ||
+		resp->in_report->id == REPORT_BL_ERASE_MEMORY) {
+		if (memcmp(raw_data, resp->raw_data, len_off) != 0)
+			goto skip;
+		ret = 0;
+	}
+skip:
+	kfree(resp);
+	return ret;
+}
+
+/* write a given size of data (bounds check to be done by caller) */
+static ssize_t _picolcd_flash_write(struct picolcd_data *data, int report_id,
+		const char __user *u, size_t s, loff_t *off)
+{
+	struct picolcd_pending *resp;
+	u8 raw_data[36];
+	ssize_t ret = 0;
+	int len_off, err = -EIO;
+
+	while (s > 0) {
+		err = -EIO;
+		len_off = _picolcd_flash_setaddr(data, raw_data, *off);
+		raw_data[len_off] = s > 32 ? 32 : s;
+		if (copy_from_user(raw_data+len_off+1, u, raw_data[len_off])) {
+			err = -EFAULT;
+			goto skip;
+		}
+		resp = picolcd_send_and_wait(data->hdev, report_id, raw_data,
+				len_off+1+raw_data[len_off]);
+		if (!resp || !resp->in_report)
+			goto skip;
+		if (resp->in_report->id == REPORT_MEMORY ||
+			resp->in_report->id == REPORT_BL_WRITE_MEMORY) {
+			if (memcmp(raw_data, resp->raw_data, len_off+1+raw_data[len_off]) != 0)
+				goto skip;
+			*off += raw_data[len_off];
+			s    -= raw_data[len_off];
+			ret  += raw_data[len_off];
+			err   = 0;
+		}
+skip:
+		kfree(resp);
+		if (err)
+			break;
+	}
+	return ret > 0 ? ret : err;
+}
+
+static ssize_t picolcd_debug_flash_write(struct file *f, const char __user *u,
+		size_t s, loff_t *off)
+{
+	struct picolcd_data *data = f->private_data;
+	ssize_t err, ret = 0;
+	int report_erase, report_write;
+
+	if (s == 0)
+		return -EINVAL;
+	if (*off > 0x5fff)
+		return -ENOSPC;
+	if (s & 0x3f)
+		return -EINVAL;
+	if (*off & 0x3f)
+		return -EINVAL;
+
+	if (data->status & PICOLCD_BOOTLOADER) {
+		report_erase = REPORT_BL_ERASE_MEMORY;
+		report_write = REPORT_BL_WRITE_MEMORY;
+	} else {
+		report_erase = REPORT_ERASE_MEMORY;
+		report_write = REPORT_WRITE_MEMORY;
+	}
+	while (s > 0) {
+		err = _picolcd_flash_erase64(data, report_erase, off);
+		if (err)
+			break;
+		err = _picolcd_flash_write(data, report_write, u, 64, off);
+		if (err < 0)
+			break;
+		ret += err;
+		*off += err;
+		s -= err;
+		if (err != 64)
+			break;
+	}
+	return ret > 0 ? ret : err;
+}
+
+static const struct file_operations picolcd_debug_flash_fops = {
+	.owner    = THIS_MODULE,
+	.open     = picolcd_debug_flash_open,
+	.read     = picolcd_debug_flash_read,
+	.write    = picolcd_debug_flash_write,
+	.llseek   = generic_file_llseek,
+};
+
+
+/*
  * Helper code for HID report level dumping/debugging
  */
 static const char *error_codes[] = {
@@ -1689,9 +2023,76 @@ static inline void picolcd_debug_raw_event(struct picolcd_data *data,
 	wake_up_interruptible(&hdev->debug_wait);
 	kfree(buff);
 }
+
+static inline int picolcd_init_devfs(struct picolcd_data *data,
+		struct hid_report *eeprom_r, struct hid_report *eeprom_w,
+		struct hid_report *flash_r, struct hid_report *flash_w,
+		struct hid_report *reset)
+{
+	struct hid_device *hdev = data->hdev;
+
+	/* reset */
+	if (reset)
+		data->debug_reset = debugfs_create_file("reset", 0600,
+				hdev->debug_dir, data, &picolcd_debug_reset_fops);
+
+	/* eeprom */
+	if (eeprom_r || eeprom_w)
+		data->debug_eeprom = debugfs_create_file("eeprom",
+			(eeprom_w ? S_IWUSR : 0) | (eeprom_r ? S_IRUSR : 0),
+			hdev->debug_dir, data, &picolcd_debug_eeprom_fops);
+	if (eeprom_r && (eeprom_r->maxfield != 1 ||
+			eeprom_r->field[0]->report_count != 3 ||
+			eeprom_r->field[0]->report_size != 8))
+		dev_warn(&hdev->dev, "Unsupported EEPROM data report (%d, %d, %d)\n",
+				eeprom_r->maxfield, eeprom_r->field[0]->report_count,
+				eeprom_r->field[0]->report_size);
+
+	/* flash */
+	if (flash_r && flash_r->maxfield == 1 && flash_r->field[0]->report_size == 8)
+		data->addr_sz = flash_r->field[0]->report_count - 1;
+	else
+		data->addr_sz = -1;
+	if (data->addr_sz == 2 || data->addr_sz == 3)
+		data->debug_flash = debugfs_create_file("flash", 
+			(flash_w ? S_IWUSR : 0) | (flash_r ? S_IRUSR : 0),
+			hdev->debug_dir, data, &picolcd_debug_flash_fops);
+	else if (flash_r || flash_w)
+		dev_warn(&hdev->dev, "Unexpected FLASH access reports, "
+				"please submit rdesc for review\n");
+	return 0;
+}
+
+static void picolcd_exit_devfs(struct picolcd_data *data)
+{
+	struct dentry *dent;
+
+	dent = data->debug_reset;
+	data->debug_reset = NULL;
+	if (dent)
+		debugfs_remove(dent);
+	dent = data->debug_eeprom;
+	data->debug_eeprom = NULL;
+	if (dent)
+		debugfs_remove(dent);
+	dent = data->debug_flash;
+	data->debug_flash = NULL;
+	if (dent)
+		debugfs_remove(dent);
+}
 #else
 #define picolcd_debug_raw_event(data, hdev, report, raw_data, size)
-#endif
+static inline int picolcd_init_devfs(struct picolcd_data *data,
+	struct hid_report *eeprom_r, struct hid_report *eeprom_w,
+	struct hid_report *flash_r, struct hid_report *flash_w,
+	struct hid_report *reset)
+{
+	return 0;
+}
+static void picolcd_exit_devfs(struct picolcd_data *data)
+{
+}
+#endif /* CONFIG_DEBUG_FS */
 
 /*
  * Handle raw report as sent by device
@@ -1842,7 +2243,6 @@ static void picolcd_exit_cir(struct picolcd_data *data)
 static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data *data)
 {
 	struct picolcd_pending *verinfo;
-	struct hid_report *report;
 	int error;
 
 	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
@@ -1900,13 +2300,11 @@ static inline int picolcd_probe_lcd(struct hid_device *hdev, struct picolcd_data
 	if (error)
 		goto err;
 
-#ifdef CONFIG_DEBUG_FS
-	report = picolcd_out_report(REPORT_READ_MEMORY, hdev);
-	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
-		data->addr_sz = report->field[0]->report_count - 1;
-	else
-		data->addr_sz = -1;
-#endif
+	picolcd_init_devfs(data, picolcd_out_report(REPORT_EE_READ, hdev),
+			picolcd_out_report(REPORT_EE_WRITE, hdev),
+			picolcd_out_report(REPORT_READ_MEMORY, hdev),
+			picolcd_out_report(REPORT_WRITE_MEMORY, hdev),
+			picolcd_out_report(REPORT_RESET, hdev));
 	return 0;
 err:
 	picolcd_exit_leds(data);
@@ -1921,7 +2319,6 @@ err:
 static inline int picolcd_probe_bootloader(struct hid_device *hdev, struct picolcd_data *data)
 {
 	struct picolcd_pending *verinfo;
-	struct hid_report *report;
 
 	verinfo = picolcd_send_and_wait(hdev, REPORT_VERSION, NULL, 0);
 	if (!verinfo || !verinfo->in_report) {
@@ -1948,13 +2345,9 @@ static inline int picolcd_probe_bootloader(struct hid_device *hdev, struct picol
 		return -ENODEV;
 	}
 
-#ifdef CONFIG_DEBUG_FS
-	report = picolcd_out_report(REPORT_BL_READ_MEMORY, hdev);
-	if (report && report->maxfield == 1 && report->field[0]->report_size == 8)
-		data->addr_sz = report->field[0]->report_count - 1;
-	else
-		data->addr_sz = -1;
-#endif
+	picolcd_init_devfs(data, NULL, NULL,
+			picolcd_out_report(REPORT_BL_READ_MEMORY, hdev),
+			picolcd_out_report(REPORT_BL_WRITE_MEMORY, hdev), NULL);
 	return 0;
 }
 
@@ -2047,6 +2440,7 @@ static void picolcd_remove(struct hid_device *hdev)
 	data->status |= PICOLCD_FAILED;
 	spin_unlock_irqrestore(&data->lock, flags);
 
+	picolcd_exit_devfs(data);
 	sysfs_remove_file(&(hdev->dev.kobj), &dev_attr_operation_mode.attr);
 	hdev->ll_driver->close(hdev);
 	hid_hw_stop(hdev);
-- 
1.6.4.4

