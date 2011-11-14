Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab1KNJjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 04:39:46 -0500
Received: from mail-am1.bigfish.com ([213.199.180.138]:13753 "EHLO
	AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752963Ab1KNJjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:39:45 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/5] regmap: Fix memory leak in regcache_hw_init error path
Date: Mon, 14 Nov 2011 10:40:16 +0100
Message-ID: <1321263619-25891-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321263619-25891-1-git-send-email-lars@metafoo.de>
References: <1321263619-25891-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure reg_defaults_raw gets freed in case of an error.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6ab9f03..7944626 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -61,8 +61,10 @@ static int regcache_hw_init(struct regmap *map)
 
 	map->reg_defaults = kmalloc(count * sizeof(struct reg_default),
 				      GFP_KERNEL);
-	if (!map->reg_defaults)
-		return -ENOMEM;
+	if (!map->reg_defaults) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
 
 	/* fill the reg_defaults */
 	map->num_reg_defaults = count;
@@ -77,6 +79,12 @@ static int regcache_hw_init(struct regmap *map)
 	}
 
 	return 0;
+
+err_free:
+	if (map->cache_free)
+		kfree(map->reg_defaults_raw);
+
+	return ret;
 }
 
 int regcache_init(struct regmap *map)
-- 
1.7.7.1


