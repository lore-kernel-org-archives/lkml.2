Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0JVX75 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:59:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60658 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab0JVXyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UGpHdBvS6r/4HgrPsJI4F5Cb7pAgePJTuXSm0aeXuUbNgVCP9PPgooaLvrkX0GJXT6
         8zfSvxJhgKv9+NE0DtDc7defgTNebKagVOOjOOGPYadGGr/E7n5sMVpfW3MQvwY7J2tf
         91X1raQ3jzsfIC0M5UdLhUdzy9NuObZz7GwJQ=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 05/29] memstick: mspro_block: move declarations to header and refactor things a bit
Date: Sat, 23 Oct 2010 01:53:33 +0200
Message-Id: <1287791637-10329-6-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes it much easier to lookup things and reduces size of mspro_block.c
Also add debbuging macros so that it becames possible to control
debbuging via module param.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/core/mspro_block.c |  157 ++-----------------------------
 drivers/memstick/core/mspro_block.h |  176 +++++++++++++++++++++++++++++++++++
 2 files changed, 185 insertions(+), 148 deletions(-)
 create mode 100644 drivers/memstick/core/mspro_block.h

diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index d3f1a08..5dc8fd7 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -20,158 +20,14 @@
 #include <linux/slab.h>
 #include <linux/smp_lock.h>
 #include <linux/memstick.h>
-
-#define DRIVER_NAME "mspro_block"
+#include "mspro_block.h"
 
 static int major;
-module_param(major, int, 0644);
-
-#define MSPRO_BLOCK_MAX_SEGS  32
-#define MSPRO_BLOCK_MAX_PAGES ((2 << 16) - 1)
-
-#define MSPRO_BLOCK_SIGNATURE        0xa5c3
-#define MSPRO_BLOCK_MAX_ATTRIBUTES   41
-
-#define MSPRO_BLOCK_PART_SHIFT 3
-
-enum {
-	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
-	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
-	MSPRO_BLOCK_ID_MBR             = 0x20,
-	MSPRO_BLOCK_ID_PBR16           = 0x21,
-	MSPRO_BLOCK_ID_PBR32           = 0x22,
-	MSPRO_BLOCK_ID_SPECFILEVALUES1 = 0x25,
-	MSPRO_BLOCK_ID_SPECFILEVALUES2 = 0x26,
-	MSPRO_BLOCK_ID_DEVINFO         = 0x30
-};
-
-struct mspro_sys_attr {
-	size_t                  size;
-	void                    *data;
-	unsigned char           id;
-	char                    name[32];
-	struct device_attribute dev_attr;
-};
-
-struct mspro_attr_entry {
-	__be32 address;
-	__be32 size;
-	unsigned char id;
-	unsigned char reserved[3];
-} __attribute__((packed));
-
-struct mspro_attribute {
-	__be16 signature;
-	unsigned short          version;
-	unsigned char           count;
-	unsigned char           reserved[11];
-	struct mspro_attr_entry entries[];
-} __attribute__((packed));
-
-struct mspro_sys_info {
-	unsigned char  class;
-	unsigned char  reserved0;
-	__be16 block_size;
-	__be16 block_count;
-	__be16 user_block_count;
-	__be16 page_size;
-	unsigned char  reserved1[2];
-	unsigned char  assembly_date[8];
-	__be32 serial_number;
-	unsigned char  assembly_maker_code;
-	unsigned char  assembly_model_code[3];
-	__be16 memory_maker_code;
-	__be16 memory_model_code;
-	unsigned char  reserved2[4];
-	unsigned char  vcc;
-	unsigned char  vpp;
-	__be16 controller_number;
-	__be16 controller_function;
-	__be16 start_sector;
-	__be16 unit_size;
-	unsigned char  ms_sub_class;
-	unsigned char  reserved3[4];
-	unsigned char  interface_type;
-	__be16 controller_code;
-	unsigned char  format_type;
-	unsigned char  reserved4;
-	unsigned char  device_type;
-	unsigned char  reserved5[7];
-	unsigned char  mspro_id[16];
-	unsigned char  reserved6[16];
-} __attribute__((packed));
-
-struct mspro_mbr {
-	unsigned char boot_partition;
-	unsigned char start_head;
-	unsigned char start_sector;
-	unsigned char start_cylinder;
-	unsigned char partition_type;
-	unsigned char end_head;
-	unsigned char end_sector;
-	unsigned char end_cylinder;
-	unsigned int  start_sectors;
-	unsigned int  sectors_per_partition;
-} __attribute__((packed));
-
-struct mspro_specfile {
-	char           name[8];
-	char           ext[3];
-	unsigned char  attr;
-	unsigned char  reserved[10];
-	unsigned short time;
-	unsigned short date;
-	unsigned short cluster;
-	unsigned int   size;
-} __attribute__((packed));
-
-struct mspro_devinfo {
-	__be16 cylinders;
-	__be16 heads;
-	__be16 bytes_per_track;
-	__be16 bytes_per_sector;
-	__be16 sectors_per_track;
-	unsigned char  reserved[6];
-} __attribute__((packed));
-
-struct mspro_block_data {
-	struct memstick_dev   *card;
-	unsigned int          usage_count;
-	unsigned int          caps;
-	struct gendisk        *disk;
-	struct request_queue  *queue;
-	struct request        *block_req;
-	spinlock_t            q_lock;
-
-	unsigned short        page_size;
-	unsigned short        cylinders;
-	unsigned short        heads;
-	unsigned short        sectors_per_track;
-
-	unsigned char         system;
-	unsigned char         read_only:1,
-			      eject:1,
-			      has_request:1,
-			      data_dir:1,
-			      active:1;
-	unsigned char         transfer_cmd;
-
-	int                   (*mrq_handler)(struct memstick_dev *card,
-					     struct memstick_request **mrq);
-
-	struct attribute_group attr_group;
-
-	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
-	unsigned int          seg_count;
-	unsigned int          current_seg;
-	unsigned int          current_page;
-};
+static int debug;
 
 static DEFINE_IDR(mspro_block_disk_idr);
 static DEFINE_MUTEX(mspro_block_disk_lock);
 
-static int mspro_block_complete_req(struct memstick_dev *card, int error);
-
 /*** Block device ***/
 
 static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
@@ -1202,6 +1058,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	msb->cylinders = be16_to_cpu(dev_info->cylinders);
 	msb->heads = be16_to_cpu(dev_info->heads);
 	msb->sectors_per_track = be16_to_cpu(dev_info->sectors_per_track);
+	sg_init_table(msb->req_sg, MSPRO_BLOCK_MAX_SEGS);
 
 	msb->page_size = be16_to_cpu(sys_info->unit_size);
 
@@ -1257,7 +1114,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	capacity *= be16_to_cpu(sys_info->block_size);
 	capacity *= msb->page_size >> 9;
 	set_capacity(msb->disk, capacity);
-	dev_dbg(&card->dev, "capacity set %ld\n", capacity);
+	dbg(card, "capacity set %ld", capacity);
 
 	add_disk(msb->disk);
 	msb->active = 1;
@@ -1345,7 +1202,7 @@ static void mspro_block_remove(struct memstick_dev *card)
 	spin_unlock_irqrestore(&msb->q_lock, flags);
 
 	del_gendisk(msb->disk);
-	dev_dbg(&card->dev, "mspro block remove\n");
+	dbg(card, "mspro block remove");
 
 	blk_cleanup_queue(msb->queue);
 	msb->queue = NULL;
@@ -1485,6 +1342,10 @@ static void __exit mspro_block_exit(void)
 module_init(mspro_block_init);
 module_exit(mspro_block_exit);
 
+module_param(major, int, 0644);
+module_param(debug, int, 0644);
+
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("Sony MemoryStickPro block device driver");
diff --git a/drivers/memstick/core/mspro_block.h b/drivers/memstick/core/mspro_block.h
new file mode 100644
index 0000000..afb29f8
--- /dev/null
+++ b/drivers/memstick/core/mspro_block.h
@@ -0,0 +1,176 @@
+/*
+ *  Sony MemoryStick Pro storage support
+ *
+ *  Copyright (C) 2007 Alex Dubov <oakad@yahoo.com>
+ *  Copyright (C) 2010 Maxim Levitsky <maximlevitsky@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Special thanks to Carlos Corbacho for providing various MemoryStick cards
+ * that made this driver possible.
+ *
+ */
+
+#define DRIVER_NAME "mspro_block"
+
+#define MSPRO_BLOCK_MAX_SEGS  32
+#define MSPRO_BLOCK_MAX_PAGES ((2 << 16) - 1)
+
+#define MSPRO_BLOCK_SIGNATURE        0xa5c3
+#define MSPRO_BLOCK_MAX_ATTRIBUTES   41
+
+#define MSPRO_BLOCK_PART_SHIFT 3
+
+enum {
+	MSPRO_BLOCK_ID_SYSINFO         = 0x10,
+	MSPRO_BLOCK_ID_MODELNAME       = 0x15,
+	MSPRO_BLOCK_ID_MBR             = 0x20,
+	MSPRO_BLOCK_ID_PBR16           = 0x21,
+	MSPRO_BLOCK_ID_PBR32           = 0x22,
+	MSPRO_BLOCK_ID_SPECFILEVALUES1 = 0x25,
+	MSPRO_BLOCK_ID_SPECFILEVALUES2 = 0x26,
+	MSPRO_BLOCK_ID_DEVINFO         = 0x30
+};
+
+struct mspro_sys_attr {
+	size_t                  size;
+	void                    *data;
+	unsigned char           id;
+	char                    name[32];
+	struct device_attribute dev_attr;
+};
+
+struct mspro_attr_entry {
+	__be32 address;
+	__be32 size;
+	unsigned char id;
+	unsigned char reserved[3];
+} __packed;
+
+struct mspro_attribute {
+	__be16 signature;
+	unsigned short          version;
+	unsigned char           count;
+	unsigned char           reserved[11];
+	struct mspro_attr_entry entries[];
+} __packed;
+
+struct mspro_sys_info {
+	unsigned char  class;
+	unsigned char  reserved0;
+	__be16 block_size;
+	__be16 block_count;
+	__be16 user_block_count;
+	__be16 page_size;
+	unsigned char  reserved1[2];
+	unsigned char  assembly_date[8];
+	__be32 serial_number;
+	unsigned char  assembly_maker_code;
+	unsigned char  assembly_model_code[3];
+	__be16 memory_maker_code;
+	__be16 memory_model_code;
+	unsigned char  reserved2[4];
+	unsigned char  vcc;
+	unsigned char  vpp;
+	__be16 controller_number;
+	__be16 controller_function;
+	__be16 start_sector;
+	__be16 unit_size;
+	unsigned char  ms_sub_class;
+	unsigned char  reserved3[4];
+	unsigned char  interface_type;
+	__be16 controller_code;
+	unsigned char  format_type;
+	unsigned char  reserved4;
+	unsigned char  device_type;
+	unsigned char  reserved5[7];
+	unsigned char  mspro_id[16];
+	unsigned char  reserved6[16];
+} __packed;
+
+struct mspro_mbr {
+	unsigned char boot_partition;
+	unsigned char start_head;
+	unsigned char start_sector;
+	unsigned char start_cylinder;
+	unsigned char partition_type;
+	unsigned char end_head;
+	unsigned char end_sector;
+	unsigned char end_cylinder;
+	unsigned int  start_sectors;
+	unsigned int  sectors_per_partition;
+} __packed;
+
+struct mspro_specfile {
+	char           name[8];
+	char           ext[3];
+	unsigned char  attr;
+	unsigned char  reserved[10];
+	unsigned short time;
+	unsigned short date;
+	unsigned short cluster;
+	unsigned int   size;
+} __packed;
+
+struct mspro_devinfo {
+	__be16 cylinders;
+	__be16 heads;
+	__be16 bytes_per_track;
+	__be16 bytes_per_sector;
+	__be16 sectors_per_track;
+	unsigned char  reserved[6];
+} __packed;
+
+
+
+struct mspro_block_data {
+	struct memstick_dev   *card;
+	unsigned int          usage_count;
+	unsigned int          caps;
+	struct gendisk        *disk;
+	struct request_queue  *queue;
+	struct request        *block_req;
+	spinlock_t            q_lock;
+
+	unsigned short        page_size;
+	unsigned short        cylinders;
+	unsigned short        heads;
+	unsigned short        sectors_per_track;
+
+	unsigned char         system;
+	unsigned char         read_only:1,
+			      eject:1,
+			      has_request:1,
+			      data_dir:1,
+			      active:1;
+	unsigned char         transfer_cmd;
+
+	int                   (*mrq_handler)(struct memstick_dev *card,
+					     struct memstick_request **mrq);
+
+	struct attribute_group attr_group;
+
+	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
+	unsigned int          seg_count;
+	unsigned int          current_seg;
+	unsigned int          current_page;
+};
+
+static int mspro_block_complete_req(struct memstick_dev *card, int error);
+static int mspro_block_switch_interface(struct memstick_dev *card);
+static int mspro_block_issue_req(struct memstick_dev *card, int chunk);
+
+#define __dbg(card, level, format, ...) \
+	do { \
+		if (debug >= level) \
+			printk(KERN_DEBUG \
+				"%s: " format "\n", dev_name(&card->dev) \
+					 , ## __VA_ARGS__); \
+		else \
+			dev_dbg(&card->dev, format, ## __VA_ARGS__); \
+	} while (0)
+
+#define dbg(card, format, ...)		__dbg(card, 1, format, ## __VA_ARGS__)
+#define dbg_v(card, format, ...)	__dbg(card, 2, format, ## __VA_ARGS__)
-- 
1.7.1

