Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965063Ab2I1S6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:58:19 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964990Ab2I1S6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Chen <ian.cy.chen@samsung.com>, Namjae Jeon <linkinjeon@gmail.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: [ 077/262] mmc: card: Skip secure erase on MoviNAND; causes unrecoverable corruption.
Date: Fri, 28 Sep 2012 11:50:06 -0700
Message-Id: <20120928183007.135483850@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Chen <ian.cy.chen@samsung.com>

commit 3550ccdb9d8d350e526b809bf3dd92b550a74fe1 upstream.

For several MoviNAND eMMC parts, there are known issues with secure
erase and secure trim.  For these specific MoviNAND devices, we skip
these operations.

Specifically, there is a bug in the eMMC firmware that causes
unrecoverable corruption when the MMC is erased with MMC_CAP_ERASE
enabled.

References:

http://forum.xda-developers.com/showthread.php?t=1644364
https://plus.google.com/111398485184813224730/posts/21pTYfTsCkB#111398485184813224730/posts/21pTYfTsCkB

Signed-off-by: Ian Chen <ian.cy.chen@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Jaehoon Chung <jh80.chung@samsung.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/card/block.c |   26 +++++++++++++++++++++++++-
 include/linux/mmc/card.h |    1 +
 2 files changed, 26 insertions(+), 1 deletion(-)

--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1429,7 +1429,8 @@ static int mmc_blk_issue_rq(struct mmc_q
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
-		if (req->cmd_flags & REQ_SECURE)
+		if (req->cmd_flags & REQ_SECURE &&
+			!(card->quirks & MMC_QUIRK_SEC_ERASE_TRIM_BROKEN))
 			ret = mmc_blk_issue_secdiscard_rq(mq, req);
 		else
 			ret = mmc_blk_issue_discard_rq(mq, req);
@@ -1734,6 +1735,7 @@ force_ro_fail:
 #define CID_MANFID_SANDISK	0x2
 #define CID_MANFID_TOSHIBA	0x11
 #define CID_MANFID_MICRON	0x13
+#define CID_MANFID_SAMSUNG	0x15
 
 static const struct mmc_fixup blk_fixups[] =
 {
@@ -1770,6 +1772,28 @@ static const struct mmc_fixup blk_fixups
 	MMC_FIXUP(CID_NAME_ANY, CID_MANFID_MICRON, 0x200, add_quirk_mmc,
 		  MMC_QUIRK_LONG_READ_TIME),
 
+	/*
+	 * On these Samsung MoviNAND parts, performing secure erase or
+	 * secure trim can result in unrecoverable corruption due to a
+	 * firmware bug.
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
 
--- a/include/linux/mmc/card.h
+++ b/include/linux/mmc/card.h
@@ -238,6 +238,7 @@ struct mmc_card {
 #define MMC_QUIRK_BLK_NO_CMD23	(1<<7)		/* Avoid CMD23 for regular multiblock */
 #define MMC_QUIRK_BROKEN_BYTE_MODE_512 (1<<8)	/* Avoid sending 512 bytes in */
 #define MMC_QUIRK_LONG_READ_TIME (1<<9)		/* Data read time > CSD says */
+#define MMC_QUIRK_SEC_ERASE_TRIM_BROKEN (1<<10)	/* Skip secure for erase/trim */
 						/* byte mode */
 	unsigned int    poweroff_notify_state;	/* eMMC4.5 notify feature */
 #define MMC_NO_POWER_NOTIFICATION	0


