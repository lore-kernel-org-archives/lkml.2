Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364Ab1KJROu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 12:14:50 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:33159
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757581Ab1KJROs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 12:14:48 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        <linux-kernel@vger.kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: Fix memory leak in regmap_init error path
Date: Thu, 10 Nov 2011 18:15:15 +0100
Message-ID: <1320945315-2745-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If regcache initialization fails regmap_init will currently exit without
freeing work_buf.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/regmap.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 3e30d16..b08df85 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -229,12 +229,14 @@ struct regmap *regmap_init(struct device *dev,
 
 	ret = regcache_init(map);
 	if (ret < 0)
-		goto err_map;
+		goto err_free_workbuf;
 
 	regmap_debugfs_init(map);
 
 	return map;
 
+err_free_workbuf:
+	kfree(map->work_buf);
 err_map:
 	kfree(map);
 err:
-- 
1.7.7.1


