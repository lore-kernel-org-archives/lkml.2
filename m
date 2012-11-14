Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745Ab2KNLbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:31:41 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59734 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755351Ab2KNLbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:31:40 -0500
Date: Wed, 14 Nov 2012 11:31:38 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mfd: arizona: Sync regcache after reset
Message-ID: <20121114113138.GC23525@opensource.wolfsonmicro.com>
References: <20121112175648.GA29044@opensource.wolfsonmicro.com> <20121113055618.GC18224@opensource.wolfsonmicro.com> <20121113131219.GA29198@opensource.wolfsonmicro.com> <20121114012007.GD4415@opensource.wolfsonmicro.com> <20121114104854.GB23525@opensource.wolfsonmicro.com> <20121114105106.GK7407@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114105106.GK7407@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the absence of a physical reset line the chip is reset by writing the
first register, which is done after the register patch has been applied.
This patch synchronises the register cache after the reset to preserve
any register changes that had been applied.

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

I will look at the LDO reset and submit it as a seperate patch at
a later date.

 drivers/mfd/arizona-core.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 202bf55..ad1ca49 100644
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
+			goto err_ldoena;
+		}
 	}
 
 	ret = arizona_wait_for_boot(arizona);
-- 
1.7.2.5

