Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1AMNCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 08:02:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:30263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab1AMNCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 08:02:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,317,1291622400"; 
   d="scan'208";a="877176205"
Date: Thu, 13 Jan 2011 20:57:27 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH v2 1/1]mmc: implemented eMMC4.4 enhanced area feature
Message-ID: <20110113125727.GA20452@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhanced area feature is a new feature defined in eMMC4.4 standard. This
kind of area can help to improve the performance.

MMC driver will read out the enhanced area offset and size and add them
to be device attributes. The feature enabling should be done in manufactory.
To use this feature, bit ERASE_GRP_DEF should also be set.

Documentation/ABI/testing/sysfs-devices-mmc described the two new attributes

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-mmc |   19 +++++++
 drivers/mmc/core/mmc.c                      |   73 +++++++++++++++++++++++++++
 include/linux/mmc/card.h                    |    3 +
 include/linux/mmc/mmc.h                     |    3 +
 4 files changed, 98 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-mmc

diff --git a/Documentation/ABI/testing/sysfs-devices-mmc b/Documentation/ABI/testing/sysfs-devices-mmc
new file mode 100644
index 0000000..f0fb053
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-mmc
@@ -0,0 +1,19 @@
+What:		/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_offset
+Date:		January 2011
+Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
+Description:
+		Enhanced area is a new feature defined in eMMC4.4 standard.
+		eMMC4.4 or later card can support such feature. This kind of area
+		can help to improve the card performance. If the feature is enabled,
+		this attribute will indicate the start address of enhanced data
+		area. If not, this attribute will be 0. Unit Byte.
+
+What:		/sys/devices/.../mmc_host/mmcX/mmcX:XXXX/enhanced_area_size
+Date:		January 2011
+Contact:	Chuanxiao Dong <chuanxiao.dong@intel.com>
+Description:
+		Enhanced area is a new feature defined in eMMC4.4 standard.
+		eMMC4.4 or later card can support such feature. This kind of area
+		can help to improve the card performance. If the feature is enabled,
+		this attribute will indicate the size of enhanced data area. If not,
+		this attribute will be 0. Unit KBytes.
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 16006ef..c8b5b3b 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -302,6 +302,41 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 	}
 
 	if (card->ext_csd.rev >= 4) {
+		/*
+		 * Enhanced area feature support
+		 * check whether eMMC card is enabled enhanced area,
+		 * if so, export enhanced area offset and size to
+		 * user by adding sysfs interface
+		 */
+		if ((ext_csd[EXT_CSD_PARTITION_SUPPORT] & 0x2) &&
+				(ext_csd[EXT_CSD_PARTITION_ATTRIBUTE] & 0x1)) {
+			u8 hc_erase_grp_sz =
+				ext_csd[EXT_CSD_HC_ERASE_GRP_SIZE];
+			u8 hc_wp_grp_sz =
+				ext_csd[EXT_CSD_HC_WP_GRP_SIZE];
+			/*
+			 * set a flag to identify whether the enhanced
+			 * user data are enabled
+			 */
+			card->ext_csd.enhanced_area_en = 1;
+			/*
+			 * caculate the enhanced data area offset, unit B
+			 */
+			card->ext_csd.enhanced_area_offset =
+				(ext_csd[139] << 24) + (ext_csd[138] << 16) +
+				(ext_csd[137] << 8) + ext_csd[136];
+			if (mmc_card_blockaddr(card))
+				card->ext_csd.enhanced_area_offset <<= 9;
+			/*
+			 * caculate the enhanced data area size, unit KB
+			 */
+			card->ext_csd.enhanced_area_size =
+				(ext_csd[142] << 16) + (ext_csd[141] << 8) +
+				ext_csd[140];
+			card->ext_csd.enhanced_area_size *=
+				(size_t)(hc_erase_grp_sz * hc_wp_grp_sz);
+			card->ext_csd.enhanced_area_size <<= 9;
+		}
 		card->ext_csd.sec_trim_mult =
 			ext_csd[EXT_CSD_SEC_TRIM_MULT];
 		card->ext_csd.sec_erase_mult =
@@ -336,6 +371,9 @@ MMC_DEV_ATTR(manfid, "0x%06x\n", card->cid.manfid);
 MMC_DEV_ATTR(name, "%s\n", card->cid.prod_name);
 MMC_DEV_ATTR(oemid, "0x%04x\n", card->cid.oemid);
 MMC_DEV_ATTR(serial, "0x%08x\n", card->cid.serial);
+MMC_DEV_ATTR(enhanced_area_offset, "0x%llxB\n",
+		card->ext_csd.enhanced_area_offset);
+MMC_DEV_ATTR(enhanced_area_size, "0x%xKB\n", card->ext_csd.enhanced_area_size);
 
 static struct attribute *mmc_std_attrs[] = {
 	&dev_attr_cid.attr,
@@ -349,6 +387,8 @@ static struct attribute *mmc_std_attrs[] = {
 	&dev_attr_name.attr,
 	&dev_attr_oemid.attr,
 	&dev_attr_serial.attr,
+	&dev_attr_enhanced_area_offset.attr,
+	&dev_attr_enhanced_area_size.attr,
 	NULL,
 };
 
@@ -484,6 +524,39 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * If enhanced_area_en is TRUE, host need to enable
+	 * ERASE_GRP_DEF bit.
+	 * ERASE_GRP_DEF bit will be lost everytime
+	 * after a reset or power off.
+	 */
+	if (card->ext_csd.enhanced_area_en) {
+		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				EXT_CSD_ERASE_GROUP_DEF, 1);
+
+		if (err && err != -EBADMSG)
+			goto free_card;
+
+		if (err) {
+			err = 0;
+			/*
+			 * Just disable enhanced area off & sz
+			 * will try to enable ERASE_GROUP_DEF
+			 * during next time reinit
+			 */
+			card->ext_csd.enhanced_area_offset = 0;
+			card->ext_csd.enhanced_area_size = 0;
+		} else {
+			card->ext_csd.erase_group_def = 1;
+			/*
+			 * enable ERASE_GRP_DEF successfully.
+			 * This will affect the erase size, so
+			 * here need to reset erase size
+			 */
+			mmc_set_erase_size(card);
+		}
+	}
+
+	/*
 	 * Activate high speed (if supported)
 	 */
 	if ((card->ext_csd.hs_max_dtr != 0) &&
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..cc9a07e 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -54,6 +54,9 @@ struct mmc_ext_csd {
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
 	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
 	unsigned int		trim_timeout;		/* In milliseconds */
+	bool		enhanced_area_en; /* enhanced area enable bit */
+	loff_t		enhanced_area_offset; /* enhanced area addr */
+	size_t		enhanced_area_size; /* enhanced area size */
 };
 
 struct sd_scr {
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 612301f..c50ede6 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -253,6 +253,8 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_PARTITION_ATTRIBUTE 156	/* R/W */
+#define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
 #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
 #define EXT_CSD_BUS_WIDTH		183	/* R/W */
@@ -262,6 +264,7 @@ struct _mmc_csd {
 #define EXT_CSD_CARD_TYPE		196	/* RO */
 #define EXT_CSD_SEC_CNT			212	/* RO, 4 bytes */
 #define EXT_CSD_S_A_TIMEOUT		217	/* RO */
+#define EXT_CSD_HC_WP_GRP_SIZE		221	/* RO */
 #define EXT_CSD_ERASE_TIMEOUT_MULT	223	/* RO */
 #define EXT_CSD_HC_ERASE_GRP_SIZE	224	/* RO */
 #define EXT_CSD_SEC_TRIM_MULT		229	/* RO */
-- 
1.6.6.1

