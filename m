Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399Ab0KWIqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:46:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:4660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0KWIqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:46:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208,223";a="576631012"
Date: Tue, 23 Nov 2010 16:43:50 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, arjan@linux.intel.com,
        hang.yuan@intel.com
Subject: [PATCH v1 1/4]enable background operations for supported card
Message-ID: <20101123084350.GB17754@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6a8fc91e198de80774c3c40246d0eee83366effc Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Mon, 22 Nov 2010 16:31:12 +0800
Subject: [PATCH 1/4] mmc: Enabled background operations feature if eMMC card supports

Background operations is a new feature defined in eMMC4.41 standard.
Since this feature is opertional for eMMC card, so driver only enable
for those eMMC card which supports this feature

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/mmc.c   |   26 ++++++++++++++++++++++++++
 include/linux/mmc/card.h |    2 ++
 include/linux/mmc/mmc.h  |    3 +++
 3 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 77f93c3..471ed82 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -310,6 +310,14 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 			ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
 		card->ext_csd.trim_timeout = 300 *
 			ext_csd[EXT_CSD_TRIM_MULT];
+
+		/* detect whether the eMMC card support BKOPS */
+		if (ext_csd[EXT_CSD_BKOPS_SUPPORT] & 0x1) {
+			card->ext_csd.bkops = 1;
+			card->ext_csd.bkops_en =
+				ext_csd[EXT_CSD_BKOPS_EN];
+		}
+
 	}
 
 	if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
@@ -484,6 +492,24 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * enable BKOPS if eMMC card supports.
+	 */
+	if (card->ext_csd.bkops) {
+		if (!card->ext_csd.bkops_en) {
+			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+					EXT_CSD_BKOPS_EN, 1);
+			if (err && err != -EBADMSG)
+				goto free_card;
+
+			if (err) {
+				card->ext_csd.bkops_en = 0;
+				err = 0;
+			} else
+				card->ext_csd.bkops_en = 1;
+		}
+	}
+
+	/*
 	 * Activate high speed (if supported)
 	 */
 	if ((card->ext_csd.hs_max_dtr != 0) &&
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..9b755cb 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -54,6 +54,8 @@ struct mmc_ext_csd {
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
 	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
 	unsigned int		trim_timeout;		/* In milliseconds */
+	unsigned int		bkops:1; /* background support bit */
+	unsigned int		bkops_en:1; /* background enable bit */
 };
 
 struct sd_scr {
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 956fbd8..14f7813 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -251,6 +251,8 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_BKOPS_EN		163	/* R/W */
+#define EXT_CSD_BKOPS_START		164	/* W */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
 #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
 #define EXT_CSD_BUS_WIDTH		183	/* R/W */
@@ -266,6 +268,7 @@ struct _mmc_csd {
 #define EXT_CSD_SEC_ERASE_MULT		230	/* RO */
 #define EXT_CSD_SEC_FEATURE_SUPPORT	231	/* RO */
 #define EXT_CSD_TRIM_MULT		232	/* RO */
+#define EXT_CSD_BKOPS_SUPPORT	502	/* RO */
 
 /*
  * EXT_CSD field definitions
-- 
1.6.6.1

