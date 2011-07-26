Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1GZSG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:06:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54057 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751373Ab1GZSGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:06:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/5] regmap: Allow devices to specify which registers are accessible
Date: Tue, 26 Jul 2011 19:06:12 +0100
Message-Id: <1311703576-7955-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is currently unused but we need to know which registers exist and
their properties in order to implement diagnostics like register map
dumps and the cache features.

We use callbacks partly because properties can vary at runtime (eg, through
access locks on registers) and partly because big switch statements are a
good compromise between readable code and small data size for providing
information on big register maps.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap.c |    9 +++++++++
 include/linux/regmap.h       |   13 +++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 95bab38..7d4dc11 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -40,6 +40,11 @@ struct regmap {
 	void *work_buf;     /* Scratch buffer used to format I/O */
 	struct regmap_format format;  /* Buffer format */
 	const struct regmap_bus *bus;
+
+	unsigned int max_register;
+	bool (*writeable_reg)(struct device *dev, unsigned int reg);
+	bool (*readable_reg)(struct device *dev, unsigned int reg);
+	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 };
 
 static void regmap_format_4_12_write(struct regmap *map,
@@ -119,6 +124,10 @@ struct regmap *regmap_init(struct device *dev,
 	map->format.val_bytes = config->val_bits / 8;
 	map->dev = dev;
 	map->bus = bus;
+	map->max_register = config->max_register;
+	map->writeable_reg = config->writeable_reg;
+	map->readable_reg = config->readable_reg;
+	map->volatile_reg = config->volatile_reg;
 
 	switch (config->reg_bits) {
 	case 4:
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index cf8e4cf..aef2b36 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -25,10 +25,23 @@ struct spi_device;
  *
  * @reg_bits: Number of bits in a register address, mandatory.
  * @val_bits: Number of bits in a register value, mandatory.
+ *
+ * @max_register: Optional, specifies the maximum valid register index.
+ * @writeable_register: Optional callback returning true if the register
+ *                      can be written to.
+ * @readable_register: Optional callback returning true if the register
+ *                     can be read from.
+ * @volatile_register: Optional callback returning true if the register
+ *                     value can't be cached.
  */
 struct regmap_config {
 	int reg_bits;
 	int val_bits;
+
+	unsigned int max_register;
+	bool (*writeable_reg)(struct device *dev, unsigned int reg);
+	bool (*readable_reg)(struct device *dev, unsigned int reg);
+	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.5.4

