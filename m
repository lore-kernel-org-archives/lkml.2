Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab2CHNCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 08:02:06 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:50825 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345Ab2CHNCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 08:02:03 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/4] mfd/ab8500: don't use mutex_lock_interruptible
Date: Thu, 8 Mar 2012 14:01:46 +0100
Message-ID: <1331211706-9763-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rabin Vincent <rabin.vincent@stericsson.com>

This disadvantage of having it interruptible is that it would
appear to work OK in most situations, but in the rare case
that this call does fail, it can lead to misconfiguration
of the AB, such as a regulator not being turned off and
leading to a platform power consumption increase.

There's no real benefit to having this interruptible.

Make it a plain mutex_lock. The non-interruptability matches
other low-level I/O functions such as SPI and I2C.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 15a18fe..f134a6c 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -147,9 +147,7 @@ static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
 
 	dev_vdbg(ab8500->dev, "wr: addr %#x <= %#x\n", addr, data);
 
-	ret = mutex_lock_interruptible(&ab8500->lock);
-	if (ret)
-		return ret;
+	mutex_lock(&ab8500->lock);
 
 	ret = ab8500->write(ab8500, addr, data);
 	if (ret < 0)
@@ -176,9 +174,7 @@ static int get_register_interruptible(struct ab8500 *ab8500, u8 bank,
 	 * bank on higher 8 bits and reg in lower */
 	u16 addr = ((u16)bank) << 8 | reg;
 
-	ret = mutex_lock_interruptible(&ab8500->lock);
-	if (ret)
-		return ret;
+	mutex_lock(&ab8500->lock);
 
 	ret = ab8500->read(ab8500, addr);
 	if (ret < 0)
@@ -210,9 +206,7 @@ static int mask_and_set_register_interruptible(struct ab8500 *ab8500, u8 bank,
 	 * bank on higher 8 bits and reg in lower */
 	u16 addr = ((u16)bank) << 8 | reg;
 
-	ret = mutex_lock_interruptible(&ab8500->lock);
-	if (ret)
-		return ret;
+	mutex_lock(&ab8500->lock);
 
 	ret = ab8500->read(ab8500, addr);
 	if (ret < 0) {
-- 
1.7.8

