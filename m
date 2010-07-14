Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab0GNNIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 09:08:06 -0400
Received: from imap.ru.mvista.com ([213.79.90.228]:18723 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754076Ab0GNNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 09:08:01 -0400
Date: Wed, 14 Jul 2010 17:07:59 +0400
From: Anton Vorontsov <avorontsov@mvista.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Albert Herranz <albert_herranz@yahoo.es>,
        Matt Fleming <matt@console-pimps.org>, Ben Dooks <ben-linux@fluff.org>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 2/8] sdhci: Use work structs instead of tasklets
Message-ID: <20100714130759.GB517@oksana.dev.rtsoft.ru>
References: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100714130728.GA27339@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver can happily live without an atomic context and tasklets,
so turn the tasklets into the work structs.

Tasklets handlers still grab irqsave spinlocks, but we'll deal
with it in a separate patch.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 drivers/mmc/host/sdhci.c |   48 ++++++++++++++++++++-------------------------
 drivers/mmc/host/sdhci.h |    4 +-
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index dc6328c..748a2e3 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -872,7 +872,7 @@ static void sdhci_finish_data(struct sdhci_host *host)
 
 		sdhci_send_command(host, data->stop);
 	} else
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 }
 
 static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
@@ -901,7 +901,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 				"inhibit bit(s).\n", mmc_hostname(host->mmc));
 			sdhci_dumpregs(host);
 			cmd->error = -EIO;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 			return;
 		}
 		timeout--;
@@ -922,7 +922,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
 		printk(KERN_ERR "%s: Unsupported response type!\n",
 			mmc_hostname(host->mmc));
 		cmd->error = -EINVAL;
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 		return;
 	}
 
@@ -973,7 +973,7 @@ static void sdhci_finish_command(struct sdhci_host *host)
 		sdhci_finish_data(host);
 
 	if (!host->cmd->data)
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 
 	host->cmd = NULL;
 }
@@ -1122,7 +1122,7 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 	if (!present || host->flags & SDHCI_DEVICE_DEAD) {
 		host->mrq->cmd->error = -ENOMEDIUM;
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 	} else
 		sdhci_send_command(host, mrq->cmd);
 
@@ -1239,16 +1239,16 @@ static const struct mmc_host_ops sdhci_ops = {
 
 /*****************************************************************************\
  *                                                                           *
- * Tasklets                                                                  *
+ * Work handlers                                                             *
  *                                                                           *
 \*****************************************************************************/
 
-static void sdhci_tasklet_card(unsigned long param)
+static void sdhci_card_detect_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 
-	host = (struct sdhci_host*)param;
+	host = container_of(wk, struct sdhci_host, card_detect_work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1263,7 +1263,7 @@ static void sdhci_tasklet_card(unsigned long param)
 			sdhci_reset(host, SDHCI_RESET_DATA);
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 	}
 
@@ -1272,13 +1272,13 @@ static void sdhci_tasklet_card(unsigned long param)
 	mmc_detect_change(host->mmc, msecs_to_jiffies(200));
 }
 
-static void sdhci_tasklet_finish(unsigned long param)
+static void sdhci_finish_work(struct work_struct *wk)
 {
 	struct sdhci_host *host;
 	unsigned long flags;
 	struct mmc_request *mrq;
 
-	host = (struct sdhci_host*)param;
+	host = container_of(wk, struct sdhci_host, finish_work);
 
 	spin_lock_irqsave(&host->lock, flags);
 
@@ -1349,7 +1349,7 @@ static void sdhci_timeout_work(struct work_struct *wk)
 			else
 				host->mrq->cmd->error = -ETIMEDOUT;
 
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 	}
 
@@ -1382,7 +1382,7 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
 		host->cmd->error = -EILSEQ;
 
 	if (host->cmd->error) {
-		tasklet_schedule(&host->finish_tasklet);
+		schedule_work(&host->finish_work);
 		return;
 	}
 
@@ -1528,7 +1528,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 	if (intmask & (SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE)) {
 		sdhci_writel(host, intmask & (SDHCI_INT_CARD_INSERT |
 			SDHCI_INT_CARD_REMOVE), SDHCI_INT_STATUS);
-		tasklet_schedule(&host->card_tasklet);
+		schedule_work(&host->card_detect_work);
 	}
 
 	intmask &= ~(SDHCI_INT_CARD_INSERT | SDHCI_INT_CARD_REMOVE);
@@ -1872,19 +1872,17 @@ int sdhci_add_host(struct sdhci_host *host)
 	mmc->max_blk_count = (host->quirks & SDHCI_QUIRK_NO_MULTIBLOCK) ? 1 : 65535;
 
 	/*
-	 * Init tasklets.
+	 * Init work structs.
 	 */
-	tasklet_init(&host->card_tasklet,
-		sdhci_tasklet_card, (unsigned long)host);
-	tasklet_init(&host->finish_tasklet,
-		sdhci_tasklet_finish, (unsigned long)host);
+	INIT_WORK(&host->card_detect_work, sdhci_card_detect_work);
+	INIT_WORK(&host->finish_work, sdhci_finish_work);
 
 	INIT_DELAYED_WORK(&host->timeout_work, sdhci_timeout_work);
 
 	ret = request_irq(host->irq, sdhci_irq, IRQF_SHARED,
 		mmc_hostname(mmc), host);
 	if (ret)
-		goto untasklet;
+		return ret;
 
 	sdhci_init(host, 0);
 
@@ -1923,10 +1921,6 @@ reset:
 	sdhci_reset(host, SDHCI_RESET_ALL);
 	free_irq(host->irq, host);
 #endif
-untasklet:
-	tasklet_kill(&host->card_tasklet);
-	tasklet_kill(&host->finish_tasklet);
-
 	return ret;
 }
 
@@ -1946,7 +1940,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 				" transfer!\n", mmc_hostname(host->mmc));
 
 			host->mrq->cmd->error = -ENOMEDIUM;
-			tasklet_schedule(&host->finish_tasklet);
+			schedule_work(&host->finish_work);
 		}
 
 		spin_unlock_irqrestore(&host->lock, flags);
@@ -1967,8 +1961,8 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
 
 	flush_delayed_work(&host->timeout_work);
 
-	tasklet_kill(&host->card_tasklet);
-	tasklet_kill(&host->finish_tasklet);
+	flush_work(&host->card_detect_work);
+	flush_work(&host->finish_work);
 
 	kfree(host->adma_desc);
 	kfree(host->align_buffer);
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 55c114d..d96e4dd 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -288,8 +288,8 @@ struct sdhci_host {
 	dma_addr_t		adma_addr;	/* Mapped ADMA descr. table */
 	dma_addr_t		align_addr;	/* Mapped bounce buffer */
 
-	struct tasklet_struct	card_tasklet;	/* Tasklet structures */
-	struct tasklet_struct	finish_tasklet;
+	struct work_struct	card_detect_work;
+	struct work_struct	finish_work;
 
 	struct delayed_work	timeout_work;	/* Work for timeouts */
 
-- 
1.7.0.5

