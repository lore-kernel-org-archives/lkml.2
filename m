Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab3ADRQR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 12:16:17 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39351 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079Ab3ADRQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 12:16:16 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Check errors from regcache_sync()
Date: Fri,  4 Jan 2013 17:16:12 +0000
Message-Id: <1357319772-11347-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the control bus is unrelabile we may hit errors during regcache_sync(),
especially given that it tends to be one the most dense bursts of I/O in
many systems.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 2281e80..f8738aa 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -239,7 +239,12 @@ static int arizona_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	regcache_sync(arizona->regmap);
+	ret = regcache_sync(arizona->regmap);
+	if (ret != 0) {
+		dev_err(arizona->dev, "Failed to restore register cache\n");
+		regulator_disable(arizona->dcvdd);
+		return ret;
+	}
 
 	return 0;
 }
-- 
1.7.10.4

