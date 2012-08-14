Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab2HNHKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 03:10:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53149 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2HNHKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 03:10:11 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-2e-5029f9d11c10
Message-id: <5029F8F6.1080207@samsung.com>
Date: Tue, 14 Aug 2012 16:06:30 +0900
From: IAN CHEN <ian.cy.chen@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: d.j.shin@samsung.com, jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com, ian.cy.chen@samsung.com
Subject: [PATCH v3] mmc: card: Skip secure option for MoviNAND.
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t9jQd2LPzUDDB5u1bC4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWc3niRqWCKZMWBP32MDYzbRbsYOTkkBEwkVp5rZoKw
	xSQu3FvPBmILCUxnlPj9qw7Cfs0osfJyfRcjBwevgJbEiZlxIGEWAVWJabs+gJWzCWhIfD/4
	hBHEFhUIk1j0/gAriM0rICjxY/I9li5GLg4RgY2MEqc79oI5zAKNjBLz3k0HqxIWsJfYteEq
	2BHMAjoS+1unsUHY8hKb17xlnsDINwvJsFlIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzi0nkntYFzZYHGIUYCDUYmHVyFNM0CINbGsuDL3EKMEB7OSCO+zj0Ah3pTEyqrU
	ovz4otKc1OJDjNIcLErivMbeX/2FBNITS1KzU1MLUotgskwcnFINjBt9lXmiZr36X2V2f3W2
	2ge/95+vCPvoTrowVbuwvOZmWnlRvXCtjnr0/Vn5X3faB6jeXF6573XZ9Eyd0wtvB0uKBm48
	vjapg9Fxs1XwhYnyCxgDt2gaKlU5Pzs86/LjNz6TedJ85tp5J36NOGNsrs92SSlklZqhLsf2
	gzlHluVHz1B4/9awR4mlOCPRUIu5qDgRAHQELpopAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For several MoviNAND, there are some known issue with secure option.
For these specific MoviNAND device, we skip secure option.

You could refer this discussion in XDA developers.
http://forum.xda-developers.com/showthread.php?t=1644364
https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB

Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
---
 drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
 include/linux/mmc/card.h |    1 +
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f1c84de..8d2de7e 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
struct request *req)
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
+		if (req->cmd_flags & REQ_SECURE &&
+			!(card->quirks & MMC_QUIRK_SECURE_MODE_BROKEN))
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
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SECURE_MODE_BROKEN),
+
 	END_FIXUP
 };

diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 111aca5..e7ec522 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -239,6 +239,7 @@ struct mmc_card {
 #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular
multiblock */
 #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512
bytes in */
 #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
+#define MMC_QUIRK_SECURE_MODE_BROKEN (1<<10)	/* Skip secure for
erase/trim */
 						/* byte mode */
 	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
 #define MMC_NO_POWER_NOTIFICATION	0
-- 
1.7.0.4
