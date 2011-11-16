Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab1KPP3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:29:31 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:13568
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab1KPP30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:29:26 -0500
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
Subject: [PATCH 3/7] regmap: Properly round cache_word_size
Date: Wed, 16 Nov 2011 16:28:18 +0100
Message-ID: <1321457302-8724-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321457302-8724-1-git-send-email-lars@metafoo.de>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regcache currently only properly works with val sizes of 8 or 16. For all other
val sizes it will round them down to the next multiple of 8, which will cause
the cache to be too small. This patch fixes it by rounding the cache_word_size
up to the nearest storage size.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index d687df6..6f0dbc0 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -111,8 +111,15 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	map->num_reg_defaults = config->num_reg_defaults;
 	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
 	map->reg_defaults_raw = config->reg_defaults_raw;
-	map->cache_size_raw = (config->val_bits / 8) * config->num_reg_defaults_raw;
-	map->cache_word_size = config->val_bits / 8;
+
+	if (config->val_bits <= 8)
+		map->cache_word_size = 1;
+	else if (config->val_bits <= 16)
+		map->cache_word_size = 2;
+	else
+		return -EINVAL;
+
+	map->cache_size_raw = map->cache_word_size * config->num_reg_defaults_raw;
 
 	map->cache = NULL;
 	map->cache_ops = cache_types[i];
-- 
1.7.7.1


