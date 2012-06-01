Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759784Ab2FANUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:20:24 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34728 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab2FANUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:20:22 -0400
From: "Torne (Richard Coles)" <torne@google.com>
To: cjb@laptop.org
Cc: linus.walleij@linaro.org, jh80.chung@samsung.com,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben@decadent.org.uk, "Torne (Richard Coles)" <torne@google.com>
Subject: [PATCH V3] MMC: core: cap MMC card timeouts at UINT_MAX
Date: Fri,  1 Jun 2012 14:20:15 +0100
Message-Id: <1338556815-26487-1-git-send-email-torne@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAEV-rjehr=zWTetxoBCwx0FR5ZzOqZxOTFHAuv1+3u+K=YqAAw@mail.gmail.com>
References: <CAEV-rjehr=zWTetxoBCwx0FR5ZzOqZxOTFHAuv1+3u+K=YqAAw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Torne (Richard Coles)" <torne@google.com>

MMC CSD info can specify very large, ridiculous timeouts, big enough to
overflow timeout_ns. This can result in the card timing out on every
operation because the wrapped timeout value is far too small.

Fix the overflow by capping the result at UINT_MAX.  Cards specifying
longer timeouts are almost certainly insane, and host controllers
generally cannot support timeouts that long in any case.

Signed-off-by: Torne (Richard Coles) <torne@google.com>
---
 drivers/mmc/core/core.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 0b6141d..74ec3d4 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -512,7 +512,16 @@ void mmc_set_data_timeout(struct mmc_data *data, const struct mmc_card *card)
 	if (data->flags & MMC_DATA_WRITE)
 		mult <<= card->csd.r2w_factor;
 
-	data->timeout_ns = card->csd.tacc_ns * mult;
+	/*
+	 * The timeout in nanoseconds may overflow with some cards. Cap it at
+	 * UINT_MAX to avoid the overflow; host controllers cannot generally
+	 * generate timeouts that long anyway.
+	 */
+	if (card->csd.tacc_ns <= UINT_MAX / mult)
+		data->timeout_ns = card->csd.tacc_ns * mult;
+	else
+		data->timeout_ns = UINT_MAX;
+
 	data->timeout_clks = card->csd.tacc_clks * mult;
 
 	/*
-- 
1.7.7.3

