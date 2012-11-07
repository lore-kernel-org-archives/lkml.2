Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985Ab2KGMeP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:34:15 -0500
Received: from masquerade.micron.com ([137.201.242.130]:39690 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab2KGMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:34:13 -0500
Message-ID: <509A5C39.40609@micron.com>
Date: Wed, 7 Nov 2012 06:03:53 -0700
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <asamymuthupa@micron.com>, <sbradshaw@micron.com>,
        <linux-kernel@vger.kernel.org>, <dan.carpenter@oracle.com>
Subject: [PATCH 2/3] mtip32xx: Fix to make lba address correct in big-endian
 systems
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19346.007
X-TM-AS-Result: No--1.425500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Earlier lba address was assigned directly to lba_low and lba_low_ex,
which would result in a different number (bytes reversed) in
big-endian systems. Now assigning lba address byte-by-byte to fis.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index dfb7196..df46b5a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2465,8 +2465,12 @@ static void mtip_hw_submit_io(struct driver_data *dd, sector_t start,
 	fis->opts        = 1 << 7;
 	fis->command     =
 		(dir == READ ? ATA_CMD_FPDMA_READ : ATA_CMD_FPDMA_WRITE);
-	*((unsigned int *) &fis->lba_low) = (start & 0xFFFFFF);
-	*((unsigned int *) &fis->lba_low_ex) = ((start >> 24) & 0xFFFFFF);
+	fis->lba_low     = start & 0xFF;
+	fis->lba_mid     = (start >> 8) & 0xFF;
+	fis->lba_hi      = (start >> 16) & 0xFF;
+	fis->lba_low_ex  = (start >> 24) & 0xFF;
+	fis->lba_mid_ex  = (start >> 32) & 0xFF;
+	fis->lba_hi_ex   = (start >> 40) & 0xFF;
 	fis->device	 = 1 << 6;
 	fis->features    = nsect & 0xFF;
 	fis->features_ex = (nsect >> 8) & 0xFF;
-- 
1.7.1
