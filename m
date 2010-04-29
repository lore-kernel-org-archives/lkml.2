Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0EAA7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 20:59:30 -0400
Received: from p01c12o148.mxlogic.net ([208.65.145.71]:59173 "EHLO
	p01c12o148.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab0EAA70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 20:59:26 -0400
X-MXL-Hash: 4bdb7cee4f13796b-ffa0016d4513bfc42c61e7a88f2c745445b6c0a1
X-MXL-Hash: 4bd9d19e217b8539-377f8aca4ad5779c50c82beba01c76395749fc80
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "dedekind1@gmail.com" <dedekind1@gmail.com>
Date: Thu, 29 Apr 2010 13:34:24 -0500
Subject: [PATCH] sst25l.c: fix multi-part messages with broken spi masters
Thread-Topic: [PATCH] sst25l.c: fix multi-part messages with broken spi
 masters
Thread-Index: AcrnypfJPeCwvyWvRyqcxSV64zmhaw==
Message-ID: <0D753D10438DA54287A00B0270842697636E305D4A@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010043001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=borFIQzli1YA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=pGLkceISAAAA:8 a=rggnVFrEAAAA:8 a=nowIHpIveu]
X-AnalysisOut: [VuGbkFGBMA:9 a=Hj9QbegMjyGHuiDSf8cA:7 a=vP3aldeonwbFo30t8E]
X-AnalysisOut: [bzZHiF4tIA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nU]
X-AnalysisOut: [Sh_UA:10 a=MSl-tDqOz04A:10 a=ct-hs6iedJYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o410xXmE012615

Some SPI masters (ep93xx) have limitations when using the SFRMOUT
signal for the spi device chip select.  The SFRMOUT signal is
only asserted as long as the spi transmit fifo contains data.  As
soon as the last bit is clocked into the receive fifo it gets
deasserted.

The functions sst25l_status and sst25l_match_device use the API
function spi_write_then_read to write a command to the flash then
read the response back.  This API function creates a two part spi
message for the write then read.  When this message is transferred
the SFRMOUT signal ends up getting deasserted after the command
phase.  This causes the command to get aborted by the device so
the read phase returns invalid data.

By changing sst25l_status and sst25l_match_device to use a single
transfer synchronous message, the SFRMOUT signal stays asserted
during the entire message so the correct data always gets returned.

This change will have no effect on SPI masters which use a chip
select mechanism (GPIO's, etc.) which does stay asserted correctly.
As a bonus, the single transfer synchronous messages complete faster
than multi-part messages.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>

---

This driver is needed on the ep93xx based EDB93xx dev boards to
access the SPI flash.

This patch replaces "sst25l.c: simplify reading the device ManID/DevID"
which was previously posted.

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index fe17054..7de3bee 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -73,15 +73,25 @@ static struct flash_info __initdata sst25l_flash_info[] = {
 
 static int sst25l_status(struct sst25l_flash *flash, int *status)
 {
-	unsigned char command, response;
+	struct spi_message m;
+	struct spi_transfer t;
+	unsigned char cmd_resp[2];
 	int err;
 
-	command = SST25L_CMD_RDSR;
-	err = spi_write_then_read(flash->spi, &command, 1, &response, 1);
+	spi_message_init(&m);
+	memset(&t, 0, sizeof(struct spi_transfer));
+
+	cmd_resp[0] = SST25L_CMD_RDSR;
+	cmd_resp[1] = 0xff;
+	t.tx_buf = cmd_resp;
+	t.rx_buf = cmd_resp;
+	t.len = sizeof(cmd_resp);
+	spi_message_add_tail(&t, &m);
+	err = spi_sync(flash->spi, &m);
 	if (err < 0)
 		return err;
 
-	*status = response;
+	*status = cmd_resp[1];
 	return 0;
 }
 
@@ -328,33 +338,32 @@ out:
 static struct flash_info *__init sst25l_match_device(struct spi_device *spi)
 {
 	struct flash_info *flash_info = NULL;
-	unsigned char command[4], response;
+	struct spi_message m;
+	struct spi_transfer t;
+	unsigned char cmd_resp[6];
 	int i, err;
 	uint16_t id;
 
-	command[0] = SST25L_CMD_READ_ID;
-	command[1] = 0;
-	command[2] = 0;
-	command[3] = 0;
-	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
-	if (err < 0) {
-		dev_err(&spi->dev, "error reading device id msb\n");
-		return NULL;
-	}
-
-	id = response << 8;
-
-	command[0] = SST25L_CMD_READ_ID;
-	command[1] = 0;
-	command[2] = 0;
-	command[3] = 1;
-	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
+	spi_message_init(&m);
+	memset(&t, 0, sizeof(struct spi_transfer));
+
+	cmd_resp[0] = SST25L_CMD_READ_ID;
+	cmd_resp[1] = 0;
+	cmd_resp[2] = 0;
+	cmd_resp[3] = 0;
+	cmd_resp[4] = 0xff;
+	cmd_resp[5] = 0xff;
+	t.tx_buf = cmd_resp;
+	t.rx_buf = cmd_resp;
+	t.len = sizeof(cmd_resp);
+	spi_message_add_tail(&t, &m);
+	err = spi_sync(spi, &m);
 	if (err < 0) {
-		dev_err(&spi->dev, "error reading device id lsb\n");
+		dev_err(&spi->dev, "error reading device id\n");
 		return NULL;
 	}
 
-	id |= response;
+	id = (cmd_resp[4] << 8) | cmd_resp[5];
 
 	for (i = 0; i < ARRAY_SIZE(sst25l_flash_info); i++)
 		if (sst25l_flash_info[i].device_id == id)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
