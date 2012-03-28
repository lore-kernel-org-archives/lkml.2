Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab2C1NuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:50:16 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55463 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756788Ab2C1NuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:50:14 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h668h839hd24h)
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH-v2] Support M95040 SPI EEPROM
Date: Wed, 28 Mar 2012 15:50:02 +0200
Message-ID: <1332942602-22324-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 28 Mar 2012 13:50:08.0090 (UTC) FILETIME=[AFDB23A0:01CD0CE9]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the generic SPI EEPROM driver AT25 for support of an additional address
bit in the instruction byte. Certain EEPROMS have a size that is larger than the
number of address bytes would allow (e.g. like M95040 from ST that has 512 Byte
size but uses only one address byte (A0 to A7) for addressing.) For the extra
address bit (A8, A16 or A24) bit 3 of the instruction byte is used. This
instruction bit is normally defined as don't care for other AT25 like chips.

v2: Introduced a flag EE_INSTR_BIT3_IS_ADDR to support additional address bits
in READ/WRITE instruction.

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---
 drivers/misc/eeprom/at25.c |   24 +++++++++++++++++++++---
 include/linux/spi/eeprom.h |   10 ++++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index c627e41..5e0650f 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -35,6 +35,7 @@ struct at25_data {
 	struct spi_eeprom	chip;
 	struct bin_attribute	bin;
 	unsigned		addrlen;
+	unsigned		instr_bit3_address_offset;
 };
 
 #define	AT25_WREN	0x06		/* latch the write enable */
@@ -50,6 +51,7 @@ struct at25_data {
 #define	AT25_SR_BP1	0x08
 #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
 
+#define	AT25_INSTR_BIT3	0x08		/* Additional address bit in instr */
 
 #define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
 
@@ -75,6 +77,7 @@ at25_ee_read(
 	ssize_t			status;
 	struct spi_transfer	t[2];
 	struct spi_message	m;
+	u8			instr;
 
 	if (unlikely(offset >= at25->bin.size))
 		return 0;
@@ -84,7 +87,12 @@ at25_ee_read(
 		return count;
 
 	cp = command;
-	*cp++ = AT25_READ;
+
+	instr = AT25_READ;
+	if (at25->instr_bit3_address_offset)
+		if (offset >= at25->instr_bit3_address_offset)
+			instr |= AT25_INSTR_BIT3;
+	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
 	switch (at25->addrlen) {
@@ -167,14 +175,14 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
 	/* For write, rollover is within the page ... so we write at
 	 * most one page, then manually roll over to the next page.
 	 */
-	bounce[0] = AT25_WRITE;
 	mutex_lock(&at25->lock);
 	do {
 		unsigned long	timeout, retries;
 		unsigned	segment;
 		unsigned	offset = (unsigned) off;
-		u8		*cp = bounce + 1;
+		u8		*cp = bounce;
 		int		sr;
+		u8		instr;
 
 		*cp = AT25_WREN;
 		status = spi_write(at25->spi, cp, 1);
@@ -184,6 +192,12 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
 			break;
 		}
 
+		instr = AT25_WRITE;
+		if (at25->instr_bit3_address_offset)
+			if (offset >= at25->instr_bit3_address_offset)
+				instr |= AT25_INSTR_BIT3;
+		*cp++ = instr;
+
 		/* 8/16/24-bit address is written MSB first */
 		switch (at25->addrlen) {
 		default:	/* case 3 */
@@ -296,6 +310,7 @@ static int at25_probe(struct spi_device *spi)
 	int			err;
 	int			sr;
 	int			addrlen;
+	unsigned		instr_bit3_address_offset = 0;
 
 	/* Chip description */
 	chip = spi->dev.platform_data;
@@ -317,6 +332,8 @@ static int at25_probe(struct spi_device *spi)
 		err = -EINVAL;
 		goto fail;
 	}
+	if (chip->flags & EE_INSTR_BIT3_IS_ADDR)
+		instr_bit3_address_offset = 1U << (addrlen * 8);
 
 	/* Ping the chip ... the status register is pretty portable,
 	 * unlike probing manufacturer IDs.  We do expect that system
@@ -339,6 +356,7 @@ static int at25_probe(struct spi_device *spi)
 	at25->spi = spi_dev_get(spi);
 	dev_set_drvdata(&spi->dev, at25);
 	at25->addrlen = addrlen;
+	at25->instr_bit3_address_offset = instr_bit3_address_offset;
 
 	/* Export the EEPROM bytes through sysfs, since that's convenient.
 	 * And maybe to other kernel code; it might hold a board's Ethernet
diff --git a/include/linux/spi/eeprom.h b/include/linux/spi/eeprom.h
index 306e7b1..403e007 100644
--- a/include/linux/spi/eeprom.h
+++ b/include/linux/spi/eeprom.h
@@ -20,6 +20,16 @@ struct spi_eeprom {
 #define	EE_ADDR3	0x0004			/* 24 bit addrs */
 #define	EE_READONLY	0x0008			/* disallow writes */
 
+	/*
+	 * Certain EEPROMS have a size that is larger than the number of address
+	 * bytes would allow (e.g. like M95040 from ST that has 512 Byte size
+	 * but uses only one address byte (A0 to A7) for addressing.) For
+	 * the extra address bit (A8, A16 or A24) bit 3 of the instruction byte
+	 * is used. This instruction bit is normally defined as don't care for
+	 * other AT25 like chips.
+	 */
+#define EE_INSTR_BIT3_IS_ADDR	0x0010
+
 	/* for exporting this chip's data to other kernel code */
 	void (*setup)(struct memory_accessor *mem, void *context);
 	void *context;
-- 
1.7.0.4


