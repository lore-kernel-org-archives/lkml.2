Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1KHRhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 12:37:04 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:57454
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932235Ab1KHRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 12:36:58 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] regmap: Support some more block operations on cached devices
Date: Tue, 8 Nov 2011 18:37:26 +0100
Message-ID: <1320773846-28635-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1320773846-28635-1-git-send-email-lars@metafoo.de>
References: <1320773846-28635-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 10a08d9f ("regmap: Support some block operations on cached devices")
allowed raw read operations without throwing a warning when using caches if
all registers are volatile. This patch does the same for raw write operations.

This is for example useful when loading a firmware in a predefined volatile
region on a chip where we otherwise want registers to be cached.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 4016b00..a471083 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -387,9 +387,11 @@ EXPORT_SYMBOL_GPL(regmap_write);
 int regmap_raw_write(struct regmap *map, unsigned int reg,
 		     const void *val, size_t val_len)
 {
+	size_t val_count = val_len / map->format.val_bytes;
 	int ret;
 
-	WARN_ON(map->cache_type != REGCACHE_NONE);
+	WARN_ON(!regmap_volatile_range(map, reg, val_count) &&
+		map->cache_type != REGCACHE_NONE);
 
 	mutex_lock(&map->lock);
 
-- 
1.7.7


