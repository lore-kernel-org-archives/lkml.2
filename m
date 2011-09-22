Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1IVPfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:35:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:47926 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1IVPfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:35:30 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] mmc : general purpose partition support.
Date: Fri, 23 Sep 2011 00:34:40 +0900
Message-Id: <1316705680-1940-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows general purpose parition in MMC Device. If it is enable, it will make mmcblk0gp1,gp2,gp3,gp4 partition like this.

>cat /proc/paritition
      179 0 847872 mmcblk0
      179 192 4096 mmcblk0gp4
      179 160 4096 mmcblk0gp3
      179 128 4096 mmcblk0gp2
      179 96  1052672 mmcblk0gp1
      179 64  1024 mmcblk0boot1
      179 32  1024 mmcblk0boot0

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/mmc/card/block.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/mmc.c   |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    4 ++++
 include/linux/mmc/mmc.h  |    4 ++++
 4 files changed, 86 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 9b90726..074ec55 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1402,6 +1402,42 @@ static int mmc_blk_alloc_parts(struct mmc_card *card, struct mmc_blk_data *md)
 			return ret;
 	}
 
+	if (card->ext_csd.gp1_size) {
+		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_GP1,
+					card->ext_csd.gp1_size >> 9,
+					false,
+					"gp1");
+		if (ret)
+			return ret;
+	}
+
+	if (card->ext_csd.gp2_size) {
+		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_GP2,
+					card->ext_csd.gp2_size >> 9,
+					false,
+					"gp2");
+		if (ret)
+			return ret;
+	}
+
+	if (card->ext_csd.gp3_size) {
+		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_GP3,
+					card->ext_csd.gp3_size >> 9,
+					false,
+					"gp3");
+		if (ret)
+			return ret;
+	}
+
+	if (card->ext_csd.gp4_size) {
+		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_GP4,
+					card->ext_csd.gp4_size >> 9,
+					false,
+					"gp4");
+		if (ret)
+			return ret;
+	}
+
 	return ret;
 }
 
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 10f5a19..cc31511 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -393,6 +393,48 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 			card->ext_csd.enhanced_area_offset = -EINVAL;
 			card->ext_csd.enhanced_area_size = -EINVAL;
 		}
+
+		/*
+		 * General purpose partition Support
+		 */
+
+		if (ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x1) {
+
+			u8 hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			u8 hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+			card->ext_csd.enhanced_area_en = 1;
+
+			card->ext_csd.gp1_size =
+				(ext_csd[145] << 16) + (ext_csd[144] << 8) +
+				ext_csd[143];
+			card->ext_csd.gp1_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+			card->ext_csd.gp1_size <<= 19;
+
+			card->ext_csd.gp2_size =
+				(ext_csd[148] << 16) + (ext_csd[147] << 8) +
+				ext_csd[146];
+			card->ext_csd.gp2_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+				card->ext_csd.gp2_size <<= 19;
+
+			card->ext_csd.gp3_size =
+				(ext_csd[151] << 16) + (ext_csd[150] << 8) +
+				ext_csd[149];
+			card->ext_csd.gp3_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+			card->ext_csd.gp3_size <<= 19;
+
+			card->ext_csd.gp4_size =
+				(ext_csd[154] << 16) + (ext_csd[153] << 8) +
+				ext_csd[152];
+			card->ext_csd.gp4_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+			card->ext_csd.gp4_size <<= 19;
+		}
 		card->ext_csd.sec_trim_mult =
 			ext_csd[EXT_CSD_SEC_TRIM_MULT];
 		card->ext_csd.sec_erase_mult =
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index b460fc2..96a98a7 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -64,6 +64,10 @@ struct mmc_ext_csd {
 	unsigned long long	enhanced_area_offset;	/* Units: Byte */
 	unsigned int		enhanced_area_size;	/* Units: KB */
 	unsigned int		boot_size;		/* in bytes */
+	unsigned int		gp1_size;		/* in bytes */
+	unsigned int		gp2_size;		/* in bytes */
+	unsigned int		gp3_size;		/* in bytes */
+	unsigned int		gp4_size;		/* in bytes */
 	u8			raw_partition_support;	/* 160 */
 	u8			raw_erased_mem_count;	/* 181 */
 	u8			raw_ext_csd_structure;	/* 194 */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 5a794cb..380720a 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -303,6 +303,10 @@ struct _mmc_csd {
 #define EXT_CSD_PART_CONFIG_ACC_MASK	(0x7)
 #define EXT_CSD_PART_CONFIG_ACC_BOOT0	(0x1)
 #define EXT_CSD_PART_CONFIG_ACC_BOOT1	(0x2)
+#define EXT_CSD_PART_CONFIG_ACC_GP1	(0x4)
+#define EXT_CSD_PART_CONFIG_ACC_GP2	(0x5)
+#define EXT_CSD_PART_CONFIG_ACC_GP3	(0x6)
+#define EXT_CSD_PART_CONFIG_ACC_GP4	(0x7)
 
 #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
 #define EXT_CSD_CMD_SET_SECURE		(1<<1)
-- 
1.7.4.4

