Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab1KKQxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:53:14 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49185 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab1KKQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:53:12 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Matt_Domsch@dell.com, eugeneteo@kernel.sg,
        davej@codemonkey.org.uk, Warns@pre-sense.de,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] efi: add option for MSR partition.
Date: Sat, 12 Nov 2011 01:52:55 +0900
Message-Id: <1321030375-8221-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After formatting GUID table on MS windows, MSR(Windows Reserved Partition) is not visible on MS windows. But this partition is visible in linux. User don't want to see the stranged partitin. So I try to add option that user can select MSR partition to be visible or not in linux.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>
Cc: Dave Jones <davej@codemonkey.org.uk>
Cc: Timo Warns <Warns@pre-sense.de>
---
 fs/partitions/Kconfig |   10 ++++++++++
 fs/partitions/efi.c   |   15 ++++++++++-----
 include/linux/efi.h   |    3 +++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/partitions/Kconfig b/fs/partitions/Kconfig
index cb5f0a3..c97f4f2 100644
--- a/fs/partitions/Kconfig
+++ b/fs/partitions/Kconfig
@@ -241,6 +241,16 @@ config EFI_PARTITION
 	  Say Y here if you would like to use hard disks under Linux which
 	  were partitioned using EFI GPT.
 
+config MSR_PARTITION_VISIBLE
+        bool "Visible MSR Partition"
+        depends on EFI_PARTITION
+        default y
+        help
+          If you say Y here Microsoft Reserved Partition is visible in
+	  GUID Partitions.
+          Initial size of MSR is 32 MB on disks smaller than 16 GB, or
+	  128 MB on other disks
+
 config SYSV68_PARTITION
 	bool "SYSV68 partition table support" if PARTITION_ADVANCED
 	default y if VME
diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 6296b40..473832d 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -618,7 +618,7 @@ int efi_partition(struct parsed_partitions *state)
 {
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
-	u32 i;
+	u32 i, part_num = 0;
 	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
 	u8 unparsed_guid[37];
 
@@ -641,14 +641,19 @@ int efi_partition(struct parsed_partitions *state)
 		if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
 			continue;
 
-		put_partition(state, i+1, start * ssz, size * ssz);
+#ifdef CONFIG_MSR_PARTITION_VISIBLE
+		if (!efi_guidcmp(ptes[i].partition_type_guid,
+				 PARTITION_WINDOWS_RESERVED))
+			continue;
+#endif
+		put_partition(state, ++part_num, start * ssz, size * ssz);
 
 		/* If this is a RAID volume, tell md */
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
 				 PARTITION_LINUX_RAID_GUID))
-			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
+			state->parts[part_num].flags = ADDPART_FLAG_RAID;
 
-		info = &state->parts[i + 1].info;
+		info = &state->parts[part_num].info;
 		/* Instead of doing a manual swap to big endian, reuse the
 		 * common ASCII hex format as the interim.
 		 */
@@ -666,7 +671,7 @@ int efi_partition(struct parsed_partitions *state)
 			info->volname[label_count] = c;
 			label_count++;
 		}
-		state->parts[i + 1].has_info = true;
+		state->parts[part_num].has_info = true;
 	}
 	kfree(ptes);
 	kfree(gpt);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2362a0b..44fbe4d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -236,6 +236,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 #define LINUX_EFI_CRASH_GUID \
     EFI_GUID(  0xcfc8fc79, 0xbe2e, 0x4ddc, 0x97, 0xf0, 0x9f, 0x98, 0xbf, 0xe2, 0x98, 0xa0 )
 
+#define PARTITION_WINDOWS_RESERVED \
+    EFI_GUID(0xE3C9E316, 0x0B5C, 0x4DB8, 0x81, 0x7D, 0xF9, 0x2D, 0xF0, 0x02, 0x15, 0xAE)
+
 typedef struct {
 	efi_guid_t guid;
 	unsigned long table;
-- 
1.7.4.4

