Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1KPP2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:28:05 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:35083 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab1KPP2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:28:02 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Michael Hennerich <michael.hennerich@analog.com>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <device-drivers-devel@blackfin.uclinux.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/7] regmap: Make reg_config reg_defaults const
Date: Wed, 16 Nov 2011 16:28:17 +0100
Message-ID: <1321457302-8724-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321457302-8724-1-git-send-email-lars@metafoo.de>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reg_defaults field usually points to a static per driver array, which should
not be modified. Make requirement this explicit by making reg_defaults const.
To allow this the regcache_init code needs some minor changes. Previoulsy the
reg_config was not available in regcache_init and regmap->reg_defaults was used
to pass the default register set to regcache_init. Now that the reg_config is
available we can work on it directly.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |    5 ++---
 include/linux/regmap.h         |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 0ad6cfb..d687df6 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -108,7 +108,6 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 		return -EINVAL;
 	}
 
-	map->reg_defaults = config->reg_defaults;
 	map->num_reg_defaults = config->num_reg_defaults;
 	map->num_reg_defaults_raw = config->num_reg_defaults_raw;
 	map->reg_defaults_raw = config->reg_defaults_raw;
@@ -127,10 +126,10 @@ int regcache_init(struct regmap *map, const struct regmap_config *config)
 	 * won't vanish from under us.  We'll need to make
 	 * a copy of it.
 	 */
-	if (map->reg_defaults) {
+	if (config->reg_defaults) {
 		if (!map->num_reg_defaults)
 			return -EINVAL;
-		tmp_buf = kmemdup(map->reg_defaults, map->num_reg_defaults *
+		tmp_buf = kmemdup(config->reg_defaults, map->num_reg_defaults *
 				  sizeof(struct reg_default), GFP_KERNEL);
 		if (!tmp_buf)
 			return -ENOMEM;
diff --git a/include/linux/regmap.h b/include/linux/regmap.h
index 1e4ec2b..458f15f 100644
--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -83,7 +83,7 @@ struct regmap_config {
 	bool (*precious_reg)(struct device *dev, unsigned int reg);
 
 	unsigned int max_register;
-	struct reg_default *reg_defaults;
+	const struct reg_default *reg_defaults;
 	unsigned int num_reg_defaults;
 	enum regcache_type cache_type;
 	const void *reg_defaults_raw;
-- 
1.7.7.1


