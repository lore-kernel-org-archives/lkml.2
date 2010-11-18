Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412Ab0KRJCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 04:02:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:17505 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab0KRJCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 04:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,216,1288594800"; 
   d="scan'208,223";a="678678864"
Date: Thu, 18 Nov 2010 17:00:35 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alan@linux.intel.com, arjan@linux.intel.com
Subject: [PATCH v2 1/3]mmc:Add a new quirk for SDHCI HC to erase single
	erase block
Message-ID: <20101118090035.GB18161@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 3e4ee72e57a667f383f34a9e3276f2431b7bb53d Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 18 Nov 2010 16:06:35 +0800
Subject: [PATCH 1/3] mmc: Added a new quirk for SDHCI HC to erase single erase block

Some sdhci host controller like MFLD sdhci host controller cannot erase
unlimited sectors one time since host controller may generate a timeout
interrupt before erasing is done. This should be a architecture issue. So
added a quirk for host controller to use.

With this quirk, sdhci host controller can set a suitable
max_discard_sectors value which will be safe for erasing.

Patch add two follow things
1. Add SDHCI_QUIRK_FORCE_ERASE_SINGLE and MMC_CAP_ERASE_SINGLE for this
kind of sdhci host controller.
2. Add a routine mmc_set_discard_limit in mmc core layer to set a safe
secotrs value.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/card/queue.c  |    8 +++++++-
 drivers/mmc/core/core.c   |   27 +++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c  |    4 ++++
 include/linux/mmc/core.h  |    1 +
 include/linux/mmc/host.h  |    2 ++
 include/linux/mmc/sdhci.h |    2 ++
 6 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4e42d03..f665c62 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -131,7 +131,13 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 	if (mmc_can_erase(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
-		mq->queue->limits.max_discard_sectors = UINT_MAX;
+		/* get a suitable max_discard_sectors limitation */
+		ret = mmc_set_discard_limit(card);
+		if (ret > 0)
+			mq->queue->limits.max_discard_sectors = ret;
+		else
+			mq->queue->limits.max_discard_sectors = UINT_MAX;
+
 		if (card->erased_byte == 0)
 			mq->queue->limits.discard_zeroes_data = 1;
 		if (!mmc_can_trim(card) && is_power_of_2(card->erase_size)) {
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 434e62c..947d963 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1454,6 +1454,33 @@ int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 }
 EXPORT_SYMBOL(mmc_erase_group_aligned);
 
+/*
+ * mmc_set_discard_limit: set the max_discard_sectors according
+ * to host controller timeout capability.
+ */
+int mmc_set_discard_limit(struct mmc_card *card)
+{
+	struct mmc_host *host;
+	unsigned int nr = 0;
+	host = card->host;
+	if (host->caps & MMC_CAP_ERASE_SINGLE) {
+		/*
+		 * Have to set a small limitation for request queue
+		 * to ensure that host controller won't generate a
+		 * timeout interrupt during waiting, here let limitation
+		 * to be 1 erase block. And this will let TRIM/ERASE
+		 * performance lower.
+		 */
+		nr = 1;
+		if (card->erase_shift)
+			nr <<= card->erase_shift;
+		else
+			nr *= card->erase_size;
+	}
+	return nr;
+}
+EXPORT_SYMBOL(mmc_set_discard_limit);
+
 int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen)
 {
 	struct mmc_command cmd;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 154cbf8..fa66988 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1857,6 +1857,10 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->f_min = host->max_clk / SDHCI_MAX_DIV_SPEC_200;
 	mmc->f_max = host->max_clk;
 	mmc->caps |= MMC_CAP_SDIO_IRQ;
+	mmc->caps |= MMC_CAP_ERASE;
+
+	if (host->quirks & SDHCI_QUIRK_FORCE_ERASE_SINGLE)
+		mmc->caps |= MMC_CAP_ERASE_SINGLE;
 
 	if (!(host->quirks & SDHCI_QUIRK_FORCE_1_BIT_DATA))
 		mmc->caps |= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA;
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 64e013f..ffddd1f 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -152,6 +152,7 @@ extern int mmc_can_trim(struct mmc_card *card);
 extern int mmc_can_secure_erase_trim(struct mmc_card *card);
 extern int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 				   unsigned int nr);
+extern int mmc_set_discard_limit(struct mmc_card *card);
 
 extern int mmc_set_blocklen(struct mmc_card *card, unsigned int blocklen);
 
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index f108cee..85df99a 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -168,6 +168,8 @@ struct mmc_host {
 						/* DDR mode at 1.8V */
 #define MMC_CAP_1_2V_DDR	(1 << 12)	/* can support */
 						/* DDR mode at 1.2V */
+#define MMC_CAP_ERASE_SINGLE	(1 << 13)
+				/* Erase signle erase block each time */
 
 	mmc_pm_flag_t		pm_caps;	/* supported pm features */
 
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index 1fdc673..e7bdfc8 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -83,6 +83,8 @@ struct sdhci_host {
 #define SDHCI_QUIRK_MULTIBLOCK_READ_ACMD12		(1<<28)
 /* Controller doesn't have HISPD bit field in HI-SPEED SD card */
 #define SDHCI_QUIRK_NO_HISPD_BIT			(1<<29)
+/* Controller has an issue with erase/trim the whole device at one time */
+#define SDHCI_QUIRK_FORCE_ERASE_SINGLE			(1<<30)
 
 	int irq;		/* Device IRQ */
 	void __iomem *ioaddr;	/* Mapped address */
-- 
1.6.6.1

