Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746Ab2FRFml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:42:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59868 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2FRFmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:42:40 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-0e-4fdebfcea3c5
From: Seungwon Jeon <tgih.jun@samsung.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        "'Maya Erez'" <merez@codeaurora.org>,
        "'Subhash Jadavani'" <subhashj@codeaurora.org>,
        "'S, Venkatraman'" <svenkatr@ti.com>
References: 
In-reply-to: 
Subject: [PATCH RESEND v7 1/3] mmc: core: Add packed command feature of eMMC4.5
Date: Mon, 18 Jun 2012 14:42:38 +0900
Message-id: <007a01cd4d15$2bba3d10$832eb730$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1Hq4q3IPCsnzD7TQm7bK9qtEJddAAoqgUw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t9jAd1z++/5G0z6bGJxedccNosj//sZ
	HZg8Pm+SC2CM4rJJSc3JLEst0rdL4Mp4fmcra8EatYpv76eyNzB2yHcxcnJICJhIvD1+jBnC
	FpO4cG89WxcjF4eQwCJGicMflzFBOH8YJTp/vWUBqWIT0JL4++YNWIeIgKzEzz8XwDqYBfYy
	Sqw/9wgowQHUwS2xujkIpIZTgEdi3Z9OsHphAX+JM5+Wgc1hEVCV6H/ylhXE5hWwlfjeAhHn
	FRCU+DH5HgvIGGYBdYkpU3JBwswC8hKb17wFmy4BFH70VxfiAiOJR5c/s0CUiEjse/GOcQKj
	0Cwkg2YhDJqFZNAsJB0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSH8zOpHYwrGywO
	MQpwMCrx8H5aes9fiDWxrLgy9xCjBAezkgivbTtQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+T
	9QV/IYH0xJLU7NTUgtQimCwTB6dUA2PUOgn1jOB9nvfmOa14GPsoj+nEDI/HeVeiW/uLFqfq
	/pz6OmrO7T1lSteqT11ct7BGS+4Wi43U1WrhT47q55p/JHk5cGR+3crLlWyTc6s6PZN/ylP+
	IzfPXNdND/I3Ucqyz53xveKkv/2eehMhq1lPZ0p0LeBcPGGVXM515rk5/lsr9316ZanEUpyR
	aKjFXFScCAAfmsxvYwIAAA==
X-TM-AS-MML: No
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
 drivers/mmc/core/mmc.c   |   25 +++++++++++++++++++++++++
 include/linux/mmc/card.h |    3 +++
 include/linux/mmc/host.h |    4 ++++
 include/linux/mmc/mmc.h  |   15 +++++++++++++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 258b203..bfb271f 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -516,6 +516,11 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		} else {
 			card->ext_csd.data_tag_unit_size = 0;
 		}
+
+		card->ext_csd.max_packed_writes =
+			ext_csd[EXT_CSD_MAX_PACKED_WRITES];
+		card->ext_csd.max_packed_reads =
+			ext_csd[EXT_CSD_MAX_PACKED_READS];
 	} else {
 		card->ext_csd.data_sector_size = 512;
 	}
@@ -1246,6 +1251,26 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		}
 	}
 
+	if ((host->caps2 & MMC_CAP2_PACKED_WR &&
+			card->ext_csd.max_packed_writes > 0) ||
+	    (host->caps2 & MMC_CAP2_PACKED_RD &&
+			card->ext_csd.max_packed_reads > 0)) {
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
index d76513b..4aeb4e9 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -53,6 +53,9 @@ struct mmc_ext_csd {
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
index 0707d22..9d0d946 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -238,6 +238,10 @@ struct mmc_host {
 #define MMC_CAP2_BROKEN_VOLTAGE	(1 << 7)	/* Use the broken voltage */
 #define MMC_CAP2_DETECT_ON_ERR	(1 << 8)	/* On I/O err check card removal */
 #define MMC_CAP2_HC_ERASE_SZ	(1 << 9)	/* High-capacity erase size */
+#define MMC_CAP2_PACKED_RD	(1 << 10)	/* Allow packed read */
+#define MMC_CAP2_PACKED_WR	(1 << 11)	/* Allow packed write */
+#define MMC_CAP2_PACKED_CMD	(MMC_CAP2_PACKED_RD | \
+				 MMC_CAP2_PACKED_WR) /* Allow packed commands */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 	unsigned int        power_notify_type;
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index d425cab..254901a 100644
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
@@ -377,6 +384,14 @@ struct _mmc_csd {
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


