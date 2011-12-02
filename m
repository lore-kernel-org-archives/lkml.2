Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab1LBJjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:39:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30047 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab1LBJjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:39:52 -0500
X-AuditID: cbfee61a-b7b62ae0000030b0-f0-4ed89cc3764f
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: "'Chris Ball'" <cjb@laptop.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        dh.han@samsung.com
Subject: [PATCH v2 1/2] mmc: core: Add packed command feature of eMMC4.5
Date: Fri, 02 Dec 2011 18:39:15 +0900
Message-id: <003401ccb0d6$4144f570$c3cee050$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyw1kDe6BnEXbJMQMSp9vlN7M11eA==
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
 include/linux/mmc/host.h |    1 +
 include/linux/mmc/mmc.h  |   15 +++++++++++++++
 4 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index e8b6b5d..fc8a4cf 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -487,6 +487,11 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 			ext_csd[EXT_CSD_CACHE_SIZE + 1] << 8 |
 			ext_csd[EXT_CSD_CACHE_SIZE + 2] << 16 |
 			ext_csd[EXT_CSD_CACHE_SIZE + 3] << 24;
+
+		card->ext_csd.max_packed_writes =
+			ext_csd[EXT_CSD_MAX_PACKED_WRITES];
+		card->ext_csd.max_packed_reads =
+			ext_csd[EXT_CSD_MAX_PACKED_READS];
 	}
 
 out:
@@ -1076,6 +1081,25 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		card->ext_csd.cache_ctrl = err ? 0 : 1;
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
index 6402d92..73e8add 100644
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
index 9a03d03..5667035 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -242,6 +242,7 @@ struct mmc_host {
 #define MMC_CAP2_CACHE_CTRL	(1 << 1)	/* Allow cache control */
 #define MMC_CAP2_POWEROFF_NOTIFY (1 << 2)	/* Notify poweroff supported */
 #define MMC_CAP2_NO_MULTI_READ	(1 << 3)	/* Multiblock reads don't work */
+#define MMC_CAP2_PACKED_CMD	(1 << 4)	/* Allow packed command */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index 0e71356..1b94c4f 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -138,6 +138,7 @@ static inline bool mmc_op_multi(u32 opcode)
 #define R1_CURRENT_STATE(x)	((x & 0x00001E00) >> 9)	/* sx, b (4 bits) */
 #define R1_READY_FOR_DATA	(1 << 8)	/* sx, a */
 #define R1_SWITCH_ERROR		(1 << 7)	/* sx, c */
+#define R1_EXP_EVENT		(1 << 6)	/* sr, a */
 #define R1_APP_CMD		(1 << 5)	/* sr, c */
 
 #define R1_STATE_IDLE	0
@@ -273,6 +274,10 @@ struct _mmc_csd {
 #define EXT_CSD_FLUSH_CACHE		32      /* W */
 #define EXT_CSD_CACHE_CTRL		33      /* R/W */
 #define EXT_CSD_POWER_OFF_NOTIFICATION	34	/* R/W */
+#define EXT_CSD_PACKED_FAILURE_INDEX	35	/* RO */
+#define EXT_CSD_PACKED_CMD_STATUS	36	/* RO */
+#define EXT_CSD_EXP_EVENTS_STATUS	54	/* RO, 2 bytes */
+#define EXT_CSD_EXP_EVENTS_CTRL	56	/* R/W, 2 bytes */
 #define EXT_CSD_GP_SIZE_MULT		143	/* R/W */
 #define EXT_CSD_PARTITION_ATTRIBUTE	156	/* R/W */
 #define EXT_CSD_PARTITION_SUPPORT	160	/* RO */
@@ -313,6 +318,8 @@ struct _mmc_csd {
 #define EXT_CSD_POWER_OFF_LONG_TIME	247	/* RO */
 #define EXT_CSD_GENERIC_CMD6_TIME	248	/* RO */
 #define EXT_CSD_CACHE_SIZE		249	/* RO, 4 bytes */
+#define EXT_CSD_MAX_PACKED_WRITES	500	/* RO */
+#define EXT_CSD_MAX_PACKED_READS	501	/* RO */
 #define EXT_CSD_HPI_FEATURES		503	/* RO */
 
 /*
@@ -364,6 +371,14 @@ struct _mmc_csd {
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


