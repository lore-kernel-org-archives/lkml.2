Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1AJVV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:21:58 -0500
Received: from mail131.messagelabs.com ([216.82.242.99]:19713 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1AJVVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:21:53 -0500
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1294694506!9398818!33
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.72]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
CC: David Woodhouse <dwmw2@infradead.org>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>
Date: Mon, 10 Jan 2011 15:21:40 -0600
Subject: [PATCH] mtd: sst25l: fix reads with broken spi-masters
Thread-Topic: [PATCH] mtd: sst25l: fix reads with broken spi-masters
Thread-Index: AcuxDF9I6KfGxxvZSoOcEo66kiFNeg==
Message-ID: <0D753D10438DA54287A00B027084269764CDF4146A@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0ALM5Fa015807

Some spi masters (ep93xx) have limitations when using the SFRMOUT
signal for the chip select.  The SFRMOUT signal is only asserted
as long as the transmit fifo contains data.  As soon as the last
bit is clocked into the receive fifo it gets deasserted.

The chip select line to the SST25L must remain asserted for the
duration of the Read cycle.  If it gets deasserted the command
gets aborted.

To handle these broken masters, implement an alternate read method 
that uses the fifo_size information, passed from the platform data,
to make sure the command+data message always fits into the spi fifo.
This insures that the messages will always complete correctly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

---

This patch is needed in order to read from the SPI flash on the
EDB93xx series dev boards.  Without it any read from the device will
return 0x00.

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index c163e61..864bd20 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -54,6 +54,10 @@ struct sst25l_flash {
 	struct mtd_info		mtd;
 
 	int 			partitioned;
+
+	bool			use_fifo;
+	int			fifo_size;
+	unsigned char		*bounce_buf;
 };
 
 struct flash_info {
@@ -269,6 +273,79 @@ static int sst25l_read(struct mtd_info *mtd, loff_t from, size_t len,
 	return 0;
 }
 
+static int sst25l_read_use_fifo(struct mtd_info *mtd, loff_t from, size_t len,
+				size_t *retlen, unsigned char *buf)
+{
+	struct sst25l_flash *flash = to_sst25l_flash(mtd);
+	struct spi_message message;
+	struct spi_transfer transfer;
+	loff_t addr;
+	size_t count;
+	int xfer_size = flash->fifo_size - 4;
+	int ret, i;
+
+	/* Sanity checking */
+	if (len == 0)
+		return 0;
+
+	if (from + len > flash->mtd.size)
+		return -EINVAL;
+
+	if (retlen)
+		*retlen = 0;
+
+	mutex_lock(&flash->lock);
+
+	/* Wait for previous write/erase to complete */
+	ret = sst25l_wait_till_ready(flash);
+	if (ret) {
+		mutex_unlock(&flash->lock);
+		return ret;
+	}
+
+	for (addr = from, count = 0; addr < from + len; addr += xfer_size) {
+		spi_message_init(&message);
+		memset(&transfer, 0, sizeof(transfer));
+
+		/* Fill the bounce buffer with known data */
+		memset(flash->bounce_buf, 0xff, flash->fifo_size);
+
+		/*
+		 * Send the 4 byte Read command and read back as much
+		 * data as possible (fifo_size - 4) into the bounce buffer.
+		 */
+		flash->bounce_buf[0] = SST25L_CMD_READ;
+		flash->bounce_buf[1] = addr >> 16;
+		flash->bounce_buf[2] = addr >> 8;
+		flash->bounce_buf[3] = addr;
+
+		transfer.tx_buf = flash->bounce_buf;
+		transfer.rx_buf = flash->bounce_buf;
+		transfer.len = flash->fifo_size;
+		spi_message_add_tail(&transfer, &message);
+		ret = spi_sync(flash->spi, &message);
+		if (ret < 0) {
+			mutex_unlock(&flash->lock);
+			return ret;
+		}
+
+		/*
+		 * Copy the read data from the bounce buffer to the
+		 * passed buffer.  Don't overflow the passed buffer.
+		 */
+		for (i = 0; i < xfer_size; i++) {
+			if (count < len)
+				buf[count++] = flash->bounce_buf[4+i];
+		}
+	}
+
+	if (retlen)
+		*retlen += count;
+
+	mutex_unlock(&flash->lock);
+	return 0;
+}
+
 static int sst25l_write(struct mtd_info *mtd, loff_t to, size_t len,
 			size_t *retlen, const unsigned char *buf)
 {
@@ -400,13 +477,25 @@ static int __devinit sst25l_probe(struct spi_device *spi)
 	else
 		flash->mtd.name = dev_name(&spi->dev);
 
+	flash->use_fifo		= data->use_fifo;
+	flash->fifo_size	= data->fifo_size;
+
 	flash->mtd.type		= MTD_NORFLASH;
 	flash->mtd.flags	= MTD_CAP_NORFLASH;
 	flash->mtd.erasesize	= flash_info->erase_size;
 	flash->mtd.writesize	= flash_info->page_size;
 	flash->mtd.size		= flash_info->page_size * flash_info->nr_pages;
 	flash->mtd.erase	= sst25l_erase;
-	flash->mtd.read		= sst25l_read;
+	if (flash->use_fifo) {
+		flash->bounce_buf = kzalloc(flash->fifo_size, GFP_KERNEL);
+		if (!flash->bounce_buf) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		flash->mtd.read = sst25l_read_use_fifo;
+	} else {
+		flash->mtd.read	= sst25l_read;
+	}
 	flash->mtd.write 	= sst25l_write;
 
 	dev_info(&spi->dev, "%s (%lld KiB)\n", flash_info->name,
@@ -461,12 +550,17 @@ static int __devinit sst25l_probe(struct spi_device *spi)
 
 	ret = add_mtd_device(&flash->mtd);
 	if (ret == 1) {
-		kfree(flash);
-		dev_set_drvdata(&spi->dev, NULL);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err;
 	}
 
 	return 0;
+
+err:
+	kfree(flash->bounce_buf);
+	kfree(flash);
+	dev_set_drvdata(&spi->dev, NULL);
+	return ret;
 }
 
 static int __exit sst25l_remove(struct spi_device *spi)
@@ -478,8 +572,10 @@ static int __exit sst25l_remove(struct spi_device *spi)
 		ret = del_mtd_partitions(&flash->mtd);
 	else
 		ret = del_mtd_device(&flash->mtd);
-	if (ret == 0)
+	if (ret == 0) {
+		kfree(flash->bounce_buf);
 		kfree(flash);
+	}
 	return ret;
 }
 
diff --git a/include/linux/spi/flash.h b/include/linux/spi/flash.h
index 3f22932..8524221 100644
--- a/include/linux/spi/flash.h
+++ b/include/linux/spi/flash.h
@@ -10,6 +10,10 @@ struct mtd_partition;
  * @nr_parts: number of mtd_partitions for static partitoning
  * @type: optional flash device type (e.g. m25p80 vs m25p64), for use
  *	with chips that can't be queried for JEDEC or other IDs
+ * @use_fifo: optional flag to read/write data using the SPI master's
+ *	fifo limitations (for broken SPI masters that deassert the
+ *	chip select during multi-part transfers)
+ * @fifo_size: optional fifo size used with broken SPI masters
  *
  * Board init code (in arch/.../mach-xxx/board-yyy.c files) can
  * provide information about SPI flash parts (such as DataFlash) to
@@ -25,6 +29,9 @@ struct flash_platform_data {
 
 	char		*type;
 
+	bool		use_fifo;
+	int		fifo_size;
+
 	/* we'll likely add more ... use JEDEC IDs, etc */
 };
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
