Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab0LBL3F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 06:29:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:23643 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab0LBL3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 06:29:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,287,1288594800"; 
   d="scan'208,223";a="579826836"
Date: Thu, 2 Dec 2010 19:25:53 +0800
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cjb@laptop.org, arjan@linux.intel.com,
        alan@linux.intel.com, akpm@linux-foundation.org,
        adrian.hunter@nokia.com
Subject: [PATCH v3 1/3]add a new quirk for SDHCI host
Message-ID: <20101202112553.GB10358@intel.com>
Reply-To: Chuanxiao Dong <chuanxiao.dong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 08e9f6c1fb908172c2ebb278e7b8da359db51bac Mon Sep 17 00:00:00 2001
From: Chuanxiao Dong <chuanxiao.dong@intel.com>
Date: Thu, 2 Dec 2010 15:19:54 +0800
Subject: [PATCH 1/3] add a quirk for sdhci host which cannot erase too many sectors each time

The original max_discard_sectors value which used to limit the number of
discard sectors is UINT_MAX, which means kernel block layer can pass down
any sectors to host for erasing. But for some sdhci host controller like
MFLD platform controller cannot handle too many sectors at one time. Maybe
during the erasing, host controller will generate a timeout interrupt since
erasing too many sectors may need longer time than the maximum time host can
wait.

This patch adds a new quirk for such sdhci host controller since this should
be an architecture issue. SDHCI host controller with this quirk can set the
max_discard_sectors to be one erase block size. With the set value, sdhci
host controller can operate erase command without error.

Signed-off-by: Chuanxiao Dong <chuanxiao.dong@intel.com>
---
 drivers/mmc/card/queue.c  |    5 ++++-
 drivers/mmc/core/core.c   |   33 +++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c  |    4 ++++
 include/linux/mmc/core.h  |    1 +
 include/linux/mmc/host.h  |    2 ++
 include/linux/mmc/sdhci.h |    2 ++
 6 files changed, 46 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 4e42d03..f557788 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -131,7 +131,10 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, mq->queue);
 	if (mmc_can_erase(card)) {
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mq->queue);
-		mq->queue->limits.max_discard_sectors = UINT_MAX;
+		/* get a suitable max_discard_sectors limitation */
+		mq->queue->limits.max_discard_sectors =
+			mmc_set_discard_limit(card);
+
 		if (card->erased_byte == 0)
 			mq->queue->limits.discard_zeroes_data = 1;
 		if (!mmc_can_trim(card) && is_power_of_2(card->erase_size)) {
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6286898..9fe16c2 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1469,6 +1469,39 @@ int mmc_erase_group_aligned(struct mmc_card *card, unsigned int from,
 }
 EXPORT_SYMBOL(mmc_erase_group_aligned);
 
+/**
+ * mmc_set_discard_limit: set the max_discard_sectors according
+ * to host controller erase capability.
+ * @card: card need to be erased
+ *
+ * Return value:
+ * positive value: one erase block size
+ * UINT_MAX: unlimitied value which means no limitation for
+ * max_discard_sectors
+ */
+int mmc_set_discard_limit(struct mmc_card *card)
+{
+	struct mmc_host *host;
+	unsigned int nr = UINT_MAX;
+	host = card->host;
+	if (host->caps & MMC_CAP_ERASE_SINGLE) {
+		/*
+		 * Have to set a small limitation for request queue
+		 * to ensure that host controller won't generate a
+		 * timeout interrupt during erasing, here let limitation
+		 * to be one erase block size.
+		 * And this will let TRIM/ERASE performance lower.
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
index 8a74fcb..b4448a9 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1875,6 +1875,10 @@ int sdhci_add_host(struct sdhci_host *host)
 
 	mmc->f_max = host->max_clk;
 	mmc->caps |= MMC_CAP_SDIO_IRQ;
+	mmc->caps |= MMC_CAP_ERASE;
+
+	if (host->quirks & SDHCI_QUIRK_FORCE_ERASE_SINGLE)
+		mmc->caps |= MMC_CAP_ERASE_SINGLE;
 
 	/*
 	 * A controller may support 8-bit width, but the board itself
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
index 381c77f..c3d2ade 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -169,6 +169,8 @@ struct mmc_host {
 #define MMC_CAP_1_2V_DDR	(1 << 12)	/* can support */
 						/* DDR mode at 1.2V */
 #define MMC_CAP_POWER_OFF_CARD	(1 << 13)	/* Can power off after boot */
+#define MMC_CAP_ERASE_SINGLE	(1 << 14)
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

