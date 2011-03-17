Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817Ab1CQVmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 17:42:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36825 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755667Ab1CQVmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 17:42:33 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Push byte swap out of WM8994 bulk I/O
Date: Thu, 17 Mar 2011 21:42:29 +0000
Message-Id: <1300398150-11834-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1300398150-11834-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For bulk I/O it is both convenient and more sensible to pre-swap the data
rather than doing the swap as part of the I/O operation so move the byte
swaps we're currently doing into the core write function into the register
based functions, giving the bulk write function a straight pass through
to the chip.

This leaves reads inconsistent, this will be addressed as a followup patch.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-core.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index ce93796..475bd50 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -107,9 +107,7 @@ static int wm8994_write(struct wm8994 *wm8994, unsigned short reg,
 
 	for (i = 0; i < bytes / 2; i++) {
 		dev_vdbg(wm8994->dev, "Write %04x to R%d(0x%x)\n",
-			 buf[i], reg + i, reg + i);
-
-		buf[i] = cpu_to_be16(buf[i]);
+			 be16_to_cpu(buf[i]), reg + i, reg + i);
 	}
 
 	return wm8994->write_dev(wm8994, reg, bytes, src);
@@ -127,6 +125,8 @@ int wm8994_reg_write(struct wm8994 *wm8994, unsigned short reg,
 {
 	int ret;
 
+	val = cpu_to_be16(val);
+
 	mutex_lock(&wm8994->io_lock);
 
 	ret = wm8994_write(wm8994, reg, 2, &val);
@@ -143,7 +143,7 @@ EXPORT_SYMBOL_GPL(wm8994_reg_write);
  * @wm8994: Device to write to
  * @reg: First register
  * @count: Number of registers
- * @buf: Buffer to write from.
+ * @buf: Buffer to write from.  Data must be big-endian formatted.
  */
 int wm8994_bulk_write(struct wm8994 *wm8994, unsigned short reg,
 		      int count, u16 *buf)
@@ -183,6 +183,8 @@ int wm8994_set_bits(struct wm8994 *wm8994, unsigned short reg,
 	r &= ~mask;
 	r |= val;
 
+	r = cpu_to_be16(r);
+
 	ret = wm8994_write(wm8994, reg, 2, &r);
 
 out:
-- 
1.7.4.1

