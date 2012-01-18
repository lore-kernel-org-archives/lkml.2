Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2AYMSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 07:18:18 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:36621 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2AYMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 07:18:17 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <201201251217.q0PCHmRe027024@gatekeeper.vosshq.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Wed, 18 Jan 2012 10:16:54 +0100
Subject: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
To: Artem Bityutskiy <dedekind1@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fb5427508abbd635e877fabdf55795488119c2d6 optimizes PIO
NAND accesses by using IO memcpy instead of IO read/write
repeated functions.

This breaks access to 16 bit NAND devices as memcpy_fromio()/toio()
_always_ use byte accesses (see arch/arm/kernel/io.c), so with
16 bit NAND, one byte gets lost per NAND access cycle and NAND
address count is wrong.

Using memcpy() instead of the IO memcpy functions fixes this, but
depends on correct word alignment of the buffer and length has to
be a multiple of four, otherwise it might issue byte accesses and
possibly break 16 bit NAND access (cf arch/arm/lib/copy_template.S).

Memcpy variants seem to be the wrong approach here, since the
NAND controller doesn't make the NAND appear as truely randomly
accessible memory (as opposed to the DRAM controller which does
exactly that).

So, my proposal is to use 32 bit IO read/write (and let SMC
map it to 8 bit or 16 bit NAND accesses) and account for
length % 4 > 0 with two additional IO read/writes.

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
---
 drivers/mtd/nand/atmel_nand.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index a582a0f..7396d4a 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -265,7 +265,12 @@ static void atmel_read_buf(struct mtd_info *mtd, u8 *buf, int len)
 			return;
 
 	/* if no DMA operation possible, use PIO */
-	memcpy_fromio(buf, chip->IO_ADDR_R, len);
+	readsl(chip->IO_ADDR_R, buf, len >> 2);
+	if (len & 2)
+		/* read into buf[len - 2] or buf[len - 3] */
+		*((u16 *)&buf[len & ~3]) = chip->read_word(mtd);
+	if (len & 1)
+		buf[len - 1] = chip->read_byte(mtd);
 }
 
 static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
@@ -278,7 +283,17 @@ static void atmel_write_buf(struct mtd_info *mtd, const u8 *buf, int len)
 			return;
 
 	/* if no DMA operation possible, use PIO */
-	memcpy_toio(chip->IO_ADDR_W, buf, len);
+	writesl(chip->IO_ADDR_W, buf, len >> 2);
+	if (len & 2)
+		/* write from buf[len - 2] or buf[len - 3] */
+		writew(*((u16 *)&buf[len & ~3]), chip->IO_ADDR_R);
+	if (len & 1) {
+		/* a single byte cannot be written to 16 bit NAND */
+		if (chip->options & NAND_BUSWIDTH_16)
+			BUG();
+		else
+			writeb(buf[len - 1], chip->IO_ADDR_R);
+	}
 }
 
 /*
-- 
1.7.5.4

