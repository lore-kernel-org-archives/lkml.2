Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab1EKPxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:53:51 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34520 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1EKPsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:48:51 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Chris Ball <cjb@laptop.org>
Cc: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v5] sdio: optimized SDIO IRQ handling for single irq
Date: Wed, 11 May 2011 17:48:05 +0200
Message-Id: <1305128885-21275-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305128885-21275-1-git-send-email-per.forlin@linaro.org>
References: <1305128885-21275-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

If there is only 1 function interrupt registered it is possible to
improve performance by directly calling the irq handler
and avoiding the overhead of reading the CCCR registers.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
Reviewed-by: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 drivers/mmc/core/sdio_irq.c |   33 ++++++++++++++++++++++++++++++++-
 include/linux/mmc/card.h    |    1 +
 2 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index bb192f9..a0890ac 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -31,6 +31,17 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 {
 	int i, ret, count;
 	unsigned char pending;
+	struct sdio_func *func;
+
+	/*
+	 * Optimization, if there is only 1 function interrupt registered
+	 * call irq handler directly
+	 */
+	func = card->sdio_single_irq;
+	if (func) {
+		func->irq_handler(func);
+		return 1;
+	}
 
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
@@ -42,7 +53,7 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 	count = 0;
 	for (i = 1; i <= 7; i++) {
 		if (pending & (1 << i)) {
-			struct sdio_func *func = card->sdio_func[i - 1];
+			func = card->sdio_func[i - 1];
 			if (!func) {
 				printk(KERN_WARNING "%s: pending IRQ for "
 					"non-existant function\n",
@@ -186,6 +197,24 @@ static int sdio_card_irq_put(struct mmc_card *card)
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
@@ -227,6 +256,7 @@ int sdio_claim_irq(struct sdio_func *func, sdio_irq_handler_t *handler)
 	ret = sdio_card_irq_get(func->card);
 	if (ret)
 		func->irq_handler = NULL;
+	sdio_single_irq_set(func->card);
 
 	return ret;
 }
@@ -251,6 +281,7 @@ int sdio_release_irq(struct sdio_func *func)
 	if (func->irq_handler) {
 		func->irq_handler = NULL;
 		sdio_card_irq_put(func->card);
+		sdio_single_irq_set(func->card);
 	}
 
 	ret = mmc_io_rw_direct(func->card, 0, 0, SDIO_CCCR_IENx, 0, &reg);
diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index d8dffc9..4910dec 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -191,6 +191,7 @@ struct mmc_card {
 	struct sdio_cccr	cccr;		/* common card info */
 	struct sdio_cis		cis;		/* common tuple info */
 	struct sdio_func	*sdio_func[SDIO_MAX_FUNCS]; /* SDIO functions (devices) */
+	struct sdio_func	*sdio_single_irq; /* SDIO function when only one IRQ active */
 	unsigned		num_info;	/* number of info strings */
 	const char		**info;		/* info strings */
 	struct sdio_func_tuple	*tuples;	/* unknown common tuples */
-- 
1.7.4.1

