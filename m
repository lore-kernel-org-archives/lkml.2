Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab0HDCGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:06:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44629 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0HDCGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:06:21 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH v2 2/3] genhd, efi: add efi partition metadata to hd_structs
Date: Tue,  3 Aug 2010 21:04:42 -0500
Message-Id: <1280887483-2979-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
References: <AANLkTim6Bn++JaspY0cbpLLvi=MYBLNgUhARwKQkoYpE@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change extends the partition_meta_info structure to
support EFI GPT-specific metadata and ensures that data
is copied in on partition scanning.

Signed-off-by: Will Drewry <wad@chromium.org>

v2: move info assignment after memcpy()s
    adds _MAX to the enum after EFI
---
 fs/partitions/efi.c   |   16 ++++++++++++++++
 include/linux/genhd.h |   14 ++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 9efb2cf..fac527d 100644
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
+		info->format = PARTITION_META_INFO_FORMAT_EFI;
+		memcpy(info->efi.uuid.b, ptes[i].unique_partition_guid.b,
+			sizeof(info->efi.uuid.b));
+		memcpy(info->efi.type.b, ptes[i].partition_type_guid.b,
+			sizeof(info->efi.type.b));
+		memcpy(info->efi.label, ptes[i].partition_name,
+			sizeof(info->efi.label));
+		state->parts[i + 1].info = info;
 	}
 	kfree(ptes);
 	kfree(gpt);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7b6644a..beb98e3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -91,11 +91,25 @@ struct disk_stats {
 enum partition_meta_info_format_t {
 	/* Partition info format */
 	PARTITION_META_INFO_FORMAT_NONE = 0,
+	PARTITION_META_INFO_FORMAT_EFI,
+	/* Place additional formats here. */
+	PARTITION_META_INFO_FORMAT_MAX,
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

