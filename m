Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757728Ab0E1A73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 20:59:29 -0400
Received: from mail.df.lth.se ([194.47.250.12]:56394 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757229Ab0E1A70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 20:59:26 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] MFD: AB8500 mask off irrelevant bits from the SPI message
Date: Fri, 28 May 2010 02:59:44 +0200
Message-Id: <1275008384-17285-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The registers on the AB8500 are only 8 bits wide, so the content
of the remaining bits is undefined. Let's mask off the undefined
stuff when returning a register in an SPI read.

Acked-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab8500-spi.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
index b81d4f7..e1c8b62 100644
--- a/drivers/mfd/ab8500-spi.c
+++ b/drivers/mfd/ab8500-spi.c
@@ -68,7 +68,12 @@ static int ab8500_spi_read(struct ab8500 *ab8500, u16 addr)
 
 	ret = spi_sync(spi, &msg);
 	if (!ret)
-		ret = ab8500->rx_buf[0];
+		/*
+		 * Only the 8 lowermost bytes are
+		 * defined with value, the rest may
+		 * vary depending on chip/board noise.
+		 */
+		ret = ab8500->rx_buf[0] & 0xFFU;
 
 	return ret;
 }
-- 
1.6.3.3

