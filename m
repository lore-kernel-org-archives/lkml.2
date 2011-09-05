Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab1IENSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:18:33 -0400
Received: from smtp-out-051.synserver.de ([212.40.185.51]:1096 "EHLO
	smtp-out-049.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753668Ab1IENSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:18:30 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 29850
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: alsa-devel@alsa-project.org, device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/3] regmap: Add support for device specific write and read flag masks.
Date: Mon,  5 Sep 2011 15:18:00 +0200
Message-Id: <1315228682-1097-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some buses like SPI have no standard notation of read or write operations.
The general scheme here is to set or clear specific bits in the register
address to indicate whether the operation is a read or write. We already
support having a read flag mask per bus, but as there is no standard
the bits which need to be set or cleared differ between devices and vendors,
thus we need a mechanism to specify them per device.

This patch adds two new entries to the regmap_config struct, read_flag_mask and
write_flag_mask. These will be or'ed onto the top byte when doing a read or
write operation. If both masks are empty the device will fallback to the
regmap_bus masks.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/internal.h |    3 +++
 drivers/base/regmap/regmap.c   |   15 ++++++++++++---
 include/linux/regmap.h         |    9 +++++++++
 3 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 5ab3fef..7e14d5a 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -46,6 +46,9 @@ struct regmap {
 	bool (*readable_reg)(struct device *dev, unsigned int reg);
 	bool (*volatile_reg)(struct device *dev, unsigned int reg);
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
+
+	u8 read_flag_mask;
+	u8 write_flag_mask;
 };
 
 bool regmap_writeable(struct regmap *map, unsigned int reg);
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fa2bd89..8ecf8bf 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -147,6 +147,13 @@ struct regmap *regmap_init(struct device *dev,
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
 
+	if (config->read_flag_mask || config->write_flag_mask) {
+		map->read_flag_mask = config->read_flag_mask;
+		map->write_flag_mask = config->write_flag_mask;
+	} else {
+		map->read_flag_mask = bus->read_flag_mask;
+	}
+
 	switch (config->reg_bits) {
 	case 4:
 		switch (config->val_bits) {
@@ -229,6 +236,7 @@ EXPORT_SYMBOL_GPL(regmap_exit);
 static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 			     const void *val, size_t val_len)
 {
+	u8 *u8 = map->work_buf;
 	void *buf;
 	int ret = -ENOTSUPP;
 	size_t len;
@@ -242,6 +250,8 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 
 	map->format.format_reg(map->work_buf, reg);
 
+	u8[0] |= map->write_flag_mask;
+
 	trace_regmap_hw_write_start(map->dev, reg,
 				    val_len / map->format.val_bytes);
 
@@ -369,13 +379,12 @@ static int _regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	map->format.format_reg(map->work_buf, reg);
 
 	/*
-	 * Some buses flag reads by setting the high bits in the
+	 * Some buses or devices flag reads by setting the high bits in the
 	 * register addresss; since it's always the high bits for all
 	 * current formats we can do this here rather than in
 	 * formatting.  This may break if we get interesting formats.
 	 */
-	if (map->bus->read_flag_mask)
-		u8[0] |= map->bus->read_flag_mask;
+	u8[0] |= map->read_flag_mask;
 
 	trace_regmap_hw_read_start(map->dev, reg,
 				   val_len / map->format.val_bytes);
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 449e264..f0b8d47 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -53,6 +53,12 @@ struct reg_default {
  * @reg_defaults: Power on reset values for registers (for use with
  *                register cache support).
  * @num_reg_defaults: Number of elements in reg_defaults.
+ *
+ * @read_flag_mask: Mask to be set in the top byte of the register when doing
+ *                  a read.
+ * @write_flag_mask: Mask to be set in the top byte of the register when doing
+ *                   a write. If both read_flag_mask and write_flag_mask are
+ *                   empty the regmap_bus default masks are used.
  */
 struct regmap_config {
 	int reg_bits;
@@ -66,6 +72,9 @@ struct regmap_config {
 	unsigned int max_register;
 	struct reg_default *reg_defaults;
 	int num_reg_defaults;
+
+	u8 read_flag_mask;
+	u8 write_flag_mask;
 };
 
 typedef int (*regmap_hw_write)(struct device *dev, const void *data,
-- 
1.7.2.5

