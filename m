Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab1EHSEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:04:54 -0400
Received: from [69.28.251.93] ([69.28.251.93]:51376 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753900Ab1EHSEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:04:52 -0400
From: Kevin Cernekee <cernekee@gmail.com>
To: <dedekind@infradead.org>, <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] mtd: m25p80: Add Spansion S25FL256S
Date: Sun, 08 May 2011 10:48:01 -0700
Message-Id: <71f2bd3eadeac971ea46eba6a801f647@localhost>
In-Reply-To: <657440bd74a74686279e691d39337f21@localhost>
References: <657440bd74a74686279e691d39337f21@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are 32MiB parts which use a slightly different 4-byte enable
sequence from Macronix.

Default to the Spansion 4-byte scheme in set_4byte(), as it is more
likely to be copied by other vendors.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/devices/m25p80.c |   22 +++++++++++++++++-----
 1 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 10a84ce..fad7448 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -56,6 +56,9 @@
 #define	OPCODE_EN4B		0xb7	/* Enter 4-byte mode */
 #define	OPCODE_EX4B		0xe9	/* Exit 4-byte mode */
 
+/* Used for Spansion flashes only. */
+#define	OPCODE_BRWR		0x17	/* Bank register write */
+
 /* Status Register bits. */
 #define	SR_WIP			1	/* Write in progress */
 #define	SR_WEL			2	/* Write enable latch */
@@ -161,11 +164,18 @@ static inline int write_disable(struct m25p *flash)
 /*
  * Enable/disable 4-byte addressing mode.
  */
-static inline int set_4byte(struct m25p *flash, int enable)
+static inline int set_4byte(struct m25p *flash, u32 jedec_id, int enable)
 {
-	u8	code = enable ? OPCODE_EN4B : OPCODE_EX4B;
-
-	return spi_write_then_read(flash->spi, &code, 1, NULL, 0);
+	switch (JEDEC_MFR(jedec_id)) {
+	case CFI_MFR_MACRONIX:
+		flash->command[0] = enable ? OPCODE_EN4B : OPCODE_EX4B;
+		return spi_write(flash->spi, flash->command, 1);
+	default:
+		/* Spansion style */
+		flash->command[0] = OPCODE_BRWR;
+		flash->command[1] = enable << 7;
+		return spi_write(flash->spi, flash->command, 2);
+	}
 }
 
 /*
@@ -687,6 +697,8 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "s25sl032a",  INFO(0x010215,      0,  64 * 1024,  64, 0) },
 	{ "s25sl032p",  INFO(0x010215, 0x4d00,  64 * 1024,  64, SECT_4K) },
 	{ "s25sl064a",  INFO(0x010216,      0,  64 * 1024, 128, 0) },
+	{ "s25fl256s0", INFO(0x010219, 0x4d00, 256 * 1024, 128, 0) },
+	{ "s25fl256s1", INFO(0x010219, 0x4d01,  64 * 1024, 512, 0) },
 	{ "s25sl12800", INFO(0x012018, 0x0300, 256 * 1024,  64, 0) },
 	{ "s25sl12801", INFO(0x012018, 0x0301,  64 * 1024, 256, 0) },
 	{ "s25fl129p0", INFO(0x012018, 0x4d00, 256 * 1024,  64, 0) },
@@ -920,7 +932,7 @@ static int __devinit m25p_probe(struct spi_device *spi)
 		/* enable 4-byte addressing if the device exceeds 16MiB */
 		if (flash->mtd.size > 0x1000000) {
 			flash->addr_width = 4;
-			set_4byte(flash, 1);
+			set_4byte(flash, info->jedec_id, 1);
 		} else
 			flash->addr_width = 3;
 	}
-- 
1.7.5

