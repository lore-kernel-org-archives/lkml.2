Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0DTXRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:17:33 -0400
Received: from p01c12o144.mxlogic.net ([208.65.145.67]:35862 "EHLO
	p01c12o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0DTXRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:17:31 -0400
X-MXL-Hash: 4bce360b3629dd8c-5d99468ef2b6b7e7424f8aebd579cf13527d03e7
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>
Date: Tue, 20 Apr 2010 18:17:32 -0500
Subject: [PATCH] sst25l.c: simplify reading the device ManID/DevID
Thread-Topic: [PATCH] sst25l.c: simplify reading the device ManID/DevID
Thread-Index: Acrg36deRQHDTx5hRRSy22oT3OfgYg==
Message-ID: <0D753D10438DA54287A00B0270842697636D85BD7C@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010041501)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.99]
X-AnalysisOut: [v=1.0 c=1 a=t8usvzF2hgsA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=rggnVFrEAAAA:8 a=soJuZ57OAEw2ZrepiwgA:9 a=9m]
X-AnalysisOut: [JAFRGV89A9kQrHkHMA:7 a=cGEJxn6M8fXquCw0KAcXcAugt4AA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=ct-hs6]
X-AnalysisOut: [iedJYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3KNHdmE016559

The Read-ID command will continuously output the Manufacture ID and Device ID
until the command is terminated by a low to high transition on the CE# pin.
We can take advantage of this in the sst25l_match_device routine by reading
both bytes in one spi_write_then_read transaction.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Andre Renaud <andre@bluewatersys.com>
Cc: Ryan Mallon <ryan@bluewatersys.com>

---

diff --git a/drivers/mtd/devices/sst25l.c b/drivers/mtd/devices/sst25l.c
index fe17054..b13ca75 100644
--- a/drivers/mtd/devices/sst25l.c
+++ b/drivers/mtd/devices/sst25l.c
@@ -328,7 +328,7 @@ out:
 static struct flash_info *__init sst25l_match_device(struct spi_device *spi)
 {
 	struct flash_info *flash_info = NULL;
-	unsigned char command[4], response;
+	unsigned char command[4], response[2];
 	int i, err;
 	uint16_t id;
 
@@ -336,25 +336,14 @@ static struct flash_info *__init sst25l_match_device(struct spi_device *spi)
 	command[1] = 0;
 	command[2] = 0;
 	command[3] = 0;
-	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
+	err = spi_write_then_read(spi, command, sizeof(command),
+				       response, sizeof(response));
 	if (err < 0) {
 		dev_err(&spi->dev, "error reading device id msb\n");
 		return NULL;
 	}
 
-	id = response << 8;
-
-	command[0] = SST25L_CMD_READ_ID;
-	command[1] = 0;
-	command[2] = 0;
-	command[3] = 1;
-	err = spi_write_then_read(spi, command, sizeof(command), &response, 1);
-	if (err < 0) {
-		dev_err(&spi->dev, "error reading device id lsb\n");
-		return NULL;
-	}
-
-	id |= response;
+	id = (response[0] << 8) | response[1];
 
 	for (i = 0; i < ARRAY_SIZE(sst25l_flash_info); i++)
 		if (sst25l_flash_info[i].device_id == id)
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
