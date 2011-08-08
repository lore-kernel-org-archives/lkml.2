Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1HHHuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 03:50:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48369 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751525Ab1HHHuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 03:50:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: Skip precious registers when dumping registers via debugfs
Date: Mon,  8 Aug 2011 15:44:32 +0900
Message-Id: <1312785872-19629-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312785872-19629-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1312785872-19629-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/internal.h       |    1 +
 drivers/base/regmap/regmap-debugfs.c |    4 ++++
 drivers/base/regmap/regmap.c         |    1 +
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 78f87f3..a67dc68 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -45,6 +45,7 @@ struct regmap {
 	bool (*writeable_reg)(struct device *dev, unsigned int reg);
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
+	bool (*precious_reg)(struct device *dev, unsigned int reg);
 };
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 2be8bf8..184b618 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -56,6 +56,10 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 		    !map->readable_reg(map->dev, i))
 			continue;
 
+		if (map->precious_reg &&
+		    map->precious_reg(map->dev, i))
+			continue;
+
 		/* If we're in the region the user is trying to read */
 		if (p >= *ppos) {
 			/* ...but not beyond it */
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e68556c..c25c13c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -101,6 +101,7 @@ struct regmap *regmap_init(struct device *dev,
 	map->writeable_reg = config->writeable_reg;
 	map->readable_reg = config->readable_reg;
 	map->volatile_reg = config->volatile_reg;
+	map->precious_reg = config->precious_reg;
 
 	switch (config->reg_bits) {
 	case 4:
-- 
1.7.5.4

