Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1JDQRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:17:55 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35005 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1JDQRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:17:54 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, awarkentin@vmware.com,
        adrian.hunter@intel.com, linus.walleij@linaro.org,
        james_p_freyensee@linux.intel.com, sebras@gmail.com,
        Ulf.Hansson@stericsson.com, stefan.xk.nilsson@stericsson.com,
        per.forlin@stericsson.com, johan.rudholm@stericsson.com,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v9] mmc : general purpose partition support.
Date: Wed,  5 Oct 2011 01:17:37 +0900
Message-Id: <1317745057-6328-1-git-send-email-linkinjeon@gmail.com>
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
 drivers/mmc/card/block.c |   31 +++++++++++++++------------
 drivers/mmc/core/mmc.c   |   52 ++++++++++++++++++++++++++++++++++++++++++---
 include/linux/mmc/card.h |   34 +++++++++++++++++++++++++++++-
 include/linux/mmc/mmc.h  |    5 +++-
 4 files changed, 102 insertions(+), 20 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 1ff5486..8452872 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1377,26 +1377,29 @@ static int mmc_blk_alloc_part(struct mmc_card *card,
 	return 0;
 }
 
+/* MMC Physical partition consist of two boot partitions and
+ * up to four general purpose partitions.
+ * For each partitions enabled in EXT_CSD
+ * The block device will allocated to provide access to the partition.
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
+	 for (idx = 0; idx < card->nr_parts; idx++) {
+		if (card->part[idx].size) {
+			ret = mmc_blk_alloc_part(card, md,
+				card->part[idx].part_cfg,
+				card->part[idx].size >> 9,
+				card->part[idx].force_ro,
+				card->part[idx].name);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return ret;
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 5700b1c..478b251 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -239,7 +239,9 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
  */
 static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 {
-	int err = 0;
+	int err = 0, idx;
+	unsigned int part_size;
+	u8 hc_erase_grp_sz = 0, hc_wp_grp_sz = 0;
 
 	BUG_ON(!card);
 
@@ -340,7 +342,15 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		 * There are two boot regions of equal size, defined in
 		 * multiples of 128K.
 		 */
-		card->ext_csd.boot_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
+		if (ext_csd[EXT_CSD_BOOT_MULT])	{
+			for (idx = 0; idx < MMC_NUM_BOOT_PARTITION;
+				idx++) {
+				part_size = ext_csd[EXT_CSD_BOOT_MULT] << 17;
+				mmc_part_add(card, part_size,
+					EXT_CSD_PART_CONFIG_ACC_BOOT0 + idx,
+					"boot%d", idx, true);
+			}
+		}
 	}
 
 	card->ext_csd.raw_hc_erase_gap_size =
@@ -361,9 +371,9 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		 */
 		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
 		    (ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
-			u8 hc_erase_grp_sz =
+			hc_erase_grp_sz =
 				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
-			u8 hc_wp_grp_sz =
+			hc_wp_grp_sz =
 				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
 
 			card->ext_csd.enhanced_area_en = 1;
@@ -392,6 +402,40 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 			card->ext_csd.enhanced_area_offset = -EINVAL;
 			card->ext_csd.enhanced_area_size = -EINVAL;
 		}
+
+		/*
+		 * General purpose partition feature support --
+		 * If ext_csd have the size of general purpose partitions,
+		 * set size, part_cfg, partition name in mmc_part.
+		 */
+
+		if (ext_csd[EXT_CSD_PARTITION_SUPPORT] &
+			EXT_CSD_PART_SUPPORT_PART_EN) {
+			if (card->ext_csd.enhanced_area_en != 1) {
+				hc_erase_grp_sz =
+					ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+				hc_wp_grp_sz =
+					ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+
+				card->ext_csd.enhanced_area_en = 1;
+			}
+
+			for (idx = 0; idx < MMC_NUM_GP_PARTITION; idx++) {
+				if (!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3] &&
+				!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] &&
+				!ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2])
+					continue;
+			part_size =
+			  (ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 2] << 16) +
+			  (ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3 + 1] << 8) +
+			  ext_csd[EXT_CSD_GP_SIZE_MULT + idx * 3];
+				part_size *= (size_t)(hc_erase_grp_sz *
+					hc_wp_grp_sz);
+				mmc_part_add(card, part_size << 19,
+					EXT_CSD_PART_CONFIG_ACC_GP0 + idx,
+					"gp%d", idx, false);
+			}
+		}
 		card->ext_csd.sec_trim_mult =
 			ext_csd[EXT_CSD_SEC_TRIM_MULT];
 		card->ext_csd.sec_erase_mult =
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index b460fc2..8e42573 100644
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
@@ -157,6 +157,23 @@ struct sdio_func_tuple;
 
 #define SDIO_MAX_FUNCS		7
 
+/* The number of MMC physical partitions
+ * It consist of boot partitions(2), general purpose partitions(4) in MMC v4.4
+ */
+#define MMC_NUM_BOOT_PARTITION	2
+#define MMC_NUM_GP_PARTITION	4
+#define MMC_NUM_PHY_PARTITION	6
+
+/*
+ * MMC Physical partitions
+ */
+struct mmc_part {
+	unsigned int	size;	/* partition size (in bytes) */
+	unsigned int	part_cfg;	/* it used to part_type */
+	char	name[DISK_NAME_LEN];
+	bool	force_ro;	/* to make boot parts RO by default */
+};
+
 /*
  * MMC device
  */
@@ -216,9 +233,24 @@ struct mmc_card {
 	unsigned int		sd_bus_speed;	/* Bus Speed Mode set for the card */
 
 	struct dentry		*debugfs_root;
+	struct mmc_part	part[MMC_NUM_PHY_PARTITION]; /* physical partitions */
+	unsigned int	nr_parts;
 };
 
 /*
+ * This function fill contents in mmc_part.
+ */
+static inline void mmc_part_add(struct mmc_card *card, unsigned int size,
+	unsigned int part_cfg, char *name, int idx, bool ro)
+{
+	card->part[card->nr_parts].size = size;
+	card->part[card->nr_parts].part_cfg = part_cfg;
+	sprintf(card->part[card->nr_parts].name, name, idx);
+	card->part[card->nr_parts].force_ro = ro;
+	card->nr_parts++;
+}
+
+/*
  *  The world is not perfect and supplies us with broken mmc/sdio devices.
  *  For at least some of these bugs we need a work-around.
  */
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 5a794cb..ac0422a 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -270,6 +270,7 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
 #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
 #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
 #define EXT_CSD_WR_REL_PARAM		166	/* RO */
@@ -302,7 +303,9 @@ struct _mmc_csd {
 
 #define EXT_CSD_PART_CONFIG_ACC_MASK	(0x7)
 #define EXT_CSD_PART_CONFIG_ACC_BOOT0	(0x1)
-#define EXT_CSD_PART_CONFIG_ACC_BOOT1	(0x2)
+#define EXT_CSD_PART_CONFIG_ACC_GP0	(0x4)
+
+#define EXT_CSD_PART_SUPPORT_PART_EN	(0x1)
 
 #define EXT_CSD_CMD_SET_NORMAL		(1<<0)
 #define EXT_CSD_CMD_SET_SECURE		(1<<1)
-- 
1.7.4.4

