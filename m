Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532Ab1ISIuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 04:50:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60546 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab1ISIuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 04:50:10 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 4/5] ideapad: add debugfs support
Date: Mon, 19 Sep 2011 16:50:05 +0800
Message-Id: <1316422205-13908-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315247572-9131-1-git-send-email-ike.pan@canonical.com>
References: <1315247572-9131-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add two nodes in debugfs which shows cfg value and its meaning,
and status info read from VPC2004.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 Documentation/ABI/testing/debugfs-ideapad |   19 ++++
 drivers/platform/x86/ideapad-laptop.c     |  149 +++++++++++++++++++++++++++++
 2 files changed, 168 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-ideapad

diff --git a/Documentation/ABI/testing/debugfs-ideapad b/Documentation/ABI/testing/debugfs-ideapad
new file mode 100644
index 0000000..7079c0b
--- /dev/null
+++ b/Documentation/ABI/testing/debugfs-ideapad
@@ -0,0 +1,19 @@
+What:		/sys/kernel/debug/ideapad/cfg
+Date:		Sep 2011
+KernelVersion:	3.2
+Contact:	Ike Panhc <ike.pan@canonical.com>
+Description:
+
+cfg shows the return value of _CFG method in VPC2004 device. It tells machine
+capability and what graphic component within the machine.
+
+
+What:		/sys/kernel/debug/ideapad/status
+Date:		Sep 2011
+KernelVersion:	3.2
+Contact:	Ike Panhc <ike.pan@canonical.com>
+Description:
+
+status shows infos we can read and tells its meaning and value.
+
+
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 39a72a8..1a18cc2 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -34,6 +34,8 @@
 #include <linux/input/sparse-keymap.h>
 #include <linux/backlight.h>
 #include <linux/fb.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
@@ -71,6 +73,7 @@ struct ideapad_private {
 	struct platform_device *platform_device;
 	struct input_dev *inputdev;
 	struct backlight_device *blightdev;
+	struct dentry *debug;
 	unsigned long cfg;
 };
 
@@ -188,6 +191,149 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 }
 
 /*
+ * debugfs
+ */
+static int debugfs_status_show(struct seq_file *s, void *data)
+{
+	unsigned long value;
+
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_BL_MAX, &value))
+		seq_printf(s, "Backlight max:\t%lu\n", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_BL, &value))
+		seq_printf(s, "Backlight now:\t%lu\n", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_BL_POWER, &value))
+		seq_printf(s, "BL power value:\t%s\n", value ? "On" : "Off");
+	seq_printf(s, "=====================\n");
+
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_RF, &value))
+		seq_printf(s, "Radio status:\t%s(%lu)\n",
+			   value ? "On" : "Off", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_WIFI, &value))
+		seq_printf(s, "Wifi status:\t%s(%lu)\n",
+			   value ? "On" : "Off", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_BT, &value))
+		seq_printf(s, "BT status:\t%s(%lu)\n",
+			   value ? "On" : "Off", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_3G, &value))
+		seq_printf(s, "3G status:\t%s(%lu)\n",
+			   value ? "On" : "Off", value);
+	seq_printf(s, "=====================\n");
+
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_TOUCHPAD, &value))
+		seq_printf(s, "Touchpad status:%s(%lu)\n",
+			   value ? "On" : "Off", value);
+	if (!read_ec_data(ideapad_handle, VPCCMD_R_CAMERA, &value))
+		seq_printf(s, "Camera status:\t%s(%lu)\n",
+			   value ? "On" : "Off", value);
+
+	return 0;
+}
+
+static int debugfs_status_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, debugfs_status_show, NULL);
+}
+
+static const struct file_operations debugfs_status_fops = {
+	.owner = THIS_MODULE,
+	.open = debugfs_status_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int debugfs_cfg_show(struct seq_file *s, void *data)
+{
+	struct ideapad_private *priv = s->private;
+
+	seq_printf(s, "cfg: 0x%.8lX\n\nCapability: ", priv->cfg);
+	if (test_bit(CFG_BT_BIT, &priv->cfg))
+		seq_printf(s, "Bluetooth ");
+	if (test_bit(CFG_3G_BIT, &priv->cfg))
+		seq_printf(s, "3G ");
+	if (test_bit(CFG_WIFI_BIT, &priv->cfg))
+		seq_printf(s, "Wireless ");
+	if (test_bit(CFG_CAMERA_BIT, &priv->cfg))
+		seq_printf(s, "Camera ");
+	seq_printf(s, "\nGraphic: ");
+	switch ((priv->cfg)&0x700) {
+	case 0x100:
+		seq_printf(s, "Intel");
+		break;
+	case 0x200:
+		seq_printf(s, "ATI");
+		break;
+	case 0x300:
+		seq_printf(s, "Nvidia");
+		break;
+	case 0x400:
+		seq_printf(s, "Intel and ATI");
+		break;
+	case 0x500:
+		seq_printf(s, "Intel and Nvidia");
+		break;
+	default:
+		seq_printf(s, "Unknown");
+	}
+	seq_printf(s, "\n");
+
+	return 0;
+}
+
+static int debugfs_cfg_open(struct inode *inode, struct file *file)
+{
+	struct ideapad_private *priv = inode->i_private;
+
+	return single_open(file, debugfs_cfg_show, priv);
+}
+
+static const struct file_operations debugfs_cfg_fops = {
+	.owner = THIS_MODULE,
+	.open = debugfs_cfg_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void ideapad_debugfs_exit(struct ideapad_private *priv)
+{
+	debugfs_remove_recursive(priv->debug);
+	priv->debug = NULL;
+}
+
+static void __devinit ideapad_debugfs_init(struct ideapad_private *priv)
+{
+	struct dentry *node;
+
+	priv->debug = debugfs_create_dir("ideapad", NULL);
+	if (IS_ERR_OR_NULL(priv->debug)) {
+		priv->debug = NULL;
+		pr_err("failed to create debugfs directory");
+		return;
+	}
+
+	node = debugfs_create_file("cfg", S_IRUGO, priv->debug, priv,
+				   &debugfs_cfg_fops);
+	if (IS_ERR_OR_NULL(priv->debug)) {
+		pr_err("failed to create cfg in debugfs");
+		goto errout;
+	}
+
+	node = debugfs_create_file("status", S_IRUGO, priv->debug, NULL,
+				   &debugfs_status_fops);
+	if (IS_ERR_OR_NULL(priv->debug)) {
+		pr_err("failed to create event in debugfs");
+		goto errout;
+	}
+
+	return;
+
+errout:
+	ideapad_debugfs_exit(priv);
+	return;
+}
+
+/*
  * sysfs
  */
 static ssize_t show_ideapad_cam(struct device *dev,
@@ -598,6 +744,8 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 			goto backlight_failed;
 	}
 
+	ideapad_debugfs_init(priv);
+
 	return 0;
 
 backlight_failed:
@@ -620,6 +768,7 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		ideapad_unregister_rfkill(adevice, i);
 	ideapad_input_exit(priv);
+	ideapad_debugfs_exit(priv);
 	ideapad_platform_exit(priv);
 	dev_set_drvdata(&adevice->dev, NULL);
 	kfree(priv);
-- 
1.7.5.4

