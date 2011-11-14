Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1KNJkG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:40:06 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:46012 "EHLO
	AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754120Ab1KNJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:39:50 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/5] regmap: Fix memory leak in regcache_init error path
Date: Mon, 14 Nov 2011 10:40:17 +0100
Message-ID: <1321263619-25891-3-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure all allocated memory gets freed again in case initializing the cache
failed.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 7944626..27fae58 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -144,9 +144,18 @@ int regcache_init(struct regmap *map)
 	if (map->cache_ops->init) {
 		dev_dbg(map->dev, "Initializing %s cache\n",
 			map->cache_ops->name);
-		return map->cache_ops->init(map);
+		ret = map->cache_ops->init(map);
+		if (ret)
+			goto err_free;
 	}
 	return 0;
+
+err_free:
+	kfree(map->reg_defaults);
+	if (map->cache_free)
+		kfree(map->reg_defaults_raw);
+
+	return ret;
 }
 
 void regcache_exit(struct regmap *map)
-- 
1.7.7.1


