Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2I0M25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 08:28:57 -0400
Received: from masquerade.micron.com ([137.201.242.130]:51355 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285Ab2I0M24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 08:28:56 -0400
Message-ID: <50644D1D.9040708@micron.com>
Date: Thu, 27 Sep 2012 06:57:01 -0600
From: Selvan Mani <smani@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: <axboe@kernel.dk>
CC: <linux-kernel@vger.kernel.org>, <sbradshaw@micron.com>,
        <asamymuthupa@micron.com>
Subject: mtip32xx:Added appropriate timeout value for secure erase
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19214.007
X-TM-AS-Result: No--12.103300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Please queue this patch for 3.7.

Added appropriate timeout value for secure erase based on identify device data

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Selvan Mani <smani@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   19 +++++++++++++++----
 drivers/block/mtip32xx/mtip32xx.h |    3 +++
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f56205f..cbaacd7 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2038,8 +2038,9 @@ static unsigned int implicit_sector(unsigned char command,
 	}
 	return rv;
 }
-
-static void mtip_set_timeout(struct host_to_dev_fis *fis, unsigned int *timeout)
+static void mtip_set_timeout(struct driver_data *dd,
+					struct host_to_dev_fis *fis,
+					unsigned int *timeout, u8 erasemode)
 {
 	switch (fis->command) {
 	case ATA_CMD_DOWNLOAD_MICRO:
@@ -2047,7 +2048,10 @@ static void mtip_set_timeout(struct host_to_dev_fis *fis, unsigned int *timeout)
 		break;
 	case ATA_CMD_SEC_ERASE_UNIT:
 	case 0xFC:
-		*timeout = 240000; /* 4 minutes */
+		if (erasemode)
+			*timeout = ((*(dd->port->identify + 90) * 2) * 60000);
+		else
+			*timeout = ((*(dd->port->identify + 89) * 2) * 60000);
 		break;
 	case ATA_CMD_STANDBYNOW1:
 		*timeout = 120000;  /* 2 minutes */
@@ -2090,6 +2094,7 @@ static int exec_drive_taskfile(struct driver_data *dd,
 	unsigned int transfer_size;
 	unsigned long task_file_data;
 	int intotal = outtotal + req_task->out_size;
+	int erasemode = 0;
 
 	taskout = req_task->out_size;
 	taskin = req_task->in_size;
@@ -2215,7 +2220,13 @@ static int exec_drive_taskfile(struct driver_data *dd,
 		fis.lba_hi,
 		fis.device);
 
-	mtip_set_timeout(&fis, &timeout);
+	/* check for erase mode support during secure erase.*/
+	if ((fis.command == ATA_CMD_SEC_ERASE_UNIT)
+					&& (outbuf[0] & MTIP_SEC_ERASE_MODE)) {
+		erasemode = 1;
+	}
+
+	mtip_set_timeout(dd, &fis, &timeout, erasemode);
 
 	/* Determine the correct transfer size.*/
 	if (force_single_sector)
diff --git a/drivers/block/mtip32xx/mtip32xx.h b/drivers/block/mtip32xx/mtip32xx.h
index 18627a1..8498e99 100644
--- a/drivers/block/mtip32xx/mtip32xx.h
+++ b/drivers/block/mtip32xx/mtip32xx.h
@@ -33,6 +33,9 @@
 /* offset of Device Control register in PCIe extended capabilites space */
 #define PCIE_CONFIG_EXT_DEVICE_CONTROL_OFFSET	0x48
 
+/* check for erase mode support during secure erase */
+#define MTIP_SEC_ERASE_MODE     0x3
+
 /* # of times to retry timed out/failed IOs */
 #define MTIP_MAX_RETRIES	2
 
-- 
1.7.1


