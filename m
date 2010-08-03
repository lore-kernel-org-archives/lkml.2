Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0HCCxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:53:10 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54894 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0HCCxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:53:09 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Will Drewry <wad@chromium.org>
Subject: [PATCH v2 RFC] efi: add and expose efi_partition_by_guid
Date: Mon,  2 Aug 2010 21:52:46 -0500
Message-Id: <1280803966-11603-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20100802.160057.91342787.davem@davemloft.net>
References: <20100802.160057.91342787.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EFI's GPT partitioning scheme expects that all partitions have a unique
identifiers.  After initial partition scanning, this information is
completely lost to the rest of the kernel.

efi_partition_by_guid exposes GPT parsing support in a limited fashion
to allow other portions of the kernel to map a partition from GUID to
map.

This change is motivated the desire to have the ability to specify a
UUID argument to a device mapper target allowing it to select the device
by the UUID.

Change against Linus's tree: 9fe6206f400646a2322096b56c59891d530e8d51

Signed-off-by: Will Drewry <wad@chromium.org>

v2: pr_debug(KERN_WARNING -> pr_debug(. joe@perches.com
    moved down trailing {. davem@davemloft.net
---
 fs/partitions/efi.c |   61 +++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h |    5 ++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/efi.c b/fs/partitions/efi.c
index 9efb2cf..8669c4f 100644
--- a/fs/partitions/efi.c
+++ b/fs/partitions/efi.c
@@ -633,3 +633,64 @@ int efi_partition(struct parsed_partitions *state)
 	printk("\n");
 	return 1;
 }
+
+/**
+ * efi_partition_by_guid
+ * @bdev:	Whole block device to scan for a GPT.
+ * @guid:	Unique identifier for the partition to find.
+ *
+ * N.b., returns on the first match since it should be unique.
+ *
+ * Returns:
+ * -1 if an error occurred
+ *  0 if there was no match (or not GPT)
+ *  >=1 is the index of the partition found.
+ *
+ */
+int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid) {
+	gpt_header *gpt = NULL;
+	gpt_entry *ptes = NULL;
+	u32 i;
+	struct parsed_partitions *state;
+	int part = 0;
+
+	if (!bdev || !guid)
+		return -1;
+
+	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
+	if (!state)
+		return -1;
+
+	state->limit = disk_max_parts(bdev->bd_disk);
+	pr_debug("efi_find_partition looking for gpt\n");
+
+	state->bdev = bdev;
+	if (!find_valid_gpt(state,  &gpt, &ptes) || !gpt || !ptes) {
+		pr_debug("efi_find_partition no GPT\n");
+		kfree(gpt);
+		kfree(ptes);
+		kfree(state);
+		return 0;
+	}
+
+	pr_debug("GUID Partition Table is valid!  Yea!\n");
+	pr_debug("efi_find_partition: 0 -> %d (limit:%d)\n",
+		 le32_to_cpu(gpt->num_partition_entries),
+		 state->limit);
+	for (i = 0; i < le32_to_cpu(gpt->num_partition_entries) &&
+		    i < state->limit-1; i++) {
+		if (!is_pte_valid(&ptes[i], last_lba(bdev)))
+			continue;
+
+		/* Bails on first hit so duped "unique" GUIDs will be FCFS. */
+		if (!efi_guidcmp(ptes[i].unique_partition_guid,
+				 *guid)) {
+			part = i + 1;
+			break;
+		}
+	}
+	kfree(ptes);
+	kfree(gpt);
+	kfree(state);
+	return part;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index fb737bc..1a77259 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -301,6 +301,11 @@ extern unsigned long efi_get_time(void);
 extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern struct efi_memory_map memmap;
 
+#ifdef CONFIG_EFI_PARTITION
+struct block_device;
+extern int efi_partition_by_guid(struct block_device *bdev, efi_guid_t *guid);
+#endif
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
-- 
1.7.0.4

