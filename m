Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab2KHNJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 08:09:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:7521 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab2KHND4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 08:03:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,737,1344236400"; 
   d="scan'208";a="244102197"
From: dragos.tatulea@intel.com
To: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, cjb@laptop.org
Cc: kirill.shutemov@linux.intel.com, irina.tirdea@intel.com,
        octavian.purdila@intel.com, tony.luck@intel.com, keescook@chromium.org,
        dragos.tatulea@gmail.com, Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v2 09/26] mmc: panic write: suppress host not claimed warnings
Date: Thu,  8 Nov 2012 15:06:07 +0200
Message-Id: <1352379984-18381-10-git-send-email-dragos.tatulea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
References: <1352379984-18381-1-git-send-email-dragos.tatulea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 drivers/mmc/core/core.c     |   13 +++++++------
 drivers/mmc/core/mmc.c      |    4 ++--
 drivers/mmc/core/sd.c       |    4 ++--
 drivers/mmc/core/sdio.c     |    4 ++--
 drivers/mmc/core/sdio_irq.c |    4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 6b2377a..0b904bc 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -224,7 +224,7 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 			 mrq->stop->arg, mrq->stop->flags);
 	}
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	mrq->cmd->error = 0;
 	mrq->cmd->mrq = mrq;
@@ -558,7 +558,7 @@ int mmc_wait_for_cmd(struct mmc_host *host, struct mmc_command *cmd, int retries
 {
 	struct mmc_request mrq = {NULL};
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	memset(cmd->resp, 0, sizeof(cmd->resp));
 	cmd->retries = retries;
@@ -843,7 +843,7 @@ void mmc_release_host(struct mmc_host *host)
 {
 	unsigned long flags;
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	if (host->ops->disable && host->claim_cnt == 1)
 		host->ops->disable(host);
@@ -1433,7 +1433,7 @@ void mmc_attach_bus(struct mmc_host *host, const struct mmc_bus_ops *ops)
 	BUG_ON(!host);
 	BUG_ON(!ops);
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1456,7 +1456,7 @@ void mmc_detach_bus(struct mmc_host *host)
 
 	BUG_ON(!host);
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 	WARN_ON(!host->bus_ops);
 
 	spin_lock_irqsave(&host->lock, flags);
@@ -2106,7 +2106,8 @@ int mmc_detect_card_removed(struct mmc_host *host)
 	struct mmc_card *card = host->card;
 	int ret;
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
+
 
 	if (!card)
 		return 1;
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 7cc4638..9cc36c4 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -823,7 +823,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 	u8 *ext_csd = NULL;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	/* Set correct bus mode for MMC before attempting init */
 	if (!mmc_host_is_spi(host))
@@ -1478,7 +1478,7 @@ int mmc_attach_mmc(struct mmc_host *host)
 	u32 ocr;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	/* Set correct bus mode for MMC before attempting attach */
 	if (!mmc_host_is_spi(host))
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 74972c2..4ad079f 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -899,7 +899,7 @@ static int mmc_sd_init_card(struct mmc_host *host, u32 ocr,
 	u32 rocr = 0;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	err = mmc_sd_get_cid(host, ocr, cid, &rocr);
 	if (err)
@@ -1146,7 +1146,7 @@ int mmc_attach_sd(struct mmc_host *host)
 	u32 ocr;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	/* Disable preset value enable if already set since last time */
 	if (host->ops->enable_preset_value) {
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 2273ce6..af89c84 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -585,7 +585,7 @@ static int mmc_sdio_init_card(struct mmc_host *host, u32 ocr,
 	int err;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	/*
 	 * Inform the card of the voltage
@@ -1051,7 +1051,7 @@ int mmc_attach_sdio(struct mmc_host *host)
 	struct mmc_card *card;
 
 	BUG_ON(!host);
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	err = mmc_send_io_op_cond(host, 0, &ocr);
 	if (err)
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 3d8ceb4..719701c 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -175,7 +175,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 
 	if (!host->sdio_irqs++) {
 		atomic_set(&host->sdio_irq_thread_abort, 0);
@@ -196,7 +196,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
 {
 	struct mmc_host *host = card->host;
 
-	WARN_ON(!host->claimed);
+	WARN_ON(!host->claimed && !mmc_am_panic_task(host));
 	BUG_ON(host->sdio_irqs < 1);
 
 	if (!--host->sdio_irqs) {
-- 
1.7.9.5

