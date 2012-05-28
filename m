Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2E1Rg5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 13:36:57 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:52503 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab2E1Rg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 13:36:56 -0400
From: "Torne (Richard Coles)" <torne@google.com>
To: cjb@laptop.org
Cc: linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk, "Torne (Richard Coles)" <torne@google.com>
Subject: [PATCH V2] MMC: core: cap MMC card timeouts at 2 seconds.
Date: Mon, 28 May 2012 18:31:18 +0100
Message-Id: <1338226278-13336-1-git-send-email-torne@google.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Torne (Richard Coles)" <torne@google.com>

MMC CSD info can specify very large, ridiculous timeouts, big enough to
overflow timeout_ns on 32-bit machines. This can result in the card
timing out on every operation because the wrapped timeout value is far
too small.

Fix the overflow by capping the result at 2 seconds.  Cards specifying
longer timeouts are almost certainly insane, and host controllers
generally cannot support timeouts that long in any case.

2 seconds should be plenty of time for any card to actually function;
the timeout calculation code is already using 1 second as a "worst case"
timeout for cards running in SPI mode.
---
 drivers/mmc/core/core.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 0b6141d..3b4a9fc 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
 	if (data->flags & MMC_DATA_WRITE)
 		mult <<= card->csd.r2w_factor;
 
-	data->timeout_ns = card->csd.tacc_ns * mult;
+	/*
+	 * The timeout in nanoseconds may overflow with some cards. Cap it at
+	 * two seconds both to avoid the overflow and also because host
+	 * controllers cannot generally generate timeouts that long anyway.
+	 */
+	if (card->csd.tacc_ns <= (2 * NSEC_PER_SEC) / mult)
+		data->timeout_ns = card->csd.tacc_ns * mult;
+	else
+		data->timeout_ns = 2 * NSEC_PER_SEC;
+
 	data->timeout_clks = card->csd.tacc_clks * mult;
 
 	/*
-- 
1.7.7.3

