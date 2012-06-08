Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab2FHWY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 18:24:59 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51399 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab2FHWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 18:24:56 -0400
From: mathieu.poirier@linaro.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
Subject: [PATCH RESEND 2/6] mg_disk: use readb/writeb instead of inb/outb
Date: Fri,  8 Jun 2012 16:24:36 -0600
Message-Id: <1339194280-27475-3-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
References: <1339194280-27475-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The inb/outb functions are meant for PC-style programmed I/O,
which uses port numbers, not __iomem pointers. This driver
relies on ioremap to map the MMIO registers into the kernel
address space, so it should use the appropriate accessors.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/block/mg_disk.c |   78 +++++++++++++++++++++++-----------------------
 1 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 76fa3de..7d94fb0 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -187,7 +187,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
 	if ((stat & ATA_ERR) == 0) {
 		host->error = 0;
 	} else {
-		host->error = inb((unsigned long)host->dev_base + MG_REG_ERROR);
+		host->error = readb(host->dev_base + MG_REG_ERROR);
 		printk(KERN_ERR "%s: %s: error=0x%02x { ", name, msg,
 				host->error & 0xff);
 		if (host->error & ATA_BBK)
@@ -225,11 +225,11 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 	 * busy wait, because mflash's PLL is machine dependent.
 	 */
 	if (prv_data->use_polling) {
-		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
-		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		status = readb(host->dev_base + MG_REG_STATUS);
+		status = readb(host->dev_base + MG_REG_STATUS);
 	}
 
-	status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	status = readb(host->dev_base + MG_REG_STATUS);
 
 	do {
 		cur_jiffies = jiffies;
@@ -256,7 +256,7 @@ static unsigned int mg_wait(struct mg_host *host, u32 expect, u32 msec)
 			return MG_ERR_INV_STAT;
 		}
 
-		status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		status = readb(host->dev_base + MG_REG_STATUS);
 	} while (time_before(cur_jiffies, expire));
 
 	if (time_after_eq(cur_jiffies, expire) && msec)
@@ -281,7 +281,7 @@ static unsigned int mg_wait_rstout(u32 rstout, u32 msec)
 
 static void mg_unexpected_intr(struct mg_host *host)
 {
-	u32 status = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+	u32 status = readb(host->dev_base + MG_REG_STATUS);
 
 	mg_dump_status("mg_unexpected_intr", status, host);
 }
@@ -351,18 +351,18 @@ static int mg_get_disk_id(struct mg_host *host)
 	char serial[ATA_ID_SERNO_LEN + 1];
 
 	if (!prv_data->use_polling)
-		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(ATA_NIEN, host->dev_base + MG_REG_DRV_CTRL);
 
-	outb(MG_CMD_ID, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_ID, host->dev_base + MG_REG_COMMAND);
 	err = mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_RD_DRQ);
 	if (err)
 		return err;
 
 	for (i = 0; i < (MG_SECTOR_SIZE >> 1); i++)
-		host->id[i] = le16_to_cpu(inw((unsigned long)host->dev_base +
+		host->id[i] = le16_to_cpu(readw(host->dev_base +
 					MG_BUFF_OFFSET + i * 2));
 
-	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
 	err = mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD);
 	if (err)
 		return err;
@@ -394,7 +394,7 @@ static int mg_get_disk_id(struct mg_host *host)
 			host->n_sectors, host->nres_sectors);
 
 	if (!prv_data->use_polling)
-		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(0, host->dev_base + MG_REG_DRV_CTRL);
 
 	return err;
 }
@@ -419,20 +419,20 @@ static int mg_disk_init(struct mg_host *host)
 		return err;
 
 	/* soft reset on */
-	outb(ATA_SRST | (prv_data->use_polling ? ATA_NIEN : 0),
-			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	writeb(ATA_SRST | (prv_data->use_polling ? ATA_NIEN : 0),
+			host->dev_base + MG_REG_DRV_CTRL);
 	err = mg_wait(host, ATA_BUSY, MG_TMAX_RST_TO_BUSY);
 	if (err)
 		return err;
 
 	/* soft reset off */
-	outb(prv_data->use_polling ? ATA_NIEN : 0,
-			(unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+	writeb(prv_data->use_polling ? ATA_NIEN : 0,
+			host->dev_base + MG_REG_DRV_CTRL);
 	err = mg_wait(host, MG_STAT_READY, MG_TMAX_SWRST_TO_RDY);
 	if (err)
 		return err;
 
-	init_status = inb((unsigned long)host->dev_base + MG_REG_STATUS) & 0xf;
+	init_status = readb(host->dev_base + MG_REG_STATUS) & 0xf;
 
 	if (init_status == 0xf)
 		return MG_ERR_INIT_STAT;
@@ -465,15 +465,15 @@ static unsigned int mg_out(struct mg_host *host,
 	}
 	if (MG_RES_SEC)
 		sect_num += MG_RES_SEC;
-	outb((u8)sect_cnt, (unsigned long)host->dev_base + MG_REG_SECT_CNT);
-	outb((u8)sect_num, (unsigned long)host->dev_base + MG_REG_SECT_NUM);
-	outb((u8)(sect_num >> 8), (unsigned long)host->dev_base +
+	writeb((u8)sect_cnt, host->dev_base + MG_REG_SECT_CNT);
+	writeb((u8)sect_num, host->dev_base + MG_REG_SECT_NUM);
+	writeb((u8)(sect_num >> 8), host->dev_base +
 			MG_REG_CYL_LOW);
-	outb((u8)(sect_num >> 16), (unsigned long)host->dev_base +
+	writeb((u8)(sect_num >> 16), host->dev_base +
 			MG_REG_CYL_HIGH);
-	outb((u8)((sect_num >> 24) | ATA_LBA | ATA_DEVICE_OBS),
-			(unsigned long)host->dev_base + MG_REG_DRV_HEAD);
-	outb(cmd, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb((u8)((sect_num >> 24) | ATA_LBA | ATA_DEVICE_OBS),
+			host->dev_base + MG_REG_DRV_HEAD);
+	writeb(cmd, host->dev_base + MG_REG_COMMAND);
 	return MG_ERR_NONE;
 }
 
@@ -483,7 +483,7 @@ static void mg_read_one(struct mg_host *host, struct request *req)
 	u32 i;
 
 	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
-		*buff++ = inw((unsigned long)host->dev_base + MG_BUFF_OFFSET +
+		*buff++ = readw(host->dev_base + MG_BUFF_OFFSET +
 			      (i << 1));
 }
 
@@ -507,7 +507,7 @@ static void mg_read(struct request *req)
 
 		mg_read_one(host, req);
 
-		outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base +
+		writeb(MG_CMD_RD_CONF, host->dev_base +
 				MG_REG_COMMAND);
 	} while (mg_end_request(host, 0, MG_SECTOR_SIZE));
 }
@@ -518,7 +518,7 @@ static void mg_write_one(struct mg_host *host, struct request *req)
 	u32 i;
 
 	for (i = 0; i < MG_SECTOR_SIZE >> 1; i++)
-		outw(*buff++, (unsigned long)host->dev_base + MG_BUFF_OFFSET +
+		writew(*buff++, host->dev_base + MG_BUFF_OFFSET +
 		     (i << 1));
 }
 
@@ -545,7 +545,7 @@ static void mg_write(struct request *req)
 	do {
 		mg_write_one(host, req);
 
-		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+		writeb(MG_CMD_WR_CONF, host->dev_base +
 				MG_REG_COMMAND);
 
 		rem--;
@@ -568,7 +568,7 @@ static void mg_read_intr(struct mg_host *host)
 
 	/* check status */
 	do {
-		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		i = readb(host->dev_base + MG_REG_STATUS);
 		if (i & ATA_BUSY)
 			break;
 		if (!MG_READY_OK(i))
@@ -588,7 +588,7 @@ ok_to_read:
 	       blk_rq_pos(req), blk_rq_sectors(req) - 1, req->buffer);
 
 	/* send read confirm */
-	outb(MG_CMD_RD_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_RD_CONF, host->dev_base + MG_REG_COMMAND);
 
 	if (mg_end_request(host, 0, MG_SECTOR_SIZE)) {
 		/* set handler if read remains */
@@ -606,7 +606,7 @@ static void mg_write_intr(struct mg_host *host)
 
 	/* check status */
 	do {
-		i = inb((unsigned long)host->dev_base + MG_REG_STATUS);
+		i = readb(host->dev_base + MG_REG_STATUS);
 		if (i & ATA_BUSY)
 			break;
 		if (!MG_READY_OK(i))
@@ -630,7 +630,7 @@ ok_to_write:
 	}
 
 	/* send write confirm */
-	outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_WR_CONF, host->dev_base + MG_REG_COMMAND);
 
 	if (!rem)
 		mg_request(host->breq);
@@ -697,7 +697,7 @@ static unsigned int mg_issue_req(struct request *req,
 		break;
 	case WRITE:
 		/* TODO : handler */
-		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(ATA_NIEN, host->dev_base + MG_REG_DRV_CTRL);
 		if (mg_out(host, sect_num, sect_cnt, MG_CMD_WR, &mg_write_intr)
 				!= MG_ERR_NONE) {
 			mg_bad_rw_intr(host);
@@ -705,14 +705,14 @@ static unsigned int mg_issue_req(struct request *req,
 		}
 		del_timer(&host->timer);
 		mg_wait(host, ATA_DRQ, MG_TMAX_WAIT_WR_DRQ);
-		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(0, host->dev_base + MG_REG_DRV_CTRL);
 		if (host->error) {
 			mg_bad_rw_intr(host);
 			return host->error;
 		}
 		mg_write_one(host, req);
 		mod_timer(&host->timer, jiffies + 3 * HZ);
-		outb(MG_CMD_WR_CONF, (unsigned long)host->dev_base +
+		writeb(MG_CMD_WR_CONF, host->dev_base +
 				MG_REG_COMMAND);
 		break;
 	}
@@ -789,15 +789,15 @@ static int mg_suspend(struct platform_device *plat_dev, pm_message_t state)
 		return -EIO;
 
 	if (!prv_data->use_polling)
-		outb(ATA_NIEN, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(ATA_NIEN, host->dev_base + MG_REG_DRV_CTRL);
 
-	outb(MG_CMD_SLEEP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_SLEEP, host->dev_base + MG_REG_COMMAND);
 	/* wait until mflash deep sleep */
 	msleep(1);
 
 	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD)) {
 		if (!prv_data->use_polling)
-			outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+			writeb(0, host->dev_base + MG_REG_DRV_CTRL);
 		return -EIO;
 	}
 
@@ -812,7 +812,7 @@ static int mg_resume(struct platform_device *plat_dev)
 	if (mg_wait(host, MG_STAT_READY, MG_TMAX_CONF_TO_CMD))
 		return -EIO;
 
-	outb(MG_CMD_WAKEUP, (unsigned long)host->dev_base + MG_REG_COMMAND);
+	writeb(MG_CMD_WAKEUP, host->dev_base + MG_REG_COMMAND);
 	/* wait until mflash wakeup */
 	msleep(1);
 
@@ -820,7 +820,7 @@ static int mg_resume(struct platform_device *plat_dev)
 		return -EIO;
 
 	if (!prv_data->use_polling)
-		outb(0, (unsigned long)host->dev_base + MG_REG_DRV_CTRL);
+		writeb(0, host->dev_base + MG_REG_DRV_CTRL);
 
 	return 0;
 }
-- 
1.7.5.4

