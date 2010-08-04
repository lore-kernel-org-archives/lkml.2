Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566Ab0HDSXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:23:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60316 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643Ab0HDSXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:23:06 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH v3 3/3] init: add support for root devices specified by partition UUID
Date: Wed,  4 Aug 2010 13:22:06 -0500
Message-Id: <1280946126-19587-3-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
References: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third patch in a series which adds support for
storing partition metadata, optionally, off of the hd_struct.

One major use for that data is being able to resolve partition
by other identities than just the index on a block device.  Device
enumeration varies by platform and there's a benefit to being able
to use something like EFI GPT's GUIDs to determine the correct
block device and partition to mount as the root.

This change adds that support to root= by adding support for
the following syntax:

  root=PARTUUID=hex-uuid

Signed-off-by: Will Drewry <wad@chromium.org>

v2: added to patch series
v3: adds uuids to printk_all_partitions
    simplifies matching to a uniform uuid packed format (big endian)
---
 block/genhd.c    |    9 +++++-
 init/do_mounts.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c8da120..5c9c503 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -642,6 +642,7 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
+		u8 uuid[PARTITION_META_INFO_UUIDLTH * 2 + 1];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -660,10 +661,14 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			printk("%s%s %10llu %s", is_part0 ? "" : "  ",
+			uuid[0] = 0;
+			if (part->info)
+				part_unpack_uuid(part->info->uuid, uuid);
+
+			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
-			       disk_name(disk, part->partno, name_buf));
+			       disk_name(disk, part->partno, name_buf), uuid);
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff --git a/init/do_mounts.c b/init/do_mounts.c
index 02e3ca4..804f9c6 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -58,6 +58,60 @@ static int __init readwrite(char *str)
 __setup("ro", readonly);
 __setup("rw", readwrite);
 
+/**
+ * match_dev_by_uuid - callback for finding a partition using its uuid
+ * @dev:	device passed in by the caller
+ * @data:	opaque pointer to a 36 byte char array with a UUID
+ *
+ * Returns 1 if the device matches, and 0 otherwise.
+ */
+static int __init match_dev_by_uuid(struct device *dev, void *data)
+{
+	u8 *uuid = data;
+	struct hd_struct *part = dev_to_part(dev);
+
+	if (!part->info)
+		goto no_match;
+
+	if (memcmp(uuid, part->info->uuid, sizeof(part->info->uuid)))
+			goto no_match;
+
+	return 1;
+no_match:
+	return 0;
+}
+
+
+/**
+ * devt_from_partuuid - looks up the dev_t of a partition by its UUID
+ * @uuid:	36 byte char array containing a hex ascii UUID
+ *
+ * The function will return the first partition which contains a matching
+ * UUID value in its partition_meta_info struct.  This does not search
+ * by filesystem UUIDs.
+ *
+ * Returns the matching dev_t on success or 0 on failure.
+ */
+static dev_t __init devt_from_partuuid(char *uuid_str)
+{
+	dev_t res = 0;
+	struct device *dev = NULL;
+	u8 uuid[16];
+
+	/* Pack the requested UUID in the expected format. */
+	part_pack_uuid(uuid_str, uuid);
+
+	dev = class_find_device(&block_class, NULL, uuid, &match_dev_by_uuid);
+	if (!dev)
+		goto done;
+
+	res = dev->devt;
+	put_device(dev);
+
+done:
+	return res;
+}
+
 /*
  *	Convert a name into device number.  We accept the following variants:
  *
@@ -68,6 +122,8 @@ __setup("rw", readwrite);
  *         of partition - device number of disk plus the partition number
  *	5) /dev/<disk_name>p<decimal> - same as the above, that form is
  *	   used when disk name of partitioned disk ends on a digit.
+ *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
+ *	   unique id of a partition if the partition table provides it.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
  *	block_class is used to check if something is a disk name. If the disk
@@ -82,6 +138,16 @@ dev_t name_to_dev_t(char *name)
 	dev_t res = 0;
 	int part;
 
+	if (strncmp(name, "PARTUUID=", 9) == 0) {
+		name += 9;
+		if (strlen(name) != 36)
+			goto fail;
+		res = devt_from_partuuid(name);
+		if (!res)
+			goto fail;
+		goto done;
+	}
+
 	if (strncmp(name, "/dev/", 5) != 0) {
 		unsigned maj, min;
 
-- 
1.7.0.4

