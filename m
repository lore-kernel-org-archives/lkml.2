Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538Ab2B1BWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:22:42 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40933 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502Ab2B1BT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:19:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.72.70 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010430.120140267@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:04:37 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lars-Peter Clausen <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 08/72] regmap: Fix cache defaults initialization from raw cache defaults
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 61cddc57dc14a5dffa0921d9a24fd68edbb374ac upstream.

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
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regcache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -54,7 +54,7 @@ static int regcache_hw_init(struct regma
 	for (count = 0, i = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (!val)
+		if (regmap_volatile(map, i))
 			continue;
 		count++;
 	}
@@ -69,7 +69,7 @@ static int regcache_hw_init(struct regma
 	for (i = 0, j = 0; i < map->num_reg_defaults_raw; i++) {
 		val = regcache_get_val(map->reg_defaults_raw,
 				       i, map->cache_word_size);
-		if (!val)
+		if (regmap_volatile(map, i))
 			continue;
 		map->reg_defaults[j].reg = i;
 		map->reg_defaults[j].def = val;


