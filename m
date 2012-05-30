Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187Ab2E3Blv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:41:51 -0400
Received: from masquerade.micron.com ([137.201.242.130]:46526 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab2E3Blu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:41:50 -0400
Message-ID: <4FC57ADB.4020408@micron.com>
Date: Tue, 29 May 2012 18:41:47 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 03/11] mtip32xx: Change HDIO_GET_IDENTITY to return stored
 data
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--0.344500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For the ioctl command HDIO_GET_IDENTITY, return the stored copy of IDENTIFY
DATA instead of sending the command to the device - similar to libata.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index bbbdaf9..8b7f82b 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2295,13 +2295,12 @@ static int mtip_hw_ioctl(struct driver_data *dd, unsigned int cmd,
 {
 	switch (cmd) {
 	case HDIO_GET_IDENTITY:
-		if (mtip_get_identify(dd->port, (void __user *) arg) < 0) {
-			dev_warn(&dd->pdev->dev,
-				"Unable to read identity\n");
-			return -EIO;
-		}
-
+	{
+		if (copy_to_user((void __user *)arg, dd->port->identify,
+						sizeof(u16) * ATA_ID_WORDS))
+			return -EFAULT;
 		break;
+	}
 	case HDIO_DRIVE_CMD:
 	{
 		u8 drive_command[4];
-- 
1.7.1

