Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab1EIAdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 20:33:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:61813 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab1EIAds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 20:33:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,337,1301900400"; 
   d="scan'208";a="689907991"
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 16/19] mfd: Use mfd cell platform_data for tps6105x cells platform bits
Date: Mon,  9 May 2011 02:32:08 +0200
Message-Id: <1304901131-7104-17-git-send-email-sameo@linux.intel.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/tps6105x.c                 |    3 ++-
 drivers/regulator/tps6105x-regulator.c |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps6105x.c b/drivers/mfd/tps6105x.c
index 46d8205..a293b97 100644
--- a/drivers/mfd/tps6105x.c
+++ b/drivers/mfd/tps6105x.c
@@ -183,7 +183,8 @@ static int __devinit tps6105x_probe(struct i2c_client *client,
 	/* Set up and register the platform devices. */
 	for (i = 0; i < ARRAY_SIZE(tps6105x_cells); i++) {
 		/* One state holder for all drivers, this is simple */
-		tps6105x_cells[i].mfd_data = tps6105x;
+		tps6105x_cells[i].platform_data = tps6105x;
+		tps6105x_cells[i].pdata_size = sizeof(*tps6105x);
 	}
 
 	ret = mfd_add_devices(&client->dev, 0, tps6105x_cells,
diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index 1661499..4453a2a 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -137,7 +137,7 @@ static struct regulator_desc tps6105x_regulator_desc = {
  */
 static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 {
-	struct tps6105x *tps6105x = mfd_get_data(pdev);
+	struct tps6105x *tps6105x = pdev->dev.platform_data;
 	struct tps6105x_platform_data *pdata = tps6105x->pdata;
 	int ret;
 
@@ -164,7 +164,7 @@ static int __devinit tps6105x_regulator_probe(struct platform_device *pdev)
 
 static int __devexit tps6105x_regulator_remove(struct platform_device *pdev)
 {
-	struct tps6105x *tps6105x = platform_get_drvdata(pdev);
+	struct tps6105x *tps6105x = pdev->dev.platform_data;
 	regulator_unregister(tps6105x->regulator);
 	return 0;
 }
-- 
1.7.2.3

