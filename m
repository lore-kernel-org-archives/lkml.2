Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab2FDToL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:44:11 -0400
Received: from masquerade.micron.com ([137.201.242.130]:38803 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2FDToH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:44:07 -0400
Message-ID: <4FCD1002.2060203@micron.com>
Date: Mon, 4 Jun 2012 12:44:02 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 2/2] mtip32xx: Create debugfs entries for troubleshooting
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18948.001
X-TM-AS-Result: No--10.503200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On module load, creates a debugfs parent 'rssd' in debugfs root. Then for each
device, create a new node with corresponding disk name. Under the new node, two
entries 'registers' and 'flags' are created.

NOTE: These entries were removed from sysfs in the previous patch

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |  162 ++++++++++++++++++++++++++++++++++++-
 drivers/block/mtip32xx/mtip32xx.h |    4 +
 2 files changed, 165 insertions(+), 1 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index b6e95b9..a8fddeb 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -37,6 +37,7 @@
 #include <linux/kthread.h>
 #include <../drivers/ata/ahci.h>
 #include <linux/export.h>
+#include <linux/debugfs.h>
 #include "mtip32xx.h"
 
 #define HW_CMD_SLOT_SZ		(MTIP_MAX_COMMAND_SLOTS * 32)
@@ -85,6 +86,7 @@ static int instance;
  * allocated in mtip_init().
  */
 static int mtip_major;
+static struct dentry *dfs_parent;
 
 static DEFINE_SPINLOCK(rssd_index_lock);
 static DEFINE_IDA(rssd_index_ida);
@@ -2574,6 +2576,120 @@ static ssize_t mtip_hw_show_status(struct device *dev,
 
 static DEVICE_ATTR(status, S_IRUGO, mtip_hw_show_status, NULL);
 
+static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
+				  size_t len, loff_t *offset)
+{
+	struct driver_data *dd =  (struct driver_data *)f->private_data;
+	char buf[MTIP_DFS_MAX_BUF_SIZE];
+	u32 group_allocated;
+	int size = *offset;
+	int n;
+
+	if (!len || size)
+		return 0;
+
+	if (size < 0)
+		return -EINVAL;
+
+	size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
+
+	for (n = dd->slot_groups-1; n >= 0; n--)
+		size += sprintf(&buf[size], "%08X ",
+					 readl(dd->port->s_active[n]));
+
+	size += sprintf(&buf[size], "]\n");
+	size += sprintf(&buf[size], "H/ Command Issue : [ 0x");
+
+	for (n = dd->slot_groups-1; n >= 0; n--)
+		size += sprintf(&buf[size], "%08X ",
+					readl(dd->port->cmd_issue[n]));
+
+	size += sprintf(&buf[size], "]\n");
+	size += sprintf(&buf[size], "H/ Completed     : [ 0x");
+
+	for (n = dd->slot_groups-1; n >= 0; n--)
+		size += sprintf(&buf[size], "%08X ",
+				readl(dd->port->completed[n]));
+
+	size += sprintf(&buf[size], "]\n");
+	size += sprintf(&buf[size], "H/ PORT IRQ STAT : [ 0x%08X ]\n",
+				readl(dd->port->mmio + PORT_IRQ_STAT));
+	size += sprintf(&buf[size], "H/ HOST IRQ STAT : [ 0x%08X ]\n",
+				readl(dd->mmio + HOST_IRQ_STAT));
+	size += sprintf(&buf[size], "\n");
+
+	size += sprintf(&buf[size], "L/ Allocated     : [ 0x");
+
+	for (n = dd->slot_groups-1; n >= 0; n--) {
+		if (sizeof(long) > sizeof(u32))
+			group_allocated =
+				dd->port->allocated[n/2] >> (32*(n&1));
+		else
+			group_allocated = dd->port->allocated[n];
+		size += sprintf(&buf[size], "%08X ", group_allocated);
+	}
+	size += sprintf(&buf[size], "]\n");
+
+	size += sprintf(&buf[size], "L/ Commands in Q : [ 0x");
+
+	for (n = dd->slot_groups-1; n >= 0; n--) {
+		if (sizeof(long) > sizeof(u32))
+			group_allocated =
+				dd->port->cmds_to_issue[n/2] >> (32*(n&1));
+		else
+			group_allocated = dd->port->cmds_to_issue[n];
+		size += sprintf(&buf[size], "%08X ", group_allocated);
+	}
+	size += sprintf(&buf[size], "]\n");
+
+	*offset = size <= len ? size : len;
+	size = copy_to_user(ubuf, buf, *offset);
+	if (size)
+		return -EFAULT;
+
+	return *offset;
+}
+
+static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
+				  size_t len, loff_t *offset)
+{
+	struct driver_data *dd =  (struct driver_data *)f->private_data;
+	char buf[MTIP_DFS_MAX_BUF_SIZE];
+	int size = *offset;
+
+	if (!len || size)
+		return 0;
+
+	if (size < 0)
+		return -EINVAL;
+
+	size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
+							dd->port->flags);
+	size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
+							dd->dd_flag);
+
+	*offset = size <= len ? size : len;
+	size = copy_to_user(ubuf, buf, *offset);
+	if (size)
+		return -EFAULT;
+
+	return *offset;
+}
+
+static const struct file_operations mtip_regs_fops = {
+	.owner  = THIS_MODULE,
+	.open   = simple_open,
+	.read   = mtip_hw_read_registers,
+	.llseek = no_llseek,
+};
+
+static const struct file_operations mtip_flags_fops = {
+	.owner  = THIS_MODULE,
+	.open   = simple_open,
+	.read   = mtip_hw_read_flags,
+	.llseek = no_llseek,
+};
+
 /*
  * Create the sysfs related attributes.
  *
@@ -2615,6 +2731,34 @@ static int mtip_hw_sysfs_exit(struct driver_data *dd, struct kobject *kobj)
 	return 0;
 }
 
+static int mtip_hw_debugfs_init(struct driver_data *dd)
+{
+	if (!dfs_parent)
+		return -1;
+
+	dd->dfs_node = debugfs_create_dir(dd->disk->disk_name, dfs_parent);
+	if (IS_ERR_OR_NULL(dd->dfs_node)) {
+		dev_warn(&dd->pdev->dev,
+			"Error creating node %s under debugfs\n",
+						dd->disk->disk_name);
+		dd->dfs_node = NULL;
+		return -1;
+	}
+
+	debugfs_create_file("flags", S_IRUGO, dd->dfs_node, dd,
+							&mtip_flags_fops);
+	debugfs_create_file("registers", S_IRUGO, dd->dfs_node, dd,
+							&mtip_regs_fops);
+
+	return 0;
+}
+
+static void mtip_hw_debugfs_exit(struct driver_data *dd)
+{
+	debugfs_remove_recursive(dd->dfs_node);
+}
+
+
 /*
  * Perform any init/resume time hardware setup
  *
@@ -3640,6 +3784,7 @@ skip_create_disk:
 		mtip_hw_sysfs_init(dd, kobj);
 		kobject_put(kobj);
 	}
+	mtip_hw_debugfs_init(dd);
 
 	if (dd->mtip_svc_handler) {
 		set_bit(MTIP_DDF_INIT_DONE_BIT, &dd->dd_flag);
@@ -3665,6 +3810,8 @@ start_service_thread:
 	return rv;
 
 kthread_run_error:
+	mtip_hw_debugfs_exit(dd);
+
 	/* Delete our gendisk. This also removes the device from /dev */
 	del_gendisk(dd->disk);
 
@@ -3715,6 +3862,7 @@ static int mtip_block_remove(struct driver_data *dd)
 			kobject_put(kobj);
 		}
 	}
+	mtip_hw_debugfs_exit(dd);
 
 	/*
 	 * Delete our gendisk structure. This also removes the device
@@ -4062,10 +4210,20 @@ static int __init mtip_init(void)
 	}
 	mtip_major = error;
 
+	if (!dfs_parent) {
+		dfs_parent = debugfs_create_dir("rssd", NULL);
+		if (IS_ERR_OR_NULL(dfs_parent)) {
+			printk(KERN_WARNING "Error creating debugfs parent\n");
+			dfs_parent = NULL;
+		}
+	}
+
 	/* Register our PCI operations. */
 	error = pci_register_driver(&mtip_pci_driver);
-	if (error)
+	if (error) {
+		debugfs_remove(dfs_parent);
 		unregister_blkdev(mtip_major, MTIP_DRV_NAME);
+	}
 
 	return error;
 }
@@ -4082,6 +4240,8 @@ static int __init mtip_init(void)
  */
 static void __exit mtip_exit(void)
 {
+	debugfs_remove_recursive(dfs_parent);
+
 	/* Release the allocated major block device number. */
 	unregister_blkdev(mtip_major, MTIP_DRV_NAME);
 
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index b2c88da..0c15d70 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -111,6 +111,8 @@
  #define dbg_printk(format, arg...)
 #endif
 
+#define MTIP_DFS_MAX_BUF_SIZE 1024
+
 #define __force_bit2int (unsigned int __force)
 
 enum {
@@ -447,6 +449,8 @@ struct driver_data {
 	unsigned long dd_flag; /* NOTE: use atomic bit operations on this */
 
 	struct task_struct *mtip_svc_handler; /* task_struct of svc thd */
+
+	struct dentry *dfs_node;
 };
 
 #endif
-- 
1.7.1

