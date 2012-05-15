Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965960Ab2EORLc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:11:32 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965936Ab2EORL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:11:27 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: tglx@linutronix.de, dedekind1@gmail.com, linux-kernel@vger.kernel.org,
        Heinz.Egger@linutronix.de, tim.bird@am.sony.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 3/7] [RFC] UBI: Add fastmap on-flash layout
Date: Tue, 15 May 2012 19:11:07 +0200
Message-Id: <1337101871-31181-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1337101871-31181-1-git-send-email-richard@nod.at>
References: <1337101871-31181-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specifies the fastmap on-flash layout.
The fastmap on-flash data structure consists of two major parts.
A super block (identified via UBI_FM_SB_VOLUME_ID) and
zero or more data blocks (identified via UBI_Fm_DATA_VOLUME_ID).
Data blocks are only used if whole checkpoint information does not fit
into the super block.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi-media.h |  124 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/mtd/ubi/ubi-media.h b/drivers/mtd/ubi/ubi-media.h
index 6fb8ec2..a23196f 100644
--- a/drivers/mtd/ubi/ubi-media.h
+++ b/drivers/mtd/ubi/ubi-media.h
@@ -375,4 +375,128 @@ struct ubi_vtbl_record {
 	__be32  crc;
 } __packed;
 
+/* UBI fastmap on-flash data structures */
+
+#define UBI_FM_SB_VOLUME_ID	(UBI_LAYOUT_VOLUME_ID + 1)
+#define UBI_FM_DATA_VOLUME_ID	(UBI_LAYOUT_VOLUME_ID + 2)
+
+/* fastmap on-flash data structure format version */
+#define UBI_FM_FMT_VERSION	1
+
+#define UBI_FM_SB_MAGIC		0x7B11D69F
+#define UBI_FM_HDR_MAGIC	0xD4B82EF7
+#define UBI_FM_VHDR_MAGIC	0xFA370ED1
+#define UBI_FM_POOL_MAGIC	0x67AF4D08
+#define UBI_FM_EBA_MAGIC	0xf0c040a8
+
+/* Semi-sane default values - TBR */
+#ifndef UBI_FM_MAX_POOL_SIZE
+#define UBI_FM_MAX_POOL_SIZE	128
+#endif
+#ifndef UBI_FM_MAX_BLOCKS
+#define UBI_FM_MAX_BLOCKS	32
+#endif
+#ifndef UBI_FM_MAX_START
+#define UBI_FM_MAX_START	64
+#endif
+
+/**
+ * struct ubi_fm_sb - UBI fastmap super block
+ * @magic: fastmap super block magic number (%UBI_FM_SB_MAGIC)
+ * @version: format version of this fastmap
+ * @data_crc: CRC over the fastmap data
+ * @nblocks: number of PEBs used by this fastmap
+ * @block_loc: an array containing the location of all PEBs of the fastmap
+ * @block_ec: the erase counter of each used PEB
+ * @sqnum: highest sequence number value at the time while taking the fastmap
+ *
+ */
+struct ubi_fm_sb {
+	__be32 magic;
+	__u8 version;
+	__u8 padding1[3];
+	__be32 data_crc;
+	__be32 nblocks;
+	__be32 block_loc[UBI_FM_MAX_BLOCKS];
+	__be32 block_ec[UBI_FM_MAX_BLOCKS];
+	__be64 sqnum;
+	__u8 padding2[32];
+} __packed;
+
+/**
+ * struct ubi_fm_hdr - header of the fastmap data set
+ * @magic: fastmap header magic number (%UBI_FM_HDR_MAGIC)
+ * @nfree: number of free PEBs known by this fastmap
+ * @nused: number of used PEBs known by this fastmap
+ * @nvol: number of UBI volumes known by this fastmap
+ */
+struct ubi_fm_hdr {
+	__be32 magic;
+	__be32 nfree;
+	__be32 nused;
+	__be32 nvol;
+	__u8 padding[16];
+} __packed;
+
+/* struct ubi_fm_hdr is followed by struct ubi_fm_scan_pool */
+
+/**
+ * struct ubi_fm_scan_pool - Fastmap pool PEBs to be scanned while attaching
+ * @magic: pool magic numer (%UBI_FM_POOL_MAGIC)
+ * @size: current pool size
+ * @pebs: an array containing the location of all PEBs in this pool
+ */
+struct ubi_fm_scan_pool {
+	__be32 magic;
+	__be32 size;
+	__be32 pebs[UBI_FM_MAX_POOL_SIZE];
+	__be32 padding[4];
+} __packed;
+
+/* struct ubi_fm_scan_pool is followed by nfree+nused struct ubi_fm_ec records */
+
+/**
+ * struct ubi_fm_ec - stores the erase counter of a PEB
+ * @pnum: PEB number
+ * @ec: ec of this PEB
+ */
+struct ubi_fm_ec {
+	__be32 pnum;
+	__be32 ec;
+} __packed;
+
+/**
+ * struct ubi_fm_volhdr - Fastmap volume header
+ * it identifies the start of an eba table
+ * @magic: Fastmap volume header magic number (%UBI_FM_VHDR_MAGIC)
+ * @vol_id: volume id of the fastmapped volume
+ * @vol_type: type of the fastmapped volume
+ * @data_pad: data_pad value of the fastmapped volume
+ * @used_ebs: number of used LEBs within this volume
+ * @last_eb_bytes: number of bytes used in the last LEB
+ */
+struct ubi_fm_volhdr {
+	__be32 magic;
+	__be32 vol_id;
+	__u8 vol_type;
+	__u8 padding1[3];
+	__be32 data_pad;
+	__be32 used_ebs;
+	__be32 last_eb_bytes;
+	__u8 padding2[8];
+} __packed;
+
+/* struct ubi_fm_volhdr is followed by one struct ubi_fm_eba records */
+
+/**
+ * struct ubi_fm_eba - denotes an association beween a PEB and LEB
+ * @magic EBA table magic number
+ * @nused: number of table entries
+ * @pnum: PEB number of LEB (LEB is the index)
+ */
+struct ubi_fm_eba {
+	__be32 magic;
+	__be32 nused;
+	__be32 pnum[0];
+} __packed;
 #endif /* !__UBI_MEDIA_H__ */
-- 
1.7.6.5

