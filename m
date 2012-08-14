Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388Ab2HNEHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 00:07:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40613 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab2HNEHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 00:07:49 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-55-5029cf1325f6
Message-id: <5029CE38.4000407@samsung.com>
Date: Tue, 14 Aug 2012 13:04:08 +0900
From: IAN CHEN <ian.cy.chen@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: d.j.shin@samsung.com, jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com, ian.cy.chen@samsung.com
Subject: [PATCH v2] mmc: card: Skip secure option for MoviNAND.
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jAV3h85oBBn1TzC0u75rDZnHkfz+j
	A5PH501yAYxRXDYpqTmZZalF+nYJXBn7/1xlLpgqXrFi3jXmBsbjwl2MnBwSAiYSa//8YIaw
	xSQu3FvPBmILCSxilGi/7dHFyAVkv2aUaLn6ihUkwSugJdG5cTJYA4uAqsSW7V9YQGw2AQ2J
	7wefMILYogJhEoveH4CqF5T4MfkeC8ggEYGNjBKnO/aCOcwCjYwS895NB6sSFrCXmLbzGthq
	ZgEdif2t06BseYnNa94yT2Dkm4Vk2CwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERxez6R3MK5qsDjEKMDBqMTDW5ioGSDEmlhWXJl7iFGCg1lJhPd+D1CINyWxsiq1KD++
	qDQntfgQozQHi5I4r4n3V38hgfTEktTs1NSC1CKYLBMHp1QDo4gzo/YH/cRSt5bKBf8M1+82
	SLwx75K0v/K31UaBc4Ttly6/dvT0k6VHH/g0qfqsZ1T3O2+iPzU9h5Xt6Y0GQdOqoMXn9kzd
	xRa5Y7FXqk3iAz4Wyf9CK1qzjhVJ35zG/DHL9elN//21hQsnTOj09t2w7fSRvnP7Uxv6+K6p
	8C3NqQnsNr8sp8RSnJFoqMVcVJwIAIEiLB4rAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For several MoviNAND, there are some known issue with secure option.
For these specific MoviNAND device, we skip secure option.

Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
---
 drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
 include/linux/mmc/card.h |    1 +
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f1c84de..a01cc14 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
struct request *req)
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
+		if (req->cmd_flags & REQ_SECURE &&
+			!(card->quirks & MMC_QUIRK_SKIP_SECURE))
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
@@ -1716,6 +1717,7 @@ force_ro_fail:
 #define CID_MANFID_SANDISK	0x2
 #define CID_MANFID_TOSHIBA	0x11
 #define CID_MANFID_MICRON	0x13
+#define CID_MANFID_SAMSUNG	0x15

 static const struct mmc_fixup blk_fixups[] =
 {
@@ -1752,6 +1754,26 @@ static const struct mmc_fixup blk_fixups[] =
 	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_MICRON, 0x200, add_quirk_mmc,
 		  MMC_QUIRK_LONG_READ_TIME),

+	/*
+	 * Some issue about secure erase/secure trim for Samsung MoviNAND
+	 */
+	MMC_FIXUP("M8G2FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_MOVINAND_SECURE),
+
 	END_FIXUP
 };

diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 111aca5..b639a92 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -239,6 +239,7 @@ struct mmc_card {
 #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular
multiblock */
 #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512
bytes in */
 #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
+#define MMC_QUIRK_SKIP_SECURE (1<<10)		/* Skip secure for erase/trim */
 						/* byte mode */
 	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
 #define MMC_NO_POWER_NOTIFICATION	0
-- 
1.7.0.4
