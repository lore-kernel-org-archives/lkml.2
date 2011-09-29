Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab1I2PRk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:17:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56093 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab1I2PRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:17:39 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com,
        adrian.hunter@intel.com, linus.walleij@linaro.org,
        james_p_freyensee@linux.intel.com, sebras@gmail.com,
        Ulf.Hansson@stericsson.com, stefan.xk.nilsson@stericsson.com,
        per.forlin@stericsson.com, johan.rudholm@stericsson.com,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v3] mmc : general purpose partition support.
Date: Fri, 30 Sep 2011 00:17:11 +0900
Message-Id: <1317309431-1898-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It allows gerneral purpose partitions in MMC Device.
And I try to simpliy make mmc_blk_alloc_parts using mmc_part structure suggested by Andrei Warkentin.
After patching, we can see general purpose partitions like this.
> cat /proc/partitions
              179 0 847872 mmcblk0
              179 192 4096 mmcblk0gp3
              179 160 4096 mmcblk0gp2
              179 128 4096 mmcblk0gp1
              179 96  1052672 mmcblk0gp0
              179 64  1024 mmcblk0boot1
              179 32  1024 mmcblk0boot0

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 drivers/mmc/card/block.c |   43 ++++++++++++++++++++++++++------------
 drivers/mmc/core/mmc.c   |   51 ++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/card.h |   20 +++++++++++++++++-
 include/linux/mmc/mmc.h  |   13 +++++++++--
 4 files changed, 107 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1ff5486..e48529c 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1377,26 +1377,41 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
 	return 0;
 }
 
+/* MMC Physical partition consist of two boot partitons and
+ * four general purpose partitions.
+ * if the register of respective partitions is set in ext_csd,
+ * it allocate block device to be accessed.
+ */
+
 static int mmc_blk_alloc_parts(struct mmc_card *card, struct mmc_blk_data *md)
 {
-	int ret = 0;
+	int idx, ret = 0;
 
 	if (!mmc_card_mmc(card))
 		return 0;
 
-	if (card->ext_csd.boot_size) {
-		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_BOOT0,
-					 card->ext_csd.boot_size >> 9,
-					 true,
-					 "boot0");
-		if (ret)
-			return ret;
-		ret = mmc_blk_alloc_part(card, md, EXT_CSD_PART_CONFIG_ACC_BOOT1,
-					 card->ext_csd.boot_size >> 9,
-					 true,
-					 "boot1");
-		if (ret)
-			return ret;
+	 for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
+		if (card->boot_part[idx].size) {
+			ret = mmc_blk_alloc_part(card, md,
+				card->boot_part[idx].cookie,
+				card->boot_part[idx].size >> 9,
+				card->boot_part[idx].force_ro,
+				card->boot_part[idx].name);
+			if (ret)
+				return ret;
+		}
+	}
+
+	for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
+		if (card->gp_part[idx].size) {
+			ret = mmc_blk_alloc_part(card, md,
+				card->gp_part[idx].cookie,
+				card->gp_part[idx].size >> 9,
+				card->gp_part[idx].force_ro,
+				card->gp_part[idx].name);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return ret;
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 5700b1c..b36b906 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -239,7 +239,7 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
  */
 static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 {
-	int err = 0;
+	int err = 0, idx, part_cfg, gp_size_mult;
 
 	BUG_ON(!card);
 
@@ -340,7 +340,17 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		 * There are two boot regions of equal size, defined in
 		 * multiples of 128K.
 		 */
-		card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
+		if (ext_csd[EXT_CSD_BOOT_MULT])	{
+			part_cfg = EXT_CSD_PART_CONFIG_ACC_BOOT0;
+			for (idx = 0; idx < MMC_NUM_BOOT_PARTITION; idx++) {
+				card->boot_part[idx].size =
+					ext_csd[EXT_CSD_BOOT_MULT] << 17;
+				card->boot_part[idx].cookie = part_cfg++;
+				sprintf(card->boot_part[idx].name, "boot%d",
+					idx);
+				card->boot_part[idx].force_ro = true;
+			}
+		}
 	}
 
 	card->ext_csd.raw_hc_erase_gap_size =
@@ -392,6 +402,43 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 			card->ext_csd.enhanced_area_offset = -EINVAL;
 			card->ext_csd.enhanced_area_size = -EINVAL;
 		}
+
+		/*
+		 * General purpose partition feature support --
+		 * If ext_csd have the size of general purpose partitions,
+		 * set size, part_type, partition name in mmc_part.
+		 */
+
+		if (ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x1) {
+			u8 hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			u8 hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+			card->ext_csd.enhanced_area_en = 1;
+
+			part_cfg = EXT_CSD_PART_CONFIG_ACC_GP0;
+			for (idx = 0, gp_size_mult = 143;
+				idx < MMC_NUM_GP_PARTITION; idx++,
+				gp_size_mult += 3) {
+				if (!ext_csd[gp_size_mult] &&
+					!ext_csd[gp_size_mult + 1] &&
+					!ext_csd[gp_size_mult + 2])
+						continue;
+				card->gp_part[idx].size =
+					(ext_csd[gp_size_mult + 2] << 16) +
+					(ext_csd[gp_size_mult + 1] << 8) +
+					ext_csd[gp_size_mult];
+				card->gp_part[idx].size *=
+					(size_t)(hc_erase_grp_sz *
+					hc_wp_grp_sz);
+				card->gp_part[idx].size <<= 19;
+				card->gp_part[idx].cookie = part_cfg++;
+				sprintf(card->gp_part[idx].name,
+					"gp%d", idx);
+				card->gp_part[idx].force_ro = false;
+			}
+		}
 		card->ext_csd.sec_trim_mult =
 			ext_csd[EXT_CSD_SEC_TRIM_MULT];
 		card->ext_csd.sec_erase_mult =
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index b460fc2..aa67bf8 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -12,6 +12,7 @@
 
 #include <linux/mmc/core.h>
 #include <linux/mod_devicetable.h>
+#include <linux/genhd.h>
 
 struct mmc_cid {
 	unsigned int		manfid;
@@ -63,7 +64,6 @@ struct mmc_ext_csd {
 	bool			enhanced_area_en;	/* enable bit */
 	unsigned long long	enhanced_area_offset;	/* Units: Byte */
 	unsigned int		enhanced_area_size;	/* Units: KB */
-	unsigned int		boot_size;		/* in bytes */
 	u8			raw_partition_support;	/* 160 */
 	u8			raw_erased_mem_count;	/* 181 */
 	u8			raw_ext_csd_structure;	/* 194 */
@@ -157,6 +157,22 @@ struct sdio_func_tuple;
 
 #define SDIO_MAX_FUNCS		7
 
+/* The number of MMC physical partitions
+ * It consist of boot partitions(2), general purpose partitions(4) in MMC v4.4
+ */
+#define MMC_NUM_BOOT_PARTITION	2
+#define MMC_NUM_GP_PARTITION	4
+
+/*
+ * MMC Physical partitions
+ */
+struct mmc_part {
+	unsigned int	size;	/* partition size (in bytes) */
+	unsigned int	cookie;	/* it used to part_type */
+	char	name[DISK_NAME_LEN];
+	bool	force_ro;	/* to make boot parts RO by default */
+};
+
 /*
  * MMC device
  */
@@ -216,6 +232,8 @@ struct mmc_card {
 	unsigned int		sd_bus_speed;	/* Bus Speed Mode set for the card */
 
 	struct dentry		*debugfs_root;
+	struct mmc_part	boot_part[MMC_NUM_BOOT_PARTITION];	/* mmc boot partitions */
+	struct mmc_part	gp_part[MMC_NUM_GP_PARTITION];	/* mmc general purpose partitions */
 };
 
 /*
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 5a794cb..41fe51a 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -300,9 +300,16 @@ struct _mmc_csd {
 
 #define EXT_CSD_WR_REL_PARAM_EN		(1<<2)
 
-#define EXT_CSD_PART_CONFIG_ACC_MASK	(0x7)
-#define EXT_CSD_PART_CONFIG_ACC_BOOT0	(0x1)
-#define EXT_CSD_PART_CONFIG_ACC_BOOT1	(0x2)
+enum {
+	EXT_CSD_PART_CONFIG_ACC_BOOT0 = 0x1,
+	EXT_CSD_PART_CONFIG_ACC_BOOT1,
+	EXT_CSD_PART_CONFIG_ACC_RPMB, /* not used yet. */
+	EXT_CSD_PART_CONFIG_ACC_GP0,
+	EXT_CSD_PART_CONFIG_ACC_GP1,
+	EXT_CSD_PART_CONFIG_ACC_GP2,
+	EXT_CSD_PART_CONFIG_ACC_GP3,
+	EXT_CSD_PART_CONFIG_ACC_MASK = 0x7
+};
 
 #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
 #define EXT_CSD_CMD_SET_SECURE		(1<<1)
-- 
1.7.4.4

