Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933507Ab2HVXCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:02:39 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49458 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab2HVXCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:02:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Will Drewry <wad@chromium.org>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        cross-distro@lists.linaro.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/3] block: partition: msdos: provide UUIDs for partitions
Date: Wed, 22 Aug 2012 17:02:04 -0600
Message-Id: <1345676524-24450-3-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1345676524-24450-1-git-send-email-swarren@wwwdotorg.org>
References: <1345676524-24450-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

The MSDOS/MBR partition table includes a 32-bit unique ID, often referred
to as the NT disk signature. When combined with a partition number within
the table, this can form a unique ID similar in concept to EFI/GPT's
partition UUID. Constructing and recording this value in struct
partition_meta_info allows MSDOS partitions to be referred to on the
kernel command-line using the following syntax:

root=PARTUUID=0002dd75-01

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 block/partitions/msdos.c |   21 +++++++++++++++++++--
 init/do_mounts.c         |    4 ++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/block/partitions/msdos.c b/block/partitions/msdos.c
index 5f79a66..8752a5d 100644
--- a/block/partitions/msdos.c
+++ b/block/partitions/msdos.c
@@ -94,6 +94,17 @@ static int aix_magic_present(struct parsed_partitions *state, unsigned char *p)
 	return ret;
 }
 
+static void set_info(struct parsed_partitions *state, int slot,
+		     u32 disksig)
+{
+	struct partition_meta_info *info = &state->parts[slot].info;
+
+	snprintf(info->uuid, sizeof(info->uuid), "%08x-%02x", disksig,
+		 slot);
+	info->volname[0] = 0;
+	state->parts[slot].has_info = true;
+}
+
 /*
  * Create devices for each logical partition in an extended partition.
  * The logical partitions form a linked list, with each entry being
@@ -106,7 +117,8 @@ static int aix_magic_present(struct parsed_partitions *state, unsigned char *p)
  */
 
 static void parse_extended(struct parsed_partitions *state,
-			   sector_t first_sector, sector_t first_size)
+			   sector_t first_sector, sector_t first_size,
+			   u32 disksig)
 {
 	struct partition *p;
 	Sector sect;
@@ -166,6 +178,7 @@ static void parse_extended(struct parsed_partitions *state,
 			}
 
 			put_partition(state, state->next, next, size);
+			set_info(state, state->next, disksig);
 			if (SYS_IND(p) == LINUX_RAID_PARTITION)
 				state->parts[state->next].flags = ADDPART_FLAG_RAID;
 			loopct = 0;
@@ -437,6 +450,7 @@ int msdos_partition(struct parsed_partitions *state)
 	struct partition *p;
 	struct fat_boot_sector *fb;
 	int slot;
+	u32 disksig;
 
 	data = read_part_sector(state, 0, &sect);
 	if (!data)
@@ -491,6 +505,8 @@ int msdos_partition(struct parsed_partitions *state)
 #endif
 	p = (struct partition *) (data + 0x1be);
 
+	disksig = le32_to_cpup((__le32 *)(data + 0x1b8));
+
 	/*
 	 * Look for partitions in two passes:
 	 * First find the primary and DOS-type extended partitions.
@@ -515,11 +531,12 @@ int msdos_partition(struct parsed_partitions *state)
 			put_partition(state, slot, start, n);
 
 			strlcat(state->pp_buf, " <", PAGE_SIZE);
-			parse_extended(state, start, size);
+			parse_extended(state, start, size, disksig);
 			strlcat(state->pp_buf, " >", PAGE_SIZE);
 			continue;
 		}
 		put_partition(state, slot, start, size);
+		set_info(state, slot, disksig);
 		if (SYS_IND(p) == LINUX_RAID_PARTITION)
 			state->parts[slot].flags = ADDPART_FLAG_RAID;
 		if (SYS_IND(p) == DM6_PARTITION)
diff --git a/init/do_mounts.c b/init/do_mounts.c
index fcbe825..b6aa632 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -189,6 +189,10 @@ done:
  *	   used when disk name of partitioned disk ends on a digit.
  *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
+ *	   The UUID may be either an EFI/GPT UUID, or refer to an MSDOS
+ *	   partition using the format SSSSSSSS-PP, where SSSSSSSS is a zero-
+ *	   filled hex representation of the 32-bit "NT disk signature", and PP
+ *	   is a zero-filled hex representation of the 1-based partition number.
  *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
  *	   a partition with a known unique id.
  *
-- 
1.7.0.4

