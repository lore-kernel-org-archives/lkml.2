Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1GZSHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:07:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54058 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751567Ab1GZSGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:06:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/5] regmap: Implement writable register checks
Date: Tue, 26 Jul 2011 19:06:13 +0100
Message-Id: <1311703576-7955-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mainly intended to be used by devices which can dynamically
block register writes at runtime, for other devices there is usually
limited value.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 7d4dc11..e57f10f 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -211,6 +211,13 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 	void *buf;
 	int ret = -ENOTSUPP;
 	size_t len;
+	int i;
+
+	/* Check for unwritable registers before we start */
+	if (map->writeable_reg)
+		for (i = 0; i < val_len / map->format.val_bytes; i++)
+			if (!map->writeable_reg(map->dev, reg + i))
+				return -EINVAL;
 
 	map->format.format_reg(map->work_buf, reg);
 
-- 
1.7.5.4

