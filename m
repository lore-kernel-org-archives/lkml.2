Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1KPP26 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:28:58 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:11130
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab1KPP2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:28:04 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jonathan Cameron <jic23@kernel.org>
CC: Michael Hennerich <michael.hennerich@analog.com>,
        <linux-kernel@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <device-drivers-devel@blackfin.uclinux.org>, <drivers@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/7] regmap: Try cached read before checking if a hardware read is possible
Date: Wed, 16 Nov 2011 16:28:19 +0100
Message-ID: <1321457302-8724-4-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321457302-8724-1-git-send-email-lars@metafoo.de>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some register format types we do not provide a parse_val so we can not do a
hardware read. But a cached read is still possible, so try to read from the
cache first, before checking whether a hardware read is possible. Otherwise the
cache becomes pretty useless for these register types.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3cf4785..b96cf72 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -434,15 +434,15 @@ static int _regmap_read(struct regmap *map, unsigned int reg,
 {
 	int ret;
 
-	if (!map->format.parse_val)
-		return -EINVAL;
-
 	if (!map->cache_bypass) {
 		ret = regcache_read(map, reg, val);
 		if (ret == 0)
 			return 0;
 	}
 
+	if (!map->format.parse_val)
+		return -EINVAL;
+
 	if (map->cache_only)
 		return -EBUSY;
 
-- 
1.7.7.1


