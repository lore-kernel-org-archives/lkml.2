Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174Ab2LJTNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:13:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55682 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751446Ab2LJTNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:13:01 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, benh@kernel.crashing.org, arnd@arndb.de,
        james.hogan@imgtec.com, Matthew Leach <matthew@mattleach.net>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v2 07/10] mtd: nand/gpio: use io{read,write}*_rep accessors
Date: Mon, 10 Dec 2012 19:12:39 +0000
Message-Id: <1355166762-15133-8-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
References: <1355166762-15133-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Leach <matthew@mattleach.net>

The {read,write}s{b,w,l} operations are not defined by all
architectures and are being removed from the asm-generic/io.h
interface.

This patch replaces the usage of these string functions in the mtd
gpio accessors with io{read,write}{8,16,32}_rep calls instead.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org
Signed-off-by: Matthew Leach <matthew@mattleach.net>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 drivers/mtd/nand/gpio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/gpio.c b/drivers/mtd/nand/gpio.c
index bc73bc5..0d233e9 100644
--- a/drivers/mtd/nand/gpio.c
+++ b/drivers/mtd/nand/gpio.c
@@ -90,14 +90,14 @@ static void gpio_nand_writebuf(struct mtd_info *mtd, const u_char *buf, int len)
 {
 	struct nand_chip *this = mtd->priv;
 
-	writesb(this->IO_ADDR_W, buf, len);
+	iowrite8_rep(this->IO_ADDR_W, buf, len);
 }
 
 static void gpio_nand_readbuf(struct mtd_info *mtd, u_char *buf, int len)
 {
 	struct nand_chip *this = mtd->priv;
 
-	readsb(this->IO_ADDR_R, buf, len);
+	ioread8_rep(this->IO_ADDR_R, buf, len);
 }
 
 static void gpio_nand_writebuf16(struct mtd_info *mtd, const u_char *buf,
@@ -106,7 +106,7 @@ static void gpio_nand_writebuf16(struct mtd_info *mtd, const u_char *buf,
 	struct nand_chip *this = mtd->priv;
 
 	if (IS_ALIGNED((unsigned long)buf, 2)) {
-		writesw(this->IO_ADDR_W, buf, len>>1);
+		iowrite16_rep(this->IO_ADDR_W, buf, len>>1);
 	} else {
 		int i;
 		unsigned short *ptr = (unsigned short *)buf;
@@ -121,7 +121,7 @@ static void gpio_nand_readbuf16(struct mtd_info *mtd, u_char *buf, int len)
 	struct nand_chip *this = mtd->priv;
 
 	if (IS_ALIGNED((unsigned long)buf, 2)) {
-		readsw(this->IO_ADDR_R, buf, len>>1);
+		ioread16_rep(this->IO_ADDR_R, buf, len>>1);
 	} else {
 		int i;
 		unsigned short *ptr = (unsigned short *)buf;
-- 
1.8.0

