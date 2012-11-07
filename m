Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab2KGMeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:34:16 -0500
Received: from masquerade.micron.com ([137.201.242.130]:13978 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab2KGMeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:34:13 -0500
Message-ID: <509A5C29.1060803@micron.com>
Date: Wed, 7 Nov 2012 06:03:37 -0700
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <sbradshaw@micron.com>, <asamymuthupa@micron.com>,
        <linux-kernel@vger.kernel.org>, <dan.carpenter@oracle.com>,
        <alan@linux.intel.com>
Subject: [PATCH 1/3] mtip32xx: fix potential crash on SEC_ERASE_UNIT
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19346.007
X-TM-AS-Result: No--10.040000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The mtip driver lifted this code from elsewhere and then added a special
handling check for SEC_ERASE_UNIT. If the caller tries to do a security
erase but passes no output data for the command then outbuf is not
allocated and the driver duly explodes.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Selvan Mani <smani@micron.com>
Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index adc6f36..dfb7196 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2218,8 +2218,8 @@ static int exec_drive_taskfile(struct driver_data *dd,
 		fis.device);
 
 	/* check for erase mode support during secure erase.*/
-	if ((fis.command == ATA_CMD_SEC_ERASE_UNIT)
-					&& (outbuf[0] & MTIP_SEC_ERASE_MODE)) {
+	if ((fis.command == ATA_CMD_SEC_ERASE_UNIT) && outbuf &&
+					(outbuf[0] & MTIP_SEC_ERASE_MODE)) {
 		erasemode = 1;
 	}
 
-- 
1.7.1
