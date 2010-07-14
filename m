Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab0GNNIN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:08:13 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:18756 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756834Ab0GNNII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:08:08 -0400
Date: Wed, 14 Jul 2010 17:08:07 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 6/8] sdhci: Get rid of card detect work
Message-ID: <20100714130807.GF517@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nowadays we can just call the card detection handler directly,
no need for the separate work struct.

We still need host->finish_work as sdhci_finish_work() calls
mmc_request_done(), which tries to re-enter the driver.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci.c |   14 ++------------
 drivers/mmc/host/sdhci.h |    1 -
 2 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 5eddbdb..56d5c56 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1239,14 +1239,8 @@ static const struct mmc_host_ops sdhci_ops = {
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_card_detect_work(struct work_struct *wk)
+static void sdhci_card_detect(struct sdhci_host *host)
 {
-	struct sdhci_host *host;
-
-	host = container_of(wk, struct sdhci_host, card_detect_work);
-
-	mutex_lock(&host->lock);
-
 	if (!(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
 		if (host->mrq) {
 			printk(KERN_ERR "%s: Card removed during transfer!\n",
@@ -1262,8 +1256,6 @@ static void sdhci_card_detect_work(struct work_struct *wk)
 		}
 	}
 
-	mutex_unlock(&host->lock);
-
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
 
@@ -1511,7 +1503,7 @@ static irqreturn_t sdhci_irq_thread(int irq, void *dev_id)
 	sdhci_writel(host, intmask, SDHCI_INT_STATUS);
 
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE))
-		schedule_work(&host->card_detect_work);
+		sdhci_card_detect(host);
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
 
@@ -1865,7 +1857,6 @@ int sdhci_add_host(struct sdhci_host *host)
 	/*
 	 * Init work structs.
 	 */
-	INIT_WORK(&host->card_detect_work, sdhci_card_detect_work);
 	INIT_WORK(&host->finish_work, sdhci_finish_work);
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
@@ -1950,7 +1941,6 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	flush_delayed_work(&host->timeout_work);
 
-	flush_work(&host->card_detect_work);
 	flush_work(&host->finish_work);
 
 	kfree(host->adma_desc);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 364d4e8..5f7d649 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -289,7 +289,6 @@ struct sdhci_host {
 	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
 	dma_addr_t		align_addr;	/* Mapped bounce buffer */
 
-	struct work_struct	card_detect_work;
 	struct work_struct	finish_work;
 
 	struct delayed_work	timeout_work;	/* Work for timeouts */
-- 
1.7.0.5

