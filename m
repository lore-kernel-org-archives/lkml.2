Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574Ab0LCMRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 07:17:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:37014 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755364Ab0LCMRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 07:17:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,292,1288594800"; 
   d="scan'208,223";a="632763908"
Date: Fri, 3 Dec 2010 20:14:28 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, akpm@linux-foundation.org,
        arjan@linux.intel.com, alan@linux.intel.com, kmpark@infradead.org
Subject: [PATCH v2 3/4]enable HPI for supported eMMC card
Message-ID: <20101203121428.GD18655@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c9a450e2eb60b3b0151e9bafc2707d0a0c3aad76 Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Fri, 3 Dec 2010 19:31:59 +0800
Subject: [PATCH 3/4] mmc: Enabled HPI feature

HPI feature is a new feature in eMMC4.41 standard. It will be
used to interrupt background operations and low priority
foreground operations

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/core/mmc.c   |   31 +++++++++++++++++++++++++++++++
 include/linux/mmc/card.h |    2 ++
 include/linux/mmc/mmc.h  |    2 ++
 3 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 471ed82..8d6c5cb 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -318,6 +318,18 @@ static int mmc_read_ext_csd(struct mmc_card *card)
 				ext_csd[EXT_CSD_BKOPS_EN];
 		}
 
+		/* check whether the eMMC card support HPI */
+		if (ext_csd[EXT_CSD_HPI_FEATURES] & 0x1) {
+			card->ext_csd.hpi = 1;
+			card->ext_csd.hpi_en =
+				ext_csd[EXT_CSD_HPI_MGMT];
+			if (ext_csd[EXT_CSD_HPI_FEATURES] & 0x2)
+				card->ext_csd.hpi_cmd =
+					MMC_STOP_TRANSMISSION;
+			else
+				card->ext_csd.hpi_cmd =
+					MMC_SEND_STATUS;
+		}
 	}
 
 	if (ext_csd[EXT_CSD_ERASED_MEM_CONT])
@@ -510,6 +522,25 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	}
 
 	/*
+	 * enable HPI feature if eMMC card support
+	 */
+	if (card->ext_csd.hpi) {
+		if (!card->ext_csd.hpi_en) {
+			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+					EXT_CSD_HPI_MGMT, 1);
+			if (err && err != -EBADMSG)
+				goto free_card;
+
+			if (err) {
+				card->ext_csd.hpi_en = 0;
+				err = 0;
+			} else {
+				card->ext_csd.hpi_en = 1;
+			}
+		}
+	}
+
+	/*
 	 * Activate high speed (if supported)
 	 */
 	if ((card->ext_csd.hs_max_dtr != 0) &&
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 4142ab5..efb2c56 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -57,6 +57,8 @@ struct mmc_ext_csd {
 	unsigned int		bkops:1; /* background support bit */
 	unsigned int		bkops_en:1; /* background enable bit */
 	unsigned int		hpi_en:1; /* HPI enable bit */
+	unsigned int		hpi:1; /* HPI support bit */
+	unsigned int		hpi_cmd; /* cmd used to for HPI */
 };
 
 struct sd_scr {
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 2ba6a8b..34feaee 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -258,6 +258,7 @@ struct _mmc_csd {
  * EXT_CSD fields
  */
 
+#define EXT_CSD_HPI_MGMT		161	/* R/W */
 #define EXT_CSD_BKOPS_EN		163	/* R/W */
 #define EXT_CSD_BKOPS_START		164	/* W */
 #define EXT_CSD_ERASE_GROUP_DEF		175	/* R/W */
@@ -276,6 +277,7 @@ struct _mmc_csd {
 #define EXT_CSD_SEC_FEATURE_SUPPORT	231	/* RO */
 #define EXT_CSD_TRIM_MULT		232	/* RO */
 #define EXT_CSD_BKOPS_SUPPORT	502	/* RO */
+#define EXT_CSD_HPI_FEATURES	503	/* RO */
 
 /*
  * EXT_CSD field definitions
-- 
1.6.6.1

