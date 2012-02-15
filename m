Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab2BOJWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:22:22 -0500
Received: from smtp-out-228.synserver.de ([212.40.185.228]:1316 "EHLO
	smtp-out-225.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756025Ab2BOJWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:22:17 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 4314
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: Fix cache defaults initialization from raw cache defaults
Date: Wed, 15 Feb 2012 10:23:25 +0100
Message-Id: <1329297805-8066-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently registers with a value of 0 are ignored when initializing the register
defaults from raw defaults. This worked in the past, because registers without a
explicit default were assumed to have a default value of 0. This was changed in
commit b03622a8 ("regmap: Ensure rbtree syncs registers set to zero properly").
As a result registers, which have a raw default value of 0 are now assumed to
have no default. This again can result in unnecessary writes when syncing the
cache. It will also result in unnecessary reads for e.g. the first update
operation. In the case where readback is not possible this will even let the
update operation fail, if the register has not been written to before.

So this patch removes the check. Instead it adds a check to ignore raw defaults
for registers which are volatile, since those registers are not cached.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 77ce5ff..a10e81c 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -53,7 +53,7 @@ static int regcache_hw_init(struct regmap *map)
 	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (!val)
+		if (regmap_volatile(map, i))
 			continue;
 		count++;
 	}
@@ -70,7 +70,7 @@ static int regcache_hw_init(struct regmap *map)
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (!val)
+		if (regmap_volatile(map, i))
 			continue;
 		map->reg_defaults[j].reg = i;
 		map->reg_defaults[j].def = val;
-- 
1.7.9

