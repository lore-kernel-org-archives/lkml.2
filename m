Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1KPTdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:33:49 -0500
Received: from smtp-out-060.synserver.de ([212.40.185.60]:1146 "HELO
	smtp-out-058.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1751953Ab1KPTdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:33:47 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16707
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH  v2 1/2] regmap: Properly round cache_word_size
Date: Wed, 16 Nov 2011 20:34:03 +0100
Message-Id: <1321472044-15686-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache currently only properly works with val bit sizes of 8 or 16, since
it will, when calculating the cache word size, round down. This causes the
cache storage to be too small to hold the full register value. Fix this by
rounding up instead.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>

---
Changes since v1:
 * Use DIV_ROUND_UP
---
 drivers/base/regmap/regcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d687df6..6d93e49 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -111,8 +111,8 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	map->num_reg_defaults = config->num_reg_defaults;
 	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
 	map->reg_defaults_raw = config->reg_defaults_raw;
-	map->cache_size_raw = (config->val_bits / 8) * config->num_reg_defaults_raw;
-	map->cache_word_size = config->val_bits / 8;
+	map->cache_word_size = DIV_ROUND_UP(config->val_bits, 8);
+	map->cache_size_raw = map->cache_word_size * config->num_reg_defaults_raw;
 
 	map->cache = NULL;
 	map->cache_ops = cache_types[i];
-- 
1.7.7.1

