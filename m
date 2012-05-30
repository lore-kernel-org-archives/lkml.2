Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab2E3Bnj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 21:43:39 -0400
Received: from masquerade.micron.com ([137.201.242.130]:58272 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756160Ab2E3Bne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 21:43:34 -0400
Message-ID: <4FC57B43.4000303@micron.com>
Date: Tue, 29 May 2012 18:43:31 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: [PATCH 07/11] mtip32xx: Fix to support more than one sector in exec_drive_command()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.800.1017-18936.003
X-TM-AS-Result: No--4.964300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix to support more than one sector in exec_drive_command().

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   60 +++++++++++++++++++++++++++----------
 1 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index a8a5522..acc1d6f 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -1890,13 +1890,33 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 				void __user *user_buffer)
 {
 	struct host_to_dev_fis	fis;
-	struct host_to_dev_fis *reply = (port->rxfis + RX_FIS_D2H_REG);
+	struct host_to_dev_fis *reply;
+	u8 *buf = NULL;
+	dma_addr_t dma_addr = 0;
+	int rv = 0, xfer_sz = command[3];
+
+	if (xfer_sz) {
+		if (user_buffer)
+			return -EFAULT;
+
+		buf = dmam_alloc_coherent(&port->dd->pdev->dev,
+				ATA_SECT_SIZE * xfer_sz,
+				&dma_addr,
+				GFP_KERNEL);
+		if (!buf) {
+			dev_err(&port->dd->pdev->dev,
+				"Memory allocation failed (%d bytes)\n",
+				ATA_SECT_SIZE * xfer_sz);
+			return -ENOMEM;
+		}
+		memset(buf, 0, ATA_SECT_SIZE * xfer_sz);
+	}
 
 	/* Build the FIS. */
 	memset(&fis, 0, sizeof(struct host_to_dev_fis));
-	fis.type		= 0x27;
-	fis.opts		= 1 << 7;
-	fis.command		= command[0];
+	fis.type	= 0x27;
+	fis.opts	= 1 << 7;
+	fis.command	= command[0];
 	fis.features	= command[2];
 	fis.sect_count	= command[3];
 	if (fis.command == ATA_CMD_SMART) {
@@ -1905,6 +1925,11 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 		fis.cyl_hi	= 0xC2;
 	}
 
+	if (xfer_sz)
+		reply = (port->rxfis + RX_FIS_PIO_SETUP);
+	else
+		reply = (port->rxfis + RX_FIS_D2H_REG);
+
 	dbg_printk(MTIP_DRV_NAME
 		" %s: User Command: cmd %x, sect %x, "
 		"feat %x, sectcnt %x\n",
@@ -1914,43 +1939,46 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
 		command[2],
 		command[3]);
 
-	memset(port->sector_buffer, 0x00, ATA_SECT_SIZE);
-
 	/* Execute the command. */
 	if (mtip_exec_internal_command(port,
 				&fis,
 				 5,
-				 port->sector_buffer_dma,
-				 (command[3] != 0) ? ATA_SECT_SIZE : 0,
+				 (xfer_sz ? dma_addr : 0),
+				 (xfer_sz ? ATA_SECT_SIZE * xfer_sz : 0),
 				 0,
 				 GFP_KERNEL,
 				 MTIP_IOCTL_COMMAND_TIMEOUT_MS)
 				 < 0) {
-		return -1;
+		rv = -EFAULT;
+		goto exit_drive_command;
 	}
 
 	/* Collect the completion status. */
 	command[0] = reply->command; /* Status*/
 	command[1] = reply->features; /* Error*/
-	command[2] = command[3];
+	command[2] = reply->sect_count;
 
 	dbg_printk(MTIP_DRV_NAME
 		" %s: Completion Status: stat %x, "
-		"err %x, cmd %x\n",
+		"err %x, nsect %x\n",
 		__func__,
 		command[0],
 		command[1],
 		command[2]);
 
-	if (user_buffer && command[3]) {
+	if (xfer_sz) {
 		if (copy_to_user(user_buffer,
-				 port->sector_buffer,
+				 buf,
 				 ATA_SECT_SIZE * command[3])) {
-			return -EFAULT;
+			rv = -EFAULT;
+			goto exit_drive_command;
 		}
 	}
-
-	return 0;
+exit_drive_command:
+	if (buf)
+		dmam_free_coherent(&port->dd->pdev->dev,
+				ATA_SECT_SIZE * xfer_sz, buf, dma_addr);
+	return rv;
 }
 
 /*
-- 
1.7.1

