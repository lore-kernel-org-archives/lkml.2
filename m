Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab1BCEDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:03:09 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48075 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCEDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:03:07 -0500
Date: Wed, 2 Feb 2011 20:03:02 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/19] ab3100: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202200302.0e05c3d0@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

In this case, move the ab3100_platform_data pointer from platform_data
to driver_data.  The only client who makes use of it is also changed.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/ab3100-core.c  |    6 ++----
 drivers/regulator/ab3100.c |    2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index 4193af5..244c2a2 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -949,10 +949,8 @@ static int __devinit ab3100_probe(struct i2c_client *client,
 		goto exit_no_ops;
 
 	/* Set up and register the platform devices. */
-	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++) {
-		ab3100_devs[i].platform_data = ab3100_plf_data;
-		ab3100_devs[i].data_size = sizeof(struct ab3100_platform_data);
-	}
+	for (i = 0; i < ARRAY_SIZE(ab3100_devs); i++)
+		ab3100_devs[i].driver_data = ab3100_plf_data;
 
 	err = mfd_add_devices(&client->dev, 0, ab3100_devs,
 		ARRAY_SIZE(ab3100_devs), NULL, 0);
diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index ed6feaf..1f266b9 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -576,7 +576,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 
 static int __devinit ab3100_regulators_probe(struct platform_device *pdev)
 {
-	struct ab3100_platform_data *plfdata = pdev->dev.platform_data;
+	struct ab3100_platform_data *plfdata = platform_get_drvdata(pdev);
 	int err = 0;
 	u8 data;
 	int i;
-- 
1.7.2.3

