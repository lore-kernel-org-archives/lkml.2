Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2KLR4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 12:56:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51017 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752198Ab2KLR4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 12:56:49 -0500
Date: Mon, 12 Nov 2012 17:56:48 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: arizona: Move chip reset to before register patch
Message-ID: <20121112175648.GA29044@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of a physical reset line the chip is reset by writing the
first register, this was done after the register patch was applied which
negates the settings applied in the register patch.

This patch moves the reset to take place before the register patch is
applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-core.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 1b48f20..1d241ea 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -366,6 +366,15 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 
 	regcache_cache_only(arizona->regmap, false);
 
+	/* If we have a /RESET GPIO we'll already be reset */
+	if (!arizona->pdata.reset) {
+		ret = regmap_write(arizona->regmap, ARIZONA_SOFTWARE_RESET, 0);
+		if (ret != 0) {
+			dev_err(dev, "Failed to reset device: %d\n", ret);
+			goto err_reset;
+		}
+	}
+
 	ret = regmap_read(arizona->regmap, ARIZONA_SOFTWARE_RESET, &reg);
 	if (ret != 0) {
 		dev_err(dev, "Failed to read ID register: %d\n", ret);
@@ -413,15 +422,6 @@ int __devinit arizona_dev_init(struct arizona *arizona)
 	if (ret != 0)
 		dev_err(arizona->dev, "Failed to apply patch: %d\n", ret);
 
-	/* If we have a /RESET GPIO we'll already be reset */
-	if (!arizona->pdata.reset) {
-		ret = regmap_write(arizona->regmap, ARIZONA_SOFTWARE_RESET, 0);
-		if (ret != 0) {
-			dev_err(dev, "Failed to reset device: %d\n", ret);
-			goto err_reset;
-		}
-	}
-
 	ret = arizona_wait_for_boot(arizona);
 	if (ret != 0) {
 		dev_err(arizona->dev, "Device failed initial boot: %d\n", ret);
-- 
1.7.2.5

