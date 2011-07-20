Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GTVGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 17:06:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49995 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751654Ab1GTVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 17:06:11 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Just send the buffer directly for single register writes
Date: Wed, 20 Jul 2011 22:06:08 +0100
Message-Id: <1311195968-9819-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing a single register write we use work_buf for both the register
and the value with the buffer formatted for sending directly to the device
so we can just do a write() directly. This saves allocating a temporary
buffer if we can't do gather writes and is likely to be faster than doing
a gather write.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index cf3565c..84acbef 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -202,13 +202,20 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->format.format_reg(map->work_buf, reg);
 
-	/* Try to do a gather write if we can */
-	if (map->bus->gather_write)
+	/* If we're doing a single register write we can probably just
+	 * send the work_buf directly, otherwise try to do a gather
+	 * write.
+	 */
+	if (val == map->work_buf + map->format.reg_bytes)
+		ret = map->bus->write(map->dev, map->work_buf,
+				      map->format.reg_bytes +
+				      map->format.val_bytes);
+	else if (map->bus->gather_write)
 		ret = map->bus->gather_write(map->dev, map->work_buf,
 					     map->format.reg_bytes,
 					     val, val_len);
 
-	/* Otherwise fall back on linearising by hand. */
+	/* If that didn't work fall back on linearising by hand. */
 	if (ret == -ENOTSUPP) {
 		len = map->format.reg_bytes + val_len;
 		buf = kmalloc(len, GFP_KERNEL);
-- 
1.7.5.4

