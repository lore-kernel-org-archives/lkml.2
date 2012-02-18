Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2BRACh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 19:02:37 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45394 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751521Ab2BRACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 19:02:36 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regmap: Implement support for 32 bit registers and values
Date: Fri, 17 Feb 2012 16:01:25 -0800
Message-Id: <1329523285-1285-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache.c |   11 +++++++++++
 drivers/base/regmap/regmap.c   |   24 ++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index a10e81c..0cadb11 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -386,6 +386,13 @@ bool regcache_set_val(void *base, unsigned int idx,
 		cache[idx] = val;
 		break;
 	}
+	case 4: {
+		u32 *cache = base;
+		if (cache[idx] == val)
+			return true;
+		cache[idx] = val;
+		break;
+	}
 	default:
 		BUG();
 	}
@@ -407,6 +414,10 @@ unsigned int regcache_get_val(const void *base, unsigned int idx,
 		const u16 *cache = base;
 		return cache[idx];
 	}
+	case 4: {
+		const u32 *cache = base;
+		return cache[idx];
+	}
 	default:
 		BUG();
 	}
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a871f14..d1db130 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -125,6 +125,13 @@ static void regmap_format_16(void *buf, unsigned int val)
 	b[0] = cpu_to_be16(val);
 }
 
+static void regmap_format_32(void *buf, unsigned int val)
+{
+	__be32 *b = buf;
+
+	b[0] = cpu_to_be32(val);
+}
+
 static unsigned int regmap_parse_8(void *buf)
 {
 	u8 *b = buf;
@@ -141,6 +148,15 @@ static unsigned int regmap_parse_16(void *buf)
 	return b[0];
 }
 
+static unsigned int regmap_parse_32(void *buf)
+{
+	__be32 *b = buf;
+
+	b[0] = be32_to_cpu(b[0]);
+
+	return b[0];
+}
+
 /**
  * regmap_init(): Initialise register map
  *
@@ -239,6 +255,10 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.format_reg = regmap_format_16;
 		break;
 
+	case 32:
+		map->format.format_reg = regmap_format_32;
+		break;
+
 	default:
 		goto err_map;
 	}
@@ -252,6 +272,10 @@ struct regmap *regmap_init(struct device *dev,
 		map->format.format_val = regmap_format_16;
 		map->format.parse_val = regmap_parse_16;
 		break;
+	case 32:
+		map->format.format_val = regmap_format_32;
+		map->format.parse_val = regmap_parse_32;
+		break;
 	}
 
 	if (!map->format.format_write &&
-- 
1.7.9

