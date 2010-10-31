Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064Ab0JaEZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 00:25:07 -0400
Received: from [69.28.251.93] ([69.28.251.93]:38308 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab0JaEYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 00:24:47 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Subject: [PATCH 2/3] mtd: m25p80: Add support for Macronix MX256L25635E
To: David Woodhouse <dwmw2@infradead.org>
Cc: <linux-mtd@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Date: Sat, 30 Oct 2010 21:11:03 -0700
Message-Id: <a4a2512bcf19341d19db73534412250e@localhost>
In-Reply-To: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
References: <fbcf2b0a4d8ebff3378b9522ce81ad82@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a 256Mbit (32MiB) part so minor changes were made to support
4-byte addressing.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 drivers/mtd/devices/m25p80.c |   31 ++++++++++++++++++++++++++++---
 1 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 80404e1..96ae54e 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -51,6 +51,10 @@
 #define	OPCODE_WRDI		0x04	/* Write disable */
 #define	OPCODE_AAI_WP		0xad	/* Auto address increment word program */
 
+/* Used for Macronix flashes only. */
+#define	OPCODE_EN4B		0xb7	/* Enter 4-byte mode */
+#define	OPCODE_EX4B		0xe9	/* Exit 4-byte mode */
+
 /* Status Register bits. */
 #define	SR_WIP			1	/* Write in progress */
 #define	SR_WEL			2	/* Write enable latch */
@@ -62,7 +66,7 @@
 
 /* Define max times to check status register before we give up. */
 #define	MAX_READY_WAIT_JIFFIES	(40 * HZ)	/* M25P16 specs 40s max chip erase */
-#define	MAX_CMD_SIZE		4
+#define	MAX_CMD_SIZE		5
 
 #ifdef CONFIG_M25PXX_USE_FAST_READ
 #define OPCODE_READ 	OPCODE_FAST_READ
@@ -152,6 +156,16 @@ static inline int write_disable(struct m25p *flash)
 }
 
 /*
+ * Enable/disable 4-byte addressing mode.
+ */
+static inline int set_4byte(struct m25p *flash, int enable)
+{
+	u8	code = enable ? OPCODE_EN4B : OPCODE_EX4B;
+
+	return spi_write_then_read(flash->spi, &code, 1, NULL, 0);
+}
+
+/*
  * Service routine to read status register until ready, or timeout occurs.
  * Returns non-zero if error.
  */
@@ -207,6 +221,7 @@ static void m25p_addr2cmd(struct m25p *flash, unsigned int addr, u8 *cmd)
 	cmd[1] = addr >> (flash->addr_width * 8 -  8);
 	cmd[2] = addr >> (flash->addr_width * 8 - 16);
 	cmd[3] = addr >> (flash->addr_width * 8 - 24);
+	cmd[4] = addr >> (flash->addr_width * 8 - 32);
 }
 
 static int m25p_cmdsz(struct m25p *flash)
@@ -607,7 +622,6 @@ struct flash_info {
 		.sector_size = (_sector_size),				\
 		.n_sectors = (_n_sectors),				\
 		.page_size = 256,					\
-		.addr_width = 3,					\
 		.flags = (_flags),					\
 	})
 
@@ -653,6 +667,7 @@ static const struct spi_device_id m25p_ids[] = {
 	{ "mx25l6405d",  INFO(0xc22017, 0, 64 * 1024, 128, 0) },
 	{ "mx25l12805d", INFO(0xc22018, 0, 64 * 1024, 256, 0) },
 	{ "mx25l12855e", INFO(0xc22618, 0, 64 * 1024, 256, 0) },
+	{ "mx25l25635e", INFO(0xc22019, 0, 64 * 1024, 512, 0) },
 
 	/* Spansion -- single (large) sector size only, at least
 	 * for the chips listed here (without boot sectors).
@@ -884,7 +899,17 @@ static int __devinit m25p_probe(struct spi_device *spi)
 
 	flash->mtd.dev.parent = &spi->dev;
 	flash->page_size = info->page_size;
-	flash->addr_width = info->addr_width;
+
+	if (info->addr_width)
+		flash->addr_width = info->addr_width;
+	else {
+		/* enable 4-byte addressing if the device exceeds 16MiB */
+		if (flash->mtd.size > 0x1000000) {
+			flash->addr_width = 4;
+			set_4byte(flash, 1);
+		} else
+			flash->addr_width = 3;
+	}
 
 	dev_info(&spi->dev, "%s (%lld Kbytes)\n", id->name,
 			(long long)flash->mtd.size >> 10);
-- 
1.7.0.4

