Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab2HVXCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:02:17 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36624 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933229Ab2HVXCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:02:13 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Will Drewry <wad@chromium.org>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        cross-distro@lists.linaro.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/3] block: store partition_meta_info.uuid as a string
Date: Wed, 22 Aug 2012 17:02:02 -0600
Message-Id: <1345676524-24450-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

This will allow other types of UUID to be stored here, aside from true
UUIDs. This also simplifies code that uses this field, since it's
usually constructed from a, used as a, or compared to other, strings.

Note: A simplistic approach here would be to set uuid_str[36]=0 whenever
a /PARTNROFF option was found to be present. However, this modifies the
input string, and causes subsequent calls to devt_from_partuuid() not to
see the /PARTNROFF option, which causes different results. In order to
avoid misleading future maintainers, this parameter is marked const.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 block/genhd.c          |    8 +-------
 block/partitions/efi.c |    7 +------
 include/linux/genhd.h  |    8 ++++++--
 init/do_mounts.c       |   28 +++++++++++++++++-----------
 4 files changed, 25 insertions(+), 26 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 6cace66..b281f3a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -743,7 +743,6 @@ void __init printk_all_partitions(void)
 		struct hd_struct *part;
 		char name_buf[BDEVNAME_SIZE];
 		char devt_buf[BDEVT_SIZE];
-		char uuid_buf[PARTITION_META_INFO_UUIDLTH * 2 + 5];
 
 		/*
 		 * Don't show empty devices or things that have been
@@ -762,16 +761,11 @@ void __init printk_all_partitions(void)
 		while ((part = disk_part_iter_next(&piter))) {
 			bool is_part0 = part == &disk->part0;
 
-			uuid_buf[0] = '\0';
-			if (part->info)
-				snprintf(uuid_buf, sizeof(uuid_buf), "%pU",
-					 part->info->uuid);
-
 			printk("%s%s %10llu %s %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part_nr_sects_read(part) >> 1
 			       , disk_name(disk, part->partno, name_buf),
-			       uuid_buf);
+			       part->info ? part->info->uuid : "");
 			if (is_part0) {
 				if (disk->driverfs_dev != NULL &&
 				    disk->driverfs_dev->driver != NULL)
diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 6296b40..b62fb88 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -620,7 +620,6 @@ int efi_partition(struct parsed_partitions *state)
 	gpt_entry *ptes = NULL;
 	u32 i;
 	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
-	u8 unparsed_guid[37];
 
 	if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -649,11 +648,7 @@ int efi_partition(struct parsed_partitions *state)
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
-		/* Instead of doing a manual swap to big endian, reuse the
-		 * common ASCII hex format as the interim.
-		 */
-		efi_guid_unparse(&ptes[i].unique_partition_guid, unparsed_guid);
-		part_pack_uuid(unparsed_guid, info->uuid);
+		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
 		label_max = min(sizeof(info->volname) - 1,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..79b8bba 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -88,10 +88,14 @@ struct disk_stats {
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
-#define PARTITION_META_INFO_UUIDLTH	16
+/*
+ * Enough for the string representation of any kind of UUID plus NULL.
+ * EFI UUID is 36 characters. MSDOS UUID is 11 characters.
+ */
+#define PARTITION_META_INFO_UUIDLTH	37
 
 struct partition_meta_info {
-	u8 uuid[PARTITION_META_INFO_UUIDLTH];	/* always big endian */
+	char uuid[PARTITION_META_INFO_UUIDLTH];
 	u8 volname[PARTITION_META_INFO_VOLNAMELTH];
 };
 
diff --git a/init/do_mounts.c b/init/do_mounts.c
index d3f0aee..4dba733 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -69,23 +69,28 @@ __setup("ro", readonly);
 __setup("rw", readwrite);
 
 #ifdef CONFIG_BLOCK
+struct uuidcmp {
+	const char *uuid;
+	int len;
+};
+
 /**
  * match_dev_by_uuid - callback for finding a partition using its uuid
  * @dev:	device passed in by the caller
- * @data:	opaque pointer to a 36 byte char array with a UUID
+ * @data:	opaque pointer to the desired struct uuidcmp to match
  *
  * Returns 1 if the device matches, and 0 otherwise.
  */
 static int match_dev_by_uuid(struct device *dev, void *data)
 {
-	u8 *uuid = data;
+	struct uuidcmp *cmp = data;
 	struct hd_struct *part = dev_to_part(dev);
 
 	if (!part->info)
 		goto no_match;
 
-	if (memcmp(uuid, part->info->uuid, sizeof(part->info->uuid)))
-			goto no_match;
+	if (strncasecmp(cmp->uuid, part->info->uuid, cmp->len))
+		goto no_match;
 
 	return 1;
 no_match:
@@ -95,7 +100,7 @@ no_match:
 
 /**
  * devt_from_partuuid - looks up the dev_t of a partition by its UUID
- * @uuid:	min 36 byte char array containing a hex ascii UUID
+ * @uuid:	char array containing ascii UUID
  *
  * The function will return the first partition which contains a matching
  * UUID value in its partition_meta_info struct.  This does not search
@@ -106,11 +111,11 @@ no_match:
  *
  * Returns the matching dev_t on success or 0 on failure.
  */
-static dev_t devt_from_partuuid(char *uuid_str)
+static dev_t devt_from_partuuid(const char *uuid_str)
 {
 	dev_t res = 0;
+	struct uuidcmp cmp;
 	struct device *dev = NULL;
-	u8 uuid[16];
 	struct gendisk *disk;
 	struct hd_struct *part;
 	int offset = 0;
@@ -118,6 +123,9 @@ static dev_t devt_from_partuuid(char *uuid_str)
 	if (strlen(uuid_str) < 36)
 		goto done;
 
+	cmp.uuid = uuid_str;
+	cmp.len = 36;
+
 	/* Check for optional partition number offset attributes. */
 	if (uuid_str[36]) {
 		char c = 0;
@@ -134,10 +142,8 @@ static dev_t devt_from_partuuid(char *uuid_str)
 		}
 	}
 
-	/* Pack the requested UUID in the expected format. */
-	part_pack_uuid(uuid_str, uuid);
-
-	dev = class_find_device(&block_class, NULL, uuid, &match_dev_by_uuid);
+	dev = class_find_device(&block_class, NULL, &cmp,
+				&match_dev_by_uuid);
 	if (!dev)
 		goto done;
 
-- 
1.7.0.4

