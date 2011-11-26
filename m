Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1KZKA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:00:57 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:42672 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1KZKAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:00:52 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/16] samsung-laptop: add a small debugfs interface
Date: Sat, 26 Nov 2011 11:00:03 +0100
Message-Id: <1322301613-8801-7-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allow to call arbitrary sabi commands wihout
modifying the driver at all. For example, setting
the keyboard backlight brightness to 5 using debugfs
interface can be done like that:

 ; Set the command
 echo 0x78 > command
 ; Set the data
 echo 0x0582 > d0
 ; Fill the rest with 0
 echo 0 > d1
 echo 0 > d2
 echo 0 > d3
 ; And issue the command
 cat call

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/samsung-laptop.c |  147 +++++++++++++++++++++++++++++++++
 1 files changed, 147 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index cd638c4..6cbf2ed 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -22,6 +22,8 @@
 #include <linux/platform_device.h>
 #include <linux/rfkill.h>
 #include <linux/acpi.h>
+#include <linux/seq_file.h>
+#include <linux/debugfs.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
@@ -226,6 +228,35 @@ static const struct sabi_config sabi_configs[] = {
 	{ },
 };
 
+/*
+ * samsung-laptop/    - debugfs root directory
+ *   f0000_segment    - dump f0000 segment
+ *   command          - current command
+ *   data             - current data
+ *   d0, d1, d2, d3   - data fields
+ *   call             - call SABI using command and data
+ *
+ * This allow to call arbitrary sabi commands wihout
+ * modifying the driver at all.
+ * For example, setting the keyboard backlight brightness to 5
+ *
+ *  echo 0x78 > command
+ *  echo 0x0582 > d0
+ *  echo 0 > d1
+ *  echo 0 > d2
+ *  echo 0 > d3
+ *  cat call
+ */
+
+struct samsung_laptop_debug {
+	struct dentry *root;
+	struct sabi_data data;
+	u16 command;
+
+	struct debugfs_blob_wrapper f0000_wrapper;
+	struct debugfs_blob_wrapper data_wrapper;
+};
+
 struct samsung_laptop {
 	const struct sabi_config *config;
 
@@ -239,6 +270,8 @@ struct samsung_laptop {
 	struct backlight_device *backlight_device;
 	struct rfkill *rfk;
 
+	struct samsung_laptop_debug debug;
+
 	bool handle_backlight;
 	bool has_stepping_quirk;
 };
@@ -680,6 +713,113 @@ static int __init samsung_sysfs_init(struct samsung_laptop *samsung)
 
 }
 
+static int show_call(struct seq_file *m, void *data)
+{
+	struct samsung_laptop *samsung = m->private;
+	struct sabi_data *sdata = &samsung->debug.data;
+	int ret;
+
+	seq_printf(m, "SABI 0x%04x {0x%08x, 0x%08x, 0x%04x, 0x%02x}\n",
+		   samsung->debug.command,
+		   sdata->d0, sdata->d1, sdata->d2, sdata->d3);
+
+	ret = sabi_command(samsung, samsung->debug.command, sdata, sdata);
+
+	if (ret) {
+		seq_printf(m, "SABI command 0x%04x failed\n",
+			   samsung->debug.command);
+		return ret;
+	}
+
+	seq_printf(m, "SABI {0x%08x, 0x%08x, 0x%04x, 0x%02x}\n",
+		   sdata->d0, sdata->d1, sdata->d2, sdata->d3);
+	return 0;
+}
+
+static int samsung_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_call, inode->i_private);
+}
+
+static const struct file_operations samsung_laptop_call_io_ops = {
+	.owner = THIS_MODULE,
+	.open = samsung_debugfs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void samsung_debugfs_exit(struct samsung_laptop *samsung)
+{
+	debugfs_remove_recursive(samsung->debug.root);
+}
+
+static int samsung_debugfs_init(struct samsung_laptop *samsung)
+{
+	struct dentry *dent;
+
+	samsung->debug.root = debugfs_create_dir("samsung-laptop", NULL);
+	if (!samsung->debug.root) {
+		pr_err("failed to create debugfs directory");
+		goto error_debugfs;
+	}
+
+	samsung->debug.f0000_wrapper.data = samsung->f0000_segment;
+	samsung->debug.f0000_wrapper.size = 0xffff;
+
+	samsung->debug.data_wrapper.data = &samsung->debug.data;
+	samsung->debug.data_wrapper.size = sizeof(samsung->debug.data);
+
+	dent = debugfs_create_u16("command", S_IRUGO | S_IWUSR,
+				  samsung->debug.root, &samsung->debug.command);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_u32("d0", S_IRUGO | S_IWUSR, samsung->debug.root,
+				  &samsung->debug.data.d0);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_u32("d1", S_IRUGO | S_IWUSR, samsung->debug.root,
+				  &samsung->debug.data.d1);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_u16("d2", S_IRUGO | S_IWUSR, samsung->debug.root,
+				  &samsung->debug.data.d2);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_u8("d3", S_IRUGO | S_IWUSR, samsung->debug.root,
+				 &samsung->debug.data.d3);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_blob("data", S_IRUGO | S_IWUSR,
+				   samsung->debug.root,
+				   &samsung->debug.data_wrapper);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_blob("f0000_segment", S_IRUSR | S_IWUSR,
+				   samsung->debug.root,
+				   &samsung->debug.f0000_wrapper);
+	if (!dent)
+		goto error_debugfs;
+
+	dent = debugfs_create_file("call", S_IFREG | S_IRUGO,
+				   samsung->debug.root, samsung,
+				   &samsung_laptop_call_io_ops);
+	if (!dent)
+		goto error_debugfs;
+
+	return 0;
+
+error_debugfs:
+	samsung_debugfs_exit(samsung);
+	return -ENOMEM;
+}
+
 static void samsung_sabi_exit(struct samsung_laptop *samsung)
 {
 	const struct sabi_config *config = samsung->config;
@@ -1123,9 +1263,15 @@ static int __init samsung_init(void)
 	if (ret)
 		goto error_rfkill;
 
+	ret = samsung_debugfs_init(samsung);
+	if (ret)
+		goto error_debugfs;
+
 	samsung_platform_device = samsung->platform_device;
 	return ret;
 
+error_debugfs:
+	samsung_rfkill_exit(samsung);
 error_rfkill:
 	samsung_backlight_exit(samsung);
 error_backlight:
@@ -1145,6 +1291,7 @@ static void __exit samsung_exit(void)
 
 	samsung = platform_get_drvdata(samsung_platform_device);
 
+	samsung_debugfs_exit(samsung);
 	samsung_rfkill_exit(samsung);
 	samsung_backlight_exit(samsung);
 	samsung_sysfs_exit(samsung);
-- 
1.7.5.4

