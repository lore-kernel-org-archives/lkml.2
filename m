Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0HCCtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:49:07 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47409 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0HCCtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:49:04 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Will Drewry <wad@chromium.org>
Subject: [PATCH RFC (alt)] efi: add efi_partition_walk and expose for kernel access
Date: Mon,  2 Aug 2010 21:48:37 -0500
Message-Id: <1280803717-11233-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1280776623-1337-1-git-send-email-wad@chromium.org>
References: <1280776623-1337-1-git-send-email-wad@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

efi_partition_walk provides a generic mechanism for iterating over a partition
table using a callback over the GPT entry data.  However, it avoids exposing
too many internals while still providing less specialized access than the
previous patch.

The same questions apply - any and all feedback is truly appreciated.

I'll post an updated version of the original with feedback from Joe Perches and
David Miller shortly.

Signed-off-by: Will Drewry <wad@chromium.org>
---
 fs/partitions/efi.c |  123 ++++++++++++++++++++++++++++++++++++++-------------
 include/linux/efi.h |    9 ++++
 2 files changed, 101 insertions(+), 31 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 9efb2cf..cfb52ac 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -580,56 +580,117 @@ static int find_valid_gpt(struct parsed_partitions *state, gpt_header **gpt,
 }
 
 /**
- * efi_partition(struct parsed_partitions *state)
- * @state
+ * efi_partition_walk
+ * @bdev:	Whole block device to scan for a GPT.
+ * @walk_arg:	Opaque data to pass to the walker
+ * @walk:	Function to walk valid GPT entries
  *
- * Description: called from check.c, if the disk contains GPT
- * partitions, sets up partition entries in the kernel.
+ * If walk() returns non-zero, then the walk will terminate early.
  *
- * If the first block on the disk is a legacy MBR,
- * it will get handled by msdos_partition().
- * If it's a Protective MBR, we'll handle it here.
+ * We ignore the GPT entry so the first number refers to the first
+ * data partition.
  *
- * We do not create a Linux partition for GPT, but
- * only for the actual data partitions.
  * Returns:
- * -1 if unable to read the partition table
- *  0 if this isn't our partition table
- *  1 if successful
+ * -1   if an error occurred or unable to read
+ *  0   if there is no gpt entry
+ *  1   if traversal occurred (even if terminated early)
  *
  */
-int efi_partition(struct parsed_partitions *state)
+int efi_partition_walk(struct block_device *bdev, void *walk_arg,
+		       efi_partition_callback_t walk)
 {
 	gpt_header *gpt = NULL;
 	gpt_entry *ptes = NULL;
+	struct parsed_partitions *state = NULL;
+	unsigned ssz = 0;
 	u32 i;
-	unsigned ssz = bdev_logical_block_size(state->bdev) / 512;
 
-	if (!find_valid_gpt(state, &gpt, &ptes) || !gpt || !ptes) {
+	if (!bdev || !walk)
+		return -1;
+
+	ssz = bdev_logical_block_size(bdev) / 512;
+
+	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
+	if (!state)
+		return -1;
+	state->limit = disk_max_parts(bdev->bd_disk);
+	state->bdev = bdev;
+
+	pr_debug(KERN_WARNING "efi_find_partition looking for gpt\n");
+	if (!find_valid_gpt(state,  &gpt, &ptes) || !gpt || !ptes) {
+		pr_debug(KERN_WARNING "efi_find_partition no GPT\n");
 		kfree(gpt);
 		kfree(ptes);
+		kfree(state);
 		return 0;
 	}
 
-	pr_debug("GUID Partition Table is valid!  Yea!\n");
-
-	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) && i < state->limit-1; i++) {
-		u64 start = le64_to_cpu(ptes[i].starting_lba);
-		u64 size = le64_to_cpu(ptes[i].ending_lba) -
-			   le64_to_cpu(ptes[i].starting_lba) + 1ULL;
-
-		if (!is_pte_valid(&ptes[i], last_lba(state->bdev)))
+	pr_debug(KERN_WARNING "efi_find_partition: 0 -> %d (limit:%d)\n",
+		 le32_to_cpu(gpt->num_partition_entries),
+		 state->limit);
+	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
+		    i < state->limit-1; i++) {
+		/* Convert start and size to sectors from lbas */
+		sector_t start = le64_to_cpu(ptes[i].starting_lba) * ssz;
+		sector_t size = ssz * (le64_to_cpu(ptes[i].ending_lba) -
+			   le64_to_cpu(ptes[i].starting_lba) + 1ULL);
+		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
 			continue;
-
-		put_partition(state, i+1, start * ssz, size * ssz);
-
-		/* If this is a RAID volume, tell md */
-		if (!efi_guidcmp(ptes[i].partition_type_guid,
-				 PARTITION_LINUX_RAID_GUID))
-			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
+		if (walk(i+1,
+			 &ptes[i].partition_type_guid,
+			 &ptes[i].unique_partition_guid,
+			 start, size, walk_arg) != 0)
+			break;
 	}
 	kfree(ptes);
 	kfree(gpt);
-	printk("\n");
+	kfree(state);
 	return 1;
 }
+
+/**
+ * efi_partition_add
+ * @num:	current partition number
+ * @entry:	gpt_entry
+ * @arg:	void * to a struct parsed_partition *
+ *
+ * Callback for efi_partition().
+ */
+static int efi_partition_add(int num, efi_guid_t *partition_type_guid,
+	efi_guid_t *unique_partition_guid, sector_t start, sector_t size,
+	void *arg)
+{
+	struct parsed_partitions *state = arg;
+
+	put_partition(state, num, start, size);
+
+	/* If this is a RAID volume, tell md */
+	if (!efi_guidcmp(*partition_type_guid, PARTITION_LINUX_RAID_GUID))
+		state->parts[num].flags = 1;
+	return 0;
+}
+
+
+/**
+ * efi_partition(struct parsed_partitions *state)
+ * @state
+ *
+ * Description: called from check.c, if the disk contains GPT
+ * partitions, sets up partition entries in the kernel.
+ *
+ * If the first block on the disk is a legacy MBR,
+ * it will get handled by msdos_partition().
+ * If it's a Protective MBR, we'll handle it here.
+ *
+ * We do not create a Linux partition for GPT, but
+ * only for the actual data partitions.
+ * Returns:
+ * -1 if unable to read the partition table
+ *  0 if this isn't our partition table
+ *  1 if successful
+ *
+ */
+int efi_partition(struct parsed_partitions *state)
+{
+	return efi_partition_walk(state->bdev, state, efi_partition_add);
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fb737bc..15165bc 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -301,6 +301,15 @@ extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern struct efi_memory_map memmap;
 
+#ifdef CONFIG_EFI_PARTITION
+typedef int (*efi_partition_callback_t) (int num,
+	efi_guid_t *partition_type_guid, efi_guid_t *unique_partition_guid,
+	sector_t start, sector_t size, void *arg);
+struct block_device;
+int efi_partition_walk(struct block_device *bdev, void *walk_arg,
+		       efi_partition_callback_t walk);
+#endif
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.7.0.4

