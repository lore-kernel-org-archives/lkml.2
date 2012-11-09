Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2KIJRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 04:17:08 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:7561 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab2KIJRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 04:17:04 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2012 04:17:04 EST
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1de0h1202h1d1ah1d2ah1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <dwmw2@infradead.org>
CC: <dedekind1@gmail.com>, <computersforpeace@gmail.com>,
        <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH] mtd: de-select the chip when it is not used
Date: Fri, 9 Nov 2012 16:23:45 +0800
Message-ID: <1352449425-16496-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we scan several nand chips with nand_scan(), such as
     .......................
      nand_scan(*, 2);
     .......................

In nand_scan_ident(), the maxchips will become 2, so the current code
will select chip 1 to read the device ID. But the chip 0 is still
selected in this case.

To make the logic clear, we'd better de-select the chip when it is not used.

This patch de-select the nand chip if it is not used any more.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/mtd/nand/nand_base.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index ec6841d..fd5fa3b 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -3325,6 +3325,8 @@ int nand_scan_ident(struct mtd_info *mtd, int maxchips,
 		return PTR_ERR(type);
 	}
 
+	chip->select_chip(mtd, -1);
+
 	/* Check for a chip array */
 	for (i = 1; i < maxchips; i++) {
 		chip->select_chip(mtd, i);
@@ -3334,8 +3336,11 @@ int nand_scan_ident(struct mtd_info *mtd, int maxchips,
 		chip->cmdfunc(mtd, NAND_CMD_READID, 0x00, -1);
 		/* Read manufacturer and device IDs */
 		if (nand_maf_id != chip->read_byte(mtd) ||
-		    nand_dev_id != chip->read_byte(mtd))
+		    nand_dev_id != chip->read_byte(mtd)) {
+			chip->select_chip(mtd, -1);
 			break;
+		}
+		chip->select_chip(mtd, -1);
 	}
 	if (i > 1)
 		pr_info("%d NAND chips detected\n", i);
@@ -3594,9 +3599,6 @@ int nand_scan_tail(struct mtd_info *mtd)
 	/* Initialize state */
 	chip->state = FL_READY;
 
-	/* De-select the device */
-	chip->select_chip(mtd, -1);
-
 	/* Invalidate the pagebuffer reference */
 	chip->pagebuf = -1;
 
-- 
1.7.0.4


