Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732Ab2CZOrQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:47:16 -0400
Received: from mail.meprolight.com ([194.90.149.17]:57346 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932489Ab2CZOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:47:14 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <marc.reilly@gmail.com>, <s.hauer@pengutronix.de>,
        <fabio.estevam@freescale.com>, Alex Gershgorin <alexg@meprolight.com>
Subject: [PATCH] regmap: Add 24 bits support
Date: Mon, 26 Mar 2012 16:40:08 +0200
Message-ID: <1332772808-13346-1-git-send-email-alexg@meprolight.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for PMIC who use regmap and 24 bit registers
For example MC13892, the patch was tested on i.MX35-PDK

Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
---
 drivers/base/regmap/internal.h |    1 +
 drivers/base/regmap/regmap.c   |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 1a02b75..3c5d204 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -122,5 +122,6 @@ int regcache_lookup_reg(struct regmap *map, unsigned int reg);
 
 extern struct regcache_ops regcache_rbtree_ops;
 extern struct regcache_ops regcache_lzo_ops;
+typedef struct { __u8 b[3]; } __be24;
 
 #endif
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6555803..499ee6a 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -114,6 +114,13 @@ static void regmap_format_16(void *buf, unsigned int val)
 	b[0] = cpu_to_be16(val);
 }
 
+static void regmap_format_24(void *buf, unsigned int val)
+{
+	__be24 *b = buf;
+
+	b[0] = (__be24){ {(val >> 16) & 0xff, (val >> 8) & 0xff, val & 0xff } };
+}
+
 static unsigned int regmap_parse_8(void *buf)
 {
 	u8 *b = buf;
@@ -130,6 +137,13 @@ static unsigned int regmap_parse_16(void *buf)
 	return b[0];
 }
 
+static unsigned int regmap_parse_24(void *buf)
+{
+	__be24 *b = buf;
+
+	return (b->b[0] << 16) | (b->b[1] << 8) | (b->b[2]);
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -229,6 +243,10 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.format_val = regmap_format_16;
 		map->format.parse_val = regmap_parse_16;
 		break;
+	case 24:
+		map->format.format_val = regmap_format_24;
+		map->format.parse_val = regmap_parse_24;
+		break;
 	}
 
 	if (!map->format.format_write &&
-- 
1.7.0.4

