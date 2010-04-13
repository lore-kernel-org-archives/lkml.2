Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab0DMLcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 07:32:10 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:64256 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0DMLcJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 07:32:09 -0400
Date: Tue, 13 Apr 2010 13:31:55 +0200
From: Anders Larsen <al@alarsen.net>
Subject: [PATCH] Fix Oops with Atmel SPI
To: linux-mtd@lists.infradead.org
Cc: Ian McDonnell <ian@brightstareng.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.3.14
Message-Id: <1271158315l.25331l.9l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tweak MTD's cache allocation to make it work with the atmel DMA'ed SPI.
Substitute kmalloc for vmalloc so the cache buffer is mappable as per
the Atmel SPI driver's requirements, otherwise an Oops would occur.

The original patch by Ian McDonnell <ian@brightstareng.com> was found here:
http://lists.infradead.org/pipermail/linux-mtd/2007-December/020184.html

Signed-off-by: Anders Larsen <al@alarsen.net>
Cc: Ian McDonnell <ian@brightstareng.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Nicolas Pitre <nico@fluxnic.net>
---
 drivers/mtd/mtdblock.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: b/drivers/mtd/mtdblock.c
===================================================================
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -253,7 +253,11 @@ static int mtdblock_writesect(struct mtd
 {
 	struct mtdblk_dev *mtdblk = mtdblks[dev->devnum];
 	if (unlikely(!mtdblk->cache_data && mtdblk->cache_size)) {
+#ifdef CONFIG_SPI_ATMEL
+		mtdblk->cache_data = kmalloc(mtdblk->mtd->erasesize, GFP_KERNEL);
+#else
 		mtdblk->cache_data = vmalloc(mtdblk->mtd->erasesize);
+#endif
 		if (!mtdblk->cache_data)
 			return -EINTR;
 		/* -EINTR is not really correct, but it is the best match
@@ -322,7 +326,11 @@ static int mtdblock_release(struct mtd_b
 		mtdblks[dev] = NULL;
 		if (mtdblk->mtd->sync)
 			mtdblk->mtd->sync(mtdblk->mtd);
+#ifdef CONFIG_SPI_ATMEL
+		kfree(mtdblk->cache_data);
+#else
 		vfree(mtdblk->cache_data);
+#endif
 		kfree(mtdblk);
 	}
 

