Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab2B0KUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:20:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62317 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab2B0KUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:20:35 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-ae-4f4b58f27d56
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        "'Maya Erez'" <merez@codeaurora.org>
Subject: [PATCH v5 1/2] mmc: core: Add packed command feature of eMMC4.5
Date: Mon, 27 Feb 2012 19:20:34 +0900
Message-id: <004201ccf539$70fb4c40$52f1e4c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz1OXCf4DeF5mqwQtmHnR8rstsFGw==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds packed command feature of eMMC4.5.
The maximum number for packing read(or write) is offered
and exception event relevant to packed command which is
used for error handling is enabled. If host wants to use
this feature, MMC_CAP2_PACKED_CMD should be set.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/mmc/core/mmc.c   |   24 ++++++++++++++++++++++++
 include/linux/mmc/card.h |    3 +++
 include/linux/mmc/host.h |    4 ++++
 include/linux/mmc/mmc.h  |   15 +++++++++++++++
 4 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 6b13776..18e2f7d 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -533,6 +533,11 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		} else {
 			card->ext_csd.data_tag_unit_size = 0;
 		}
+
+		card->ext_csd.max_packed_writes =
+			ext_csd[EXT_CSD_MAX_PACKED_WRITES];
+		card->ext_csd.max_packed_reads =
+			ext_csd[EXT_CSD_MAX_PACKED_READS];
 	}
 
 out:
@@ -1255,6 +1260,25 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		}
 	}
 
+	if ((host->caps2 & MMC_CAP2_PACKED_CMD) &&
+			(card->ext_csd.max_packed_writes > 0) &&
+			(card->ext_csd.max_packed_reads > 0)) {
+		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				EXT_CSD_EXP_EVENTS_CTRL,
+				EXT_CSD_PACKED_EVENT_EN,
+				card->ext_csd.generic_cmd6_time);
+		if (err && err != -EBADMSG)
+			goto free_card;
+		if (err) {
+			pr_warning("%s: Enabling packed event failed\n",
+					mmc_hostname(card->host));
+			card->ext_csd.packed_event_en = 0;
+			err = 0;
+		} else {
+			card->ext_csd.packed_event_en = 1;
+		}
+	}
+
 	if (!oldcard)
 		host->card = card;
 
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 1a1ca71..8c16199 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -52,6 +52,9 @@ struct mmc_ext_csd {
 	u8			part_config;
 	u8			cache_ctrl;
 	u8			rst_n_function;
+	u8			max_packed_writes;
+	u8			max_packed_reads;
+	u8			packed_event_en;
 	unsigned int		part_time;		/* Units: ms */
 	unsigned int		sa_timeout;		/* Units: 100ns */
 	unsigned int		generic_cmd6_time;	/* Units: 10ms */
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ee2b036..f18e95b 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -258,6 +258,10 @@ struct mmc_host {
 #define MMC_CAP2_HS200		(MMC_CAP2_HS200_1_8V_SDR | \
 				 MMC_CAP2_HS200_1_2V_SDR)
 #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken voltage */
+#define MMC_CAP2_PACKED_RD	(1 << 8)	/* Allow packed read */
+#define MMC_CAP2_PACKED_WR	(1 << 9)	/* Allow packed write */
+#define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
+				 MMC_CAP2_PACKED_WR) /* Allow packed commands */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index b822a2c..d990760 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -139,6 +139,7 @@ static inline bool mmc_op_multi(u32 opcode)
 #define R1_CURRENT_STATE(x)	((x & 0x00001E00) >> 9)	/* sx, b (4 bits) */
 #define R1_READY_FOR_DATA	(1 << 8)	/* sx, a */
 #define R1_SWITCH_ERROR		(1 << 7)	/* sx, c */
+#define R1_EXP_EVENT		(1 << 6)	/* sr, a */
 #define R1_APP_CMD		(1 << 5)	/* sr, c */
 
 #define R1_STATE_IDLE	0
@@ -274,6 +275,10 @@ struct _mmc_csd {
 #define EXT_CSD_FLUSH_CACHE		32      /* W */
 #define EXT_CSD_CACHE_CTRL		33      /* R/W */
 #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
+#define EXT_CSD_PACKED_FAILURE_INDEX	35	/* RO */
+#define EXT_CSD_PACKED_CMD_STATUS	36	/* RO */
+#define EXT_CSD_EXP_EVENTS_STATUS	54	/* RO, 2 bytes */
+#define EXT_CSD_EXP_EVENTS_CTRL	56	/* R/W, 2 bytes */
 #define EXT_CSD_DATA_SECTOR_SIZE	61	/* R */
 #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
 #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
@@ -318,6 +323,8 @@ struct _mmc_csd {
 #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
 #define EXT_CSD_TAG_UNIT_SIZE		498	/* RO */
 #define EXT_CSD_DATA_TAG_SUPPORT	499	/* RO */
+#define EXT_CSD_MAX_PACKED_WRITES	500	/* RO */
+#define EXT_CSD_MAX_PACKED_READS	501	/* RO */
 #define EXT_CSD_HPI_FEATURES		503	/* RO */
 
 /*
@@ -437,6 +444,14 @@ struct _mmc_csd {
 #define EXT_CSD_PWR_CL_4BIT_MASK	0x0F	/* 8 bit PWR CLS */
 #define EXT_CSD_PWR_CL_8BIT_SHIFT	4
 #define EXT_CSD_PWR_CL_4BIT_SHIFT	0
+
+#define EXT_CSD_PACKED_EVENT_EN	(1 << 3)
+
+#define EXT_CSD_PACKED_FAILURE	(1 << 3)
+
+#define EXT_CSD_PACKED_GENERIC_ERROR	(1 << 0)
+#define EXT_CSD_PACKED_INDEXED_ERROR	(1 << 1)
+
 /*
  * MMC_SWITCH access modes
  */
-- 
1.7.0.4


