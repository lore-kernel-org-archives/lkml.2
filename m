Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab1KOMeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:34:44 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:9319
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1KOMen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:34:43 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-SS: 0,13,
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 2/2] regmap: Do not call regcache_exit from regcache_lzo_init error path
Date: Tue, 15 Nov 2011 13:34:41 +0100
Message-ID: <1321360481-17783-2-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321360481-17783-1-git-send-email-lars@metafoo.de>
References: <20111114214304.GI6528@opensource.wolfsonmicro.com>
 <1321360481-17783-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling regcache_exit from regcache_lzo_init is first of all a layering
violation and secondly will cause double frees. regcache_exit will free buffers
allocated by the core, but the core will also free the same buffers when the
cacheops init callback returns an error. Thus we end up with a double free.
Fix this by not calling regcache_exit but only free those buffers which, have
been allocated in this function.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regcache-lzo.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regcache-lzo.c b/drivers/base/regmap/regcache-lzo.c
index 226ffc1..b7d1614 100644
--- a/drivers/base/regmap/regcache-lzo.c
+++ b/drivers/base/regmap/regcache-lzo.c
@@ -15,6 +15,8 @@
 
 #include "internal.h"
 
+static int regcache_lzo_exit(struct regmap *map);
+
 struct regcache_lzo_ctx {
 	void *wmem;
 	void *dst;
@@ -193,7 +195,7 @@ static int regcache_lzo_init(struct regmap *map)
 
 	return 0;
 err:
-	regcache_exit(map);
+	regcache_lzo_exit(map);
 	return ret;
 }
 
-- 
1.7.7.1


