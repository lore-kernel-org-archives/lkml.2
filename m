Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768110Ab2KOOz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:55:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36976 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1768071Ab2KOOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:55:26 -0500
Date: Thu, 15 Nov 2012 14:55:25 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>, sameo@linux.intel.com
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3] mfd: arizona: Sync regcache after reset
Message-ID: <20121115145524.GB11206@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com> <20121113055618.GC18224@opensource.wolfsonmicro.com> <20121113131219.GA29198@opensource.wolfsonmicro.com> <20121114012007.GD4415@opensource.wolfsonmicro.com> <20121114104854.GB23525@opensource.wolfsonmicro.com> <20121114105106.GK7407@opensource.wolfsonmicro.com> <20121114113138.GC23525@opensource.wolfsonmicro.com> <20121114113424.GM7407@opensource.wolfsonmicro.com> <20121114114537.GA11206@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114114537.GA11206@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of a physical reset line the chip is reset by writing the
first register, which is done after the register patch has been applied.
This patch synchronises the register cache after the reset to preserve
any register changes that had been applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Apologies but it seems I accidentally generated yesterdays patch
against a local development branch rather than the upstream
branch. Sorry for the inconvience here is a fixed version.


 drivers/mfd/arizona-core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

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
1.7.2.5

