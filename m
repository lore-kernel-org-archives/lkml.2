Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965238Ab0GPLMp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 07:12:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965124Ab0GPLLm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 07:11:42 -0400
From: Thomas Renninger <trenn@suse.de>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
        Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: [PATCH 4/7] ACPI: Remove /proc/acpi/embedded_controller/..
Date: Fri, 16 Jul 2010 13:11:34 +0200
Message-Id: <1279278697-3694-5-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1279278697-3694-1-git-send-email-trenn@suse.de>
References: <1279278697-3694-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other patches in this series add the same info to /sys/... and
/proc/ioports.

The info removed should never have been used in an application,
eventually someone read it manually.
/proc/acpi is deprecated for more than a year anyway...

Signed-off-by: Thomas Renninger <trenn@suse.de>

CC: Alexey Starikovskiy <astarikovskiy@suse.de>
CC: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
CC: linux-acpi@vger.kernel.org
CC: platform-driver-x86@vger.kernel.org
---
 drivers/acpi/ec.c |   81 +----------------------------------------------------
 1 files changed, 1 insertions(+), 80 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index f95fa9f..13d3011 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -34,8 +34,6 @@
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/delay.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
 #include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -664,72 +662,6 @@ acpi_ec_space_handler(u32 function, acpi_physical_address address,
 }
 
 /* --------------------------------------------------------------------------
-                              FS Interface (/proc)
-   -------------------------------------------------------------------------- */
-
-static struct proc_dir_entry *acpi_ec_dir;
-
-static int acpi_ec_read_info(struct seq_file *seq, void *offset)
-{
-	struct acpi_ec *ec = seq->private;
-
-	if (!ec)
-		goto end;
-
-	seq_printf(seq, "gpe:\t\t\t0x%02x\n", (u32) ec->gpe);
-	seq_printf(seq, "ports:\t\t\t0x%02x, 0x%02x\n",
-		   (unsigned)ec->command_addr, (unsigned)ec->data_addr);
-	seq_printf(seq, "use global lock:\t%s\n",
-		   ec->global_lock ? "yes" : "no");
-      end:
-	return 0;
-}
-
-static int acpi_ec_info_open_fs(struct inode *inode, struct file *file)
-{
-	return single_open(file, acpi_ec_read_info, PDE(inode)->data);
-}
-
-static const struct file_operations acpi_ec_info_ops = {
-	.open = acpi_ec_info_open_fs,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static int acpi_ec_add_fs(struct acpi_device *device)
-{
-	struct proc_dir_entry *entry = NULL;
-
-	if (!acpi_device_dir(device)) {
-		acpi_device_dir(device) = proc_mkdir(acpi_device_bid(device),
-						     acpi_ec_dir);
-		if (!acpi_device_dir(device))
-			return -ENODEV;
-	}
-
-	entry = proc_create_data(ACPI_EC_FILE_INFO, S_IRUGO,
-				 acpi_device_dir(device),
-				 &acpi_ec_info_ops, acpi_driver_data(device));
-	if (!entry)
-		return -ENODEV;
-	return 0;
-}
-
-static int acpi_ec_remove_fs(struct acpi_device *device)
-{
-
-	if (acpi_device_dir(device)) {
-		remove_proc_entry(ACPI_EC_FILE_INFO, acpi_device_dir(device));
-		remove_proc_entry(acpi_device_bid(device), acpi_ec_dir);
-		acpi_device_dir(device) = NULL;
-	}
-
-	return 0;
-}
-
-/* --------------------------------------------------------------------------
                                Driver Interface
    -------------------------------------------------------------------------- */
 static acpi_status
@@ -879,7 +811,6 @@ static int acpi_ec_add(struct acpi_device *device)
 	if (!first_ec)
 		first_ec = ec;
 	device->driver_data = ec;
-	acpi_ec_add_fs(device);
 	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
 
@@ -906,7 +837,6 @@ static int acpi_ec_remove(struct acpi_device *device, int type)
 		kfree(handler);
 	}
 	mutex_unlock(&ec->lock);
-	acpi_ec_remove_fs(device);
 	device->driver_data = NULL;
 	if (ec == first_ec)
 		first_ec = NULL;
@@ -1095,16 +1025,10 @@ int __init acpi_ec_init(void)
 {
 	int result = 0;
 
-	acpi_ec_dir = proc_mkdir(ACPI_EC_CLASS, acpi_root_dir);
-	if (!acpi_ec_dir)
-		return -ENODEV;
-
 	/* Now register the driver for the EC */
 	result = acpi_bus_register_driver(&acpi_ec_driver);
-	if (result < 0) {
-		remove_proc_entry(ACPI_EC_CLASS, acpi_root_dir);
+	if (result < 0)
 		return -ENODEV;
-	}
 
 	return result;
 }
@@ -1115,9 +1039,6 @@ static void __exit acpi_ec_exit(void)
 {
 
 	acpi_bus_unregister_driver(&acpi_ec_driver);
-
-	remove_proc_entry(ACPI_EC_CLASS, acpi_root_dir);
-
 	return;
 }
 #endif	/* 0 */
-- 
1.6.3

