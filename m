Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab3AJMTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:19:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41525 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754302Ab3AJMS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:18:59 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 5/9] mfd: arizona: Check errors from regcache_sync()
Date: Thu, 10 Jan 2013 12:18:48 +0000
Message-Id: <1357820332-14586-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130110121828.GN20956@opensource.wolfsonmicro.com>
 <1357820332-14586-1-git-send-email-broonie@opensource.wolfsonmicro.com>
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
index a8b8a7b..1ab02a7 100644
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

