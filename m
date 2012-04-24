Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab2DXXBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:01:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38637 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2DXWeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:31 -0400
Message-Id: <20120424223243.035100694@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Adrian Hunter <adrian.hunter@intel.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 12/62] mmc: fixes for eMMC v4.5 sanitize operation
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 283028122db37621b124f079ca8eae5b64807ad4 upstream.

eMMC v4.5 sanitize operation erases all copies of unmapped
data.  However trim or erase operations must be used first
to unmap the required sectors.  That was not being done.

Fixes apply to linux 3.2 on.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |   54 +++++++++++++++++++++++++++++++++--------------
 drivers/mmc/core/core.c  |    2 +
 2 files changed, 40 insertions(+), 16 deletions(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -874,7 +874,7 @@ static int mmc_blk_issue_secdiscard_rq(s
 {
 	struct mmc_blk_data *md = mq->data;
 	struct mmc_card *card = md->queue.card;
-	unsigned int from, nr, arg;
+	unsigned int from, nr, arg, trim_arg, erase_arg;
 	int err = 0, type = MMC_BLK_SECDISCARD;
 
 	if (!(mmc_can_secure_erase_trim(card) || mmc_can_sanitize(card))) {
@@ -882,20 +882,26 @@ static int mmc_blk_issue_secdiscard_rq(s
 		goto out;
 	}
 
+	from = blk_rq_pos(req);
+	nr = blk_rq_sectors(req);
+
 	/* The sanitize operation is supported at v4.5 only */
 	if (mmc_can_sanitize(card)) {
-		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
-				EXT_CSD_SANITIZE_START, 1, 0);
-		goto out;
+		erase_arg = MMC_ERASE_ARG;
+		trim_arg = MMC_TRIM_ARG;
+	} else {
+		erase_arg = MMC_SECURE_ERASE_ARG;
+		trim_arg = MMC_SECURE_TRIM1_ARG;
 	}
 
-	from = blk_rq_pos(req);
-	nr = blk_rq_sectors(req);
-
-	if (mmc_can_trim(card) && !mmc_erase_group_aligned(card, from, nr))
-		arg = MMC_SECURE_TRIM1_ARG;
-	else
-		arg = MMC_SECURE_ERASE_ARG;
+	if (mmc_erase_group_aligned(card, from, nr))
+		arg = erase_arg;
+	else if (mmc_can_trim(card))
+		arg = trim_arg;
+	else {
+		err = -EINVAL;
+		goto out;
+	}
 retry:
 	if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
@@ -905,25 +911,41 @@ retry:
 				 INAND_CMD38_ARG_SECERASE,
 				 0);
 		if (err)
-			goto out;
+			goto out_retry;
 	}
+
 	err = mmc_erase(card, from, nr, arg);
-	if (!err && arg == MMC_SECURE_TRIM1_ARG) {
+	if (err == -EIO)
+		goto out_retry;
+	if (err)
+		goto out;
+
+	if (arg == MMC_SECURE_TRIM1_ARG) {
 		if (card->quirks & MMC_QUIRK_INAND_CMD38) {
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 					 INAND_CMD38_ARG_EXT_CSD,
 					 INAND_CMD38_ARG_SECTRIM2,
 					 0);
 			if (err)
-				goto out;
+				goto out_retry;
 		}
+
 		err = mmc_erase(card, from, nr, MMC_SECURE_TRIM2_ARG);
+		if (err == -EIO)
+			goto out_retry;
+		if (err)
+			goto out;
 	}
-out:
-	if (err == -EIO && !mmc_blk_reset(md, card->host, type))
+
+	if (mmc_can_sanitize(card))
+		err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
+				 EXT_CSD_SANITIZE_START, 1, 0);
+out_retry:
+	if (err && !mmc_blk_reset(md, card->host, type))
 		goto retry;
 	if (!err)
 		mmc_blk_reset_success(md, type);
+out:
 	spin_lock_irq(&md->lock);
 	__blk_end_request(req, err, blk_rq_bytes(req));
 	spin_unlock_irq(&md->lock);
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1850,6 +1850,8 @@ EXPORT_SYMBOL(mmc_can_discard);
 
 int mmc_can_sanitize(struct mmc_card *card)
 {
+	if (!mmc_can_trim(card) && !mmc_can_erase(card))
+		return 0;
 	if (card->ext_csd.sec_feature_support & EXT_CSD_SEC_SANITIZE)
 		return 1;
 	return 0;


