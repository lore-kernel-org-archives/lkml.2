Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab0L0KSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 05:18:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:11614 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab0L0KSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 05:18:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,234,1291622400"; 
   d="scan'208";a="587482464"
Date: Mon, 27 Dec 2010 18:13:43 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, akpm@linux-foundation.org
Subject: [PATCH v6 1/3]mmc: enable HW reset capability if card supports
Message-ID: <20101227101343.GB20143@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HW reset capability enable bit is byte 162 in card EXT_CSD register, only
version4.4 card or later can support to enable this feature.

HW reset feature can be used to reset eMMC card when occurs timeout error
during read/write/erase even eMMC card cannot correspond any command

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/mmc.c   |   24 ++++++++++++++++++++++++
 include/linux/mmc/card.h |    1 +
 include/linux/mmc/mmc.h  |    1 +
 3 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 1d8409f..ebb5748 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -310,6 +310,8 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 			ext_csd[EXT_CSD_SEC_FEATURE_SUPPORT];
 		card->ext_csd.trim_timeout = 300 *
 			ext_csd[EXT_CSD_TRIM_MULT];
+		/* check Hardware reset capability */
+		card->ext_csd.rst = ext_csd[EXT_CSD_RST];
 	}
 
 	if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
@@ -484,6 +486,28 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * eMMC4.4 version card has HW reset capability. Enable this feature
+	 * here. RST_N_FUNCTION register is W/R, one time programmable or
+	 * readable. So need to enable this register only once after power on
+	 */
+	if (card->csd.mmca_vsn >= CSD_SPEC_VER_4 &&
+			card->ext_csd.rev >= 5 &&
+			card->ext_csd.rst == 0) {
+		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				EXT_CSD_RST, 1);
+
+		if (err && err != -EBADMSG)
+			goto free_card;
+
+		if (err) {
+			pr_warn("%s: switch to rst enable failed %d\n",
+				   mmc_hostname(card->host), err);
+			err = 0;
+		} else
+			card->ext_csd.rst = 1;
+	}
+
+	/*
 	 * Activate high speed (if supported)
 	 */
 	if ((card->ext_csd.hs_max_dtr != 0) &&
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 8ce0827..ebee676 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -54,6 +54,7 @@ struct mmc_ext_csd {
 	unsigned int		sec_trim_mult;	/* Secure trim multiplier  */
 	unsigned int		sec_erase_mult;	/* Secure erase multiplier */
 	unsigned int		trim_timeout;		/* In milliseconds */
+	unsigned int		rst; /* hardware reset enable bit */
 };
 
 struct sd_scr {
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 612301f..ed86b78 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -253,6 +253,7 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_RST		162	/* onetime programmable R/W */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
 #define EXT_CSD_ERASED_MEM_CONT		181	/* RO */
 #define EXT_CSD_BUS_WIDTH		183	/* R/W */
-- 
1.6.6.1

