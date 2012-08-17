Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab2HQHNz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 03:13:55 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22110 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202Ab2HQHNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 03:13:53 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-1d-502def285125
Message-id: <502DEE45.40405@samsung.com>
Date: Fri, 17 Aug 2012 16:09:57 +0900
From: IAN CHEN <ian.cy.chen@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714
 Thunderbird/14.0
MIME-version: 1.0
To: cjb@laptop.org, linkinjeon@gmail.com, adrian.hunter@intel.com,
        subhashj@codeaurora.org, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: d.j.shin@samsung.com, jongtae22.kim@samsung.com, kyungmin.park@samsung.com,
        jh80.chung@samsung.com, ian.cy.chen@samsung.com
Subject: [PATCH v5] mmc: card: Skip secure option for MoviNAND.
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBLMWRmVeSWpSXmKPExsVy+t9jQV2N97oBBltvSVtc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJ+zJjFXjBVquLn9GusDYzrxLoYOTkkBEwkPl1bxwxh
	i0lcuLeeDcQWEpjOKDFjoVcXIxeQ/ZpRYtuiA+wgCV4BDYmTh6+AFbEIqEpMunqPEcRmA4p/
	P/gEzBYVCJNY9P4AK0S9oMSPyfdYQAaJCGxklDjdsRfMYRZoZJSY9246WJWwgL3E9P0PwWxm
	AR2J/a3T2CBseYnNa94yT2Dkm4Vk2CwkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERxez6R3MK5qsDjEKMDBqMTDe6BMN0CINbGsuDL3EKMEB7OSCO/yQKAQb0piZVVqUX58
	UWlOavEhRmkOFiVxXhPvr/5CAumJJanZqakFqUUwWSYOTqkGxgktfy6UtDOpTzhR4W/4n1mH
	vbK+ac++nYFeDROyyz+u1k5o+slvkGfU9+L4+iebkwMWm6m437ui7qCSIGFa0xaTkjt/zVFB
	6X8/7r9bIPmQy19L1d+l/vR6kXlq0yxvMTGk5369U5nl+ufz8pkpiZciD3zL88rYxlQhWHDx
	ygYbhq3/9DZeUmIpzkg01GIuKk4EAIdVqE8rAgAA
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
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 drivers/mmc/card/block.c |   24 +++++++++++++++++++++++-
 include/linux/mmc/card.h |    1 +
 2 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index f1c84de..0377885 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1411,7 +1411,8 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq,
struct request *req)
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
+		if (req->cmd_flags & REQ_SECURE &&
+			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
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
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MAG4FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MBG8FA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("MCGAFA", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VAL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("KYL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+	MMC_FIXUP("VZL00M", CID_MANFID_SAMSUNG, CID_OEMID_ANY, add_quirk_mmc,
+		  MMC_QUIRK_SEC_ERASE_TRIM_BROKEN),
+
 	END_FIXUP
 };

diff --git a/include/linux/mmc/card.h b/include/linux/mmc/card.h
index 111aca5..4b27f9f 100644
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -239,6 +239,7 @@ struct mmc_card {
 #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular
multiblock */
 #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512
bytes in */
 #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
+#define MMC_QUIRK_SEC_ERASE_TRIM_BROKEN (1<<10)	/* Skip secure for
erase/trim */
 						/* byte mode */
 	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
 #define MMC_NO_POWER_NOTIFICATION	0
-- 
1.7.0.4
