Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761329Ab0FRRAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 13:00:05 -0400
Received: from www.tglx.de ([62.245.132.106]:33304 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab0FRRAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 13:00:01 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Sascha Hauer <kernel@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] mtd: mxc_nand fixups
Date: Fri, 18 Jun 2010 18:59:47 +0200
Message-ID: <80hbl0b7jw.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch avoids byte access to the NFC buffer. Byte access to the
NFC is not allowed.

The patch is against linux-next 20100618.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
---
 drivers/mtd/nand/mxc_nand.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-next-20100618/drivers/mtd/nand/mxc_nand.c
===================================================================
--- linux-next-20100618.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-next-20100618/drivers/mtd/nand/mxc_nand.c
@@ -289,16 +289,16 @@ static void send_read_id(struct mxc_nand
 	/* Wait for operation to complete */
 	wait_op_done(host, true);
 
+	memcpy(host->data_buf, host->main_area0, 16);
+
 	if (this->options & NAND_BUSWIDTH_16) {
-		void __iomem *main_buf = host->main_area0;
 		/* compress the ID info */
-		writeb(readb(main_buf + 2), main_buf + 1);
-		writeb(readb(main_buf + 4), main_buf + 2);
-		writeb(readb(main_buf + 6), main_buf + 3);
-		writeb(readb(main_buf + 8), main_buf + 4);
-		writeb(readb(main_buf + 10), main_buf + 5);
+		host->data_buf[1] = host->data_buf[2];
+		host->data_buf[2] = host->data_buf[4];
+		host->data_buf[3] = host->data_buf[6];
+		host->data_buf[4] = host->data_buf[8];
+		host->data_buf[5] = host->data_buf[10];
 	}
-	memcpy(host->data_buf, host->main_area0, 16);
 }
 
 /* This function requests the NANDFC to perform a read of the
