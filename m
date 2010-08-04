Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab0HDSXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:23:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65271 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556Ab0HDSXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 14:23:04 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Jens Axboe <axboe@kernel.dk>,
        Karel Zak <kzak@redhat.com>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jan Blunck <jblunck@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Will Drewry <wad@chromium.org>
Subject: [PATCH v3 2/3] genhd, efi: add efi partition metadata to hd_structs
Date: Wed,  4 Aug 2010 13:22:05 -0500
Message-Id: <1280946126-19587-2-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
References: <AANLkTi=b_zBigV8ePRPO1_qHpbMTALnCAV7v=dSTO5wc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change extends the partition_meta_info structure to
support EFI GPT-specific metadata and ensures that data
is copied in on partition scanning.

Signed-off-by: Will Drewry <wad@chromium.org>

v2: move info assignment after memcpy()s
    adds _MAX to the enum after EFI
v3: exports a generic uuid/volname format
---
 fs/partitions/efi.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 9efb2cf..427f2fb 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -94,6 +94,7 @@
  *
  ************************************************************/
 #include <linux/crc32.h>
+#include <linux/ctype.h>
 #include <linux/math64.h>
 #include <linux/slab.h>
 #include "check.h"
@@ -604,6 +605,7 @@ int efi_partition(struct parsed_partitions *state)
 	gpt_entry *ptes = NULL;
 	u32 i;
 	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
+	u8 unparsed_guid[37];
 
 	if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
 		kfree(gpt);
@@ -614,6 +616,9 @@ int efi_partition(struct parsed_partitions *state)
 	pr_debug("GUID Partition Table is valid!  Yea!\n");
 
 	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
+		struct partition_meta_info *info;
+		unsigned label_count = 0;
+		unsigned label_max;
 		u64 start = le64_to_cpu(ptes[i].starting_lba);
 		u64 size = le64_to_cpu(ptes[i].ending_lba) -
 			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
@@ -627,6 +632,26 @@ int efi_partition(struct parsed_partitions *state)
 		if (!efi_guidcmp(ptes[i].partition_type_guid,
 				 PARTITION_LINUX_RAID_GUID))
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
+
+		info = &state->parts[i + 1].info;
+		/* Instead of doing a manual swap to big endian, reuse the
+		 * common ASCII hex format as the interim.
+		 */
+		efi_guid_unparse(&ptes[i].unique_partition_guid, unparsed_guid);
+		part_pack_uuid(unparsed_guid, info->uuid);
+
+		/* Naively convert UTF16-LE to 7 bits. */
+		label_max = min(sizeof(info->volname) - 1,
+				sizeof(ptes[i].partition_name));
+		info->volname[label_max] = 0;
+		while (label_count < label_max) {
+			u8 c = ptes[i].partition_name[label_count] & 0xff;
+			if (c && !isprint(c))
+				c = '!';
+			info->volname[label_count] = c;
+			label_count++;
+		}
+		state->parts[i + 1].has_info = true;
 	}
 	kfree(ptes);
 	kfree(gpt);
-- 
1.7.0.4

