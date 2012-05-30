Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2E3Bl1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:41:27 -0400
Received: from masquerade.micron.com ([137.201.242.130]:19942 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab2E3Bl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:41:26 -0400
Message-ID: <4FC57AC3.3070601@micron.com>
Date: Tue, 29 May 2012 18:41:23 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 02/11] mtip32xx: Set custom timeouts for PIO commands
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--17.011100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change sets custom timeouts depending on PIO command.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   55 +++++++++++++++++++------------------
 1 files changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f9cf905..bbbdaf9 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2002,6 +2002,32 @@ static unsigned int implicit_sector(unsigned char command,
 	return rv;
 }
 
+static void mtip_set_timeout(struct host_to_dev_fis *fis, unsigned int *timeout)
+{
+	switch (fis->command) {
+	case ATA_CMD_DOWNLOAD_MICRO:
+		*timeout = 120000; /* 2 minutes */
+		break;
+	case ATA_CMD_SEC_ERASE_UNIT:
+	case 0xFC:
+		*timeout = 240000; /* 4 minutes */
+		break;
+	case ATA_CMD_STANDBYNOW1:
+		*timeout = 10000;  /* 10 seconds */
+		break;
+	case 0xF7:
+	case 0xFA:
+		*timeout = 60000;  /* 60 seconds */
+		break;
+	case ATA_CMD_SMART:
+		*timeout = 15000;  /* 15 seconds */
+		break;
+	default:
+		*timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
+		break;
+	}
+}
+
 /*
  * Executes a taskfile
  * See ide_taskfile_ioctl() for derivation
@@ -2022,7 +2048,7 @@ static int exec_drive_taskfile(struct driver_data *dd,
 	unsigned int taskin = 0;
 	unsigned int taskout = 0;
 	u8 nsect = 0;
-	unsigned int timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
+	unsigned int timeout;
 	unsigned int force_single_sector;
 	unsigned int transfer_size;
 	unsigned long task_file_data;
@@ -2152,32 +2178,7 @@ static int exec_drive_taskfile(struct driver_data *dd,
 		fis.lba_hi,
 		fis.device);
 
-	switch (fis.command) {
-	case ATA_CMD_DOWNLOAD_MICRO:
-		/* Change timeout for Download Microcode to 2 minutes */
-		timeout = 120000;
-		break;
-	case ATA_CMD_SEC_ERASE_UNIT:
-		/* Change timeout for Security Erase Unit to 4 minutes.*/
-		timeout = 240000;
-		break;
-	case ATA_CMD_STANDBYNOW1:
-		/* Change timeout for standby immediate to 10 seconds.*/
-		timeout = 10000;
-		break;
-	case 0xF7:
-	case 0xFA:
-		/* Change timeout for vendor unique command to 10 secs */
-		timeout = 10000;
-		break;
-	case ATA_CMD_SMART:
-		/* Change timeout for vendor unique command to 15 secs */
-		timeout = 15000;
-		break;
-	default:
-		timeout = MTIP_IOCTL_COMMAND_TIMEOUT_MS;
-		break;
-	}
+	mtip_set_timeout(&fis, &timeout);
 
 	/* Determine the correct transfer size.*/
 	if (force_single_sector)
-- 
1.7.1

