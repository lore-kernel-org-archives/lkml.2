Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab2JDRgX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 13:36:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59426 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932151Ab2JDRgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 13:36:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: Split raw writes that cross window boundaries
Date: Thu,  4 Oct 2012 18:36:16 +0100
Message-Id: <1349372177-18931-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1349372177-18931-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1349372177-18931-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a block write covers a paged memory region and crosses a window
boundary then rather than failing the write split the transfer up
into multiple writes, making the whole process more transparent for
drivers.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |   21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index baf9586..07ea564 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -852,8 +852,25 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	range = _regmap_range_lookup(map, reg);
 	if (range) {
-		ret = _regmap_select_page(map, &reg, range,
-					  val_len / map->format.val_bytes);
+		int val_num = val_len / map->format.val_bytes;
+		int win_offset = (reg - range->range_min) % range->window_len;
+		int win_residue = range->window_len - win_offset;
+
+		/* If the write goes beyond the end of the window split it */
+		while (val_num > win_residue) {
+			dev_dbg(map->dev, "Writing window %d/%d\n",
+				win_residue, val_len);
+			ret = _regmap_raw_write(map, reg, val, win_residue);
+			if (ret != 0)
+				return ret;
+
+			val += win_residue;
+			val_len -= win_residue;
+			val_num = val_len / map->format.val_bytes;
+			win_residue = range->window_len - win_offset;
+		}
+
+		ret = _regmap_select_page(map, &reg, range, val_num);
 		if (ret != 0)
 			return ret;
 	}
-- 
1.7.10.4

