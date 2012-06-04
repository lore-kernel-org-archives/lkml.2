Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370Ab2FDTnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 15:43:11 -0400
Received: from masquerade.micron.com ([137.201.242.130]:15462 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2FDTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 15:43:07 -0400
Message-ID: <4FCD0FC7.9010105@micron.com>
Date: Mon, 4 Jun 2012 12:43:03 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 1/2] mtip32xx: Remove 'registers' and 'flags' from sysfs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18948.001
X-TM-AS-Result: No--19.225600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes entries 'registers' and 'flags' from sysfs. Updated ABI file
to reflect this change.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 Documentation/ABI/testing/sysfs-block-rssd |   21 ------
 drivers/block/mtip32xx/mtip32xx.c          |   92 +---------------------------
 2 files changed, 1 insertions(+), 112 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-rssd b/Documentation/ABI/testing/sysfs-block-rssd
index 679ce35..beef30c 100644
--- a/Documentation/ABI/testing/sysfs-block-rssd
+++ b/Documentation/ABI/testing/sysfs-block-rssd
@@ -1,26 +1,5 @@
-What:           /sys/block/rssd*/registers
-Date:           March 2012
-KernelVersion:  3.3
-Contact:        Asai Thambi S P <asamymuthupa@micron.com>
-Description:    This is a read-only file. Dumps below driver information and
-                hardware registers.
-                    - S ACTive
-                    - Command Issue
-                    - Completed
-                    - PORT IRQ STAT
-                    - HOST IRQ STAT
-                    - Allocated
-                    - Commands in Q
-
 What:           /sys/block/rssd*/status
 Date:           April 2012
 KernelVersion:  3.4
 Contact:        Asai Thambi S P <asamymuthupa@micron.com>
 Description:    This is a read-only file. Indicates the status of the device.
-
-What:           /sys/block/rssd*/flags
-Date:           May 2012
-KernelVersion:  3.5
-Contact:        Asai Thambi S P <asamymuthupa@micron.com>
-Description:    This is a read-only file. Dumps the flags in port and driver
-                data structure
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 264bc77..b6e95b9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2546,7 +2546,7 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
 }
 
 /*
- * Sysfs register/status dump.
+ * Sysfs status dump.
  *
  * @dev  Pointer to the device structure, passed by the kernrel.
  * @attr Pointer to the device_attribute structure passed by the kernel.
@@ -2555,71 +2555,6 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
  * return value
  *	The size, in bytes, of the data copied into buf.
  */
-static ssize_t mtip_hw_show_registers(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	u32 group_allocated;
-	struct driver_data *dd = dev_to_disk(dev)->private_data;
-	int size = 0;
-	int n;
-
-	size += sprintf(&buf[size], "Hardware\n--------\n");
-	size += sprintf(&buf[size], "S ACTive      : [ 0x");
-
-	for (n = dd->slot_groups-1; n >= 0; n--)
-		size += sprintf(&buf[size], "%08X ",
-					 readl(dd->port->s_active[n]));
-
-	size += sprintf(&buf[size], "]\n");
-	size += sprintf(&buf[size], "Command Issue : [ 0x");
-
-	for (n = dd->slot_groups-1; n >= 0; n--)
-		size += sprintf(&buf[size], "%08X ",
-					readl(dd->port->cmd_issue[n]));
-
-	size += sprintf(&buf[size], "]\n");
-	size += sprintf(&buf[size], "Completed     : [ 0x");
-
-	for (n = dd->slot_groups-1; n >= 0; n--)
-		size += sprintf(&buf[size], "%08X ",
-				readl(dd->port->completed[n]));
-
-	size += sprintf(&buf[size], "]\n");
-	size += sprintf(&buf[size], "PORT IRQ STAT : [ 0x%08X ]\n",
-				readl(dd->port->mmio + PORT_IRQ_STAT));
-	size += sprintf(&buf[size], "HOST IRQ STAT : [ 0x%08X ]\n",
-				readl(dd->mmio + HOST_IRQ_STAT));
-	size += sprintf(&buf[size], "\n");
-
-	size += sprintf(&buf[size], "Local\n-----\n");
-	size += sprintf(&buf[size], "Allocated    : [ 0x");
-
-	for (n = dd->slot_groups-1; n >= 0; n--) {
-		if (sizeof(long) > sizeof(u32))
-			group_allocated =
-				dd->port->allocated[n/2] >> (32*(n&1));
-		else
-			group_allocated = dd->port->allocated[n];
-		size += sprintf(&buf[size], "%08X ", group_allocated);
-	}
-	size += sprintf(&buf[size], "]\n");
-
-	size += sprintf(&buf[size], "Commands in Q: [ 0x");
-
-	for (n = dd->slot_groups-1; n >= 0; n--) {
-		if (sizeof(long) > sizeof(u32))
-			group_allocated =
-				dd->port->cmds_to_issue[n/2] >> (32*(n&1));
-		else
-			group_allocated = dd->port->cmds_to_issue[n];
-		size += sprintf(&buf[size], "%08X ", group_allocated);
-	}
-	size += sprintf(&buf[size], "]\n");
-
-	return size;
-}
-
 static ssize_t mtip_hw_show_status(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -2637,24 +2572,7 @@ static ssize_t mtip_hw_show_status(struct device *dev,
 	return size;
 }
 
-static ssize_t mtip_hw_show_flags(struct device *dev,
-				struct device_attribute *attr,
-				char *buf)
-{
-	struct driver_data *dd = dev_to_disk(dev)->private_data;
-	int size = 0;
-
-	size += sprintf(&buf[size], "Flag in port struct : [ %08lX ]\n",
-							dd->port->flags);
-	size += sprintf(&buf[size], "Flag in dd struct   : [ %08lX ]\n",
-							dd->dd_flag);
-
-	return size;
-}
-
-static DEVICE_ATTR(registers, S_IRUGO, mtip_hw_show_registers, NULL);
 static DEVICE_ATTR(status, S_IRUGO, mtip_hw_show_status, NULL);
-static DEVICE_ATTR(flags, S_IRUGO, mtip_hw_show_flags, NULL);
 
 /*
  * Create the sysfs related attributes.
@@ -2671,15 +2589,9 @@ static int mtip_hw_sysfs_init(struct driver_data *dd, struct kobject *kobj)
 	if (!kobj || !dd)
 		return -EINVAL;
 
-	if (sysfs_create_file(kobj, &dev_attr_registers.attr))
-		dev_warn(&dd->pdev->dev,
-			"Error creating 'registers' sysfs entry\n");
 	if (sysfs_create_file(kobj, &dev_attr_status.attr))
 		dev_warn(&dd->pdev->dev,
 			"Error creating 'status' sysfs entry\n");
-	if (sysfs_create_file(kobj, &dev_attr_flags.attr))
-		dev_warn(&dd->pdev->dev,
-			"Error creating 'flags' sysfs entry\n");
 	return 0;
 }
 
@@ -2698,9 +2610,7 @@ static int mtip_hw_sysfs_exit(struct driver_data *dd, struct kobject *kobj)
 	if (!kobj || !dd)
 		return -EINVAL;
 
-	sysfs_remove_file(kobj, &dev_attr_registers.attr);
 	sysfs_remove_file(kobj, &dev_attr_status.attr);
-	sysfs_remove_file(kobj, &dev_attr_flags.attr);
 
 	return 0;
 }
-- 
1.7.1

