Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1KPP2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:28:13 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:10087
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083Ab1KPP2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:28:07 -0500
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
Subject: [PATCH 5/7] regmap: Check if a register is writable instead of readable in regcache_read
Date: Wed, 16 Nov 2011 16:28:20 +0100
Message-ID: <1321457302-8724-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321457302-8724-1-git-send-email-lars@metafoo.de>
References: <1321457302-8724-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the reasons for using a cache is to have a software shadow of a register
which is writable but not readable. This allows us to do a read-modify-write
operation on such a register.

Currently regcache checks whether a register is readable when performing a
cached read and returns an error if not. Change this check to test whether the
register is writable. This makes more sense, since reading from the cache when
the register is not readable allows the operation described above, but if the
register is not writable there shouldn't  be a value for it in the cache anyway.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regcache.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 6f0dbc0..a004a7a 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -206,7 +206,7 @@ int regcache_read(struct regmap *map,
 
 	BUG_ON(!map->cache_ops);
 
-	if (!regmap_readable(map, reg))
+	if (!regmap_writeable(map, reg))
 		return -EIO;
 
 	if (!regmap_volatile(map, reg))
-- 
1.7.7.1


