Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab2CUPYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 11:24:31 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:8405 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759137Ab2CUPYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 11:24:30 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bhz2ei87h668h839hd24h)
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-kernel@vger.kernel.org>
CC: Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] Support M95040 SPI EEPROM
Date: Wed, 21 Mar 2012 16:24:05 +0100
Message-ID: <1332343445-17104-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 21 Mar 2012 15:24:07.0705 (UTC) FILETIME=[A86FD890:01CD0776]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated the generic SPI EEPROM driver AT25 for support of address bit A8
in the instruction byte. Certain EEPROMS (like M95040 from ST) have a 512
Byte size but use only one address byte (A0 to A7) for addressing. For the
extra address bit A8 bit 3 of the instruction byte is used. This instruction
bit is threated as don't care for other AT25 like chips

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---
 drivers/misc/eeprom/at25.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index c627e41..907aecc 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -50,6 +50,7 @@ struct at25_data {
 #define	AT25_SR_BP1	0x08
 #define	AT25_SR_WPEN	0x80		/* writeprotect enable */
 
+#define	AT25_INSTR_A8	0x08		/* Address bit 8 in instruction */
 
 #define EE_MAXADDRLEN	3		/* 24 bit addresses, up to 2 MBytes */
 
@@ -75,6 +76,7 @@ at25_ee_read(
 	ssize_t			status;
 	struct spi_transfer	t[2];
 	struct spi_message	m;
+	u8			instr;
 
 	if (unlikely(offset >= at25->bin.size))
 		return 0;
@@ -84,7 +86,18 @@ at25_ee_read(
 		return count;
 
 	cp = command;
-	*cp++ = AT25_READ;
+
+	/*
+	 * Certain EEPROMS (like M95040 from ST) have a 512 Byte size
+	 * but use only one address byte (A0 to A7) for addressing. For
+	 * the extra address bit A8 bit 3 of the instruction byte is
+	 * used. This instruction bit is threated as don't care for
+	 * other AT25 like chips.
+	 */
+	instr = AT25_READ;
+	if ((at25->addrlen == 1) && (offset >= 256))
+		instr |= AT25_INSTR_A8;
+	*cp++ = instr;
 
 	/* 8/16/24-bit address is written MSB first */
 	switch (at25->addrlen) {
@@ -167,14 +180,14 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
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
@@ -184,6 +197,18 @@ at25_ee_write(struct at25_data *at25, const char *buf, loff_t off,
 			break;
 		}
 
+		/*
+		 * Certain EEPROMS (like M95040 from ST) have a 512 Byte size
+		 * but use only one address byte (A0 to A7) for addressing. For
+		 * the extra address bit A8 bit 3 of the instruction byte is
+		 * used. This instruction bit is threated as don't care for
+		 * other AT25 like chips.
+		 */
+		instr = AT25_WRITE;
+		if ((at25->addrlen == 1) && (offset >= 256))
+			instr |= AT25_INSTR_A8;
+		*cp++ = instr;
+
 		/* 8/16/24-bit address is written MSB first */
 		switch (at25->addrlen) {
 		default:	/* case 3 */
-- 
1.7.0.4


