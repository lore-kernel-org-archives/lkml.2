Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2DCGZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:25:10 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:45492
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab2DCGZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:25:08 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h668h839hd24h)
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Chris Wright <chrisw@sous-sol.org>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH-v3] Support M95040 SPI EEPROM
Date: Tue, 3 Apr 2012 08:25:02 +0200
Message-ID: <1333434302-14897-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 03 Apr 2012 06:25:04.0875 (UTC) FILETIME=[81FA63B0:01CD1162]
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

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---
v3: Processed review comments from Wolfram Sang: no additional address_offset
is calculated during the probe, but during the read/write the flag is checked
and the extra address bit offset is calculated runtime.

 drivers/misc/eeprom/at25.c |   19 ++++++++++++++++---
 include/linux/spi/eeprom.h |   10 ++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index c627e41..0d272c6 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -50,6 +50,7 @@ struct at25_data {
 #define	AT25_SR_BP1	0x08
 #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
 
+#define	AT25_INSTR_BIT3	0x08		/* Additional address bit in instr */
 
 #define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
 
@@ -75,6 +76,7 @@ at25_ee_read(
 	ssize_t			status;
 	struct spi_transfer	t[2];
 	struct spi_message	m;
+	u8			instr;
 
 	if (unlikely(offset >= at25->bin.size))
 		return 0;
@@ -84,7 +86,12 @@ at25_ee_read(
 		return count;
 
 	cp = command;
-	*cp++ = AT25_READ;
+
+	instr = AT25_READ;
+	if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
+		if (offset >= (1U << (at25->addrlen * 8)))
+			instr |= AT25_INSTR_BIT3;
+	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
 	switch (at25->addrlen) {
@@ -167,14 +174,14 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
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
@@ -184,6 +191,12 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
 			break;
 		}
 
+		instr = AT25_WRITE;
+		if (at25->chip.flags & EE_INSTR_BIT3_IS_ADDR)
+			if (offset >= (1U << (at25->addrlen * 8)))
+				instr |= AT25_INSTR_BIT3;
+		*cp++ = instr;
+
 		/* 8/16/24-bit address is written MSB first */
 		switch (at25->addrlen) {
 		default:	/* case 3 */
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


