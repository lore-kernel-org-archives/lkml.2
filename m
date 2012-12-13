Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab2LMOEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:04:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44233 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab2LMOEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:04:21 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Ball <cjb@laptop.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 059/241] mmc: sdhci: fix NULL dereference in sdhci_request() tuning
Date: Thu, 13 Dec 2012 11:57:04 -0200
Message-Id: <1355407206-17100-60-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 14efd957209461bbdf285bf0d67e931955d04a4c upstream.

Commit 473b095a72a9 ("mmc: sdhci: fix incorrect command used in tuning")
introduced a NULL dereference at resume-time if an SD 3.0 host controller
raises the SDHCI_NEEDS_TUNING flag while no card is inserted.  Seen on an
OLPC XO-4 with sdhci-pxav3, but presumably affects other controllers too.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/mmc/host/sdhci.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 1dffebe..732ab1a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1294,16 +1294,19 @@ static void sdhci_request(struct mmc_host *mmc, struct mmc_request *mrq)
 		 */
 		if ((host->flags & SDHCI_NEEDS_RETUNING) &&
 		    !(present_state & (SDHCI_DOING_WRITE | SDHCI_DOING_READ))) {
-			/* eMMC uses cmd21 while sd and sdio use cmd19 */
-			tuning_opcode = mmc->card->type == MMC_TYPE_MMC ?
-				MMC_SEND_TUNING_BLOCK_HS200 :
-				MMC_SEND_TUNING_BLOCK;
-			spin_unlock_irqrestore(&host->lock, flags);
-			sdhci_execute_tuning(mmc, tuning_opcode);
-			spin_lock_irqsave(&host->lock, flags);
-
-			/* Restore original mmc_request structure */
-			host->mrq = mrq;
+			if (mmc->card) {
+				/* eMMC uses cmd21 but sd and sdio use cmd19 */
+				tuning_opcode =
+					mmc->card->type == MMC_TYPE_MMC ?
+					MMC_SEND_TUNING_BLOCK_HS200 :
+					MMC_SEND_TUNING_BLOCK;
+				spin_unlock_irqrestore(&host->lock, flags);
+				sdhci_execute_tuning(mmc, tuning_opcode);
+				spin_lock_irqsave(&host->lock, flags);
+
+				/* Restore original mmc_request structure */
+				host->mrq = mrq;
+			}
 		}
 
 		if (mrq->sbc && !(host->flags & SDHCI_AUTO_CMD23))
-- 
1.7.9.5

