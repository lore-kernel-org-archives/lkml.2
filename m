Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab1AGMKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 07:10:04 -0500
Received: from landau.phys.spbu.ru ([195.19.235.38]:3145 "EHLO
	landau.phys.spbu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1AGMKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 07:10:01 -0500
From: Kirill Smelkov <kirr@landau.phys.spbu.ru>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Kirill Smelkov <kirr@landau.phys.spbu.ru>,
        Will Drewry <wad@chromium.org>
Subject: [RESEND PATCH 1/2] init: Add support for root devices to be specified by partition name
Date: Fri,  7 Jan 2011 14:42:41 +0300
Message-Id: <89f79879497f66250cde9abdab3cc1da846fd790.1294400351.git.kirr@landau.phys.spbu.ru>
X-Mailer: git-send-email 1.7.4.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 [ In follow-up to b5af921e ]

Besides GUIDs, there are also partition names stored in an EFI GPT
partition table. So let's add support for root to be located not only by
GUID, but also by partition names, like this:

    root=PARTNAME=<partition-name>

Cc: Will Drewry <wad@chromium.org>
Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
---
 block/genhd.c    |   11 ++++++++---
 init/do_mounts.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6a5b772..a478068 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -736,6 +736,7 @@ void __init printk_all_partitions(void)
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
 		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
+		char *partname;
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -755,13 +756,17 @@ void __init printk_all_partitions(void)
 			bool is_part0 = part == &disk->part0;
 
 			uuid[0] = 0;
-			if (part->info)
+			partname = NULL;
+			if (part->info) {
 				part_unpack_uuid(part->info->uuid, uuid);
+				partname = part->info->volname;
+			}
 
-			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
+			printk("%s%s %10llu %s %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf), uuid);
+			       disk_name(disk, part->partno, name_buf), uuid,
+			       partname ? partname : "");
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 830aaec..1dda439 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -84,6 +84,30 @@ no_match:
 
 
 /**
+ * match_dev_by_partname - callback for finding a partition using its name
+ * @dev:	device passed in by the caller
+ * @data:	opaque pointer to a partition name string
+ *
+ * Returns 1 if the device matches, and 0 otherwise.
+ */
+static int match_dev_by_partname(struct device *dev, void *data)
+{
+	char *partname = data;
+	struct hd_struct *part = dev_to_part(dev);
+
+	if (!part->info)
+		goto no_match;
+
+	if (strncmp(partname, part->info->volname, sizeof(part->info->volname)))
+		goto no_match;
+
+	return 1;
+no_match:
+	return 0;
+}
+
+
+/**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
  * @uuid:	36 byte char array containing a hex ascii UUID
  *
@@ -112,6 +136,23 @@ static dev_t __init devt_from_partuuid(char *uuid_str)
 done:
 	return res;
 }
+
+
+static dev_t devt_from_partname(char *partname)
+{
+	dev_t res = 0;
+	struct device *dev = NULL;
+
+	dev = class_find_device(&block_class, NULL, partname, &match_dev_by_partname);
+	if (!dev)
+		goto done;
+
+	res = dev->devt;
+	put_device(dev);
+
+done:
+	return res;
+}
 #endif
 
 /*
@@ -126,6 +167,8 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	7) PARTNAME=<partition_name> represents the device and partition
+ *	   number of partition with matching name.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -150,6 +193,14 @@ dev_t name_to_dev_t(char *name)
 			goto fail;
 		goto done;
 	}
+
+	if (strncmp(name, "PARTNAME=", 9) == 0) {
+		name += 9;
+		res = devt_from_partname(name);
+		if (!res)
+			goto fail;
+		goto done;
+	}
 #endif
 
 	if (strncmp(name, "/dev/", 5) != 0) {
-- 
1.7.4.rc1
