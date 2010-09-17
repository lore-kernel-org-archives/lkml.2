Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab0IQFsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:48:20 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60179 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0IQFsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:48:19 -0400
From: Keng-Yu Lin <keng-yu.lin@canonical.com>
To: mjg59@srcf.ucam.org, len.brown@intel.com, alan-jenkins@tuffmail.co.uk,
        superm1@ubuntu.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Keng-Yu Lin <keng-yu.lin@canonical.com>
Subject: [PATCH v3] dell-laptop: Add debugfs support
Date: Fri, 17 Sep 2010 13:47:39 +0800
Message-Id: <1284702459-31646-1-git-send-email-keng-yu.lin@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <alpine.LFD.2.00.1009161239140.2727@localhost.localdomain>
References: <alpine.LFD.2.00.1009161239140.2727@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the status of RF killswitch through debugfs.

The killswitch status is obtained by the SMI to BIOS. Exporting this status
through debugfs can help identify the issue with the misbehaving firmware.

Signed-off-by: Keng-Yu Lin <keng-yu.lin@canonical.com>
---
 drivers/platform/x86/dell-laptop.c |   77 ++++++++++++++++++++++++++++++++++++
 1 files changed, 77 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c b/drivers/platform/x86/dell-laptop.c
index 4413975..bf5fbae 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -25,6 +25,8 @@
 #include <linux/mm.h>
 #include <linux/i8042.h>
 #include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 #include "../../firmware/dcdbas.h"
 
 #define BRIGHTNESS_TOKEN 0x7d
@@ -325,6 +327,75 @@ static const struct rfkill_ops dell_rfkill_ops = {
 	.query = dell_rfkill_query,
 };
 
+static struct dentry *dell_laptop_dir;
+
+static int dell_debugfs_show(struct seq_file *s, void *data)
+{
+	int status;
+
+	get_buffer();
+	dell_send_request(buffer, 17, 11);
+	status = buffer->output[1];
+	release_buffer();
+
+	seq_printf(s, "status:\t0x%X\n", status);
+	seq_printf(s, "Hardware switch supported:   %lu\n",
+		   status & BIT(0));
+	seq_printf(s, "Wifi locator supported:      %lu\n",
+		  (status & BIT(1)) >> 1);
+	seq_printf(s, "Wifi is supported:           %lu\n",
+		  (status & BIT(2)) >> 2);
+	seq_printf(s, "Bluetooth is supported:      %lu\n",
+		  (status & BIT(3)) >> 3);
+	seq_printf(s, "WWAN is supported:           %lu\n",
+		  (status & BIT(4)) >> 4);
+	seq_printf(s, "Wireless keyboard supported: %lu\n",
+		  (status & BIT(5)) >> 5);
+	seq_printf(s, "Wifi is installed:           %lu\n",
+		  (status & BIT(8)) >> 8);
+	seq_printf(s, "Bluetooth is installed:      %lu\n",
+		  (status & BIT(9)) >> 9);
+	seq_printf(s, "WWAN is installed:           %lu\n",
+		  (status & BIT(10)) >> 10);
+	seq_printf(s, "Hardware switch is on:       %lu\n",
+		  (status & BIT(16)) >> 16);
+	seq_printf(s, "Wifi is blocked:             %lu\n",
+		  (status & BIT(17)) >> 17);
+	seq_printf(s, "Bluetooth is blocked:        %lu\n",
+		  (status & BIT(18)) >> 18);
+	seq_printf(s, "WWAN is blocked:             %lu\n",
+		  (status & BIT(19)) >> 19);
+
+	seq_printf(s, "\nhwswitch_state:\t0x%X\n", hwswitch_state);
+	seq_printf(s, "Wifi controlled by switch:      %lu\n",
+		   hwswitch_state & BIT(0));
+	seq_printf(s, "Bluetooth controlled by switch: %lu\n",
+		   hwswitch_state & BIT(0) >> 1);
+	seq_printf(s, "WWAN controlled by switch:      %lu\n",
+		   hwswitch_state & BIT(0) >> 2);
+	seq_printf(s, "Wireless switch config locked:  %lu\n",
+		   hwswitch_state & BIT(0) >> 7);
+	seq_printf(s, "Wifi locator enabled:           %lu\n",
+		   hwswitch_state & BIT(0) >> 8);
+	seq_printf(s, "Wifi locator setting locked:    %lu\n",
+		   hwswitch_state & BIT(0) >> 15);
+
+	return 0;
+}
+
+static int dell_debugfs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dell_debugfs_show, inode->i_private);
+}
+
+static const struct file_operations dell_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = dell_debugfs_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
 static void dell_update_rfkill(struct work_struct *ignored)
 {
 	if (wifi_rfkill)
@@ -556,6 +627,11 @@ static int __init dell_init(void)
 		goto fail_filter;
 	}
 
+	dell_laptop_dir = debugfs_create_dir("dell_laptop", NULL);
+	if (dell_laptop_dir != NULL)
+		debugfs_create_file("rfkill", 0444, dell_laptop_dir, NULL,
+				    &dell_debugfs_fops);
+
 #ifdef CONFIG_ACPI
 	/* In the event of an ACPI backlight being available, don't
 	 * register the platform controller.
@@ -615,6 +691,7 @@ fail_platform_driver:
 
 static void __exit dell_exit(void)
 {
+	debugfs_remove_recursive(dell_laptop_dir);
 	i8042_remove_filter(dell_laptop_i8042_filter);
 	cancel_delayed_work_sync(&dell_rfkill_work);
 	backlight_device_unregister(dell_backlight_device);
-- 
1.7.1

