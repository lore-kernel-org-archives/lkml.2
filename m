Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab2LJQZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 11:25:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753460Ab2LJQZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 11:25:40 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/3] regmap: debugfs: Avoid overflows for very small reads
Date: Tue, 11 Dec 2012 01:25:30 +0900
Message-Id: <1355156732-2943-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If count is less than the size of a register then we may hit integer
wraparound when trying to move backwards to check if we're still in
the buffer. Instead move the position forwards to check if it's still
in the buffer, we are unlikely to be able to allocate a buffer
sufficiently big to overflow here.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 00fbd58..3df274e 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -93,7 +93,7 @@ static ssize_t regmap_read_debugfs(struct regmap *map, unsigned int from,
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
-			if (buf_pos >= count - 1 - map->debugfs_tot_len)
+			if (buf_pos + 1 + map->debugfs_tot_len >= count)
 				break;
 
 			/* Format the register */
-- 
1.7.10.4

