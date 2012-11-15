Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767552Ab2KOENU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 23:13:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:50087 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993399Ab2KOENM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 23:13:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Ball <cjb@laptop.org>
Subject: [ 49/57] mmc: sdhci: fix NULL dereference in sdhci_request() tuning
Date: Wed, 14 Nov 2012 20:11:57 -0800
Message-Id: <20121115040936.151320638@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
In-Reply-To: <20121115040933.223998671@linuxfoundation.org>
References: <20121115040933.223998671@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Ball <cjb@laptop.org>

commit 14efd957209461bbdf285bf0d67e931955d04a4c upstream.

Commit 473b095a72a9 ("mmc: sdhci: fix incorrect command used in tuning")
introduced a NULL dereference at resume-time if an SD 3.0 host controller
raises the SDHCI_NEEDS_TUNING flag while no card is inserted.  Seen on an
OLPC XO-4 with sdhci-pxav3, but presumably affects other controllers too.

Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1294,16 +1294,19 @@ static void sdhci_request(struct mmc_hos
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
+			if (mmc->card) {
+				/* eMMC uses cmd21 but sd and sdio use cmd19 */
+				tuning_opcode =
+					mmc->card->type == MMC_TYPE_MMC ?
+					MMC_SEND_TUNING_BLOCK_HS200 :
+					MMC_SEND_TUNING_BLOCK;
+				spin_unlock_irqrestore(&host->lock, flags);
+				sdhci_execute_tuning(mmc, tuning_opcode);
+				spin_lock_irqsave(&host->lock, flags);
 
-			/* Restore original mmc_request structure */
-			host->mrq = mrq;
+				/* Restore original mmc_request structure */
+				host->mrq = mrq;
+			}
 		}
 
 		if (mrq->sbc && !(host->flags & SDHCI_AUTO_CMD23))


