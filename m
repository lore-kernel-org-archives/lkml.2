Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760624Ab2EIRk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:40:29 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756617Ab2EIRjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:39:08 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tim.bird@am.sony.com, tglx@linutronix.de, dedekind1@gmail.com,
        linux-kernel@vger.kernel.org, Heinz.Egger@linutronix.de,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/7] [RFC] UBI: Add checkpoint on-chip layout
Date: Wed,  9 May 2012 19:38:39 +0200
Message-Id: <1336585125-127220-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1336585125-127220-1-git-send-email-richard@nod.at>
References: <1336585125-127220-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify the on-chip checkpoint layout.
The checkpoint consists of two major parts.
A super block (identified via UBI_CP_SB_VOLUME_ID) and
zero or more data blocks (identified via UBI_CP_DATA_VOLUME_ID).
Data blocks are only used if whole checkpoint information does not fit
into the super block.

All three checkpointing pools have the same size for now, this my also change.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi-media.h |  135 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 6fb8ec2..7223b02 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -375,4 +375,139 @@ struct ubi_vtbl_record {
 	__be32  crc;
 } __packed;
 
+#ifdef CONFIG_MTD_UBI_CHECKPOINT
+#define UBI_CP_SB_VOLUME_ID	(UBI_LAYOUT_VOLUME_ID + 1)
+#define UBI_CP_DATA_VOLUME_ID	(UBI_CP_SB_VOLUME_ID + 1)
+
+/* Checkoint format version */
+#define UBI_CP_FMT_VERSION	1
+
+#define UBI_CP_MAX_START	64
+#define UBI_CP_MAX_BLOCKS	32
+#define UBI_CP_MAX_POOL_SIZE	128
+#define UBI_CP_SB_MAGIC		0x7B11D69F
+#define UBI_CP_HDR_MAGIC	0xD4B82EF7
+#define UBI_CP_VHDR_MAGIC	0xFA370ED1
+#define UBI_CP_LPOOL_MAGIC	0x67AF4D08
+#define UBI_CP_SPOOL_MAGIC	0x67AF4D09
+#define UBI_CP_UPOOL_MAGIC	0x67AF4D0A
+
+/**
+ * struct ubi_cp_sb - UBI checkpoint super block
+ * @magic: checkpoint super block magic number (%UBI_CP_SB_MAGIC)
+ * @version: format version of this checkpoint
+ * @data_crc: CRC over the checkpoint data
+ * @nblocks: number of PEBs used by this checkpoint
+ * @block_loc: an array containing the location of all PEBs of the checkpoint
+ * @block_ec: the erase counter of each used PEB
+ * @sqnum: highest sequence number value at the time while taking the checkpoint
+ *
+ * The checkpoint
+ */
+struct ubi_cp_sb {
+	__be32 magic;
+	__u8 version;
+	__be32 data_crc;
+	__be32 nblocks;
+	__be32 block_loc[UBI_CP_MAX_BLOCKS];
+	__be32 block_ec[UBI_CP_MAX_BLOCKS];
+	__be64 sqnum;
+} __packed;
+
+/**
+ * struct ubi_cp_hdr - header of the checkpoint data set
+ * @magic: checkpoint header magic number (%UBI_CP_HDR_MAGIC)
+ * @nfree: number of free PEBs known by this checkpoint
+ * @nused: number of used PEBs known by this checkpoint
+ * @nvol: number of UBI volumes known by this checkpoint
+ */
+struct ubi_cp_hdr {
+	__be32 magic;
+	__be32 nfree;
+	__be32 nused;
+	__be32 nvol;
+} __packed;
+
+/* struct ubi_cp_hdr is followed by exactly three struct ub_cp_pool_* records
+ * long, short and unknown pool */
+
+/**
+ * struct ubi_cp_long_pool - Checkpoint pool with long term used PEBs
+ * @magic: long pool magic numer (%UBI_CP_LPOOL_MAGIC)
+ * @size: current pool size
+ * @pebs: an array containing the location of all PEBs in this pool
+ */
+struct ubi_cp_long_pool {
+	__be32 magic;
+	__be32 size;
+	__be32 pebs[UBI_CP_MAX_POOL_SIZE];
+} __packed;
+
+/**
+ * struct ubi_cp_short_pool - Checkpoint pool with short term used PEBs
+ * @magic: long pool magic numer (%UBI_CP_SPOOL_MAGIC)
+ * @size: current pool size
+ * @pebs: an array containing the location of all PEBs in this pool
+ */
+struct ubi_cp_short_pool {
+	__be32 magic;
+	__be32 size;
+	__be32 pebs[UBI_CP_MAX_POOL_SIZE];
+} __packed;
+
+/**
+ * struct ubi_cp_unk_pool - Checkpoint pool with all other PEBs
+ * @magic: long pool magic numer (%UBI_CP_UPOOL_MAGIC)
+ * @size: current pool size
+ * @pebs: an array containing the location of all PEBs in this pool
+ */
+struct ubi_cp_unk_pool {
+	__be32 magic;
+	__be32 size;
+	__be32 pebs[UBI_CP_MAX_POOL_SIZE];
+} __packed;
+
+/* struct ubi_cp_unk_pool is followed by nfree+nused struct ubi_cp_ec records */
+
+/**
+ * struct ubi_cp_ec - stores the erase counter of a PEB
+ * @pnum: PEB number
+ * @ec: ec of this PEB
+ */
+struct ubi_cp_ec {
+	__be32 pnum;
+	__be32 ec;
+} __packed;
+
+/**
+ * struct ubi_cp_volhdr - checkpoint volume header
+ * it identifies the start of an eba table
+ * @magic: checkpoint volume header magic number (%UBI_CP_VHDR_MAGIC)
+ * @vol_id: volume id of the checkpointed volume
+ * @vol_type: type of the checkpointed volume
+ * @data_pad: data_pad value of the checkpointed volume
+ * @used_ebs: number of used LEBs within this volume
+ * @last_eb_bytes: number of bytes used in the last LEB
+ */
+struct ubi_cp_volhdr {
+	__be32 magic;
+	__be32 vol_id;
+	__u8 vol_type;
+	__be32 data_pad;
+	__be32 used_ebs;
+	__be32 last_eb_bytes;
+} __packed;
+
+/* struct ubi_cp_volhdr is followed by nused struct ubi_cp_eba records */
+
+/**
+ * struct ubi_cp_eba - denotes an association beween a PEB and LEB
+ * @lnum: LEB number
+ * @pnum: PEB number
+ */
+struct ubi_cp_eba {
+	__be32 lnum;
+	__be32 pnum;
+} __packed;
+#endif /* CONFIG_MTD_UBI_CHECKPOINT */
 #endif /* !__UBI_MEDIA_H__ */
-- 
1.7.6.5

