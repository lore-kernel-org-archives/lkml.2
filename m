Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab2KTFtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:49:20 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41961 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872Ab2KTFtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:49:19 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: arizona: Sync regcache after reset
Date: Tue, 20 Nov 2012 14:49:10 +0900
Message-Id: <1353390550-28077-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353386781-10468-5-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1353386781-10468-5-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

In the absence of a physical reset line the chip is reset by writing the
first register, which is done after the register patch has been applied.
This patch synchronises the register cache after the reset to preserve
any register changes that had been applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 202bf55..f4f9bf8 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -415,11 +415,19 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 
 	/* If we have a /RESET GPIO we'll already be reset */
 	if (!arizona->pdata.reset) {
+		regcache_mark_dirty(arizona->regmap);
+
 		ret = regmap_write(arizona->regmap, ARIZONA_SOFTWARE_RESET, 0);
 		if (ret != 0) {
 			dev_err(dev, "Failed to reset device: %d\n", ret);
 			goto err_reset;
 		}
+
+		ret = regcache_sync(arizona->regmap);
+		if (ret != 0) {
+			dev_err(dev, "Failed to sync device: %d\n", ret);
+			goto err_reset;
+		}
 	}
 
 	ret = arizona_wait_for_boot(arizona);
-- 
1.7.10.4

