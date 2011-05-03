Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab1ECUGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 16:06:16 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35434 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668Ab1ECUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 16:06:13 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>,
        Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>,
        Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] sdio: optimized SDIO IRQ handling for single function
Date: Tue,  3 May 2011 22:04:47 +0200
Message-Id: <1304453087-7365-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>

If there is only 1 function registered, and IRQ:s are supported and
currently enabled, call the callback handler directly
without checking the CCCR registers.

Signed-off-by: Stefan Nilsson XK <stefan.xk.nilsson@stericsson.com>
Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/sdio_irq.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index b300161..25291bf 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -32,6 +32,20 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 	int i, ret, count;
 	unsigned char pending;
 
+	/*
+	 * If there is only 1 function registered
+	 * call irq directly without checking the CCCR registers.
+	 */
+	if ((card->host->caps & MMC_CAP_SDIO_IRQ) &&
+	    card->host->sdio_irqs && (card->sdio_funcs == 1))
+		for (i = 0; i < SDIO_MAX_FUNCS; i++) {
+			struct sdio_func *func = card->sdio_func[i];
+			if (func && func->irq_handler) {
+				func->irq_handler(func);
+				return 1;
+			}
+		}
+
 	ret = mmc_io_rw_direct(card, 0, 0, SDIO_CCCR_INTx, 0, &pending);
 	if (ret) {
 		printk(KERN_DEBUG "%s: error %d reading SDIO_CCCR_INTx\n",
-- 
1.7.4.1

