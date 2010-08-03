Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0HCVgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:36:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64562 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756928Ab0HCVgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:36:31 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Will Drewry <wad@chromium.org>
Subject: [PATCH 2/2] genhd, efi: add efi partition metadata to hd_structs
Date: Tue,  3 Aug 2010 16:35:36 -0500
Message-Id: <1280871336-31046-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com>
References: <AANLkTin3+LfXOpW5MsPSgs_5Z0UFnQTwBAXSocrU1Xs8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change extends the partition_meta_info structure to
support EFI GPT-specific metadata and ensures that data
is copied in on partition scanning.

Adding this information would make it possible to identify a
partition by GUID using something like disk_part_iter_*(),
calls that make hd_struct accessible, or even class_find_device.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/partitions/efi.c   |   16 ++++++++++++++++
 include/linux/genhd.h |   12 ++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 9efb2cf..2880b33 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -614,6 +614,7 @@ int efi_partition(struct parsed_partitions *state)
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+		struct partition_meta_info *info;
 		u64 start = le64_to_cpu(ptes[i].starting_lba);
 		u64 size = le64_to_cpu(ptes[i].ending_lba) -
 			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
@@ -627,6 +628,21 @@ int efi_partition(struct parsed_partitions *state)
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
 				 PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
+
+		info = alloc_part_info(NULL);
+		if (!info) {
+			printk(KERN_WARNING
+			       "unable to allocate memory for part->info\n");
+			continue;
+		}
+		state->parts[i + 1].info = info;
+		info->format = PARTITION_META_INFO_FORMAT_EFI;
+		memcpy(info->efi.uuid.b, ptes[i].unique_partition_guid.b,
+			sizeof(info->efi.uuid.b));
+		memcpy(info->efi.type.b, ptes[i].partition_type_guid.b,
+			sizeof(info->efi.type.b));
+		memcpy(info->efi.label, ptes[i].partition_name,
+			sizeof(info->efi.label));
 	}
 	kfree(ptes);
 	kfree(gpt);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7b6644a..e0a742f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -91,11 +91,23 @@ struct disk_stats {
 enum partition_meta_info_format_t {
 	/* Partition info format */
 	PARTITION_META_INFO_FORMAT_NONE = 0,
+	PARTITION_META_INFO_FORMAT_EFI = 1,
 };
 
+#ifdef CONFIG_EFI_PARTITION
+#include <linux/efi.h>
+#endif
+
 struct partition_meta_info {
 	enum partition_meta_info_format_t format;
 	union {
+#ifdef CONFIG_EFI_PARTITION
+		struct {
+			efi_guid_t uuid;
+			efi_guid_t type;
+			efi_char16_t label[72 / sizeof(efi_char16_t)];
+		} efi;
+#endif
 	};
 };
 
-- 
1.7.0.4

