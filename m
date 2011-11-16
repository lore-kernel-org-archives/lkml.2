Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1KPP3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:29:49 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:14345
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1KPP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:29:48 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Michael Hennerich <michael.hennerich@analog.com>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <device-drivers-devel@blackfin.uclinux.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 1/7] regmap: Move initialization of regcache related fields to regcache_init
Date: Wed, 16 Nov 2011 16:28:16 +0100
Message-ID: <1321457302-8724-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the initialization regcache related fields of the regmap struct to
regcache_init. This allows us to keep regmap and regcache code better
separated.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/internal.h |    2 +-
 drivers/base/regmap/regcache.c |    9 ++++++++-
 drivers/base/regmap/regmap.c   |    8 +-------
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index 6483e0b..954f7b7 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -106,7 +106,7 @@ static inline void regmap_debugfs_exit(struct regmap *map) { }
 #endif
 
 /* regcache core declarations */
-int regcache_init(struct regmap *map);
+int regcache_init(struct regmap *map, const struct regmap_config *config);
 void regcache_exit(struct regmap *map);
 int regcache_read(struct regmap *map,
 		       unsigned int reg, unsigned int *value);
diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 27fae58..0ad6cfb 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -87,7 +87,7 @@ err_free:
 	return ret;
 }
 
-int regcache_init(struct regmap *map)
+int regcache_init(struct regmap *map, const struct regmap_config *config)
 {
 	int ret;
 	int i;
@@ -108,6 +108,13 @@ int regcache_init(struct regmap *map)
 		return -EINVAL;
 	}
 
+	map->reg_defaults = config->reg_defaults;
+	map->num_reg_defaults = config->num_reg_defaults;
+	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
+	map->reg_defaults_raw = config->reg_defaults_raw;
+	map->cache_size_raw = (config->val_bits / 8) * config->num_reg_defaults_raw;
+	map->cache_word_size = config->val_bits / 8;
+
 	map->cache = NULL;
 	map->cache_ops = cache_types[i];
 
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index b84ebf9..3cf4785 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -159,12 +159,6 @@ struct regmap *regmap_init(struct device *dev,
 	map->volatile_reg = config->volatile_reg;
 	map->precious_reg = config->precious_reg;
 	map->cache_type = config->cache_type;
-	map->reg_defaults = config->reg_defaults;
-	map->num_reg_defaults = config->num_reg_defaults;
-	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
-	map->reg_defaults_raw = config->reg_defaults_raw;
-	map->cache_size_raw = (config->val_bits / 8) * config->num_reg_defaults_raw;
-	map->cache_word_size = config->val_bits / 8;
 
 	if (config->read_flag_mask || config->write_flag_mask) {
 		map->read_flag_mask = config->read_flag_mask;
@@ -227,7 +221,7 @@ struct regmap *regmap_init(struct device *dev,
 		goto err_map;
 	}
 
-	ret = regcache_init(map);
+	ret = regcache_init(map, config);
 	if (ret < 0)
 		goto err_free_workbuf;
 
-- 
1.7.7.1


