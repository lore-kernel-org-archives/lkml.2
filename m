Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab1EDQGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:06:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35764 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab1EDQGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:06:17 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2] sdio: optimized SDIO IRQ handling for single irq
Date: Wed,  4 May 2011 18:06:01 +0200
Message-Id: <1304525161-14448-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304525161-14448-1-git-send-email-per.forlin@linaro.org>
References: <1304525161-14448-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

If there is only 1 function registered it is possible to
improve performance by directly calling the irq handler
and avoiding the overhead of reading the CCCR registers.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
---
 drivers/mmc/core/sdio_irq.c |   30 ++++++++++++++++++++++++++++++
 include/linux/mmc/card.h    |    1 +
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index b300161..64c4409 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -32,6 +32,16 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 	int i, ret, count;
 	unsigned char pending;
 
+	/*
+	 * Optimization, if there is only 1 function registered
+	 * call irq handler directly
+	 */
+	if (card->sdio_single_irq && card->sdio_single_irq->irq_handler) {
+		struct sdio_func *func = card->sdio_single_irq;
+		func->irq_handler(func);
+		return 1;
+	}
+
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
 		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
@@ -186,6 +196,24 @@ static int sdio_card_irq_put(struct mmc_card *card)
 	return 0;
 }
 
+/* If there is only 1 function registered set sdio_single_irq */
+static void sdio_single_irq_set(struct mmc_card *card)
+{
+	struct sdio_func *func;
+	int i;
+
+	card->sdio_single_irq = NULL;
+	if ((card->host->caps & MMC_CAP_SDIO_IRQ) &&
+	    card->host->sdio_irqs == 1)
+		for (i = 0; i < card->sdio_funcs; i++) {
+		       func = card->sdio_func[i];
+		       if (func && func->irq_handler) {
+			       card->sdio_single_irq = func;
+			       break;
+		       }
+	       }
+}
+
 /**
  *	sdio_claim_irq - claim the IRQ for a SDIO function
  *	@func: SDIO function
@@ -227,6 +255,7 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
 	ret = sdio_card_irq_get(func->card);
 	if (ret)
 		func->irq_handler = NULL;
+	sdio_single_irq_set(func->card);
 
 	return ret;
 }
@@ -251,6 +280,7 @@ int sdio_release_irq(struct sdio_func *func)
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
 		sdio_card_irq_put(func->card);
+		sdio_single_irq_set(func->card);
 	}
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IENx, 0, &reg);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index adb4888..0d64211 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -145,6 +145,7 @@ struct mmc_card {
 	struct sdio_cccr	cccr;		/* common card info */
 	struct sdio_cis		cis;		/* common tuple info */
 	struct sdio_func	*sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */
+	struct sdio_func	*sdio_single_irq; /* SDIO function when only one IRQ active */
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
-- 
1.7.4.1

