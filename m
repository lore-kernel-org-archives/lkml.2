Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab1KRQIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 11:08:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46035 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949Ab1KRQIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 11:08:00 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Suppress noop writes in regmap_update_bits()
Date: Fri, 18 Nov 2011 16:07:56 +0000
Message-Id: <1321632476-28162-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the new register value is identical to the original one then suppress
the write to the hardware in regmap_update_bits(), saving some I/O cost.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e533368..10ecbba3 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -583,18 +583,19 @@ int regmap_update_bits(struct regmap *map, unsigned int reg,
 		       unsigned int mask, unsigned int val)
 {
 	int ret;
-	unsigned int tmp;
+	unsigned int tmp, orig;
 
 	mutex_lock(&map->lock);
 
-	ret = _regmap_read(map, reg, &tmp);
+	ret = _regmap_read(map, reg, &orig);
 	if (ret != 0)
 		goto out;
 
-	tmp &= ~mask;
+	tmp = orig & ~mask;
 	tmp |= val & mask;
 
-	ret = _regmap_write(map, reg, tmp);
+	if (tmp != orig)
+		ret = _regmap_write(map, reg, tmp);
 
 out:
 	mutex_unlock(&map->lock);
-- 
1.7.7.3

